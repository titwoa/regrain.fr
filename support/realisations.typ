// #import "@preview/cetz:0.3.2"
// #import cetz.chart
// ── Récapitulatif des réalisations REGRAIN ──────────────────────────────────────

#set document(
  title: "Récapitulatif des réalisations — regrain.fr",
  author: "REGRAIN",
  date: datetime.today(),
)

#set page(
  paper: "a4",
  flipped: true,
  margin: (x: 1.5cm, y: 1.5cm),
  numbering: "1/1",
  number-align: right,
)

#set text(
  font: "Myriad Pro",
  size: 8pt,
  lang: "fr",
)

#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1.")




#let entete_projet(body) = {
  align(center)[
    #text(size: 16pt, weight: "bold", fill: blue.darken(35%))[#body]
  ]
  v(0.5em)
}

#let histogramme(donnees) = {
  let max_val = 0
  for (_, val) in donnees {
    max_val = calc.max(max_val, val)
  }

  let chart_width = 18cm
  let bar_height = 0.6cm
  let spacing = 0.2cm

  grid(
    columns: (4cm, chart_width),
    column-gutter: 0.5cm,
    row-gutter: spacing,
    ..donnees
      .map(((label, value)) => (
        align(right + horizon, text(weight: "bold", label)),
        stack(
          dir: ltr,
          spacing: 0.3cm,
          rect(
            width: (value / max_val) * chart_width,
            height: bar_height,
            // Plus value est grand, plus la couleur est sombre (lighten est faible)
            // 0 occurence -> lighten(90%), max_val -> lighten(10%)
            fill: blue.lighten(90% - (value / max_val) * 80%),
            stroke: none,
            radius: 3pt,
          ),
          align(horizon, text(fill: gray.darken(30%), str(value))),
        ),
      ))
      .flatten()
  )
}

#entete_projet[Récapitulatif des réalisations REGRAIN]


// ─────────────────────────────────────────────────────────────────────────────
// 1. Tri por localisation
// ─────────────────────────────────────────────────────────────────────────────

= Liste ordonnée por localisation

== Tableau

