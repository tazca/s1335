import 'package:flutter/material.dart';

import '/src/clock/clock_controller.dart' show ClockFace;
import '/src/location/location_view.dart';
import '/src/utils/platform_aware_image.dart' show platformAwareImageProvider;

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).devicePixelRatio * 96 * 3.0,
            maxHeight: MediaQuery.of(context).devicePixelRatio * 96 * 3.0,
            minWidth: MediaQuery.of(context).devicePixelRatio * 96 * 4.8,
            maxWidth: MediaQuery.of(context).devicePixelRatio * 96 * 4.8,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _alarm(context),
                      ],
                    ),
                    const Spacer(),
                    const Align(
                      alignment: Alignment.center,
                      child: Text('Clock faces'),
                    ),
                    const Spacer(),
                    _clockFace(context),
                    const Spacer(),
                    const Align(
                      alignment: Alignment.center,
                      child: Text('Miscellaneous'),
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        Expanded(child: _oled(context)),
                        Expanded(child: _intro(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _alarm(BuildContext context) {
    return Row(
      children: <Widget>[
        FilledButton.tonal(
          onPressed: controller.alarmSet
              ? () async {
                  TimeOfDay? setAlarm = await showTimePicker(
                    initialTime:
                        controller.alarm ?? const TimeOfDay(hour: 0, minute: 0),
                    context: context,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  controller.updateAlarm(setAlarm);
                }
              : null,
          child: const Text('Set alarm'),
        ),
        Switch.adaptive(
          onChanged: (x) {
            if (controller.alarmSet) {
              controller.updateAlarmSet(false);
            } else {
              controller.updateAlarmSet(true);
            }
          },
          value: controller.alarmSet,
        ),
      ],
    );
  }

  Widget _location(BuildContext context) {
    return FilledButton.tonal(
      onPressed: (controller.clockFace == ClockFace.solar) ? () {
        Navigator.restorablePushNamed(context, LocationView.routeName);
      } : null,
      child: const Text('Location'),
    );
  }

  Widget _clockFace(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Material(
            child: Ink.image(
              fit: BoxFit.contain,
              width: 100,
              height: 100,
              image: platformAwareImageProvider('assets/images/ledclock.png'),
              child: InkWell(
                onTap: () {
                  controller.updateClockFace(ClockFace.led);
                },
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Material(
                child: Ink.image(
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  image: platformAwareImageProvider(
                      'assets/images/solarclock.png'),
                  child: InkWell(
                    onTap: () {
                      controller.updateClockFace(ClockFace.solar);
                    },
                  ),
                ),
              ),
            ),
            _location(context),
          ],
        ),
      ],
    );
  }

  Widget _oled(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Text('Prevent OLED burn'),
        Switch.adaptive(
          onChanged: (x) {
            if (controller.oled) {
              controller.updateOled(false);
            } else {
              controller.updateOled(true);
            }
          },
          value: controller.oled,
        ),
      ],
    );
  }

  Widget _intro(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Text('Show intro texts'),
        Switch.adaptive(
          onChanged: (x) {
            if (controller.intro) {
              controller.updateIntro(false);
            } else {
              controller.updateIntro(true);
            }
          },
          value: controller.intro,
        ),
      ],
    );
  }
}
