
#include <stdint.h>
#include <stddef.h>

#if _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

extern "C"
{
    /**
     * @brief Success
     */
    #define HASH_ERROR_OK 0
    /**
     * @brief Unknown error
     */
    #define HASH_ERROR_GENERAL 1
    /**
     * @brief Standard exception encountered
     */
    #define HASH_ERROR_EXCEPTION 2
    /**
     * @brief Memory allocation failed
     */
    #define HASH_ERROR_MEMORY 3
    /**
     * @brief Reading an empty log
     */
    #define HASH_ERROR_LOG_EMPTY 4
    /**
     * @brief Invalid argument passed to a function
     */
    #define HASH_ERROR_ARGUMENT_INVALID 5
    /**
     * @brief Empty argument passed to a function
     */
    #define HASH_ERROR_ARGUMENT_NULL 6
    /**
     * @brief Library is not initialized
     */
    #define HASH_ERROR_NOT_INITIALIZED 7
    /**
     * @brief Library is already initialized
     */
    #define HASH_ERROR_ALREADY_INITIALIZED 8

    /**
     * @brief Initialize the library, must be called before any other functin from the library
     * 
     * @return uint32_t Error code, possible errors - HASH_ERROR_EXCEPTION, HASH_ERROR_ALREADY_INITIALIZED
     */
    EXPORT
    uint32_t HashInit();

    /**
     * @brief Terminate the library, must be called as the last function from the library
     * 
     * @return uint32_t Error code, possible errors - HASH_ERROR_EXCEPTION, HASH_ERROR_NOT_INITIALIZED
     */
    EXPORT
    uint32_t HashTerminate();

    /**
     * @brief Hash all files in the specified directory, the content of the file is hashed using the MD5 algorithm
     * 
     * This operation is not blocking, when initiated, it runs in parallel and hashes the content of each file in
     * the specified directory. The operation status can be obtained be calling HashStatus. The operation can be 
     * stopped by calling HashStop. The result of the opertaion is stored in an internal log and can be obtained 
     * by calling HashReadNextLogLine.
     * 
     * @param directory [in] Path to the target directory, can be absolute or relative path, must not be NULL
     * @param id [in] Operation identifier, must not be NULL
     * @return uint32_t Error code, possible errors - HASH_ERROR_EXCEPTION, HASH_ERROR_ARGUMENT_NULL, HASH_ERROR_NOT_INITIALIZED, HASH_ERROR_ARGUMENT_INVALID
     */
    EXPORT
    uint32_t HashDirectory(const char* directory, size_t* id);

    /**
     * @brief Get the next line in the log, if present
     * 
     * @param hash [out] Next log line, must be freed by HashFree, must not be NULL
     * @return uint32_t Error code, possible errors - HASH_ERROR_MEMORY, HASH_ERROR_LOG_EMPTY, HASH_ERROR_EXCEPTION, HASH_ERROR_ARGUMENT_NULL, HASH_ERROR_NOT_INITIALIZED
     */
    EXPORT
    uint32_t HashReadNextLogLine(char** hash);

    /**
     * @brief Get status of an operation
     * 
     * @param id [in] Identifier of the operation
     * @param operations [out] Flag indicating if the operation is running, must not be NULL
     * @return uint32_t Error code, possible errors - HASH_ERROR_EXCEPTION, HASH_ERROR_ARGUMENT_NULL, HASH_ERROR_NOT_INITIALIZED, HASH_ERROR_ARGUMENT_INVALID
     */
    EXPORT
    uint32_t HashStatus(size_t id, bool* running);

    /**
     * @brief Stop specified operation
     * 
     * @param id [in] Operation identifier
     * @return uint32_t Error code, possible errors - HASH_ERROR_ARGUMENT_INVALID, HASH_ERROR_EXCEPTION, HASH_ERROR_NOT_INITIALIZED
     */
    EXPORT
    uint32_t HashStop(size_t id);

    /**
     * @brief Release memory allocated by functions in this library
     * 
     * @param hash [in] Memory to release
     */
    EXPORT
    void HashFree(void* hash);
}
