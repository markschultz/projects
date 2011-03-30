import time
from threading import Thread, Lock
from multiprocessing import Value

class worker(Thread):
    def run(self):
        count=0
        while count < 5:
            #lock.acquire()
            time.sleep(5)
            print "%d" % (share.value)
            #lock.release()

class waiter(Thread):
    def run(self):
        count=0
        while count < 50:
            #lock.acquire()
            share.value += 1
            print "inc"
            time.sleep(1)
            #lock.release()
         
lock = Lock()
global share
share = Value('i',2)
def exe():
    worker().start()
    waiter().start()
