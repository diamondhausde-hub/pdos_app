import 'package:flutter_test/flutter_test.dart';

typedef CartItem = Map<String, dynamic>;

int _findExistingIndex(List<CartItem> cart, String productId) {
  return cart.indexWhere((i) => i['productId'] == productId);
}

CartItem _makeItem(String productId, String productName, {int qty = 1, double price = 10.0}) {
  return {
    'productId': productId,
    'productName': productName,
    'qtySold': qty,
    'qtyFree': 0,
    'priceAtSale': price,
  };
}

CartItem _makeStockItem(String productId, String productName, {int qty = 1}) {
  return {
    'productId': productId,
    'productName': productName,
    'observedQty': qty,
  };
}

void main() {
  group('Sales cart merge logic', () {
    test('adding a new product appends to cart', () {
      final cart = <CartItem>[];
      final item = _makeItem('p1', 'Product A');

      final idx = _findExistingIndex(cart, item['productId'] as String);
      if (idx == -1) {
        cart.add(item);
      }

      expect(cart.length, 1);
      expect(cart[0]['productId'], 'p1');
    });

    test('adding the same product twice merges (replaces) rather than duplicating', () {
      final cart = <CartItem>[];
      cart.add(_makeItem('p1', 'Product A', qty: 2));

      final newItem = _makeItem('p1', 'Product A', qty: 5);
      final idx = _findExistingIndex(cart, newItem['productId'] as String);

      if (idx != -1) {
        cart[idx] = newItem;
      } else {
        cart.add(newItem);
      }

      expect(cart.length, 1, reason: 'Cart must still contain exactly 1 item (no duplicate)');
      expect(cart[0]['qtySold'], 5, reason: 'Quantity must be updated to the new value');
      expect(cart[0]['productId'], 'p1');
    });

    test('adding a different product creates a second entry', () {
      final cart = <CartItem>[];
      cart.add(_makeItem('p1', 'Product A', qty: 2));

      final newItem = _makeItem('p2', 'Product B', qty: 1);
      final idx = _findExistingIndex(cart, newItem['productId'] as String);

      if (idx != -1) {
        cart[idx] = newItem;
      } else {
        cart.add(newItem);
      }

      expect(cart.length, 2);
      expect(cart[0]['productId'], 'p1');
      expect(cart[1]['productId'], 'p2');
    });

    test('merging preserves priceAtSale from the new entry', () {
      final cart = <CartItem>[];
      cart.add(_makeItem('p1', 'Product A', qty: 2, price: 15.0));

      final newItem = _makeItem('p1', 'Product A', qty: 3, price: 20.0);
      final idx = _findExistingIndex(cart, newItem['productId'] as String);

      if (idx != -1) {
        cart[idx] = newItem;
      }

      expect(cart[0]['priceAtSale'], 20.0, reason: 'Merged item must take the new price snapshot');
    });
  });

  group('Stock check merge logic', () {
    test('adding the same product for stock check merges rather than duplicating', () {
      final checks = <CartItem>[];
      checks.add(_makeStockItem('p1', 'Product A', qty: 10));

      final newCheck = _makeStockItem('p1', 'Product A', qty: 15);
      final idx = _findExistingIndex(checks, newCheck['productId'] as String);

      if (idx != -1) {
        checks[idx] = newCheck;
      } else {
        checks.add(newCheck);
      }

      expect(checks.length, 1, reason: 'Stock checks must not duplicate the same product');
      expect(checks[0]['observedQty'], 15);
    });
  });
}
