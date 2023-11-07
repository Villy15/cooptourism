import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomNavHomeWidget extends ConsumerStatefulWidget {
  const BottomNavHomeWidget({Key? key}) : super(key: key);
  @override
  ConsumerState<BottomNavHomeWidget> createState() =>
      _BottomNavHomeWidgetState();
}

class _BottomNavHomeWidgetState extends ConsumerState<BottomNavHomeWidget> {
  String? role;

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(homePageControllerProvider);
    final user = ref.watch(userModelProvider);
    role = user?.role ?? 'Customer';

    // debugPrint("role: $role");

    // Changes the bottom navigation bar items based on the user's role
    List<BottomNavigationBarItem> items;
    if (user?.role == 'Manager') {
      items = _getManagerItems();
    } else if (role == 'Member') {
      items = _getMemberItems();
    } else if (role == 'Customer') {
      items = _getCustomerItems();
    } else {
      items = _getMemberItems();
    }

    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        iconSize: 30,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        // unselectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedLabelStyle:
            TextStyle(color: Theme.of(context).colorScheme.primary),
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedLabelStyle:
            TextStyle(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Theme.of(context).colorScheme.background,
        // selectedFontSize: 12,
        items: items,
        currentIndex: position,
        onTap: (value) => _onTap(value));
  }

  void _onTap(int index) {
    ref.read(homePageControllerProvider.notifier).setPosition(index);
    final user = ref.read(userModelProvider);
    switch (index) {
      case 0:
        if (role == "Manager") {
          context.go("/manager_home_page");
        } else if (role == 'Member') {
          context.go("/member_dashboard_page");
        } else if (role == 'Customer'){
          context.go("/customer_home_page");
        }

        break;
      case 1:
        if (role == 'Manager') {
          context.go("/dashboard_page");
        } else if (role == 'Member') {
          context.go("/wallet_page");
        } else if (role == 'Customer') {
          context.go("/market_page");
        }
        break;
      case 2:
        if (role == 'Manager') {
          context.go("/members_page");
        } else if (role == 'Member') {
          context.go("/market_page");
        } else if (role == 'Customer') {
          context.go("/events_page");
        }
        break;
      case 3:
        if (role == 'Manager') {
          context.go("/reports_page");
        } else if (role == 'Member') {
          context.go("/profile_page/${user!.uid}}");
        } else if (role == 'Customer') {
          context.go("/coops_page");
        }
        break;
      case 4:
        context.go("/menu_page");
        break;
      default:
    }
  }

  List<BottomNavigationBarItem> _getManagerItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard_rounded),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_outline_rounded), 
        activeIcon: Icon(Icons.people_rounded),
        label: 'Members',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart_outlined),
        activeIcon: Icon(Icons.bar_chart_rounded),
        label: 'Reports',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_rounded),
        activeIcon: Icon(Icons.menu_open_rounded),
        label: 'Menu',
      ),
    ];
  }

  List<BottomNavigationBarItem> _getMemberItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet_outlined),
        activeIcon: Icon(Icons.account_balance_wallet_rounded),
        label: 'Wallet',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.store_mall_directory_outlined),
        activeIcon: Icon(Icons.store_mall_directory_rounded),
        label: 'Market',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_rounded),
        activeIcon: Icon(Icons.person_rounded),
        label: 'Profile',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_rounded),
        activeIcon: Icon(Icons.menu_open_rounded),
        label: 'Menu',
      ),
    ];
  }

  List<BottomNavigationBarItem> _getCustomerItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.store_mall_directory_outlined),
        activeIcon: Icon(Icons.store_mall_directory_rounded),
        label: 'Market',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event_outlined),
        activeIcon: Icon(Icons.event_rounded),
        label: 'Events',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.group_outlined),
        activeIcon: Icon(Icons.group_rounded),
        label: 'Coops',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_rounded),
        activeIcon: Icon(Icons.menu_open_rounded),
        label: 'Menu',
      ),
    ];
  }
}
