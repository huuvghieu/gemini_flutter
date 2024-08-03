part of 'genai_bloc.dart';

sealed class GenaiState extends Equatable {
  const GenaiState();
}

final class GenaiInitial extends GenaiState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class MessageUpdate extends GenaiState{
  List<ChatContent> contents;

  MessageUpdate(this.contents);

  @override
  List<Object?> get props => [...contents, contents.length];
}