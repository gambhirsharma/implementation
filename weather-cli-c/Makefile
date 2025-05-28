CC = gcc
CFLAGS = -Wall -Wextra

# Define object files
OBJ = main.o weather.o

# Define the final executable name
TARGET = weather

# Rule to compile .c files to .o files
%.o: %.c
	$(CC) $(CFLAGS) -c $<

# Rule to link object files and create the executable
$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ) -lcurl

# Clean rule
clean:
	rm -f $(OBJ) $(TARGET)
