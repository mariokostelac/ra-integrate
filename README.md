# dnassembler
DNA assembler developed on Faculty of Electrical Engineering and Computing and Ruder Boskovic Institute, Croatia

## Requirements
- ruby
- make
- g++ (4.8.2 or later)
- graphviz
- and lot more. If it does not work for you, drop an issue...

## Installation
```
git clone --recursive https://github.com/mariokostelac/dnassembler.git
make
```

## Upgrade
```
git pull
git submodule foreach git pull origin master
make
```

## Clang Issues or "Build does not work!"
If you are unlucky and your `g++` points to `clang`, run
```
brew install g++-4.8
CXX=g++-4.8 make
```
