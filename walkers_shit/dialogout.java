import javax.swing.JDialog;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.swing.JPanel;
import javax.swing.BorderFactory;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;
import javax.swing.JButton;
import javax.swing.JSlider;
/**
 * @author  Administrator
 * @created March 12, 2011
 */
public class dialogout extends JDialog 
{
static dialogout thedialogout;

JPanel pnPanel0;

/**
 * @author  Administrator
 * @created March 12, 2011
 */
class Panel5 extends JPanel implements ActionListener 
{
   JTextArea taTxtOut;

   /**
    *Constructor for the Panel5 object
    */
   public Panel5() 
   {
      super();
      setBorder( BorderFactory.createTitledBorder( "File Contents" ) );

      GridBagLayout gbPanel5 = new GridBagLayout();
      GridBagConstraints gbcPanel5 = new GridBagConstraints();
      setLayout( gbPanel5 );

      taTxtOut = new JTextArea(2,10);
	  //taTxtOut.setEditable(False);
      JScrollPane scpTxtOut = new JScrollPane( taTxtOut );
	  MessageConsole mc = new MessageConsole(taTxtOut);
	  mc.redirectOut();
	  //mc.redirectErr(Color.RED, null);
	  mc.setMessageLines(100);
      gbcPanel5.gridx = 0;
      gbcPanel5.gridy = 0;
      gbcPanel5.gridwidth = 20;
      gbcPanel5.gridheight = 16;
      gbcPanel5.fill = GridBagConstraints.BOTH;
      gbcPanel5.weightx = 1;
      gbcPanel5.weighty = 1;
      gbcPanel5.anchor = GridBagConstraints.NORTH;
      gbPanel5.setConstraints( scpTxtOut, gbcPanel5 );
      add( scpTxtOut );
   } 

   /**
    */
   public void actionPerformed( ActionEvent e ) 
   {
	if(e.getSource() == btBtnGen) {
        //do generation call
        //RandGenerator.gen();
        //btBtnGen.doClick();
   System.out.println("test2");
    } else if (e.getSource() == btBtnDel) {
        //do deletion call
        //Main.deleteFile();
        //btBtnDel.doClick();
   System.out.println("test3");
    } else if (e.getSource() == btBtnRead) {
        //do reading call
        //Main.readFile();
        //btBtnRead.doClick();
   System.out.println("test4");
    }
	   System.out.println("test5");
   } 
} 

Panel5 pnPanel5;

JPanel pnPanel6;
JButton btBtnGen;
JButton btBtnDel;
JButton btBtnRead;
JSlider sdSlider;
/**
 */
public static void main( String args[] ) 
{
   try 
   {
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
   }
   catch ( ClassNotFoundException e ) 
   {
   }
   catch ( InstantiationException e ) 
   {
   }
   catch ( IllegalAccessException e ) 
   {
   }
   catch ( UnsupportedLookAndFeelException e ) 
   {
   }
   thedialogout = new dialogout();
      System.out.println("test1");
} 

/**
 */
public dialogout() 
{
   super();
   //super( OWNER, "TITLE", MODAL );

   pnPanel0 = new JPanel();
   GridBagLayout gbPanel0 = new GridBagLayout();
   GridBagConstraints gbcPanel0 = new GridBagConstraints();
   pnPanel0.setLayout( gbPanel0 );

   pnPanel5 = new Panel5();
   gbcPanel0.gridx = 0;
   gbcPanel0.gridy = 0;
   gbcPanel0.gridwidth = 20;
   gbcPanel0.gridheight = 16;
   gbcPanel0.fill = GridBagConstraints.BOTH;
   gbcPanel0.weightx = 1;
   gbcPanel0.weighty = 1;
   gbcPanel0.anchor = GridBagConstraints.NORTH;
   gbPanel0.setConstraints( pnPanel5, gbcPanel0 );
   pnPanel0.add( pnPanel5 );

   pnPanel6 = new JPanel();
   GridBagLayout gbPanel6 = new GridBagLayout();
   GridBagConstraints gbcPanel6 = new GridBagConstraints();
   pnPanel6.setLayout( gbPanel6 );

   btBtnGen = new JButton( "Generate"  );
   btBtnGen.setActionCommand( "genFile(Slider.value)" );
   gbcPanel6.gridx = 0;
   gbcPanel6.gridy = 0;
   gbcPanel6.gridwidth = 7;
   gbcPanel6.gridheight = 2;
   gbcPanel6.fill = GridBagConstraints.BOTH;
   gbcPanel6.weightx = 1;
   gbcPanel6.weighty = 0;
   gbcPanel6.anchor = GridBagConstraints.NORTH;
   gbPanel6.setConstraints( btBtnGen, gbcPanel6 );
   pnPanel6.add( btBtnGen );

   btBtnDel = new JButton( "Delete"  );
   gbcPanel6.gridx = 7;
   gbcPanel6.gridy = 0;
   gbcPanel6.gridwidth = 7;
   gbcPanel6.gridheight = 2;
   gbcPanel6.fill = GridBagConstraints.BOTH;
   gbcPanel6.weightx = 1;
   gbcPanel6.weighty = 0;
   gbcPanel6.anchor = GridBagConstraints.NORTH;
   gbPanel6.setConstraints( btBtnDel, gbcPanel6 );
   pnPanel6.add( btBtnDel );

   btBtnRead = new JButton( "Read"  );
   gbcPanel6.gridx = 14;
   gbcPanel6.gridy = 0;
   gbcPanel6.gridwidth = 7;
   gbcPanel6.gridheight = 2;
   gbcPanel6.fill = GridBagConstraints.BOTH;
   gbcPanel6.weightx = 1;
   gbcPanel6.weighty = 0;
   gbcPanel6.anchor = GridBagConstraints.NORTH;
   gbPanel6.setConstraints( btBtnRead, gbcPanel6 );
   pnPanel6.add( btBtnRead );

   sdSlider = new JSlider( );
   sdSlider.setMajorTickSpacing( 10 );
   sdSlider.setMaximum( 50 );
   sdSlider.setMinorTickSpacing( 5 );
   sdSlider.setPaintTicks( true );
   sdSlider.setValue( 50 );
   gbcPanel6.gridx = 0;
   gbcPanel6.gridy = 2;
   gbcPanel6.gridwidth = 21;
   gbcPanel6.gridheight = 2;
   gbcPanel6.fill = GridBagConstraints.BOTH;
   gbcPanel6.weightx = 1;
   gbcPanel6.weighty = 0;
   gbcPanel6.anchor = GridBagConstraints.NORTH;
   gbPanel6.setConstraints( sdSlider, gbcPanel6 );
   pnPanel6.add( sdSlider );
   gbcPanel0.gridx = 0;
   gbcPanel0.gridy = 16;
   gbcPanel0.gridwidth = 20;
   gbcPanel0.gridheight = 4;
   gbcPanel0.fill = GridBagConstraints.BOTH;
   gbcPanel0.weightx = 1;
   gbcPanel0.weighty = 0;
   gbcPanel0.anchor = GridBagConstraints.NORTH;
   gbPanel0.setConstraints( pnPanel6, gbcPanel0 );
   pnPanel0.add( pnPanel6 );

   setDefaultCloseOperation( DISPOSE_ON_CLOSE );

   setContentPane( pnPanel0 );
   pack();
   setVisible( true );
} 
} 
