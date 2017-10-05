# x
x is cmd manager  
##### download
`sudo wget --no-check-certificate https://github.com/onoie/x/archive/master.zip -O x-master.zip`  
##### usage
`x`  
`x -d`  
`source x`  
`source x -d`  
`sh ./x`  
`./x install.sh`  
`vim $X`  
`cd $XD`  
  
## config.sh
##### import
autoload  
ex) `declare -a IMPORT=("./src/import/*")`  
##### script
fast script  
ex) `declare -a SCRIPT=("./src/script/example.sh")`  
~~`./x install` => `/bin/bash ./script/install.sh`~~  
##### env
shebang scripts  
ex) `declare -a ENV=("bash" "node")`  
`x bash hello.sh` => `/usr/bin/env bash ./env/bash/hello.sh`  
`x node echo.js hello onoie` => `/usr/bin/env node ./env/node/echo.js "hello onoie"`  
##### make
makefiles alias  
ex) `declare -a MAKES=("sample ./default/Makefile")`  
~~`x make sample readme` => `$MAKES[sample]:./src/default/Makefile.make readme`~~  
## variable
export X,XD  
TODO~~DEBUG,SOURCE,LINES,COLUMNS,INSTALL_DIR,BIN_NAME,BIN_DIR,BIN_PATH,SRC,SH,RC,CONF,IMPORT,ENV,SCRIPT,MAKES,ARGS~~  
### function
TODO~~timestamp,hr,hbr,ownlog,log,notfound,exist,load~~  
## author
onoie
  
