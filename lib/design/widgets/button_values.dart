

class CalculatorBean {
  static const clr = "CE";
  static const del = "D";
  static const multiply = "x";
  static const divide = "/";
  static const add = "+";
  static const subtract = "-";
  static const calculate = "=";
  static const dot = ".";
  static const n0 = "0";
  static const n1 = "1";
  static const n2 = "2";
  static const n3 = "3";
  static const n4 = "4";
  static const n5 = "5";
  static const n6 = "6";
  static const n7 = "7";
  static const n8 = "8";
  static const n9 = "9";
  static const openParenthesis = "(";
  static const closeParenthesis = ")";
  static const sqrt = "√";
  static const exponentiation = "^";
  static const sin = "sin";
  static const cos = "cos";
  static const tan = "tan";
  static const ctg = "ctg";
  static const arcsin = "arcsin";
  static const arccos = "arccos";
  static const arctan = "arctan";
  static const pi = "π";
  static String  toggleAngleUnit = "Рад";
  static List<String> buttonValues = [
    sin,
    cos,
    tan,
    ctg,
    arcsin,
    arccos,
    arctan,
    clr,
    del,
    toggleAngleUnit,
    pi,
    sqrt,
    openParenthesis,
    closeParenthesis,
    exponentiation,
    divide,
    n7,
    n8,
    n9,
    multiply,
    n4,
    n5,
    n6,
    subtract,
    n1,
    n2,
    n3,
    add,
    n0,
    dot,
    calculate
  ];
  static void toggleAngleUnitValue() {
    toggleAngleUnit = (toggleAngleUnit == "Рад") ? "Рад" : "Град"; // Toggle the value between "Рад" and "Град"
  }
}
