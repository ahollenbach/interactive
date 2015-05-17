public class Levelizer extends AbstractSketch {
    private int curColor;
    private String name;
    private float scaling;

    public Levelizer(final PApplet parent, String name, final int width, final int height, float scaling, int colr) {
        super(parent, width, height);

        this.curColor = colr;
        this.name = name;
        this.scaling = scaling;
    }

    @Override
    public void draw() {
        graphics.beginDraw();
        graphics.background(0);
        graphics.fill(curColor);

        // Reverse the orientation of y axis
        graphics.scale(1, -1);
        graphics.translate(0, -graphics.height);

        // Draw the equalizer
        graphics.rect(0, 0, graphics.width, graphics.height*SketchMapperMain.in.mix.level()*scaling);

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
