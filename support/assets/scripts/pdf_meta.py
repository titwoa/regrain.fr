"""
pdf_meta.py — Injecte les préférences d'affichage et la protection dans un PDF.

Usage :
    python scripts/pdf_meta.py <fichier.pdf> [--protect] [--owner-pass MOT_DE_PASSE]

Options :
    --protect          Active la protection en écriture (lecture/impression autorisées)
    --owner-pass PASS  Mot de passe propriétaire (défaut : "regrain")
    --no-bookmarks     Ne pas ouvrir le panneau signets par défaut
    --layout LAYOUT    Disposition : TwoPageRight (défaut), TwoPageLeft, SinglePage
"""

import sys
import argparse
from pathlib import Path

try:
    import pikepdf
except ImportError:
    sys.exit("❌  pikepdf non installé — exécuter : pip install pikepdf")


def main() -> None:
    parser = argparse.ArgumentParser(description="Injection métadonnées PDF via pikepdf")
    parser.add_argument("pdf", help="Fichier PDF à modifier (modifié en place)")
    parser.add_argument("--protect",      action="store_true", help="Protéger contre la modification")
    parser.add_argument("--owner-pass",   default="regrain",   help="Mot de passe propriétaire (défaut: regrain)")
    parser.add_argument("--no-bookmarks", action="store_true", help="Ne pas ouvrir le panneau signets")
    parser.add_argument("--layout",       default="TwoPageRight",
                        choices=["TwoPageRight", "TwoPageLeft", "SinglePage", "TwoColumnRight", "TwoColumnLeft"],
                        help="Disposition des pages (défaut: TwoPageRight)")
    args = parser.parse_args()

    pdf_path = Path(args.pdf)
    if not pdf_path.exists():
        sys.exit(f"❌  Fichier introuvable : {pdf_path}")

    print(f"  Ouverture : {pdf_path.name}")
    try:
        # On tente une ouverture normale
        pdf = pikepdf.open(pdf_path, allow_overwriting_input=True)
    except pikepdf.PdfError:
        # Si ça échoue (ex: trailer dictionary missing), on peut tenter qpdf_recovery si supporté
        # ou simplement signaler l'erreur plus proprement.
        print(f"  ⚠️  Fichier potentiellement malformé, tentative de récupération...")
        try:
            pdf = pikepdf.open(pdf_path, allow_overwriting_input=True)
        except Exception as e:
            sys.exit(f"❌  Erreur fatale lors de l'ouverture du PDF : {e}")

    with pdf:

        # ── Préférences d'affichage ────────────────────────────────────────────
        pdf.Root["/PageLayout"] = pikepdf.Name(f"/{args.layout}")
        pdf.Root["/PageMode"]   = pikepdf.Name("/UseNone" if args.no_bookmarks else "/UseOutlines")

        # ── Sauvegarde (avec ou sans protection) ──────────────────────────────
        import time
        max_retries = 10
        retry_delay = 1.0

        for attempt in range(max_retries):
            try:
                if args.protect:
                    if attempt == 0:
                        print(f"  Protection écriture activée (owner: {args.owner_pass!r})")
                    pdf.save(
                        pdf_path,
                        encryption=pikepdf.Encryption(
                            owner=args.owner_pass,
                            user="",          # pas de mot de passe pour ouvrir
                            R=6,              # chiffrement AES-256
                            allow=pikepdf.Permissions(
                                accessibility=True,
                                extract=True,
                                modify_annotation=False,
                                modify_assembly=False,
                                modify_form=False,
                                modify_other=False,
                                print_lowres=True,
                                print_highres=True,
                            ),
                        ),
                    )
                else:
                    pdf.save(pdf_path)
                break # Succès
            except PermissionError as e:
                if attempt < max_retries - 1:
                    print(f"  ⚠️  Accès refusé, tentative {attempt + 1}/{max_retries} dans {retry_delay}s...")
                    print(f"     (Vérifiez si le fichier '{pdf_path.name}' est ouvert dans un autre logiciel)")
                    time.sleep(retry_delay)
                else:
                    print(f"\n❌  Erreur d'accès persistante lors de la sauvegarde : {e}")
                    print(f"    Le fichier est probablement verrouillé par une autre application (lecteur PDF, navigateur, etc.).")
                    print(f"    Veuillez fermer tout logiciel utilisant ce fichier et relancer la commande.\n")
                    sys.exit(1)
            except Exception as e:
                sys.exit(f"❌  Erreur lors de la sauvegarde : {e}")

    print(f"  ✓ Métadonnées injectées → {pdf_path.name}")


if __name__ == "__main__":
    main()
