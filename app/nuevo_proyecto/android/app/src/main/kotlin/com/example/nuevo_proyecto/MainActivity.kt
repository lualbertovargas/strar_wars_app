package com.example.nuevo_proyecto

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity(), SensorEventListener {
    private var sensorManager: SensorManager? = null
    private var gyroscopeSensor: Sensor? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onResume() {
        super.onResume()
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        gyroscopeSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_GYROSCOPE)

        val eventChannel = EventChannel(flutterEngine?.dartExecutor?.binaryMessenger, "gyroscope_event")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
                sensorManager?.registerListener(this@MainActivity, gyroscopeSensor, SensorManager.SENSOR_DELAY_NORMAL)
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
                sensorManager?.unregisterListener(this@MainActivity)
            }
        })
    }

    override fun onPause() {
        super.onPause()
        sensorManager?.unregisterListener(this)
    }

    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            val values = it.values
            if (eventSink != null) {
                eventSink?.success(floatArrayOf(values[0], values[1], values[2]))
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // No necesitamos hacer nada aquí
    }
}
