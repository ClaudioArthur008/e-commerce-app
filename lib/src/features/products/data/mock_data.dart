import 'package:e_commerce_app/src/features/products/domain/product_model.dart';

final List<Category> mockCategories = const [
  Category(
    id: '2',
    name: 'Alimentaire & Produit Frais',
    imageUrl: 'https://via.placeholder.com/100',
  ),
  Category(
    id: '3',
    name: 'Boulangerie & Pâtisserie',
    imageUrl: 'https://via.placeholder.com/100',
  ),
  Category(
    id: '4',
    name: 'Epicerie & Produits Secs',
    imageUrl: 'https://via.placeholder.com/100',
  ),
  Category(
    id: '5',
    name: 'Hygiène & Entretien',
    imageUrl: 'https://via.placeholder.com/100',
  ),
  Category(
    id: '6',
    name: 'Bazar & Accessoires',
    imageUrl: 'https://via.placeholder.com/100',
  ),
];

final List<Product> mockProducts = const [
  // Alimentaire & Produit Frais
  Product(
    id: '201',
    name: 'Jus d\'Orange Frais',
    description: 'Jus d\'orange pressé 100% naturel',
    price: 4.50,
    stock: 30,
    imageUrl: 'assets/images/orange.jpg',
    category: 'Alimentaire & Produit Frais',
  ),
  Product(
    id: '202',
    name: 'Panier de Tomates',
    description: 'Tomates fraîches sélectionnées du jour',
    price: 2.80,
    stock: 40,
    imageUrl: 'assets/images/tomatoes.jpg',
    category: 'Alimentaire & Produit Frais',
  ),

  // Boulangerie & Pâtisserie
  Product(
    id: '301',
    name: 'Chocolate Donut',
    description: 'Donut au chocolat glacé',
    price: 3.20,
    stock: 20,
    imageUrl: 'https://via.placeholder.com/200',
    category: 'Boulangerie & Pâtisserie',
  ),
  Product(
    id: '302',
    name: 'Baguette Tradition',
    description: 'Baguette de pain cuite au feu de bois',
    price: 1.50,
    stock: 50,
    imageUrl: 'assets/images/baguette.jpg',
    category: 'Boulangerie & Pâtisserie',
  ),

  // Epicerie & Produits Secs
  Product(
    id: '401',
    name: 'Pâtes Spaghetti',
    description: 'Paquet de pâtes spaghetti 500g',
    price: 1.90,
    stock: 60,
    imageUrl: 'https://via.placeholder.com/200',
    category: 'Epicerie & Produits Secs',
  ),
  Product(
    id: '402',
    name: 'Riz Basmati 1kg',
    description: 'Riz basmati parfumé, sachet de 1kg',
    price: 3.10,
    stock: 45,
    imageUrl: 'https://via.placeholder.com/200',
    category: 'Epicerie & Produits Secs',
  ),

  // Hygiène & Entretien
  Product(
    id: '501',
    name: 'Liquide Vaisselle',
    description: 'Flacon 500ml, parfum citron',
    price: 2.20,
    stock: 35,
    imageUrl: 'assets/images/vaisselle.jpg',
    category: 'Hygiène & Entretien',
  ),
  Product(
    id: '502',
    name: 'Gel Douche',
    description: 'Gel douche hydratant 250ml',
    price: 3.75,
    stock: 28,
    imageUrl: 'assets/images/gel.jpg',
    category: 'Hygiène & Entretien',
  ),

  // Bazar & Accessoires
  Product(
    id: '601',
    name: 'Éponges de Cuisine (x5)',
    description: 'Lot de 5 éponges multi-usage',
    price: 1.60,
    stock: 70,
    imageUrl: 'https://via.placeholder.com/200',
    category: 'Bazar & Accessoires',
  ),
  Product(
    id: '602',
    name: 'Sac de Rangement',
    description: 'Sac de rangement réutilisable, grande capacité',
    price: 5.90,
    stock: 18,
    imageUrl: 'https://via.placeholder.com/200',
    category: 'Bazar & Accessoires',
  ),
];
