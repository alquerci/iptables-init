iptables-init
=============

[![Build Status][0]][1]

An useful bash script for auto-restore iptables rules.

Deprecation
-----------

This tool is deprecated please use the debian/ubuntu package [iptables-persistant][2] instead.

Requirements
------------

* GNU core utilities
* iptables
* git
* make
* shunit2

Build
-----

$ `make`

Tests
-----

$ `make test`

Installation
------------

The installation must running into a root account.

$ `sudo make install`

It's also possible to uninstall it by running.

$ `sudo make uninstall`


Files
-----

`/var/backups/iptables.rules`: Path used to save rules.


TODO
----

* Add missing tests and do better tests
* Makefile/install Do better usage of update-rc.d

[0]: https://travis-ci.org/alquerci/iptables-init.png?branch=master
[1]: https://travis-ci.org/alquerci/iptables-init
[2]: https://launchpad.net/ubuntu/+source/iptables-persistent
