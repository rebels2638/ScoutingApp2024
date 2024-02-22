import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:scouting_app_2024/blobs/qr_converter_blob.dart';
import 'package:scouting_app_2024/debug.dart';
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
        coopertition: data["coop"], breakdown: data["broken"]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(
        <String, dynamic>{"coop": coopertition, "broken": breakdown});
  }
}

class MiscUpdateEvent extends ScoutingSessionEvents {}

class MiscState extends ScoutingSessionStates {
  final MiscInfo data;
  MiscState(this.data);
}

class EndgameInfo extends ScoutingInfo
    implements QRCompatibleData<EndgameInfo> {
  EndStatus endState;
  Harmony harmony;
  TrapScored trapScored;
  MatchResult matchResult;
  MicScored micScored;
  bool harmonyAttempted;

  EndgameInfo(
      {required this.endState,
      required this.harmony,
      required this.harmonyAttempted,
      required this.matchResult,
      required this.trapScored,
      required this.micScored});

  factory EndgameInfo.optional(
          {EndStatus endState = EndStatus.on_stage,
          Harmony harmony = Harmony.no,
          bool harmonyAttempted = false,
          MatchResult matchResult = MatchResult.loss,
          TrapScored trapScored = TrapScored.no,
          MicScored micScored = MicScored.no}) =>
      EndgameInfo(
        harmonyAttempted: harmonyAttempted,
        matchResult: matchResult,
        endState: endState,
        harmony: harmony,
        trapScored: trapScored,
        micScored: micScored,
      );

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "endStatus": endState,
        "harmony": harmony,
        "trapScored": trapScored,
        "micScored": micScored,
        "harmonyAttempted": harmonyAttempted,
        "matchResult": matchResult,
      };

  static EndgameInfo fromCompatibleFormat(String csv) {
    final Map<String, dynamic> data =
        jsonDecode(csv) as Map<String, dynamic>;
    return EndgameInfo(
        harmonyAttempted: data["hmnyAttempt"],
        matchResult: MatchResult.values[data["res"]],
        endState: EndStatus.values[data["end"]],
        harmony: Harmony.values[data["hmny"]],
        trapScored: TrapScored.values[data["trap"]],
        micScored: MicScored.values[data["mic"]]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "res": matchResult.index,
      "end": endState.index,
      "hmny": harmony.index,
      "hmnyAttempt": harmonyAttempted,
      "trap": trapScored.index,
      "mic": micScored.index,
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
  bool underStage;
  int scoredSpeaker;
  int missedSpeaker;
  int scoredAmp;
  int piecesScored;
  int missedAmp;
  int scoredWhileAmped; // such a goofy name
  int driverRating;

  TeleOpInfo(
      {required this.playsDefense,
      required this.underStage,
      required this.scoredSpeaker,
      required this.missedSpeaker,
      required this.scoredAmp,
      required this.piecesScored,
      required this.missedAmp,
      required this.scoredWhileAmped,
      required this.driverRating});

  factory TeleOpInfo.optional(
          {bool playsDefense = false,
          bool underStage = false,
          int scoredSpeaker = 0,
          int missedSpeaker = 0,
          int scoredAmp = 0,
          int piecesScored = 0,
          int missedAmp = 0,
          int scoredWhileAmped = 0,
          int driverRating = 0}) =>
      TeleOpInfo(
          playsDefense: playsDefense,
          underStage: underStage,
          scoredSpeaker: scoredSpeaker,
          missedSpeaker: missedSpeaker,
          scoredAmp: scoredAmp,
          piecesScored: piecesScored,
          missedAmp: missedAmp,
          scoredWhileAmped: scoredWhileAmped,
          driverRating: driverRating);

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "playsDefense": playsDefense,
        "underStage": underStage,
        "scoredSpeaker": scoredSpeaker,
        "missedSpeaker": missedSpeaker,
        "scoredAmp": scoredAmp,
        "piecesScored": piecesScored,
        "missedAmp": missedAmp,
        "scoredWhileAmped": scoredWhileAmped,
        "driverRating": driverRating
      };

  static TeleOpInfo fromCompatibleFormat(String csv) {
    final Map<String, dynamic> data =
        jsonDecode(csv) as Map<String, dynamic>;
    return TeleOpInfo(
        piecesScored: data["pieces"],
        playsDefense: data["def"],
        underStage: data["undSpker"],
        scoredSpeaker: data["spker"],
        missedSpeaker: data["missSpker"],
        scoredAmp: data["amp"],
        missedAmp: data["missAmp"],
        scoredWhileAmped: data["whileAmp"],
        driverRating: data["driverting"]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "def": playsDefense,
      "pieces": piecesScored,
      "undSpker": underStage,
      "spker": scoredSpeaker,
      "missSpker": missedSpeaker,
      "amp": scoredAmp,
      "missAmp": missedAmp,
      "whileAmp": scoredWhileAmped,
      "driverting": driverRating
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

  AutoInfo(
      {required this.notePreloaded,
      required this.notesPickedUp,
      required this.taxi,
      required this.scoredSpeaker,
      required this.missedSpeaker,
      required this.scoredAmp,
      required this.missedAmp});

  factory AutoInfo.optional(
          {bool notePreloaded = false,
          List<AutoPickup> notesPickedUp = const <AutoPickup>[
            ...AutoPickup.values
          ],
          bool taxi = false,
          int scoredSpeaker = 0,
          int missedSpeaker = 0,
          int scoredAmp = 0,
          int missedAmp = 0}) =>
      AutoInfo(
          notePreloaded: notePreloaded,
          notesPickedUp: notesPickedUp,
          taxi: taxi,
          scoredSpeaker: scoredSpeaker,
          missedSpeaker: missedSpeaker,
          scoredAmp: scoredAmp,
          missedAmp: missedAmp);

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "notePreloaded": notePreloaded,
        "notesPickedUp": notesPickedUp,
        "taxi": taxi,
        "scoredSpeaker": scoredSpeaker,
        "missedSpeaker": missedSpeaker,
        "scoredAmp": scoredAmp,
        "missedAmp": missedAmp,
      };

  static AutoInfo fromCompatibleFormat(String rawData) {
    final Map<String, dynamic> data =
        jsonDecode(rawData) as Map<String, dynamic>;
    final List<AutoPickup> notesPickedUp = <AutoPickup>[];
    for (int element in data["pickup"]) {
      notesPickedUp.add(AutoPickup.values[element]);
    }
    return AutoInfo(
        notePreloaded: data["preload"],
        notesPickedUp: notesPickedUp,
        taxi: data["taxi"],
        scoredSpeaker: data["spker"],
        missedSpeaker: data["missSpker"],
        scoredAmp: data["amp"],
        missedAmp: data["missAmp"]);
  }

  @override
  String toCompatibleFormat() {
    final List<int> notesPickedUpIndexes = <int>[];
    for (AutoPickup element in notesPickedUp) {
      notesPickedUpIndexes.add(element.index);
    }
    return jsonEncode(<String, dynamic>{
      "preload": notePreloaded,
      "pickup": notesPickedUpIndexes,
      "taxi": taxi,
      "spker": scoredSpeaker,
      "missSpker": missedSpeaker,
      "amp": scoredAmp,
      "missAmp": missedAmp,
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
  int teamNumber;
  int matchNumber;
  MatchType matchType;
  TeamAlliance alliance;
  MatchStartingPosition startingPosition;

  PrelimInfo(
      {required this.timeStamp,
      required this.teamNumber,
      required this.matchNumber,
      required this.matchType,
      required this.alliance,
      required this.startingPosition});

  factory PrelimInfo.optional(
          {int? timeStamp,
          int teamNumber = 0,
          int matchNumber = 0,
          MatchType matchType = MatchType.qualification,
          TeamAlliance alliance = TeamAlliance.red,
          MatchStartingPosition startingPosition =
              MatchStartingPosition.middle}) =>
      PrelimInfo(
          timeStamp:
              timeStamp ?? DateTime.now().millisecondsSinceEpoch,
          teamNumber: teamNumber,
          matchNumber: matchNumber,
          matchType: matchType,
          alliance: alliance,
          startingPosition: startingPosition);

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "timeStamp": timeStamp,
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
        timeStamp: data["time"],
        teamNumber: data["team#"],
        matchNumber: data["match#"],
        matchType: MatchType.values[data["match"]],
        alliance: TeamAlliance.values[data["allies"]],
        startingPosition:
            MatchStartingPosition.values[data["start"]]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "time": timeStamp,
      "team#": teamNumber,
      "match#": matchNumber,
      "match": matchType.index,
      "allies": alliance.index,
      "start": startingPosition.index
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
      emit(PrelimState(prelim));
      Debug().info(
          "[Update] SCOUTING_SESSION$hashCode PRELIM->updated.");
    });
    on<AutoUpdateEvent>(
        (AutoUpdateEvent event, Emitter<ScoutingSessionStates> emit) {
      emit(AutoState(auto));
      Debug()
          .info("[Update] SCOUTING_SESSION$hashCode AUTO->updated");
    });
    on<MiscUpdateEvent>(
        (MiscUpdateEvent event, Emitter<ScoutingSessionStates> emit) {
      emit(MiscState(misc));
      Debug()
          .info("[Update] SCOUTING_SESSION$hashCode MISC->updated");
    });
    on<TeleOpUpdateEvent>((TeleOpUpdateEvent event,
        Emitter<ScoutingSessionStates> emit) {
      emit(TeleOpState(teleop));
      Debug()
          .info("[Update] SCOUTING_SESSION$hashCode TELEOP->updated");
    });
    on<EndgameUpdateEvent>((EndgameUpdateEvent event,
        Emitter<ScoutingSessionStates> emit) {
      emit(EndgameState(endgame));
      Debug().info(
          "[Update] SCOUTING_SESSION$hashCode ENDGAME->updated");
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