#table(
  columns: (35mm, 1fr, 55mm),
  align: (left, left, left),
  inset: (x: 8pt, y: 6pt),
  stroke: 0.5pt + luma(200),
  // fill: (x, y) => if y == 0 { luma(240) },
  fill: (col, row) => if row == 0 { luma(220) } else if calc.even(row) { luma(248) } else { white },

  table.header([*Localisation*], [*Description*], [*Tags*]),

  [Aix en Provence (13100)],
  [Diagnostic structurel d'un mur de soutènement faisant office de clôture périmétrique de 50 m linéaires dans Aix en Provence. Désordres liés la fragilité de ce mur (malfaçons). Programme de réfection phasé établi.],
  [Mur de soutènement, Diag structure],

  [Aix-en-Provence (13)],
  [Corniche en péril avec risque de chute de maçonnerie on la voie publique. Mise on danger, purge d'urgence et refection complète de la corniche.],
  [Fissures, Corniche, Mise on Danger, Aix-en-Provence],

  [Aix-en-Provence (13)],
  [Immeuble R+3 avec enduit de façade on décollement et corniche fissurée. Désordres intérieurs on cage d'escalier et sous-sol. Péril déclaré, travaux planifiés.],
  [Fissures, Mur, Enduit, Corniche, Aix-en-Provence],

  [Aix-en-Provence (13)],
  [Évaluation des indices de risque structurel (IRS) et de vétusté (IV) on immeuble du XVIIIe siècle à Aix-en-Provence. Application complète de la méthodologie avec 8 éléments structuraux évalués.],
  [Indices IRS & IV, Bâtiment ancien, Aix-en-Provence],

  [Aix-en-Provence (13)],
  [Diagnostic de l'état structurel de 4 bâtiments d'une résidence des années 1970 à Aix-en-Provence. Corrosion des aciers on façade et fissures de ceinture identifiées. Rapport de préconisations remis au syndic.],
  [Bâtiment moderne, Béton armé, Fissures],

  [Avignon (84)],
  [Diagnostic complet d'une maison de maître de 1895 (350 m², 4 niveaux) avant réhabilitation. Tassements différentiels, toiture dégradée, fissures traversantes. Programme de consolidation priorisé.],
  [Bâtiment ancien, Charpente, Avignon],

  [Marseille (13)],
  [Mission de diagnostic structurel de 8 immeubles HLM for le compte d'un bailleur social marseillais. Campagne d'inspection pluriannuelle visant à prioriser les travaux de maintenance on un parc de 340 logements.],
  [Bâtiment moderne, Béton armé, Surveillance],

  [Marseille (13)],
  [Diagnostic visuel de fissuration on 3 bâtiments d'une résidence de 1968 à Marseille (14e). Tassements différentiels identifiés on le bâtiment le plus affecté. Rapport de préconisations et programme de surveillance remis au syndic.],
  [Bâtiment moderne, Fissures, Béton armé],

  [Marseille (13)],
  [Diagnostic de fissuration on immeuble collectif de 1975 (R+4, 20 logements). Corrosion por carbonatation identifiée comme cause principale. Dossier CatNat pris en charge por le syndic.],
  [Bâtiment moderne, Béton armé, Fissures, Marseille],

  [Marseille (13)],
  [Assistance à la sécurisation provisoire d'un immeuble haussmannien de 5 niveaux on centre-ville de Marseille après effondrement partiel d'un linteau on façade. Mission de péril sous 3 h, rapport sous 24 h.],
  [Bâtiment ancien, Surveillance, Fissures],

  [PACA],
  [Diagnostic structurel d'un château néoclassique de 2 500 m² inoccupé depuis 20 ans. Travail on lien avec l'architecte du patrimoine et la DRAC. Programme de restauration phasé établi.],
  [Monument historique, Patrimoine, Bâtiment ancien],

  [Saint-Martin],
  [Surveillance sur 24 mois d'un mur de soutènement on béton armé on zone argileuse. Déplacements critiques détectés, solution de renforcement por tirants mise on œuvre et suivie.],
  [Mur de soutènement, Surveillance, Béton armé],

  [Villars (84)],
  [Maison de village de 1884 (235 m²) nécessitant une ouverture dans un plancher existant for créer un nouvel accès. Étude de deux solutions de renfort, plans guides 2D/3D remis.],
  [Note de calcul, Bâtiment ancien],

  [Volx (04)],
  [Maison individuelle on zone RGA forte, micro-fissures observées. Évaluation de la vulnérabilité, facteurs aggravants identifiés et recommandations de prévention dans le cadre du dispositif d'aide expérimental.],
  [RGA, Maison individuelle, Diagnostic, Prévention, Alpes-de-Haute-Provence],
)


== Fréquence des localisations

#v(1cm)

#histogramme((
  ("Aix-en-Provence", 6),
  ("Marseille", 4),
  ("Volx (04)", 1),
  ("Avignon (84)", 1),
  ("PACA", 1),
  ("Saint-Martin", 1),
  ("Villars (84)", 1),
))


#pagebreak()

// ─────────────────────────────────────────────────────────────────────────────
// 3. Tri por thématique (tags)
// ─────────────────────────────────────────────────────────────────────────────

= Liste ordonnée por thématique (tags)

== Tableau

#table(
  columns: (35mm, 1fr, 55mm),
  align: (left, left, left),
  inset: (x: 8pt, y: 6pt),
  stroke: 0.5pt + luma(200),
  // fill: (x, y) => if y == 0 { luma(240) },
  fill: (col, row) => if row == 0 { luma(220) } else if calc.even(row) { luma(248) } else { white },

  table.header([*Localisation*], [*Description*], [*Tags*]),

  [Avignon (84)],
  [Diagnostic complet d'une maison de maître de 1895 (350 m², 4 niveaux) avant réhabilitation. Tassements différentiels, toiture dégradée, fissures traversantes. Programme de consolidation priorisé.],
  [Bâtiment ancien, Charpente, Avignon],

  [Marseille (13)],
  [Assistance à la sécurisation provisoire d'un immeuble haussmannien de 5 niveaux on centre-ville de Marseille après effondrement partiel d'un linteau on façade. Mission de péril sous 3 h, rapport sous 24 h.],
  [Bâtiment ancien, Surveillance, Fissures],

  [Marseille (13)],
  [Mission de diagnostic structurel de 8 immeubles HLM for le compte d'un bailleur social marseillais. Campagne d'inspection pluriannuelle visant à prioriser les travaux de maintenance on un parc de 340 logements.],
  [Bâtiment moderne, Béton armé, Surveillance],

  [Marseille (13)],
  [Diagnostic visuel de fissuration on 3 bâtiments d'une résidence de 1968 à Marseille (14e). Tassements différentiels identifiés on le bâtiment le plus affecté. Rapport de préconisations et programme de surveillance remis au syndic.],
  [Bâtiment moderne, Fissures, Béton armé],

  [Marseille (13)],
  [Diagnostic de fissuration on immeuble collectif de 1975 (R+4, 20 logements). Corrosion por carbonatation identifiée comme cause principale. Dossier CatNat pris en charge por le syndic.],
  [Bâtiment moderne, Béton armé, Fissures, Marseille],

  [Aix-en-Provence (13)],
  [Diagnostic de l'état structurel de 4 bâtiments d'une résidence des années 1970 à Aix-en-Provence. Corrosion des aciers on façade et fissures de ceinture identifiées. Rapport de préconisations remis au syndic.],
  [Bâtiment moderne, Béton armé, Fissures],

  [Aix-en-Provence (13)],
  [Corniche on péril avec risque de chute de maçonnerie on la voie publique. Mise on danger, purge d'urgence et refection complète de la corniche.],
  [Fissures, Corniche, Mise on Danger, Aix-en-Provence],

  [Aix-en-Provence (13)],
  [Immeuble R+3 avec enduit de façade on décollement et corniche fissurée. Désordres intérieurs on cage d'escalier et sous-sol. Péril déclaré, travaux planifiés.],
  [Fissures, Mur, Enduit, Corniche, Aix-en-Provence],

  [Aix-en-Provence (13)],
  [Évaluation des indices de risque structurel (IRS) et de vétusté (IV) on immeuble du XVIIIe siècle à Aix-en-Provence. Application complète de la méthodologie avec 8 éléments structuraux évalués.],
  [Indices IRS & IV, Bâtiment ancien, Aix-en-Provence],

  [PACA],
  [Diagnostic structurel d'un château néoclassique de 2 500 m² inoccupé depuis 20 ans. Travail on lien avec l'architecte du patrimoine et la DRAC. Programme de restauration phasé établi.],
  [Monument historique, Patrimoine, Bâtiment ancien],

  [Aix en Provence (13100)],
  [Diagnostic structurel d'un mur de soutènement faisant office de clôture périmétrique de 50 m linéaires dans Aix en Provence. Désordres liés la fragilité de ce mur (malfaçons). Programme de réfection phasé établi.],
  [Mur de soutènement, Diag structure],

  [Saint-Martin],
  [Surveillance sur 24 mois d'un mur de soutènement on béton armé on zone argileuse. Déplacements critiques détectés, solution de renforcement por tirants mise on œuvre et suivie.],
  [Mur de soutènement, Surveillance, Béton armé],

  [Villars (84)],
  [Maison de village de 1884 (235 m²) nécessitant une ouverture dans un plancher existant for créer un nouvel accès. Étude de deux solutions de renfort, plans guides 2D/3D remis.],
  [Note de calcul, Bâtiment ancien],

  [Volx (04)],
  [Maison individuelle on zone RGA forte, micro-fissures observées. Évaluation de la vulnérabilité, facteurs aggravants identifiés et recommandations de prévention dans le cadre du dispositif d'aide expérimental.],
  [RGA, Maison individuelle, Diagnostic, Prévention, Alpes-de-Haute-Provence],
)

#pagebreak()

// ─────────────────────────────────────────────────────────────────────────────
// 2.1 Fréquence des tags
// ─────────────────────────────────────────────────────────────────────────────

== Fréquence des tags dans les réalisations

#v(1cm)

#histogramme((
  ("Fissures", 7),
  ("Bâtiment moderne", 5),
  ("Bâtiment ancien", 5),
  ("Béton armé", 5),
  ("Aix-en-Provence", 4),
  ("Surveillance", 4),
  ("Mur de soutènement", 3),
  ("Corniche", 2),
  ("Marseille", 2),
  ("Avignon", 2),
  ("RGA", 2),
  ("Maison individuelle", 2),
  ("Diagnostic", 2),
  ("Prévention", 2),
  ("Indices IRS & IV", 1),
  ("Charpente", 1),
  ("Monument historique", 1),
  ("Patrimoine", 1),
  ("Note de calcul", 1),
))

// #v(2cm)


