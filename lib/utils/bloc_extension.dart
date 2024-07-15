// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocSafety<Event, State> on Bloc<Event, State>{
  void emitSafety(State state){
    if(!isClosed){
      emit(state);
    }
  }
}

extension CubitSafety<State> on Cubit<State>{
  void emitSafety(Emitter<State> emit){
    if(!isClosed){
      emit(state);
    }
  }
}