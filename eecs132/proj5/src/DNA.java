import java.lang.IllegalArgumentException;
import java.util.NoSuchElementException;

public class DNA {
	public enum Base {
		A, C, G, T
	}

	public DoubleLinkedList<Base> list;
	public DNA() {
		list = new DoubleLinkedList<Base>();
	}

	public void addToFront(Base b){
		list.addToFront(b);
	}

	public void addToBack(Base b){
		list.addToBack(b);
	}

	public Base removeFromBack(){
		return list.removeFromBack();
	}

	public Base removeFromFront(){
		return list.removeFromFront();
	}

	public String toString() {
		return list.toString();
	}

	public static DNA string2DNA(String s) {
		if (s == "" || s == null) throw new IllegalArgumentException();
		DNA froms = new DNA();
		for (char ch : s.toCharArray()) {
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

	public boolean splice(DNA dna, int numbases) {
		try{
			for (int i = 0; i<numbases; i++) {
				dna.removeFromFront();
			}
		} catch (NoSuchElementException ex) {
			return false;
		}
		if (dna.list.isEmpty()) {
			return false;
		}
		list.append(dna.list);
		return true;
	}

	public static boolean overlaps(DNA dna1, DNA dna2, int n) {
		String dnas1 = dna1.toString();
		String dnas2 = dna2.toString();
		if((dnas1.length() == 0 || dnas2.length() == 0) && n > 0){
			return false;
		}
		String end1;
		String beg2;
		try{
			end1 = dnas1.substring(dnas1.length()-n);
			beg2 = dnas2.substring(0,n);
		} catch (IndexOutOfBoundsException ex) {
			return false;
		}
		return end1.equals(beg2);
	}

	public static void main(String[] args) {
	}
}
