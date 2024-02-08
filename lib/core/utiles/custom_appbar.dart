import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onCartTap;
  final int cartItemCount;

  const CommonAppBar({super.key,
    required this.title,
     this.onCartTap,
    required this.cartItemCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      elevation: 8.0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple,
              Colors.deepPurpleAccent,
              Colors.deepPurple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      actions: <Widget>[
        _buildCartIcon(),
      ],
    );
  }

  Widget _buildCartIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkResponse(
        onTap: onCartTap,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                cartItemCount > 0 ? cartItemCount.toString() : '',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
