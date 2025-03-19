import 'package:nexus/core/constants/app_styles.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Column(
        children: [
          Container(
            alignment: Alignment(-0.8, 0.8),
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              image: const DecorationImage(
                image: AssetImage('assets/images/cartographer.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(
              'Log In',
              style: TextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: PrimaryButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                child: const Text('Login'),
              )),
            ),
          )
        ],
      ),
    );
  }
}
