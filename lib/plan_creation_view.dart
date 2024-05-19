import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_admin/models/plan.dart';
import 'package:fitness_admin/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PlanCreationView extends StatefulWidget {
  const PlanCreationView({super.key});

  @override
  State<PlanCreationView> createState() => _PlanCreationViewState();
}

class _PlanCreationViewState extends State<PlanCreationView> {
  TextEditingController headingContoller = TextEditingController();
  TextEditingController descriptionContoller = TextEditingController();
  TextEditingController imageUrlContoller = TextEditingController();
  PlanCategory _selectedCategory = PlanCategory.normal;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Plan'),
      ),
      body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Create your new plan here'),
                CustomTextFormField(
                  controller: headingContoller,
                  labelText: 'Heading',
                  validator: (s) {
                    if (s == null || s.isEmpty) {
                      return "Please enter a valid Heading";
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  controller: descriptionContoller,
                  labelText: 'Description',
                  validator: (s) => s == null || s.isEmpty
                      ? "Please enter a valid Heading"
                      : null,
                ),
                CustomTextFormField(
                  controller: imageUrlContoller,
                  labelText: 'Image Url eg. https://example.com/image.png',
                  validator: (s) => s == null || s.isEmpty
                      ? "Please enter a valid Public Image Url"
                      : null,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Select Plan: '),
                    DropdownButton<PlanCategory>(
                      value: _selectedCategory,
                      onChanged: (PlanCategory? value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      items: PlanCategory.values.map((PlanCategory category) {
                        return DropdownMenuItem<PlanCategory>(
                          value: category,
                          child: Text(category.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        // Check of image too,
                        PlanModel planModel = PlanModel(
                          imageUrl: imageUrlContoller.text,
                          heading: headingContoller.text,
                          description: descriptionContoller.text,
                          category: _selectedCategory,
                        );

                        FirebaseFirestore.instance
                            .collection('plans')
                            .withConverter<PlanModel>(
                              fromFirestore: (snapshot, options) =>
                                  PlanModel.fromFirestore(snapshot),
                              toFirestore: (value, options) {
                                return value.toFirestore();
                              },
                            )
                            .add(planModel)
                            .then((value) => Navigator.pop(context));
                      }
                    },
                    child: const Text('Save'))
              ],
            ),
          )),
    );
  }
}
