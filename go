#!/bin/bash

EVM_DIR="$HOME/.evm"

if [[ -d $EVM_DIR ]]; then
  echo "EVM is already installed at '$EVM_DIR'"

  exit 1
else
  git clone -b ${1:-master} https://github.com/rejeep/evm.git $EVM_DIR &> /dev/null

  echo "Successfully installed EVM! Now, add the evm binary to your PATH."
  echo '  export PATH="'${EVM_DIR}'/bin:$PATH"'

  exit 0
fi
