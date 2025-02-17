import 'package:app_planetas/models/planet.dart';
import 'package:flutter/material.dart';
import 'package:app_planetas/controllers/planet_controller.dart';

class PlanetScreen extends StatefulWidget {
  final bool isAdding;
  final Planet planet;
  final Function() onFinished;
  const PlanetScreen(
      {super.key,
      required this.onFinished,
      required this.planet,
      required this.isAdding});

  @override
  State<PlanetScreen> createState() => _PlanetScreenState();
}

class _PlanetScreenState extends State<PlanetScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  final PlanetController _planetController = PlanetController();

  late Planet _planet;

  @override
  void initState() {
    _planet = widget.planet;
    _nameController.text = _planet.name;
    _sizeController.text = _planet.size.toString();
    _distanceController.text = _planet.distance.toString();
    _nicknameController.text = _planet.nickname ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    _distanceController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _addPlanet() async {
    await _planetController.addPlanet(_planet);
  }

  Future<void> _editPlanet() async {
    await _planetController.editPlanet(_planet);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.isAdding) {
        _addPlanet();
      } else {
        _editPlanet();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Planeta salvo com sucesso!'),
      ),
      );
      
      Navigator.of(context).pop();
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 3,
          centerTitle: true,
          title: const Text('Cadastrar Planetas'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(40),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(5)),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          labelStyle: TextStyle(fontSize: 25),
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o nome do planeta';
                          }
                          if (value.length < 3) {
                            return 'O nome do planeta deve ter no mínimo 3 caracteres';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _planet.name = value!;
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      TextFormField(
                          controller: _sizeController,
                          decoration: const InputDecoration(
                            labelText: 'Tamanho (em km)',
                            labelStyle: TextStyle(fontSize: 25),
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe o tamanho do planeta';
                            }
                            if (double.tryParse(value) == null) {
                              return 'O tamanho deve ser um valor numérico';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _planet.size = double.parse(value!);
                          }),
                      const Padding(padding: EdgeInsets.all(10)),
                      TextFormField(
                          controller: _distanceController,
                          decoration: const InputDecoration(
                            labelText: 'Distância (em km)',
                            labelStyle: TextStyle(fontSize: 25),
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe a distância do planeta';
                            }
                            if (double.tryParse(value) == null) {
                              return 'O distância deve ser um valor numérico';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _planet.distance = double.parse(value!);
                          }),
                      const Padding(padding: EdgeInsets.all(10)),
                      TextFormField(
                          controller: _nicknameController,
                          decoration: const InputDecoration(
                            labelText: 'Apelido',
                            labelStyle: TextStyle(fontSize: 25),
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          )),
                      const Padding(padding: EdgeInsets.all(10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                          onPressed: () {
                            _submitForm();
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 25),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text("Salvar")),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 25),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text("Cancelar")),
                      ],),
                      
                      
                    ],
                  ),
                ))));
  }
}
