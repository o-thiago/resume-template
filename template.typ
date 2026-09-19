#let resume(cv) = {
  // Document metadata
  set document(
    title: "CV " + cv.name,
    author: cv.name,
  )

  // Page layout matching LaTeX geometry: top=1.5cm, bottom=1.5cm, left=1.5cm, right=1.5cm
  set page(
    paper: "a4",
    margin: (x: 1.5cm, y: 1.5cm),
    header: none,
    footer: none,
  )

  // Typography settings matching LaTeX article/Computer Modern
  set text(
    font: ("New Computer Modern", "Libertinus Serif"),
    size: 10pt,
    lang: cv.at("lang", default: "en"),
  )
  set par(justify: true, leading: 0.55em)
  set list(indent: 0.25em, body-indent: 0.5em, spacing: 0.35em)

  // Clean links styling (black links)
  show link: set text(fill: black)

  // Section titles with horizontal rule
  show heading.where(level: 1): it => block(width: 100%, below: 0.6em, above: 1em)[
    #text(size: 1.25em, weight: "bold")[#it.body]
    #v(-0.35em)
    #line(length: 100%, stroke: 0.5pt + black)
  ]

  // CV entry macro: Title & Location on row 1, Role & Date on row 2
  let cventry(title, location, role, date) = block(width: 100%, below: 0.4em)[
    #grid(
      columns: (1fr, auto),
      column-gutter: 1em,
      row-gutter: 0.25em,
      align: (left, right),
      [*#title*], [#location],
      [#emph(role)], [#emph(date)]
    )
  ]

  // Header
  align(center)[
    #text(size: 1.6em, weight: "bold")[#cv.name] \
    #v(0.1cm)
    #cv.location
    #sym.bullet
    #cv.phone
    #sym.bullet
    #link("mailto:" + cv.email)[#cv.email]
    #sym.bullet
    #link(cv.linkedin)[#cv.linkedin.replace("https://", "")]
    #sym.bullet
    #link(cv.github)[#cv.github.replace("https://", "")]
  ]

  // Summary
  if "summary" in cv and cv.summary != "" [
    = #cv.summary_title
    #cv.summary
  ]

  // Experience
  if "experience" in cv and cv.experience.len() > 0 [
    = #cv.experience_title
    #for exp in cv.experience [
      #cventry(exp.company, exp.location, exp.role, exp.date)
      #if "bullets" in exp and exp.bullets.len() > 0 [
        #v(-0.2em)
        #for b in exp.bullets [
          - #b
        ]
        #v(0.25em)
      ]
    ]
  ]

  // Education
  if "education" in cv and cv.education.len() > 0 [
    = #cv.education_title
    #for edu in cv.education [
      #cventry(edu.institution, edu.location, edu.degree, edu.date)
      #v(0.25em)
    ]
  ]

  // Skills
  if "skills" in cv and cv.skills.len() > 0 [
    = #cv.skills_title
    #for s in cv.skills [
      - *#s.label:* #s.value
    ]
  ]

  // Certifications
  if "certifications" in cv and cv.certifications.len() > 0 [
    = #cv.certifications_title
    #for c in cv.certifications [
      - #c
    ]
  ]
}
