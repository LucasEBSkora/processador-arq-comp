shopt -s extglob
rm !(*.vhd|.gitignore|LICENSE|*.sh|*.md)
shopt -u extglob