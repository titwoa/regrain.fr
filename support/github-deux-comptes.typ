#import "assets/template.typ": *

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages)


// logo-societe: "assets/images/"

#show: doc => template(
  societe:       "BET REGRAIN",
  logo:           "images/regrain_logo.png",
  titre:         [Deux comptes GitHub \ sur Win 11],
  sous-titre:    [Configuration de 2 clés SSH \ pour compte perso + compte pro/Regrain],
  auteur:        "OLT",
  version-date:  "18/03/2026",
  version:       "1.0",
  texte-entete:  "Support technique — Site web regrain.fr",
  mots-cles:     ("Github", "comptes", "clés SSH", "Web"),
  doc-description: "Guide de création de 2 comptes Github à l'aide des clés SSH différentes.",
  tdm-profondeur:      3,
  doc,
)

= Contexte & Objectif

- un compte GitHub *existant* associé à l'email `o.turlier@gmail.com`, à conserver, sera utilisé prochainement pour héberger les pages web du site #link("https://canopee.org")[canopee.org]

- un compte GitHub *à créer*  associé au mail `o.turlier@regrain.fr`, utilisé pour héberger les pages du site web #link("https://regrain.fr")[regrain.fr]

= Principe

Deux comptes GitHub peuvent coexister sur le même poste grâce à *deux clés SSH distinctes* et un fichier `~/.ssh/config` qui associe chaque clé à un alias d'hôte.

L'astuce clé : utiliser un alias (`github-regrain`) dans l'URL de la remote Git, plutôt que `github.com` directement — ce qui force l'utilisation de la bonne clé SSH selon le dépôt.

== Canopee.org et dépôts existants

=== Étape 0 — vérification et/ou renommage

*A) *vérifier l'existence d'une clé SSH associée à l'email `o.turlier@gmail.com` dans les fichiers

+ il y a `C:\Users\oturl\.gitconfig` qui liste :
  ```
  [filter "lfs"]
    process = git-lfs filter-process
    required = true
    clean = git-lfs clean -- %f
    smudge = git-lfs smudge -- %f
  [user]
    name = Olivier TURLIER
    email = o.turlier@gmail.com
  [http]
    postBuffer = 524288000
  [credential "https://codeberg.org"]
    provider = generic
  ```

+ le fichier `C:\Users\oturl\.ssh\known_hosts` qui liste :
  ```
  github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
  proxy.tunnl.gg ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3HFkIcqgWI6Sa1E31KiUbcfcrX/5MZl4LnaQnUYL8K
  ```

+ les fichiers contenus dans `C:\Program Files\Git\etc`



*B)* Vérification avec les commandes :

