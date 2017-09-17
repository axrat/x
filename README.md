# x
x is cmd bridge
  
`x`  
`sh ./x -d`  
`source x -d`  
`x install` => `/bin/bash ./env/install.sh`  
`x bash hello` => `/usr/bin/env bash ./env/bash/hello.sh`  
`x node echo hello` => `/usr/bin/env node ./env/node/echo.js "hello"`  

## env format 
* ./env/bash:*.sh
* ./env/node:*.js

