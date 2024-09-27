#!/bin/bash

set -e

yue .
for computer_dir in ~/.local/share/PrismLauncher/instances/CC-\ Islands/.minecraft/saves/*/computercraft/computer/*/; do
	cp -r ./ "$computer_dir"
done
