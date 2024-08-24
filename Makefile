LIBNAME = scalene
PYTHON = python3
PYTHON_SOURCES = scalene/[a-z]*.py
C_SOURCES = src/source/get_line_atomic.cpp src/include/*.h* # src/source/libscalene.cpp 

CXXFLAGS = /Ox /DNDEBUG /std:c++14 /Zi
CXX = cl

MAIN_INCLUDES  = -Isrc -Isrc/include
INCLUDES = $(MAIN_INCLUDES) -Ivendor/Heap-Layers -Ivendor/Heap-Layers/wrappers -Ivendor/Heap-Layers/utility -Ivendor/printf

LIBFILE = lib$(LIBNAME).dll
WRAPPER = # vendor/Heap-Layers/wrappers/gnuwrapper.cpp

SRC = src/source/lib$(LIBNAME).cpp $(WRAPPER) vendor/printf/printf.cpp

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

vendor/Heap-Layers: ;

vendor/printf/printf.cpp: ;

vendor-deps: clear-vendor-dirs vendor/Heap-Layers vendor/printf/printf.cpp

clear-vendor-dirs: ;

pkg: vendor/Heap-Layers vendor/printf/printf.cpp
	-rm -rf dist build *egg-info
	$(PYTHON) setup.py sdist bdist_wheel

upload: pkg # to pypi
	$(PYTHON) -m twine upload dist/*
