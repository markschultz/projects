import junit.framework.TestCase;
import java.util.NoSuchElementException;

/**
 * A class that tests the methods of the DoubleLinkedList class.
 */
public class DoubleLinkedListTester extends TestCase {

	/**
	 * Tests the append method of DoubleLinkedList
	 */
	public void testAppend() {
		DoubleLinkedList<Integer> list1 = new DoubleLinkedList<Integer>();
		DoubleLinkedList<Integer> list2 = new DoubleLinkedList<Integer>();
		list1.append(list2);
		assertEquals("Testing append on 2 empty lists", "", list1.toString());
		list1.addToFront(3);
		list1.append(list2);
		assertEquals("Testing append on 2nd empty list", "3", list1.toString());
		list1.removeFromFront();
		list2.addToFront(2);
		list1.append(list2);
		assertEquals("Testing append on 1st empty list", "2", list1.toString());
		list1.addToFront(1);
		list1.addToBack(3);
		list2.addToFront(1);
		list2.addToBack(3);
		list1.append(list2);
		assertEquals("Testing append on 2 populated lists", "123123", list1.toString());
	}

	/**
	 * Tests the equals method of DoubleLinkedList
	 */
	public void testEquals() {
		DoubleLinkedList<Integer> list1 = new DoubleLinkedList<Integer>();
		DoubleLinkedList<Integer> list2 = new DoubleLinkedList<Integer>();
		list1.addToFront(3);
		list2.addToFront(3);
		assertEquals("Testing equals on single element list", true, list1.equals(list2));
		list1.addToFront(2);
		list2.addToFront(2);
		list1.addToFront(1);
		assertEquals("Testing equals on lists of different lengths", false, list1.equals(list2));
		assertEquals("Testing equals on reverse of different lengths", false, list2.equals(list1));
		list2.addToFront(1);
		assertEquals("Testing equals on equal lists", true, list1.equals(list2));
		assertEquals("Testing equals on equal lists reverse", true, list2.equals(list1));
		list1.addToFront(0);
		list2.addToFront(10);
		assertEquals("Testing equals on unequal lists", false, list1.equals(list2));
		assertEquals("Testing equals on unequal lists reverse", false, list2.equals(list1));
	}

	/**
	 * Tests the addToFront method of DoubleLinkedList.
	 */
	public void testAddToFront() {
		DoubleLinkedList<Integer> list = new DoubleLinkedList<Integer>();
		list.addToFront(3);
		list.addToFront(2);
		list.addToFront(1);
		DLNode<Integer> head = list.getHead();
		DLNode<Integer> tail = list.getTail();

		assertEquals("Testing first node of list", new Integer(1), head.getElement());
		assertEquals("Testing second node of list", new Integer(2), head.getNext().getElement());
		assertEquals("Testing third node of list", new Integer(3), head.getNext().getNext().getElement());
		assertEquals("Testing end of list", null, head.getNext().getNext().getNext());

		assertEquals("Testing node at back of list", new Integer(3), tail.getElement());
		assertEquals("Testing next to last node", new Integer(2), tail.getPrevious().getElement());
		assertEquals("Testing third to last node", new Integer(1), tail.getPrevious().getPrevious().getElement());
		assertEquals("Testing front of list", null, tail.getPrevious().getPrevious().getPrevious());
	}

	/**
	 * Tests the addToBack method of DoubleLinkedList.
	 */
	public void testAddToBack() {
		DoubleLinkedList<Integer> list = new DoubleLinkedList<Integer>();
		list.addToBack(1);
		list.addToBack(2);
		list.addToBack(3);
		DLNode<Integer> head = list.getHead();
		DLNode<Integer> tail = list.getTail();

		assertEquals("Testing last node of list", new Integer(3), tail.getElement());
		assertEquals("Testing next to last node", new Integer(2), tail.getPrevious().getElement());
		assertEquals("Testing third to last node", new Integer(1), tail.getPrevious().getPrevious().getElement());
		assertEquals("Testing front of list", null, tail.getPrevious().getPrevious().getPrevious());

		assertEquals("Testing node at front of list", new Integer(1), head.getElement());
		assertEquals("Testing second node of list", new Integer(2), head.getNext().getElement());
		assertEquals("Testing third node of list", new Integer(3), head.getNext().getNext().getElement());
		assertEquals("Testing end of list", null, head.getNext().getNext().getNext());
	}

