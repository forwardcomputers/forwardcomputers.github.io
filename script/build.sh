#!/bin/bash
#
curl --silent --location --url https://github.com/forwardcomputers/dotfiles/raw/master/README.md | sed -n '/| Repository/,$p' > README.md
curl --silent --location --url https://github.com/forwardcomputers/home-assistant/raw/master/README.md | sed -n '/| [![]/,$p' >> README.md
curl --silent --location --url https://github.com/forwardcomputers/pxe/raw/master/README.md | sed -n '/| [![]/,$p' >> README.md
#
curl --silent --location --url https://github.com/forwardcomputers/dockerfiles/raw/master/README.md | sed -n '/| [![]/,$p' >> README.md
#
