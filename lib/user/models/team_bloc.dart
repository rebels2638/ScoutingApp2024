import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:scouting_app_2024/blobs/qr_converter_blob.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';
import 'package:uuid/uuid.dart';

// there is hella boilerplate written here
sealed class ScoutingSessionStates extends Equatable {
  @override
  List<dynamic> get props => <dynamic>[];
}

sealed class ScoutingSessionEvents {}

sealed class ScoutingInfo {
  Map<String, dynamic> exportMap();
}

class MiscInfo extends ScoutingInfo
    implements QRCompatibleData<MiscInfo> {
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

  static MiscInfo fromCompatibleFormat(String csv) {
    final Map<String, dynamic> data =
        jsonDecode(csv) as Map<String, dynamic>;
    return MiscInfo(
        coopertition: data["coopertition"],
        breakdown: data["breakdown"]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "coopertition": coopertition,
      "breakdown": breakdown
    });
  }
}

class MiscUpdateEvent extends ScoutingSessionEvents {}

class MiscState extends ScoutingSessionStates {
  final MiscInfo data;
  MiscState(this.data);
}

class EndgameInfo extends ScoutingInfo
    implements QRCompatibleData<EndgameInfo> {
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

  static EndgameInfo fromCompatibleFormat(String csv) {
    final Map<String, dynamic> data =
        jsonDecode(csv) as Map<String, dynamic>;
    return EndgameInfo(
        onChain: data["onChain"],
        harmony: Harmony.values[data["harmony"]],
        trapScored: TrapScored.values[data["trapScored"]],
        micScored: MicScored.values[data["micScored"]],
        comments: data["comments"]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "onChain": onChain,
      "harmony": harmony.index,
      "trapScored": trapScored.index,
      "micScored": micScored.index,
      "comments": comments
    });
  }
}

class EndgameUpdateEvent extends ScoutingSessionEvents {}

class EndgameState extends ScoutingSessionStates {
  final EndgameInfo data;
  EndgameState(this.data);
}

class TeleOpInfo extends ScoutingInfo
    implements QRCompatibleData<TeleOpInfo> {
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

  static TeleOpInfo fromCompatibleFormat(String csv) {
    final Map<String, dynamic> data =
        jsonDecode(csv) as Map<String, dynamic>;
    return TeleOpInfo(
        playsDefense: data["playsDefense"],
        wasDefended: data["wasDefended"],
        scoredSpeaker: data["scoredSpeaker"],
        missedSpeaker: data["missedSpeaker"],
        scoredAmp: data["scoredAmp"],
        missedAmp: data["missedAmp"],
        scoredWhileAmped: data["scoredWhileAmped"],
        comments: data["comments"],
        driverRating: data["driverRating"]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "playsDefense": playsDefense,
      "wasDefended": wasDefended,
      "scoredSpeaker": scoredSpeaker,
      "missedSpeaker": missedSpeaker,
      "scoredAmp": scoredAmp,
      "missedAmp": missedAmp,
      "scoredWhileAmped": scoredWhileAmped,
      "comments": comments,
      "driverRating": driverRating
    });
  }
}

class TeleOpUpdateEvent extends ScoutingSessionEvents {}

class TeleOpState extends ScoutingSessionStates {
  final TeleOpInfo data;
  TeleOpState(this.data);
}

class AutoInfo extends ScoutingInfo
    implements QRCompatibleData<AutoInfo> {
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

  static AutoInfo fromCompatibleFormat(String rawData) {
    final Map<String, dynamic> data =
        jsonDecode(rawData) as Map<String, dynamic>;
    final List<AutoPickup> notesPickedUp = <AutoPickup>[];
    for (int element in data["notesPickedUp"]) {
      notesPickedUp.add(AutoPickup.values[element]);
    }
    return AutoInfo(
        notePreloaded: data["notePreloaded"],
        notesPickedUp: notesPickedUp,
        taxi: data["taxi"],
        scoredSpeaker: data["scoredSpeaker"],
        missedSpeaker: data["missedSpeaker"],
        scoredAmp: data["scoredAmp"],
        missedAmp: data["missedAmp"],
        comments: data["comments"]);
  }

  @override
  String toCompatibleFormat() {
    final List<int> notesPickedUpIndexes = <int>[];
    for (AutoPickup element in notesPickedUp) {
      notesPickedUpIndexes.add(element.index);
    }
    return jsonEncode(<String, dynamic>{
      "notePreloaded": notePreloaded,
      "notesPickedUp": notesPickedUpIndexes,
      "taxi": taxi,
      "scoredSpeaker": scoredSpeaker,
      "missedSpeaker": missedSpeaker,
      "scoredAmp": scoredAmp,
      "missedAmp": missedAmp,
      "comments": comments
    });
  }
}

class AutoUpdateEvent extends ScoutingSessionEvents {}

class AutoState extends ScoutingSessionStates {
  final AutoInfo data;
  AutoState(this.data);
}

class PrelimInfo extends ScoutingInfo
    implements QRCompatibleData<PrelimInfo> {
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
          {int? timeStamp,
          String scouters = "",
          int teamNumber = 0,
          int matchNumber = 0,
          MatchType matchType = MatchType.qualification,
          TeamAlliance alliance = TeamAlliance.red,
          MatchStartingPosition startingPosition =
              MatchStartingPosition.middle}) =>
      PrelimInfo(
          timeStamp:
              timeStamp ?? DateTime.now().millisecondsSinceEpoch,
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

  static PrelimInfo fromCompatibleFormat(String rawData) {
    final Map<String, dynamic> data =
        jsonDecode(rawData) as Map<String, dynamic>;
    return PrelimInfo(
        timeStamp: data["timeStamp"],
        scouters: data["scouters"],
        teamNumber: data["teamNumber"],
        matchNumber: data["matchNumber"],
        matchType: MatchType.values[data["matchType"]],
        alliance: TeamAlliance.values[data["alliance"]],
        startingPosition:
            MatchStartingPosition.values[data["startingPosition"]]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "timeStamp": timeStamp,
      "scouters": scouters,
      "teamNumber": teamNumber,
      "matchNumber": matchNumber,
      "matchType": matchType.index,
      "alliance": alliance.index,
      "startingPosition": startingPosition.index
    });
  }
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
  late final String id;

  ScoutingSessionBloc()
      : prelim = PrelimInfo.optional(),
        auto = AutoInfo.optional(),
        teleop = TeleOpInfo.optional(),
        endgame = EndgameInfo.optional(),
        misc = MiscInfo.optional(),
        super(PrelimState(PrelimInfo.optional())) {
    id = const Uuid()
        .v1(); // generatate UUID using v1 which is time based
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

  HollisticMatchScoutingData exportHollistic() =>
      HollisticMatchScoutingData(
          id: id,
          misc: misc,
          preliminary: prelim,
          auto: auto,
          teleop: teleop,
          endgame: endgame);
}
