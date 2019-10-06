#!/bin/sh
cat $1 | ./olc-parseprint && echo OK
