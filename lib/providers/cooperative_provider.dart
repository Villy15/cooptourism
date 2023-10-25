import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cooperativeProvider = StateNotifierProvider<CooperativeProvider, CooperativesModel>((ref) {
  return CooperativeProvider(CooperativesModel());
});


class CooperativeProvider extends StateNotifier<CooperativesModel> {
  CooperativeProvider(super.state);

  void setCooperative (CooperativesModel cooperative ){
    state = cooperative;
  }
}