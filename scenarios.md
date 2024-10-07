### Test Scenarios:

# Test Plan for DLL

## Initialization Tests

1. **Test Initialization Success**

    - **Test Name:** `Test_Initialization_Success`
    - Call `HashInit()` and expect `HASH_ERROR_OK` (success).

2. **Test Double Initialization**

    - **Test Name:** `Test_Double_Initialization`
    - Call `HashInit()` twice, expect the first call to return `HASH_ERROR_OK` and the second call to return
      `HASH_ERROR_ALREADY_INITIALIZED`.

3. **Test Terminate Before Initialization**

    - **Test Name:** `Test_Terminate_Before_Initialization`
    - Call `HashTerminate()` without calling `HashInit()` first, expect `HASH_ERROR_NOT_INITIALIZED`.

## Termination Tests

1. **Test Termination Success**

    - **Test Name:** `Test_Termination_Success`
    - Call `HashTerminate()` after calling `HashInit()`, expect `HASH_ERROR_OK`.

2. **Test Double Termination**

    - **Test Name:** `Test_Double_Termination`
    - Call `HashTerminate()` twice, expect the first call to return `HASH_ERROR_OK` and the second call to return
      `HASH_ERROR_NOT_INITIALIZED`.

## Directory Hashing Tests

1. **Test Directory Hash Success**

    - **Test Name:** `Test_Directory_Hash_Success`
    - Call `HashDirectory()` with a valid directory, expect `HASH_ERROR_OK`.

2. **Test Directory Hash Null Argument**

    - **Test Name:** `Test_Directory_Hash_Null_Argument`
    - Call `HashDirectory()` with `NULL` directory, expect `HASH_ERROR_ARGUMENT_NULL`.

3. **Test Directory Hash Before Initialization**

    - **Test Name:** `Test_Directory_Hash_Before_Initialization`
    - Call `HashDirectory()` without calling `HashInit()`, expect `HASH_ERROR_NOT_INITIALIZED`.

4. **Test Invalid Directory Path**

    - **Test Name:** `Test_Invalid_Directory_Path`
    - Call `HashDirectory()` with an invalid directory, expect `HASH_ERROR_ARGUMENT_INVALID`.

## Log Reading Tests

1. **Test Log Reading Success**

    - **Test Name:** `Test_Directory_Hash_Success`
    - After successful hashing, call `HashReadNextLogLine()`, expect `HASH_ERROR_OK`.

2. **Test Log Reading Null Argument**

    - **Test Name:** `Test_Log_Reading_Null_Argument`
    - Call `HashReadNextLogLine()` with `NULL` argument, expect `HASH_ERROR_ARGUMENT_NULL`.

3. **Test Log Reading Before Hashing**

    - **Test Name:** `Test_Log_Reading_Before_Hashing`
    - Call `HashReadNextLogLine()` without any previous hashing operation, expect `HASH_ERROR_LOG_EMPTY`.

4. **Test Log Reading Before Initialization**

    - **Test Name:**
    - Call `HashReadNextLogLine()` without calling `HashInit()`, expect `HASH_ERROR_NOT_INITIALIZED`.

---

## Operation Status Tests

1. **Test Operation Status Success**

    - **Test Name:**
    - Call `HashStatus()` with a valid operation ID, expect `HASH_ERROR_OK`.

2. **Test Operation Status Null Argument**

    - **Test Name:**
    - Call `HashStatus()` with `NULL` running flag, expect `HASH_ERROR_ARGUMENT_NULL`.

3. **Test Operation Status Invalid ID**

    - **Test Name:**
    - Call `HashStatus()` with an invalid operation ID, expect `HASH_ERROR_ARGUMENT_INVALID`.

## Stop Operation Tests

1. **Test Stop Operation Success**

    - **Test Name:**
    - Call `HashStop()` with a valid operation ID while the operation is running, expect `HASH_ERROR_OK`.

2. **Test Stop Operation Invalid ID**

    - **Test Name:**
    - Call `HashStop()` with an invalid operation ID, expect `HASH_ERROR_ARGUMENT_INVALID`.

3. **Test Stop Operation Before Initialization**

    - **Test Name:**
    - Call `HashStop()` without calling `HashInit()`, expect `HASH_ERROR_NOT_INITIALIZED`.

## Memory Management Tests

1. **Test Memory Freeing Success**

    - **Test Name:**
    - After reading a log line with `HashReadNextLogLine()`, call `HashFree()` to release the memory.

2. **Test Null Memory Freeing**

    - **Test Name:**
    - Call `HashFree()` with `NULL`, ensure it does not crash or cause issues.

## Error Handling Tests

1. **Test Exception Handling**

    - **Test Name:**
    - Trigger an exception scenario in any of the functions and verify that `HASH_ERROR_EXCEPTION` is returned.
