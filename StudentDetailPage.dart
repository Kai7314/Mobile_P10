

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Student.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;
  const StudentDetailPage({super.key, required this.student});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {

  late String _selectedProgramme;
  var programmes = [ "RSD", "RSW", "RDS", "RIT"];

  @override
  void initState() {
    super.initState();
    _selectedProgramme = widget.student.programme;
  }


  Future<void> updateStudent(Student student) async {
     //todo:: call web API to update student's programme
    Uri uri = Uri.parse("http://10.0.2.2:5151/api/home/update");

    try {
      final response = await http.put(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(student.toJson())
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("Successful update ${data['message']}");
      } else {
        log("fail to update");
      }
    }catch (e){
      log("Error : $e");
    }
  }

  void _saveChanges() {
    setState(() {
      widget.student.programme = _selectedProgramme;
      updateStudent(widget.student);
    });

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.student.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${widget.student.id}", style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 8),

            Text("Name: ${widget.student.name}", style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 8),

            Text("Gender: ${widget.student.gender}", style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select Programme",
                border: OutlineInputBorder(),
              ),
              value: _selectedProgramme,
              items: programmes.map((programme) {
                return DropdownMenuItem( value: programme,  child: Text(programme) );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  _selectedProgramme = value!;
                });
              },
            ),


            const SizedBox(height: 8),

            Text("Year: ${widget.student.year}", style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text("Save Changes"),
            )
          ],
        ),
      ),
    );
  }
}
