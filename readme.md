## Bugs:

### BUG01: Initializing already initialized library returns `HASH_ERROR_OK 0` instead of

`HASH_ERROR_ALREADY_INITIALIZED 8`

#### Test: `Test_Double_Initialization`

#### Steps:

1. Load the library
2. Initialize the Library => `HASH_ERROR_OK 0`
3. Initialize the Library for the second time

#### Expected Result:

`HASH_ERROR_ALREADY_INITIALIZED 8`

#### Actual Result:

`HASH_ERROR_OK 0`

---

### BUG02: DLL Returns wrong hash values

#### Test: `Test_Directory_Hash_Success`

#### Steps:

1. Load the library
2. Call the hashDirectory
3. Call the hashLib
4. Compare hashes

#### Expected Result:

Hashes are the same

#### Actual Result:

`0` is being removed for some hashes\
e.g\
`d41d8cd98f0b24e980998ecf8427e` - dll\
`d41d8cd98f00b204e9800998ecf8427e` - hash lib\

---

### BUG03: hashDirectory always uses the folder called from

#### Test: `Test_Directory_Hash_Success`

#### Steps:

1. Load the library
2. Call the hashDirectory with some absolute path
3. See the files hashed

#### Expected Result:

hashDirectory is called on given directory

#### Actual Result:

Directory used is directory script is called from

---

### BUG04: hashReadNextLogLine with None/NULL as lib doesnt return HASH_ERROR_ARGUMENT_NULL

#### Test: `Test_Log_Reading_Null_Argument`

#### Steps:

1. Load the library
2. Call the hashReadNextLogLine with NULL as lib

#### Expected Result:

hashReadNextLogLine returns `Return Code: 6 HASH_ERROR_ARGUMENT_NULL`

#### Actual Result:

hashReadNextLogLine returns `AttributeError: 'NoneType' object has no attribute 'HashReadNextLogLine'`

---

### BUG05: hashReadNextLogLine doesnt return HASH_ERROR_LOG_EMPTY when called before hashDirectory

#### Test: `Test_Log_Reading_Before_Hashing`

#### Steps:

1. Load the library
2. Call the hashReadNextLogLine without calling hashDirectory

#### Expected Result:

hashReadNextLogLine returns `Return Code: 4 HASH_ERROR_LOG_EMPTY`

#### Actual Result:

hashReadNextLogLine returns `Error Code: (1, b'')`

---

### BUG06: hashReadNextLogLine doesnt return HASH_ERROR_NOT_INITIALIZED

#### Test: `Test_Log_Reading_Before_Initialization`

#### Steps:

1. Load the library
2. Call the hashReadNextLogLine before initializing library

#### Expected Result:

hashReadNextLogLine returns `Return Code: 7 HASH_ERROR_NOT_INITIALIZED`

#### Actual Result:

hashReadNextLogLine returns `Error Code: (7, b'')`

Note:
`b''` could be something from wrapper as error code seems correct

---
