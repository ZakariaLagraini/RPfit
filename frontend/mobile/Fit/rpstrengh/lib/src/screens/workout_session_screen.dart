import 'package:flutter/material.dart';
import 'dart:async';

class WorkoutSessionScreen extends StatefulWidget {
  final String title;
  final String imagePath;

  const WorkoutSessionScreen({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int _countdown = 3;
  bool _isCountingDown = true;
  bool _isResting = false;
  int _currentSet = 1;
  int _restSeconds = 60;
  Timer? _timer;
  final int totalSets = 3;
  List<bool> completedSets = [false, false, false];
  String _elapsedTime = "00:00";
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    startCountdown();
    _stopwatch.start();
    _startTimeTracking();
  }

  void _startTimeTracking() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          final minutes = _stopwatch.elapsed.inMinutes;
          final seconds = _stopwatch.elapsed.inSeconds % 60;
          _elapsedTime = "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
        });
      }
    });
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isCountingDown = false;
        });
      }
    });
  }

  void startRest() {
    setState(() {
      _isResting = true;
      _restSeconds = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSeconds > 0) {
        setState(() {
          _restSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResting = false;
        });
      }
    });
  }

  void _logSet() {
    if (_currentSet <= totalSets) {
      setState(() {
        completedSets[_currentSet - 1] = true;
        if (_currentSet < totalSets) {
          _currentSet++;
          startRest();
        }
      });
    }
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Your progress:', style: TextStyle(color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProgressItem(Icons.timer, '${_stopwatch.elapsed.inSeconds} sec', 'Duration'),
                _buildProgressItem(Icons.format_list_numbered, '$totalSets', 'Sets'),
                _buildProgressItem(Icons.fitness_center, '0 kg', 'Volume'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Do you want to finish?', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.black),
        Text(value, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12)),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Time: $_elapsedTime', style: const TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
          TextButton(
            onPressed: _showFinishDialog,
            child: const Text('Finish', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tips and Exercise Image
          Row(
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.lightbulb_outline, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_list_bulleted, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: _isCountingDown
                      ? Text(
                          _countdown.toString(),
                          style: const TextStyle(
                            fontSize: 150,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : _isResting
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.accessibility_new, size: 50, color: Colors.black),
                                const Text(
                                  'Rest',
                                  style: TextStyle(color: Colors.black, fontSize: 40),
                                ),
                                Text(
                                  _restSeconds.toString(),
                                  style: const TextStyle(color: Colors.black, fontSize: 60),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _timer?.cancel();
                                    setState(() {
                                      _isResting = false;
                                    });
                                  },
                                  child: const Text('Skip', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            )
                          : Image.asset(widget.imagePath, height: 200),
                ),
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      widget.imagePath,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),

          // Exercise Info and Sets
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ...List.generate(5, (index) {
                                return Container(
                                  width: 15,
                                  height: 4,
                                  margin: const EdgeInsets.only(right: 2),
                                  color: index < 3 ? Colors.red : Colors.grey[700],
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.timer, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '60 rest',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Sets', style: TextStyle(color: Colors.black)),
                      Text('Last', style: TextStyle(color: Colors.black)),
                      Text('Reps', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: totalSets + 1,
                      itemBuilder: (context, index) {
                        if (index == totalSets) {
                          return Center(
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add, color: Colors.black),
                              label: const Text('Add a set', style: TextStyle(color: Colors.black)),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                            ),
                          );
                        }
                        return Container(
                          color: _currentSet - 1 == index ? Colors.red : null,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  if (completedSets[index])
                                    const Icon(Icons.check, color: Colors.black)
                                  else
                                    Text('${index + 1}',
                                        style: const TextStyle(color: Colors.black)),
                                ],
                              ),
                              Text('10 reps', style: TextStyle(color: Colors.grey[600])),
                              const Text('10', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: !_isCountingDown && !_isResting 
                        ? completedSets.every((set) => set) 
                          ? _showFinishDialog  
                          : _logSet 
                        : null,
                      icon: const Icon(Icons.check),
                      label: Text(completedSets.every((set) => set) ? 'Finish' : 'Log set'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 