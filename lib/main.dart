import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

// Login Page
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<void> login() async {
    final url = Uri.parse('https://parseapi.back4app.com/login');
    final response = await http.post(
      url,
      headers: {
        'X-Parse-Application-Id': 'YL9qiDB7OkX794ngVD5dGirnRjD5T1vJJW4qFsAL',
        'X-Parse-REST-API-Key': '1sQ8argYYAklrnHOYT7YjGUfa1J2tUzGnqRQXFJS',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username": _usernameController.text,
        "password": _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: "sessionToken", value: data['sessionToken']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Task Manager")),
      body: Center(
        child: Container(
          width: 350, // Set a fixed width for better UI
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Signup Page
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signUp() async {
    final url = Uri.parse('https://parseapi.back4app.com/users');
    final response = await http.post(
      url,
      headers: {
        'X-Parse-Application-Id': 'YL9qiDB7OkX794ngVD5dGirnRjD5T1vJJW4qFsAL',
        'X-Parse-REST-API-Key': '1sQ8argYYAklrnHOYT7YjGUfa1J2tUzGnqRQXFJS',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username": _usernameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Successful! Please login.")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Failed!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Center(
        child: Container(
          width: 350, // Reduce the width of the form
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Page with Full-Width Table
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
  List tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final url = Uri.parse('https://parseapi.back4app.com/classes/tasks');
    final token = await storage.read(key: "sessionToken");
    final response = await http.get(
      url,
      headers: {
        'X-Parse-Application-Id': 'YL9qiDB7OkX794ngVD5dGirnRjD5T1vJJW4qFsAL',
        'X-Parse-REST-API-Key': '1sQ8argYYAklrnHOYT7YjGUfa1J2tUzGnqRQXFJS',
        'X-Parse-Session-Token': token ?? "",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        tasks = data['results'];
      });
    }
  }

  Future<void> deleteTask(String objectId) async {
    final url = Uri.parse('https://parseapi.back4app.com/classes/tasks/$objectId');
    final token = await storage.read(key: "sessionToken");

    final response = await http.delete(
      url,
      headers: {
        'X-Parse-Application-Id': 'YL9qiDB7OkX794ngVD5dGirnRjD5T1vJJW4qFsAL',
        'X-Parse-REST-API-Key': '1sQ8argYYAklrnHOYT7YjGUfa1J2tUzGnqRQXFJS',
        'X-Parse-Session-Token': token ?? "",
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("Task deleted successfully");
    } else {
      print("Failed to delete task");
    }
  }


  Future<void> logout() async {
    await storage.delete(key: "sessionToken");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity, // Full-width table
                        child: DataTable(
                        columnSpacing: 30.0,
                        border: TableBorder.all(width: 1, color: Colors.grey),
                        headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
                        columns: [
                          DataColumn(label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))), // Column for Edit & Delete Buttons
                        ],
                        rows: tasks.map((task) {
                          return DataRow(cells: [
                            DataCell(Text(task['title'], style: TextStyle(fontSize: 16))),
                            DataCell(Text(task['description'], style: TextStyle(fontSize: 16))),
                            DataCell(Text(task['status'], style: TextStyle(fontSize: 16, color: Colors.green))),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () async {
                                      bool? updated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditTaskPage(task: task),
                                        ),
                                      );

                                      if (updated == true) {
                                        fetchTasks(); // Refresh task list after editing
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Delete Task"),
                                            content: Text("Are you sure you want to delete this task?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(true),
                                                child: Text("Delete", style: TextStyle(color: Colors.red)),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (confirmDelete == true) {
                                        await deleteTask(task['objectId']); // Call delete function
                                        fetchTasks(); // Refresh task list after deletion
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),


                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Wait for CreateTaskPage to finish and then fetch tasks again
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTaskPage()),
          );
          fetchTasks(); // Refresh tasks when returning from CreateTaskPage
        },
        child: Icon(Icons.add),
        tooltip: "Create Task",
      ),
    );
  }
}



// Task Creation Page
class CreateTaskPage extends StatefulWidget {
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final storage = FlutterSecureStorage();

  // Available status options
  final List<String> _statusOptions = ["Pending", "In Progress", "Completed"];
  String? _selectedStatus;

  Future<void> createTask() async {
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a status")),
      );
      return;
    }

    final url = Uri.parse('https://parseapi.back4app.com/classes/tasks');
    final token = await storage.read(key: "sessionToken");

    final userResponse = await http.get(
      Uri.parse('https://parseapi.back4app.com/users/me'),
      headers: {
        'X-Parse-Application-Id': 'YL9qiDB7OkX794ngVD5dGirnRjD5T1vJJW4qFsAL',
        'X-Parse-REST-API-Key': '1sQ8argYYAklrnHOYT7YjGUfa1J2tUzGnqRQXFJS',
        'X-Parse-Session-Token': token ?? "",
      },
    );

    if (userResponse.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to get user details.")),
      );
      return;
    }

    final userData = jsonDecode(userResponse.body);
    final userId = userData['objectId'];

    final response = await http.post(
      url,
      headers: {
        'X-Parse-Application-Id': 'YL9qiDB7OkX794ngVD5dGirnRjD5T1vJJW4qFsAL',
        'X-Parse-REST-API-Key': '1sQ8argYYAklrnHOYT7YjGUfa1J2tUzGnqRQXFJS',
        'X-Parse-Session-Token': token ?? "",
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "title": _titleController.text,
        "description": _descriptionController.text,
        "status": _selectedStatus,
        "userId": {
          "__type": "Pointer",
          "className": "_User",
          "objectId": userId,
        }
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task added successfully!")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task creation failed!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Task")),
      body: Center(
        child: Container(
          width: 350, // Reduce form width for a better layout
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "New Task",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: "Select Status",
                  border: OutlineInputBorder(),
                ),
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createTask,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text("Add Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditTaskPage extends StatefulWidget {
  final Map task;

  EditTaskPage({required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedStatus;
  final storage = FlutterSecureStorage();
  final List<String> _statusOptions = ["Pending", "In Progress", "Completed"];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task['title'];
    _descriptionController.text = widget.task['description'];
    _selectedStatus = widget.task['status'];
  }

  Future<void> updateTask() async {
    final url = Uri.parse('https://parseapi.back4app.com/classes/tasks/${widget.task['objectId']}');
    final token = await storage.read(key: "sessionToken");

    final response = await http.put(
      url,
      headers: {
        'X-Parse-Application-Id': 'YL9qiDB7OkX794ngVD5dGirnRjD5T1vJJW4qFsAL',
        'X-Parse-REST-API-Key': '1sQ8argYYAklrnHOYT7YjGUfa1J2tUzGnqRQXFJS',
        'X-Parse-Session-Token': token ?? "",
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "title": _titleController.text,
        "description": _descriptionController.text,
        "status": _selectedStatus,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task updated successfully!")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update task!")),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Update Task")),
    body: Center(
      child: Container(
        width: 350, // Set fixed width for a better UI
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Update Task",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: "Select Status",
                border: OutlineInputBorder(),
              ),
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedStatus = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateTask,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("Update Task"),
            ),
          ],
        ),
      ),
    ),
  );
}

}


