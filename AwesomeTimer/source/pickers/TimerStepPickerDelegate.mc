import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Timer;

class TimerStepPickerDelegate extends WatchUi.BehaviorDelegate {
    private var _pickerView;
    private var _changeSec = true;
    private var _min = 0;
    private var _sec = 0;
    private var _timerType = "timer";
    private var _setTimer = new Timer.Timer();
    private var _callback;

    function initialize(
        pickerView as TimerStepPicker, 
        callback as Method, 
        initialValue as Number,
        initialType as String) {
        BehaviorDelegate.initialize();
        _pickerView = pickerView;
        _callback = callback;
        _min = initialValue / 60 as Number;
        _sec = initialValue % 60 as Number;
        _pickerView.setInitialValue(initialValue);
        _pickerView.setInitialType(initialType);
    }
    // switch timer type
    function switchTimerType() as Void {
        if (_timerType.equals("timer")) {
            _timerType = "open";
            _pickerView.setTopElement("Open");
            _pickerView.deactivateTimer();
            _pickerView.deactivateArrows();
        } else {
            _timerType = "timer";
            _pickerView.setTopElement("Timer");
            _pickerView.setMinutes(_min);
            _pickerView.setSeconds(_sec);
            _pickerView.setArrows(_changeSec);
        }
    }
    // function onHold
    function onHold(clickEvent) as Boolean {
        if (_timerType.equals("open")) {
            return true;
        }
        var coords = clickEvent.getCoordinates();
        var x = coords[0];
        var y = coords[1];
        if (y < 70) {
            return true;
        }
        var callback;
        if (x < 130) {
            // Set Minutes
            _changeSec = false;
            _pickerView.setArrows(_changeSec);
            if (y < 130) {
                // Increase
                callback = method(:incMinutes);
            } else {
                // Decrease
                callback = method(:decMinutes);
            }
        } else {
            // Set Seconds
            _changeSec = true;
            _pickerView.setArrows(_changeSec);
            if (y < 130) {
                // Increase
                callback = method(:incSeconds);
            } else {
                // Decrease
                callback = method(:decSeconds);
            }
        }
        // _setTimer = new Timer.Timer();
        _setTimer.start(callback, 100, true);
        return true;
    }
    // function onRelease
    function onRelease(clickEvent) as Boolean {
        _setTimer.stop();
        return true;
    }
    // function onTap
    function onTap(clickEvent) as Boolean {
        var coords = clickEvent.getCoordinates();
        var x = coords[0];
        var y = coords[1];
        // System.println("X: " + x + " Y: " + y);
        if (y < 70) {
            switchTimerType();
        } else if (y > 220) {
            addStep();
        } else if (_timerType.equals("open")) {
            // Nothing
        } else if (x < 130) {
            // Change minutes
            _changeSec = false;
            _pickerView.setArrows(_changeSec);
            /**if (_changeSec) {
                _changeSec = !(_changeSec);
                _pickerView.setArrows(_changeSec);
            } else {**/
            if (y < 130) {
                // increase
                incMinutes();
            } else {
                // decrease
                decMinutes();
            }
            //}
        } else {
            // Change Seconds
            _changeSec = true;
            _pickerView.setArrows(_changeSec);
            /**if (!_changeSec) {
                _changeSec = !(_changeSec);
                _pickerView.setArrows(_changeSec);
            } else {**/
            if (y < 130) {
                // increase
                incSeconds();
            } else {
                // decrease
                decSeconds();
            }
            //}
        }
        return true;
    }
    // increase seconds
    function incSeconds() as Void {
        if (_sec < 59) {
            _sec++;
            _pickerView.setSeconds(_sec);
        } else {
            _min++;
            _sec = 0;
            _pickerView.setMinutes(_min);
            _pickerView.setSeconds(_sec);
        }
    }
    // decrease seconds
    function decSeconds() as Void {
        if (_sec > 0) {
            _sec--;
            _pickerView.setSeconds(_sec);
        } else if (_min > 0) {
            _min--;
            _sec = 59;
            _pickerView.setMinutes(_min);
            _pickerView.setSeconds(_sec);
        }
    }
    // function increase minutes
    function incMinutes() as Void {
        if (_min < 99) {
            _min++;
            _pickerView.setMinutes(_min);
        }
    }
    // function decrease minutes
    function decMinutes() as Void {
        if (_min > 0) {
            _min--;
            _pickerView.setMinutes(_min);
        }
    }
    // function addStep
    function addStep() {
        if (_timerType.equals("timer") && _min + _sec == 0) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return;
        }
        _callback.invoke(_timerType, _min * 60 + _sec);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
    // function onSelect
    function onMenu() as Boolean {
        addStep();
        return true;
    }
}