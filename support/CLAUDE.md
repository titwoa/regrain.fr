# Search errors in all content files and fix them

## Different kind of errors

- typographic errors :
    - french guillemets : "word" --> <<+"thin space"word"thin space"+>>
        - in .md/.mdx : handled automatically by frenchQuotesRemarkPlugin at build time — no manual fix needed
        - in .astro pages : NOT handled by the plugin — must be replaced manually with «\u202Fword\u202F» in JS strings
    - a space before ":" : word: --> word :
    - commas : no space before and a space after : word1,word2 --> word1, word2
    - Only one uppercase in a sentence : Only One Uppercase --> Only one uppercase at the first word
    - other typographic rule I don't remember/know
- orthographic errors
- dead links, both internals and "external" :
    - external links : 
        - check viability of https://{slug}
        - opens in a new tab (target: _blank)
- "graphic" errors :
    - list all placeholder images to change for real ones (a lot !)
    - broken image paths : all images have been moved from `public/images/` to `src/assets/images/`.
      String paths like `/images/...` no longer work. Fix per context :
        - `.md`/`.mdx` frontmatter and inline string props : replace `/images/` with `~/assets/images/`
          → `findImage()` (src/utils/images.ts) resolves these via import.meta.glob automatically
        - `.astro` page props passed to components using plain `<img>` (e.g. TeamMember) :
          `import img from '~/assets/images/...'` then pass `img.src` as a string, or update the
          component to use the custom `Image.astro` (which calls findImage)
      Never use `/images/...` — all images are in `src/assets/images/`.

## fix them


## Document them in "relecture.typ"

Check cases a), b) & c) with a green check when fix realised and summarise what's done in d) note() field