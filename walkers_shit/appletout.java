//======================================================
// Source code generated by jvider v1.8 EVALUATION version.
// http://www.jvider.com/
//======================================================
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
import javax.swing.JApplet;
/**
 * @author  Administrator
 * @created March 12, 2011
 */
public class appletout extends JApplet 
{
static appletout theappletout;

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
      JScrollPane scpTxtOut = new JScrollPane( taTxtOut );
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
   theappletout = new appletout();
}

/**
 */
public appletout() 
{
   super();

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

   setContentPane( pnPanel0 );
} 
} 
