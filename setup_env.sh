#!/bin/bash

R_DLATK_DIR=`find /usr/local/lib -name 'dlatk'`
R_MYSQL_HOST=${MYSQL_PORT_3306_TCP_ADDR:-$MYSQL_HOST}
R_MYSQL_PORT=${MYSQL_PORT_3306_TCP_PORT:-$MYSQL_PORT}
R_MYSQL_USER=${MYSQL_USER:-root}
R_MYSQL_PASS=${MYSQL_ENV_MYSQL_ROOT_PASSWORD:-$MYSQL_PASSWORD}

cat $HOME/bashrc.template | sed "s@dlatk_dir_tmp@$R_DLATK_DIR@" > $HOME/.bashrc
cat $HOME/mycnf.template | sed "s@user_tmp@$R_MYSQL_USER@" | sed "s@password_tmp@$R_MYSQL_PASS@" | sed "s@host_tmp@$R_MYSQL_HOST@" | sed "s@port_tmp@$R_MYSQL_PORT@" > $HOME/.my.cnf
DLA_CONST=`find $R_DLATK_DIR/ -name "dlaConstants.py"`
cat $DLA_CONST | sed "s@127.0.0.1@$R_MYSQL_HOST@" > $DLA_CONST.tmp && mv $DLA_CONST.tmp $DLA_CONST
