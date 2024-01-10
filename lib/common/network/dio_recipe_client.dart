import 'dart:typed_data';

import 'package:receipts/common/exceptions/exceptions.dart';
import 'package:receipts/common/exceptions/object_not_found_exception.dart';
import 'package:receipts/common/exceptions/unknown_code_exception.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:dio/dio.dart';
import 'package:receipts/common/network/network_models/network_favourite.dart';

import 'network_models/network_models.dart';

class DioRecipeClient implements BaseNetworkRecipeClient {
  final String baseUrl = 'https://foodapi.dzolotov.tech';

  DioRecipeClient() {
    _dio.options =
        BaseOptions(baseUrl: baseUrl, contentType: Headers.jsonContentType);
  }

  final Dio _dio = Dio();

  @override
  Future<List<NetworkRecipe>> getRecipes() async {
    final response = await _dio.get<List>('/recipe');
    if (response.statusCode == 200) {
      return response.data!.map((e) => NetworkRecipe.fromJson(e)).toList();
    }
    if (response.statusCode == 400) {
      throw InvalidRequestException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<List<RecipeStepLink>> getRecipeStepLinks() async {
    final response = await _dio.get<List>('/recipe_step_link');
    if (response.statusCode == 200) {
      return response.data!.map((e) => RecipeStepLink.fromJson(e)).toList();
    }
    if (response.statusCode == 400) {
      throw InvalidRequestException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<NetworkRecipeStep> getRecipeStepById(int id) async {
    final response = await _dio.get('/recipe_step/$id');
    if (response.statusCode == 200) {
      return NetworkRecipeStep.fromJson(response.data);
    }
    if (response.statusCode == 404) {
      throw ObjectNotFoundException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<List<RecipeIngredientLink>> getRecipeIngredientsLinks() async {
    final response = await _dio.get<List>('/recipe_ingredient');
    if (response.statusCode == 200) {
      return response.data!
          .map((e) => RecipeIngredientLink.fromJson(e))
          .toList();
    }
    if (response.statusCode == 400) {
      throw InvalidRequestException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<NetworkIngredient> getIngredientById(int id) async {
    final response = await _dio.get('/ingredient/$id');
    if (response.statusCode == 200) {
      return NetworkIngredient.fromJson(response.data);
    }
    if (response.statusCode == 404) {
      throw ObjectNotFoundException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<NetworkMeasureUnit> getMeasureUnitById(int id) async {
    final response = await _dio.get('/measure_unit/$id');
    if (response.statusCode == 200) {
      return NetworkMeasureUnit.fromJson(response.data);
    }
    if (response.statusCode == 404) {
      throw ObjectNotFoundException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<Uint8List> getImage(String imageUrl) async {
    final response = await _dio.get<Uint8List>(imageUrl,
        options: Options(responseType: ResponseType.bytes));
    if (response.statusCode == 200) {
      return response.data!;
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<List<NetworkFavourite>> getFavourites() async {
    final response = await _dio.get<List>('/favorite');
    if (response.statusCode == 200) {
      return response.data!.map((e) => NetworkFavourite.fromJson(e)).toList();
    }
    if (response.statusCode == 400) {
      throw InvalidRequestException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<int> markAsFavourite(int recipeId, int userId) async {
    final json = NetworkFavourite(
            id: -1,
            recipe: LinkedToFavouriteRecipe(id: recipeId),
            user: LinkedToFavouriteUser(id: userId))
        .toJson();
    json.remove('id');
    final response = await _dio.post('/favorite', data: json);
    if (response.statusCode == 200) {
      return NetworkFavourite.fromJson(response.data).id;
    }
    if (response.statusCode == 400) {
      throw InvalidRequestException();
    } else if (response.statusCode == 409) {
      throw ObjectAlreadyExistsException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<void> unmarkFavourite(int favouriteId) async {
    final response = await _dio.delete('/favorite/$favouriteId');
    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 404) {
      throw ObjectNotFoundException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }
}