	/**
	 * Tests the removeFromFront method of DoubleLinkedList.
	 */
	public void testRemoveFromFront() {
		DoubleLinkedList<Integer> list = new DoubleLinkedList<Integer>();
		list.addToFront(1);
		list.addToFront(2);
		list.addToFront(3);
		assertEquals("Removing element of list", new Integer(3), list.removeFromFront());
		assertEquals("Removing a second element", new Integer(2), list.removeFromFront());
		assertEquals("Removing a third element", new Integer(1), list.removeFromFront());
		assertEquals("Removed last element of list", true, list.isEmpty());
		try {
			list.removeFromFront();
			fail("Removing from empty list did not throw an exception.");
		}
		catch (java.util.NoSuchElementException e) {
			/* everything is good */
		}
		catch (Exception e) {
			fail("Removing from empty list threw the wrong type of exception.");
		}

		list.addToBack(6);
		list.addToBack(7);
		assertEquals("Removing element added to back of list", new Integer(6), list.removeFromFront());
		assertEquals("Removing second element added to back", new Integer(7), list.removeFromFront());
	}

	/**
	 * Tests the removeFromBack method of DoubleLinkedList.
	 */
	public void testRemoveFromBack() {
		DoubleLinkedList<Integer> list = new DoubleLinkedList<Integer>();
		list.addToBack(5);
		list.addToFront(4);
		list.addToBack(6);
		assertEquals("Removing element from back of list", new Integer(6), list.removeFromBack());
		assertEquals("Removing second element from back of list", new Integer(5), list.removeFromBack());
		assertEquals("Removing element from back that was added to front", new Integer(4), list.removeFromBack());
		assertEquals("Removing last element of list", true, list.isEmpty());
		try {
			list.removeFromBack();
			fail("Removing from empty list did not throw an exception.");
		}
		catch (java.util.NoSuchElementException e) {
			/* everything is good */
		}
		catch (Exception e) {
			fail("Removing from empty list threw the wrong type of exception.");
		}
	}

	/**
	 * Tests the toString method of DoubleLinkedList.
	 */
	public void testToString() {
		DoubleLinkedList<Integer> list = new DoubleLinkedList<Integer>();
		list.addToFront(3);
		list.addToFront(2);
		list.addToFront(1);
		assertEquals("Testing toString for three element list", "123", list.toString());
		list.removeFromBack();
		list.removeFromBack();
		assertEquals("Testing toString for single element list", "1", list.toString());
		list.removeFromBack();
		assertEquals("Testing toString for empty list", "", list.toString());
	}

	/**
	 * Tests the toStringReverse method of DoubleLinkedList.
	 */
	public void testToStringReverse() {    
		DoubleLinkedList<Integer> list = new DoubleLinkedList<Integer>();
		list.addToFront(3);
		list.addToFront(2);
		list.addToFront(1);
		assertEquals("Testing toStringReverse for three element list", "321", list.toStringReverse());
		list.removeFromBack();
		list.removeFromBack();
		assertEquals("Testing toStringReverse for single element list", "1", list.toStringReverse());
		list.removeFromBack();
		assertEquals("Testing toStringReverse for empty list", "", list.toStringReverse());
	}

	/**
	 * Tests the iterator features of DoubleLinkedList.
	 */
	public void testIterator() {
		DoubleLinkedList<Integer> list = new DoubleLinkedList<Integer>();
		list.addToFront(3);
		list.addToFront(2);
		list.addToFront(1);
		assertEquals("make sure iterNode is initially null", null, list.iterNode);
		list.resetIterator();
		assertEquals("test reset node equals head", list.getHead(), list.iterNode);
		assertEquals("test hasnext is true", true, list.hasNext());
		assertEquals("test first next is first element", new Integer(1), list.next().getElement());
		assertEquals("test hasnext is true", true, list.hasNext());
		assertEquals("test second next is second element", new Integer(2), list.next().getElement());
		assertEquals("test hasnext is true", true, list.hasNext());
		assertEquals("test last next is last element", new Integer(3), list.next().getElement());
		assertEquals("test hasnext is false", false, list.hasNext());
		try{
			list.next();
			fail("list.next() should have thrown a NoSuchElementException");
		} catch (NoSuchElementException ex) {
			//expected, do nothing
		}
	}
}
