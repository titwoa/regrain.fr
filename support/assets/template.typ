// assets/template.typ — Template Notes techniques Re·grain
// Miroir de contacts-pro.typ : même en-têtes, pieds de page, styles de titres,
// bannière tabler-icons en page de titre.
//
// Usage dans le fichier principal :
//   #import "assets/template.typ": *
//   #show: doc => template(titre: "...", sous-titre: "...", doc)

#import "@preview/tableau-icons:0.334.1": ti-icon
#import "title-banner.typ": title-banner
#import "icon-list.typ": icon-list

// ─── Codly (blocs de code colorés) ───────────────────────────────────────
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages)

// ── Couleurs (identiques à contacts-pro.typ) ──────────────────────────────
#let couleur-titre1 = rgb("#0180ff")   // bleu  — h1
#let couleur-titre2 = rgb("#860000")   // rouge — h2
#let couleur-titre3 = rgb("#1caa00")   // vert  — h3
#let couleur-gris   = rgb("#959595")

// ── Boîtes ────────────────────────────────────────────────────────────────
#let note(body, fill: rgb("#fff7d2"), stroke: 1pt + rgb("#fcbd01")) = block(
  fill: fill, stroke: stroke,
  inset: 9pt, radius: 3pt, width: 100%,
  text(size: 9pt, body))

#let warn(body) = block(
  fill: rgb("#fdecea"), stroke: 1pt + rgb("#e74c3c"),
  inset: 9pt, radius: 3pt, width: 100%,
  text(size: 9pt, body))

#let tip(body) = block(
  fill: rgb("#d5f5e3"), stroke: 1pt + rgb("#27ae60"),
  inset: 9pt, radius: 3pt, width: 100%,
  text(size: 9pt, body))

// State : passe à true au début du corps (déclenche header/footer)
#let _apres-titre = state("apres-titre", false)
#let _in-corps    = state("in-corps", false)

