shopt -s extglob
rm !(*.vhd|.gitignore|LICENSE|*.sh|*.md|*.txt|*.ghw|*.gtkw|*.asm)
shopt -u extglob