/*
 * GenFrame.java
 * Walker
 * This program generated a mostly random string of 64 hex characters. This could be useful for uniquely tagging reports or other business data.
 */

import java.io.*;
import java.util.Scanner;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import java.util.Random;

	

public class GenFrame extends javax.swing.JFrame {
	// Variables declaration
    public final String fileName = "rand.txt"; //This is the constant variable as noted by 'final' keyword
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTextArea txtOut;
    // End of variables declaration
    /** Creates new form GenFrame */
    public GenFrame() {
        initComponents(); //set up all gui components and settings
    }
                            
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel(); //this is the "file contents" bit
        jScrollPane1 = new javax.swing.JScrollPane();
        txtOut = new javax.swing.JTextArea(); //this is the part where the text of the file is displayed
        jButton1 = new javax.swing.JButton(); //3 buttons
        jButton2 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE); //sets the program to exit when you close the window

        jLabel1.setText("File Contents of " + fileName); //change the text
        jLabel1.setName("jLabel1"); 

        jScrollPane1.setName("jScrollPane1"); 

        txtOut.setColumns(20);
        txtOut.setEditable(false);
        txtOut.setLineWrap(true);
        txtOut.setRows(5);
        txtOut.setName("txtOut"); 
        jScrollPane1.setViewportView(txtOut);

        ClickListener cl = new ClickListener(); //new instance of clicklistener for the button clicks
        jButton1.addActionListener(cl); //the clickerlistener needs to be of type 'ActionListener' to pass in this method
        jButton1.setText("Generate");
        jButton1.setName("jButton1"); 
        
        jButton2.addActionListener(cl);
        jButton2.setText("Read");
        jButton2.setName("jButton2"); 
        
        jButton3.addActionListener(cl);
        jButton3.setText("Delete");
        jButton3.setName("jButton3"); 

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane()); //fixing the layout of the buttons etc.
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup() //make heirarchial groups of interface components to make it easier to handle.
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 376, Short.MAX_VALUE)
                    .addComponent(jLabel1)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jButton1)
                        .addGap(18, 18, 18)
                        .addComponent(jButton2)
                        .addGap(18, 18, 18)
                        .addComponent(jButton3)))
                .addContainerGap())
        );
        layout.setVerticalGroup( //more layout
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 212, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton1)
                    .addComponent(jButton2)
                    .addComponent(jButton3))
                .addContainerGap(20, Short.MAX_VALUE))
        );

        pack();
    } //end gui setup

    public static void main(String args[]) {
		new GenFrame().setVisible(true); //create new gui object and execute the init above. make it all visible when done initializing.
    }
	/*
	* This class has methods create my own objects and has methods that pass arguments
	*/
public class ClickListener implements ActionListener { //means a ClickListener object is of type ActionListener
	
    public void actionPerformed(ActionEvent e) { //must implement this method to be an ActionListener
        
        if(e.getSource() == jButton1) { //if the source of the event is btn1...
            //gen
            callGen();
        } else if (e.getSource() == jButton2) {
            //read
            callRead();
        } else if (e.getSource() == jButton3) {
            //del
            callDel();
        }
        
    }

    public void callGen() {//method to run on 'generate' button press
        log("testgen"); //log prints to std out
        String holdGen = randGen(); //create random string of hex characters
        log(holdGen);
        ReaderWriter writer = new ReaderWriter(holdGen); //create writer and try to write to rand.txt
        try {
            writer.writefile();
        } catch (Exception e) {
            txtOut.setText("Error writing file, gen is: "+holdGen); //error message on any type of exception encountered while writing out the file
        }
    }
    public void callRead() {//method to run on 'read' button press
        log("testread");
        ReaderWriter reader = new ReaderWriter();//make use of overloaded constructor and pass no arguments
        try {
            txtOut.setText("Read: " + reader.readfile()); //readfile() returns a string which is added to the text display
        } catch (Exception e){
            txtOut.setText("Error reading file");
        }
    }
    public void callDel() {//method to run on 'delete' btn press
        log("testdel");
        deleteTxtFile();//method to delete the file does not return anything
    }
}
    /*
	* This class has a switch statement, a for loop, and an array.
	*/
public String randGen() {
        Random randomGen = new Random();//random number generator
        char[] tempArray = new char[64]; //array of 64 chars
        for(int i = 0; i < 64; i++) { //will loop 64 times, to fill entire array of chars
            int randInt = randomGen.nextInt(16); //gives us 0..15
            switch (randInt) { //convert to hex
                case 0: tempArray[i] = '0'; break;
                case 1: tempArray[i] = '1'; break;
                case 2: tempArray[i] = '2'; break;
                case 3: tempArray[i] = '3'; break;
                case 4: tempArray[i] = '4'; break;
                case 5: tempArray[i] = '5'; break;
                case 6: tempArray[i] = '6'; break;
                case 7: tempArray[i] = '7'; break;
                case 8: tempArray[i] = '8'; break;
                case 9: tempArray[i] = '9'; break;
                case 10: tempArray[i] = 'A'; break;
                case 11: tempArray[i] = 'B'; break;
                case 12: tempArray[i] = 'C'; break;
                case 13: tempArray[i] = 'D'; break;
                case 14: tempArray[i] = 'E'; break;
                case 15: tempArray[i] = 'F'; break;
                default: tempArray[i] = 'X'; break; //error on X
            }
        }
		return new String(tempArray); //constructs string from array of char and returns
    }
	/*
	* This class deals with reading and writing files as well as method and constructor overloading. It also has a while loop and methods that return values.
	*/
public class ReaderWriter { //class takes care of reading from and writing to files.
    private String writestr;
    ReaderWriter() {
        //no args, for reading
    }
    ReaderWriter(String toWrite) {
        //overloaded constructor w/ stuff to write immediately
        writestr = toWrite;
    }
    public String readfile() throws IOException { //fileinputstream throws a fileNotFound exception so we also have to throw an exception
        StringBuilder text = new StringBuilder(); 
        String NL = System.getProperty("line.separator"); //newline depends on operating system
        Scanner scanner = new Scanner(new FileInputStream(fileName)); //open file for reading like from the user but from a file instead.
        try {
            while(scanner.hasNext()) { 
                text.append(scanner.nextLine() + NL); //take a line of text then add a return only while there is more to read.
            }
        }
        finally {
            scanner.close(); //close file
        }
        return text.toString(); //finally make a string from the string builder and then return it.
    }
    public void writefile() throws IOException { 
        Writer out = new OutputStreamWriter(new FileOutputStream(fileName)); //very similar to the reader but opens file for writing instead
        try {
            out.write(writestr); //use this method if writestr was set by class constructor
            txtOut.setText("Gen: " + writestr);
        }
        finally {
            out.close();
        }
    }
    
    //this method is overloaded and can be called if the ReaderWriter was not initialized w/ a string.
    public void writefile(String toWrite) throws IOException {
        Writer out = new OutputStreamWriter(new FileOutputStream(fileName));
        try {
            out.write(toWrite); //exactly the same as above but for use if the class constructor w/ no arguments was used.
            txtOut.setText("Gen: " + toWrite);
        }
        finally {
            out.close();
        }
    }
    
}    
    /*
	* This method has if statements.
	*/
public void deleteTxtFile() {
    // A File object to represent the filename
    File f = new File(fileName);
        
    // Attempt to delete it
    boolean success = f.delete();

    if (!success)//tell the user what happened.
    txtOut.setText("failed to delete " + fileName);
    else txtOut.setText("deleted " + fileName);
}
    
private void log(String aMessage){
    System.out.println(aMessage); //so i dont have to type it out every time
  }
}
