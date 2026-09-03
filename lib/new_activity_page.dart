import 'package:be_human/client.dart';
import 'package:be_human/main.dart';
import 'package:flutter/material.dart';

enum ActivityMode {
  add,
  edit
}

class NewActivityPage extends StatefulWidget {

  final ActivityMode mode;

  const NewActivityPage({
    super.key,
    required this.selectedDayIndex,
    required this.mode,
    this.currentActivity,
    this.currentStartTime,
    this.currentEndTime
  });

  final int selectedDayIndex;
  final String? currentActivity;
  final TimeOfDay? currentStartTime;
  final TimeOfDay? currentEndTime;

  @override
  State<NewActivityPage> createState() => _NewActivityPageState();
}


class _NewActivityPageState extends State<NewActivityPage>{

  Client client = Client();

  TextEditingController _activityController = TextEditingController();
   
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Future<void> means that an operation is async and returns no data
  Future<void> pickTime() async {
    
    final start = await showTimePicker(
      context: context,
      initialTime: _startTime == null ? TimeOfDay(hour: 00, minute: 00) : _startTime!
    );

    if(start == null) return;

    final end = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 00, minute: 00)
    );

    if(end == null) return;

    setState(() {
      _startTime = start;
      _endTime = end;
    });
  }
  
  @override
  Widget build(BuildContext context) {

    if(widget.mode == ActivityMode.edit && _startTime == null && _endTime == null){
      _activityController = (TextEditingController(text: widget.currentActivity));
      _startTime = widget.currentStartTime;
      _endTime = widget.currentEndTime;
    }

    return Scaffold(

      backgroundColor: const Color.fromARGB(255, 125, 139, 174),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 89, 95, 156),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.mode == ActivityMode.add ? 'Add New Activity' : 'Edit Activity',
            style: TextStyle(
              color: const Color.fromARGB(255, 34, 34, 45)
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(      
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [

            Text(
              'Activty:',
              style: TextStyle(fontSize: 20),
            ),

            TextField(
              controller: _activityController,
              autofocus: true,
              maxLength: 100,
              cursorColor: const Color.fromARGB(255, 60, 64, 113),
              decoration: InputDecoration(
                hintText: widget.mode == ActivityMode.add ? 'E.g: Go for a walk...' : widget.currentActivity,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 34, 34, 45),
                  )
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),

            Text(
              'Period:',
              style: TextStyle(fontSize: 20),
            ),


            ElevatedButton(
              onPressed: pickTime,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                backgroundColor: const Color.fromARGB(255, 174, 175, 220),
                foregroundColor: const Color.fromARGB(255, 34, 34, 45),
              ),
              child: Text(
                _startTime == null || _endTime == null
                ? 'Pick Time'
                : '${_startTime!.format(context)} - ${_endTime!.format(context)}'
              )
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(_activityController.text.isEmpty || _startTime == null || _endTime == null){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Empty Field(s)', style: TextStyle(color: const Color.fromARGB(255, 109, 52, 48))),
                backgroundColor: const Color.fromARGB(255, 71, 71, 121),
                duration: Duration(milliseconds: 1500),
              )
            );
          }else{
            Activity activity = Activity(
              activityDesc: _activityController.text,
              startTime: _startTime,
              endTime: _endTime,
              day: widget.selectedDayIndex
            );

            String? id = await client.postActivity(activity);   

            activity = ActivityUtil.copyWith(activity, id);  

           // widget.mode == ActivityMode.add ? ActivityUtil.addToDayList(activity) : ActivityUtil.editActivity(activity);
            ActivityUtil.addToDayList(activity); // TODO: DELETE THIS LINE WHEN U FIX THE ABOVE LINE

            Navigator.pop(
              context, 
            );
          }
        },
        backgroundColor: const Color.fromARGB(255, 174, 175, 220),
        foregroundColor: const Color.fromARGB(255, 34, 34, 45),
        child: Icon(Icons.done),
      ),
    );
  }
}