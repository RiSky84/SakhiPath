import 'package:flutter/material.dart';

class TimeManagementScreen extends StatefulWidget {
  const TimeManagementScreen({super.key});

  @override
  State<TimeManagementScreen> createState() => _TimeManagementScreenState();
}

class _TimeManagementScreenState extends State<TimeManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _studyMinutes = 0;
  int _studySeconds = 0;
  bool _isStudying = false;

  final int _dailyScreenTime = 245;
  final int _screenTimeLimit = 300;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Management'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.timer), text: 'Study Timer'),
            Tab(icon: Icon(Icons.phone_android), text: 'Screen Time'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Schedule'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStudyTimer(),
          _buildScreenTime(),
          _buildSchedule(),
        ],
      ),
    );
  }

  Widget _buildStudyTimer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isStudying ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              border: Border.all(
                color: _isStudying ? Colors.green : Colors.grey,
                width: 8,
              ),
            ),
            child: Center(
              child: Text(
                '${_studyMinutes.toString().padLeft(2, '0')}:${_studySeconds.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isStudying = !_isStudying;
                  });
                },
                icon: Icon(_isStudying ? Icons.pause : Icons.play_arrow),
                label: Text(_isStudying ? 'Pause' : 'Start'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: _isStudying ? Colors.orange : Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _studyMinutes = 0;
                    _studySeconds = 0;
                    _isStudying = false;
                  });
                },
                icon: const Icon(Icons.stop),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          const Text(
            'Quick Start',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickStartChip('25 min Pomodoro', 25),
              _buildQuickStartChip('45 min Session', 45),
              _buildQuickStartChip('1 Hour', 60),
              _buildQuickStartChip('2 Hours', 120),
            ],
          ),
          const SizedBox(height: 40),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Study Stats',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow('Total Study Time', '2h 30m', Icons.timer),
                  _buildStatRow('Sessions Completed', '4', Icons.check_circle),
                  _buildStatRow('Average Focus', '85%', Icons.trending_up),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenTime() {
    final percentage = (_dailyScreenTime / _screenTimeLimit * 100).clamp(0, 100);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Today\'s Screen Time',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: percentage / 100,
                          strokeWidth: 20,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          color: percentage > 80 ? Colors.red : Colors.blue,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${(_dailyScreenTime ~/ 60)}h ${_dailyScreenTime % 60}m',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${percentage.toInt()}% of limit',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Limit: ${_screenTimeLimit ~/ 60}h ${_screenTimeLimit % 60}m daily',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'App Usage',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildAppUsageItem('Social Media', 95, Colors.purple),
          _buildAppUsageItem('Entertainment', 75, Colors.red),
          _buildAppUsageItem('Education', 45, Colors.green),
          _buildAppUsageItem('Productivity', 30, Colors.blue),

          const SizedBox(height: 24),

          Card(
            child: ListTile(
              leading: const Icon(Icons.do_not_disturb, color: Colors.orange),
              title: const Text('Focus Mode'),
              subtitle: const Text('Block distracting apps'),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Focus mode toggled')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedule() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Today\'s Schedule',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildScheduleItem('Morning Study', '06:00 - 08:00', 'Mathematics', Colors.blue, true),
        _buildScheduleItem('Break Time', '08:00 - 08:30', 'Breakfast', Colors.grey, true),
        _buildScheduleItem('Study Session', '09:00 - 11:00', 'Science', Colors.green, false),
        _buildScheduleItem('Lunch Break', '12:00 - 13:00', 'Lunch', Colors.grey, false),
        _buildScheduleItem('Afternoon Study', '14:00 - 16:00', 'Languages', Colors.orange, false),
        _buildScheduleItem('Evening Study', '17:00 - 19:00', 'Review', Colors.purple, false),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add new schedule item')),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Schedule'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStartChip(String label, int minutes) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        setState(() {
          _studyMinutes = minutes;
          _studySeconds = 0;
          _isStudying = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Started $label timer')),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildAppUsageItem(String appName, int minutes, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.apps, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: minutes / 120,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    color: color,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${minutes}m',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String title, String time, String subject, Color color, bool isCompleted) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.schedule,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('$time\n$subject'),
        isThreeLine: true,
        trailing: isCompleted
            ? const Icon(Icons.done, color: Colors.green)
            : null,
      ),
    );
  }
}
