import java.util.Scanner; // Scanner is in java.util

public class Program { 
  // define group 1 course layout read data
    public static String[] group1Header = new String[2];
    public static int group1Number = 0;
    public static String[][] group1Course = new String[8][4];
  // define group 2 course layout read data
    public static String[] group2Header = new String[2];
    public static int group2Number = 0;
    public static String[][] group2Course = new String[8][5];
  // define group 3 course layout read data
    public static String[] group3Header = new String[2];
    public static int group3Number = 0;
    public static String[][] group3Course = new String[8][5];
  // define group 4 course layout read data
    public static String[] group4Header = new String[2];
    public static int group4Number = 0;
    public static String[][] group4Course = new String[8][7];
  // define group 5 course layout read data
    public static String[] group5Header = new String[2];
    public static int group5Number = 0;
    public static String[][] group5Course = new String[8][8];
  // define group 6 course layout read data
    public static String[] group6Header = new String[2];
    public static int group6Number = 0;
    public static String[][] group6Course = new String[8][9];
  // define group 7 course layout read data
    public static String[] group7Header = new String[2];
    public static int group7Number = 0;
    public static String[][] group7Course = new String[8][11];

// console main method - test the file read operations
  public static void main(String[] args) throws Exception { 
// Create a File instance 
    java.io.File file = new java.io.File( "course_layout.txt"); 
// Create a Scanner for the file 
    java.util.Scanner input = new java.util.Scanner( file); 
// call a method to read the GRSC race course layouts
    group1Number = readCourseLayout( input, group1Header, group1Course);
    group2Number = readCourseLayout( input, group2Header, group2Course);
    group3Number = readCourseLayout( input, group3Header, group3Course);
    group4Number = readCourseLayout( input, group4Header, group4Course);
    group5Number = readCourseLayout( input, group5Header, group5Course);
    group6Number = readCourseLayout( input, group6Header, group6Course);
    group7Number = readCourseLayout( input, group7Header, group7Course);
 // Close the file 
    input.close(); 
    // print the data
//    printCourseLayout( group1Header, group1Number, group1Course);
//    printCourseLayout( group2Header, group2Number, group2Course);
//    printCourseLayout( group3Header, group3Number, group3Course);
//    printCourseLayout( group4Header, group4Number, group4Course);
//    printCourseLayout( group5Header, group5Number, group5Course);
//    printCourseLayout( group6Header, group6Number, group6Course);
//    printCourseLayout( group7Header, group7Number, group7Course);
/*
 * now prompt user for race
 */
    // Create a Scanner for console input (stdin)
    input = new Scanner(System.in);
    // Prompt the user to enter an initial a GRSC race
    System.out.print("Enter race [A-H][1-7]: ");
    String answer = input.next();
    // search for the race string from each group
    int raceNumber = -1;
    if( 0 <= (raceNumber = searchCourseLayout( answer, group1Course)))
        printRaceCourse( raceNumber, group1Header, group1Number, group1Course);
    else if( 0 <= (raceNumber = searchCourseLayout( answer, group2Course)))
        printRaceCourse( raceNumber, group2Header, group2Number, group2Course);
    else if( 0 <= (raceNumber = searchCourseLayout( answer, group3Course)))
        printRaceCourse( raceNumber, group3Header, group3Number, group3Course);
    else if( 0 <= (raceNumber = searchCourseLayout( answer, group4Course)))
        printRaceCourse( raceNumber, group4Header, group4Number, group4Course);
    else if( 0 <= (raceNumber = searchCourseLayout( answer, group5Course)))
        printRaceCourse( raceNumber, group5Header, group5Number, group5Course);
    else if( 0 <= (raceNumber = searchCourseLayout( answer, group6Course)))
        printRaceCourse( raceNumber, group6Header, group6Number, group6Course);
    else if( 0 <= (raceNumber = searchCourseLayout( answer, group7Course)))
        printRaceCourse( raceNumber, group7Header, group7Number, group7Course);
    else
        System.out.println( "Invalid race: " + answer);
  } 

// method to read the GRSC race course table
  public static int readCourseLayout( java.util.Scanner input, 
                                       String[] groupHeader, 
                                       String[][] groupCourse) {
    int groupNumber = 0;
// Read the Group header from the file 
      if( input.hasNext()) groupHeader[0] = input.next(); 
      if( input.hasNext()) groupNumber = input.nextInt(); 
      if( input.hasNext()) groupHeader[1] = input.next();  
// print the header with array row and column
//    System.out.println( groupHeader[0] + " " + groupNumber + " " + groupHeader[1]); 
//    System.out.println( groupCourse.length + " " + groupCourse[0].length); 
// Read the course table 
      for( int i = 0; i < groupCourse.length; i++)
        for( int j = 0; j < groupCourse[0].length; j++)
          if( input.hasNext())
             groupCourse[ i][ j] = input.next();
          else
             break;
       return groupNumber;
  }

// method to search the GRSC race course table
  public static int searchCourseLayout( String raceString,
                                       String[][] groupCourse) {
    int groupNumber = -1; // not found value
// Search the course table 
      for( int i = 0; i < groupCourse.length; i++)
   if( groupCourse[ i][0].equals( raceString) == true)
              return i;  // 0 - 7 row index
       return groupNumber;
  }

