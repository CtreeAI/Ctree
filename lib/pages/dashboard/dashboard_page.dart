import 'package:ctree/pages/Complaint/complaint_page.dart';
import 'package:ctree/pages/auth/data/auth_repository.dart';
import 'package:ctree/pages/ctComplaint/create_complaint.dart';
import 'package:ctree/pages/ctPost/create_post_page.dart';
import 'package:ctree/pages/dashboard/components/nav_item.dart';
import 'package:ctree/pages/feed/feed_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late List<NavItem> _navItems = [];
  late List<Widget> _pages = [];
  String? _userRole;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
  }

  void _initializeNavigation() {
    final userModel = AuthRepository.currentUserModel;
    if (userModel != null) {
      setState(() {
        _userRole = userModel.role;
        _updateNavItemsAndPages();
      });
    }
  }

  void _updateNavItemsAndPages() {
    switch (_userRole) {
      case 'User':
        _navItems = const [
          NavItem(icon: Icons.dashboard, label: 'Feed'),
          NavItem(icon: Icons.settings, label: 'Report'),
          NavItem(icon: Icons.person, label: 'Chat'),
        ];
        _pages = [
          const FeedPage(),
          const CreateComplaintPage(),
          const Placeholder(),
        ];
        break;

      case 'Org':
        _navItems = const [
          NavItem(icon: Icons.dashboard, label: 'Feed'),
          NavItem(icon: Icons.business, label: 'List Complaints'),
          NavItem(icon: Icons.add, label: 'Create Post'),
          NavItem(icon: Icons.message_rounded, label: 'Chat'),
        ];
        _pages = [
          const FeedPage(),
          const ComplaintsPage(),
          const CreatePostPage(),
          const Placeholder(),
        ];
        break;

      default:
        // Default configuration or for unauthenticated users
        _navItems = const [
          NavItem(icon: Icons.dashboard, label: 'Feed'),
        ];
        _pages = [
          const FeedPage(),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if navigation is initialized
    if (_navItems.isEmpty || _pages.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check if the selected index is valid for the current page list
    if (_selectedIndex >= _pages.length) {
      _selectedIndex = 0;
    }

    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
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
