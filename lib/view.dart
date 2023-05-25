import 'dart:async';
import 'dart:convert';
import 'dart:core';


import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:menu/CallApi.dart';
import 'package:menu/SplashScreen.dart';
import 'package:menu/instagram.dart';
import 'package:menu/model/CategorieModel.dart';
import 'package:menu/model/OrderModel.dart';
import 'package:menu/services/OrderService.dart';
import 'package:menu/services/category_service.dart';
import 'package:menu/services/product_services.dart';
import 'package:menu/slider.dart';
import 'package:provider/provider.dart';
import 'ExpandeLeft.dart';
import 'constants/Url.dart';
import 'facebook.dart';
import 'model/ProduitModel.dart';
import 'model/apiRespons.dart';
import 'overlaid.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchQueryController = TextEditingController();


  // visibiliti of the expanded
  bool _isSecondPartVisible = false;

  void _toggleSecondPartVisibility() {
    setState(() {
      _isSecondPartVisible = selectedProducts.isNotEmpty;
    });

  }

  double calculateTotalPrice(List<ProduitModel> products) {
    double totalPrice = 0;
    for (var product in products) {
      totalPrice += product.prix ?? 0;
    }
    return totalPrice;
  }

  String _searchQuery = '';

  //Product list
  List<ProduitModel> products = [];
  List<CategorieModel> category = [];
  List<ProduitModel> selectedProducts = [];

  CategorieModel? selectedCategory;


  void getProductByCategory(int categoryId) async {
    try {
      // Make the API call to fetch products by category
      ApiResponse response = await fetchProductsByCategory(categoryId);

      if (response.error == null && mounted) {
        List<ProduitModel> fetchedProducts = response.data as List<ProduitModel>;

        // Filter products based on search query
        if (_searchQuery.isNotEmpty) {
          fetchedProducts = fetchedProducts.where((product) =>
              product.name!.toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();
        }
        setState(() {
          products = fetchedProducts;
        });

      } else if (response.error == 'unauthorized') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${response.error}')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch products')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }


  void searchProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (selectedCategory != null) {
        getProductByCategory(selectedCategory!.id!);
      }
    });
  }



  void getCategory() async {
    try {
      ApiResponse response = await fetchCategorys();
      if (response.error == null && mounted) {
        setState(() {
          category = response.data as List<CategorieModel>;
        });
        print("her is category list: ${category[3].name_category}");
      } else if (response.error == 'unauthorized') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${response.error}')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch categories')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }




  void showMyDialog(BuildContext context, ProduitModel product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _orderVM=Provider.of<OrderService>(context);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
          child: Container(
            padding: EdgeInsets.all(6),
            width: 700,
            height: 700,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                 ClipRRect(
                 borderRadius: BorderRadius.circular(35.0),
                 child: Container(
                 width:300,
                 height:300,
                 decoration: BoxDecoration(
                 image: DecorationImage(
                  image: NetworkImage('${product.image!}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
                        SizedBox(width: 25,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children : [
                        Text(
                          product.name!,
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          width: 350,
                          child: Text(
                            product.description!,
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Price: \$${product.prix!.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        ],
                        ),
                  ],
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          fontSize: 25,
                            color: Colors.black54),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedProducts.add(product);
                          _orderVM.handlesaveproduct(produitModel: product);
                        });
                        Navigator.pop(context);
                        _toggleSecondPartVisibility();
                        // Do something when the button is pressed
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(fontSize: 25),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: Text('Enregistrer le choix'),
                    )

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  List imageList = [
    {"id": 1, "image_path": 'Icons/Yasmina1.png'},
    {"id": 2, "image_path": 'Icons/LogoYassmina.png'},
    {"id": 3, "image_path": 'Icons/Yasmina1.png'},
    {"id": 4, "image_path": 'Icons/LogoYassmina.png'}

  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  // for PageView
  late PageController _pageController;
  int _currentIndex = 0;

               //initState
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    startTimer();
    getCategory();
  }

  @override
  void dispose() {
    _pageController.dispose();
    stopTimer();
    super.dispose();
  }

  // for button
  bool _isPressed = false;
  // for autoplay slider
  final CarouselController carouselControler = CarouselController();
  int Index = 0;
  List<Map<String, String>> imageListSlider = [
    {'image_path': 'Icons/Yasmina1.png'},
    {'image_path': 'assets/Yasmina1.png'},
    {'image_path': 'assets/Yasmina1.png'},
  ];

  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      final int nextPageIndex = (Index + 1) % imageListSlider.length;
      carouselControler.animateToPage(nextPageIndex);
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    final offreVM=Provider.of<OrderService>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Row(
          children: [
            ExpandedLeft(),
            Expanded(
              flex: 19,
              child: Container(
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15,),

                      Container(
                        padding: EdgeInsets.only(top: 12,left: 40),
                        constraints: BoxConstraints(
                          minHeight: 10.0,
                          minWidth: 200.0,
                          maxHeight: 50.0,
                          maxWidth: 400.0,
                        ),

                        //search textfield

                        child: TextField(
                          controller: _searchQueryController,
                          onChanged: (value) {
                            searchProducts(value); // Call the searchProducts function with the updated search query
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Colors.grey.shade400),),
                            fillColor: Colors.white,
                            filled: true ,
                            hintText: "Search",
                            hintStyle: TextStyle( color: Colors.grey.shade500,height: 3),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                     const SizedBox(height: 10,),


                      //Slider of home page

                      AutoplayListView(imageList: [
                        {"id": 1, "image_path": 'Icons/Yasmina1.png'},
                        {"id": 2, "image_path": 'Icons/LogoYassmina.png'},
                        {"id": 3, "image_path": 'Icons/Yasmina1.png'},
                        {"id": 2, "image_path": 'Icons/LogoYassmina.png'}

                      ], itemWidth: 450, itemHeight: 130,),

                      //text
                      Container(
                        padding: EdgeInsets.only(left: 55),
                        child: Row(
                          children: [
                            Text(
                              'Sélectionnez la catégorie que vous souhaitez ' ,
                              style: TextStyle(color: Colors.black,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.start,

                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15,),


                      /*    ElevatedButton(
                            onPressed: () {
                              _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                              setState(() {
                                _currentIndex = 0;
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                _currentIndex == 0 ? Colors.redAccent : Colors.white,
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.menu_book,
                                  color: _currentIndex == 0 ? Colors.white : Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Petite Déjouner',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: _currentIndex == 0 ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                      // list of categories
                      SizedBox(
                        height: 50,
                        child:
                        ListView.builder (
                          scrollDirection: Axis.horizontal,
                          itemCount: category.length,
                          itemBuilder: (context, index) {
                            CategorieModel currentCategory = category[index];
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _currentIndex = index;
                                      getProductByCategory(category[index].id!);
                                      print("her is the id of my category: ${category[index].id}");
                                    });
                                    _pageController.animateToPage(
                                      _currentIndex,
                                      duration: Duration(milliseconds: 10),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      _currentIndex == index ? Colors.redAccent : Colors.white,
                                    ),
                                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) return Colors.redAccent;
                                        return null;
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(currentCategory.icon!),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        currentCategory.name_category!,
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: _currentIndex == index ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // list of productes
                      const SizedBox(height: 15,),
                      SizedBox(
                        height: 350,
                        child: PageView.builder(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          controller: _pageController,
                          onPageChanged: (int index) {
                            setState(() {
                              _currentIndex = index;
                              getProductByCategory(category[index].id!);
                            });
                          },
                            itemCount: category.length,
                          itemBuilder: (BuildContext context,int index){

                          return  ListView.builder (
                              padding: EdgeInsets.only(bottom: 25),
                              itemCount: (products!.length / 3).ceil(),
                              itemBuilder: (BuildContext context, int index) {
                                int startingIndex = index * 3;
                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(
                                    (startingIndex + 3 <= products!.length)
                                        ? 3
                                        : products!.length - startingIndex,
                                        (i) {
                                      int currentIndex = startingIndex + i;
                                      final product = products![currentIndex];
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              print("her is the  product : ${product.id}");
                                              showMyDialog(context,product);

                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(35.0),
                                              ),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(35.0),
                                                    child: Container(
                                                      width:270,
                                                      height:270,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage('${product.image!}'),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Text(
                                            product.name!,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            Visibility(
              visible: selectedProducts.isNotEmpty,
              child: Expanded(
                flex: 6,
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('Icons/Yasmina1.png'),
                              Container(
                                  width: 200,
                                  child: Divider()
                              ),
                              SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('My Order',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              SingleChildScrollView(
                                physics: ScrollPhysics(), // Enable scrolling
                                child: ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: selectedProducts!.length,
                                  itemBuilder: (context, index) {
                                    if (index >= selectedProducts.length) {
                                      return null; // Return null for invalid indices
                                    }
                                    final selectedProduct = selectedProducts[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: Image.network('${selectedProduct.image!}'),
                                          title: Text(selectedProduct.name!),
                                          subtitle: Text('Prix: \$${selectedProduct.prix!.toStringAsFixed(2)}'),
                                          trailing: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                selectedProducts.removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                                 Container(
                                  width: 200,
                                  child: Divider()
                                      ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 10,),
                                  Text('Total :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                          SizedBox(width: 15,),
                          Text(
                           '${calculateTotalPrice(selectedProducts).toStringAsFixed(2)}'+' DH',
                             style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 22,
                               color: Colors.green,
                             ),
                           ),
                                ],
                              ),
                              SizedBox(height: 25,),
                              ElevatedButton(
                                onPressed: () {
                                  offreVM.sendProduct();
                                  SuccessMessageOverlay.show(context);

                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.pressed))
                                        return Colors.white; //<-- SEE HERE
                                      return null; // Defer to the widget's default.
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0), // <-- SET THE BORDER RADIUS HERE
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Valider',
                                  style: TextStyle(fontSize: 24 ,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
