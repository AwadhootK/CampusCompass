import 'package:flutter/material.dart';

class SubjectForm extends StatefulWidget {
  @override
  _SubjectFormState createState() => _SubjectFormState();
}

class _SubjectFormState extends State<SubjectForm> {
  final _formKey = GlobalKey<FormState>();
  int _numberOfSubjects = 0;
  Map<int, String> _subjects = {};

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Number of Subjects: $_numberOfSubjects');
      print('Subjects: $_subjects');
      // Do something with the data, like storing it in a database or sending it to an API
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Number of Subjects'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the number of subjects';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            onSaved: (value) {
              _numberOfSubjects = int.parse(value!);
            },
          ),
          SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _numberOfSubjects,
            itemBuilder: (context, index) {
              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Subject ${index + 1}',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a subject name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _subjects[index + 1] = value!;
                },
              );
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _saveForm,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
