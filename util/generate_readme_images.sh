#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
set -vx

rm -rf snippets/*

bundle exec ruby util/readme_examples.rb

for snippet in snippets/*.rb; do
    bundle exec ruby $snippet;
    dot -Tsvg shape-graph.dot > $snippet.svg
done

rm images/*.svg

cp snippets/*.svg images
