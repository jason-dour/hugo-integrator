# hugo-integrator

Integration and Publication Image For Hugo from gohugo.io.

## What is it?

More to come, but to summarize:

* Docker image focused around [Hugo](https://github.com/gohugoio/hugo) as website publication engine.
* Layered in tools to support a more robust workflow:
  * [Hugo Preproc](https://github.com/jason-dour/hugo-preproc) - For pre-processing of files for Hugo to include in the published website, leveraging the various included tools.
  * [Pandoc](https://github.com/jgm/pandoc) - For various document conversation capabilities; multi-tool on the belt.
  * [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) - For easy conversation of Mermaid files to images.
  * [Graphviz](https://gitlab.com/graphviz/graphviz/) - For conversion of DOT/Graphviz to images.
  * [Draw.io](https://github.com/jgraph/drawio) - For diagram conversion to images.
  * ...

## Gotchas

Quite frankly, this image is **huge**, and I hate it.  But if you want `Draw.io`, you pay the price of Electron bloat.  Without `Draw.io` this could be an Alpine based image that is incredibly smaller.

Trimming this down is vital; not sure how possible it will be.  Looking at alternatives to using `drawio-desktop`.
