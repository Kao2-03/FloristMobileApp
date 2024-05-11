import 'package:flutter/material.dart';

class Bouquets {
  final String image;
  final String title;
  final double price;
  final int rating;

  Bouquets(this.image, this.title, this.price, this.rating);
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static List<Bouquets> main_bouquets_list = [
    Bouquets('assets/images/1.jpg', 'hoa 1', 50, 5),
    Bouquets('assets/images/2.jpg', 'hoa 2', 51, 4),
    Bouquets('assets/images/3.jpg', 'hoa 3', 49, 5),
  ];
  List<Bouquets> display_list = main_bouquets_list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bạn muốn tìm gì?",
              style: TextStyle(
                color: Colors.pink,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 239, 164, 189),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Nhập từ khóa",
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.pink,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75, // Kích thước hợp lí cho hình ảnh
                ),
                itemCount: display_list.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset(
                            display_list[index].image,
                            fit: BoxFit.cover, // Fit kích thước ảnh
                          ),
                        ),
                        ListTile(
                          title: Text(
                            display_list[index].title,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            children: List.generate(
                              display_list[index].rating,
                              (index) => Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                          trailing: Text(
                            '\$${display_list[index].price}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}