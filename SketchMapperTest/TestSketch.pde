public class TestSketch extends AbstractSketch {
    float t = 0;  
  
    int lightPink = color(224,222,250);
    int yellow   = color(240,242,166);
    
    int c  = lightPink;
    
    Minim minim;
    AudioInput in;

    public TestSketch(final PApplet parent, final int width, final int height, Minim m, AudioInput i) {
        super(parent, width, height);
        
        minim = m;
        in = i;
    }

    @Override
    public void draw() {
        graphics.beginDraw();
        graphics.background(0);
        graphics.fill(c);
        
        // Reverse the orientation of y axis
        graphics.scale(1, -1);
        graphics.translate(0, -graphics.height);
        
        // Draw the equalizer
        graphics.rect(0, 0, graphics.width, graphics.height*in.mix.level()*4);
        
        graphics.endDraw();
    }
    
    @Override
    public void keyEvent(KeyEvent event) {

    }

    @Override
    public void mouseEvent(MouseEvent event) {
      c = (c == lightPink) ? yellow : lightPink;
    }

    @Override
    public void setup() {

    }
}
