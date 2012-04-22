import junit.framework.TestCase;

public class DNATester extends TestCase {

	/**
	 * Tests whatever
	 */
	public void testWhatever(){
	}

	/**
	 * Tests splice method
	 */
	public void testSplice(){
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
		assertEquals("Testing tostring and string2dna are inverse", "ACGT", DNA.string2DNA("ACGT").toString());
		try {
			DNA.string2DNA("");
			fail("string2DNA on empty string did not throw an exception.");
		}
		catch (java.lang.IllegalArgumentException e) {
			/* everything is good */
		}
		catch (Exception e) {
			fail("string2DNA on empty string threw the wrong exception");
		}
		try {
			DNA.string2DNA("BXY");
			fail("string2DNA on illegal chars did not throw an exception.");
		}
		catch (java.lang.IllegalArgumentException e) {
			/* everything is good */
		}
		catch (Exception e) {
			fail("string2DNA on illegal chars threw the wrong exception");
		}
	}
}
