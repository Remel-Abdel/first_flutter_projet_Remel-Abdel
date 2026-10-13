import 'package:flutter/material.dart';

import '../services/database_helper.dart';

import 'package:sqflite/sqflite.dart'; // <--- AJOUTEZ CETTE LIGNE ICI

class CommandeDetailView extends StatefulWidget {
  final int idCmd;
  const CommandeDetailView({super.key, required this.idCmd});

  @override
  State<CommandeDetailView> createState() => _CommandeDetailViewState();
}

class _CommandeDetailViewState extends State<CommandeDetailView> {
  List<Map<String, dynamic>> _lignes = [];
  List<Map<String, dynamic>> _produitsDispo = [];
  int? _selectedProdId;
  final _qteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final db = await DatabaseHelper.instance.database;

    final lignesData = await db.rawQuery(
      '''
      SELECT LigneCommande.*, Produit.designProd, Produit.prixUProd 
      FROM LigneCommande 
      JOIN Produit ON LigneCommande.idProd = Produit.idProd
      WHERE LigneCommande.idCmd = ?
    ''',
      [widget.idCmd],
    );

    final prodsData = await db.query('Produit');

    setState(() {
      _lignes = lignesData;
      _produitsDispo = prodsData;
    });
  }

  void _ajouterProduit() async {
    if (_selectedProdId == null || _qteController.text.isEmpty) return;
    final db = await DatabaseHelper.instance.database;

    await db.insert('LigneCommande', {
      'idCmd': widget.idCmd,
      'idProd': _selectedProdId,
      'qteCmd': int.parse(_qteController.text),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    _qteController.clear();
    _refreshData();
  }

  void _modifierQuantite(int idProd, int nouvelleQte) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'LigneCommande',
      {'qteCmd': nouvelleQte},
      where: 'idCmd = ? AND idProd = ?',
      whereArgs: [widget.idCmd, idProd],
    );
    _refreshData();
  }

  void _supprimerProduit(int idProd) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'LigneCommande',
      where: 'idCmd = ? AND idProd = ?',
      whereArgs: [widget.idCmd, idProd],
    );
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails Commande N° ${widget.idCmd}"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enregistrer un produit pour cette commande (Q1)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<int>(
                    value: _selectedProdId,
                    hint: const Text("Sélectionner un produit"),
                    isExpanded: true,
                    items: _produitsDispo.map((p) {
                      return DropdownMenuItem<int>(
                        value: p['idProd'],
                        child: Text(
                          "${p['designProd']} (${p['prixUProd']} FCFA)",
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedProdId = val),
                  ),
                  TextField(
                    controller: _qteController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantité à commander",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _ajouterProduit,
                    child: const Text("Enregistrer la ligne"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _lignes.isEmpty
                ? const Center(
                    child: Text("Aucun produit dans cette commande."),
                  )
                : ListView.builder(
                    itemCount: _lignes.length,
                    itemBuilder: (ctx, i) {
                      final ligne = _lignes[i];
                      return ListTile(
                        title: Text("${ligne['designProd']}"),
                        subtitle: Text(
                          "Quantité : ${ligne['qteCmd']} | Total : ${ligne['qteCmd'] * ligne['prixUProd']} FCFA",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditDialog(
                                ligne['idProd'],
                                ligne['qteCmd'],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _supprimerProduit(ligne['idProd']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int idProd, int qteActuelle) {
    final edtCtrl = TextEditingController(text: qteActuelle.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Modifier la quantité (Q3)"),
        content: TextField(
          controller: edtCtrl,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              _modifierQuantite(idProd, int.parse(edtCtrl.text));
              Navigator.pop(ctx);
            },
            child: const Text("Valider"),
          ),
        ],
      ),
    );
  }
}
