#!/bin/bash

[[ ! -d /Users/scott/perl5 ]] && return

PATH="/Users/scott/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/scott/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/scott/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/scott/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/scott/perl5"; export PERL_MM_OPT;
