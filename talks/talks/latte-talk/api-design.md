# API design process

Design a memloader using different abstractions. Try to mix the abstractions as needed.

## Summary of the problems that I faced while trying to write some code
- The boundary between different abstractions causes a big problem.
- In the memloader case study,
    - When instantiating the data queues in RTL level, the RTL level constructs propagates into the entire module which prevents the users from actually writing any higher level code. This seems to indicate that we want the abstraction boundaries to be module boundaries. This doesn't necessarily mean that the abstractions cannot be interleaved in a fine-grained manner. It may mean that there will be more submodules.
    - When trying to write the entire module in HLS, it seems much more straightforward. Kind of like writing imperative code. The problem is that dealing with the valid signals in the decoupled interfaces seems annoying.
- The biggest problem is the timing information. Whether or not the interface it latency insensitive or not, having to specify the signals that indicate some sort of timing behavior when trying to write normal code is annoying. And of course, once you start reasoning about timing information, you've already lost because it means that you are already very close to writing RTL.
    - So how do we strip out the signals that contain timing information (especially stuff related to ready, valid)??
    - HLS (normal code) | some magic layer | RTL
    - What should the "some magic layer" be doing???
    - If the interface is fully decoupled, I have a feeling that we can use concepts similar to LI-BDNs to integrate the HSL block into RTL. We can only run a function only when it has all its input arguments anyways.
    - What happens if we don't have a decoupled interface? Like the divider for example? I think there will be two cases.
        - The module has both decoupled & non-decoupled interfaces
            - When would we want this type of module?
        - The module has only non-decoupled interfaces. 
            - This doesn't really imply a lot of things.
            - It can imply that the module has a fixed latency.
            - However, it can also mean that the downstream module consuming the output cannot backpressure (even though this module has variable latency).