  /*
   * method to print the course header and layoyut to the screeen
   */
  public static void printCourseLayout( String[] groupHeader,
                                       int groupNumber,
                                       String[][] groupCourse) {
// print the header
    System.out.println( groupHeader[0] + " " + groupNumber + " " + groupHeader[1]); 
// print the data from the table
      for( int i = 0; i < groupCourse.length; i++) {
        for( int j = 0; j < groupCourse[0].length; j++)
           System.out.print( groupCourse[ i][ j] + "\t");
        System.out.println( "");
      }
  } 

  public static String[][] raceBearings = {
      { "S", "A", "015", "(0.85nm)", },
      { "S", "B", "060", "(0.85nm)", },
      { "S", "C", "105", "(0.85nm)", },
      { "S", "D", "150", "(0.85nm)", },
      { "S", "E", "195", "(0.85nm)", },
      { "S", "F", "240", "(0.85nm)", },
      { "S", "G", "285", "(0.85nm)", },
      { "S", "H", "330", "(0.85nm)", },

      { "A", "S", "195", "(0.85nm)", },
      { "B", "S", "240", "(0.85nm)", },
      { "C", "S", "285", "(0.85nm)", },
      { "D", "S", "330", "(0.85nm)", },
      { "E", "S", "015", "(0.85nm)", },
      { "F", "S", "060", "(0.85nm)", },
      { "G", "S", "105", "(0.85nm)", },
      { "H", "S", "150", "(0.85nm)", },

      { "A", "E", "195", "(1.70nm)", },
      { "B", "F", "240", "(1.70nm)", },
      { "C", "G", "285", "(1.70nm)", },
      { "D", "H", "330", "(1.70nm)", },
      { "E", "A", "015", "(1.70nm)", },
      { "F", "B", "060", "(1.70nm)", },
      { "G", "C", "105", "(1.70nm)", },
      { "H", "D", "150", "(1.70nm)", },
                                                                                                 
      { "A", "G", "240", "(1.20nm)", },
      { "B", "H", "285", "(1.20nm)", },
      { "C", "A", "330", "(1.20nm)", },
      { "D", "B", "015", "(1.20nm)", },
      { "E", "C", "060", "(1.20nm)", },
      { "F", "D", "105", "(1.20nm)", },
      { "G", "E", "150", "(1.20nm)", },
      { "H", "F", "195", "(1.20nm)", },

      { "A", "H", "263", "(0.65nm)", },
      { "B", "A", "308", "(0.65nm)", },
      { "C", "B", "353", "(0.65nm)", },
      { "D", "C", "038", "(0.65nm)", },
      { "E", "D", "083", "(0.65nm)", },
      { "F", "E", "128", "(0.65nm)", },
      { "G", "F", "173", "(0.65nm)", },
      { "H", "G", "218", "(0.65nm)", },

      { "A", "B", "128", "(0.65nm)", },
      { "B", "C", "173", "(0.65nm)", },
      { "C", "D", "218", "(0.65nm)", },
      { "D", "E", "263", "(0.65nm)", },
      { "E", "F", "308", "(0.65nm)", },
      { "F", "G", "353", "(0.65nm)", },
      { "G", "H", "038", "(0.65nm)", },
      { "H", "A", "083", "(0.65nm)", },
                                                                                                 
    };

// method to search the GRSC race bearing table
  public static int searchRaceBearing( String fromMark, String toMark) {
    int raceBearingNumber = -1; // not found value
// Search the bearing table 
   for( int i = 0; i < raceBearings.length; i++)
     if( fromMark.equals( raceBearings[ i][0]) == true && toMark.equals( raceBearings[ i][1]) == true)
              return i;  // race bearing index
   return raceBearingNumber;
  }

  /*
   * method to print the race course to the screeen
   */
  public static void printRaceCourse( int raceNumber,
                                       String[] groupHeader,
                                       int groupNumber,
                                       String[][] groupCourse) {
// print the header
    System.out.println( groupHeader[0] + " " + groupNumber + " " + groupHeader[1]); 
// print the data from the table
    for( int j = 2; j < groupCourse[0].length; j++)
    {
        System.out.print( groupCourse[ raceNumber][ j]);
 // extra credit
        int raceBearingIndex = searchRaceBearing( groupCourse[ raceNumber][ j - 1], groupCourse[ raceNumber][j]);
        System.out.println( " " + raceBearings[ raceBearingIndex][2] + " " + raceBearings[ raceBearingIndex][3] );
    }
  } 

} 
