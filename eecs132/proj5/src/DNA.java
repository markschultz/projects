import java.lang.IllegalArgumentException;
import java.util.NoSuchElementException;

public class DNA {
	/**
	 * Base Enum with 4 DNA letters
	 */
	public enum Base {
		A, C, G, T
	}

	/**
	 * DoubleLinkedList holding only elements of type Base
	 */
	public DoubleLinkedList<Base> list;

	/**
	 * The constructor. makes new DLlist
	 */
	public DNA() {
		list = new DoubleLinkedList<Base>();
	}

	/**
	 * Add base to Front of list.
	 * @param b Base to be added
	 */
	public void addToFront(Base b){
		list.addToFront(b);
	}

	/**
	 * Add base to Back of list.
	 * @param b Base to be added
	 */
	public void addToBack(Base b){
		list.addToBack(b);
	}

	/**
	 * Remove base at back of list
	 * @return the base at the back of the list
	 */
	public Base removeFromBack(){
		return list.removeFromBack();
	}

	/**
	 * Remove base at front of list
	 * @return the base at the front of the list
	 */
	public Base removeFromFront(){
		return list.removeFromFront();
	}

	/**
	 * Converts list to string
	 * @return string representation of DNA list
	 */
	public String toString() {
		return list.toString();
	}

	/**
	 * Converts string to DNA
	 * @param s string of base pairs
	 * @return DNA object containing given base pairs
	 * @throws IllegalArgumentException when the given string cannot be converted to DNA
	 */
	public static DNA string2DNA(String s) {
		//throw exception when string is empty, null or contains non-dna letters
		if (s == "" || s == null) throw new IllegalArgumentException();
		DNA froms = new DNA();
		for (char ch : s.toCharArray()) {
			//we want to preserve the order so add to back
			if (ch == 'A') froms.addToBack(Base.A);
			else if (ch == 'C') froms.addToBack(Base.C);
			else if (ch == 'G') froms.addToBack(Base.G);
			else if (ch == 'T') froms.addToBack(Base.T);
			else throw new IllegalArgumentException();
//			cleaner way to do it but we cant use break
//			switch (ch) {
//				case 'A':
//				case 'a':
//					froms.addToBack(Base.A);
//					break;
//				case 'C':
//				case 'c':
//					froms.addToBack(Base.C);
//					break;
//				case 'G':
//				case 'g':
//					froms.addToBack(Base.G);
//					break;
//				case 'T':
//				case 't':
//					froms.addToBack(Base.T);
//					break;
//				default:
//					throw new IllegalArgumentException();
//			}
		}
		return froms;
	}

	/**
	 * Appends given number of bases from given DNA to current DNA
	 * @param dna DNA to splice from
	 * @param numbases number of Base pairs to splice
	 * @return true if splice was successfull
	 */
	public boolean splice(DNA dna, int numbases) {
		//if we assume the end of 'this' dna contains the beginning of 'dna'
		//then we can remove the common part then append whats left over
		try{
			for (int i = 0; i<numbases; i++) {
				dna.removeFromFront();
			}
		} catch (NoSuchElementException ex) {
			//we tried to remove more elements than dna contains
			//return false because we didnt actually splice anything
			return false;
		}
		if (dna.list.isEmpty()) {
			//same as above
			return false;
		}
		list.append(dna.list);
		return true;
	}

	/**
	 * Finds if given DNA overlap by given amount
	 * @param dna1 first DNA to be overlap checked
	 * @param dna2 second DNA to be overlap checked
	 * @param n number of bases to check
	 * @return true if last n bases of dna1 are the same as the first n bases of dna2
	 */
	public static boolean overlaps(DNA dna1, DNA dna2, int n) {
		//store string version so we dont have to type toString out every time.
		String dnas1 = dna1.toString();
		String dnas2 = dna2.toString();
		if((dnas1.length() == 0 || dnas2.length() == 0) && n > 0){
			//if either DNAs are empty they cant overlap more than 0
			return false;
		}
		String end1;
		String beg2;
		try{
			//end of the first dna. substring length == n. last letter to last-nth letter.
			end1 = dnas1.substring(dnas1.length()-n);
			//beginning of second dna. substring length == n. first letter to nth letter
			beg2 = dnas2.substring(0,n);
		} catch (IndexOutOfBoundsException ex) {
			//cant overlap more letters than the string has
			return false;
		}
		//dont use == because that will check for identical objects, not identical strings
		return end1.equals(beg2);
	}

	/**
	 * Takes 2 strings of Bases and finds prints the smallest spliced DNA
	 * @param args 2 strings to be spliced into single DNA
	 */
	public static void main(String[] args) {
		if (args.length == 2) {
			DNA dna1;
			DNA dna2;
			try {
				//parse input
				dna1 = DNA.string2DNA(args[0]);
				dna2 = DNA.string2DNA(args[1]);
				int smallest = 0;
				int largestOverlapA = 0;
				int largestOverlapB = 0;
				//find length of shorter DNA
				if (dna1.toString().length() > dna2.toString().length()) {
					smallest = dna2.toString().length();
				} else {
					smallest = dna1.toString().length();
				}
				//check overlaps, max length of shorter DNA
				//TODO: max length is handled in overlap
				for (int i = 0; i <= smallest; i++) {
					if (DNA.overlaps(dna1, dna2, i)) {
						largestOverlapA = i;
					}
				}
				//check if they overlap the other way around
				for (int i = 0; i <= smallest; i++) {
					if (DNA.overlaps(dna2, dna1, i)) {
						largestOverlapB = i;
					}
				}
				//pick the larger overlap and if equal print in the order we got the DNA
				if (largestOverlapA >= largestOverlapB) {
					dna1.splice(dna2, largestOverlapA);
					System.out.println("Created DNA: "+dna1.toString());
				} else {
					dna2.splice(dna1, largestOverlapB);
					System.out.println("Created DNA: "+dna2.toString());
				}
			} catch (IllegalArgumentException ex) {
				System.out.println("Incompatible arguments. Please supply 2 DNA strings");
			}
		} else {
			System.out.println("Incorrect number of arguments. Please supply 2 DNA strings");
		}
	}
}
