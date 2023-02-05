import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

const ARROW_WIDTH = 50;
const ARROW_HEIGHT = 25;

class TimerStepPicker extends WatchUi.View {
    private var _topElement;
    private var _minElement;
    private var _secElement;
    private var _arrows = SecArrows;
    private var _initialValue;
    private var _initialType;

    enum {
        UpArrow,
        DownArrow
    }

    enum {
        NoArrows,
        SecArrows,
        MinArrows
    }

    function initialize() {
        View.initialize();
    }
    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.PickerLayout(dc));
        // get Elements
        _topElement = findDrawableById("topElement");
        _minElement = findDrawableById("minElement");
        _secElement = findDrawableById("secElement");
        if (_initialType.equals("timer")) {
            // Set initial values for min and sec
            setMinutes(_initialValue / 60 as Number);
            setSeconds(_initialValue % 60 as Number);
        } else if (_initialType.equals("open")) {
            setTopElement("Open");
            deactivateTimer();
        }
    }
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }
    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        if (_arrows == SecArrows) {
            drawSecArrows(dc);
        } else if (_arrows == MinArrows) {
            drawMinArrows(dc);
        }
    }
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }
    // Function drawArrow
    function drawArrow(
        dc as Dc, 
        direction as Number, 
        locX as Number or Float or String, 
        locY as Number or Float or String, 
        width as Number, 
        height as Number) {
        if (locX instanceof String) {
            locX = locX.substring(null, -1).toFloat() / 100 * dc.getWidth();
        }
        if (locY instanceof String) {
            locY = locY.substring(null, -1).toFloat() / 100 * dc.getHeight();
        }
        if (direction == UpArrow) {
            // Up Arrow
            dc.fillPolygon([
                [locX - width / 2, locY], 
                [locX + width / 2, locY], 
                [locX, locY - height]]);
        } else if (direction == DownArrow) {
            dc.fillPolygon([
                [locX - width / 2, locY], 
                [locX + width / 2, locY], 
                [locX, locY + height]]);
        }
    }
    // Function drawMinArrows
    function drawMinArrows(dc as Dc) {
        // Up-Arrow
        drawArrow(dc, UpArrow, "25%", "33%", ARROW_WIDTH, ARROW_HEIGHT);
        // Down-Arrow
        drawArrow(dc, DownArrow, "25%", "68%", ARROW_WIDTH, ARROW_HEIGHT);
    }
    // Function drawSecArrows
    function drawSecArrows(dc as Dc) {
        // Up-Arrow
        drawArrow(dc, UpArrow, "75%", "33%", ARROW_WIDTH, ARROW_HEIGHT);
        // Down-Arrow
        drawArrow(dc, DownArrow, "75%", "68%", ARROW_WIDTH, ARROW_HEIGHT);
    }
    // Set topElement
    function setTopElement(text as String) as Void {
        _topElement.setText(text);
        WatchUi.requestUpdate();
    }
    // Set arrows
    function setArrows(changeSec as Boolean) as Void {
        if (changeSec) {
            _arrows = SecArrows;
        } else {
            _arrows = MinArrows;
        }
        WatchUi.requestUpdate();
    }
    // Deactivate arrows
    function deactivateArrows() as Void {
        _arrows = NoArrows;
        WatchUi.requestUpdate();
    }
    // Set seconds
    function setSeconds(seconds as Number) as Void {
        _secElement.setText(seconds.format("%02d"));
        WatchUi.requestUpdate();
    }
    // Set Minutes
    function setMinutes(minutes as Number) as Void {
        _minElement.setText(minutes.format("%02d"));
        WatchUi.requestUpdate();
    }
    // Deactivate Timer
    function deactivateTimer() as Void {
        _minElement.setText("--");
        _secElement.setText("--");
        WatchUi.requestUpdate();
    }
    // Function setInitialValue
    function setInitialValue(initialValue as Number) as Void {
        _initialValue = initialValue;
        return;
    }
    // Function setInitialType
    function setInitialType(initialType as String) as Void {
        _initialType = initialType;
        return;
    }
}
