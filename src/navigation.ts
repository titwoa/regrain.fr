import { getPermalink } from './utils/permalinks';

export const headerData = {
  links: [
    {
      text: 'Accueil',
      href: getPermalink('/'),
    },
    {
      text: 'Services',
      links: [
        {
          text: 'Bâtiments anciens',
          href: getPermalink('/services/batiments-anciens'),
        },
        {
          text: 'Bâtiments récents',
          href: getPermalink('/services/batiments-modernes'),
        },
        {
          text: 'Évaluation risque structurel (IRS) et vétusté (IV)',
          href: getPermalink('/services/evaluation-irs-iv'),
        },
        {
          text: 'Diagnostic de vulnérabilité RGA',
          href: getPermalink('/services/diagnostic-rga'),
        },
        {
          text: 'Instrumentation & suivi de fissures',
          href: getPermalink('/services/suivi-fissures-pathologies'),
        },
        {
          text: 'Notes de calcul',
          href: getPermalink('/services/notes-calcul-renforcement'),
        },
        {
          text: 'Préconisations & Plans',
          href: getPermalink('/services/precos-plans'),
        },
        {
          text: '→ Tous nos services',
          href: getPermalink('/services'),
        },
      ],
    },
    {
      text: 'Réalisations',
      href: getPermalink('/realisations'),
    },
    {
      text: 'À propos',
      links: [
        {
          text: "L'entreprise",
          href: getPermalink('/a-propos/entreprise'),
        },
        {
          text: "L'équipe",
          href: getPermalink('/a-propos/equipe'),
        },
      ],
    },
    {
      text: 'Infos & Blog',
      links: [
        {
          text: 'Actualités & Blog',
          href: getPermalink('/infos/blog'),
        },
        {
          text: 'Ressources',
          href: getPermalink('/infos/ressources'),
        },
      ],
    },
  ],
  actions: [{ text: 'Nous contacter', href: getPermalink('/contact') }],
};

export const footerData = {
  links: [
    {
      title: 'Services',
      links: [
        { text: 'Diag. Bât. anciens', href: getPermalink('/services/batiments-anciens') },
        { text: 'Diag. Bât. récents', href: getPermalink('/services/batiments-modernes') },
        { text: 'Évaluation IRS & IV', href: getPermalink('/services/evaluation-irs-iv') },
        { text: 'Diagnostics RGA', href: getPermalink('/services/diagnostic-rga') },
        { text: 'Instrumentation de fissures', href: getPermalink('/services/suivi-fissures-pathologies') },
        { text: 'Notes de calcul', href: getPermalink('/services/notes-calcul-renforcement') },
        { text: 'Préconisations & Plans', href: getPermalink('/services/precos-plans') },
        // { text: 'Rapports d\'expertise', href: getPermalink('/services/rapports-expertise') },
      ],
    },
    {
      title: 'Réalisations & Infos',
      links: [
        { text: 'Réalisations', href: getPermalink('/realisations') },
        { text: 'Carte des projets', href: getPermalink('/carte') },
        { text: 'Blog', href: getPermalink('/infos/blog') },
        { text: 'Ressources', href: getPermalink('/infos/ressources') },
      ],
    },
    {
      title: 'À propos',
      links: [
        { text: "L'entreprise", href: getPermalink('/a-propos/entreprise') },
        { text: "L'équipe", href: getPermalink('/a-propos/equipe') },
        { text: 'Contact', href: getPermalink('/contact') },
      ],
    },
  ],
  secondaryLinks: [
    { text: 'Mentions légales', href: getPermalink('/mentions-legales') },
    { text: 'Confidentialité', href: getPermalink('/confidentialite') },
  ],
  socialLinks: [
    {
      ariaLabel: 'LinkedIn',
      icon: 'tabler:brand-linkedin',
      href: 'https://www.linkedin.com/company/bet-regrain',
      target: '_blank',
    },
  ],
  footNote: `
    © ${new Date().getFullYear()} <strong>Regrain</strong> · SIRET 511 997 538 00059
    · 341 chemin des basses beaumes, 84360 Puget
    · <button data-tel="0662186835" style="background:none;border:none;padding:0;cursor:pointer;text-decoration:underline;color:inherit;font:inherit">Voir le numéro</button>
    · <a href="mailto:contact@regrain.fr">contact@regrain.fr</a>
  `,
};
