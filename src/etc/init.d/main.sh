main()
{
    case "$1" in
        stop)
            iptables_save;
            exit $?;
        ;;
        start|restart)
            iptables_restore;
            insert_default_route;
            exit $?;
        ;;
        *)
            echo "usage: $SELF_PATH <start|stop|restart>";
        ;;
    esac;
};

