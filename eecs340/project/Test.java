import java.util.Scanner;
import java.util.Random;
import java.io.*;

public class Test
{
       public static void main(String[] args)
       {
               // code
               int[] n = new int[10000];
               long[] results = new long[10000];
               Random gen = new Random();
               boolean print = false;
               int sort = 0;
               int nlen = 0;
               for (int i=0;i<args.length;i++) {
               	       if (args[i].equals("quick")) {
               	       	       sort =1; 
               	               nlen=1000;
               	       }
               	       else if (args[i].equals("merge")) {
               	       	       sort =0; 
               	       	       nlen=10000;
               	       }
               	       else if (args[i].equals("print")) print = true;
               }
               for (int i=0; i<10000; i++) {
               	      
               	      n[i]= gen.nextInt(nlen)+1;
               	      int[] a = buildArray(n[i]);
               	      if (i % 1000 == 0 ) System.out.print(i/100+"% ");
               	      long startTime = 0;
               	      switch(sort) {
               	      case 1: startTime = System.nanoTime(); QuickSort(a,0,a.length-1);
               	      case 0: startTime = System.nanoTime(); MergeSort(a,0,a.length-1);
               	      //default: startTime = System.nanoTime(); MergeSort(a,0,a.length-1);
               	      }
		      long elapsedTime = System.nanoTime() - startTime;
		      results[i] = elapsedTime;
	       }
	       if (print) { 
	       	       printResults(n,results,n.length);
	       } else {
	       	       csvOut(n,results);
	       }
	       return;
       }
     
       
       public static void csvOut(int[] n, long[] r) 
       {
       	       FileOutputStream fout;
       	       PrintStream p;
       	       try {
       	       	       fout = new FileOutputStream("out.csv");
       	       	       p = new PrintStream(fout);
       	       	       for(int i = 0; i < n.length; i++) {
       	       	       	       p.println(n[i]+","+r[i]+","+(n[i]*(Math.log((double) n[i])/Math.log((double) 2)))+","+(r[i]/(n[i]*(Math.log((double) n[i])/Math.log((double) 2)))));
		       }
		       p.close();
       	       } catch (Exception e) { System.out.println("error with fileout:"+e); }
       }
       public static void printResults(int[] n, long[] r, int num) {
       	       System.out.println("\n n:\t actual:\t nlgn:\t ratio:\n");
       	       for (int i = 0;i<num;i++) {
       	       	       System.out.println(n[i]+"\t"+r[i]+"\t"+(n[i]*(Math.log((double) n[i])/Math.log((double) 2)))+"\t"+r[i]/(n[i]*(Math.log((double) n[i])/Math.log((double) 2))));
       	       }
       	       System.out.println("\n");
       	       //print sum total
       	       float tempn=0, tempa=0, templ=0;
       	       for (int i=0;i<n.length;i++) {
       	       	       tempn += n[i];
       	       	       tempa += r[i]/n.length;
       	       	       templ += n[i]*(Math.log((double) n[i])/Math.log((double) 2))/n.length;
       	       }
       	       System.out.println(tempn/n.length+"\t"+tempa+"\t"+templ+"\t"+tempa/templ+"\t END");
       }
       
       public static int[] buildArray(int size) {
       	       int[] randa = new int[size];
       	       Random genb = new Random(100000);
       	       for (int i = 0; i<genb.nextInt();i++) {
       	       	       randa[i] = genb.nextInt();
       	       }
       	       //array is now of random length and w/ random ints
       	       return randa;
       }

       public static void QuickSort(int[] A, int p, int r)
       {
               if (p < r)
               {
                       int q = Partition(A, p, r);
                       QuickSort(A, p, q - 1);
                       QuickSort(A, q + 1, r);
               }
       }

       public static int Partition(int[] A, int p, int r)
       {
               int x = A[r];
               int i = p - 1;

               for (int j = p; j < r; j++)
               {
                       if (A[j] <= x)
                       {
                               i++;

                               // swap
                               int temp = A[i];
                               A[i] = A[j];
                               A[j] = temp;
                       }
               }

               int temp = A[i + 1];
               A[i + 1] = A[r];
               A[r] = temp;

               return i + 1;
       }

       public static void MergeSort(int[] A, int p, int r)
       {
               if (p < r)
               {
                       int q = (p + r) / 2;
                       MergeSort(A, p, q);
                       MergeSort(A, q + 1, r);
                       Merge(A, p, q, r);
               }
       }

       public static void Merge(int[] A, int p, int q, int r)
       {
               int n1 = q - p + 1;
               int n2 = r - q;

               int[] L = new int[n1];
               for (int i = 0; i < L.length; i++)
               {
                       L[i] = A[p + i];
               }

               int[] R = new int[n2];
               for (int i = 0; i < R.length; i++)
               {
                       R[i] = A[q + 1 + i];
               }

               int i = 0;
               int j = 0;
               for (int k = p; k < r && i < L.length && j < R.length; k++)
               {
                       if (L[i] <= R[j])
                       {
                               A[k] = L[i];
                               i++;
                       }
                       else
                       {
                               A[k] = R[j];
                               j++;
                       }
               }
               for (; i < L.length; i++)
               {
                       A[p + j + i] = L[i];
               }
               for (; j < R.length; j++)
               {
                       A[p + i + j] = R[j];
               }
       }

       public static void printArray(int A[])
       {
               printArray(A, 0, A.length - 1);
       }

       public static void printArray(int A[], int p, int r)
       {
               for (int i = p; i <= r; i++)
               {
                       System.out.print(A[i] + ", ");
               }
               System.out.println();
       }
}