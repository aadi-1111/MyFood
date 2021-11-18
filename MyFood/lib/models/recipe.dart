//class Recipe {
//  final String name;
//  final int calorie;

//  Recipe(this.name, this.calorie);
//}
class RecipeModel {
  final String title;
  final double rating;
  final double calories;
  final String uri;
  final String time;
  final List ingredients;
  final List steps;
  final List equipment;

  RecipeModel(this.title, this.rating, this.calories, this.time, this.uri,
      this.ingredients, this.steps, this.equipment);
}
