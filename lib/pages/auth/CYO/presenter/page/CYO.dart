import 'package:ctree/core/components/text_app.dart';
import 'package:ctree/core/components/view_component.dart';
import 'package:ctree/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CYOPage extends StatelessWidget {
  const CYOPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewComponent(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const TextApp(
                label: 'Ctree',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              const SizedBox(height: 20),
              Image.asset('assets/images/logo.jpeg', height: 150),
              const SizedBox(height: 40),

              // Botões de Login Social
              _buildSocialButton(
                label: 'Entrar',
                color: AppColors.gray,
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
              ),
              const SizedBox(height: 15),
              _buildSocialButton(
                label: 'Cadastrar',
                color: AppColors.gray,
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: color),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: color),
      ),
    );
  }
}
