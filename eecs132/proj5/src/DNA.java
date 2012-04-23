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
		return true;
	}

	public static void main(String[] args) {
	}
}
