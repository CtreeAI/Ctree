import 'package:ctree/pages/auth/data/auth_repository.dart';
import 'package:ctree/pages/dashboard/components/nav_item.dart';
import 'package:ctree/pages/feed/feed_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // O índice selecionado na barra de navegação
  int _selectedIndex = 0;

  // Inicializa _navItems como uma lista vazia
  late List<NavItem> _navItems = [];

  // Função para atualizar o índice e navegar para a página correspondente
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // A lista de telas para navegação
  final List<Widget> _pages = [
    FeedPage(),
  ];

  @override
  void initState() {
    super.initState();
    _updateNavItems();
  }

  // Método assíncrono para atualizar os itens da barra de navegação
  void _updateNavItems() async {
    final userModel = AuthRepository.currentUserModel;
    if (userModel != null) {
      setState(() {
        if (userModel.role == 'User') {
          _navItems = const [
            NavItem(icon: Icons.dashboard, label: 'Feed'),
            NavItem(icon: Icons.settings, label: 'Denunciar'),
            NavItem(icon: Icons.person, label: 'Chat'),
          ];
        } else if (userModel.role == 'Org') {
          _navItems = const [
            NavItem(icon: Icons.dashboard, label: 'Feed'),
            NavItem(icon: Icons.business, label: 'Listar Denuncias'),
            NavItem(icon: Icons.add, label: 'Criar Post'),
            NavItem(icon: Icons.message_rounded, label: 'Chat'),
          ];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se os _navItems foram inicializados antes de renderizar a UI
    if (_navItems.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            // Barra lateral de navegação
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              extended: true,
              destinations: _navItems
                  .map((item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        label: Text(item.label),
                      ))
                  .toList(),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: _pages[_selectedIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
