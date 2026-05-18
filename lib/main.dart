import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // Magyar dátumokhoz
import 'screens/dashboard_screen.dart';
import 'screens/catches_log_screen.dart';
import 'screens/fishing_spots_screen.dart';
import 'screens/extra_menu_screen.dart';
import 'providers/fishing_provider.dart';
import 'screens/add_catch_screen.dart';
import 'screens/add_fishing_spot_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Magyar nyelvű dátumformázás inicializálása
  await initializeDateFormatting('hu_HU', null);
  
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
      title: 'Kapásjelző',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFFFF9100),
          surface: Colors.white,
          onPrimary: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 20, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
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
    const ExtraMenuScreen(),
  ];

  final List<String> _titles = ['Főoldal', 'Fogási Napló', 'Horgászhelyek', 'Extra Funkciók'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
      ),
      body: Consumer<FishingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          return _screens[_selectedIndex];
        },
      ),
      bottomNavigationBar: _buildModernNavbar(),
    );
  }

  Widget _buildModernNavbar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 25),
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navbarItem(0, Icons.dashboard_rounded, 'Főoldal'),
          _navbarItem(1, Icons.auto_stories_rounded, 'Napló'),
          _buildCenterAddButton(),
          _navbarItem(2, Icons.location_on_rounded, 'Helyek'),
          _navbarItem(3, Icons.more_horiz_rounded, 'Extra'),
        ],
      ),
    );
  }

  Widget _navbarItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor.withValues(alpha: 0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
                icon,
                color: isSelected ? primaryColor : Colors.grey[500],
                size: 28
            ),
          ),
          const SizedBox(height: 4),
          Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? primaryColor : Colors.grey[500]
              )
          ),
        ],
      ),
    );
  }

  Widget _buildCenterAddButton() {
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTap: () {
        if (_selectedIndex == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFishingSpotScreen()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCatchScreen()));
        }
      },
      child: Container(
        height: 65,
        width: 65,
        transform: Matrix4.translationValues(0, -5, 0),
        decoration: BoxDecoration(
          color: secondaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: secondaryColor.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
}
