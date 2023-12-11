import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário Pancreatite',
      home: PatientForm(),
    );
  }
}

class Patient {
  String name;
  int age;
  int leukocytes;
  double glucose;
  int ast;
  int ldh;
  bool hasGallstones;
  double score;
  String mortality;

  Patient({
    required this.name,
    required this.age,
    required this.leukocytes,
    required this.glucose,
    required this.ast,
    required this.ldh,
    required this.hasGallstones,
    required this.score,
    required this.mortality,
  });
}

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController leukocytesController = TextEditingController();
  TextEditingController glucoseController = TextEditingController();
  TextEditingController astController = TextEditingController();
  TextEditingController ldhController = TextEditingController();
  bool hasGallstones = false;
  bool showResults = false;
  double score = 0.0;
  String mortality = '';
  List<Patient> patients = [];

  double calculateMortality() {
    int score = 0;

    if (!hasGallstones) {
      int age = int.tryParse(ageController.text) ?? 0;
      int leukocytes = int.tryParse(leukocytesController.text) ?? 0;
      double glucose = double.tryParse(glucoseController.text) ?? 0.0;
      int ast = int.tryParse(astController.text) ?? 0;
      int ldh = int.tryParse(ldhController.text) ?? 0;

      if (age > 55) score++;
      if (leukocytes > 16000) score++;
      if (glucose > 11.0) score++;
      if (ast > 250) score++;
      if (ldh > 350) score++;
    } else {
      int age = int.tryParse(ageController.text) ?? 0;
      int leukocytes = int.tryParse(leukocytesController.text) ?? 0;
      double glucose = double.tryParse(glucoseController.text) ?? 0.0;
      int ast = int.tryParse(astController.text) ?? 0;
      int ldh = int.tryParse(ldhController.text) ?? 0;

      if (age > 70) score++;
      if (leukocytes > 18000) score++;
      if (glucose > 12.2) score++;
      if (ast > 250) score++;
      if (ldh > 400) score++;
    }

    return score.toDouble();
  }

  String getMortalityCategory(double score) {
    if (score >= 7) {
      return '100% de mortalidade';
    } else if (score >= 5) {
      return '40% de mortalidade';
    } else if (score >= 3) {
      return '15% de mortalidade';
    } else {
      return '2% de mortalidade';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Pancreatite'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do paciente.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(labelText: 'Idade'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a idade do paciente.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: leukocytesController,
                    decoration: InputDecoration(labelText: 'Leucócitos'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o número de leucócitos.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: glucoseController,
                    decoration: InputDecoration(labelText: 'Valor da Glicemia'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o valor da glicemia.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: astController,
                    decoration: InputDecoration(labelText: 'Valor da AST/TGO'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o valor da AST/TGO.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ldhController,
                    decoration: InputDecoration(labelText: 'Valor da LDH'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o valor da LDH.';
                      }
                      return null;
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Pancreatite com Litíase Biliar'),
                    value: hasGallstones,
                    onChanged: (value) {
                      setState(() {
                        hasGallstones = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        score = calculateMortality();
                        mortality = getMortalityCategory(score);

                        Patient newPatient = Patient(
                          name: nameController.text,
                          age: int.tryParse(ageController.text) ?? 0,
                          leukocytes: int.tryParse(leukocytesController.text) ?? 0,
                          glucose: double.tryParse(glucoseController.text) ?? 0.0,
                          ast: int.tryParse(astController.text) ?? 0,
                          ldh: int.tryParse(ldhController.text) ?? 0,
                          hasGallstones: hasGallstones,
                          score: score,
                          mortality: mortality,
                        );

                        setState(() {
                          patients.add(newPatient);
                          showResults = true;
                        });
                      }
                    },
                    child: Text('Adicionar Paciente'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            if (showResults)
              Expanded(
                child: ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text('Paciente: ${patients[index].name}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pontuação: ${patients[index].score}'),
                            Text('Mortalidade: ${patients[index].mortality}'),
                          ],
                        ),
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
