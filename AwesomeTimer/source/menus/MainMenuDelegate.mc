import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;
import Toybox.Application.Storage;

class MainMenuViewDelegate extends WatchUi.Menu2InputDelegate {
    private var _menu;
    private var _mainDelegate = getDelegate();
    private var nTimer = _mainDelegate.timerList.size();

    // Constructor
    function initialize() {
        _menu = new WatchUi.Menu2({:title=>"Select Timer"});
        setMenu(_mainDelegate.timerList);
        Menu2InputDelegate.initialize();
    }
    // Function setMenu: add all MenuItems from timer-list
    function setMenu(timerList as Array<AwesomeTimerDefinition>) as Void {
        _menu.addItem(new WatchUi.MenuItem("Add Timer...", "", "add_timer", null));
        for (var i = 0; i < timerList.size(); i++) {
            _menu.addItem(new WatchUi.MenuItem(timerList[i].createName(), "", i.toString(), null));
        }
    } 

    function getMenuView() as Menu2 {
        return _menu;
    }

    // On Select button clicked (or item tapped)
    (:typecheck(false))
    function onSelect(item as MenuItem) as Void {
        var id = item.getId().toString();

        if (id.equals("repeat")) {
            // Toggle Repeat Timer function
            var toggleItem = item as WatchUi.ToggleMenuItem;
            _mainDelegate.setRepeat(toggleItem.isEnabled());
            return;
        }

        if (id.equals("add_timer")) {
            // Add new Timer from Number Picker
            WatchUi.pushView(new AddTimerMenu().getView(), new AddTimerMenuDelegate(self), WatchUi.SLIDE_UP);
            return;

        } else {
            // System.println(id.toNumber());
            var timerObject = _mainDelegate.timerList[id.toNumber()] as AwesomeTimerDefinition;
            _mainDelegate.setCurrentTimer(timerObject);
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }

    function addTimer(timerObject as AwesomeTimerDefinition) as Void {
        nTimer++;
        var text = timerObject.createName();
        var idx = nTimer - 1;
        _menu.addItem(new WatchUi.MenuItem(text, "", idx.toString(), null));
        _mainDelegate.addTimerObject(timerObject);
        saveTimer(timerObject);
    }

    function saveTimer(timerObject as AwesomeTimerDefinition) as Void {
        Storage.setValue("number", nTimer);
        timerObject.saveToStorage(nTimer);
    }
}