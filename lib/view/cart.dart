import 'dart:developer';
import 'dart:io';
import 'package:benefique/constants/image_constant.dart';
import 'package:benefique/constants/text_constant.dart';
import 'package:benefique/view/widgets/widgetAndColors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:benefique/controller/cartFunction/cartFunction.dart';
import 'package:benefique/modal/cartModal/cartModal.dart';
import 'package:benefique/modal/prodectModal/prodectModal.dart';

double getSubtotal(List<StoreCart> cartItems) {
  double subtotal = 0;
  for (var item in cartItems) {
    try {
      subtotal += double.parse(item.price ?? '0');
    } catch (e) {
      log("${item.itemsName}${item.price}");
    }
  }
  return subtotal;
}

const double deliveryCharge = 50;
const double tax = 30;

class CartPage extends StatefulWidget {
  final List<Prodectmodel> cartItemsOfEach;

  const CartPage({super.key, required this.cartItemsOfEach});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double subtotal = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    getAllCart();
    updateTotals();
  }

  void updateTotals() {
    setState(() {
      subtotal =
          double.parse(getSubtotal(cartlisterner.value).toStringAsFixed(2));
      total =
          double.parse((subtotal + deliveryCharge + tax).toStringAsFixed(2));
    });
  }

  void refreshCart() {
    updateTotals();
  }

  void deleteCart(int index) {
    cartlisterner.value.removeAt(index);
    cartlisterner.notifyListeners(); 
    refreshCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlueColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const Gap(20),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Iconsax.arrow_left,
                        color: Colors.white,
                        weight: 20,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Cart",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 15,
                    top: 10,
                    child: Icon(
                      Iconsax.heart5,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Gap(50),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(30),
                        ValueListenableBuilder<List<StoreCart>>(
                          valueListenable: cartlisterner,
                          builder: (context, cartStoredItems, child) {
                            log('$cartStoredItems');
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: cartStoredItems.length,
                              itemBuilder: (context, index) {
                                final item = cartStoredItems[index];
                                final imagePath = item.image;

                                if (imagePath == null) {
                                  log(' ${item.itemsName}');
                                }

                                return SizedBox(
                                  height: 100,
                                  child: Card(
                                    color: const Color(0xffFBFCF8),
                                    elevation: 5,
                                    child: Center(
                                      child: ListTile(
                                        leading: SizedBox(
                                          height: double.infinity,
                                          width: 60,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image(
                                              image: FileImage(File(item
                                                      .image ??
                                                 ImageConstant.defaultimage )),
                                            ),
                                          ),
                                        ),
                                        title: Text(item.itemsName.toString()),
                                        subtitle: Text(item.price.toString()),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            deleteCart(index);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const Gap(50),
                        cartlisterner.value.isNotEmpty
                            ? Column(
                                children: [
                                  priceOfCart(
                                    name: TextConstant.deliveryCharge,
                                    price: '$subtotal',
                                  ),
                                  const Gap(3),
                                  priceOfCart(
                                    name: TextConstant.deliveryCharge,
                                    price: '$deliveryCharge',
                                  ),
                                  const Gap(3),
                                  priceOfCart(
                                      name: TextConstant.tax, price: '$tax'),
                                  const Gap(3),
                                  const Divider(),
                                  priceOfCart(
                                    name: TextConstant.total,
                                    price: '$total',
                                  ),
                                ],
                              )
                            : Text(TextConstant.emty),
                        const Gap(35),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainBlueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(100, 50),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Check Out',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
