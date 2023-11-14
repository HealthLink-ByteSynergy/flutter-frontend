import 'package:flutter/material.dart';
import 'package:healthlink/utils/colors.dart';

class MultiSelect extends StatefulWidget {
  final List items;
  final List selectedItems;
  const MultiSelect(
      {Key? key, required this.items, required this.selectedItems})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  //to manage checkbox
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        widget.selectedItems.add(itemValue);
      } else {
        widget.selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  ///this function returns the selected item to the user who called it
  void _submit() {
    Navigator.pop(context, widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text('Select Specializations', style: TextStyle(color: color4)),
      backgroundColor: collaborateAppBarBgColor,
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    title: Text(item, style: const TextStyle(color: color4)),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: widget.selectedItems.contains(item),
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                    activeColor: color4,
                    checkColor: collaborateAppBarBgColor,
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
