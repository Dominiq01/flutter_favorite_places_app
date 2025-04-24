import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app/models/place.dart';
import 'package:flutter_favorite_places_app/providers/places_provider.dart';
import 'package:flutter_favorite_places_app/widgets/image_input.dart';
import 'package:flutter_favorite_places_app/widgets/location_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  File? _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    final isValid = _formKey.currentState!.validate();

    if (isValid && _pickedImage != null) {
      _formKey.currentState!.save();
      Navigator.of(context).pop();
      ref
          .read(placesProvider.notifier)
          .addPlace(Place(name: _enteredName, image: _pickedImage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new place',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 2 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (newValue) => _enteredName = newValue!,
              ),
              ImageInput(onSelectImage: _selectImage),
              const SizedBox(height: 16),
              LocationInput(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
