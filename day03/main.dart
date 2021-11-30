import 'dart:io';
import 'dart:math';

class Pair {
  int x;
  int y;

  Pair(this.x, this.y);

  @override
  String toString() {
    return '(x: ' + this.x.toString() + ', y: ' + this.y.toString() + ')';
  }
}

class Segment {
  Pair start;
  Pair finish;
  int length;
  bool swaped;

  Segment(this.start, this.finish, this.length, {this.swaped = false});

  void swap() {
    Pair temp = this.start;
    this.start = this.finish;
    this.finish = temp;

    this.swaped = true;
  }

  @override
  String toString() {
    return 'start: ' + this.start.toString() + ' finish: ' + this.finish.toString() + '\n';
  }
}

List<Segment> CreateSegments(String wire) {
  List<Segment> wireSegments = [];

  Pair segmentStart = Pair(0, 0);
  Pair segmentFinish = Pair(0, 0);
  wire.split(',').forEach((String item) {
    int value = int.parse(item.substring(1));
    switch (item[0]) {
      case 'U':
        {
          segmentFinish = Pair(segmentStart.x, segmentStart.y + value);
          break;
        }
      case 'R':
        {
          segmentFinish = Pair(segmentStart.x + value, segmentStart.y);
          break;
        }
      case 'D':
        {
          segmentFinish = Pair(segmentStart.x, segmentStart.y - value);
          break;
        }
      case 'L':
        {
          segmentFinish = Pair(segmentStart.x - value, segmentStart.y);
          break;
        }
    }
    wireSegments.add(Segment(segmentStart, segmentFinish, value));
    segmentStart = segmentFinish;
  });

  return wireSegments;
}

void swap(int a, int b) {
  //a ^= b ^= a ^= b;
}

void OrganizeSegments(List<Segment> wire) {
  wire.forEach((Segment segment) {
    if (segment.start.x == segment.finish.x) {
      if (segment.finish.y < segment.start.y) {
        segment.swap();
      }
    } else {
      if (segment.finish.x < segment.start.x) {
        segment.swap();
      }
    }
  });
}

List<Pair> Intersection(Segment segment1, Segment segment2) {
  if (segment1.start.y == segment1.finish.y) {
    // segment1 horizontal
    if (segment2.start.y == segment2.finish.y) {
      // segment2 horizontal
      if (segment1.start.y == segment2.start.y) {
        Pair intersectionStart;
        Pair intersectionFinish;
        if (segment1.start.x >= segment2.start.x && segment1.start.x <= segment2.finish.x) {
          intersectionStart = segment1.start;
          intersectionFinish = segment2.finish;
        } else if (segment1.finish.x >= segment2.start.x && segment1.finish.x <= segment2.finish.x) {
          intersectionStart = segment2.start;
          intersectionFinish = segment1.finish;
        } else {
          return [];
        }
        List<Pair> intersections = [];
        for (int x = intersectionStart.x, y = intersectionStart.y; x <= intersectionFinish.x; x++) {
          intersections.add(Pair(x, y));
        }
        print('Overlaps: ' + intersections.length.toString());
        return intersections;
      } else {
        return [];
      }
    } else {
      // segment2 vertical
      if (segment2.start.x >= segment1.start.x && segment2.start.x <= segment1.finish.x) {
        if (segment1.start.y >= segment2.start.y && segment1.start.y <= segment2.finish.y) {
          return [Pair(segment2.start.x, segment1.start.y)];
        }
      } else {
        return [];
      }
    }
  } else {
    // segment1 vertical
    if (segment2.start.y == segment2.finish.y) {
      // segment2 horizontal
      if (segment1.start.x >= segment2.start.x && segment1.start.x <= segment2.finish.x) {
        if (segment2.start.y >= segment1.start.y && segment2.start.y <= segment1.finish.y) {
          return [Pair(segment1.start.x, segment2.start.y)];
        }
      }
    } else {
      // segment2 vertical
      if (segment1.start.x == segment2.start.x) {
        Pair intersectionStart;
        Pair intersectionFinish;
        if (segment1.start.y >= segment2.start.y && segment1.start.y <= segment2.finish.y) {
          intersectionStart = segment1.start;
          intersectionFinish = segment2.finish;
        } else if (segment1.finish.y >= segment2.start.y && segment1.finish.y <= segment2.finish.y) {
          intersectionStart = segment2.start;
          intersectionFinish = segment1.finish;
        } else {
          return [];
        }
        List<Pair> intersections = [];
        for (int x = intersectionStart.x, y = intersectionStart.y; y <= intersectionFinish.y; y++) {
          intersections.add(Pair(x, y));
        }
        print('Overlaps: ' + intersections.length.toString());
        return intersections;
      } else {
        return [];
      }
    }
  }
  return [];
}

int ManhattanDistance(Pair a, Pair b) {
  return (a.x - b.x).abs() + (a.y - b.y).abs();
}

void PartOne(List<Segment> wire1, List<Segment> wire2) {
  List<Pair> intersections = [];

  for (int i = 0; i < wire1.length; i++) {
    for (int j = 0; j < wire2.length; j++) {
      intersections.addAll(Intersection(wire1[i], wire2[j]));
    }
  }

  int minDistance = ManhattanDistance(intersections[0], intersections[1]);
  intersections.skip(2).forEach((Pair intersection) {
    minDistance = min(minDistance, ManhattanDistance(intersections[0], intersection));
  });

  print(minDistance);
}

void CalculateLength(List<Segment> wire) {
  for (int i = wire.length - 1; i > 0; i--) {
    wire[i].length = wire[i - 1].length;
  }
  wire[0].length = 0;
  for (int i = 2; i < wire.length; i++) {
    wire[i].length += wire[i - 1].length;
  }
}

void PartTwo(List<Segment> wire1, List<Segment> wire2) {
  CalculateLength(wire1);
  CalculateLength(wire2);

  int minSteps = 0x3f3f3f3f;
  for (int i = 0; i < wire1.length; i++) {
    for (int j = 0; j < wire2.length; j++) {
      Intersection(wire1[i], wire2[j]).forEach((Pair intersection) {
        if (intersection.x == 0 && intersection.y == 0) return;
        minSteps = min(
            minSteps,
            wire1[i].length +
                wire2[j].length +
                ManhattanDistance((wire1[i].swaped ? wire1[i].finish : wire1[i].start), intersection) +
                ManhattanDistance((wire2[j].swaped ? wire2[j].finish : wire2[j].start), intersection));
      });
    }
  }

  print(minSteps);
}

void main() {
  List<String> wires = File('input.txt').readAsLinesSync();
  List<Segment> wire1 = CreateSegments(wires[0]);
  OrganizeSegments(wire1);
  List<Segment> wire2 = CreateSegments(wires[1]);
  OrganizeSegments(wire2);

  PartOne(wire1, wire2);
  PartTwo(wire1, wire2);
}
