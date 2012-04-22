/** Rachael Farber.  This class acts as a spell checker by using arrays and analyzing input from dictionary text files
 * and user information.
 */
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.File;
import java.util.Scanner;
import java.util.Arrays;
import java.lang.StringBuilder;
import java.util.StringTokenizer;
import java.lang.Character;

public class SpellChecker{

	static String[] dictionary;
	BufferedReader dictToArray;

	public SpellChecker(String dictPath) throws IOException{
		File dict = new File(dictPath);
		if (!dict.exists()) {
			System.out.println(dictPath+" does not exist.");
			System.exit(1);
		}
		dictionary = new String[numLines(dict)];
		dictToArray = new BufferedReader(new FileReader(dict));
		for (int i=0; i<dictionary.length; i++) {
			dictionary[i] = dictToArray.readLine();
		}
		dictToArray.close();
	}

	/** This method returns the number of lines in a file.
	 * @param File	file
	 */
	public int numLines(File file) throws IOException{
		BufferedReader read = new BufferedReader(new FileReader(file));
		int count = 0;
		while (read.readLine() != null) {
			count++;
		}
		read.close();
		return count;
	}

	/** This method returns a double that determines how close to the correct spelling word1 is to word2.  The "closeness"
	 * to the correct spelling is based on four parameters.  The first is letter skipping, the second is letter addition,
	 * the third is letter replacing, and the fourth is letter inversion.
	 * @param String	word1
	 * @param String	word2
	 */
	public double editDistance(String word1, String word2){
		double replacePenalty = 1.0;
		double skipPenalty = 1.0;
		double insertPenalty = 1.0;
		double interchangePenalty = 1.0;
		int length1 = word1.length();
		int length2 = word2.length();
		int length = 0;
		char[] w1 = word1.toCharArray();
		char[] w2 = word2.toCharArray();
		//System.out.println(length1+ "LENGTH");
		//System.out.println(length2+ "LENGTH");
		if (word1.length() < word2.length()) {
			length = word2.length();
		} else {
			length = word1.length();
		}
		double[][] T = new double[length][length];
		for (int i = 0; i<length1; i++) {
			for (int j = 0; j<length2; j++) {
				if (i==0 && j==0){
					T[0][0] = 0;
				} else if (i==0){
					T[0][j] = j * skipPenalty;
				}  else if (j==0){
					T[i][0] = i * insertPenalty;
				} else {
					double[] vals = new double[4];
					vals[0] = T[i-1][j] + skipPenalty;
					vals[1] = T[i][j-1] + insertPenalty;;
					vals[2] = T[i-1][j-1];
					if (w1[i] != w2[j]) {
						vals[2] += replacePenalty;
					}
					if (i>=2 && j>=2) {
						vals[3] = T[i-2][j-2] + interchangePenalty;
						if (w1[i] != w2[j-1]) {
							vals[3] += replacePenalty;
						} else if (w1[i-1] != w2[j]) {
							vals[3] += replacePenalty;
						}
					}

					Arrays.sort(vals);
					T[i][j] = vals[0];
				}
				//System.out.println(T[i][j]+ "i:"+i+",j:"+j);
				//System.out.println("i:" + i);
				//System.out.println("j:" + j);
			}
		}
		//why does this need to be double if we're only using ints?
		//System.out.println("lens:i:"+word1.length()+"j:"+word2.length());
		//System.out.println("Distance: " + word1 + "," + word2 + ":" + T[word1.length()-1][word2.length()-1]);
		return T[word1.length()-1][word2.length()-1];
	}

