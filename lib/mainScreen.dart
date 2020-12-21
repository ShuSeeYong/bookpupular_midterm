import 'dart:convert';

import 'package:bookpopular/book.dart';
import 'package:bookpopular/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MaterialApp(
      home: MainScreen(),
    ));

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List bookList;

  double screenHeight, screenWidth;
  String titlecenter = "No Information Found";

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  @override
  Widget build(BuildContext context) {
    // screenHeight = MediaQuery.of(context).size.height;
    // screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: 
        Text('Book List',
            style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent[200],
      ),
      body: Column(
        children: [
          bookList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(titlecenter,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )))))
              : Flexible(
                  child: GridView.count(
                    crossAxisCount: 2,
                    // childAspectRatio: (screenWidth/screenHeight) / 0.8,
                    children: List.generate(
                      bookList.length,
                      (index) {
                        return Padding(
                            padding: EdgeInsets.all(1),
                            child: Card(
                                child: InkWell(
                              onTap: () => _loadBookList(index),
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  Container(
                                      height: 170,
                                      width: 160,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "http://slumberjer.com/bookdepo/bookcover/${bookList[index]['cover']}.jpg",
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(
                                          Icons.broken_image,
                                          // size: screenWidth / 2,
                                        ),
                                      )),
                                  Positioned(
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.end,
                                      children: [
                                        Text(bookList[index]['rating'],
                                            style:
                                                TextStyle(color: Colors.black)),
                                        Icon(Icons.star, color: Colors.black),
                                      ],
                                    ),
                                    bottom: 50,
                                    right: 10,
                                  ),
                                  Text("Title: " + bookList[index]['booktitle'],
                                      style:TextStyle(
                                     fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                  Text("Author: " + bookList[index]['author'],
                                      textAlign: TextAlign.center),
                                  Text("RM: " + bookList[index]['price'],
                                      textAlign: TextAlign.center),
                                ],
                              )),
                            )));
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _loadBook() {
    print("Load Books Data");
    http.post("http://slumberjer.com/bookdepo/php/load_books.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        bookList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          bookList = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadBookList(int index) {
    print(bookList[index]['booktitle']);
    Book book = new Book(
      bookid: bookList[index]['bookid'],
      booktitle: bookList[index]['booktitle'],
      author: bookList[index]['author'],
      price: bookList[index]['price'],
      description: bookList[index]['description'],
      rating: bookList[index]['rating'],
      publisher: bookList[index]['publisher'],
      isbn: bookList[index]['isbn'],
      cover: bookList[index]['cover'],
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailScreen(bk: book)));
  }
}