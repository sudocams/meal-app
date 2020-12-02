import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meal/dummy.dart';
import 'package:meal/models/meal.dart';
import 'package:meal/screens/category_meals.dart';
import 'package:meal/screens/filtersScreen.dart';
import 'package:meal/screens/meal_detailScreen.dart';
import 'package:meal/screens/tabs_screen.dart';
import 'package:meal/widgets/category_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }

        if (_filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }

        if (_filters['vegan'] && !meal.isVegan) {
          return false;
        }

        if (_filters['vegetarian'] && !meal.isVegetarian) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _toggleFavorites(String mealId) {
    final existingIndex =
        _favoriteMeals.indexWhere((meal) => meal.id == mealId);

    if (existingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }
  }
  bool _isMealFavorite(String id){
    return _favoriteMeals.any((meal) => meal.id ==id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              headline2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              headline6: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold))),
      debugShowCheckedModeBanner: false,
      // home: TabScreen(),
      initialRoute: '/',

      routes: {
        '/': (ctx) => TabScreen(_favoriteMeals),
        // CategoryItem.routeName:(ctx)=> CategoryItem(),
        CategoryMeals.routeName: (ctx) => CategoryMeals(_availableMeals),
        MealDetailsScreen.routeName: (ctx) => MealDetailsScreen(_toggleFavorites, _isMealFavorite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },

      // onGenerateRoute: (settings){
      //   print(settings.arguments);
      //   if(settings.name == '/meal_details'){
      //     return  MaterialPageRoute(builder: (ctx)=> MealDetailsScreen());
      //   }
      //   return MaterialPageRoute(builder: (ctx)=> MealDetailsScreen());
      // },

      // onUnknownRoute: (settings){
      //   // this is used to prevent unnecessary crushing it will naviagate the use to this router before crush
      //    MaterialPageRoute(builder: (ctx)=> MealDetailsScreen());
      // }
    );
  }
}
