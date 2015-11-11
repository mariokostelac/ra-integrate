# dnassembler
DNA assembler developed on FER, Croatia

## Requirements
- ruby
- make
- g++ (4.8.2 or later)

## Installation
```
git clone --recursive https://github.com/mariokostelac/dnassembler.git
make
```

## Clang Issues or "Build does not work!"
If you are unlucky and your `g++` points to `clang`, run
```
brew install g++-4.8
CXX=g++-4.8 make
```
