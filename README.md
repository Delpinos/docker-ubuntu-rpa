# Docker container - Ubuntu for RPA
Base docker image for using RPA processes

## About

This project contains the source code of the docker image to use RPA

This source code follows good practices and clean architecture


The docker image contains the following components:

* NodeJS 14 + npm
* JRE 11
* Python (2.7 e 3.8) + pip
* .NET Core Runtime 3.1
* Browsers:
  * Mozilla Firefox
  * Google Chrome

<br />

## Commands

<br />

### Start
```
  npm run start
```
or  
```
  ./start.sh
```  
or  
```
  docker-compose -f docker-compose.yml up -d --force-recreate --build
``` 

<br />


### Restart
```
  npm run restart
```  
or
```
  ./restart.sh
``` 
or  
```
  docker-compose -f docker-compose.yml down && docker-compose -f docker-compose.yml up -d --force-recreate --build
```

<br />

### Stop
```
  npm run stop
```  
or
```
  ./stop.sh
```  
or  
```
  docker-compose -f docker-compose.yml down
```

<br />

### Logs
```
  npm run logs
``` 
or
```
  ./logs.sh
``` 
or
```
  docker logs docker-ubuntu-rpa -f
``` 

<br />

## Changelog

The current changelog is provided here: **[CHANGELOG.md](CHANGELOG.md)**