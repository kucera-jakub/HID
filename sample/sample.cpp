#include "hash.h"
#include <iostream>
#include <chrono>
#include <thread>

#define CHECK_OK(res) if(res != HASH_ERROR_OK) { return 1; }

int main()
{
    size_t code = 0;
    char* line = nullptr;
    bool running = true;

    CHECK_OK(HashInit());
    CHECK_OK(HashDirectory(".", &code));
    while (HashStatus(code, &running) == HASH_ERROR_OK && running);
    while (HashReadNextLogLine(&line) == HASH_ERROR_OK)
    {
        std::cout << line << std::endl;
        HashFree(line);
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }
    CHECK_OK(HashStop(code));
    CHECK_OK(HashTerminate());
    return 0;
} 