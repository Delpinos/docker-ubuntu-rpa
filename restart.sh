#!/bin/bash

COMMAND="docker-compose -f docker-compose.yml down"
echo $COMMAND
$COMMAND

COMMAND="docker-compose -f docker-compose.yml up -d --force-recreate --build"
echo $COMMAND
$COMMAND
