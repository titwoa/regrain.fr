// ─── Codly (blocs de code colorés) ───────────────────────────────────────
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
// codly
#show: codly-init.with()
// #codly(
//   number-format: none,
//   languages: (
//     rust: (name: "Rust", icon: "🦀", color: rgb("#CE412B")),
//     python: (name: "Python", icon: "🐍", color: rgb("#3776ab")),
//     bash: (name: "Bash", icon: "💻", color: rgb("#4EAA25")),
//   )
// )
#codly(languages: codly-languages) // plus simple : pas de config perso pour chaque langage !


// ─── Configuration document ───────────────────────────────────────────────
#set document(
  title:  "Mini serveur web local puis exposé sur Internet",
  author: "Olivier Turlier",
  date:   datetime.today(),
)

#set page(
  paper:  "a4",
  margin: (left: 22mm, right: 20mm, top: 30mm, bottom: 30mm),
  numbering: "1/1",
  number-align: right,
)

// ─── Typographie ──────────────────────────────────────────────────────────
// list all fonts available by Typst : `typst fonts`
#set text(font: "Atkinson Hyperlegible Next", size: 11pt, lang: "fr")
#set par(justify: true, leading: 0.65em)


// fonts for headings only
// #show heading: set text(font: "Impact") // for all titles

#show heading.where(level: 1): it => text(
  font: "Raleway",
  size: 18pt,
  weight: 1200,
  style: "normal",
  it
)

#show heading.where(level: 2): it => text(
  font: "Raleway",
  size: 14pt,
  weight: 900,
  style: "normal",
  it
)


#show heading.where(level: 3): it => text(
  font: "Raleway",
  size: 12pt,
  weight: 800,
  style: "italic",
  it
)

// Numbering
#set heading(numbering: "1.1.a")

// Switch to Fira Code for both
// inline and block raw.
#show raw: set text(font: "Fira code")



#show title: set text(size: 18pt)
#show title: set align(center)
#title[Mini serveur web local puis exposé sur Internet]
#v(1em)
#let hrule = align(center, for i in range(10) [\* #h(1em)]) // align(center, box(width: 50%, repeat[\* #h(1em)])) // align(center, line(length: 60%))
#hrule
#v(1em)


// =======================================================

= Objectif

+ Analyser le "build" du siteweb Astro, localement
+ Exposer temporairement ce "localhost" sur internet à des fins de démo-correction par un tiers

== Étapes

=== Build du website 

Pages web "statiques" dans le dossier docs/ (config pour être servi par _Github_ en y assiciant le nom de domaine "regrain.fr" au travers d'un document "CNAME") : 

// #codly-disable()
#codly(number-format: none) // zebra-fill: none, 
                            
#block(width: 70%)[
```javascript
npm run build
```
]

=== Serveur "local"

+ *Option 1* : "simple" HTTP server with Python :

#block(width: 70%)[
  ```python
  python -m http.server 8080 --directory docs
  ```
  ]

+ *Option 2 (préferée)* : npx serve (répertoire docs/ sur port 3000)

#block(width: 70%)[
  ```javascript
  npx serve docs/
  ```
  ]
  #v(0.5em)
Le serveur démarre sur le port *3000* et affiche :

#block(width: 70%)[
  #codly(zebra-fill: none) // 
```
   ┌──────────────────────────────────────────┐
   │                                          │
   │   Serving!                               │
   │                                          │
   │   - Local:    http://localhost:3000      │
   │   - Network:  http://192.168.56.1:3000   │
   │                                          │
   │   Copied local address to clipboard!     │
   │                                          │
   └──────────────────────────────────────────┘
```
]

=== Exposer le localhost sur internet

Utiliser #link("https://tunnl.gg")[tunnl.gg] : service de tunnel SSH, sans installation, gratuit.

#block(width: 70%)[
```bash
ssh -t -R 80:localhost:3000 proxy.tunnl.gg
```
]

=== Notes

- Aucune installation requise (sauf SSH à installer sur Windows 11 \ avec "`winget install Microsoft.OpenSSH.Preview`")
- L'URL change à chaque nouvelle connexion
- Le tunnel se ferme automatiquement à la déconnexion SSH

= Synthèse des commandes
#v(2em)

+ *Build + lancer le serveur local* (dans un terminal) :

  #block(width: 70%)[
  ```javascript
  npm run build && npx serve docs/
  ```
]
+ *Ouvrir le tunnel* (dans un second terminal) :

  #block(width: 70%)[
  ```bash
  ssh -t -R 80:localhost:3000 proxy.tunnl.gg
  ```
  ]

  #v(0.5em)
  tunnl.gg affiche une URL publique (ex. `https://xxxx.tunnl.gg`) à partager avec le client.

+ *Fermer le tunnel* : `Ctrl+C` dans le terminal SSH.

