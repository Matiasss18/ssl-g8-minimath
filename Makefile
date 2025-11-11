# Makefile for minimath scanner

# Compiler and flags
CC = gcc
CFLAGS = -Wall -g

# Flex and flags
LEX = flex
LFLAGS =

# Linker flags
LIBS = -lfl

# Source files
LEX_SRC = minimath.l
C_SRC = minimath.yy.c

# Target executable
TARGET = minimath

# Default target
all: $(TARGET)

# Rule to link the object file into the final executable
$(TARGET): $(C_SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(C_SRC) $(LIBS)

# Rule to generate the C source from the Flex file
$(C_SRC): $(LEX_SRC)
	$(LEX) $(LFLAGS) -o $(C_SRC) $(LEX_SRC)

# Rule to run the scanner on a test file
run: $(TARGET)
	./$(TARGET) test.minimath

# Clean up generated files
clean:
	rm -f $(TARGET) $(C_SRC)

.PHONY: all clean run
