import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> addToCart(Map<String, dynamic> product, {int qtySold = 1, int qtyFree = 0}) {
  return {
    'productId': product['id'],
    'productName': product['name'],
    'qtySold': qtySold,
    'qtyFree': qtyFree,
    'priceAtSale': product['unitPrice'] ?? 0.0,
  };
}

void main() {
  test('priceAtSale snapshots the price at add time and does not change when product price is mutated', () {
    final product = {
      'id': 'prod-1',
      'name': 'Test Product',
      'unitPrice': 15.99,
    };

    final cartItem = addToCart(product, qtySold: 2);
    expect(cartItem['priceAtSale'], 15.99);

    product['unitPrice'] = 12.50;

    expect(cartItem['priceAtSale'], 15.99,
        reason: 'Cart item price must remain at the snapshot value even after product price changes');
    expect(product['unitPrice'], 12.50, reason: 'Product price should have changed');
  });

  test('multiple cart items each retain their own priceAtSale snapshot', () {
    final products = [
      {'id': 'p1', 'name': 'Alpha', 'unitPrice': 10.00},
      {'id': 'p2', 'name': 'Beta', 'unitPrice': 20.00},
    ];

    final cart = [
      addToCart(products[0], qtySold: 1),
      addToCart(products[1], qtySold: 3),
    ];

    products[0]['unitPrice'] = 99.00;
    products[1]['unitPrice'] = 99.00;

    expect(cart[0]['priceAtSale'], 10.00);
    expect(cart[1]['priceAtSale'], 20.00);
  });

  test('priceAtSale defaults to 0.0 when unitPrice is null', () {
    final product = {'id': 'p2', 'name': 'No Price', 'unitPrice': null};
    final cartItem = addToCart(product);
    expect(cartItem['priceAtSale'], 0.0);
  });
}
