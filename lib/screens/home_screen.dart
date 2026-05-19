import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import '../services/app_selection_service.dart';
import '../services/accessibility_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AppInfo> installedApps = [];
  final Set<String> selectedApps = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadApps();
  }

  Future<void> loadApps() async {
    // 1. Busca os apps instalados
    List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);

    // Busca os apps que já foram salvos anteriormente para persistir o estado na tela
    try {
      List<String> savedApps = await AppSelectionService.getSelectedApps();
      selectedApps.addAll(savedApps);
    } catch (e) {
      debugPrint("Erro ao carregar apps salvos: $e");
    }

    // Ordena os apps por nome
    apps.sort(
      (a, b) => (a.name ?? "").toLowerCase().compareTo((b.name ?? "").toLowerCase()),
    );

    if (mounted) {
      setState(() {
        installedApps = apps;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "MindPause",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            )
          : Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER / VISÃO GERAL
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.green),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.local_fire_department, color: Colors.green, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    "7 dias",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          "Visão Geral",
                          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Seu impacto hoje",
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // BOTÃO DE ATIVAÇÃO
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      AccessibilityService.openAccessibilitySettings();
                    },
                    child: const Text("Ativar Monitoramento", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  
                  const SizedBox(height: 16),

                  // CARDS DE ESTATÍSTICAS
                  Row(
                    children: [
                      Expanded(
                        child: buildStatCard(
                          title: "IMPULSOS",
                          value: "45x",
                          subtitle: "impedidos hoje",
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: buildStatCard(
                          title: "TEMPO LIVRE",
                          value: "2,3h",
                          subtitle: "economizadas",
                          color: Colors.purpleAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // SEÇÃO DE APPS MONITORADOS
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Apps Monitorados",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Escolha quais apps terão a intervenção.",
                            style: TextStyle(color: Colors.white54),
                          ),
                          const SizedBox(height: 18),
                          Expanded(
                            child: ListView.builder(
                              itemCount: installedApps.length,
                              itemBuilder: (context, index) {
                                final app = installedApps[index];
                                final String pkgName = app.packageName ?? "";
                                final bool isSelected = selectedApps.contains(pkgName);

                                return GestureDetector(
                                  // CORREÇÃO AQUI: O clique agora é instantâneo e salva em background de forma assíncrona segura
                                  onTap: () {
                                    if (pkgName.isEmpty) return;

                                    setState(() {
                                      if (isSelected) {
                                        selectedApps.remove(pkgName);
                                      } else {
                                        selectedApps.add(pkgName);
                                      }
                                    });

                                    // Salva no SharedPreferences sem travar a renderização do check na tela
                                    AppSelectionService.saveSelectedApps(selectedApps.toList()).catchError((e) {
                                      debugPrint("Erro ao salvar lista de apps: $e");
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(bottom: 14),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.greenAccent.withOpacity(0.08)
                                          : const Color(0xFF181818),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected ? Colors.greenAccent : Colors.white.withOpacity(0.05),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: app.icon != null
                                              ? Image.memory(app.icon!, width: 42, height: 42)
                                              : Container(
                                                  width: 42,
                                                  height: 42,
                                                  color: Colors.white10,
                                                  child: const Icon(Icons.android, color: Colors.white54),
                                                ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                app.name ?? "App",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                pkgName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(color: Colors.white38, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                                          color: isSelected ? Colors.greenAccent : Colors.white24,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white38,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}