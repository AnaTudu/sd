import 'package:flutter/material.dart';

class DestinationChooseBox extends StatelessWidget {
  const DestinationChooseBox(this.hint, this.value, this.values, this.onChanged,
      {super.key});
  final String hint;
  final String? value;
  final List<String> values;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, right: 65, left: 65),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint, style: const TextStyle(fontFamily: 'Poppins')),
        isExpanded: true,
        icon: const Icon(Icons.arrow_downward, size: 15, color: Colors.grey),
        style: TextStyle(
          color: Color(
              int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
          fontFamily: 'Poppins',
        ),
        underline: Container(
          height: 1.5,
          color: const Color.fromARGB(255, 209, 209, 209),
        ),
        onChanged: onChanged,
        items: values.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
