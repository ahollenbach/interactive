public class Equalizer extends AbstractSketch {
    private int curColor;
    private String name;
    private float scaling;

    public Equalizer(final PApplet parent, String name, final int width, final int height, float scaling, int colr) {
        super(parent, width, height);

        this.curColor = colr;
        this.name = name;
        this.scaling = scaling;
    }

    @Override
    public void setup() {
    }

    @Override
    public void draw() {
      if(hideOutput || SketchMapperMain.hideAllOutput) {
        graphics.beginDraw();
        graphics.background(0);
        graphics.endDraw();
        return;
      }
      
        graphics.beginDraw();
        graphics.background(0);
        graphics.fill(curColor);

        // Reverse the orientation of y axis
        graphics.scale(1, -1);
        graphics.translate(0, -graphics.height);

        // Draw the equalizer
        float w = ((float)graphics.width)/SketchMapperMain.numSamples;
        for (int i = 0; i < numSamples; i++) {
           graphics.rect(i*w, 0, w, SketchMapperMain.fft.getBand(i) * scaling);
         }


        //graphics.rect(0, 0, graphics.width, graphics.height*in.mix.level()*4);

        graphics.endDraw();
    }

    @Override
    public void keyEvent(KeyEvent event) {

    }

    @Override
    public void mouseEvent(MouseEvent event) {

    }

    @Override
    public String getName() {
        return this.name;
    }
}
