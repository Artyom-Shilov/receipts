import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/widgets/widgets.dart';
import 'package:receipts/common/constants/constants.dart';

class AuthPage extends HookWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final GlobalKey<FormState> formKey;
    useEffect(() {
      formKey = GlobalKey<FormState>();
      return null;
    });
    return SingleChildScrollView(
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 230,
            child: Form(
              key: formKey,
              child: const Column(
                children: [
                  SizedBox(height: 200),
                  Text(
                    LoginPageTexts.appName,
                    style: TextStyle(
                        fontSize: 30, color: Colors.white),
                  ),
                  SizedBox(height: 80),
                  LoginInputField(),
                  SizedBox(height: 16),
                  PasswordInputField(),
                  SizedBox(height: 16),
                  RepeatPasswordField(),
                  SizedBox(height: 150),
                  ProcessSwitchButton(),
                ],
              ),
            ),
          ),
        ),
        AnimatedAuthButton(formKey: formKey)
      ]),
    );
  }
}
