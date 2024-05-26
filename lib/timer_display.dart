import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';


class CountDownPage extends StatefulWidget {
  final int duration;
  final VoidCallback? onReset;
  const CountDownPage({super.key, required this.duration, required this.onReset});

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  late StopWatchTimer _stopWatchTimer;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _stopWatchTimer = StopWatchTimer(
        mode: StopWatchMode.countDown,
        presetMillisecond: 1000 * widget.duration,
        onEnded: widget.onReset
    );
    _stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stop Watch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snapshot) {
                final displayTime = StopWatchTimer.getDisplayTime(
                  snapshot.data!,
                );
                return Center(
                  child: SizedBox(
                    width: 144,
                    child: Text(
                      displayTime,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: widget.onReset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}