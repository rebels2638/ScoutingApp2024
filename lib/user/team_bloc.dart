import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

// there is hella boilerplate written here
sealed class ScoutingSessionStates extends Equatable {
  @override
  List<dynamic> get props => <dynamic>[];
}

sealed class ScoutingSessionEvents {}

sealed class ScoutingInfo {
  Map<String, dynamic> exportMap();
}

class MiscInfo extends ScoutingInfo {
  bool coopertition;
  bool breakdown;

  MiscInfo({required this.coopertition, required this.breakdown});

  factory MiscInfo.optional(
          {bool coopertition = false, bool breakdown = false}) =>
      MiscInfo(coopertition: coopertition, breakdown: breakdown);

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "coopertition": coopertition,
        "breakdown": breakdown
      };
}

class MiscUpdateEvent extends ScoutingSessionEvents {}

class MiscState extends ScoutingSessionStates {
  final MiscInfo data;
  MiscState(this.data);
}

class EndgameInfo extends ScoutingInfo {
  bool onChain;
  Harmony harmony;
  TrapScored trapScored;
  MicScored micScored;
  String? comments;

  EndgameInfo(
      {required this.onChain,
      required this.harmony,
      required this.trapScored,
      required this.micScored,
      this.comments = ""});

  factory EndgameInfo.optional(
          {bool onChain = false,
          Harmony harmony = Harmony.no,
          TrapScored trapScored = TrapScored.no,
          MicScored micScored = MicScored.no,
          String comments = ""}) =>
      EndgameInfo(
          onChain: onChain,
          harmony: harmony,
          trapScored: trapScored,
          micScored: micScored,
          comments: comments);

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "onChain": onChain,
        "harmony": harmony,
        "trapScored": trapScored,
        "micScored": micScored,
        "comments": comments
      };
}

class EndgameUpdateEvent extends ScoutingSessionEvents {}

class EndgameState extends ScoutingSessionStates {
  final EndgameInfo data;
  EndgameState(this.data);
}

class TeleOpInfo extends ScoutingInfo {
  bool playsDefense;
  bool wasDefended;
  int scoredSpeaker;
  int missedSpeaker;
  int scoredAmp;
  int missedAmp;

  int scoredWhileAmped; // such a goofy name
  String? comments;
  int driverRating;

  TeleOpInfo(
      {required this.playsDefense,
      required this.wasDefended,
      required this.scoredSpeaker,
      required this.missedSpeaker,
      required this.scoredAmp,
      required this.missedAmp,
      required this.scoredWhileAmped,
      this.comments = "",
      required this.driverRating});

  factory TeleOpInfo.optional(
          {bool playsDefense = false,
          bool wasDefended = false,
          int scoredSpeaker = 0,
          int missedSpeaker = 0,
          int scoredAmp = 0,
          int missedAmp = 0,
          int scoredWhileAmped = 0,
          String comments = "",
          int driverRating = 0}) =>
      TeleOpInfo(
          playsDefense: playsDefense,
          wasDefended: wasDefended,
          scoredSpeaker: scoredSpeaker,
          missedSpeaker: missedSpeaker,
          scoredAmp: scoredAmp,
          missedAmp: missedAmp,
          scoredWhileAmped: scoredWhileAmped,
          comments: comments,
          driverRating: driverRating);

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "playsDefense": playsDefense,
        "wasDefended": wasDefended,
        "scoredSpeaker": scoredSpeaker,
        "missedSpeaker": missedSpeaker,
        "scoredAmp": scoredAmp,
        "missedAmp": missedAmp,
        "scoredWhileAmped": scoredWhileAmped,
        "comments": comments,
        "driverRating": driverRating
      };
}

class TeleOpUpdateEvent extends ScoutingSessionEvents {}

class TeleOpState extends ScoutingSessionStates {
  final TeleOpInfo data;
  TeleOpState(this.data);
}

class AutoInfo extends ScoutingInfo {
  bool notePreloaded;
  List<AutoPickup> notesPickedUp;
  bool taxi;
  int scoredSpeaker;
  int missedSpeaker;
  int scoredAmp;
  int missedAmp;
  String? comments;

  AutoInfo(
      {required this.notePreloaded,
      required this.notesPickedUp,
      required this.taxi,
      required this.scoredSpeaker,
      required this.missedSpeaker,
      required this.scoredAmp,
      required this.missedAmp,
      this.comments = ""});

