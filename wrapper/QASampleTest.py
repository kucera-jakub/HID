import ctypes
import wrapper
import sys

def readhashLog(library):
    print('')
    while True:
        returnCode, logLine = wrapper.hashReadNextLogLine(library)
        if (int(returnCode) == 0): 
            print('HashReadNextLogLine: {}.'.format(logLine))
        else:
            break
    return 


def waitforHashDirectory(library, opID:int):
    while True:
        returnCode, opRunning = wrapper.hashStatus(library, opID)
        if ((int(returnCode) != 0) or (opRunning != True)): 
            break
    print('\nHashDirectory has finished.')
    return True
            

if __name__ == "__main__":
    try: 
        lib = wrapper.loadHashLibrary("..\\bin\\windows\\hash.dll")
        wrapper.hashInit(lib)
        returnCode, ID = wrapper.hashDirectory(lib, ".")
        if (returnCode == 0):
            ret = waitforHashDirectory(lib, ID)
            if (ret):
                readhashLog(lib)
                wrapper.hashStop(lib, ID)
        wrapper.hashTerminate(lib)
    except Exception as e:
        print(e)
        sys.exit("\nSystem exited with an error condition.\n")
    else:
        sys.exit("\nSystem exited successfully.\n")
   
