nproc := `nproc`

all: llvm-config llvm

.PHONY: checkout
checkout:
#	mkdir -p llvm
#	svn co https://llvm.org/svn/llvm-project/llvm/trunk llvm
#	cd llvm/tools; svn co https://llvm.org/svn/llvm-project/cfe/trunk clang
#	cd llvm/tools/clang/tools; svn co https://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
#	cd llvm/projects; svn co https://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
	rm -rf llvm-project
	git clone --depth=1 https://github.com/llvm/llvm-project.git

.PHONY: llvm-config
llvm-config:
	rm -rf build
	mkdir -p build
	cd build; cmake ../llvm-project/llvm/ -DLLVM_ABI_BREAKING_CHECKS=FORCE_OFF -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_CCACHE_BUILD=ON -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_ENABLE_PROJECTS=clang -G "Unix Makefiles" 
	cd build; cp  compile_commands.json ../

.PHONY: llvm
llvm:
	cd build; cmake --build . --config Release -- -j $(nproc)

.PHONY: install
install:
	cd build; cmake -DCMAKE_INSTALL_PREFIX=$(PREFIX)  -P cmake_install.cmake

.PHONY: clean
clean:
	rm -rf build
