    /* This program will convert Roman numerals to ordinary arabic numerals
       and vice versa.  The user can enter a numerals of either type.  Arabic
       numerals must be in the range from 1 to 4999 inclusive.  The user ends
       the program by entering an empty line.
    */
//import TextIO;
//import ConvertArabicToRoman;
//import ConvertRomanToArabic;
    
    public class RomanArabicTest {
    
       public static void main(String[] args) {
          
          TextIO.putln("Enter a Roman numeral and I will convert it to an ordinary");
          TextIO.putln("arabic integer.  Enter an integer in the range 1 to 4999");
          TextIO.putln("and I will convert it to a Roman numeral.  Press 'N' when");
          TextIO.putln("you want to quit.");
          
          while (true) {
    
             TextIO.putln();
             TextIO.put(": ");
             
             /* Skip past any blanks at the beginning of the input line.
                Break out of the loop if there is nothing else on the line. */
             
             while (TextIO.peek() == ' ' || TextIO.peek() == '\t')
                TextIO.getAnyChar();
             if ( TextIO.peek() == 'n' || TextIO.peek() == 'N' )
                break;
                
             /* If the first non-blank character is a digit, read an arabic
                numeral and convert it to a Roman numeral.  Otherwise, read
                a Roman numeral and convert it to an arabic numeral. */
                
             if ( Character.isDigit(TextIO.peek()) ) {

		int arabic = TextIO.getlnInt();		
		if (arabic < 1) {             		TextIO.putln("You have entered an invalid value. The Roman numeral – Arabic converter will stop now.");
			break;
		}          	if (arabic > 4999) {             		TextIO.putln("You have entered an invalid value.  The Roman numeral – Arabic converter will stop now.");
			break;
		}
                ConvertArabicToRoman converter = new ConvertArabicToRoman(arabic);
		converter.Convert();
		TextIO.putln(converter.getRoman());
                
             }
             else {
		String roman = TextIO.getln();
		if (roman.length() == 0) {             		TextIO.putln("An empty string does not define a Roman numeral.");
			break;
		}
		ConvertRomanToArabic converter = new ConvertRomanToArabic(roman);
		converter.Convert();
		if(converter.getArabic() >= 5000) {
			TextIO.putln("You have enetered an invalid value.");
		}
		else{
		TextIO.putln(converter.getArabic());
		}

                
             }
    
          }  // end while
          
          TextIO.putln("exiting");
    
       }  // end main()
       
    } // end class RomanConverter