import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.System;
import Toybox.Attention;
import Toybox.Application.Storage;

class AwesomeTimerDelegate extends WatchUi.BehaviorDelegate {
    private static var duration = 10; // TODO: Initialize from storage if possible
    private var _inProgress = false;
    private var _isPaused = false;
    private var _repeatTimer = true;
    private var _openTimer = false;

    private var _currentDuration;
    private static var _timer;

    private var _mainView = getView();

    public var timerList;
    private var _currentTimer;

    function initialize() {
        BehaviorDelegate.initialize();
        timerList = loadFromStorage();
    }

    // Initialize timer
    (:typecheck(false))
    function initializeTimer() as Void {
        if (timerList.size() == 0) {
            // No timers loaded
            // System.println("Defining default Timer: Rep 10s");
            var defaultTimer = new AwesomeTimerDefinition();
            defaultTimer.repeatTimer = _repeatTimer;
            defaultTimer.addDefinition("timer10");
            defaultTimer.getStepsFromDefinition();
            setCurrentTimer(defaultTimer);
        } else {
            setCurrentTimer(timerList[0]);
        }
    }

    // Called when Start/Stop is pressed
    function onSelect() as Boolean {
        return handleStart();
    }

    // Called when screen is tapped
    function onTap(clickEvent) as Boolean {
        return handleStart();
    }

    // Handle both screen tapping and pressing Start/Stop button
    function handleStart() as Boolean {
        if (!_inProgress) {
            // New Timer => Start Countdown
            _inProgress = true;
            startCountdown();
        } else if (!_isPaused && _openTimer) {
            nextStep();
        } else if (!_isPaused) {
            // Timer in progress and not paused => Pause Timer
            _isPaused = true;
            pauseCountdown();
        } else {
            // Timer in progress but paused => Resume Timer
            _isPaused = false;
            resumeCountdown();
        }
        return true;
    }

    // on Menu (holding up) => Open Main Menu
    function onMenu() as Boolean {
        var menuDelegate = new MainMenuViewDelegate();
        var menuView = menuDelegate.getMenuView();
        WatchUi.pushView(menuView, menuDelegate, WatchUi.SLIDE_UP);
        return true;
    }

    // on Touchscreen Hold => Open Main Menu
    function onHold(clickEvent) as Boolean {
        var menuDelegate = new MainMenuViewDelegate();
        var menuView = menuDelegate.getMenuView();
        WatchUi.pushView(menuView, menuDelegate, WatchUi.SLIDE_UP);
        return true;
    }

    // Start new Timer Countdown
    function startCountdown() as Void {
        _currentDuration = duration;
        _timer = new Timer.Timer();
        // Start timer: Callback, Time (in ms), repeat t/f
        _timer.start(method(:updateCountdownValue), 1000, true);
        _mainView.setStateValue("Running");
        callAttentionStartTimer(); // Check if this can be felt for repeated timers
        _mainView.setTimerValue(_currentDuration);
    }

    // Pause Timer Countdown
    function pauseCountdown() as Void {
        _timer.stop();
        _mainView.setStateValue("Paused");
    }

    // Resume Timer Countdown
    function resumeCountdown() as Void {
        _timer.start(method(:updateCountdownValue), 1000, true);
        callAttentionStartTimer();
        _mainView.setStateValue("Running");
    }

    // Update value of timer internally and on screen
    function updateCountdownValue() as Void {
        if (_openTimer) {
            _currentDuration++;
            _mainView.setTimerValue(_currentDuration);
        } else {    
            _currentDuration--;
            _mainView.setTimerValue(_currentDuration);
        }
        if (_currentDuration == 0) {
            // Current timer over => set next step
            nextStep();
        }
        WatchUi.requestUpdate();
    }

    // Function next Step
    function nextStep() as Void {
        _timer.stop();
        var nextStepType = _currentTimer.getNextStepType();
        if (nextStepType == null) {
            // All steps done
            if (_repeatTimer) {
                // Repeat everything
                callAttentionRepeatTimer();
                _currentTimer.resetTimer();
                nextStep();
            } else {
                // Stop timer
                _timer.stop();
                _inProgress = false;
                callAttentionStopTimer();
                _mainView.setStateValue("Stopped");
                // Reset Timer for restart
                setCurrentTimer(_currentTimer);
                return;
            }
        } else {
            // Do next step
            callAttentionRepeatTimer();
            if (nextStepType.equals("timer")) {
                _currentDuration = _currentTimer.getStepTime();
                _mainView.setTimerValue(_currentDuration);
                setOpenTimer(false);
            } else if (nextStepType.equals("open")) {
                _currentDuration = 0;
                _mainView.setTimerValue(_currentDuration);
                setOpenTimer(true);
            }
        }
        _timer.start(method(:updateCountdownValue), 1000, true);
    }
    
