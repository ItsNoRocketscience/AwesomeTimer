import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application.Storage;

class MainMenu {
    private static var _menu;
    // private var repeatChecked = false as Boolean;

    function initialize() {
        if (_menu == null) {
            _menu = new WatchUi.Menu2(null);
        }
    }

    // Return Main view object>
    function getView() {
        return _menu;
    }

    // Setup menu...
    public function setMenu(timerList as Array<AwesomeTimerDefinition>) {
        //_menu = new WatchUi.Menu2(null);
        /**_menu.addItem(new WatchUi.ToggleMenuItem(
            "Repeat Timer", 
            {:enabled=>"Yes", :disabled=>"No"},
            "repeat",
            true,
            {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));**/
        _menu.addItem(new WatchUi.MenuItem("Add Timer...", "", "add_timer", null));
        for (var i = 0; i < timerList.size(); i++) {
            _menu.addItem(new WatchUi.MenuItem(timerList[i].createName(), "", i.toString(), null));
        }
    }

    function addItem(item as WatchUi.MenuItem) as Void {
        _menu.addItem(item);
    }
}