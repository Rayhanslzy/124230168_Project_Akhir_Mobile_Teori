// ---------------------------------------------------
// lib/screens/feedback_screen.dart
// ---------------------------------------------------

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _saranController = TextEditingController();
  final TextEditingController _kesanController = TextEditingController();
  
  bool _isLoading = false;
  final String _feedbackBoxName = 'feedbackBox';

  @override
  void dispose() {
    _saranController.dispose();
    _kesanController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Pastikan box terbuka
        final box = await Hive.openBox(_feedbackBoxName);

        // Simpan data
        final feedbackData = {
          'saran': _saranController.text,
          'kesan': _kesanController.text,
          'timestamp': DateTime.now().toString(),
        };

        await box.add(feedbackData);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terkirim! Masukan tersimpan ✨'), backgroundColor: Colors.green),
        );

        // Reset Form
        _saranController.clear();
        _kesanController.clear();

      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  // Format Tanggal biar enak dibaca
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saran & Kesan")),
      body: Column(
        children: [
          // --- BAGIAN INPUT FORM ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Kirim Masukan 🚀",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    
                    TextFormField(
                      controller: _kesanController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Kesan',
                        hintText: 'Aplikasi ini...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.favorite_border),
                      ),
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _saranController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Saran',
                        hintText: 'Fiturnya ditambah...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.lightbulb_outline),
                      ),
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Kirim & Simpan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(thickness: 4),

          // --- BAGIAN LIST RIWAYAT ---
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.black26,
            width: double.infinity,
            child: const Text("Riwayat Masukan (Database Hive)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),

          Expanded(
            child: FutureBuilder(
              future: Hive.openBox(_feedbackBoxName), // Buka box dulu
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // Setelah box terbuka, pasang pendengar (Listener)
                return ValueListenableBuilder(
                  valueListenable: Hive.box(_feedbackBoxName).listenable(),
                  builder: (context, Box box, _) {
                    if (box.isEmpty) {
                      return const Center(
                        child: Text("Belum ada data tersimpan.", style: TextStyle(color: Colors.grey)),
                      );
                    }

                    // Ambil data dan urutkan dari yang terbaru
                    final listData = box.values.toList().cast<Map>();
                    
                    // Variabel 'keys' SUDAH DIHAPUS agar tidak warning

                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: listData.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      // Pakai reversed index biar yang baru muncul di atas
                      itemBuilder: (context, index) {
                        final reversedIndex = listData.length - 1 - index;
                        final data = listData[reversedIndex];

                        return Card(
                          color: const Color(0xFF1F2937),
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent.withOpacity(0.2),
                              child: Text("${reversedIndex + 1}", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                            ),
                            title: Text(data['kesan'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text("Saran: ${data['saran']}", style: const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 6),
                                Text(
                                  _formatDate(data['timestamp']),
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}