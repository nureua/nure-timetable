// NureTimetable is an app for viewing schedule for groups or teachers of Kharkiv National University of Radio Electronics.
// Copyright (C) 2023-2024  music-soul1-1

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.


import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nure_timetable/models/auditory.dart';
import 'dart:convert';
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/types/entity_type.dart';


class Timetable {
  Timetable();
  /// The domain of the API.
  static const domain = "https://nure-time.runasp.net/api/v2";

  /// Gets a list of groups.
  Future<List<Group>?> getGroups() async {
    try {
      const url = '$domain/Groups/GetAll';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<Group> groups = data.map((item) => Group.fromJson(item)).toList();
        return groups;
      }
      else {
        throw Exception('Failed to load groups: ${response.statusCode}');
      }
    }
    catch(error) {
      throw Exception('Error in <getGroups>: $error');
    }
  }

  /// Gets a group by id.
  Future<Group?> getGroupById(int id) async
  {
    try
    {
      final response = await http.get(Uri.parse('$domain/Groups/Get/$id'));

      if (response.statusCode != 200)
      {
        throw Exception('Failed to get group with id $id: ${response.statusCode}');
      }

      final dynamic data = json.decode(utf8.decode(response.bodyBytes));

      return Group.fromJson(data);
    }
    catch(error)
    {
      throw Exception('Error in <getGroup>: $error');
    }
  }

  /// Gets a group by name.
  Future<Group?> getGroup(String groupName) async {
    try {
      final response = await http.get(Uri.parse('$domain/Groups/GetByName?name=$groupName'));

      if (response.statusCode != 200)
      {
        throw Exception('Failed to get group with name $groupName: ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      
      List<Group> groups = data.map((item) => Group.fromJson(item)).toList();

      return groups.first;
    }
    catch(error) {
      throw Exception('Error in <getGroup>: $error');
    }
  }

  /// Searches for a group by name.
  List<Group> searchGroup(List<Group> groups, String groupName) {
    try {
      return groups.where((group) => group.name.toLowerCase().contains(groupName.toLowerCase())).toList();
    }
    catch(error) {
      throw Exception('Error in <searchGroup>: $error');
    }
  }

  /// Gets a list of teachers.
  Future<List<Teacher>>? getTeachers() async {
    try {
      const url = '$domain/Teachers/GetAll';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to load teachers: ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      List<Teacher> teachers = data.map((item) => Teacher.fromJson(item)).toList();

      return teachers;
    }
    catch(error) {
      throw Exception('Error in <getTeachers>: $error');
    }
  }

  Future<Teacher?> getTeacherById(int id) async
  {
    try
    {
      final response = await http.get(Uri.parse('$domain/Teachers/Get/$id'));

      if (response.statusCode != 200)
      {
        throw Exception('Failed to get teacher with id $id: ${response.statusCode}');
      }

      final dynamic data = json.decode(utf8.decode(response.bodyBytes));

      return Teacher.fromJson(data);
    }
    catch(error)
    {
      throw Exception('Error in <getTeacherById>: $error');
    }
  }

  /// Gets a teacher by name.
  Future<Teacher?> getTeacher(String shortName) async {
    try {
      final response = await http.get(Uri.parse('$domain/Teachers/GetByName?name=$shortName'));

      if (response.statusCode != 200) {
        throw Exception('Failed to get teacher with name $shortName: ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      List<Teacher> teachers = data.map((item) => Teacher.fromJson(item)).toList();

      return teachers.first;
    }
    catch(error) {
      throw Exception('Error in <getTeacher>: $error');
    }
  }

  Future<List<Auditory>>? getAuditories() async {
    try {
      final response = await http.get(Uri.parse('$domain/Auditories/GetAll'));

      if (response.statusCode != 200) {
        throw Exception('Failed to load auditories: ${response.statusCode}');
      }
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      List<Auditory> auditories = data.map((item) => Auditory.fromJson(item)).toList();

      return auditories;
    }
    catch(error) {
      throw Exception('Error in <getAuditories>: $error');
    }
  }

  Future<Auditory?> getAuditoryById(int id) async
  {
    try
    {
      final response = await http.get(Uri.parse('$domain/Auditories/Get/$id'));

      if (response.statusCode != 200)
      {
        throw Exception('Failed to get auditory with id $id: ${response.statusCode}');
      }

      final dynamic data = json.decode(utf8.decode(response.bodyBytes));

      return Auditory.fromJson(data);
    }
    catch(error)
    {
      throw Exception('Error in <getAuditoryById>: $error');
    }
  }

  Future<Auditory?> getAuditory(String name) async {
    try {
      final response = await http.get(Uri.parse('$domain/Auditories/GetByName?name=$name'));

      if (response.statusCode != 200) {
        throw Exception('Failed to get auditory with name $name: ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      List<Auditory> auditories = data.map((item) => Auditory.fromJson(item)).toList();

      return auditories.first;
    }
    catch(error) {
      throw Exception('Error in <getAuditory>: $error');
    }
  }

  /// Gets lessons for a group/teacher/auditory.
  Future<List<Lesson>>? getLessons(int id, [EntityType entityType= EntityType.group, int? startTime, int? endTime]) async {
    try {
      final url = '$domain/Lessons/GetById?id=$id&type=${entityType.index}&startTime=$startTime&endTime=$endTime';

      if (kDebugMode) {
        print(url);
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<Lesson> lessons = data.map((item) => Lesson.fromJson(item)).toList();

        return lessons;
      }
      else {
        throw Exception('Failed to load lessons. Status code: ${response.statusCode}. Response: ${response.body}');
      }
    }
    catch(error) {
      throw Exception('Error in <getLessons>: $error');
    }
  }

  Lesson? getNextLessonFromList(List<Lesson> lessons) {
    try {
      if (lessons.isNotEmpty) {
        return lessons.where((lesson) => lesson.startTime >= (DateTime.now().millisecondsSinceEpoch ~/ 1000)).first;
      }
      else {
        return null;
      }
    }
    catch(error) {
      throw Exception('Error in <getNextLessonFromList>: $error');
    }
  }
}
