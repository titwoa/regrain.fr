---
title: "Estimer le coût de reconstruction au m² d'un bâtiment ancien"
description: "Méthode en trois niveaux pour établir la valeur unitaire de reconstruction utilisée dans l'indice IV : indice BT01 INSEE (borne théorique), transactions DVF locales et prix expert. Outils R, Excel et données open data."
publishDate: 2025-11-22
category: "Méthodologie"
tags: ["IV", "Vétusté", "Coût de reconstruction", "BT01", "DVF", "Analyse économique", "R"]
image:
  src: "~/assets/images/services/evaluation.webp"
  alt: "Estimation coût reconstruction bâtiment ancien"
---

## Pourquoi estimer le coût de reconstruction ?

Dans la méthode IV (Indice de Vétusté), la valeur résiduelle d'un bâtiment est calculée par :

**V\_résiduelle = V\_reconstruction × (1 − IV / 100)**

Le coût de reconstruction **V\_reconstruction** est donc le point de départ de toute l'analyse économique. Il s'agit du coût théorique de reconstruction *à l'identique* du bâtiment, aux prix courants de la main d'œuvre et des matériaux, hors terrain.

Pour un immeuble du XVIIIe siècle en centre historique d'Aix-en-Provence (320 m²), nous avons retenu **3 850 €/m²**, soit un coût de reconstruction total de **1 232 000 €**. Cette valeur résulte d'un croisement de trois référentiels, du plus théorique au plus ancré dans le marché local.

---

## Niveau 1 — Indice BT01 (borne inférieure théorique)

L'**indice BT01** publié par l'INSEE mesure l'évolution du coût de construction pour les bâtiments résidentiels collectifs *neufs et standards* (base 100 = janvier 2010).

| Paramètre | Valeur | Source |
|-----------|-------:|--------|
| Coût résidentiel collectif — base jan. 2010 | 1 550 €/m² | UNTEC / Batichiffre |
| Indice BT01 — jan. 2024 | 130 | INSEE (publié mensuellement) |
| **Coût standard 2024** | **2 015 €/m²** | = 1 550 × 130/100 |

> **⚠ Avertissement — BT01 : référence neuf standard uniquement**
>
> Le BT01 mesure le coût d'un bâtiment *résidentiel collectif neuf, standard, hors contrainte*. Pour un immeuble en centre historique ou médiéval, le coût réel de reconstruction est typiquement **2 à 4 fois supérieur** au coût BT01, en raison de :
> - techniques constructives non industrialisables (taille de pierre, voûtes, enduits à la chaux) ;
> - prescriptions ABF imposant matériaux et finitions spécifiques ;
> - accessibilité limitée : échafaudages en site étroit, absence de zone de stockage ;
> - reproduction à l'identique d'éléments architecturaux (ferronneries, menuiseries XVIIIe...).
>
> **Le BT01 est utilisé comme borne inférieure et point de départ, pas comme valeur cible.**

**Rapport pour l'immeuble de l'exemple : 3 850 / 2 015 ≈ × 1,91 le BT01** — cohérent avec les surcoûts attendus en site contraint.

---

## Niveau 2 — Transactions de marché DVF (données open data)

Les **Demandes de Valeurs Foncières (DVF)** sont publiées en open data par la DGFiP / Etalab et recensent toutes les transactions immobilières notariées en France. Elles constituent une source de référence de prix de marché local objectifs et récents.

Pour l'immeuble de l'exemple (Aix-en-Provence, centre historique), les transactions ont été extraites dans un rayon de **1 000 m** autour du bâtiment (appartements et maisons, surfaces 20–300 m², années 2022–2025) :

| Indicateur | Prix (€/m²) |
|-----------|------------:|
| Minimum | 535 |
| Q1 — 25 % | 4 768 |
| **Médiane** | **5 835** |
| Moyenne | 6 733 |
| Q3 — 75 % | 7 381 |
| Maximum | 24 848 |

*2 276 transactions retenues après filtrage géographique (source : Etalab / DGFiP).*

> **Note d'interprétation**
>
> Les prix DVF sont des **prix de vente de marché** (incluant la localisation, la rareté, la prime de centre historique), non des coûts de reconstruction pure. Pour un bâtiment ancien en bon état dans ce secteur, le marché valorise à 5 000–7 000 €/m², soit bien au-dessus du coût BT01. La médiane DVF constitue ici une **borne supérieure indicative** : le coût de reconstruction doit rester inférieur à la valeur de marché pour que la réhabilitation soit économiquement rationnelle.

---

