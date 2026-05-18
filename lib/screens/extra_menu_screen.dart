import 'package:flutter/material.dart';
import 'bait_recipes_screen.dart';
import 'yearly_summary_screen.dart';
import 'tournament_screen.dart';
import 'personal_bests_screen.dart';
import 'fish_rules_screen.dart';
import 'settings_screen.dart';

class ExtraMenuScreen extends StatelessWidget {
  const ExtraMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
      children: [
        _buildMenuCard(
          context,
          icon: Icons.emoji_events_rounded,
          title: 'Versenyszoba',
          subtitle: 'Élő versenyek és ranglista',
          color: Colors.orange.shade700,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TournamentScreen())),
        ),
        const SizedBox(height: 20),
        _buildMenuCard(
          context,
          icon: Icons.gavel_rounded,
          title: 'Horgászrend',
          subtitle: 'Tilalmi idők és méretkorlátok',
          color: Colors.red.shade700,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FishRulesScreen())),
        ),
        const SizedBox(height: 20),
        _buildMenuCard(
          context,
          icon: Icons.workspace_premium_rounded,
          title: 'Trófeaszoba',
          subtitle: 'Egyéni legjobb fogások (PB)',
          color: Colors.green.shade700,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalBestsScreen())),
        ),
        const SizedBox(height: 20),
        _buildMenuCard(
          context,
          icon: Icons.assignment_turned_in_rounded,
          title: 'Állami Fogásnapló',
          subtitle: 'Év végi összesítés leadáshoz',
          color: Colors.blue.shade700,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const YearlySummaryScreen())),
        ),
        const SizedBox(height: 20),
        _buildMenuCard(
          context,
          icon: Icons.inventory_2_rounded,
          title: 'Szerelékesláda',
          subtitle: 'Saját csalireceptek kezelése',
          color: Colors.brown.shade600,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BaitRecipesScreen())),
        ),
        const SizedBox(height: 20),
        _buildMenuCard(
          context,
          icon: Icons.person_rounded,
          title: 'Profil beállítások',
          subtitle: 'Név és alkalmazás adatok',
          color: Colors.grey.shade700,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
        ),
      ],
    );
  }

  Widget _buildMenuCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
