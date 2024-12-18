
import 'package:benefique/modal/cartModal/cartModal.dart';
import 'package:benefique/modal/prodectModal/prodectModal.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

ValueNotifier<List<StoreCart>> cartlisterner =
    ValueNotifier<List<StoreCart>>([]);
Future<void> saveCartItem(Prodectmodel cartItem) async {
  var box = await Hive.openBox<StoreCart>('cartBox');
  final storeCartItem = StoreCart(
    itemsName: cartItem.itemname,
    price: cartItem.yourPrice.toString(),
    image: cartItem.images
  );
  await box.add(storeCartItem);
  cartlisterner.value.clear();
  cartlisterner.value.addAll(box.values);

  cartlisterner.notifyListeners();
}

Future<void> getAllCart() async {
  final box = await Hive.openBox<StoreCart>('cartBox');
  cartlisterner.value.clear();
  cartlisterner.value.addAll(box.values);
  
  cartlisterner.notifyListeners();
}

Future deleteCart(int index) async {
  final box = await Hive.openBox<StoreCart>('cartBox');
  box.deleteAt(index);
  getAllCart();
}