## Niveau 3 — Prix « expert » (expérience locale)

Le prix expert est une **estimation basée sur l'expérience terrain** : devis d'entreprises générales ayant travaillé sur des bâtiments similaires dans le même secteur géographique, publications d'économistes de la construction, ou données internes de chantiers comparables.

Pour un immeuble XVIIIe siècle à Aix-en-Provence, en site contraint avec prescriptions ABF, les retours d'expérience convergent vers **3 500 – 4 200 €/m²**, selon la qualité des finitions à reproduire et la complexité structurale.

Valeur retenue : **3 850 €/m²** — au centre de la fourchette experte, cohérent avec le BT01 actualisé (× 1,91) et nettement inférieur à la médiane DVF (3 850 vs 5 835), ce qui confirme que la réhabilitation reste économiquement justifiée.

---

## Synthèse des trois référentiels

| Référence | Prix (€/m²) | Nature |
|-----------|------------:|--------|
| BT01 — neuf standard (borne théorique ⚠) | 2 015 | Indice INSEE — neuf standard, hors contrainte |
| Prix médian marché DVF | 5 835 | Transactions réelles 2022–2025, rayon 1 000 m |
| **Prix reconstruction expert** | **3 850** | Expérience locale — valeur retenue |
| **Rapport expert / BT01** | **× 1,91** | Cohérent avec les surcoûts bâtiment ancien |

---

## Outils utilisés

### Données DVF — téléchargement et traitement en R

Les données DVF sont téléchargées automatiquement via l'API open data Etalab, filtrées géographiquement par calcul de distance (Haversine), puis exportées en CSV pour intégration dans le rapport.

```r
# Téléchargement DVF via API Etalab (exemple simplifié)
library(httr2)
library(dplyr)

# Coordonnées du bâtiment
lat_bat <- 43.5283
lon_bat <- 5.4464
rayon_m <- 1000

url <- paste0(
  "https://api.data.gouv.fr/api/1/datasets/5c4ae55a634f4117716d5656/",
  "resources/?page_size=100"
)

# Après récupération : calcul distance Haversine et filtrage
dvf_local <- dvf_raw |>
  mutate(
    dist_m = 6371000 * acos(
      sin(lat * pi/180) * sin(lat_bat * pi/180) +
      cos(lat * pi/180) * cos(lat_bat * pi/180) *
      cos((lon - lon_bat) * pi/180)
    )
  ) |>
  filter(dist_m <= rayon_m, surface_reelle_bati >= 20, surface_reelle_bati <= 300)

# Export pour intégration rapport
write.csv(dvf_local, "comparables_marche.csv", row.names = FALSE)
```

### Indice BT01 — mise à jour mensuelle

L'indice BT01 est publié mensuellement par l'INSEE sur [insee.fr](https://www.insee.fr/fr/statistiques/serie/000011432). Il peut être lu directement en R :

```r
# Lecture indice BT01 depuis le fichier CSV INSEE
bt01 <- read.csv2("bt01_series.csv", skip = 3)
indice_courant <- tail(bt01$Valeur, 1)
cout_bt01 <- 1550 * indice_courant / 100
```

### Fichier de saisie Excel

Toutes les données du bâtiment (adresse, surface, coût expert, coefficients IV) sont saisies dans le fichier Excel `eval_indices_IRS+IV_synthese.xlsx`, onglet *Saisie*. Le script R lit ce fichier et génère automatiquement les fichiers de données pour le rapport Typst.

```r
library(readxl)
saisie <- read_excel("eval_indices_IRS+IV_synthese.xlsx", sheet = "Saisie")
cout_neuf_m2 <- saisie$cout_neuf_m2   # ligne 11 : valeur retenue
prix_expert  <- saisie$cout_expert    # ligne 12 : prix expert (optionnel)
```

---

## Références

- **INSEE — Indice BT01** : [serie/000011432](https://www.insee.fr/fr/statistiques/serie/000011432) — mise à jour mensuelle
- **DVF open data** : [data.gouv.fr — Demandes de Valeurs Foncières](https://www.data.gouv.fr/fr/datasets/demandes-de-valeurs-foncieres/) — DGFiP / Etalab
- **UNTEC / Batichiffre** : référentiel coûts de construction — publication annuelle
- **Méthode IV** : voir [→ Méthode d'évaluation IRS & IV](/infos/ressources/methode-evaluation-irs-iv)
- **Application concrète** : voir [→ Évaluation IRS & IV — Immeuble XVIIIe Aix-en-Provence](/realisations/evaluation-irs-immeuble-exemple)
