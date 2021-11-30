import 'dart:io';

void PartOne(List<int> range) {
  int count = 0;

  for (int i = range[0]; i <= range[1]; i ++) {
    int password = 0;
    int number = i ~/ 10;
    int lastDigit = i % 10;
    while (number > 0) {
      int currentDigit = number % 10;
      if (currentDigit > lastDigit) {
        password = 0;
        break;
      }
      if (lastDigit == currentDigit) {
        password = 1;
      }
      number ~/= 10;
      lastDigit = currentDigit;
    }
    count += password;
  }

  print(count);
}

void PartTwo(List<int> range) {
  int count = 0;

  for (int i = range[0]; i <= range[1]; i ++) {
    int number = i;
    List<int> F = List.filled(10, 0);
    int lastDigit = i % 10;
    while (number > 0) {
      if (number % 10 > lastDigit) {
        break;
      }
      else if (lastDigit == number % 10) {
        F[number % 10] += 1;
      }
      else {
        F[number % 10] = 1;
      }
      lastDigit = number % 10;
      number ~/= 10;
    }
    if (number == 0) {
      for (int j = 1; j < 10; j ++) {
        if (F[j] == 2) {
          count ++;
          break;
        }
      }
    }
  }

  print(count);
}

void main() {
  List<int> range = File('input.txt').readAsLinesSync().map((String item) => int.parse(item)).toList();
  PartOne(range);
  PartTwo(range);
}
