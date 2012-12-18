iptables-init
=============

[![Build Status][0]][1]

An useful bash script for auto-restore iptables rules.

Requirements
------------

* GNU core utilities
* iptables
* git
* make

Build
-----

$ `make`

Tests
-----

$ `make test`

Installation
------------

The installation must running into a root account.

$ `make install`

With sudo type `sudo make PWD="$(pwd)" install`

TODO
----

* Add missing tests and do better tests
* Makefile/install Do better usage of update-rc.d

[0]: https://travis-ci.org/alquerci/iptables-init.png?branch=master
[1]: https://travis-ci.org/alquerci/iptables-init
