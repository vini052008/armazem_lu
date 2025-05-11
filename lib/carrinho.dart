import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CartModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem(String name, double price) {
    _items.add({'name': name, 'price': price});
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item['price'] ?? 0.0));
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _formaPagamento = 'Cartão'; // valor padrão

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sacola de Compras'),
        backgroundColor: const Color(0xFF795548),
      ),
      body:
          cart.items.isEmpty
              ? const Center(
                child: Text(
                  'Sua sacola está vazia!',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return ListTile(
                          title: Text(item['name']),
                          subtitle: Text(
                            item['price'] > 0
                                ? 'R\$ ${item['price'].toStringAsFixed(2)}'
                                : 'Cesta personalizada',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cart.removeItem(index);
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Forma de pagamento
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Forma de pagamento:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RadioListTile(
                          title: const Text('Cartão'),
                          value: 'Cartão',
                          groupValue: _formaPagamento,
                          onChanged: (value) {
                            setState(() {
                              _formaPagamento = value!;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('Pix'),
                          value: 'Pix',
                          groupValue: _formaPagamento,
                          onChanged: (value) {
                            setState(() {
                              _formaPagamento = value!;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('Dinheiro'),
                          value: 'Dinheiro',
                          groupValue: _formaPagamento,
                          onChanged: (value) {
                            setState(() {
                              _formaPagamento = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // Total e botões
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Total: R\$ ${cart.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            String mensagem =
                                'Olá! Gostaria de finalizar minha compra:\n\n';
                            for (var item in cart.items) {
                              mensagem +=
                                  '${item['name']} - R\$ ${item['price'].toStringAsFixed(2)}\n';
                            }
                            mensagem +=
                                '\nTotal da compra: R\$ ${cart.totalPrice.toStringAsFixed(2)}';
                            mensagem +=
                                '\nForma de pagamento: $_formaPagamento';
                            mensagem += '\n\nAQUI ESTÁ O MEU ENDEREÇO:';

                            final url = Uri.parse(
                              'https://wa.me/5543996878117?text=${Uri.encodeComponent(mensagem)}',
                            );

                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Não foi possível abrir o WhatsApp!',
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.message),
                          label: const Text('Finalizar no WhatsApp'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: cart.clearCart,
                          child: const Text('Esvaziar sacola'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
