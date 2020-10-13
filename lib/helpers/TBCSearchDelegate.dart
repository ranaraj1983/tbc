import 'package:flutter/material.dart';
import 'package:tbc/models/product.dart';
import 'package:tbc/services/DataCollection.dart';


class TBCSearchDelegate extends SearchDelegate<ProductModel> {

  List<ProductModel> output = new List<ProductModel>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await DataCollection().getListOfProductItem();
          //print(output);
          close(context, null);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation,));
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  Widget _doSearch(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: DataCollection().getCategoryList(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return query.isEmpty ? Container() :
                Container(
                  child: FutureBuilder(
                    future: DataCollection().getSubCollectionWithSearchKey(
                        snapshot.data[index].documentID, query),
                    builder: (_, snp) {
                      if (snp.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snp.data.length,
                            itemBuilder: (_, ind) {
                              Map<String, dynamic> data = snapshot.data[ind].data();
                              print(data['category']);
                              return Text(data['category']);
                              /*return !snp.data[ind].data['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(query.toLowerCase())
                                  ? Container()
                                  : Container(
                                      child: WidgetFactory().getSearchListView(
                                          context, snapshot.data[index],
                                          snp.data[ind]),

                              );*/
                            }
                        );
                      }
                    },
                  ),
                );
              },

            );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print(query);
    return query.length > 3 ? _doSearch(context) : Text("Searching......");
  }


}