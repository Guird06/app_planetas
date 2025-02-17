import 'package:app_planetas/controllers/planet_controller.dart';
import 'package:app_planetas/models/planet.dart';
import 'package:app_planetas/views/planet_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App Planetas'),
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
  List<Planet> _planets = [];

  @override
  void initState() {
    super.initState();
    _readPlanets();
  }

  Future<void> _readPlanets() async {
    final planetController = PlanetController();
    final results = await planetController.readPlanets();
    setState(() {
      _planets = results;
    });
  }

  void _addPlanet(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlanetScreen(
                  isAdding: true,
                  planet: Planet.empty(),
                  onFinished: () {
                    _readPlanets();
                  },
                )));
  }

  void _editPlanet(context, Planet planet) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlanetScreen(
                  isAdding: false,
                  planet: planet,
                  onFinished: () {
                    _readPlanets();
                  },
                )));
  }

  void _deletePlanet(int id) async {
    final planetController = PlanetController();
    await planetController.deletePlanet(id);
    _readPlanets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: _planets.length,
          itemBuilder: (context, index) {
            final planet = _planets[index];
            return ListTile(
                title: Text(planet.name),
                subtitle: Text(planet.nickname!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editPlanet(context,planet),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deletePlanet(planet.id!),
                    ),
                  ],
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPlanet(context),
        tooltip: 'Adicionar Planeta',
        child: const Icon(Icons.add),
      ),
    );
  }
}
