import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expenses_tracker/data/models/transaction.dart';

void main() {
  group('Transaction Tests', () {
    test('Transaction creation', () {
      final transaction = Transaction('1', 'Test', 100.0, DateTime.now());

      expect(transaction.txnId, '1');
      expect(transaction.txnTitle, 'Test');
      expect(transaction.txnAmount, 100.0);
      expect(transaction.txnDateTime, isA<DateTime>());
    });

    test('Transaction from map', () {
      final map = {
        'id': '1',
        'title': 'Test',
        'amount': 100.0,
        'date': DateTime.now().toIso8601String(),
      };
      final transaction = Transaction.fromMap(map);

      expect(transaction.txnId, '1');
      expect(transaction.txnTitle, 'Test');
      expect(transaction.txnAmount, 100.0);
      expect(transaction.txnDateTime, isA<DateTime>());
    });

    test('Transaction to map', () {
      final transaction = Transaction('1', 'Test', 100.0, DateTime.now());
      final map = transaction.toMap();

      expect(map['id'], 1);
      expect(map['title'], 'Test');
      expect(map['amount'], 100.0);
      expect(map['date'], isA<String>());
    });
  });
}
