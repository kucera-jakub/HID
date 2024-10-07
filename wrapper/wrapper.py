#
# IMPORTANT: To load 32-bit DLL, use 32-bit Python!
#
import ctypes
import time
import hashlib
import os

ReturnCodes = {
    0: "HASH_ERROR_OK",
    1: "HASH_ERROR_GENERAL",
    2: "HASH_ERROR_EXCEPTION",
    3: "HASH_ERROR_MEMORY",
    4: "HASH_ERROR_LOG_EMPTY",
    5: "HASH_ERROR_ARGUMENT_INVALID",
    6: "HASH_ERROR_ARGUMENT_NULL",
    7: "HASH_ERROR_NOT_INITIALIZED",
    8: "HASH_ERROR_ALREADY_INITIALIZED",
}


def loadHashLibrary(libFullPath):
    try:
        lib = ctypes.cdll.LoadLibrary(libFullPath)
    except FileNotFoundError as e:
        print("Library file not found.")
        raise e
    except OSError as e:
        print(
            "Library cannot be loaded. System will exit without calling the hash routines."
        )
        raise e
    except Exception as e:
        print(e)
        raise e
    else:
        print("\nLibray loaded successfully.")
        return lib


def hashInit(library):
    returnCode = library.HashInit()
    print("\nHashInit Return code: {}.".format(ReturnCodes[returnCode]))
    return returnCode


def hashTerminate(library):
    returnCode = library.HashTerminate()
    print("\nHashTerminate Return code: {}.".format(ReturnCodes[returnCode]))
    return returnCode


def hashDirectory(library, directoryFullPath):
    opID = ctypes.c_size_t(0)

    returnCode = library.HashDirectory(
        ctypes.c_wchar_p(directoryFullPath), ctypes.byref(opID)
    )
    print(
        "\nHashDirectory Return code: {}, Operation ID: {}.".format(
            ReturnCodes[returnCode], opID.value
        )
    )
    return returnCode, int(opID.value)


def hashReadNextLogLine(library):
    HASHLENGTHINBYTE = 64
    HashFunction = library.HashReadNextLogLine
    HashFunction.argtypes = [ctypes.POINTER(ctypes.c_char_p)]

    logLine = ctypes.c_char_p()
    buffer = (ctypes.c_char * (HASHLENGTHINBYTE + 1))()
    returnCode = library.HashReadNextLogLine(ctypes.byref(logLine))

    if returnCode == 0:
        ctypes.memmove(buffer, logLine, (HASHLENGTHINBYTE + 1))
        library.HashFree(logLine)

    # When returnCode is 0 ('HASH_ERROR_OK'), buffer contains w_char array terminated by a null character
    return returnCode, buffer.value


def hashStop(library, opID):
    returnCode = library.HashStop(ctypes.c_size_t(opID))
    print("\nHashStop Return code: {}.".format(ReturnCodes[returnCode]))
    return returnCode


def hashStatus(library, opID):
    opRunning = ctypes.c_bool(False)

    returnCode = library.HashStatus(ctypes.c_size_t(opID), ctypes.byref(opRunning))
    return returnCode, bool(opRunning)


def waitForHashToFinish(library, opID):
    while True:
        returnCode, status = hashStatus(library, opID)
        assert returnCode == 0
        if status == False:
            break
    print("***Error Code:", returnCode)
    print("***Status:", status)
    print("Hashing finished!")
    return returnCode, status


def readHashLog(library):
    print("")
    hashes = []
    while True:
        returnCode, logLine = hashReadNextLogLine(library)
        if int(returnCode) == 0:
            hashes.append(extractHashes(logLine))
            # print('HashReadNextLogLine: {}.'.format(logLine))
        else:
            break
    return hashes


def extractHashes(output):
    decodedOutput = output.decode("utf-8")
    hashValue = decodedOutput.split()[-1]
    return hashValue


def md5File(filePath):
    md5Hash = hashlib.md5()
    with open(filePath, "rb") as file:
        # Read the file in chunks to avoid using too much memory
        for chunk in iter(lambda: file.read(4096), b""):
            md5Hash.update(chunk)
    return md5Hash.hexdigest()


def md5FilesInDirectory(directoryPath):
    fileHashes = []

    # List files only in the specified directory (no subdirectories)
    for file in os.listdir(directoryPath):
        # Get the full file path
        filePath = os.path.join(directoryPath, file)

        # Ensure we are only hashing files (not directories)
        if os.path.isfile(filePath):
            # Compute the MD5 hash for the file and store it
            fileHashes.append(md5File(filePath))

    return fileHashes


def isHashPresent(md5Hashes, md5RealHashes):
    areAllPresent = True
    md5HashesLower = [md5.lower() for md5 in md5Hashes]
    md5RealHashesLower = [md5.lower() for md5 in md5RealHashes]
    print("****DLL", md5HashesLower)
    print("****REAL", md5RealHashesLower)
    for md5 in md5HashesLower:
        if md5 not in md5RealHashesLower:
            print(f"Hash {md5} is NOT in md5realhashes.")
            areAllPresent = False
    return areAllPresent, md5HashesLower, md5RealHashesLower
