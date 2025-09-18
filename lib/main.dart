import 'package:flutter/material.dart';
import 'package:worker/Worker.dart'; // Importa la clase Worker

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Worker> Lista = []; 

  int _currentId = 1;  

  TextEditingController _txtCrlN = TextEditingController();
  TextEditingController _txtCrlS = TextEditingController();
  TextEditingController _txtCrlA = TextEditingController();

  void _addWorker() {
    final name = _txtCrlN.text.trim();
    final surname = _txtCrlS.text.trim();
    var age = _txtCrlA.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name cannot be empty")),
      );
      return;
    } else if (surname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Surname cannot be empty")),
      );
      return;
    } else if (age.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Age cannot be empty")),
      );
      return;
    }

    try {
      int parsedAge = int.parse(age);
      if (parsedAge < 18) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You must be 18 or older to register")),
        );
        return;
      }

      final worker = Worker(
        id: _currentId++, 
        name: name,
        surname: surname,
        age: parsedAge,
      );

      setState(() {
        Lista.add(worker);
        _txtCrlN.clear();
        _txtCrlS.clear();
        _txtCrlA.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid age input")),
      );
    }
  }

  void _removeLastWorker() {
    if (Lista.isNotEmpty) {
      setState(() {
        Lista.removeLast();
        _currentId--;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No workers to remove")),
      );
    }
  }

  Widget getWorkers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14),
        Text("Worker List:"),
        SizedBox(height: 10),
        ...Lista.map((worker) => Text("- ${worker.name} ${worker.surname}, Age: ${worker.age}, ID: ${worker.id}")).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getWorkers(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _txtCrlN,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Worker Name",
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _txtCrlS,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Worker Surname",
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _txtCrlA,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Worker Age",
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addWorker,
                  child: Text("Add Worker"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _removeLastWorker,
                  child: Text("Remove Last Worker"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
