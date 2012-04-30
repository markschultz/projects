import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.colorchooser.*;


public class Painter extends JFrame{
	Canvas canvas;
	JColorChooser colorch;
	JPanel mainPanel;
	JPanel slideTextPanel;
	JSlider slider;
	JTextField text;
	public Painter(){
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setSize(600,500);
		setVisible(true);
		mainPanel = new JPanel(new BorderLayout());
		slideTextPanel = new JPanel();
		canvas = new Canvas();
		canvas.setBackground(Color.WHITE);
		canvas.addMouseMotionListener(motionListener);
		canvas.addMouseListener(clickListener);
		colorch = new JColorChooser(Color.BLACK);
		colorch.setPreviewPanel(new JPanel());
		text = new JTextField();
		text.setColumns(4);
		text.setText("10");
		text.setEditable(false);
		slider = new JSlider(SwingConstants.VERTICAL, 1, 101, 10);
		slider.setMajorTickSpacing(10);
		slider.setMinorTickSpacing(1);
		slider.setPaintTicks(true);
		slider.setPaintLabels(true);
		slider.addChangeListener(listener);
		mainPanel.add(canvas, BorderLayout.CENTER);
		mainPanel.add(colorch, BorderLayout.PAGE_START);
		slideTextPanel.add(slider, BorderLayout.PAGE_START);
		slideTextPanel.add(text, BorderLayout.PAGE_END);
		mainPanel.add(slideTextPanel, BorderLayout.LINE_END);
		add(mainPanel);
	}

	public static void main(String[] args){
		Painter painter = new Painter();
	}

	ChangeListener listener = new ChangeListener() {
		public void stateChanged(ChangeEvent changeEvent){
			text.setText(Integer.toString(slider.getValue()));
		}
	};
	MouseListener clickListener = new MouseListener() {
		public void mousePressed(MouseEvent mouseEvent){
			Graphics graphics = canvas.getGraphics();
			if(graphics != null){
				graphics.setColor(colorch.getColor());
				graphics.fillOval(mouseEvent.getX() - slider.getValue()/2, mouseEvent.getY() - slider.getValue()/2, slider.getValue(), slider.getValue());
			}
		}
		public void mouseExited(MouseEvent mouseEvent){}
		public void mouseEntered(MouseEvent mouseEvent){}
		public void mouseReleased(MouseEvent mouseEvent){}
		public void mouseClicked(MouseEvent mouseEvent){}
	};
	MouseMotionListener motionListener = new MouseMotionListener() {
		public void mouseDragged(MouseEvent mouseEvent) {
			Graphics graphics = canvas.getGraphics();
			if(graphics != null){
				graphics.setColor(colorch.getColor());
				graphics.fillOval(mouseEvent.getX() - slider.getValue()/2, mouseEvent.getY() - slider.getValue()/2, slider.getValue(), slider.getValue());
			}
		}
		public void mouseMoved(MouseEvent mouseEvent) {}
	};

}

