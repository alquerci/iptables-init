#!/bin/bash

oneTimeSetUp()
{
    . ${SRC_DIR}/${INIT_D}/*.o > /dev/null
};

test_set_interface()
{
    set_interface;
    assertEquals "code retour" "$?" "0";
};

test_set_network_addr()
{
    set_network_addr;
    assertEquals "code retour" "$?" "0";
};

test_set_inet_addr()
{
    set_inet_addr;
    assertEquals "code retour" "$?" "0";
};

test_set_bcast_addr()
{
    set_bcast_addr;
    assertEquals "code retour" "$?" "0";
};

test_set_network_mask()
{
    set_network_mask;
    assertEquals "code retour" "$?" "0";
};

test_insert_default_route()
{
    insert_default_route;
    assertEquals "code retour" "$?" "0";
};

. shunit2;
