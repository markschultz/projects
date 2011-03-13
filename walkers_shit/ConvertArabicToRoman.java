public class ConvertArabicToRoman {
      
private String Roman;
private int Arabic;

public ConvertArabicToRoman(int A)
{
Roman = "";
Arabic = A;
}
public void setArabic(int A)
{
Arabic = A;
}
public String getRoman()
{
return Roman;
}

private static int[]    numbers = { 1000,  900,  500,  400,  100,   90,  
                                    50,   40,   10,    9,    5,    4,    1 };
                                          
private static String[] letters = { "M",  "CM",  "D",  "CD", "C",  "XC",
                                     "L",  "XL",  "X",  "IX", "V",  "IV", "I" };  

public void Convert() {
             // Return the standard representation of this Roman numeral.
          int N = Arabic;        // N represents the part of num that still has
                              //   to be converted to Roman numeral representation.
          for (int i = 0; i < numbers.length; i++) {
             while (N >= numbers[i]) {
                Roman += letters[i];
                N -= numbers[i];
             }
          }
	}
}