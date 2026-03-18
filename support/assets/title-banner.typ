// title-banner.typ
// Bannière décorative avec icônes tableau-icons en arrière-plan clipé.
// Rendu entièrement en code Typst (pas de bloc markup [..] externe).
// Usage : #import "assets/title-banner.typ": title-banner

#let title-banner(
  title: none,
  subtitle: none,
  bg-content: none,
  bg-icons: none,
  icon-function: none,
  bg-color: gray.lighten(60%),
  bg-rotation: -10deg,
  bg-size: 1.5em,
  icon-size: 1cm,
  bg-repeat: (cols: 20, rows: 13),
  box-color: white,
  exterior-stroke: 2.5pt,
  interior-stroke: 1.5pt,
  accent-color: rgb("#2e6bba"),
  title-size: 2em,
  subtitle-size: 1em,
  radius: 10pt,
  height: 8cm,
  width: 100%,
  clip-inset: (x: 0mm, y: 0mm),
  v-space: (top: 0em, bottom: 0em),
) = {
  // Construit l'arrière-plan (icônes ou symboles)
  let bg = {
    if bg-icons != none and icon-function != none {
      let ec = int(calc.round(bg-repeat.cols * 1.5))
      let er = int(calc.round(bg-repeat.rows * 1.5))
      let ic = bg-icons.len()
      let rep = range(ec * er).map(i => bg-icons.at(calc.rem(i, ic)))
      rotate(bg-rotation, origin: center + horizon,
        grid(
          columns: ec, rows: er, gutter: 0pt,
          ..rep.map(n => icon-function(n, fill: bg-color, size: icon-size))
        )
      )
    } else if bg-content != none {
      let ec = int(calc.round(bg-repeat.cols * 1.5))
      let er = int(calc.round(bg-repeat.rows * 1.5))
      rotate(bg-rotation, origin: center + horizon,
        grid(
          columns: ec, rows: er, gutter: 0.3em,
          ..range(ec * er).map(_ =>
            text(size: bg-size, fill: bg-color, weight: "bold", bg-content)
          )
        )
      )
    }
  }

  // Boîte centrale avec titre (+ sous-titre optionnel)
  let title-box = box(
    stroke: accent-color + interior-stroke,
    fill: box-color,
    inset: 2em,
    radius: 1em,
    align(center + horizon,
      if subtitle != none {
        stack(dir: ttb, spacing: 1.5em,
          text(weight: "bold", title-size, font: "Impact", title),
          text(subtitle-size, fill: accent-color, font: "Myriad Pro", subtitle),
        )
      } else {
        text(weight: "bold", title-size, font: "Atkinson Hyperlegible", title)
      }
    )
  )

  // Bloc coupé avec arrière-plan + boîte titre superposée
  let clipped = block(
    clip: true,
    width: 100%,
    height: height,
    stroke: accent-color + exterior-stroke,
    radius: radius,
    {
      set align(center + horizon)
      set par(leading: 0pt)
      // Arrière-plan agrandi (300 %) pour couvrir après rotation
      place(center + horizon,
        pad(x: -clip-inset.x, y: -clip-inset.y,
          block(width: 300%, height: 300%, bg)
        )
      )
      // Titre centré par-dessus
      place(center + horizon, title-box)
    }
  )

  v(v-space.top)
  align(center,
    box(
      stroke: box-color + exterior-stroke,
      fill: box-color,
      inset: 0em,
      radius: (top: 2em, bottom: 2em),
      width: width,
      clipped,
    )
  )
  v(v-space.bottom)
}
