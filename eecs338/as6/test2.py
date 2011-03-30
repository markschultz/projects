import threading
import time
from multiprocessing import Value


def prints ():
    count=0
    while count < 5:
        time.sleep(5)
        lock.acquire()
        print "%d" % (num.value)
        count += 1
        lock.release()
def inc ():
    count=0
    while count < 30:
        time.sleep(1)
        lock.acquire()
        num.value += 1
        count += 1
        lock.release()

def exe ():
    global lock
    lock = threading.Lock()
    global num
    num = Value('i',1) # synchronized value ('i') for int, 1 for value
    t1 = threading.Thread(target=prints,args=())
    t2 = threading.Thread(target=inc,args=())
    t2.start()
    t1.start()
    t1.join()
    t2.join()
    print "%d" % (num.value)
exe()
