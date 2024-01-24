import 'dart:typed_data';

import 'package:receipts/common/exceptions/exceptions.dart';
import 'package:receipts/common/exceptions/user_already_exists_exception.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:dio/dio.dart';
import 'package:receipts/common/network/network_models/network_comment.dart';
import 'package:receipts/common/network/network_models/network_favourite.dart';

import 'network_models/network_models.dart';

class DioRecipeClient implements BaseNetworkRecipeClient {
  final String baseUrl = 'https://foodapi.dzolotov.tech';

  DioRecipeClient() {
    _dio.options =
        BaseOptions(baseUrl: baseUrl, contentType: Headers.jsonContentType, validateStatus: (_) => true);
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

  @override
  Future<List<NetworkComment>> getComments() async {
    final response = await _dio.get<List>('/comment');
    if (response.statusCode == 200) {
      return response.data!.map((e) => NetworkComment.fromJson(e)).toList();
    }
    if (response.statusCode == 400) {
      throw InvalidRequestException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<NetworkUser> getUserById(int id) async {
    final response = await _dio.get('/user/$id');
    if (response.statusCode == 200) {
      return NetworkUser.fromJson(response.data);
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<int> sendComment(
      {required String text,
      required String photo,
      required String datetime,
      required int userId,
      required int recipeId}) async {
    final json = NetworkComment(
            id: -1,
            text: text,
            photo: photo,
            datetime: datetime,
            user: LinkedToCommentUser(id: userId),
            recipe: LinkedToCommentRecipe(id: recipeId))
        .toJson();
    json.remove('id');
    final response = await _dio.post('/comment', data: json);
    if (response.statusCode == 200) {
      return NetworkComment.fromJson(response.data).id;
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
  Future<String> loginUser({required String login, required String password}) async {
    final json =
    NetworkUser(null, null, id: -1, login: login, password: password).toJson();
    json.remove('id');
    json.remove('avatar');
    json.remove('token');
    final response = await _dio.put<String>('/user', data: json);
    if (response.statusCode == 200) {
      return response.data!;
    }
    if (response.statusCode == 400) {
      throw InvalidRequestException();
    } else if (response.statusCode == 403) {
      throw InvalidCredentialsException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }

  @override
  Future<String> registerUser({required String login, required String password}) async {
    final json =
        NetworkUser(null, null, id: -1, login: login, password: password).toJson();
    json.remove('id');
    final response = await _dio.post<String>('/user', data: json);
    if (response.statusCode == 200) {
      return response.data!;
    }
    if (response.statusCode == 400) {
      throw InvalidRequestException();
    } else if (response.statusCode == 409) {
      throw UserAlreadyExistsException();
    } else {
      throw UnknownCodeException(code: response.statusCode);
    }
  }
}
