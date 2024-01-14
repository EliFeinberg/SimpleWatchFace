import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;
import Toybox.SensorHistory;

class SimpleWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        //
        var heartImg = WatchUi.loadResource(Rez.Drawables.Heart);
        var stepImg = WatchUi.loadResource(Rez.Drawables.Steps);
        var sleepImg = WatchUi.loadResource(Rez.Drawables.Sleep);

        setTimeDisplay();
        setHeartRateDisplay();
        setBatteryDisplay();
        setStepDisplay();
        
        var yPos = 280;
        var xPos = 120;

        // Draw the icons
        dc.drawBitmap(190, 208, heartImg);
        dc.drawBitmap(xPos + 40, yPos, stepImg); // Adjust the position as needed
        dc.drawBitmap(xPos + 80, yPos, sleepImg); // Adjust the position as needed

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    private function setTimeDisplay() as Void {
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
            hours = hours.format("%02d");
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(getApp().getProperty("ForegroundColor") as Number);
        view.setText(timeString);
    }

    private function setHeartRateDisplay() as Void {
        var heartrateIterator = ActivityMonitor.getHeartRateHistory(null, false);
        var heartRate = heartrateIterator.next().heartRate;
        var view = View.findDrawableById("HeartRateLabel") as Text;
        view.setText(heartRate.format("%d"));
    }

    private function setBatteryDisplay() as Void {
        var batteryLevel = System.getSystemStats().battery;
        var view = View.findDrawableById("BatteryLabel") as Text;
        view.setText(batteryLevel.format("%d"));
    }

    private function setStepDisplay() as Void {
        var stepCount = ActivityMonitor.getInfo().steps;

        // Check if stepCount is greater than or equal to 1000
        if (stepCount >= 1000) {
            // Convert steps to thousands and display as K
            stepCount = stepCount / 1000.0;
            var view = View.findDrawableById("StepsLabel") as Text;
            view.setText(stepCount.format("%.1fK"));
        } else {
            // Display the steps as is (less than 1000)
            var view = View.findDrawableById("StepsLabel") as Text;
            view.setText(stepCount.format("%d"));
        }
    }


    // private function setSleepDisplay() as Void {
    //     var sleepTime = ActivityMonitor.getSleepTime();
    //     var view = View.findDrawableById("SleepTimeLabel") as Text;
    //     view.setText(sleepTime.format("%d"));
    // }


    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
