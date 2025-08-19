import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Student.dart';
import 'StudentDetailPage.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> students = [];
  bool isLoading = true;
  String searchQuery = "";
  String selectedProgramme = "All";
  var programmes = ["All", "RSD", "RSW", "RDS", "RIT"];


  @override
  void initState() {
    super.initState();
    //todo:: fetch all students data
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    //todo:: fetch record from web API

    late Uri uri;
    if(selectedProgramme == "All") {
      uri = Uri.parse("http://10.0.2.2:5151/api/Home/GetAll");
    }else {
      uri = Uri.parse(
          "http://10.0.2.2:5151/api/Home/GetByProgrammeCode/$selectedProgramme");
    }
    var response = await http.get(uri);
try {
  if (response.statusCode == 200) {
    var data = json.decode(response.body) as List;

    setState(() {
      students = data.map((e) => Student.fromJson(e)).toList();
      isLoading = false;
    });
  } else {
    throw Exception("Fail to load data");
  }
}catch(e){
  setState(() {
    isLoading = true;
  });

  log("Error: $e");
}
  }


  void _navigateToDetails(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailPage(student: student),
      ),
    ).then((value){
      if(value == true){
        fetchStudents();
        setState(() {

        });
      }
    });

    //todo:: update UI

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter Students")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(

        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select Programme",
                border: OutlineInputBorder(),
              ),
              value: selectedProgramme,
              items: programmes.map((programme) {
                  return DropdownMenuItem( value: programme,  child: Text(programme) );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedProgramme = value!;
                  fetchStudents();
                });
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    margin: const EdgeInsets.symmetric( horizontal: 8, vertical: 4),
                    child: ListTile(
                        //todo:: display student detail

                      leading: Image.asset(student.gender == "M" ? "assets/male.png" : "assets/female.png"),
                        title: Text(student.name),
                        subtitle: Text(student.programme),
                      trailing: Text("Year ${student.year}"),
                      onTap: ()=> _navigateToDetails(student),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}