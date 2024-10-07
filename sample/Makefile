UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
TARGET = ../bin/linux
endif
ifeq ($(UNAME), Darwin)
TARGET = ../bin/mac
endif

$(TARGET)/sample: sample.o
	g++ sample.o -o $(TARGET)/sample -I../include -L$(TARGET) -lhash -Wl,-rpath,.

sample.o: sample.cpp
	g++ sample.cpp -std=c++17 -c -o sample.o -I../include