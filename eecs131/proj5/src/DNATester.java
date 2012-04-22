import junit.framework.TestCase;

public class DNATester extends TestCase {

	/**
	 * Tests whatever
	 */
	public void testWhatever(){
	}

	/**
	 * Tests DNA toString
	 */
	public void testToString(){
		DNA test = new DNA();
		test.addToFront(DNA.Base.A);
		assertEquals("Testing single length tostring", "A", test.toString());
		test.addToFront(DNA.Base.C);
		test.addToFront(DNA.Base.G);
		assertEquals("Testing length 3 tostring", "GCA", test.toString());
	}

	/**
	 * Tests string2DNA
	 */
	public void testString2DNA(){
	}
}
