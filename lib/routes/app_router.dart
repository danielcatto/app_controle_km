import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/inicio_page.dart';
import '../pages/calcular_km_page.dart';
import '../pages/sobre_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'inicio',
          pageBuilder: (context, state) => NoTransitionPage(child: InicioPage()),
        ),
        GoRoute(
          path: '/calcular',
          name: 'calcular',
          pageBuilder: (context, state) => NoTransitionPage(child: CalcularKmPage()),
        ),
        GoRoute(
          path: '/sobre',
          name: 'sobre',
          pageBuilder: (context, state) => NoTransitionPage(child: SobrePage()),
        ),
      ],
    ),
  ],
);

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({required this.child, Key? key}) : super(key: key);
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/calcular');
        break;
      case 2:
        context.go('/sobre');
        break;
    }
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Início';
      case 1:
        return 'Calcular KM';
      case 2:
        return 'Sobre';
      default:
        return '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouter.of(context).location;
    int idx = 0;
    if (location.startsWith('/calcular')) idx = 1;
    else if (location.startsWith('/sobre')) idx = 2;
    if (idx != _currentIndex) setState(() => _currentIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titleForIndex(_currentIndex))),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calcular'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Sobre'),
        ],
      ),
    );
  }
}
