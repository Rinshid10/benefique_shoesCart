import 'dart:io';

import 'package:benefique/controller/prodectModals/prodectModel.dart';

import 'package:benefique/view/editPage.dart';
import 'package:benefique/view/widgets/widgetAndColors.dart';
import 'package:flutter/material.dart';

class EditMain extends StatefulWidget {
  const EditMain({super.key});

  @override
  State<EditMain> createState() => _EditMainState();
}

class _EditMainState extends State<EditMain> {
  @override
  void initState() {
    super.initState();
    getAllProdect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBlueColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Edit Products',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: prodectList,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final editData = value[index];
              return Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 100,
                  child: Card(
                    child: Center(
                      child: ListTile(
                        onTap: () {
                        
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => EditPage(
                                images: File(editData.images ?? ''),
                                country: editData.country,
                                currentPrice: editData.currentPrice,
                                discount: editData.discound,
                                index: index,
                                nameOfItem: editData.itemname,
                                yourPrice: editData.yourPrice,
                              ),
                            ),
                          );
                        },
                        leading: SizedBox(
                          height: double.infinity,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: editData.images != null &&
                                    File(editData.images!).existsSync()
                                ? Image.file(
                                    File(editData.images!),
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.image_not_supported),
                          ),
                        ),
                        title: Text(editData.itemname.toString()),
                        subtitle: Text(
                            'Your Price: ${editData.yourPrice.toString()}'),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
