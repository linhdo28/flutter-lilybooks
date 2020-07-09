import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:lily_books/ui/screens/auth/authentication.screen.dart';
import 'package:lily_books/ui/screens/auth/authentication_cubit.dart';
import 'package:lily_books/ui/screens/loading_state/loading_state_cubit.dart';
import 'package:lily_books/ui/screens/splash/authorization_cubit.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CubitListener<AuthorizationCubit, AuthorizationState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MultiCubitProvider(
                providers: [
                  CubitProvider(create: (_) => AuthenticationCubit()),
                  CubitProvider(create: (_) => LoadingStateCubit()),
                ],
                child: AuthenticationScreen(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign out'),
                onTap: () {
                  context.cubit<AuthorizationCubit>().signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