#table(
  columns: (1fr, 1fr, 1.2fr),
  table.header([*Commande*], [*Sortie réelle*], [*Interprétation*]),

  [`ls ~/.ssh/`],
  [`known_hosts`],
  [*Aucune clé SSH personnelle.* Seul le fichier des hôtes connus est présent (empreintes GitHub et tunnl.gg déjà contactés). Les deux clés sont à créer.],

  [`ssh -T git@github.com`],
  [`Permission denied (publickey).`],
  [Connexion refusée : aucune clé SSH n'est associée au compte GitHub. La connexion précédente à GitHub se faisait probablement via *HTTPS + token*, pas SSH.],

  [`ssh-add -l`],
  [`Could not open a connection to your authentication agent.`],
  [L'agent SSH n'est pas démarré — normal sous Git Bash Windows sans session active.],

  [`cat ~/.ssh/config`],
  [_(fichier inexistant)_],
  [Pas de config multi-comptes → à créer à l'étape 3.],
)

#note[
  Les fichiers `ssh_host_*` présents dans `C:\ProgramData\ssh\` sont les clés du *serveur* OpenSSH Windows (quand le poste agit comme serveur SSH) — ils ne peuvent pas servir à se connecter à GitHub. Les fichiers dans `C:\Program Files\Git\etc\ssh\` sont des fichiers de configuration système de Git, pas des clés.

  *Bilan :* aucune clé SSH personnelle n'existe sur ce poste. Les deux clés (compte perso + compte Regrain) sont à créer from scratch à partir de l'étape 1.
]




=== Étape 1 — Créer la clé SSH pour le compte perso (canopee.org)

Les clés publiques associées au compte `olitur` sont consultables sur #link("https://github.com/olitur.keys")[github.com/olitur.keys], mais GitHub ne stocke *jamais* les clés privées — si elles n'existent plus localement, elles sont perdues. Il faut en créer une nouvelle paire :

Dans *Git Bash* :

```bash
ssh-keygen -t ed25519 -C "o.turlier@gmail.com" -f ~/.ssh/id_perso
```

Dans *PowerShell* (`~` n'est pas résolu par `ssh-keygen`) :

```powershell
ssh-keygen -t ed25519 -C "o.turlier@gmail.com" -f "$env:USERPROFILE\.ssh\id_perso"
```

Puis ajouter la clé publique sur le compte GitHub `olitur` :

```bash
cat ~/.ssh/id_perso.pub
```

→ GitHub (`olitur`) : *Settings → SSH and GPG keys → New SSH key* → coller la clé.

#note[Les anciennes clés éventuellement listées sur `github.com/olitur.keys` peuvent être supprimées du compte GitHub (`olitur`) puisque les clés privées correspondantes n'existent plus sur le poste.]

=== Résultat

Après création du fichier `config` (étape 3) :

```powershell
ssh -T git@github.com
# Enter passphrase for key 'C:\Users\oturl/.ssh/id_perso': ****
# Hi olitur! You've successfully authenticated, but GitHub does not provide shell access.
```

✓ Connexion établie avec le compte `olitur`.

#note[
  La passphrase est demandée à chaque connexion SSH. Pour l'éviter, ajouter la clé à l'agent SSH :
  ```powershell
  ssh-add $env:USERPROFILE\.ssh\id_perso
  ```
  L'agent la mémorise pour la durée de la session Windows.
]


== Regrain.fr

=== Étape 1 — Créer la clé SSH pour le compte Regrain

Dans *Git Bash* :

```bash
ssh-keygen -t ed25519 -C "o.turlier@regrain.fr" -f ~/.ssh/id_regrain
```

Dans *PowerShell* (`~` non résolu par `ssh-keygen`) :

```powershell
ssh-keygen -t ed25519 -C "o.turlier@regrain.fr" -f "$env:USERPROFILE\.ssh\id_regrain"
```

=== Étape 2 — Ajouter la clé publique sur GitHub

Afficher la clé publique :

```bash
cat ~/.ssh/id_regrain.pub
```

Copier le résultat, puis dans GitHub (connecté au compte `o.turlier\@regrain.fr`) :

*Settings → SSH and GPG keys → New SSH key* → coller la clé.

=== Résultat

Clé ajoutée — confirmation GitHub :

```
id_regrain
SHA256:J9kzO8REBb+j5NF9EF+f+m6cZO0CkeROOmHIpirTYmo
```

=== Étape 3 — Fichier `~/.ssh/config`

Créer ou éditer `C:\Users\oturl\.ssh\config` :

```
# Compte GitHub personnel
Host github.com
  HostName github.com
  User git
  IdentityFile C:\Users\oturl\.ssh\id_perso

# Compte GitHub Regrain
Host github-regrain
  HostName github.com
  User git
  IdentityFile C:\Users\oturl\.ssh\id_regrain
  IdentitiesOnly yes
```

#note[Sous Windows, utiliser le chemin complet (`C:\Users\oturl\...`) plutôt que `~/.ssh/` — le tilde n'est pas résolu correctement par le client OpenSSH natif de Windows.]

=== Étape 3b — Tester la connexion

```powershell
ssh -T git@github-regrain
```

Réponse obtenue :

```
Hi titwoa! You've successfully authenticated, but GitHub does not provide shell access.
```

✓ Connexion établie avec le compte `titwoa`.

#warn[
  Si la réponse affiche `Hi olitur!` au lieu de `Hi titwoa!`, c'est que la mauvaise clé est utilisée. Vérifier deux points :

  + La clé `id_regrain.pub` a bien été ajoutée au compte GitHub `titwoa` (*Settings → SSH and GPG keys*)
  + Le fichier `config` contient bien le bloc `github-regrain` avec `IdentityFile` pointant vers `id_regrain`. Sous PowerShell, préférer le chemin complet :
    ```
    IdentityFile C:\Users\oturl\.ssh\id_regrain
    ```
    plutôt que `~/.ssh/id_regrain` (résolution `~` aléatoire selon le contexte).
]

=== Étape 4 — Initialiser le dépôt Regrain

Depuis le dossier du site :

```bash
cd ".../regrain-website_astro"
git init
git config user.name "Olivier Turlier"
git config user.email "o.turlier@regrain.fr"
git add .
git commit -m "Initial commit"
gh repo create regrain.fr --public --push --source=.
```

La commande `gh repo create` crée le dépôt sur GitHub *et* pousse en une seule étape — pas besoin de créer le dépôt manuellement sur github.com au préalable.

#note[`gh` doit être authentifié avec le compte `titwoa` avant cette étape — voir étape suivante.]

=== Étape 5 — Configurer git localement pour ce dépôt

Sans `--global` : s'applique uniquement à ce dépôt.

```bash
git config user.name "Othman Turlier"
git config user.email "o.turlier@regrain.fr"
```

=== Étape 6 — Tester la connexion

```bash
ssh -T git@github-regrain
```

Réponse attendue :

```
Hi titwoa! You've successfully authenticated, but GitHub
does not provide shell access.
```

= Récapitulatif des fichiers concernés

#table(
  columns: (auto, 1fr),
  table.header([*Fichier*], [*Rôle*]),
  [`~/.ssh/id_regrain`],       [Clé privée SSH — ne jamais partager],
  [`~/.ssh/id_regrain.pub`],   [Clé publique — à coller sur GitHub],
  [`~/.ssh/config`],           [Associe l'alias `github-regrain` à la bonne clé],
  [`.git/config` (dépôt)],     [Remote URL avec alias + config `user.email` locale],
)

= Remarque

Le compte GitHub doit exister avec l'adresse `o.turlier@regrain.fr` *avant* l'étape 2. Si ce n'est pas encore le cas, créer le compte sur #link("https://github.com")[github.com] avec cette adresse mail en premier.