// ── Gabarit principal ─────────────────────────────────────────────────────
#let template(
  titre:               "Génération de scripts CADIMP par IA : méthode RAG",
  sous-titre:          "",
  societe:             "BET Regrain",
  auteur:              "OLT",
  version:             "0.1",
  version-date:        "",
  version-description: "",
  mots-cles:           (),
  doc-description:     "",
  logo:                "images/logo_OTH.png",
  tdm-profondeur:      none,
  tdm-image:           none,
  texte-entete:        "",
  body,
) = {

  set document(
    title:       titre,
    author:      auteur,
    keywords:    mots-cles,
    description: doc-description,
  )

  // ── Mise en page ─────────────────────────────────────────────────────
  set page(
    paper: "a4",
    margin: (inside: 28mm, outside: 20mm, top: 28mm, bottom: 22mm),
    numbering: "1 / 1",
    number-align: right,

    header: context {
      if _apres-titre.at(here()) [
        #set text(9pt, font: "Atkinson Hyperlegible", fill: couleur-gris)
        #grid(
          columns: (auto, 1fr),
          align: (left + horizon, right + horizon),
          box(baseline: 10pt)[
            #image(logo, height: 1cm)
            #v(-1em)
            #h(4pt)
            #text(8pt, style: "italic")[#societe]
          ],
          [#texte-entete],
        )
        #line(length: 100%, stroke: 0.25pt + couleur-gris)
      ]
    },

    footer: context {
      let p     = counter(page).get().first()
      let total = counter(page).final().first()
      // here().page() = numéro physique (jamais remis à zéro) → détermine gauche/droite
      // même si counter(page) a été remis à 1 pour l'affichage
      let phys  = here().page()
      if _in-corps.at(here()) [
        #set text(9pt, font: "Atkinson Hyperlegible", fill: couleur-gris)
        #line(length: 100%, stroke: 0.25pt + couleur-gris)
        #v(0pt)
        // En affichage PDF double-page, les pages impaires sont à GAUCHE
        // → intérieur des impaires = DROITE, intérieur des paires = GAUCHE
        #if calc.odd(p) [
          // Page gauche (impaire en PDF viewer) : numéro à droite (intérieur)
          #grid(columns: (1fr, 1fr),
            align(left)[
              #text(weight: "bold")[#titre] \
              #text(style: "italic")[
                Version #version | #version-date#if version-description != "" [ | #version-description]
              ]
            ],
            align(right)[#p / #total],
          )
        ] else [
          // Page droite (paire en PDF viewer) : numéro à gauche (intérieur)
          #grid(columns: (1fr, 1fr),
            align(left)[#p / #total],
            align(right)[#text(weight: "light")[#sous-titre]],
          )
        ]
      ]
    },
  )

  // ── Texte ─────────────────────────────────────────────────────────────
  set text(font: "Atkinson Hyperlegible", size: 10pt, lang: "fr")
  set par(justify: true, leading: 0.65em)

  // ── Titres numérotés, numéro dans la marge gauche ─────────────────────
  // Le titre de la TDM (outline) est exclu du numérotage
  show outline: set heading(numbering: none)

  set heading(numbering: "1.1.")

  show heading.where(level: 1): it => {
    set text(15pt, fill: couleur-titre1, weight: "bold")
    v(1em)
    block(breakable: false)[
      #context [
        #if it.numbering != none {
          place(left, dx: -22mm,
            box(width: 19mm, align(right,
              text(15pt, fill: couleur-titre1, weight: "bold")[#counter(heading).display()]
            ))
          )
        }
        #grid(columns: (auto, 1fr), column-gutter: 0.5em, align: horizon,
          it.body,
          line(length: 100%, stroke: 1.5pt + couleur-titre1),
        )
      ]
      #v(0.5em)
    ]
  }

  show heading.where(level: 2): it => {
    set text(12pt, fill: couleur-titre2, weight: "bold")
    v(0.8em)
    block(breakable: false)[
      #context [
        #if it.numbering != none {
          place(left, dx: -22mm,
            box(width: 19mm, align(right,
              text(12pt, fill: couleur-titre2, weight: "bold")[#counter(heading).display()]
            ))
          )
        }
        #it.body
      ]
      #v(0.2em)
    ]
  }

  show heading.where(level: 3): it => {
    set text(11pt, fill: couleur-titre3, weight: "bold")
    v(0.6em)
    block(breakable: false)[
      #context [
        #if it.numbering != none {
          place(left, dx: -22mm,
            box(width: 19mm, align(right,
              text(11pt, fill: couleur-titre3, weight: "bold")[#counter(heading).display()]
            ))
          )
        }
        #it.body
      ]
      #v(0.1em)
    ]
  }

  // ── Couleurs table des matières ───────────────────────────────────────
  show outline.entry.where(level: 1): it => {
    set text(fill: couleur-titre1, weight: "bold"); it
  }
  show outline.entry.where(level: 2): it => {
    set text(fill: couleur-titre2); it
  }
  show outline.entry.where(level: 3): it => {
    set text(fill: couleur-titre3); it
  }

  // ── Liens ─────────────────────────────────────────────────────────────
  show link: it => { set text(fill: couleur-titre1); underline(it) }

  // ══════════════════════════════════════════════════════════════════════
  // PAGE DE TITRE
  // ══════════════════════════════════════════════════════════════════════
  title-banner(
    title:         titre,
    subtitle:      if sous-titre != "" { sous-titre } else { none },
    bg-icons:      icon-list,
    icon-function: ti-icon,
    bg-color:      couleur-titre1.lighten(75%),
    accent-color:  couleur-titre1,
    bg-rotation:   -15deg,
    icon-size:     1cm,
    bg-repeat:     (cols: 35, rows: 15),
    height:        8cm,
    clip-inset:    (x: -3mm, y: -3mm),
    title-size:    3em,
    subtitle-size: 1.5em,
    v-space:       (top: -10mm, bottom: 1em),
  )

  align(center)[
    #text(size: 9pt, fill: couleur-gris)[
      Version #version | #version-date#if version-description != "" [ | #version-description]
    ]
  ]
  v(0.8em)

  // Header actif dès la TDM
  _apres-titre.update(true)
  // Page 1 = page immédiatement après le titre
  counter(page).update(1)

  // ── Table des matières ────────────────────────────────────────────────
  if tdm-image != none {
    align(center)[#tdm-image]
    v(1em)
  }
  outline(title: "Table des matières", indent: auto, depth: tdm-profondeur)
  pagebreak()
  _in-corps.update(true)
  body
}
