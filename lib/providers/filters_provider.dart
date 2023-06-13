import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/Screens/filters.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum Filters { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filters, bool>> {
  FiltersNotifier()
      : super({
          Filters.vegan: false,
          Filters.glutenFree: false,
          Filters.vegetarian: false,
          Filters.lactoseFree: false,
        });

  void setFilters(Map<Filters, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filters filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filterProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filters, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider(
  (ref) {
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filterProvider);
    return meals.where(
      (meal) {
        if (activeFilters[Filters.glutenFree]! && !meal.isGlutenFree) {
          return false;
        }
        if (activeFilters[Filters.lactoseFree]! && !meal.isLactoseFree) {
          return false;
        }
        if (activeFilters[Filters.vegetarian]! && !meal.isVegetarian) {
          return false;
        }
        if (activeFilters[Filters.vegan]! && !meal.isVegan) {
          return false;
        }
        return true;
      },
    ).toList();
  },
);
