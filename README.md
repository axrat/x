# x
x is cmd bridge
  
`./x`  
`./x -d`  
`./x install` => `/bin/bash ./env/install.sh`  
`./x bash hello` => `/usr/bin/env bash ./env/bash/hello.sh`  
`./x node echo hello` => `/usr/bin/env node ./env/node/hello.js "hello"`  

## format 
* bash:*.sh
* node:*.js