	/** This method returns a spell checked version of the inputted word.
	 * @param String	word
	 */
	public String correctWord(String word){
		int[][] dist = new int[dictionary.length][2];
		String[] top = new String[10];

		//return if word is in dictionary
		if (Arrays.binarySearch(dictionary, word) >= 0){
			return word;
		}
		//calc distance of word from every dict word
		for (int i = 0; i<dictionary.length; i++){
			String s = dictionary[i];
			dist[i][0] = (int)editDistance(s, word);
			dist[i][1] = i; //keep track of indexes for after sorting
		}
		//sort distances
		Arrays.sort(dist, new java.util.Comparator<int[]>() {
			public int compare(int[] a, int[] b) {
				return a[0] - b[0];
			}
		});
		int count = 0;
		int k = 0;
		while (count < 10){
			System.out.println(k+ ":"+ dist[k][0]);
			if (dist[k][0] > 0) {
				System.out.println(dictionary[dist[k][1]]);
				top[k] = dictionary[dist[k][1]];
				count++;
			}
			k++;
		}
		/* for (int i = 0; i < 10; i++){ */
		/* } */

		//print results
		System.out.println(word + " is mispelled. Options are:\n\tk: keep\n\te:enter replacement word\nor automatically replace with:");
		for (int i = 0; i<top.length; i++) {
			System.out.println("\t" + i + ": " + top[i] + "(score " + dist[i][0] + ")");
		}
		//user input time
		String corrected = getUserIn(top, word);
		if (isCap(word)){
			return cap(corrected);
		}
		return corrected;
	}

	public String getUserIn(String[] top, String word){
		Scanner in = new Scanner(System.in);
		switch (in.next()){
			case "k":
				return word;
			case "e":
				System.out.println("Enter replacement: ");
				return in.nextLine();
			case "0":
				return top[0];
			case "1":
				return top[1];
			case "2":
				return top[2];
			case "3":
				return top[3];
			case "4":
				return top[4];
			case "5":
				return top[5];
			case "6":
				return top[6];
			case "7":
				return top[7];
			case "8":
				return top[8];
			case "9":
				return top[9];
			default:
				System.out.println("Bad entry, skipping.");
				return word;
		}
	}

	public boolean isPunc(String s){
		for (char c : s.toCharArray()) {
			int type = Character.getType(c);
			//these is the only "letters" we are expecting
			if (s.contains(".") || s.contains(",") || s.contains("'") || s.contains("\"") || s.contains("!") || s.contains("?") || s.contains(";") || s.contains(":") || s.contains(" ")){
				return true;
			}
		}
		return false;
	}

	public boolean isCap(String s){
		char[] c = s.toCharArray();
		if (Character.getType(c[0]) == Character.UPPERCASE_LETTER){
			return true;
		}
		return false;
	}

	public String cap(String s){
		return Character.toUpperCase(s.charAt(0)) + s.substring(1);
	}

	/** This method returns a new String that is the same as s, but every word in the String s is spell checked and 
	 * replaced with the correct spelling.
	 * @param String	s
	 */
	public String spellCheck(String s){
		System.out.println("instring: "+ s);
		StringBuilder build = new StringBuilder();
		StringTokenizer token = new StringTokenizer(s, " '\"?!.,:;",true);
		String[] tokens = new String[token.countTokens()];
		for (int i = 0; i<tokens.length; i++){
			tokens[i] = token.nextToken();
			System.out.println("token:"+i+ " " + tokens[i]);
		}
		//System.out.println("t len "+ tokens.length);
		for (int i = 0; i<tokens.length; i++) {
			if (isPunc(tokens[i])) {
				build.append(tokens[i]);
				System.out.println("punc: "+tokens[i]);
			} else {
				System.out.println("corrected: "+ correctWord(tokens[i]));
				build.append(correctWord(tokens[i]));
			}
		}
		System.out.println("outstring: "+ build.toString());
		return build.toString();
	}

	public static void main(String[] args) {
		BufferedWriter writer = null;
		BufferedReader reader = null;
		SpellChecker checker = null;
		try {
			checker = new SpellChecker(args[2]);
		} catch(IOException ex){
			ex.toString();
		}
		try{
			writer = new BufferedWriter(new FileWriter(args[1]));
			reader = new BufferedReader(new FileReader(args[0]));
			String line = null;

			int count = checker.numLines(new File(args[0]));
			for (int i = 0; i<count; i++) {
				line = reader.readLine();
				//System.out.println(line);
				writer.write(checker.spellCheck(line));
				writer.newLine();
			}

		} catch (Exception ex){
			ex.toString();
		} finally {
			try {
				writer.flush();
				writer.close();
				reader.close();
			} catch (IOException ex) {
				ex.toString();
			}
		}
	}
}
