import 'package:flutter/material.dart';

class NewActivityPage extends StatefulWidget {
  const NewActivityPage({super.key});

  @override
  State<NewActivityPage> createState() => _NewActivityPageState();
}

class _NewActivityPageState extends State<NewActivityPage>{

  final TextEditingController _activityController = TextEditingController();
  
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> pickTime() async {
    final start = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now()
    );

    if(start == null) return;

    final end = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now()
    );

    if(end == null) return;

    setState(() {
      _startTime = start;
      _endTime = end;
    });
  }

  void printA(){
    print(_activityController.text);
    _activityController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 125, 139, 174),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 89, 95, 156),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Add New Activity',
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
        onPressed: printA,
        backgroundColor: const Color.fromARGB(255, 174, 175, 220),
        foregroundColor: const Color.fromARGB(255, 34, 34, 45),
        child: Icon(Icons.done),
      ),
    );
  }
}