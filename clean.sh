shopt -s extglob
rm !(*.vhd|.gitignore|LICENSE|*.sh|*.md|*.txt|wave/*)
shopt -u extglob