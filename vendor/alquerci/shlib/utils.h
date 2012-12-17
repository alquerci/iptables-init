### START UTILS ###
__strlen()
{
    echo -n "$@" | grep -Eo "." | grep -Ec ".";
}

__wordno()
{
    echo -n "$@" | grep -Eo "[^[:blank:]]+" | grep -Ec ".";
}
### START UTILS ###

