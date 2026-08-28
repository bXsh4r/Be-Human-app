import 'package:flutter/material.dart';

class NewActivityPage extends StatelessWidget {
  NewActivityPage({super.key});

  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();

  void printA(){
    print(_activityController);
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
        padding: const EdgeInsets.only(left: 5, right: 50),
        child: Column(      
          spacing: 15, 
          
          children: [
            SizedBox(height: 10,),
            TextField(
              controller: _activityController,
              
            ),
            TextField(
              controller: _periodController,
              
            ),
            SizedBox(height: 300,),
            ElevatedButton(
              onPressed: printA,
              child: Text('Done')
            )
          ],
        ),
      ),
    );
  }
}