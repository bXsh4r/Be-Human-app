import 'package:be_human/client.dart';
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
  State<MainApp> createState() => _MainAppState();  // "=> _MainAppState" means "return _MainAppState"
}


class _MainAppState extends State<MainApp> {
  
  // _selectedDayIndex is here because we will eventually want to pass it to new_activity_page through the FAB in  MainApps's state
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
          onDayChanged: (index) { // an index from ActivityPage will be called back and assigned to _selectedDayIndex
            setState(() {         // the state (everything inside build) will be rebuilt to show the new change
              _selectedDayIndex = index;
            });
          }
        ),

        // FAB is here async because we need to wait for the navigator to pop and return the data for us to then set the state
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewActivityPage(
                  selectedDayIndex: _selectedDayIndex,
                  mode: ActivityMode.add,
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

// DayBox is responsible for the days list UI
class DayBox extends StatelessWidget {
  const DayBox({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final String day;
  final bool isSelected;
  final VoidCallback onTap; // callback without a value returned

  @override
  Widget build(BuildContext context) {
    
    // GestureDetector because each day box can be tapped
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

// ActivityBox is responsible for the activities list UI
class ActivityBox extends StatelessWidget {
  const ActivityBox({
    super.key,
    required this.activityDesc,
    required this.period
  });

  final String activityDesc;
  final String period;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
          strokeAlign: BorderSide.strokeAlignCenter
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activityDesc,
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
    this.id,
    required this.activityDesc,
    required this.startTime,
    required this.endTime,
    required this.day
  });

  final String? id;
  final String activityDesc;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final int day;
}


class ActivityUtil{
  
  // a 2d list for days and their activities
  static final List<Activity> activityList = [];

  static Activity copyWith(Activity activity, String? id){
    return Activity(
      id: id,
      activityDesc: activity.activityDesc,
      startTime: activity.startTime,
      endTime: activity.endTime,
      day: activity.day
    );
  }

  static void addToDayList(Activity activity){
    activityList.add(activity);
  }
  

  static void editActivity(Activity activity, String? id) async {    
    int oldActivityIndex = activityList.indexWhere((oldActivity) => oldActivity.id == id); 
    activityList[oldActivityIndex] = activity;
  }
}


class ActivityPage extends StatefulWidget{
  const ActivityPage({
    super.key,
    required this.selectedDayIndex,
    required this.onDayChanged,
  });

  final int selectedDayIndex;
  final ValueChanged<int> onDayChanged; // pass value from ActivityPage (child) to MainApp (parent)

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>{

  Client client = Client();

  final List<String> _days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  void addActivitiesToList(int day) async{
    List<Activity> newList = await client.getAllActivities(day);

    // despite MainApp already setting the state each time a user taps.
    // we still need to set state here because the app isn't gonna wait for await to finsish (only its function will wait).
    // thats why we set the state again after await finishes.
    setState((){
      ActivityUtil.activityList.clear();
      ActivityUtil.activityList.addAll(newList);
    });
  }

  @override
  void initState() {
    super.initState();
    addActivitiesToList(widget.selectedDayIndex);
  }

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
                    widget.onDayChanged(i);  // when a daybox is tapped pass i to parent
                    addActivitiesToList(i);
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
              
              for(int i=0; i<ActivityUtil.activityList.length; i++)
                
                // Dismissible for dragging left or right to delete or edit
                Dismissible(

                  // use the provided data to make a key
                  key: ValueKey(
                    ActivityUtil.activityList[i].id
                  ),

                  // async because we need to wait for the navigator to pop then set state
                  confirmDismiss: (direction) async{
                    if(direction == DismissDirection.startToEnd){
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewActivityPage(
                            selectedDayIndex: widget.selectedDayIndex,
                            mode: ActivityMode.edit,
                            id: ActivityUtil.activityList[i].id,
                            currentActivity: ActivityUtil.activityList[i].activityDesc,
                            currentStartTime: ActivityUtil.activityList[i].startTime,
                            currentEndTime: ActivityUtil.activityList[i].endTime,
                          )
                        )
                      );
                      setState(() {});
                      return false; // returning false because we dont want to dismiss the activity
                    }
                    
                    if(direction == DismissDirection.endToStart){
                      return true; // return true to dismiss the activity
                    }

                    return false;
                  },

                  // if dismissed remove the activity from the screen and from the activityList
                  onDismissed: (direction) async {
                      await client.deleteActivity(ActivityUtil.activityList[i].id);

                        setState(() {
                          ActivityUtil.activityList.removeAt(i);
                        });
                  },

                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.edit),
                  ),

                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete),
                  ),

                  child: ActivityBox(
                    activityDesc: ActivityUtil.activityList[i].activityDesc,
                    period: '${ActivityUtil.activityList[i].startTime!.format(context).toString()}'
                            ' - ${ActivityUtil.activityList[i].endTime!.format(context).toString()}',
                  ),
                )
            ],
          )
        ),
      ]
    );
  }
}