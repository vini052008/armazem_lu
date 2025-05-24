import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'carrinho.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: const ArmazemApp(),
    ),
  );
}

class ArmazemApp extends StatelessWidget {
  const ArmazemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Armazém Digital da Lourdes',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> baskets = const [
    {
      'label': 'Essencial',
      'image': 'assets/cesta1.jpeg',
      'items': ['Cenoura', 'Batata', 'Tomate', 'Cebolinha', 'Chuchu'],
      'price': 29.99,
      'priceText': 'R\$ 29,99/un',
    },
    {
      'label': 'Saúde em Dia',
      'image': 'assets/cesta2.jpeg',
      'items': [
        'Rúcula',
        'Pepino',
        'Beterraba',
        'Batata Doce',
        'Couve',
        'Pimentão',
      ],
      'price': 29.99,
      'priceText': 'R\$ 29,99/un',
    },
    {
      'label': 'Cesta da Casa',
      'image': 'assets/cesta3.jpeg',
      'items': [
        'Tomate',
        'Alface',
        'Cenoura',
        'Abobrinha',
        'Mandioca',
        'Agrião',
      ],
      'price': 29.99,
      'priceText': 'R\$ 29,99/un',
    },
  ];

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Cenoura',
      'image': 'assets/carrot.png',
      'price': 4.99,
      'priceText': 'R\$ 4,99/kg',
    },
    {
      'name': 'Tomate',
      'image': 'assets/tomato.png',
      'price': 5.99,
      'priceText': 'R\$ 5,99/kg',
    },
    {
      'name': 'Alface',
      'image': 'assets/lettuce.png',
      'price': 2.50,
      'priceText': 'R\$ 2,50/unidade',
    },
    {
      'name': 'Batata',
      'image': 'assets/potato.png',
      'price': 3.50,
      'priceText': 'R\$ 3,50/kg',
    },
    {
      'name': 'Chuchu',
      'image': 'assets/chayote.png',
      'price': 2.80,
      'priceText': 'R\$ 2,80/kg',
    },
    {
      'name': 'Repolho',
      'image': 'assets/cabbage.png',
      'price': 3.20,
      'priceText': 'R\$ 3,20/unidade',
    },
    {
      'name': 'Mandioca',
      'image': 'assets/cassava.png',
      'price': 4.00,
      'priceText': 'R\$ 4,00/kg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1D0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/topo1.jpeg'),
              const SizedBox(height: 10),
              Image.asset('assets/cesta.jpeg', height: 60),
              const Text('Loanda - PR', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Cestas Montadas:'),
              const SizedBox(height: 10),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: baskets.length,
                  itemBuilder: (context, index) {
                    final basket = baskets[index];
                    return BasketButton(
                      image: basket['image'],
                      label: basket['label'],
                      items: basket['items'],
                      price: basket['price'],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Produtos Disponíveis:'),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductItem(
                    name: product['name'],
                    image: product['image'],
                    price: product['price'],
                    priceText: product['priceText'],
                  );
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Ver Carrinho'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class BasketButton extends StatelessWidget {
  final String image;
  final String label;
  final List<String> items;
  final double price;

  const BasketButton({
    super.key,
    required this.image,
    required this.label,
    required this.items,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.brown.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector( 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BasketDetailPage(name: label, items: items),
                ),
              );
            },
            child: Column(
              children: [
                Image.asset(image, height: 60),
                const SizedBox(height: 5),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            "R\$ ${price.toStringAsFixed(2)}/un",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 70, 111, 51),
            ),
          ),
          const SizedBox(height: 4),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<CartModel>(
                context,
                listen: false,
              ).addItem(label, price);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cesta "$label" adicionada à sacola!'),
                  duration: const Duration(milliseconds: 500),
                  backgroundColor: const Color.fromARGB(255, 113, 160, 94),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart, size: 16),
            label: const Text("Adicionar", style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String name;
  final String image;
  final double price;
  final String priceText;

  const ProductItem({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.priceText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Image.asset(image, height: 40),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(priceText),
        trailing: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Provider.of<CartModel>(context, listen: false).addItem(name, price);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$name adicionado à sacola!'),
                duration: Duration(milliseconds: 500),
                backgroundColor: const Color.fromARGB(255, 113, 160, 94),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BasketDetailPage extends StatelessWidget {
  final String name;
  final List<String> items;
  const BasketDetailPage({super.key, required this.name, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Cesta: $name'),
        backgroundColor: const Color(0xFF795548),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange),
              ),
              child: Text(items[index], style: const TextStyle(fontSize: 18)),
            );
          },
        ),
      ),
    );
  }
}
