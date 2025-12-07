import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../logic/merch_bloc.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCurrency = 'IDR';

  // Format Duit (Rp 10.000)
  final currencyFormat = NumberFormat("#,##0", "id_ID");

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final priceJpy = double.tryParse(_priceController.text) ?? 0;

      context.read<MerchBloc>().add(AddMerchItem(
        itemName: name,
        priceInJpy: priceJpy,
        targetCurrency: _selectedCurrency,
      ));

      _nameController.clear();
      _priceController.clear();
      FocusScope.of(context).unfocus(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wibu Shopping Calculator 💴")),
      body: Column(
        children: [
          // INPUT FORM
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Nama Barang (ex: Figure Rem)",
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.grey[800],
                    ),
                    validator: (v) => v!.isEmpty ? "Isi dulu bang" : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Harga (Yen / ¥)",
                            labelStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: Colors.grey[800],
                            prefixText: "¥ ",
                          ),
                          validator: (v) => v!.isEmpty ? "Wajib isi" : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCurrency,
                              dropdownColor: Colors.grey[900],
                              isExpanded: true,
                              style: const TextStyle(color: Colors.white),
                              items: ['IDR', 'USD', 'EUR', 'GBP', 'KRW']
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedCurrency = v!),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.calculate, color: Colors.white),
                      label: const Text("Hitung & Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.white24),
          
          // LIST RESULT
          Expanded(
            child: BlocBuilder<MerchBloc, MerchState>(
              builder: (context, state) {
                if (state is MerchLoading) return const Center(child: CircularProgressIndicator());
                
                if (state is MerchLoaded) {
                  if (state.items.isEmpty) {
                    return const Center(child: Text("Belum ada barang inceran nih.\nYuk tambah!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    separatorBuilder: (_,__) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Card(
                        color: const Color(0xFF1F2937),
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent.withOpacity(0.2),
                            child: Text(item.targetCurrency, style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(item.itemName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            "¥${currencyFormat.format(item.priceInJpy)}", 
                            style: const TextStyle(color: Colors.grey)
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${item.targetCurrency} ${currencyFormat.format(item.convertedPrice)}",
                                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: () => context.read<MerchBloc>().add(DeleteMerchItem(item.id)),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text("Hapus", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}