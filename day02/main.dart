import 'dart:io';

List<int> Read() {
  final File file = File('input.txt');
  final String line = file.readAsStringSync();
  return line.split(',').map((String item) => int.parse(item)).toList();
}

int calculateIntCode(List<int> intCode) {
  int index = 0;
  while (index < intCode.length && intCode[index] != 99) {
    switch (intCode[index]) {
      case 1 : {
        intCode[intCode[index + 3]] = intCode[intCode[index + 1]] + intCode[intCode[index + 2]];
        break;
      }
      case 2 : {
        intCode[intCode[index + 3]] = intCode[intCode[index + 1]] * intCode[intCode[index + 2]];
        break;
      }
    }
    index += 4;
  }
  return intCode[0];
}

void PartOne(List<int> intCode) {
  calculateIntCode(intCode);
  print(intCode[0]);
}

void PartTwo(List<int> intCode) {
  const int SOLUTION = 19690720;

  for (int i = 0; i < 100; i ++) {
    for (int j = 0; j < 100; j ++) {
      List<int> potentialIntCode = [...intCode];
      potentialIntCode[1] = i;
      potentialIntCode[2] = j;
      if (calculateIntCode(potentialIntCode) == SOLUTION) {
        print(100 * i + j);
        return;
      }
    }
  }
}

void main() {
  final List<int> intCode = Read();
  PartOne([...intCode]);
  PartTwo([...intCode]);
}