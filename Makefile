LIBNAME = scalene
PYTHON = python3
PYTHON_SOURCES = scalene/[a-z]*.py
C_SOURCES = src/source/get_line_atomic.cpp src/include/*.h* # src/source/libscalene.cpp 

CXXFLAGS = /Ox /DNDEBUG /std:c++14 /Zi
CXX = cl

MAIN_INCLUDES  = -Isrc -Isrc/include
INCLUDES = $(MAIN_INCLUDES) -IHeap-Layers -IHeap-Layers/wrappers -IHeap-Layers/utility -Iprintf

LIBFILE = lib$(LIBNAME).dll
WRAPPER = # Heap-Layers/wrappers/gnuwrapper.cpp

SRC = src/source/lib$(LIBNAME).cpp $(WRAPPER) printf/printf.cpp

all:  # vendor-deps $(SRC) $(OTHER_DEPS)
# $(CXX) $(CXXFLAGS) $(INCLUDES) $(SRC) /o $(LIBFILE)

mypy:
	-mypy $(PYTHON_SOURCES)

format: black isort clang-format

clang-format:
	-clang-format -i $(C_SOURCES) --style=google

isort:
	-isort $(PYTHON_SOURCES)

black:
	-black -l 79 $(PYTHON_SOURCES)

Heap-Layers: ;
#	cd vendor && git clone https://github.com/emeryberger/Heap-Layers

printf/printf.cpp:
	copy printf/printf.c ptrintf/printf.cpp

vendor-deps: clear-vendor-dirs Heap-Layers printf/printf.cpp

clear-vendor-dirs:
	if exist vendor\ (rmdir /Q /S vendor)
	mkdir vendor

pkg: Heap-Layers printf/printf.cpp
	-rm -rf dist build *egg-info
	$(PYTHON) setup.py sdist bdist_wheel

upload: pkg # to pypi
	$(PYTHON) -m twine upload dist/*
