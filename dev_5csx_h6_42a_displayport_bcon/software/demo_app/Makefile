# Makefile for Basler pylon sample program
.PHONY: all clean

# The program to build
NAME       := demo_app

# Installation directories for pylon
PYLON_ROOT ?= /opt/pylon5

# Build tools and flags
LD         := $(CXX)
CPPFLAGS   := $(shell $(PYLON_ROOT)/bin/pylon-config --cflags)
CXXFLAGS   := #e.g., CXXFLAGS=-g -O0 for debugging
LDFLAGS    := $(shell $(PYLON_ROOT)/bin/pylon-config --libs-rpath)
LDLIBS     := $(shell $(PYLON_ROOT)/bin/pylon-config --libs)

#LIBFPGA
LIBFPGA	:= /home/mikew/projects/soc_camera/sw/ARM/libfpga

CPPFLAGS += -I${LIBFPGA}

# Rules for building
all: $(NAME)

$(NAME): main.o BCONInput.o ${LIBFPGA}/pll_reconfig.o GenICamModel.o VIPMixerII.o Filter2D.o
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)

.cpp.o: 
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

clean:
	$(RM) *.o $(NAME)
