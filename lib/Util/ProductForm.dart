class ProductForm {
  String id;
  String name;
  int cprice;
  String picture;
  String vendorName;
  String artisanImage;
  String artisanName;
  String brand;
  String colors;
  String weight;
  double size;
  String quantity;
  int vprice;
  int wprice;
  int lprice;
  int mprice;
  int rprice;
  String description;
  String category;
  String featured;
  String sale;
  int discount;
  String season;
  String festival;
  String occasion;


  ProductForm(this.id, this.name, this.cprice, this.picture, this.vendorName,
      this.artisanImage, this.artisanName, this.brand, this.colors, this.weight,
      this.size, this.quantity, this.vprice, this.wprice, this.lprice, this.mprice,
      this.rprice, this.description, this.category, this.featured, this.sale,
      this.discount, this.festival, this.occasion, this.season);

  factory ProductForm.fromJson(dynamic json) {
    return ProductForm(
        "${json['id']}",
        "${json['name']}",
         json['cprice'],
        "${json['picture']}",
        "${json['vendorName']}",
        "${json['artisanImage']}",
        "${json['artisanName']}",
        "${json['brand']}",
        "${json['colors']}",
        "${json['weight']}",
        json['size'],
        "${json['quantity']}",
        json['vprice'],
        json['wprice'],
        json['lprice'],
        json['mprice'],
        json['rprice'],
        "${json['description']}",
        "${json['category']}",
        "${json['featured']}",
        "${json['sale']}",
        json['discount'],
      "${json['festival']}",
      "${json['occasion']}",
      "${json['season']}",

    );
  }

  // Method to make GET parameters.
  Map toJson() => {
    'id': id,
    'name': name,
    'cprice': cprice,
    'picture': picture,
     "vendorName":vendorName,
     "artisanImage":artisanImage,
     "artisanName":artisanName,
     "brand":brand,
     "colors":colors,
     "weight":weight,
     "size":size,
     "quantity":quantity,
     "vprice":vprice,
     "wprice":wprice,
     "lprice":lprice,
     "mprice":mprice,
     "rprice":rprice,
     "description":description,
     "category":category,
    'featured':featured,
    'sale':sale,
    'discount':discount,
    'season':season,
    'occasion':occasion,
    'festival':festival,
  };
}