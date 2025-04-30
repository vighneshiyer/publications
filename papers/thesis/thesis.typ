/*
https://grad.berkeley.edu/academic-progress/dissertation/#background

The proper organization and page order for your manuscript is as follows:

Title Page
Copyright page or a blank page
Abstract
Optional preliminary pages such as:
    Dedication page
    Table of contents
    List of figures, list of tables, list of symbols
    Preface or introduction
    Acknowledgments
    Curriculum Vitae
Main text
References
Bibliography
Appendices

Please do not include an approval/signature page.

Paper size must be letter. Font size 12pt or larger. Same font face and size should be used for the entire document. Footnotes/captions/figures use 8pt font or larger.

Page numbers must be in upper/lower right corner or bottom center and 3/4in from edges. Placement of page numbers must be consistent.
Title and copyright page should be unnumbered.
Abstract should be numbered from 1, 2, 3, ...
Preliminary pages should be numbered from i, ii, iii, iv, ...
The main body should be numbered from 1, 2, 3 (yes, start again from 1)

Margins must be 1 in for every page.
Single spacing.

The title and abstract page must be formatted exactly as they specify.
Title: https://grad.berkeley.edu/wp-content/uploads/title-page.pdf
Abstract: https://grad.berkeley.edu/wp-content/uploads/Abstract.pdf
*/

#set page(
  paper: "us-letter",
  margin: 1in
)

#set text(
  font: "libertinus serif",
  size: 12pt,
  lang: "en"
)

#let title = "A Rigorous Evaluation and Implementation of Sampled Microarchitecture Simulation"
#let author = "Vighnesh Mohan Iyer"

#import "ilm/lib.typ": ilm

#include("chapters/front_matter.typ") // Title page, copyright page, abstract

// Begin numbering of preliminary pages from i
#counter(page).update(1)
#set page(numbering: "i")

// Table of contents
#show: ilm.with(
  title: [#title],
  author: author,
  date: datetime(year: 2025, month: 05, day: 30),
  abstract: none,
  bibliography: bibliography("bib.yml"),
  figure-index: (enabled: false),
  table-index: (enabled: false),
  listing-index: (enabled: false),
  paper-size: "us-letter",
  display-cover-page: false,
  table-of-contents: outline(title: [Table of Contents #v(1em)], depth: 2)
)

// Preface
#include("chapters/preface.typ")
// Acknowledgements
#include("chapters/acks.typ")

// Begin main text, reset numbering to 1
#set page(numbering: "1")
#counter(page).update(1)

#include("chapters/intro.typ")
#include("chapters/background.typ")
#include("chapters/trace_analysis.typ")
#include("chapters/tidalsim_prototype.typ")
#include("chapters/benchmarks.typ")
#include("chapters/linux_sampling.typ")
#include("chapters/future_work.typ")
