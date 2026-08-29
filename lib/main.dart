import 'package:be_human/new_activity_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home:  MainApp()
    )
  );
}


class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}


class _MainAppState extends State<MainApp> {
  int _selectedDayIndex = 0;

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
        
        body: ActivityPage(
          selectedDayIndex: _selectedDayIndex,
          onDayChanged: (index) {
            setState(() {
              _selectedDayIndex = index;
            });
          }
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewActivityPage(
                  selectedDayIndex: _selectedDayIndex,
                )
              )
            );
            setState(() {});
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


class Activity{
  Activity({
    required this.activityDesc,
    required this.startTime,
    required this.endTime,
    required this.day
  });

  final String activityDesc;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final int day;
}


class ActivityUtil{
  
  static final List<List<Activity>> activityList = [
    [],[],[],[],[],[],[]
  ];

  static void addToDayList(Activity activity){
    activityList[activity.day].add(activity);
  }
}


class ActivityPage extends StatefulWidget{
  ActivityPage({
    super.key,
    required this.selectedDayIndex,
    required this.onDayChanged,
  });

  final int selectedDayIndex;
  final ValueChanged<int> onDayChanged;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>{


  final List<String> _days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

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
                  isSelected: i == widget.selectedDayIndex,
                  onTap: () {
                    widget.onDayChanged(i);
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
              for(int i=0; i<ActivityUtil.activityList[widget.selectedDayIndex].length; i++)
                ActivityBox(
                  title: ActivityUtil.activityList[widget.selectedDayIndex][i].activityDesc,
                  period: '${ActivityUtil.activityList[widget.selectedDayIndex][i].startTime!.format(context).toString()} - ${ActivityUtil.activityList[widget.selectedDayIndex][i].endTime!.format(context).toString()}',
                ),
            ],
          )
        ),
      ]
    );
  }
}