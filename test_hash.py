import ctypes
import pytest
import string
from wrapper import wrapper

libRelPath = ".\\bin\\windows\\hash.dll"
libFullPath = "D:\\git-repos\\HID\\bin\\windows\\hash.dll"
libPath = libFullPath
hashDirRelPath = ".\\hash_dir"
hashDirFullPath = "D:\\git-repos\\HID\\hash_dir"
hashDirPath = hashDirRelPath

lib = wrapper.loadHashLibrary(libPath)


# ---Initialization Tests---


# Test - Initializing provided library
def test_initialization_success():
    returnCode = wrapper.hashInit(lib)
    assert returnCode == 0


# Test - Initializing already initialized library
def test_double_initialization():
    returnCode = wrapper.hashInit(lib)
    assert returnCode == 0
    returnCode = wrapper.hashInit(lib)
    assert returnCode == 8


# Test - Call the action (Terminate) before initialization
def test_terminate_before_initialization():
    returnCode = wrapper.hashTerminate(lib)
    assert returnCode == 7


# ---Termination Tests---


# Test - Terminate the library
def test_termination_success():
    returnCode = wrapper.hashInit(lib)
    assert returnCode == 0
    returnCode = wrapper.hashTerminate(lib)
    assert returnCode == 0


# Test - Terminate already Terminated library
def test_double_termination():
    returnCode = wrapper.hashInit(lib)
    assert returnCode == 0
    returnCode = wrapper.hashTerminate(lib)
    assert returnCode == 0
    returnCode = wrapper.hashTerminate(lib)
    assert returnCode == 7


# ---Hashing Tests---


# Test - Hash the directory
def test_directory_hash_success():
    returnCode = wrapper.hashInit(lib)
    assert returnCode == 0
    returnCode, opID = wrapper.hashDirectory(lib, hashDirPath)
    assert returnCode == 0
    returnCode, status = wrapper.waitForHashToFinish(lib, opID)
    assert returnCode == 0
    assert status == False
    md5hashes = wrapper.readHashLog(lib)
    realmd5hashes = wrapper.md5FilesInDirectory(".")
    areAllPresent = wrapper.isHashPresent(md5hashes, realmd5hashes)
    # print("\n****dll", md5hashes)
    # print("\n****real", realmd5hashes)
    assert areAllPresent == True
