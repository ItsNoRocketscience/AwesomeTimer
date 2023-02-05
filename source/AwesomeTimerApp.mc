import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class AwesomeTimerApp extends Application.AppBase {
    private static var _mainView;
    private static var _mainDelegate;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        _mainView = new AwesomeTimerView();
        _mainDelegate = new AwesomeTimerDelegate();
        return [ _mainView, _mainDelegate ] as Array<Views or InputDelegates>;
    }

    // Return mainView object
    public function getView() as AwesomeTimerView {
        return _mainView;
    }

    // Return mainDelegate object
    public function getDelegate() as AwesomeTimerDelegate {
        return _mainDelegate;
    } 
}

function getApp() as AwesomeTimerApp {
    return Application.getApp() as AwesomeTimerApp;
}

// Accessible functions for getView and getDelegate
function getView() as AwesomeTimerView {
    return Application.getApp().getView();
}

function getDelegate() as AwesomeTimerDelegate {
    return Application.getApp().getDelegate();
}