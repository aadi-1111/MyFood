import 'package:myfood/models/food.dart';

class FridgeContainer {
  late Map<String, int> mapIndex;
  late List<Food> listOfFood;
  late String name;
  FridgeContainer() {
    mapIndex = new Map<String, int>();
    name = "default";
  }
  FridgeContainer.withName(String name) {
    mapIndex = new Map<String, int>();
    this.name = name;
  }
  void add(String food) {
    if (mapIndex.containsKey(food)) {
      listOfFood[mapIndex[food]!].increaseCount();
      listOfFood[mapIndex[food]!].save();
    } else {
      mapIndex[food] = this.getSize();
      listOfFood.add(new Food(food, this.name));
      listOfFood[this.getSize() - 1].save();
    }
  }

  getSize() {
    return mapIndex.length;
  }

  operator [](int key) {
    return listOfFood[key];
  }
}
