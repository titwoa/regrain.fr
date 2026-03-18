// ── Relecture regrain.fr — 53 pages ──────────────────────────────────────────
#set page(
  paper: "a4",
  flipped: true,
  margin: (x: 1.5cm, y: 1.5cm),
  numbering: "1/1",
  number-align: right,
)

// Configuration texte
#set text(
  font: "Myriad Pro", //"Helvetica Neue", // "Atkinson Hyperlegible Next",
  size: 8pt,
  lang: "fr",
)

// format des dates
#let today = datetime.today().display("[day]/[month]/[year]")

// Configuration liens soulignés
#set underline(
  evade: true,
  extent: 0.5pt,
  stroke: (thickness: 0.5em, paint: yellow.lighten(60%), cap: "round"),
  background: true,
  offset: 0.75pt,
)

// Style personnalisé pour tous les liens (externes, internes, glossaire)
#show link: it => {
  // Get destination as string
  let dest_str = if type(it.dest) == label {
    str(it.dest)
  } else if type(it.dest) == str {
    it.dest
  } else {
    ""
  }

  // DEBUG: Uncomment to see what labels look like
  // [DEBUG: #dest_str]

  // Check if it's an external link
  let is_external = dest_str.starts-with("http://") or dest_str.starts-with("https://")

  // Check if it's a glossary link (glossarium package uses label format without <> wrapper)
  // The label is stored as plain string, so we check against known glossary terms
  let is_glossary = (
    dest_str in "porteur" or dest_str.contains("__glossary") or dest_str.starts-with("gls-")
  )

  // Apply different styles based on link type
  if is_glossary {
    text(style: "italic")[#it]
  } else if is_external {
    // ===== EXTERNAL LINK STYLE =====
    underline[#text(fill: blue)[#it]]
    box(baseline: -0.5em)[#text(size: 0.5em, fill: blue)[#sym.arrow.tr]]
  } else {
    // ===== INTERNAL LINK STYLE (cross-references, etc.) =====
    underline[#text(fill: blue)[#it]]
  }
}

#let page-counter = counter("active-pages")

// ── En-tête ───────────────────────────────────────────────────────────────────
#grid(
  columns: (1fr, auto),
  align: (left, right),
  [
    #text(size: 13pt, weight: "bold")[Relecture des pages — #link("https://www.regrain.fr")[regrain.fr]]
    #h(1.5em)
    #text(size: 8.5pt, fill: gray)[
      *a)* Sens général #h(0.8em)
      *b)* Aspect graphique #h(0.8em)
      *c)* Typographie française #h(0.8em)
      *d)* Particularités / à reporter dans d'autres pages
    ]
  ],
  context text(size: 7.5pt, fill: gray)[#page-counter.final().first() pages actives #sym.arrow.r #link("https://www.regrain.fr")[regrain.fr]],
)
#v(0.5em)

// // ── Alerte migration images ────────────────────────────────────────────────────
// #block(
//   fill: rgb("#fff3cd"),
//   stroke: (left: 3pt + rgb("#e6a817")),
//   inset: (x: 8pt, y: 5pt),
//   radius: 2pt,
//   width: 100%,
// )[
//   #text(weight: "bold", size: 7.5pt)[⚠ Migration images en cours —]
//   #text(
//     size: 7pt,
//   )[ toutes les images ont été déplacées de `public/images/` vers `src/assets/images/`. Les pages dont le frontmatter ou le contenu MDX référencent encore `/images/...` ont des images cassées (colonne *b*) — voir `support/CLAUDE.md` pour la procédure de correction.]
// ]
// #v(0.4em)

