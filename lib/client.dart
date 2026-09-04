import 'dart:convert';
import 'package:be_human/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Client {
  final uri = Uri.parse('http://192.168.1.251:3000');

  Future<String?> postActivity(Activity activity) async{
    final response = await post(
      uri,
      headers: ({'Content-Type': 'application/json'}),
      body: jsonEncode({
        'activityDesc': activity.activityDesc,
        'startTime': {
          'hour': activity.startTime!.hour,
          'minute': activity.startTime!.minute
        },
        'endTime': {
          'hour': activity.endTime!.hour,
          'minute': activity.endTime!.minute          
        },
        'day': activity.day
      })
    );

    if(response.statusCode == 201) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body); 
          return jsonResponse['dataID'];
    }
    return null;
  }

  Future<Activity?> getActivity(String id) async {
    final response = await get(
      uri.replace(queryParameters: {'id': id})
    );

    if(response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      Activity activity = Activity(
        id: jsonResponse['_id'],
        activityDesc: jsonResponse['activityDesc'],
        startTime: TimeOfDay(hour: jsonResponse['startTime']['hour'], minute: jsonResponse['startTime']['minute']),
        endTime: TimeOfDay(hour: jsonResponse['endTime']['hour'], minute: jsonResponse['endTime']['minute']),
        day: jsonResponse['day']
      );

      return activity;
    }

    return null;
  }

  Future<List<Activity>> getAllActivities(int day) async {
    
    List<Activity> activities = []; 

    final response = await get(
      uri.replace(queryParameters: {'day': day.toString()})
    );

    if(response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      for(int i=0; i<jsonResponse.length; i++) {
        Activity activity = Activity(
          id: jsonResponse[i]['_id'],
          activityDesc: jsonResponse[i]['activityDesc'],
          startTime: TimeOfDay(hour: jsonResponse[i]['startTime']['hour'], minute: jsonResponse[i]['startTime']['minute']),
          endTime: TimeOfDay(hour: jsonResponse[i]['endTime']['hour'], minute: jsonResponse[i]['endTime']['minute']),
          day: jsonResponse[i]['day']
        );
        activities.add(activity);
      }
      return activities;
    }
    return activities;
  }

  Future<bool> updateActivity(String? id, Activity newActivity) async{
    final response = await put(
      uri.replace(queryParameters: {'id': id}),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'activityDesc': newActivity.activityDesc,
        'startTime': {
          'hour': newActivity.startTime!.hour,
          'minute': newActivity.startTime!.minute
        },
        'endTime': {
          'hour': newActivity.endTime!.hour,
          'minute': newActivity.endTime!.minute          
        },
        'day': newActivity.day
      })
    );

    if(response.statusCode == 204){
      return true;
    }
    return false;
  }

  Future<bool> deleteActivity(String? id) async{
    final response = await delete(
      uri.replace(queryParameters: {'id': id})
    );

    if(response.statusCode == 204){
      return true;
    }
    return false;
  }
}