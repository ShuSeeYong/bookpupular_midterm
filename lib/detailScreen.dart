import 'dart:convert';

import 'package:bookpopular/book.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;


class DetailScreen extends StatefulWidget {
  final Book bk;

  const DetailScreen({Key key, this.bk}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List bookDetails;

  double screenHeight, screenWidth;
  String titlecenter = "No Details Found";

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.bk.booktitle,
          style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent[200],
        ),
        body: Container(
          color: Colors.yellow,
            child: SingleChildScrollView(
              child: Column(
                children: [
                   SizedBox(height:30),
                  Container(
                      height: 300,
                      width: 250,
                      child: CachedNetworkImage(
                        imageUrl:
                            "http://slumberjer.com/bookdepo/bookcover/${widget.bk.cover}.jpg",
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(
                          Icons.broken_image,
                          //size: screenWidth / 2,
                        ),
                      )),
                      
                  SizedBox(height:10),
                  Container(
                    color:Colors.yellow,
                    child:Padding(
                      padding: EdgeInsets.fromLTRB(15,15,15,15),
                    child: Column(
                      children:[
                  Text(
                    "Book ID: " + widget.bk.bookid,
                    style: TextStyle(fontSize: 18)),
                  Text(
                    "Title: " + widget.bk.booktitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height:7),
                  Text("Author: " + widget.bk.author,
                      style: TextStyle(fontSize: 18),
                      ),
                  SizedBox(height:7),
                  Text("RM" + widget.bk.price, 
                       style: TextStyle(fontSize: 18),),
                  SizedBox(height:7),
                  Text("Description: " + widget.bk.description,
                       style: TextStyle(fontSize: 18),),
                  SizedBox(height:7),
                  Text( "Rating: " + widget.bk.rating,
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height:7),
                  Text("Publisher: " + widget.bk.publisher,
                      style: TextStyle(fontSize: 18),),
                  SizedBox(height:7),
                  Text("ISBN: " + widget.bk.isbn, 
                       style: TextStyle(fontSize: 18),),
                ],
              ),   
        ))
             
        ])),
     ));
  }

  void _loadDetails() {
    print("Load Books Details");
    http.post("http://slumberjer.com/bookdepo/php/load_books.php", body: {
      'bookid': widget.bk.bookid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        bookDetails = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          bookDetails = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}