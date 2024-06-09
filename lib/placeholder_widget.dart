import 'package:appino/fruitDetails.dart';
import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  const PlaceholderWidget(this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FruiteDetailsWidget(
                      Colors.brown, {'name': 'test', 'id': '1234'})),
            ),
            child: const Card(
                elevation: 0,
                color: Colors.black,
                child: Image(
                  image: NetworkImage(
                      'https://www.wallmonkeys.com/cdn/shop/products/130969374-LRG_8c2c9bb2-17ee-4239-8e7f-b1a3f5cd0cba_530x.jpg?v=1578675824'),
                )),
          ),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: Image(
                image: NetworkImage(
                    'https://www.wallmonkeys.com/cdn/shop/products/130969374-LRG_8c2c9bb2-17ee-4239-8e7f-b1a3f5cd0cba_530x.jpg?v=1578675824'),
              )),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: Image(
                image: NetworkImage(
                    'https://www.wallmonkeys.com/cdn/shop/products/130969374-LRG_8c2c9bb2-17ee-4239-8e7f-b1a3f5cd0cba_530x.jpg?v=1578675824'),
              )),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: const Image(
                image: NetworkImage(
                    'https://www.wallmonkeys.com/cdn/shop/products/130969374-LRG_8c2c9bb2-17ee-4239-8e7f-b1a3f5cd0cba_530x.jpg?v=1578675824'),
              )),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: Image(
                image: NetworkImage(
                    'https://www.wallmonkeys.com/cdn/shop/products/130969374-LRG_8c2c9bb2-17ee-4239-8e7f-b1a3f5cd0cba_530x.jpg?v=1578675824'),
              )),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: Image(
                image: const NetworkImage(
                    'https://www.wallmonkeys.com/cdn/shop/products/130969374-LRG_8c2c9bb2-17ee-4239-8e7f-b1a3f5cd0cba_530x.jpg?v=1578675824'),
              )),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: Image(
                image: NetworkImage(
                    'https://www.wallmonkeys.com/cdn/shop/products/130969374-LRG_8c2c9bb2-17ee-4239-8e7f-b1a3f5cd0cba_530x.jpg?v=1578675824'),
              ))
        ],
      ),
    );
  }
}
