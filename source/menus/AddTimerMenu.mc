import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;

class AddTimerMenu {
    private static var _addMenu;

    function initialize() {
        if (_addMenu == null) {
            _addMenu = new WatchUi.Menu2(null);
            setMenu();
        }
    }

    // Return Main view object>
    function getView() {
        return _addMenu;
    }

    // Reset Menu for next use
    function resetMenu() as Void {
        _addMenu = null;
    }

    // Setup menu...
    public function setMenu() {
        // System.println("Setting Menu...");
        _addMenu.addItem(new WatchUi.MenuItem("Done", "", "done", null));
        _addMenu.addItem(new WatchUi.ToggleMenuItem(
            "Repeat All", 
            {:enabled=>"Yes", :disabled=>"No"},
            "repeat",
            true,
            {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
        _addMenu.addItem(new WatchUi.MenuItem("Add Step", "", "addTimer", null));
    }

    function addStep(item as WatchUi.MenuItem) as Void {
        // System.println("Adding Step!");
        _addMenu.addItem(item);
    }
    // Function updateStep
    function updateStep(item as WatchUi.MenuItem, index as Number) as Void {
        _addMenu.updateItem(item, index);
    }
}