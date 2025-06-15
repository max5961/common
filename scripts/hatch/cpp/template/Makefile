CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -MMD
TARGET := build/main
SRC := $(wildcard src/*.cpp)
OBJ := $(patsubst src/%.cpp, build/%.o, $(SRC))
DEPS := $(OBJ:.o=.d)

$(TARGET): $(OBJ) | build
	$(CXX) $(CXXFLAGS) -o $@ $^

build/%.o: src/%.cpp | build
	$(CXX) $(CXXFLAGS) -Iinclude -c $< -o $@

build:
	mkdir -p build

-include $(DEPS)

.PHONY: clean run

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf build
