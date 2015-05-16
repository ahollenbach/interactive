public class BassDrum extends AbstractSketch {
    private int curColor;
    private String name;

    public BassDrum(final PApplet parent, String name, final int width, final int height, int colr) {
        super(parent, width, height);

        this.curColor = colr;
        this.name = name;
    }

    @Override
    public void draw() {
        graphics.beginDraw();
        graphics.background(0);
        
        if (SketchMapperMain.beat.isOnset() ) {
          // lighten
          graphics.fill(color(250,240,250));
        } else {
          graphics.fill(curColor);
        }

        // Reverse the orientation of y axis
        graphics.scale(1, -1);
        graphics.translate(0, -graphics.height);

        // Draw the equalizer
        float bandVal = 0;
        for(int i=1;i<=3;i++) {
          bandVal += SketchMapperMain.fft.getBand(i);
        }
        bandVal = bandVal/3; // get avg
        bandVal = bandVal/60; // scale
        float w = graphics.width*bandVal;
        float h = graphics.height*bandVal;
        //graphics.rect(graphics.width/2-w/2, graphics.height/2-h/2, w, h);
        graphics.ellipse(graphics.width/2, graphics.height/2, w, h);

        graphics.endDraw();
    }

    @Override
    public void keyEvent(KeyEvent event) {

    }

    @Override
    public void mouseEvent(MouseEvent event) {

    }

    @Override
    public void setup() {

    }

    @Override
    public String getName() {
        return this.name;
    }
}
