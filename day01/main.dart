import 'dart:io';

void PartOne() {
  print(File('input.txt')
      .readAsLinesSync()
      .map((String mass) => int.parse(mass) ~/ 3 - 2)
      .reduce((sum, fuel) => sum + fuel));
}

int calculateMass(int mass) {
  if (mass >= 0) {
    return mass + calculateMass(mass ~/ 3 - 2);
  }
  return 0;
}

void PartTwo() {
  print(File('input.txt')
      .readAsLinesSync()
      .map((String mass) => calculateMass(int.parse(mass) ~/ 3 - 2))
      .reduce((sum, fuel) => sum + fuel));
}

void main() {
  PartOne();
  PartTwo();
}
