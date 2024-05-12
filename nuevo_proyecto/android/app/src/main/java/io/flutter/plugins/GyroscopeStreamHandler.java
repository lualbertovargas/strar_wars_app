import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import io.flutter.plugin.common.EventChannel;

public class GyroscopeStreamHandler implements EventChannel.StreamHandler, SensorEventListener {
    private SensorManager sensorManager;
    private Sensor gyroscopeSensor;
    private EventChannel.EventSink eventSink;

    GyroscopeStreamHandler(SensorManager sensorManager) {
        this.sensorManager = sensorManager;
        gyroscopeSensor = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
        sensorManager.registerListener(this, gyroscopeSensor, SensorManager.SENSOR_DELAY_NORMAL);
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
        sensorManager.unregisterListener(this);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (eventSink != null) {
            eventSink.success(new float[]{event.values[0], event.values[1], event.values[2]});
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
}
