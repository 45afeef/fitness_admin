import 'package:flutter/material.dart';

import '../models/plan.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown({super.key});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  PlanCategory _selectedCategory = PlanCategory.normal;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
