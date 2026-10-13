import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/database_helper.dart';
import 'commande_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Map<String, dynamic>> _produits = [];
  List<Map<String, dynamic>> _commandes = [];
  List<Map<String, dynamic>> _clients = [];

  double _chiffreAffaireTotal = 0;
  List<PieChartSectionData> _chartSections = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAllData();
  }

  void _loadAllData() async {
    final db = await DatabaseHelper.instance.database;
    final prods = await db.query('Produit');
    final cmds = await db.rawQuery(
      'SELECT Commande.*, Client.nomCli FROM Commande JOIN Client ON Commande.idCli = Client.idCli',
    );
    final clis = await db.query('Client');

    final stats = await db.rawQuery('''
      SELECT Produit.designProd, SUM(LigneCommande.qteCmd * Produit.prixUProd) as totalVentes
      FROM LigneCommande
      JOIN Produit ON LigneCommande.idProd = Produit.idProd
      GROUP BY Produit.idProd
    ''');

    double ca = 0;
    List<PieChartSectionData> sections = [];
    int colorsCounter = 0;
    List<Color> palette = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];

    for (var row in stats) {
      final totalVentes = (row['totalVentes'] as num).toDouble();
      ca += totalVentes;

      sections.add(
        PieChartSectionData(
          value: totalVentes,
          title: '${row['designProd']}\n$totalVentes F',
          color: palette[colorsCounter % palette.length],
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorsCounter++;
    }

    setState(() {
      _produits = prods;
      _commandes = cmds;
      _clients = clis;
      _chiffreAffaireTotal = ca;
      _chartSections = sections;
    });
  }

  void _creerNouvelleCommande() async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('Commande', {
      'dateCmd': DateTime.now().toString().split(' ')[0],
      'idCli': 1,
    });
    _loadAllData();
  }

  void _ajouterNouveauProduit(String design, int qte, double prix) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('Produit', {
      'designProd': design,
      'qteStock': qte,
      'prixUProd': prix,
      'photoProd': '',
    });
    _loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard & Gestion de Lignes"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: "Statistiques (Q5)"),
            Tab(icon: Icon(Icons.shopping_bag), text: "Produits (Q2)"),
            Tab(icon: Icon(Icons.list_alt), text: "Commandes (Q2)"),
            Tab(icon: Icon(Icons.people), text: "Clients (Q2)"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  color: Colors.teal.shade700,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Performance financière : Total CA",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "$_chiffreAffaireTotal FCFA",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Répartition du chiffre d'affaires par produit",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _chartSections.isEmpty
                      ? const Center(
                          child: Text(
                            "Aucune donnée disponible. Enregistrez des produits dans vos commandes.",
                          ),
                        )
                      : PieChart(
                          PieChartData(
                            sections: _chartSections,
                            centerSpaceRadius: 40,
                          ),
                        ),
                ),
              ],
            ),
          ),
          Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: _showAddProductDialog,
              child: const Icon(Icons.add_shopping_cart, color: Colors.white),
            ),
            body: ListView.builder(
              itemCount: _produits.length,
              itemBuilder: (ctx, i) => ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.inventory_2, color: Colors.white),
                ),
                title: Text("${_produits[i]['designProd']}"),
                subtitle: Text("Stock : ${_produits[i]['qteStock']}"),
                trailing: Text(
                  "${_produits[i]['prixUProd']} F",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
          ),
          Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: _creerNouvelleCommande,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: ListView.builder(
              itemCount: _commandes.length,
              itemBuilder: (ctx, i) {
                final cmd = _commandes[i];
                return ListTile(
                  leading: const Icon(Icons.receipt, color: Colors.teal),
                  title: Text(
                    "Commande N° ${cmd['idCmd']} - Client: ${cmd['nomCli']}",
                  ),
                  subtitle: Text("Date : ${cmd['dateCmd']}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommandeDetailView(idCmd: cmd['idCmd']),
                      ),
                    ).then((_) => _loadAllData());
                  },
                );
              },
            ),
          ),
          ListView.builder(
            itemCount: _clients.length,
            itemBuilder: (ctx, i) => ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                "${_clients[i]['nomCli']} ${_clients[i]['prenomCli']}",
              ),
              subtitle: Text("Email : ${_clients[i]['email']}"),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    final designCtrl = TextEditingController();
    final qteCtrl = TextEditingController();
    final prixCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ajouter un nouveau produit"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: designCtrl,
                decoration: const InputDecoration(labelText: "Désignation"),
              ),
              TextField(
                controller: qteCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Quantité"),
              ),
              TextField(
                controller: prixCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Prix (FCFA)"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              if (designCtrl.text.isNotEmpty &&
                  qteCtrl.text.isNotEmpty &&
                  prixCtrl.text.isNotEmpty) {
                _ajouterNouveauProduit(
                  designCtrl.text,
                  int.parse(qteCtrl.text),
                  double.parse(prixCtrl.text),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }
}
