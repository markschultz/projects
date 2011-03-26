#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>

#define SEMKEY 77

/*  This is the implementation of the wait() primitive. */
void W(int semkey)
{
    struct sembuf psembuf;

    psembuf.sem_op = -1;
    psembuf.sem_flg = 0;
    psembuf.sem_num = 0;
    semop(semkey,&psembuf,1);
    return;
}

/* This is the implementation of the signal() primitive. */
void S(int semkey)
{
    struct sembuf vsembuf;

    vsembuf.sem_op = 1;
    vsembuf.sem_flg = 0;
    vsembuf.sem_num = 0;
    semop(semkey,&vsembuf,1);
    return;
}

union semun {
        int             val;            /* value for SETVAL */
        struct semid_ds *buf;           /* buffer for IPC_STAT & IPC_SET */
        unsigned short  *array;         /* array for GETALL & SETALL */
};
void printm(char s[]){
	printf("%s\n",s);
	fflush(NULL);
	return;
}

//vars
int waitCar=0;
int passCar=0;
int light=0;
int trainc=0;
int cpassed=0;
int tpassed=0;

void carx(int mutex,int cwait)
{
	W(mutex);
	passCar--;
	printf("c passed, passCar=%d\n",passCar);
	if(light==0 && waitCar>0){
		S(cwait);
	}
	S(mutex);
}

void car(int mutex,int cwait)
{
	W(mutex);
	if(passCar<4 && light==0){//green.
		//now we can pass
		while(waitCar>0) {
			sleep(10);
		}
		passCar++;
		printf("c going to pass, passCar=%d\n",passCar);
		S(mutex);
		carx(mutex,cwait);
	} else {
		waitCar++;
		printf("c waiting, waitCar=%d\n",waitCar);
		S(mutex);
		W(cwait);
		S(mutex);
		waitCar--;
		passCar++;
		printf("cw going to pass, passCar=%d\n",passCar);
		S(mutex);
		carx(mutex,cwait);
	}
}

void trainx(int mutex, int twait, int cwait)
{
	W(mutex);
	trainc--;
	printf("t passed, trainc=%d\n",trainc);
	if(trainc>=1){
		light=1;//yellow
		printf("yellow\n");
		S(twait);
	} else {
		light = 0;//green
		printf("green\n");
		int i;
		for(i=0;i<waitCar;i++){
			if(i<4){
				S(cwait);
			}
		}
	}
	S(mutex);
}

void traina(int mutex, int twait, int cwait)
{
	W(mutex);
	light=2;//red
	printf("red\n");
	S(mutex);
	trainx(mutex,twait,cwait);
}

void train(int mutex,int twait,int cwait)
{
	W(mutex);
	trainc++;
	printf("t going to pass, trainc=%d\n",trainc);
	if(trainc==1){
		light=1;//yellow
		printf("yellow\n");
		S(mutex);
		sleep(10);//sleep to give cars time to finish
		traina(mutex,twait,cwait);
	} else {
		S(mutex);
		W(twait);
		traina(mutex,twait,cwait);
	}
}

int main()
{
	u_short seminit[3];
	seminit[0]=0;
	seminit[1]=0;
	seminit[2]=0;
	int mutex,carwait,trainwait;
    key_t key,key2,key3;
    union semun semctlarg,semctlarg2,semctlarg3;

    key=ftok(".", SEMKEY);//mutex
    mutex=semget(key,1,0777|IPC_CREAT);
    semctlarg.array=&seminit[0];
    semctl(mutex,1,SETALL,semctlarg);
	key2=ftok(".", SEMKEY);//carwait
    carwait=semget(key2,1,0777|IPC_CREAT);
    semctlarg2.array=&seminit[1];
    semctl(carwait,1,SETALL,semctlarg2);
	key3=ftok(".", SEMKEY);//trainwait
    trainwait=semget(key3,1,0777|IPC_CREAT);
    semctlarg3.array=&seminit[2];
    semctl(trainwait,1,SETALL,semctlarg3);
	S(mutex);//need initial value as 1
	int i;
	int forks[30];
	for(i=0;i<30;i++){//cars
		if((forks[i]=fork())==0){//child
			//sleep(10);//sleep should put them in a randomish order
			if(i>7 && i<22 && (i%2)==0){
				//printm("t\n");
				train(mutex,trainwait,carwait);
				fflush(NULL);
				_exit(1);
			}
			//printm("c\n");
			car(mutex,carwait);
			fflush(NULL);
			_exit(1);
		}
	}	
	for(i=0;i<30;i++){
		wait(NULL);//wait for all children
	}
    printf("Children have exited.  Cleaning up...\n");
    semctl(mutex,1,IPC_RMID,0);
	semctl(carwait,1,IPC_RMID,0);
	semctl(trainwait,1,IPC_RMID,0);
    return 0;
}