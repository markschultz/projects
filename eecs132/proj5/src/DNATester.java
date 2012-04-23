import junit.framework.TestCase;
import java.util.NoSuchElementException;

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
		DNA test = new DNA();
		DNA test2 = new DNA();
		assertEquals("Testing splice on 2 empty lists", false, test.splice(test2, 0));
		assertEquals("Testing splice on 2 empty lists", false, test.splice(test2, 1));
		test.addToFront(DNA.Base.A);
		assertEquals("Testing splice on 2nd empty list", false, test.splice(test2, 1));
		test2.addToFront(DNA.Base.A);
		test.removeFromFront();
		assertEquals("Testing splice on 1st empty list", true, test.splice(test2, 0));
		assertEquals("Testing splice on 1st empty list", false, test.splice(test2, 1));
		assertEquals("Testing splice correct elements", "A", test.toString());
		test.addToBack(DNA.Base.C);
		test.addToBack(DNA.Base.G);
		test.addToBack(DNA.Base.T);
		test2.addToBack(DNA.Base.A);
		test2.addToBack(DNA.Base.C);
		test2.addToBack(DNA.Base.G);
		test2.addToBack(DNA.Base.T);
		test.splice(test2, 1);
		assertEquals("Testing splice on 2 populated lists", "ACGTCGT", test.toString());
		test.splice(test2, 2);
		assertEquals("Testing longer splice", "ACGTCGTT", test.toString());
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
