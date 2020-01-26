import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_treeview/src/utilities.dart';

void main() {
  group('random generator', () {
    test('generates at least 300 unique strings', () {
      List<String> _keys = [];
      final int count = 300;
      for (int i = 0; i < count; i++) {
        _keys.add(Utilities.generateRandom());
      }
      expect(_keys.length, count);
      expect(_keys, _keys.toSet().toList());
    });
    test('generates at least 200 unique 10 character strings', () {
      List<String> _keys = [];
      final int count = 200;
      for (int i = 0; i < count; i++) {
        _keys.add(Utilities.generateRandom(10));
      }
      expect(_keys.first.length, 10);
      expect(_keys.length, count);
      expect(_keys, _keys.toSet().toList());
    });
  });
  group('icon', () {
    test('from value', () {
      final IconData icon = Utilities.getIcon('adb');
      expect(icon, Icons.adb);
      expect(icon.runtimeType, IconData);
    });
    test('from values', () {
      final IconData icon = Utilities.getIcon('CROP_16_9');
      expect(icon, Icons.crop_16_9);
      expect(icon.runtimeType, IconData);
    });
  });
  group('truthful', () {
    test('is true', () {
      expect(Utilities.truthful(true), true);
      expect(Utilities.truthful('true'), true);
      expect(Utilities.truthful(1), true);
      expect(Utilities.truthful('1'), true);
      expect(Utilities.truthful('yes'), true);
    });
    test('is false', () {
      expect(Utilities.truthful(false), false);
      expect(Utilities.truthful('false'), false);
      expect(Utilities.truthful(0), false);
      expect(Utilities.truthful('0'), false);
      expect(Utilities.truthful('no'), false);
      expect(Utilities.truthful('someothervalue'), false);
    });
  });
}
