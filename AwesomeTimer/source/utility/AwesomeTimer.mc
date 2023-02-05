import Toybox.Lang;
using Toybox.Application.Storage;
using Toybox.System; // Only for printing!

class AwesomeTimerDefinition {
    private var _nSteps;
    private var _definition = new Array<String>[0];
    private var _stepTime = new Array<Number>[0];
    private var _stepType = new Array<String>[0]; // TODO: Enum definition stepType
    public var repeatTimer = false;
    private var _currentStep;

    function initialize() {
        _nSteps = 0;
        _currentStep = -1;
    }

    // Add to new line to definition
    function addDefinition(line as String) {
        // System.println("Adding Definition: " + line);
        _definition = _definition.add(line) as Array<String>;
    }

    // Create the step arrays from definition
    (:typecheck(false))
    function getStepsFromDefinition() {
        _nSteps = _definition.size();
        // System.println("Creating steps from definition: " + _nSteps.toString());
        var _currentDef;
        // TODO: Nested repeats
        for (var i = 0; i < _nSteps; i++) {
            _currentDef = _definition[i];
            // System.println(_currentDef);
            if (_currentDef.find("timer") == 0) {
                // System.println("Adding Timer!");
                _stepType = _stepType.add("timer");
                _stepTime = _stepTime.add(_currentDef.substring(5, null).toNumber());
                // System.println(_stepType);
                // System.println(_stepTime);
            } else if (_currentDef.find("open") == 0) {
                _stepType = _stepType.add("open");
                _stepTime = _stepTime.add(null);
            }
        }
        // System.println(_stepType.size().toString());
        // System.println(_stepTime.size().toString());
    }

    // Get next stepType
    (:typecheck(false))
    function getNextStepType() as String or Null {
        _currentStep++;
        if (_currentStep == _nSteps) {
            return null;
        }
        return _stepType[_currentStep];
    }

    // Get stepTime
    (:typecheck(false))
    function getStepTime() as Number {
        return _stepTime[_currentStep];
    }

    // Reset Timer
    function resetTimer() as Void {
        _currentStep = -1;
    }

    // Create Automatic Name
    (:typecheck(false))
    function createName() as String {
        var rep = "";
        if (repeatTimer) {
            rep = "Rep ";
        }
        var timerString = "" as String;
        var stepType;
        var stepTime;
        for (var i = 0; i < _nSteps; i++) {
            // System.println(i);
            // System.println(_stepType);
            if (_stepType[i].equals("open")) {
                timerString = timerString + "open - ";
            } else {
                timerString = timerString + _stepTime[i].toString() + "s - ";
            }
        }
        return (rep + timerString.substring(null, -3));

    }

    // Save Timer Object to storage
    function saveToStorage(nTimer as Number) {
        // System.println("Saving timer" + nTimer.toString() + ": " + _definition);
        Storage.setValue("timer" + nTimer.toString(), _definition);
        Storage.setValue("timer" + nTimer.toString() + "repeat", repeatTimer);
    }
}

// Load Timer from storage
function loadFromStorage() as Array<AwesomeTimerDefinition> {
    // Storage.clearValues();
    // For checking Storage
    /**for (var i = 1; i < 20; i++) {
        var def = Storage.getValue("timer" + i.toString());
        var rep = Storage.getValue("timer" + i.toString() + "repeat");
        System.println("Timer" + i.toString() + ": " + def + " Repeat: " + rep);
    }**/
    var nTimer = Storage.getValue("number");
    if (nTimer == null) {
        return new Array<AwesomeTimerDefinition>[0];
    }
    var timers = new Array<AwesomeTimerDefinition>[nTimer];
    var newTimer;
    var newDef;
    for (var i = 1; i <= nTimer; i++) {
        newTimer = new AwesomeTimerDefinition();
        newDef = Storage.getValue("timer" + i.toString()) as Array<String>;
        // System.println("Read definition for timer" + i.toString() + ": " + newDef);
        for (var j = 0; j < newDef.size(); j++) {
            newTimer.addDefinition(newDef[j]);
        }
        newTimer.getStepsFromDefinition();
        newTimer.repeatTimer = Storage.getValue("timer" + i.toString() + "repeat") as Boolean;
        timers[i-1] = newTimer;
    }
    return timers;
}