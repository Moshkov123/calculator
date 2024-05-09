import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../design/widgets/button_values.dart';
import 'calculator_logic.dart'; // Import the logic file

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String text = ""; // variable to store the characters

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    text, // display the characters
                    style: const TextStyle(
                        fontSize: 34, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
// кнопки
            Wrap(
              children: CalculatorBean.buttonValues
                  .map((value) => SizedBox(
                        width: value == "0"
                            ? screenSize.width / 2
                            : screenSize.width / 4,
                        height: screenSize.width / 5,
                        child: buildButton(value),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: getBtnColor(value),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              if (value == CalculatorBean.toggleAngleUnit) {
                isRadians = !isRadians;
                CalculatorBean.toggleAngleUnitValue();
              } else {
                handleButtonAction(value, text, (String newText) {
                  text = newText;
                });
              }
            });
          },
          child: Center(
            child: Text(
              value == CalculatorBean.toggleAngleUnit ? (isRadians ? "Рад" : "Град") : value,
            ),
          ),
        ),
      ),
    );
  }

  Color getBtnColor(value) {
    if (value == "Рад" || value == "Град") {
      return isRadians ? Colors.red : Colors.blue;
    }
    return [CalculatorBean.del, CalculatorBean.clr].contains(value)
        ? const Color(0xffFFB69F)
        : [
            CalculatorBean.add,
            CalculatorBean.multiply,
            CalculatorBean.subtract,
            CalculatorBean.divide,
            CalculatorBean.calculate,
          ].contains(value)
            ? const Color(0xffFF9F46)
            : const Color(0xffffffff);
  }
}
