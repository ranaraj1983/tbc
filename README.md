https://www.youtube.com/c/SantosEnoque/videos
https://github.com/Santos-Enoque/admin_side_flutter_ecommerce_app/tree/product_details
https://flutter.github.io/samples/#?platform=web

https://firebase.flutter.dev/docs/firestore/usage/


List.generate(
          categories.length,
              (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {
              changeScreen(context, ProductList(categories[index]["text"]));
              print(categories[index]["text"]);
            },
          ),
        ),