import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.System;

class AwesomeTimerView extends WatchUi.View {
    private static var _clockElement;
    private static var _currentTimerElement;
    private static var _stateElement;
    private static var _repeatLabelElement;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        // Get drawables to modify
        _clockElement = findDrawableById("clock_title");
        _currentTimerElement = findDrawableById("timer_value");
        _repeatLabelElement = findDrawableById("repeat_label");
        _stateElement = findDrawableById("state_value");

        // Start Clock
        clockTimerMinutes();

        // Initialize Timers
        getDelegate().initializeTimer();
    }

    // Called to set time and is recalled every minute
    function clockTimerMinutes() as Void {
        var clockTime = System.getClockTime();
        var clockText = (
            clockTime.hour.format("%02d") + ":" + 
            clockTime.min.format("%02d")
        );
        _clockElement.setText(clockText);
        WatchUi.requestUpdate();

        var clockTimer = new Timer.Timer();
        clockTimer.start(method(:clockTimerMinutes), (60 - clockTime.sec) * 1000, false);
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
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // Set current timer value in min:sec
    public function setTimerValue(value as Number) as Void {
        var minutes = value / 60;
        var seconds = value % 60;

        _currentTimerElement.setText(minutes.format("%d") + ":" + seconds.format("%02d"));
    }

    public function setStateValue(state as String) as Void {
        _stateElement.setText(state);
        WatchUi.requestUpdate();
    }

    // Set repeat label
    public function setRepeatLabel(state as String) as Void {
        _repeatLabelElement.setText(state);
        WatchUi.requestUpdate();
    }
}
