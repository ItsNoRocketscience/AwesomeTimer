import Toybox.WatchUi;
import Toybox.Lang;

class DeleteConfirmationDelegate extends ConfirmationDelegate {
    private var _callback;

    function initialize(callback as Method) {
        ConfirmationDelegate.initialize();
        _callback = callback;
    }

    function onResponse(response) as Boolean {
        if (response == WatchUi.CONFIRM_NO) {
            //WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        } else {
            _callback.invoke();
        }
        return true;
    }
}