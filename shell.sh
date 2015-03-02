#!/bin/sh

erl  -pa `pwd`/ebin `pwd`/deps/*/ebin -run reloader -s er_app start -s observer start -config ./priv/development
