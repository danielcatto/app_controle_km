import 'package:controle_km/pages/add_km_litros_page.dart';
import 'package:controle_km/pages/medir_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/inicio_page.dart';
import '../pages/calcular_km_page.dart';
import '../pages/sobre_page.dart';
import '../pages/config_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'inicio',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: InicioPage()),
        ),
        GoRoute(
          path: '/calcular',
          name: 'calcular',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: CalcularKmPage()),
        ),
        GoRoute(
          path: '/sobre',
          name: 'sobre',
          pageBuilder: (context, state) => NoTransitionPage(child: SobrePage()),
        ),
        GoRoute(
          path: '/add',
          name: 'Add Km',
          pageBuilder: (context, state) => NoTransitionPage(child: AddPage()),
        ),
        
        GoRoute(
          path: '/medir',
          name: 'Medir distancia',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: RotaGpsPage()),
        ),

        GoRoute(
          path: '/config',
          name: 'Configurações',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: ConfigPage()),
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
      case 3:
        context.go('/add');
        break;
      case 4:
        context.go('/medir');
        break;
      case 5:
        context.go('/config');
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
      case 3:
        return 'Add Km';
      case 4:
        return 'Medir Distancia';
      case 5:
        return 'Configurações';
      default:
        return '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouter.of(context).location;
    int idx = 0;
    if (location.startsWith('/calcular'))
      idx = 1;
    else if (location.startsWith('/sobre')) idx = 2;
    if (idx != _currentIndex) setState(() => _currentIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titleForIndex(_currentIndex))),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Usuário"),
              accountEmail: Text("usuario@email.com"),
              currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              selected: _currentIndex == 0,
              onTap: () {
                Navigator.of(context).pop();
                _onTap(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Calcular KM'),
              selected: _currentIndex == 1,
              onTap: () {
                Navigator.of(context).pop();
                _onTap(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre'),
              selected: _currentIndex == 2,
              onTap: () {
                Navigator.of(context).pop();
                _onTap(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Km'),
              selected: _currentIndex == 3,
              onTap: () {
                Navigator.of(context).pop();
                _onTap(3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Medir Distância'),
              selected: _currentIndex == 4,
              onTap: () {
                Navigator.of(context).pop();
                _onTap(4);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              selected: _currentIndex == 5,
              onTap: () {
                Navigator.of(context).pop();
                _onTap(5);
              },
            ),

          ],
        ),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,

        // --- CORES DO MENU ---
        backgroundColor:
            const Color.fromARGB(153, 121, 119, 119), // Cor do fundo do menu
        selectedItemColor: const Color.fromARGB(
            255, 241, 241, 241), // Cor do ícone/texto selecionado
        unselectedItemColor: const Color.fromARGB(
            255, 216, 197, 197), // Cor dos íconer/textos inativos

        // Define o tipo de fundo (necessário para cores funcionarem corretamente com 4+ itens)
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calculate), label: 'Calcular'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Sobre'),
        ],
      ),
    );
  }
}
