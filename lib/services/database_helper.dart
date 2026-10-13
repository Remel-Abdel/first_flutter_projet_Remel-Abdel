import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gestion_commandes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Departement (
        idDep INTEGER PRIMARY KEY AUTOINCREMENT,
        nomDep TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Region (
        idRegion INTEGER PRIMARY KEY AUTOINCREMENT,
        nomRegion TEXT NOT NULL,
        idDep INTEGER,
        FOREIGN KEY (idDep) REFERENCES Departement (idDep)
      )
    ''');

    await db.execute('''
      CREATE TABLE Client (
        idCli INTEGER PRIMARY KEY AUTOINCREMENT,
        nomCli TEXT NOT NULL,
        prenomCli TEXT NOT NULL,
        email TEXT,
        photo TEXT,
        idRegion INTEGER,
        FOREIGN KEY (idRegion) REFERENCES Region (idRegion)
      )
    ''');

    await db.execute('''
      CREATE TABLE Produit (
        idProd INTEGER PRIMARY KEY AUTOINCREMENT,
        designProd TEXT NOT NULL,
        qteStock INTEGER NOT NULL,
        prixUProd REAL NOT NULL,
        photoProd TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Commande (
        idCmd INTEGER PRIMARY KEY AUTOINCREMENT,
        dateCmd TEXT NOT NULL,
        idCli INTEGER,
        FOREIGN KEY (idCli) REFERENCES Client (idCli)
      )
    ''');

    await db.execute('''
      CREATE TABLE LigneCommande (
        idCmd INTEGER,
        idProd INTEGER,
        qteCmd INTEGER NOT NULL,
        PRIMARY KEY (idCmd, idProd),
        FOREIGN KEY (idCmd) REFERENCES Commande (idCmd) ON DELETE CASCADE,
        FOREIGN KEY (idProd) REFERENCES Produit (idProd)
      )
    ''');

    await db.rawInsert('''
      INSERT INTO Departement (nomDep) VALUES ('Informatique')
    ''');
    await db.rawInsert('''
      INSERT INTO Region (nomRegion, idDep) VALUES ('Centre', 1)
    ''');
    await db.rawInsert('''
      INSERT INTO Client (nomCli, prenomCli, email, idRegion) 
      VALUES ('Mound', 'MasT', 'MasTMound2@univ.com', 1)
    ''');
    
    await db.insert('Produit', {'designProd': 'Ordinateur HP', 'qteStock': 15, 'prixUProd': 450000.0});
    await db.insert('Produit', {'designProd': 'Souris Sans Fil', 'qteStock': 50, 'prixUProd': 12000.0});
    await db.insert('Produit', {'designProd': 'Écran Pro 24"', 'qteStock': 8, 'prixUProd': 95000.0});
  }
}
