*** Settings ***
Library         ./wrapper/wrapper.py

Test Timeout    20 seconds


*** Variables ***
${DLL_RELATIVE_PATH}                ./bin/windows/hash.dll
${DLL_ABSOLUTE_PATH}                D:/git-repos/HID/bin/windows/hash.dll
${DLL_PATH}                         ${DLL_ABSOLUTE_PATH}
${HASH_DIRECTORY_ABSOLUTE_PATH}     D:\\git-repos\\HID\\hash_dir
${HASH_DIRECTORY_RELATIVE_PATH}     .
${HASH_DIRECTORY_NULL_PATH}         ${None}
${HASH_DIRECTORY_INVALID_PATH}      X:\\InvalidDir


*** Test Cases ***
# --- Initialization Tests ---
Test_Initialization_Success
    [Documentation]    Verify successful initialization of the hash library.
    [Tags]    initialization, success
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Init    ${lib}
    Log To Console    \n***Error Code: ${errorCode}***
    Should Be Equal As Integers    ${errorCode}    0

Test_Double_Initialization
    [Documentation]    Verify that initializing the library twice returns 8: "HASH_ERROR_ALREADY_INITIALIZED"
    [Tags]    initialization, failure
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Init    ${lib}
    ${errorCode}    Run Keyword And Ignore Error    Hash Init    ${lib}
    Log To Console    \n***Error Code: ${errorCode}***
    Should Be Equal    ${errorCode}    ('FAIL', 'KeyError: 8')

Test_Terminate_Before_Initialization
    [Documentation]    Verify that terminating the library before initialization returns 7: "HASH_ERROR_NOT_INITIALIZED"
    [Tags]    initialization, failure
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Terminate    ${lib}
    Log To Console    \n***Error Code: ${errorCode}***
    Should Be Equal As Integers    ${errorCode}    7

# --- Termination Tests ---

Test_Termination_Success
    [Documentation]    Verify successful termination of the hash library.
    [Tags]    termination, success
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Init    ${lib}
    ${errorCode}    Hash Terminate    ${lib}
    Log To Console    \n***Error Code: ${errorCode}***
    Should Be Equal As Integers    ${errorCode}    0

Test_Double_Termination
    [Documentation]    Verify that terminating the library twice returns 7: "HASH_ERROR_NOT_INITIALIZED"
    [Tags]    termination, failure
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Init    ${lib}
    ${errorCode}    Hash Terminate    ${lib}
    ${errorCode}    Hash Terminate    ${lib}
    Log To Console    \n***Error Code: ${errorCode}***
    Should Be Equal As Integers    ${errorCode}    7

# --- Hashing Tests ---

Test_Directory_Hash_Success
    [Documentation]    Verify successful hashing of the specified relative directory.
    [Tags]    hashing, success, log reading
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Init    ${lib}
    Log To Console    \n***Library loaded and initialized. Starting hashing on: ${HASH_DIRECTORY_RELATIVE_PATH}***
    ${errorCode}    ${opID}    Hash Directory    ${lib}    ${HASH_DIRECTORY_RELATIVE_PATH}
    Should Be Equal As Integers    ${errorCode}    0
    ${errorCode}    ${status}    Wait For Hash To Finish    ${lib}    ${opID}
    Should Be Equal As Integers    ${errorCode}    0
    Should Be Equal    ${status}    ${False}
    ${dllHashes}    Read Hash Log    ${lib}
    ${realHashes}    Md 5 Files In Directory    ${HASH_DIRECTORY_RELATIVE_PATH}
    ${hashCompareStatus}    ${dllHashes}    ${realHashes}    Is Hash Present    ${dllHashes}    ${realHashes}
    Log To Console    \n***DLL Hashes: ${dllHashes}***
    Log To Console    \n***Real Hashes: ${realHashes}***
    Should Be Equal    ${hashCompareStatus}    ${True}    ERROR: DLL Hashes do not match

