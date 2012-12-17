### START COMPILATOR ###
VERSION_MIN=2;

__compile()
{
    # Comme Chet Ramey ajoute constamment de nouvelles fonctionnalités à Bash,
    # vous pourriez configurer $minimum_version à 2.XX, 3.XX, ou quoi que ce soit
    # de plus approprié.
    if [ "$BASH_VERSION" \< "$VERSION_MIN" ];
    then
      echo "Ce script fonctionne seulement avec Bash, version $VERSION_MIN ou ultérieure.";
      echo "Une mise à jour est fortement recommandée.";
      exit $E_BAD_VERSION;
    fi;

    sh -nu "$@" > /dev/null;
    if [ "$?" != 0 ];
    then
        echo "Script non executer erreur trouvee." >&2;
        exit $E_PARSE;
    fi;
};
### START COMPILATOR ###

