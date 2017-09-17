# x
x is cmd bridge
  
`x`  
`x -d`  
`sh ./x`  
`sh ./x -d`  
`source x`  
`source x -d`  
  
## author
onoie
  
## variable
LINES,COLUMNS,INSTALL_DIR,BIN_NAME,BIN_DIR,SH,RC,CONF,IMPORT,ENV,SCRIPT,MAKES,ARGS
  
## config.sh
##### import
autoload  
ex) `declare -a IMPORT=("./src/import")`  
##### script
fast script  
ex) `declare -a SCRIPT=("./src/script")`  
~~`x install` => `/bin/bash ./src/script/install.sh`~~  
##### env
shebang scripts  
ex) `declare -a ENV=("bash" "node")`  
~~`x bash hello` => `/usr/bin/env bash ./env/bash/hello.sh`~~  
~~`x node echo hello` => `/usr/bin/env node ./env/node/echo.js "hello"`~~  
##### make
alias makefiles  
ex) `declare -a MAKES=("sample ./default/Makefile")`  
~~`x make sample readme` => `$MAKES[sample]:./src/default/Makefile.make readme`~~  

