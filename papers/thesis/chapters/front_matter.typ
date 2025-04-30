#let title = "A Rigorous Evaluation and Implementation of Sampled Microarchitecture Simulation"
#let author = "Vighnesh Mohan Iyer"

#let spacing = 0.7em
#let big_spacing = 3em

// Title page (no page number)
#page([
  #align(center)[
    #block(width: 70%)[
      #title
      #v(spacing)
      By
      #v(spacing)
      #author
      #v(big_spacing)
      A dissertation submitted in partial satisfaction of the
      #v(spacing)
      requirements for the degree of
      #v(spacing)
      Doctor of Philosophy
      #v(spacing)
      in
      #v(spacing)
      Engineering --- Electrical Engineering and Computer Sciences
      #v(spacing)
      in the
      #v(spacing)
      Graduate Division
      #v(spacing)
      of the
      #v(spacing)
      University of California, Berkeley
      #v(big_spacing)
      Committee in charge:
      #v(spacing)
      #set par(spacing: 0.6em)
      Professor Borivoje Nikolic, Chair \
      Professor Sophia Shao \
      Professor Koushik Sen \
      Professor Rajeev Jain
      #v(big_spacing)
      Summer 2025
    ]
  ]
])

// Copyright page (no page number)
#page([
  #align(center)[
    #block(width: 100%)[
      #title
      #v(big_spacing)
      #set par(spacing: 0.6em)
      Copyright 2025 \
      by \
      #author
    ]
  ]
])

// Abstract (numbered from 1)
#counter(page).update(1)
#set page(numbering: "1")
#set page(
  footer: context {
    let page_num = counter(page).at(here()).first()
    let page_txt = text(size: 0.83em, numbering(page.numbering, page_num))
    align(right)[#page_txt]
  }
)

#page([
  #align(center)[
    Abstract
    #v(spacing)
    #title
    #v(spacing)
    by
    #v(spacing)
    #author
    #v(spacing)
    Doctor of Philosophy in Engineering --- Electrical Engineering and Computer Sciences
    #v(spacing)
    University of California, Berkeley
    #v(spacing)
    Professor Borivoje Nikolic, Chair
  ]
  #v(spacing + 1em)
  I will put an abstract here once I finish up.

  #lorem(200)
])
