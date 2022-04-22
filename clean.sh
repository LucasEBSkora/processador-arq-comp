shopt -s extglob
rm !(*.vhd|.gitignore|LICENSE|clean.sh|README.md)
shopt -u extglob