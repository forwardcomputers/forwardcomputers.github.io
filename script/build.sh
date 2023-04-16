#!/bin/bash
#
curl -sL https://github.com/forwardcomputers/dotfiles/raw/main/README.md | sed -n '/| Repository/,$p' > README.md
curl -sL https://github.com/forwardcomputers/home-assistant/raw/main/README.md | sed -n '/| [![]/,$p' >> README.md
curl -sL https://github.com/forwardcomputers/pxe/raw/main/README.md | sed -n '/| [![]/,$p' >> README.md
#
curl -sL https://github.com/forwardcomputers/chocolatey-packages/raw/main/README.md | sed -n '/| [![]/,$p' >> README.md
#
curl -sL https://github.com/forwardcomputers/dockerfiles/raw/main/README.md | sed -n '/| [![]/,$p' >> README.md
#

