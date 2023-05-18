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
import 'package:menu/services/category_service.dart';
import 'package:menu/services/product_services.dart';
import 'package:menu/slider.dart';
import 'constants/Url.dart';
import 'facebook.dart';
import 'model/ProduitModel.dart';
import 'model/apiRespons.dart';


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
      _isSecondPartVisible = true;
    });

  }


  //Product list
  List<ProduitModel> products = [];
  List<CategorieModel> category = [];
  List<ProduitModel> selectedProducts = [];

  CategorieModel? selectedCategory;

// Product list
  /*void getProduct() async {
    try {
      ApiResponse response = await fetchProducts();
      if (response.error == null && mounted) {
        setState(() {
          products = response.data as List<ProduitModel>;
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
  }*/
  void getProductByCategory(int categoryId) async {
    try {
      // Make the API call to fetch products by category
      ApiResponse response = await fetchProductsByCategory(categoryId);

      if (response.error == null && mounted) {
        setState(() {
          products = response.data as List<ProduitModel>;
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
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        product.image!,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
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
                        });
                        Navigator.pop(context);

                        _toggleSecondPartVisibility();
                        // Do something when the button is pressed
                      },
                      child: Text(
                        'Enregestrer le choix',
                        style: TextStyle(color: Colors.green,
                        fontSize: 25),
                      ),
                    ),
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



  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    startTimer();

    if (selectedCategory != null) {
      fetchProductsByCategory(selectedCategory!.id_category!); // Pass the selected category's ID to fetchProductsByCategory
    } else {
      print("no data found") ; // Fetch all products if no category is selected
    }
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
    List<String> items = ['Item 1','Item 2','Item 3'];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFfa7777),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(35),bottomRight: Radius.circular(35))
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.home,size: 35,color: Colors.white,), onPressed: () { Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>  MyHomePage()),
                        ); },
                        ),
                        SizedBox(height: 50,),
                        IconButton(
                          icon: Icon(Icons.facebook,size: 35,color: Colors.white,), onPressed: () {
                          Navigator.push(
                            context,MaterialPageRoute(builder: (context) => WebViewAppFacbook()),
                          ); },
                        ),
                        SizedBox(height: 50,),
                        IconButton(
                          icon: Image.asset('Icons/instagram.png',color: Colors.white,width: 35,height: 35,), onPressed: () { Navigator.push(
                          context,MaterialPageRoute(builder: (context) => WebViewAppInstagram()),
                        ); },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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

                      const SizedBox(height: 15,),

                      //Slider of home page

                      AutoplayListView(imageList: [
                        {"id": 1, "image_path": 'Icons/Yasmina1.png'},
                        {"id": 2, "image_path": 'Icons/LogoYassmina.png'},
                        {"id": 3, "image_path": 'Icons/Yasmina1.png'},
                        {"id": 2, "image_path": 'Icons/LogoYassmina.png'}

                      ], itemWidth: double.infinity, itemHeight: 150,),
                      const SizedBox(height: 12,),

                      //text
                      Container(
                        padding: EdgeInsets.only(left: 55),
                        child: Row(
                          children: [
                            Text(
                              'Select category you would like  ' ,
                              style: TextStyle(color: Colors.black,
                                  fontSize: 20),
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

                        ListView.builder(
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
                                      getProductByCategory(category[index].id_category!);
                                      print("her is the id of my category: ${category[index].id_category}");
                                    });
                                    _pageController.animateToPage(
                                      1,
                                      duration: Duration(milliseconds: 500),
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
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (int index) {
                            setState(() {
                              _currentIndex = index;
                            } );
                          },
                          children : [
                            ListView.builder(
                              padding: EdgeInsets.only(bottom: 10),
                              itemCount: (products!.length / 3).ceil(),
                              itemBuilder: (BuildContext context, int index) {
                                int startingIndex = index * 3;
                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
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
                                            onTap: () => showMyDialog(context,product),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(35.0),
                                              ),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(35.0),
                                                    child: Image.asset(
                                                      product.image!,
                                                      width: 270,
                                                      height: 270,
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
                            )

                            //List for products
                            /* ListView.builder(
                              padding: EdgeInsets.only(bottom: 10),
                              itemCount: (products!.length / 3).ceil(),
                              itemBuilder: (BuildContext context, int index) {
                                int startingIndex = index * 3;
                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 3,
                                  children: List.generate(
                                    (startingIndex + 3 <= products!.length) ? 3 : products!.length - startingIndex,
                                        (i) {
                                      int currentIndex = startingIndex + i;
                                      final product = products[currentIndex];
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () => showMyDialog(context),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(35.0),
                                              ),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(35.0),
                                                    child: Image.asset(
                                                      product.image!,
                                                      width: 270,
                                                      height: 270,
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
                            )
*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            Visibility(
              visible: _isSecondPartVisible,
              child: Expanded(
                flex: 5,
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
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              SingleChildScrollView(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(), // Enable scrolling
                                  itemCount: selectedProducts!.length,
                                  itemBuilder: (context, index) {
                                    if (index >= selectedProducts.length) {
                                      return null; // Return null for invalid indices
                                    }
                                    final selectedProduct = selectedProducts[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(selectedProduct.name!),
                                          subtitle: Text('Price: \$${selectedProduct.prix!.toStringAsFixed(2)}'),
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
                                  Text('Total :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text('Prix:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25,),
                              ElevatedButton(
                                onPressed: () {},
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
