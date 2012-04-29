import java.util.*;
import java.lang.*;

/**
 * A doubly linked linked list.
 */
public class DoubleLinkedList<T> implements Iterator {
	/** a reference to the first node of the double linked list */
	private DLNode<T> head;

	/** a reference to the last node of a double linked list */
	private DLNode<T> tail;

	/** iterator tracker node */
	public DLNode<T> iterNode;

	/** Create an empty double linked list. */
	public DoubleLinkedList() {
		head = tail = null;
		iterNode = null;
	}

	/**
	 * Returns true if the lists are the same.
	 * @return  true if the lists contain the same elements in the same order
	 * @param list  list to compare to current list
	 */
	@Override
	public boolean equals(Object list){
		//resolve simple cases first
		if (list == null) return false;
		if (list == this) return true;
		if (!(list instanceof DoubleLinkedList)) return false;
		//we have to take an object to override correctly so cast it back to a DLL
		DoubleLinkedList castList = (DoubleLinkedList)list;
		castList.resetIterator();
		this.resetIterator();
		//compare element by element
		while(castList.hasNext() && this.hasNext()){
			if (castList.next().getElement() != this.next().getElement()) {
				return false;
			}
		}
		//lengths are not equal
		if ((castList.hasNext() && !this.hasNext()) || (!castList.hasNext() && this.hasNext())) {
			return false;
		}
		return true;
	}

	/**
	 * Appends a list to the current list.
	 * @param list  appends the nodes of list to the end of this list. list may be destroyed
	 */
	public void append(DoubleLinkedList<T> list){
		list.resetIterator();
		while(list.hasNext()) {
			addToBack(list.next().getElement());
		}
	}

	/**
	 * Resets internal iterator. Must be called before using the iterator.
	 */
	public void resetIterator() {
		iterNode = getHead();
	}

	/**
	 * {@inheritDoc}
	 */
	public boolean hasNext() {
		//THIS WILL ALWAYS RETURN FALSE UNLESS YOU CALL THE resetIterator METHOD
		//TO INITIALIZE
		if (iterNode == null) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * {@inheritDoc}
	 * @return  returns next element from list
	 */
	public DLNode<T> next() {
		if (iterNode == null) {
			//end of list so no more elements
			throw new NoSuchElementException();
		} else {
			//increment iterNode and return previous value
			DLNode<T> temp = iterNode;
			iterNode = iterNode.getNext();
			return temp;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public void remove() {
		throw new UnsupportedOperationException();
	}
	/** 
	 * Returns true if the list is empty.
	 * @return  true if the list has no nodes
	 */
	public boolean isEmpty() {
		return (head == null);
	}

	/**
	 * Returns the reference to the first node of the linked list.
	 * @return the first node of the linked list
	 */
	protected DLNode<T> getHead() {
		return head;
	}

	/**
	 * Sets the first node of the linked list.
	 * @param node  the node that will be the head of the linked list.
	 */
	protected void setHead(DLNode<T> node) {
		head = node;
	}

	/**
	 * Returns the reference to the last node of the linked list.
	 * @return the last node of the linked list
	 */
	protected DLNode<T> getTail() {
		return tail;
	}

	/**
	 * Sets the last node of the linked list.
	 * @param node the node that will be the last node of the linked list
	 */
	protected void setTail(DLNode<T> node) {
		tail = node;
	}

	/**
	 * Add an element to the head of the linked list.
	 * @param element  the element to add to the front of the linked list
	 */
	public void addToFront(T element) {
		if(isEmpty()){
			//if its the first node its also the head and the tail
			DLNode<T> newNode;
			newNode = new DLNode<T>(element, null, null);
			setHead(newNode);
			setTail(newNode);
		}
		else{
			//becomes new head
			DLNode<T> newNode = new DLNode<T>(element, null, getHead());
			setHead(newNode);
		}
	}

	/**
	 * Add an element to the tail of the linked list.
	 * @param element  the element to add to the tail of the linked list
	 */
	public void addToBack(T element) {
		if(isEmpty()){
			//same as addToFront, becomes head and tail
			DLNode<T> newBackNode;
			newBackNode = new DLNode<T>(element, null, null);
			setHead(newBackNode);
			setTail(newBackNode);
		}
		else{
			//becomes new tail
			DLNode<T> newBackNode = new DLNode<T>(element, getTail(), null);
			setTail(newBackNode);
		}
	}

	/**
	 * Remove and return the element at the front of the linked list.
	 * @return the element that was at the front of the linked list
	 * @throws NoSuchElementException if attempting to remove from an empty list
	 */
	public T removeFromFront() {
		if(isEmpty()){
			throw new NoSuchElementException();
		}
		DLNode<T> oldHead = getHead();
		if(getHead().getNext() != null){
			//fix previous for new head and set new head
			getHead().getNext().setPrevious(null);
			setHead(getHead().getNext());
		}
		else{
			//removed last node
			setHead(null);
			setTail(null);
		}
		return oldHead.getElement();
	}

	/**
	 * Remove and return the element at the back of the linked list.
	 * @return the element that was at the back of the linked list
	 * @throws NoSuchElementException if attempting to remove from an empty list
	 */
	public T removeFromBack() {
		if(isEmpty()){
			throw new NoSuchElementException();
		}
		DLNode<T> oldTail = getTail();
		if(getTail().getPrevious() != null){
			//fix next for new tail and set new tail
			getTail().getPrevious().setNext(null);
			setTail(getTail().getPrevious());
		}
		else{
			//removed last node
			setTail(null);
			setHead(null);
		}
		return oldTail.getElement();
	}

	/**
	 * Returns a string representation of the contents of the linked list, from the front to the back.
	 * @return a string representation of the linked list, from front to back
	 */
	public String toString() {
		if(isEmpty()){
			return "";
		}
		else if(getHead() == getTail()){
			//one element
			return getHead().getElement().toString();
		}
		else{
			StringBuilder newString = new StringBuilder();
			DLNode<T> placeHolder = getHead();
			//loop through and build string node by node
			while(placeHolder.getNext() != null){
				newString.append(placeHolder.getElement().toString());
				placeHolder = placeHolder.getNext();
			}
			newString.append(placeHolder.getElement().toString());
			return newString.toString();
		}
	}


	/**
	 * Returns a string representation of the contents of the linked list, from the back to the front.
	 * @return a string representation of the linked list, from back to front
	 */
	public String toStringReverse() {
		String nodes = toString();
		StringBuilder reverseNodes = new StringBuilder();
		//start at the end and go to the beginning. build new string in that order
		for(int i = nodes.length() - 1; i >= 0; --i){
			reverseNodes.append(nodes.charAt(i));
		}
		return reverseNodes.toString();
	}
}
