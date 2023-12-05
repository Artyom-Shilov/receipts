import 'dart:typed_data';

import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:dio/dio.dart';

import 'network_models/network_ingredient.dart';
import 'network_models/network_measure_unit.dart';
import 'network_models/network_recipe.dart';
import 'network_models/network_recipe_step.dart';
import 'network_models/recipe_ingredient_link.dart';
import 'network_models/recipe_step_link.dart';

class DioRecipeClient implements BaseNetworkRecipeClient {
  final String baseUrl = 'https://foodapi.dzolotov.tech';

  DioRecipeClient() {
    final options =
        BaseOptions(baseUrl: baseUrl, contentType: Headers.jsonContentType);
    _dio.options = options;
  }

  final Dio _dio = Dio();

  @override
  Future<List<NetworkRecipe>> getRecipes() async {
    final response = await _dio.get<List>('/recipe');
    return response.data!.map((e) => NetworkRecipe.fromJson(e)).toList();
  }

  @override
  Future<List<RecipeStepLink>> getRecipeStepLinks() async {
    final response = await _dio.get<List>('/recipe_step_link');
    return response.data!.map((e) => RecipeStepLink.fromJson(e)).toList();
  }

  @override
  Future<NetworkRecipeStep> getRecipeStepById(int id) async {
    final response = await _dio.get('/recipe_step/$id');
    return NetworkRecipeStep.fromJson(response.data);
  }

  @override
  Future<List<RecipeIngredientLink>> getRecipeIngredientsLinks() async {
    final response = await _dio.get<List>('/recipe_ingredient');
    return response.data!.map((e) => RecipeIngredientLink.fromJson(e)).toList();
  }

  @override
  Future<NetworkIngredient> getIngredientById(int id) async {
    final response = await _dio.get('/ingredient/$id');
    return NetworkIngredient.fromJson(response.data);
  }

  @override
  Future<NetworkMeasureUnit> getMeasureUnitById(int id) async {
    final response = await _dio.get('/measure_unit/$id');
    return NetworkMeasureUnit.fromJson(response.data);
  }

  @override
  Future<Uint8List> getImage(String imageUrl) async {
    final response = await _dio.get<Uint8List>(imageUrl, options: Options(responseType: ResponseType.bytes));
    return response.data!;
  }
}
