"""
This was one of my first attempts at python so this probably isnt very elegant.
I decided to learn how to use the multiprocessing.Value class. This is
basically a thread safe shared memory. I realize that with the mutex this is
redundant but I wanted to learn how to use it. In the main method you'll see
that I spawn 30 vehicles of which about 1/3 are trains. I figured a long
string of completely random spawns would reveal more bugs than fixed scenarios.
I also found that sleeping will sleep a single thread and not all threads so
this is usefull as long as its outside of the mutex.
"""
import threading
import time
import random
from multiprocessing import Value


def car():
    mutex.acquire()
    if(passcar.value<4 and light.value==0 and waitcar.value<4):
        passcar.value+=1
        print "passcar++,now=%d"%passcar.value
    else:
        waitcar.value+=1
        print "waitcar++,now=%d"%waitcar.value
        mutex.release()
        carwait.acquire()
        mutex.acquire()
        waitcar.value-=1
        print "waitcar--,now=%d"%waitcar.value
        passcar.value+=1
        print "passcar++,now=%d"%passcar.value
    mutex.release()
    time.sleep(random.randint(1,8))
    carx()

def carx():
    mutex.acquire()
    passcar.value-=1
    print "car passed car=%d"%passcar.value
    if(light.value==0 and waitcar.value>0):
        carwait.release()
    mutex.release()

def train():
    mutex.acquire()
    traincnt.value+=1
    print "traincnt++,now=%d"%traincnt.value
    if(traincnt.value==1):
        light.value=1
        print "YELLOW LIGHT"
        mutex.release()
        while passcar.value>0:
            pass #nop
        trainac()
    else:
        mutex.release()
        time.sleep(random.randint(1,8))
        trainwait.acquire()
        trainac()

def trainac():
    mutex.acquire()
    light.value=2
    print "RED LIGHT"
    mutex.release()
    time.sleep(random.randint(1,8))
    trainx()

def trainx():
    mutex.acquire()
    traincnt.value-=1
    print "train passed cnt=%d"%traincnt.value
    if(traincnt.value>=1):
        light.value=1
        print "YELLOW LIGHT"
        trainwait.release()
    else:
        light.value=0
        print "GREEN LIGHT"
        if(waitcar.value==1):
            carwait.release()
            print "carwait released"
        elif(waitcar.value==2):
            carwait.release()
            carwait.release()
            print "carwait released x2"
        elif(waitcar.value==3):
            carwait.release()
            carwait.release()
            carwait.release()
            print "carwait released x3"
        elif(waitcar.value>=4):
            carwait.release()
            carwait.release()
            carwait.release()
            carwait.release()
            print "carwait released x4"
    mutex.release()

def main():
    print "Mark Schultz (mxs802)"
    global mutex, trainwait, carwait
    mutex=threading.Semaphore(1)
    carwait=threading.Semaphore(0)
    trainwait=threading.Semaphore(0)
    global waitcar, passcar, traincnt, light
    waitcar = Value('i',0)# 'i' for integer and 0 for the value
    passcar = Value('i',0)
    traincnt = Value('i',0)
    light = Value('i',0) # 0=g,1=y,2=r

    # now generate threads.
    threads = [] # a list of the threads
    for x in range(30): # 30 threads
        if (random.randint(1,3)%3==0):#30% chance of train
            t = threading.Thread(target=train,args=())
            threads.append(t)
            time.sleep(6) # dont want to just flood everything in at once
            t.start()
            print "train spawned"
        else:
            c = threading.Thread(target=car,args=())
            threads.append(c)
            time.sleep(2)
            c.start()
            print "car spawned"

    """
    mutex.acquire()
    for s in threads:
        s.start()
        print "thread started"
    mutex.release()
    """
    for s in threads:
        s.join()
        print "thread ended"

    print "All Done. Exiting."


if __name__ == '__main__':
    main()