// ── Helpers ───────────────────────────────────────────────────────────────────
#let shead(title, n, color) = table.cell(
  colspan: 7,
  fill: color,
  align: left,
  inset: (x: 6pt, y: 3.5pt),
)[#text(weight: "bold", size: 7.5pt)[#title] #h(1fr) #text(fill: gray, size: 7pt)[#n pages]]

#let cb = align(center + horizon)[#box(width: 3mm, height: 3mm, stroke: 0.5pt + black)[]]
#let cbv = align(center + horizon)[#box(width: 3mm, height: 3mm, stroke: 0.5pt + black, inset: 0.3mm)[#align(
  center + horizon,
)[#text(size: 7pt)[✓]]]]
#let cbx = align(center + horizon)[#box(width: 3mm, height: 3mm, fill: luma(220), stroke: 0.5pt + luma(160), inset: 0.3mm)[#align(
  center + horizon,
)[#text(size: 7pt, fill: luma(120))[✕]]]]

#let ext-color(e) = if e == ".mdx" { rgb("#d4edda") } else if e == ".md" { rgb("#d1ecf1") } else { luma(235) }

#let r(n, url, ext, note: [], a: false, b: false, c: false, del: false) = (
  [#if not del { page-counter.step() }#align(right + horizon)[#text(fill: luma(180), size: 7pt)[#n]]],
  align(horizon)[#text(font: "Courier New", size: 7pt)[#url]],
  table.cell(fill: ext-color(ext), align: center + horizon)[#text(font: "Courier New", size: 6.5pt)[#ext]],
  if del { cbx } else if a { cbv } else { cb },
  if del { cbx } else if b { cbv } else { cb },
  if del { cbx } else if c { cbv } else { cb },
  note,
)

// ── Tableau ───────────────────────────────────────────────────────────────────
#table(
  columns: (6mm, 90mm, 14mm, 11mm, 11mm, 11mm, 1fr),
  align: (right, left, center, center, center, center, left),
  inset: (x: 5pt, y: 2.5pt),
  stroke: 0.35pt + luma(200),

  // En-tête
  table.header(
    table.cell(fill: luma(40))[#text(fill: white, size: 7pt)[N°]],
    table.cell(fill: luma(40))[#text(fill: white, weight: "bold")[Page / URL]],
    table.cell(fill: luma(40), align: center)[#text(fill: white, weight: "bold")[ext.]],
    table.cell(fill: luma(40), align: center)[#text(fill: white, weight: "bold")[a)\ ]],
    table.cell(fill: luma(40), align: center)[#text(fill: white, weight: "bold")[b)\ ]],
    table.cell(fill: luma(40), align: center)[#text(fill: white, weight: "bold")[c)\ ]],
    table.cell(fill: luma(40))[#text(fill: white, weight: "bold")[d) Particularités]],
  ),

  // ── Pages générales (9) ───────────────────────────────────────────────────
  shead("Pages générales", 9, luma(230)),
  ..r(1, "/", ".astro", a: true, b: true, c: true, note: [OK le 14/03/2026, màj le 17/03/2026]),
  ..r(2, "/404", ".astro", a: true, b: true, c: true, note: [vu le 03/03/2026]),
  ..r(3, "/a-propos/entreprise", ".astro", a: true, b: true, c: true, note: [vu le 03/03/2026]),
  ..r(4, "/a-propos/equipe", ".astro", a: true, b: true, c: true, note: [vu le 03/03/2026]),
  ..r(5, "/carte", ".astro", a: true, b: true, c: true, note: [ajout d'un lien pointant vers /realisations, vu le 14/03/2026]),
  ..r(6, "/confidentialite", ".astro", a: true, b: true, c: true, note: [supprimé : cession données à des tiers, vu le 13/03/2026]),
  ..r(7, "/contact", ".astro", a: true, b: true, c: true, note: [vu le 03/03/2026]),
  ..r(8, "/mentions-legales", ".astro", a: true, b: true, c: true, note: [supprimé : RCS+Capital social, vu le 13/03/2026]),
  ..r(9, "/merci", ".astro", a: true, b: true, c: true, note: [OK, vu le 14/03/2026]),

  // ── Blog (8) ─────────────────────────────────────────────────────────────
  shead("Blog", 8, rgb("#ddeeff")),
  ..r(10, "/infos", ".astro", a: true, b: true, c: true, note: [OK, vu le 18/03/2026]),
  ..r(11, "/infos/blog", ".astro", a: true, b: true, c: true, note: [OK, vu le 18/03/2026]),
  ..r(12, "/infos/blog/creation-website-regrain", ".md", a: true, b: true, c: true, note: [OK, vu le 18/03/2026]),
  ..r(13, "/infos/blog/sinistres-pluies-hiver-2026", "—", del: true, note: [_supprimé_ le 18/03/2026]),
  ..r(14, "/infos/blog/sinistres-structurels-jan-fev-2026", "—", del: true, note: [_supprimé_ le 18/03/2026]),
  ..r(15, "/infos/blog/reglementation-rga-2026", ".md", a: true, b: true, c: true, note: [OK, vu le 18/03/2026]),
  ..r(16, "/infos/blog/reglementation-rga-2025", "—", del: true, note: [_supprimé_ le 18/03/2026]),
  ..r(17, "/infos/blog/veille-batiment-fevrier-2026", ".md", a: true, b: true, c: true, note: [OK, vu le 18/03/2026]),

  // ── Ressources (11) ──────────────────────────────────────────────────────
  shead("Ressources", 11, rgb("#ddf2dd")),
  ..r(18, "/infos/ressources", ".astro", a: true, b: true, c: true, note: [OK, vu le 17/03/2026]),
  ..r(19, "/infos/ressources/diagnostic-batiments-anciens", "—", del: true, note: [_supprimé_ le 18/03/2026]),
  ..r(20, "/infos/ressources/methode-evaluation-irs-iv", ".mdx", a: true, b: true, c: true, note: [OK le 17/03/2026]),
  ..r(21, "/infos/ressources/methodes-diagnostic-beton", "—", del: true, note: [_supprimé_ le 18/03/2026]),
  ..r(22, "/infos/ressources/diagnostic-structurel-obligatoire", ".mdx", a: true, b: true, c: true, note: [OK, vu le 18/03/2026]),
  ..r(23, "/infos/ressources/pathologies-beton", ".mdx", a: true, b: true, c: true, note: [OK, vu le 18/03/2026]),
  ..r(24, "/infos/ressources/quand-faire-diagnostic", "—", del: true, note: [_supprimé_ le 18/03/2026]),
  ..r(25, "/infos/ressources/methodes-diagnostic-structure", ".mdx", a: true, b: true, c: true, note: [OK le 18/03/2026]),
  ..r(26, "/infos/ressources/retrait-gonflement-argiles", ".mdx", a: true, b: true, c: true, note: [OK le 17/03/2026]),
  ..r(27, "/infos/ressources/signes-alerte-batiment", "—", del: true, note: [_supprimé_ le 18/03/2026]),
  ..r(28, "/infos/ressources/cout-reconstruction-m2-batiment-ancien", ".md", a: true, b: true, c: true, note: [OK le 17/03/2026]),

  // ── Réalisations (15) ────────────────────────────────────────────────────
  shead("Réalisations", 15, rgb("#fff3dd")),
  ..r(29, "/realisations", ".astro", a: true, b: true, c: true, note: [OK le 14/03/2026]),
  ..r(30, "/realisations/5rue-roux-alpheran", ".mdx", a: true, b: true, c: true, note: [texte +image + galerie, vu le 13/03/2026]),
  ..r(31, "/realisations/9rue-de-la-treille", ".mdx", a: true, b: true, c: true, note: [texte + image + galerie, vu le 13/03/2026]),
  ..r(32, "/realisations/diag-rga-volx", ".mdx", a: true, b: true, c: true, note: [texte + image + galerie, vu le 13/03/2026]),
  ..r(33, "/realisations/diagnostic-hlm-bailleur-marseille", "—", del: true, note: [_supprimé_ le 13/03/2026]),
  ..r(34, "/realisations/diag-visuel-fissures-marseille-nord", ".mdx", a: true, b: true, c: true, note: [texte +image + galerie, vu le 13/03/2026]),
  ..r(35, "/realisations/evaluation-irs-immeuble-exemple", ".mdx", a: true, b: true, c: true, note: [texte +image + galerie, vu le 13/03/2026]),
  ..r(36, "/realisations/immeuble-marseille", "—", del: true, note: [_supprimé_ le 13/03/2026]),
  ..r(37, "/realisations/maison-avignon", "—", del: true, note: [_supprimé_ le 13/03/2026]),
  ..r(38, "/realisations/monument-historique", "—", del: true, note: [_supprimé_ le 13/03/2026]),
  ..r(39, "/realisations/mur-soutenement", "—", del: true, note: [_supprimé_ le 13/03/2026]),
  ..r(40, "/realisations/mur-soutenement-cloture-aix", ".mdx", a: true, b: true, c: true, note: [OK le 17/03/2026]),
  ..r(41, "/realisations/plan-renfort-plancher", ".mdx", a: true, b: true, c: true, note: [texte + image + galerie, vu le 13/03/2026]),
  ..r(42, "/realisations/residence-zodiaque-aix", "—", del: true, note: [_supprimé_ le 13/03/2026]),
  ..r(43, "/realisations/securisation-urgence-immeuble-marseille", "—", del: true, note: [_supprimé_ le 13/03/2026]),

  // ── Services (10) ────────────────────────────────────────────────────────
  shead("Services", 10, rgb("#eeeeff")),
  ..r(44, "/services", ".astro", a: true, b: true, c: true, note: [OK le 14/03/2026]),
  ..r(45, "/services/batiments-anciens", ".astro", a: true, b: true, c: true, note: [Guillemets corrigés : «\u202Ftemps\u202F», «\u202Fdur\u202F», «\u202Fsouple\u202F», «\u202Fbâtards\u202F», texte OK le 14/03/2026]),
  ..r(46, "/services/batiments-modernes", ".astro", a: true, b: true, c: true, note: [OK le 14/03/2026]),
  ..r(47, "/services/diagnostic-rga", ".astro", a: true, b: true, c: true, note: [OK le 17/03/2026]),
  ..r(48, "/services/diagnostic-structure", "—", del: true, note: [_supprimé_ le 17/03/2026]),
  ..r(49, "/services/evaluation-irs-iv", ".astro", a: true, b: true, c: true, note: [OK le 17/03/2026]),
  ..r(50, "/services/notes-calcul-renforcement", ".astro", a: true, b: true, c: true, note: [OK le 17/03/2026]),
  ..r(51, "/services/precos-plans", ".astro", a: true, b: true, c: true, note: [OK le 17/03/2026]),
  ..r(52, "/services/rapports-expertise",  "—", del: true, note: [_supprimé_ le 17/03/2026]),
  ..r(53, "/services/suivi-fissures-pathologies", ".astro", a: true, b: true, c: true, note: [OK le 17/03/2026]),
)
