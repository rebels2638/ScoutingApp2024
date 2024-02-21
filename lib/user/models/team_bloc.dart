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
        onChain: data["chain"],
        harmony: Harmony.values[data["harmony"]],
        trapScored: TrapScored.values[data["trap"]],
        micScored: MicScored.values[data["mic"]],
        comments: data["cmt"]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "chain": onChain,
      "harmony": harmony.index,
      "trap": trapScored.index,
      "mic": micScored.index,
      "cmt": comments
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
        playsDefense: data["defensive"],
        wasDefended: data["defed"],
        scoredSpeaker: data["spker"],
        missedSpeaker: data["missSpker"],
        scoredAmp: data["amp"],
        missedAmp: data["missAmp"],
        scoredWhileAmped: data["whileAmp"],
        comments: data["cmt"],
        driverRating: data["driverting"]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "defensive": playsDefense,
      "defed": wasDefended,
      "spker": scoredSpeaker,
      "missSpker": missedSpeaker,
      "amp": scoredAmp,
      "missAmp": missedAmp,
      "whileAmp": scoredWhileAmped,
      "cmt": comments,
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
          List<AutoPickup> notesPickedUp = const <AutoPickup>[
            ...AutoPickup.values
          ],
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
        missedAmp: data["missAmp"],
        comments: data["cmt"]);
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
      "cmt": comments
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
        timeStamp: data["time"],
        scouters: data["scters"],
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
      "scters": scouters,
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
