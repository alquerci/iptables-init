### START COLORS ###
# Couleur     Avant-plan  Arrière-plan
# noir        30          40
# rouge       31          41
# vert        32          42
# jaune       33          43
# bleu        34          44
# magenta     35          45
# cyan        36          46
# blanc       37          47
#
# FRONTGROUND
COLOR_FG_BLACK='\E[30m';
COLOR_FG_RED='\E[31m';
COLOR_FG_GREEN='\E[32m';
COLOR_FG_YELLOW='\E[33m';
COLOR_FG_BLUE='\E[34m';
COLOR_FG_MAGENTA='\E[35m';
COLOR_FG_CYAN='\E[36m';
COLOR_FG_WRITE='\E[37m';

# BACKGROUND
COLOR_BG_BLACK='\E[40m';
COLOR_BG_RED='\E[41m';
COLOR_BG_GREEN='\E[42m';
COLOR_BG_YELLOW='\E[44m';
COLOR_BG_BLUE='\E[44m';
COLOR_BG_MAGENTA='\E[45m';
COLOR_BG_CYAN='\E[46m';
COLOR_BG_WRITE='\E[47m';

__color_init()
{
    echo -ne '\E[0m';
}
### END COLORS ###

