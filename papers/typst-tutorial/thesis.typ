#set math.equation(numbering: "1.")

#set page(
  paper: "us-letter",
  margin: (x: 2cm, y: 1.5cm),
)
#set text(
  font: "New Computer Modern",
  size: 10pt
)
#set par(
  justify: true,
  leading: 0.52em,
)

#set heading(numbering: "1.")

= Introduction
#lorem(10)

== Background
#lorem(12)

== Methods
#lorem(15)

= Introduction
In this report, we will explore the various factors that influence _fluid dynamics_ in glaciers and how they contribute to the formation and behaviour of these natural structures.

+ The climate
  - Temperature
  - Precipitation
+ The topography
+ The geology

The logo can be seen in @slice-logo.

#align(center + bottom)[
#figure(
  image("./figs/logos/slice_logo.png", width: 50%),
  caption: [
    The SLICE _logo_. Any text can go in this caption!
  ]
) <slice-logo>
]

= Methods
We follow the glacier melting models established in @fpinscala (trust me).

The equation $Q = rho A v + C$ defines the glacial flow rate.

$ Q = rho $

$ Q = rho A v + "time offset" $

We can see this in @equ-1.

$ 7.32 beta + sum_(i=0)^nabla ((Q_i (a_i - epsilon)) / 2) $<equ-1>

$ v := vec(x_1, x_2, x_3) $

$ a arrow.squiggly b $

// global setting of an option
#set par(justify: true)

#par(justify: true)[
  = Background
  In the case of glaciers, fluid dynamics principles can be used to understand how the movement and behaviour of the ice is influenced by factors such as temperature, pressure, and the presence of other fluids (such as water).
]

#bibliography("references.bib")
