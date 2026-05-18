import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/catches_log_screen.dart';
import 'screens/fishing_spots_screen.dart';
import 'providers/fishing_provider.dart';
import 'screens/add_catch_screen.dart';
import 'screens/add_fishing_spot_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FishingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kapásjelző - Halas App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF0277BD),
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 18),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CatchesLogScreen(),
    const FishingSpotsScreen(),
  ];

  final List<String> _titles = [
    'Főoldal',
    'Fogási Napló',
    'Horgászhelyek',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Content flows behind the floating navigation bar
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<FishingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _screens[_selectedIndex];
        },
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: NavigationBar(
            height: 70,
            elevation: 0,
            backgroundColor: Colors.white,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            // Material 3 indicator (the pill background) styling
            indicatorColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_rounded, size: 28),
                selectedIcon: Icon(Icons.dashboard_rounded, size: 28, color: Color(0xFF2E7D32)),
                label: 'Főoldal',
              ),
              NavigationDestination(
                icon: Icon(Icons.auto_stories_rounded, size: 28),
                selectedIcon: Icon(Icons.auto_stories_rounded, size: 28, color: Color(0xFF2E7D32)),
                label: 'Napló',
              ),
              NavigationDestination(
                icon: Icon(Icons.location_on_rounded, size: 28),
                selectedIcon: Icon(Icons.location_on_rounded, size: 28, color: Color(0xFF2E7D32)),
                label: 'Helyek',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildFab() {
    if (_selectedIndex == 0) return null;

    return Padding(
      // Push FAB higher so it doesn't overlap with the floating bottom bar
      padding: const EdgeInsets.only(bottom: 100.0),
      child: FloatingActionButton.large(
        onPressed: () {
          if (_selectedIndex == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCatchScreen()));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFishingSpotScreen()));
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: Icon(_selectedIndex == 1 ? Icons.add : Icons.add_location, size: 40),
      ),
    );
  }
}
