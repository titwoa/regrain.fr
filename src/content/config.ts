import { z, defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';

// ── Métadonnées SEO partagées ──────────────────────────────────────────────
const metadataDefinition = () =>
  z
    .object({
      title: z.string().optional(),
      ignoreTitleTemplate: z.boolean().optional(),
      canonical: z.string().url().optional(),
      robots: z
        .object({
          index: z.boolean().optional(),
          follow: z.boolean().optional(),
        })
        .optional(),
      description: z.string().optional(),
      openGraph: z
        .object({
          url: z.string().optional(),
          siteName: z.string().optional(),
          images: z
            .array(z.object({ url: z.string(), width: z.number().optional(), height: z.number().optional() }))
            .optional(),
          locale: z.string().optional(),
          type: z.string().optional(),
        })
        .optional(),
    })
    .optional();

// ── Collection blog Regrain ───────────────────────────────────────────────
const blogCollection = defineCollection({
  loader: glob({ pattern: '*.{md,mdx}', base: 'src/data/blog' }),
  schema: z.object({
    title: z.string(),
    description: z.string().optional(),
    publishDate: z.coerce.date(),
    updateDate: z.coerce.date().optional(),
    author: z.string().optional().default('Regrain'),
    image: z
      .object({
        src: z.string(),
        alt: z.string().optional(),
      })
      .optional(),
    category: z.string().optional(),
    tags: z.array(z.string()).optional(),
    draft: z.boolean().optional().default(false),
    metadata: metadataDefinition(),
  }),
});

// ── Collection ressources ─────────────────────────────────────────────────
const ressourcesCollection = defineCollection({
  loader: glob({ pattern: '*.{md,mdx}', base: 'src/data/ressources' }),
  schema: z.object({
    title: z.string(),
    description: z.string().optional(),
    publishDate: z.coerce.date(),
    updateDate: z.coerce.date().optional(),
    author: z.string().optional().default('Regrain'),
    image: z
      .object({
        src: z.string(),
        alt: z.string().optional(),
      })
      .optional(),
    category: z.string().optional(),
    tags: z.array(z.string()).optional(),
    draft: z.boolean().optional().default(false),
    metadata: metadataDefinition(),
  }),
});

// ── Collection réalisations ───────────────────────────────────────────────
const realisationsCollection = defineCollection({
  loader: glob({ pattern: '*.{md,mdx}', base: 'src/data/realisations' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    publishDate: z.coerce.date(),
    updateDate: z.coerce.date().optional(),
    image: z
      .object({
        src: z.string(),
        alt: z.string().optional(),
      })
      .optional(),
    categories: z.array(z.string()).optional(),
    location: z.string().optional(),
    statut: z.string().optional(),
    lat: z.number().optional(),
    lon: z.number().optional(),
    mapsUrl: z.string().optional(),
    draft: z.boolean().optional().default(false),
    metadata: metadataDefinition(),
    carousel: z.array(z.object({
      src: z.string(),
      alt: z.string().optional(),
    })).optional(),
  }),
});

export const collections = {
  blog: blogCollection,
  ressources: ressourcesCollection,
  realisations: realisationsCollection,
};
