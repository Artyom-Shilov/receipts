abstract class BottomAppBarTexts {

  static const recipes = 'Рецепты';
  static const freezer = 'Холодильник';
  static const favourite = 'Избранное';
  static const profile = 'Профиль';
  static const login = 'Вход';
}

abstract class StabTexts {

  static const workInProgress = 'В работе';
}

abstract class TimeUnits {

  static const minutesOne = 'минута';
  static const minutesFew = 'минуты';
  static const minutesMany = 'минут';
}

abstract class LoginPageTexts {

  static const loginHint = 'логин';
  static const passwordHint = 'пароль';
  static const repeatPasswordHint = 'пароль ещё раз';
  static const appName = 'Otus.Food';
  static const doLogin = 'Войти';
  static const doRegister = 'Регистрация';
  static const toRegisterToggle = 'Зарегестрироваться';
  static const toLoginToggle = 'Войти в приложение';

  static const inputLoginValidatorMessage = 'Введите логин';
  static const inputPasswordValidatorMessage = 'Введите пароль';
  static const inputRepeatPasswordValidatorMessage = 'Повторите пароль';
  static const invalidRepeatPasswordValidatorMessage = 'Пароли не совпадают';
}

abstract class ProfilePageTexts {

  static const login = 'Логин';
  static const doLogout = 'Выход';
}

abstract class RecipeInfoTexts {

  static const mainAppBarTitle = 'Рецепт';
  static const photoGridPageAppBarTitle = 'Фото пользователя';
  static const ingredientsSectionTitle = 'Ингридиенты';
  static const stepsSectionTitle = 'Шаги приготовления';
  static const startCookingButton = 'Начать готовить';
  static const commentInputHint = 'оставить комментарий';
}

abstract class DetectionTexts {

  static const couldNotReliableFindDetections = 'Не удалось найти объекты с высокой достоверностью';
  static const undoSnackBar = 'Убрать';
}

abstract class FavouriteTexts {

  static const noFavouriteRecipes = 'Нет избранных рецептов';
}

abstract class PageNotFoundTexts {
  static const title = 'Страница не найдена';
  static const toMain = 'На главную';
}

abstract class ErrorMessages {

  static const common = 'Возникла непредвиденная ошибка';
  static const changeRecipeInfo = 'Ошибка при работе с рецептом';
  static const loadRecipesNet = 'Ошибка при загрузке рецепта по сети';
  static const loadRecipesLocal = 'Ошибка при загрузке локальных рецептов';
  static const emptyRecipeStorage = 'Нет доступа к сети. Не найдено локальных рецептов';
  static const loadFavouriteInfo = 'Ошибка получения информации о любимых рецептах';
  static const loadComments = 'Ошибка получения комментариев пользователей';
  static const changeFavouriteStatus = 'Ошибка при изменении статуса рецепта';
  static const sendComment = 'Ошибка при отправке комментария';

  static const photoViewError = 'Не удалось отобразить фото';

  static const credentials = 'Неверный логин или пароль';
  static const userAlreadyExists = 'Пользователь уже существует';
  static const authBaseError = 'Ошибка при авторизации';
  static const noConnection = 'Нет соединения с сетью';
  
  static const photoProcessInitError = 'Ошибка инициализации процесса съёмки';
}


