/*
An object of type RomanNumeral is an integer between 1 and 4999. It can be constructed either from an integer or from a string that represen a Roman numeral in this range.  The function toString() will return a standardized Roman numeral representation of the number.  The function toInt() will return the number as a value of type int.
    */
    
    public class ConvertRomanToArabic {
    
       private int Arabic; 
       private String Roman;    
       public ConvertRomanToArabic(String R) {
  
Roman = R;
Arabic = 0;

       }
       
    
       public void Convert () {
             // Constructor.  Creates the Roman number with the given representation.
             // For example, RomanNumeral("xvii") is 17.  If the parameter is not a
             // legal Roman numeral, a NumberFormatException is thrown.  Both upper and
             // lower case letters are allowed.
                          
          Roman = Roman.toUpperCase();  // Convert to upper case letters.
          
          int i = 0;
          
          while (i < Roman.length()) {
          
             char letter = Roman.charAt(i);        // Letter at current position in string.
             int number = letterToNumber(letter);  // Numerical equivalent of letter.
             
             if (number < 0) {
                System.out.println("Illegal character \"" + letter + "\" in roman numeral.");
		break;
}
                
             i++;  // Move on to next position in the string
             
             if (i == Roman.length()) {
                   // There is no letter in the string following the one we have just processed.
                   // So just add the number corresponding to the single letter to Arabic.
                Arabic += number;
             }
             else {
                   // Look at the next letter in the string.  If it has a larger Roman numeral
                   // equivalent than number, then the two letters are counted together as
                   // a Roman numeral with value (nextNumber - number).
                int nextNumber = letterToNumber(Roman.charAt(i));
				if((i+2 < Roman.length())){
                int nextnextnum = letterToNumber(Roman.charAt(i+1));
				int nextnextnextnum = letterToNumber(Roman.charAt(i+2));
				if ((number == nextNumber) && (number == nextnextnum) && (number == nextnextnum)) {
					TextIO.put("Illegal character"); //error of 4 of the same in a row
					break; //to exit program
				}
				}
				if (nextNumber > number) {
                      // Combine the two letters to get one value, and move on to next position in string.
                   Arabic += (nextNumber - number);
                   i++;
                }
                else {
                      // Don't combine the letters.  Just add the value of the one letter onto the number.
                   Arabic += number;
                }
             }
             
          }  // end while
         
       } 
       
    
       private int letterToNumber(char letter) {
             // Find the integer value of letter considered as a Roman numeral.  Return
             // -1 if letter is not a legal Roman numeral.  The letter must be upper case.
          switch (letter) {
             case 'I':  return 1;
             case 'V':  return 5;
             case 'X':  return 10;
             case 'L':  return 50;
             case 'C':  return 100;
             case 'D':  return 500;
             case 'M':  return 1000;
             default:   return -1;
          }
       }
       
	public int getArabic() {
            // Return the value of this Roman numeral as an int.
          return Arabic;
       }

public void setRoman(String R)
{
Roman = R;
}
     
    
    } // end class RomanNumeral