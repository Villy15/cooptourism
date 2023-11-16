import 'package:flutter/material.dart';

class SkillCheckbox extends StatefulWidget {
  final String skill;
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const SkillCheckbox({super.key, 
    required this.skill,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  SkillCheckboxState createState() => SkillCheckboxState();
}

class SkillCheckboxState extends State<SkillCheckbox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.skill),
      value: widget.isChecked,
      onChanged: (bool? value) {
        setState(() {
          widget.onChanged(value!);
        });
      },
    );
  }
}