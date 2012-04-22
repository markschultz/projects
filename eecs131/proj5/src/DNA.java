

public class DNA {
	public enum Base {
		A, C, G, T
	}
	Base base;

	public DoubleLinkedList<Base> list;
	public DNA() {
		list = new DoubleLinkedList<Base>();
	}

	public String toString() {
		return list.toString();
	}

	public static DNA string2DNA(String s) {
		return new DNA();
	}

	public boolean splice(DNA dna, int numbases) {
		return true;
	}

	public static boolean overlaps(DNA dna1, DNA dna2, int n) {
		return true;
	}

	public static void main(String[] args) {
	}

}
