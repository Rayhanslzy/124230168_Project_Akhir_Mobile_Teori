import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/merch_item_model.dart';
import '../repositories/merch_repository.dart';

// --- EVENTS ---
abstract class MerchEvent extends Equatable {
  const MerchEvent();
  @override
  List<Object> get props => [];
}

class LoadMerchList extends MerchEvent {}

class AddMerchItem extends MerchEvent {
  final String itemName;
  final double priceInJpy;
  final String targetCurrency;

  const AddMerchItem({
    required this.itemName,
    required this.priceInJpy,
    required this.targetCurrency,
  });

  @override
  List<Object> get props => [itemName, priceInJpy, targetCurrency];
}

class DeleteMerchItem extends MerchEvent {
  final String id;
  const DeleteMerchItem(this.id);
  @override
  List<Object> get props => [id];
}

// --- STATES ---
abstract class MerchState extends Equatable {
  const MerchState();
  @override
  List<Object> get props => [];
}

class MerchLoading extends MerchState {}

class MerchLoaded extends MerchState {
  final List<MerchItemModel> items;
  final double totalEstimateIdr; 

  const MerchLoaded({required this.items, this.totalEstimateIdr = 0});
  @override
  List<Object> get props => [items, totalEstimateIdr];
}

class MerchError extends MerchState {
  final String message;
  const MerchError(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLOC ---
class MerchBloc extends Bloc<MerchEvent, MerchState> {
  final MerchRepository merchRepository;

  // Kurs Manual (Estimasi per 1 JPY)
  final Map<String, double> exchangeRates = {
    'IDR': 105.0,    
    'USD': 0.0067,   
    'EUR': 0.0062,   
    'GBP': 0.0053,   
    'KRW': 9.0,      
  };

  MerchBloc({required this.merchRepository}) : super(MerchLoading()) {
    
    on<LoadMerchList>((event, emit) {
      _loadData(emit);
    });

    on<AddMerchItem>((event, emit) async {
      try {
        final rate = exchangeRates[event.targetCurrency] ?? 0.0;
        final converted = event.priceInJpy * rate;

        final newItem = MerchItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          itemName: event.itemName,
          priceInJpy: event.priceInJpy,
          targetCurrency: event.targetCurrency,
          convertedPrice: converted,
          dateAdded: DateTime.now(),
        );

        await merchRepository.addItem(newItem);
        _loadData(emit);
      } catch (e) {
        emit(MerchError("Gagal menyimpan data: $e"));
      }
    });

    on<DeleteMerchItem>((event, emit) async {
      await merchRepository.deleteItem(event.id);
      _loadData(emit);
    });
  }

  void _loadData(Emitter<MerchState> emit) {
    try {
      final list = merchRepository.getAllItems();
      
      // Hitung total estimasi ke IDR
      double totalIdr = 0;
      for (var item in list) {
        if (item.targetCurrency == 'IDR') {
          totalIdr += item.convertedPrice;
        } else {
           double toYen = item.convertedPrice / (exchangeRates[item.targetCurrency] ?? 1);
           totalIdr += toYen * (exchangeRates['IDR'] ?? 105);
        }
      }

      emit(MerchLoaded(items: list, totalEstimateIdr: totalIdr));
    } catch (e) {
      emit(MerchError("Gagal memuat data."));
    }
  }
}