import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:lily_books/models/auth_screen.model.dart';
import 'package:lily_books/ui/screens/auth/auth_type/auth_type_cubit.dart';
import 'package:lily_books/ui/screens/auth/authentication_cubit.dart';
import 'package:lily_books/ui/screens/auth/hide_password/hide_password_cubit.dart';
import 'package:lily_books/ui/screens/auth/sign_in/sign_in_form.dart';
import 'package:lily_books/ui/screens/auth/sign_up/sign_up_form.dart';
import 'package:lily_books/ui/screens/home/home.screen.dart';
import 'package:lily_books/ui/widgets/auth_tab.widget.dart';

class AuthenticationScreen extends StatelessWidget {
  _getForm(AuthScreenType type) {
    switch (type) {
      case AuthScreenType.SignIn:
        return SignInForm();
      case AuthScreenType.SignUp:
        return SignUpForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CubitListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is SignedIn) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            }
            if (state is ForgotPassword) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            }
          },
          child: MultiCubitProvider(
            providers: [
              CubitProvider<AuthTypeCubit>(
                create: (_) => AuthTypeCubit(),
              ),
              CubitProvider<HidePasswordCubit>(
                create: (_) => HidePasswordCubit(),
              ),
            ],
            child: CubitBuilder<AuthTypeCubit, AuthScreenType>(
              builder: (context, type) => ListView(
                children: [
                  _buildTabMenu(context, type),
                  _getForm(type),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _buildTabMenu(BuildContext context, AuthScreenType type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: authMenu
          .map((item) => AuthTabWidget(item: item, type: type))
          .toList(),
    );
  }
}