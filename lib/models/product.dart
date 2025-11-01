import 'package:hive/hive.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final String thumbnail;
  final List<String> images;
  final String category;
  final num rating;
  final String brand;
  final int stock;
  final num discountPercentage;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.images,
    required this.category,
    required this.rating,
    required this.brand,
    required this.stock,
    required this.discountPercentage,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'],
        title: j['title'] ?? '',
        description: j['description'] ?? '',
        price: j['price'] ?? 0,
        thumbnail: j['thumbnail'] ?? '',
        images: (j['images'] as List?)?.map((e) => '$e').toList() ?? const [],
        category: j['category'] ?? '',
        rating: j['rating'] ?? 0,
        brand: j['brand'] ?? '',
        stock: j['stock'] ?? 0,
        discountPercentage: j['discountPercentage'] ?? 0,
      );
}


class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 33;

  @override
  Product read(BinaryReader r) {
    final n = r.readByte();
    final f = <int, dynamic>{};
    for (var i = 0; i < n; i++) {
      f[r.readByte()] = r.read();
    }
    return Product(
      id: f[0],
      title: f[1],
      description: f[2],
      price: f[3],
      thumbnail: f[4],
      images: (f[5] as List?)?.cast<String>() ?? [],
      category: f[6],
      rating: f[7],
      brand: f[8],
      stock: f[9],
      discountPercentage: f[10],
    );
  }

  @override
  void write(BinaryWriter w, Product o) {
    w
      ..writeByte(11)
      ..writeByte(0)..write(o.id)
      ..writeByte(1)..write(o.title)
      ..writeByte(2)..write(o.description)
      ..writeByte(3)..write(o.price)
      ..writeByte(4)..write(o.thumbnail)
      ..writeByte(5)..write(o.images ?? [])
      ..writeByte(6)..write(o.category)
      ..writeByte(7)..write(o.rating)
      ..writeByte(8)..write(o.brand)
      ..writeByte(9)..write(o.stock)
      ..writeByte(10)..write(o.discountPercentage);
  }
}