Test_Directory_Hash_Null_Argument
    [Documentation]    Verify that hashing with a NULL directory argument returns 6: "HASH_ERROR_ARGUMENT_NULL"
    [Tags]    hashing, failure
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Init    ${lib}
    Log To Console    \n***Library loaded and initialized. Starting hashing on: ${HASH_DIRECTORY_NULL_PATH}***
    ${errorCode}    ${opID}    Hash Directory    ${lib}    ${HASH_DIRECTORY_NULL_PATH}
    Log To Console    \n***Error Code: ${errorCode}***
    Log To Console    \n***Process ID: ${opID}***
    Should Be Equal As Integers    ${errorCode}    6
    Should Be Equal As Integers    ${opID}    0

Test_Directory_Hash_Before_Initialization
    [Documentation]    Verify that hashing before initializing the library returns 7: "HASH_ERROR_NOT_INITIALIZED"
    [Tags]    hashing, failure
    ${lib}    Load Hash Library    ${DLL_PATH}
    Log To Console    \n***Library loaded and initialized. Starting hashing on: ${HASH_DIRECTORY_RELATIVE_PATH}***
    ${errorCode}    ${opID}    Hash Directory    ${lib}    ${HASH_DIRECTORY_RELATIVE_PATH}
    Log To Console    \n***Error Code: ${errorCode}***
    Log To Console    \n***Process ID: ${opID}***
    Should Be Equal As Integers    ${errorCode}    7
    Should Be Equal As Integers    ${opID}    0

Test_Invalid_Directory_Path
    [Documentation]    Verify that hashing with an invalid directory path returns 5: "HASH_ERROR_ARGUMENT_INVALID"
    [Tags]    hashing, failure
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Init    ${lib}
    Log To Console    \n***Library loaded and initialized. Starting hashing on: ${HASH_DIRECTORY_INVALID_PATH}***
    ${errorCode}    ${opID}    Hash Directory    ${lib}    ${HASH_DIRECTORY_INVALID_PATH}
    Log To Console    \n***Error Code: ${errorCode}***
    Log To Console    \n***Process ID: ${opID}***
    Should Be Equal As Integers    ${errorCode}    5
    Should Be Equal As Integers    ${opID}    0

# --- Read Log Tests ---

Test_Log_Reading_Null_Argument
    [Documentation]    Verify that reading a log line with a NULL argument returns an appropriate error.
    [Tags]    log reading, failure
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Init    ${lib}
    Log To Console    \n***Library loaded and initialized. Starting hashing on: ${HASH_DIRECTORY_RELATIVE_PATH}***
    ${errorCode}    ${opID}    Hash Directory    ${lib}    ${HASH_DIRECTORY_RELATIVE_PATH}
    Should Be Equal As Integers    ${errorCode}    0
    ${errorCode}    ${status}    Wait For Hash To Finish    ${lib}    ${opID}
    Should Be Equal As Integers    ${errorCode}    0
    Should Be Equal    ${status}    ${False}
    ${errorCode}    Hash Read Next Log Line    ${None}
    Log To Console    \n***Error Code: ${errorCode}***

Test_Log_Reading_Before_Hashing
    [Documentation]    Verify that reading a log line before hashing returns 4: "HASH_ERROR_LOG_EMPTY"
    [Tags]    log reading, failure
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Init    ${lib}
    ${errorCode}    Hash Read Next Log Line    ${lib}
    Log To Console    \n***Error Code: ${errorCode}***
    Should Be Equal    ${errorCode}    4

Test_Log_Reading_Before_Initialization
    [Documentation]    Verify that reading a log line before initializing the library returns 7: "HASH_ERROR_NOT_INITIALIZED"
    [Tags]    log reading, failure
    ${lib}    Load Hash Library    ${DLL_PATH}
    ${errorCode}    Hash Read Next Log Line    ${lib}
    Log To Console    \n***Error Code: ${errorCode}***
    Should Be Equal    ${errorCode}    7
