import 'package:be_human/new_activity_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home:  MainApp()
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 125, 139, 174),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 89, 95, 156),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Be Human',
              style: TextStyle(
                color: const Color.fromARGB(255, 34, 34, 45)
              ),
            ),
          ),
        ),
        body: Center(
          child: ActivityPage()
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewActivityPage()));
          },
          backgroundColor: const Color.fromARGB(255, 174, 175, 220),
          foregroundColor: const Color.fromARGB(255, 34, 34, 45),
          child: Icon(Icons.add),
        ),
    );
  }
}
class DayBox extends StatelessWidget {
  const DayBox({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final String day;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(  
      onTap: onTap,
      child: Container(  
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
          ? const Color.fromARGB(255, 15, 7, 75)
          : const Color.fromARGB(255, 174, 175, 220),
          border: Border.all(
            color: isSelected
            ? Colors.white
            : const Color.fromARGB(255, 41, 53, 59),
             strokeAlign: BorderSide.strokeAlignCenter
          ),
          borderRadius: BorderRadius.circular(3)
        ),

        child: Center(
          child: Text(
            day,
            style: TextStyle(
               color: isSelected
               ? const Color.fromARGB(255, 202, 200, 233)
               : const Color.fromARGB(255, 34, 34, 45)
            )
          ),
        ) 
      )
    );
  }
}

class ActivityBox extends StatelessWidget {
  const ActivityBox({
    super.key,
    required this.title,
    required this.period
  });

  final String title;
  final String period;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
          strokeAlign: BorderSide.strokeAlignCenter
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17
            ),
          ),
          Text(
            period,
            style: TextStyle(
              fontSize: 15
            ),
          )          
        ],
      ),
    );
  }
}



class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedDayIndex = 0;
  final List<String> _days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  // TEMP ////////////////////
  final List<String> dayActivities = [
    'Morning run in the park',
    'Checking emails and reviewing priority tasks',
    'Team standup and status update',
    'Focused software development session',
    'Deep-dive code review',
    'Client strategy call',
    'Quick mid-day walk and lunch',
    'Architecture planning session',
    'Debugging and testing bug fixes',
    'Updating documentation and task tracking',
    'Technical discussion with team lead',
    'Daily Wrap-up and planning for tomorrow',
    'Dinner and winding down',
    'Reading or personal learning'
  ];
  ////////////////////////////
  
    // TEMP ////////////////////
  final List<String> dayPeriod = [
    '08:00 AM - 08:30 AM',
    '08:30 AM - 09:00 AM',
    '09:00 AM - 09:30 AM',
    '09:30 AM - 10:30 AM',
    '10:30 AM - 11:30 AM',
    '11:30 AM - 12:30 PM',
    '12:30 PM - 01:30 PM',
    '01:30 PM - 02:30 PM',
    '02:30 PM - 03:30 PM',
    '03:30 PM - 04:15 PM',
    '04:15 PM - 05:00 PM',
    '05:00 PM - 05:30 PM',
    '06:30 PM - 07:30 PM',
    '08:00 PM - 09:00 PM'
  ];
  ////////////////////////////
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for(int i=0; i<_days.length; i++)
                DayBox(
                  day: _days[i],
                  isSelected: i == _selectedDayIndex,
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = i;
                    });
                  },
               )
            ],
          )
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              for(int i=0; i<dayActivities.length; i++)
                ActivityBox(title: dayActivities[i], period: dayPeriod[i],)
            ],
          )
        ),       
      ]
    );
  }
}