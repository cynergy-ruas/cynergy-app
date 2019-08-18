import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

////////////////////////////////////////////
// Defining the events
////////////////////////////////////////////

// The base class
abstract class DataLoadEvent extends Equatable {
  DataLoadEvent([List props = const []]) : super(props);
}

// The event emitted when data loading is initiated
class BeginDataLoad extends DataLoadEvent {
  @override
  String toString() => "BeginDataLoad";
}

////////////////////////////////////////////
// Defining the states
////////////////////////////////////////////

// The base class
abstract class DataLoadState extends Equatable {
  final data;
  DataLoadState({@required this.data});
}

// The state when the data loading is uninitialized
class DataLoadUnintialized extends DataLoadState {
  String toString() => "DataLoadUninitialized";
  DataLoadUnintialized() : super(data: null);
}

// The state when data loading is ongoing
class DataLoadOnGoing extends DataLoadState {
  String toString() => "DataLoadOnGoing";
  DataLoadOnGoing() : super(data: null);
}

// The state when data loading is complete
class DataLoadComplete extends DataLoadState {
  DataLoadComplete({@required data}) : super(data: data);

  String toString() => "DataLoadComplete";
}

////////////////////////////////////////////
// Defining the Bloc. Logic goes here
////////////////////////////////////////////

class DataLoadBloc extends Bloc<DataLoadEvent, DataLoadState>{
  
  final handler;
  
  @override
  DataLoadState get initialState => DataLoadUnintialized();

  DataLoadBloc({@required this.handler});


  @override
  Stream<DataLoadState> mapEventToState(DataLoadState currentState, DataLoadEvent event) async*{
    /**
     * Maps [DataLoadEvent]s to [DataLoadState]s,
     * 
     * Args:
     *  currentState (DataLoadState): The current state.
     *  event (DataLoadEvent): The event generated from code.
     * 
     * Yields:
     *  DataLoadState: The state to change to in response to events.
     */

    if (event is BeginDataLoad) {
      yield DataLoadOnGoing();
      var data = await handler.loadData();
      yield DataLoadComplete(data: data);
    }
  }
  
}
