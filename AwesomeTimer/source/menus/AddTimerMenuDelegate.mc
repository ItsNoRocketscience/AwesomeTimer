import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;
import Toybox.Application.Storage;

class AddTimerMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _addTimerMenu;
    private var _stepTimes = new Array<Number>[0];
    private var _stepTypes = new Array<String>[0];
    private var _nSteps = 0;
    private var _repeat = true;
    private var _mainMenuDelegate;
    private var _selectedStep;

    // Constructor
    function initialize(mainMenuDelegate as MainMenuViewDelegate) {
        _mainMenuDelegate = mainMenuDelegate;
        _addTimerMenu = new AddTimerMenu();
        Menu2InputDelegate.initialize();
    }
    // On Select button clicked (or item tapped)
    function onSelect(item as MenuItem) as Void {
        var id = item.getId().toString();

        if (id.equals("repeat")) {
            // Toggle Repeat Timer function
            var toggleItem = item as WatchUi.ToggleMenuItem;
            _repeat = toggleItem.isEnabled();
            return;
        }
        if (id.equals("addTimer")) {
            // Add new Timer from Custom Picker Picker
            var callback = method(:addTimerStep) as Method;
            var pickerView = new TimerStepPicker();
            var initialValue = getInitialTimerValue();
            var pickerDelegate = new TimerStepPickerDelegate(pickerView, callback, initialValue, "timer");
            WatchUi.pushView(pickerView, pickerDelegate, WatchUi.SLIDE_IMMEDIATE);
            return;
        } 
        if (id.equals("done")) {
            // Save timer
            saveAndReturn();
            return;
        }
        // Update Timer Step
        var stepId = id.toNumber();
        _selectedStep = stepId;
        System.println(_selectedStep);
        var stepType = (_stepTypes as Array<String>)[stepId];
        var stepTime = (_stepTimes as Array<Number>)[stepId];
        var callback = method(:updateStep) as Method;
        var pickerView = new TimerStepPicker();
        var pickerDelegate = new TimerStepPickerDelegate(pickerView, callback, stepTime, stepType);
        WatchUi.pushView(pickerView, pickerDelegate, WatchUi.SLIDE_IMMEDIATE);
        return;
    }
    // Function getInitialTimerValue: Get initial value for timer
    function getInitialTimerValue() as Number {
        if (_nSteps == 0) {
            return 0;
        }
        for (var i = _nSteps - 1; i >= 0; i--) {
            if ((_stepTypes as Array<String>)[i].equals("timer")) {
                return (_stepTimes as Array<Number>)[i];
            }
        }
        return 0;
    }
    // function add step with duration
    function addTimerStep(stepType as String, duration as Number) as Void {
        var text = "";
        if (stepType.equals("timer")) {
            _stepTimes = _stepTimes.add(duration) as Array<Number>;
            _stepTypes = _stepTypes.add("timer") as Array<String>;
            text = duration.toString() + "s";
        } else if (stepType.equals("open")) {
            _stepTypes = _stepTypes.add("open") as Array<String>;
            _stepTimes = _stepTimes.add(0) as Array<Number>;
            text = "Break";
        }
        _addTimerMenu.addStep(new WatchUi.MenuItem(text, "", _nSteps.toString(), null));
        _nSteps++;
    }
    // Function updateStep: Set duration and type of step, which was selected
    (:typecheck(false))
    function updateStep(stepType as String, duration as Number) as Void {
        var text = "";
        _stepTimes[_selectedStep as Number] = duration as Number;
        _stepTypes[_selectedStep as Number] = stepType as String;
        if (stepType.equals("timer")) {
            text = duration.toString() + "s";
        } else if (stepType.equals("open")) {
            text = "Break";
        }
        _addTimerMenu.updateStep(new WatchUi.MenuItem(text, "", _selectedStep.toString(), null), _selectedStep + 3);
        _selectedStep = null;
    }
    // function save and return
    function saveAndReturn() as Void {
        _addTimerMenu.resetMenu();
        if (_nSteps == 0) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return;
        } 
        var timerObject = new AwesomeTimerDefinition();
        timerObject.repeatTimer = _repeat;
        for (var i = 0; i < _nSteps; i++) {
            if ((_stepTypes as Array<String>)[i].equals("timer")) {
                timerObject.addDefinition("timer" + (_stepTimes as Array<Number>)[i].toString());
            } else {
                timerObject.addDefinition("open");
            }
        }
        timerObject.getStepsFromDefinition();
        _mainMenuDelegate.addTimer(timerObject);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}