  factory AutoInfo.optional(
          {bool notePreloaded = false,
          List<AutoPickup> notesPickedUp = const <AutoPickup>[],
          bool taxi = false,
          int scoredSpeaker = 0,
          int missedSpeaker = 0,
          int scoredAmp = 0,
          int missedAmp = 0,
          String comments = ""}) =>
      AutoInfo(
          notePreloaded: notePreloaded,
          notesPickedUp: notesPickedUp,
          taxi: taxi,
          scoredSpeaker: scoredSpeaker,
          missedSpeaker: missedSpeaker,
          scoredAmp: scoredAmp,
          missedAmp: missedAmp,
          comments: comments);

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "notePreloaded": notePreloaded,
        "notesPickedUp": notesPickedUp,
        "taxi": taxi,
        "scoredSpeaker": scoredSpeaker,
        "missedSpeaker": missedSpeaker,
        "scoredAmp": scoredAmp,
        "missedAmp": missedAmp,
        "comments": comments
      };
}

class AutoUpdateEvent extends ScoutingSessionEvents {}

class AutoState extends ScoutingSessionStates {
  final AutoInfo data;
  AutoState(this.data);
}

class PrelimInfo extends ScoutingInfo {
  int timeStamp; // this is in ms since epoch
  String scouters;
  int teamNumber;
  int matchNumber;
  MatchType matchType;
  TeamAlliance alliance;
  MatchStartingPosition startingPosition;

  PrelimInfo(
      {required this.timeStamp,
      required this.scouters,
      required this.teamNumber,
      required this.matchNumber,
      required this.matchType,
      required this.alliance,
      required this.startingPosition});

  factory PrelimInfo.optional(
          {int timeStamp = 0,
          String scouters = "",
          int teamNumber = 0,
          int matchNumber = 0,
          MatchType matchType = MatchType.qualification,
          TeamAlliance alliance = TeamAlliance.red,
          MatchStartingPosition startingPosition =
              MatchStartingPosition.left}) =>
      PrelimInfo(
          timeStamp: timeStamp,
          scouters: scouters,
          teamNumber: teamNumber,
          matchNumber: matchNumber,
          matchType: matchType,
          alliance: alliance,
          startingPosition: startingPosition);

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "timeStamp": timeStamp,
        "scouters": scouters,
        "teamNumber": teamNumber,
        "matchNumber": matchNumber,
        "matchType": matchType,
        "alliance": alliance,
        "startingPosition": startingPosition
      };
}

class PrelimUpdateEvent extends ScoutingSessionEvents {}

class PrelimState extends ScoutingSessionStates {
  final PrelimInfo data;
  PrelimState(this.data);
}

/// represents the intermediate representation of the data between
class ScoutingSessionBloc
    extends Bloc<ScoutingSessionEvents, ScoutingSessionStates> {
  PrelimInfo prelim;
  AutoInfo auto;
  TeleOpInfo teleop;
  EndgameInfo endgame;
  MiscInfo misc;

  ScoutingSessionBloc()
      : prelim = PrelimInfo.optional(),
        auto = AutoInfo.optional(),
        teleop = TeleOpInfo.optional(),
        endgame = EndgameInfo.optional(),
        misc = MiscInfo.optional(),
        super(PrelimState(PrelimInfo.optional())) {
    on<PrelimUpdateEvent>((PrelimUpdateEvent event,
        Emitter<ScoutingSessionStates> emit) {
      prelim = PrelimInfo.optional();
      emit(PrelimState(prelim));
    });
    on<AutoUpdateEvent>(
        (AutoUpdateEvent event, Emitter<ScoutingSessionStates> emit) {
      auto = AutoInfo.optional();
      emit(AutoState(auto));
    });
    on<MiscUpdateEvent>(
        (MiscUpdateEvent event, Emitter<ScoutingSessionStates> emit) {
      misc = MiscInfo.optional();
      emit(MiscState(misc));
    });
    on<TeleOpUpdateEvent>((TeleOpUpdateEvent event,
        Emitter<ScoutingSessionStates> emit) {
      teleop = TeleOpInfo.optional();
      emit(TeleOpState(teleop));
    });
    on<EndgameUpdateEvent>((EndgameUpdateEvent event,
        Emitter<ScoutingSessionStates> emit) {
      endgame = EndgameInfo.optional();
      emit(EndgameState(endgame));
    });
  }

  ({
    PrelimInfo prelim,
    AutoInfo auto,
    TeleOpInfo teleop,
    EndgameInfo endgame,
    MiscInfo misc
  }) export() => (
        prelim: prelim,
        auto: auto,
        teleop: teleop,
        endgame: endgame,
        misc: misc
      );

  Map<String, dynamic> exportMapDeep() => <String, dynamic>{
        "prelim": prelim.exportMap(),
        "auto": auto.exportMap(),
        "teleop": teleop.exportMap(),
        "endgame": endgame.exportMap(),
        "misc": misc.exportMap()
      };

  Map<String, dynamic> exportMap() => <String, dynamic>{
        "prelim": prelim,
        "auto": auto,
        "teleop": teleop,
        "endgame": endgame,
        "misc": misc
      };
}