    // Set Duration
    function setDuration(value as Number) as Void {
        if (_inProgress == true) {
            _timer.stop();
            _mainView.setStateValue("Stopped");
        }
        duration = value;
        _mainView.setTimerValue(duration);
        _inProgress = false;
        _isPaused = false;
    }

    // Set Repeat flag
    function setRepeat(enabled as Boolean) as Void {
        _repeatTimer = enabled;
        if (enabled) {
            _mainView.setRepeatLabel("Repeat");
        } else {
            _mainView.setRepeatLabel("");
        }
        
    }
    // Call Attention when timer stops
    function callAttentionStopTimer() as Void {
        // TODO: Add acoustic signal (optional)
        var vibeData = [new Attention.VibeProfile(100, 1000)];
        Attention.vibrate(vibeData);
    }
    // Call Attention when timer starts
    function callAttentionStartTimer() as Void {
        // TODO: Add acoustic signal (optional)
        var vibeData = [new Attention.VibeProfile(100, 100)];
        Attention.vibrate(vibeData);
    
    }
    // Call Attention when is repeated
    function callAttentionRepeatTimer() as Void {
        // TODO: Add acoustic signal (optional)
        var vibeData = [
            new Attention.VibeProfile(100, 500), 
            new Attention.VibeProfile(0, 200), 
            new Attention.VibeProfile(100, 100), ];
        Attention.vibrate(vibeData);
    
    }
    // Set new Timer
    function setCurrentTimer(timerObject as AwesomeTimerDefinition) as Void {
        _mainView.setStateValue("Stopped");
        _currentTimer = timerObject;
        _currentTimer.resetTimer();
        setRepeat(_currentTimer.repeatTimer);
        // Don't call nextStep function to prevent vibrate
        var stepType = _currentTimer.getNextStepType();
        if (stepType.equals("timer")) {
            setDuration(_currentTimer.getStepTime());
            _openTimer = false;
        } else if (stepType.equals("open")) {
            setDuration(0);
            _openTimer = true;
        }
    }
    // function setOpenTimer
    function setOpenTimer(enabled as Boolean) as Void {
        _openTimer = enabled;
        if (_openTimer) {
            _mainView.setStateValue("Open Break");
        } else {
            _mainView.setStateValue("Running");
        }
    }
    // Add AwesomeTimerDefinition-object to list
    function addTimerObject(timerObject as AwesomeTimerDefinition) as Void {
        timerList = timerList.add(timerObject);
    }
    // Delete Timer
    function deleteTimer() as Void {
        if (timerList.size() == 0) {
            return;
        }
        // Remove from Storage
        var idx = timerList.indexOf(_currentTimer);
        var nTimer = timerList.size();
        if (idx + 1 == nTimer) {
            // Remove last timer
        } else {
            // Remove from within list
            // System.println("Removing Timer" + (idx + 1).toString());
            var timerDef;
            var timerRep;
            for (var i = idx + 1; i < nTimer; i++) {
                // System.println((i+1).toString() + " / " + nTimer.toString());
                timerDef = Storage.getValue("timer" + (i + 1).toString());
                timerRep = Storage.getValue("timer" + (i + 1).toString() + "repeat");
                Storage.setValue("timer" + i.toString(), timerDef);
                Storage.setValue("timer" + i.toString() + "repeat", timerRep);
            }
        }
        Storage.deleteValue("timer" + nTimer.toString());
        Storage.deleteValue("timer" + nTimer.toString() + "repeat");
        Storage.setValue("number", nTimer - 1);
        timerList.remove(_currentTimer);
        initializeTimer();
    }
    // function onFlick
    function onFlick(flickEvent) as Boolean {
        if (flickEvent.getDirection() == 0) {
            WatchUi.pushView(
                new WatchUi.Confirmation("Delete Timer?"),
                new DeleteConfirmationDelegate(method(:deleteTimer) as Method),
                WatchUi.SLIDE_UP
            );
        }
        return true;
    }

}