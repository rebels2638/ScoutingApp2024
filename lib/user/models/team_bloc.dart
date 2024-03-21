import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:scouting_app_2024/blobs/qr_converter_blob.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
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
          {EndStatus endState = EndStatus.unset,
          Harmony harmony = Harmony.unset,
          bool harmonyAttempted = false,
          MatchResult matchResult = MatchResult.unset,
          TrapScored trapScored = TrapScored.unset,
          MicScored micScored = MicScored.unset}) =>
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
  bool underStage;
  bool lobs;
  int scoredSpeaker;
  int missedSpeaker;
  int scoredAmp;
  int missedAmp;

  TeleOpInfo(
      {required this.underStage,
      required this.lobs,
      required this.scoredSpeaker,
      required this.missedSpeaker,
      required this.scoredAmp,
      required this.missedAmp});

  factory TeleOpInfo.optional(
          {bool underStage = false,
          bool lobs = false,
          int scoredSpeaker = 0,
          int missedSpeaker = 0,
          int scoredAmp = 0,
          int piecesScored = 0,
          int missedAmp = 0}) =>
      TeleOpInfo(
          underStage: underStage,
          lobs: lobs,
          scoredSpeaker: scoredSpeaker,
          missedSpeaker: missedSpeaker,
          scoredAmp: scoredAmp,
          missedAmp: missedAmp);

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "underStage": underStage,
        "lobs": lobs,
        "scoredSpeaker": scoredSpeaker,
        "missedSpeaker": missedSpeaker,
        "scoredAmp": scoredAmp,
        "missedAmp": missedAmp,
      };

  static TeleOpInfo fromCompatibleFormat(String csv) {
    final Map<String, dynamic> data =
        jsonDecode(csv) as Map<String, dynamic>;
    return TeleOpInfo(
        underStage: data["undSpker"],
        lobs: data["lob"],
        scoredSpeaker: data["spker"],
        missedSpeaker: data["missSpker"],
        scoredAmp: data["amp"],
        missedAmp: data["missAmp"]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "undSpker": underStage,
      "lob": lobs,
      "spker": scoredSpeaker,
      "missSpker": missedSpeaker,
      "amp": scoredAmp,
      "missAmp": missedAmp
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
  bool taxi;
  int scoredSpeaker;
  int missedSpeaker;
  int scoredAmp;
  int missedAmp;

  AutoInfo(
      {required this.notePreloaded,
      required this.taxi,
      required this.scoredSpeaker,
      required this.missedSpeaker,
      required this.scoredAmp,
      required this.missedAmp});

  factory AutoInfo.optional(
          {bool notePreloaded = false,
          bool taxi = false,
          int scoredSpeaker = 0,
          int missedSpeaker = 0,
          int scoredAmp = 0,
          int missedAmp = 0}) =>
      AutoInfo(
          notePreloaded: notePreloaded,
          taxi: taxi,
          scoredSpeaker: scoredSpeaker,
          missedSpeaker: missedSpeaker,
          scoredAmp: scoredAmp,
          missedAmp: missedAmp);

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "notePreloaded": notePreloaded,
        "taxi": taxi,
        "scoredSpeaker": scoredSpeaker,
        "missedSpeaker": missedSpeaker,
        "scoredAmp": scoredAmp,
        "missedAmp": missedAmp,
      };

  static AutoInfo fromCompatibleFormat(String rawData) {
    final Map<String, dynamic> data =
        jsonDecode(rawData) as Map<String, dynamic>;
    return AutoInfo(
        notePreloaded: data["preload"],
        taxi: data["taxi"],
        scoredSpeaker: data["spker"],
        missedSpeaker: data["missSpker"],
        scoredAmp: data["amp"],
        missedAmp: data["missAmp"]);
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<String, dynamic>{
      "preload": notePreloaded,
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
  String scouter;
  MatchType matchType;
  TeamAlliance alliance;
  MatchStartingPosition startingPosition;

  PrelimInfo(
      {required this.timeStamp,
      required this.teamNumber,
      required this.matchNumber,
      required this.matchType,
      required this.alliance,
      String? scouter,
      required this.startingPosition})
      : scouter = scouter ?? UserTelemetry().currentModel.profileName;

  factory PrelimInfo.optional(
          {int? timeStamp,
          int teamNumber = 0,
          int matchNumber = 0,
          MatchType matchType = MatchType.unset,
          TeamAlliance alliance = TeamAlliance.red,
          MatchStartingPosition startingPosition =
              MatchStartingPosition.unset}) =>
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
        "scouter": scouter,
        "startingPosition": startingPosition
      };

  static PrelimInfo fromCompatibleFormat(String rawData) {
    final Map<String, dynamic> data =
        jsonDecode(rawData) as Map<String, dynamic>;
    return PrelimInfo(
        timeStamp: data["time"],
        teamNumber: data["team#"],
        matchNumber: data["match#"],
        scouter: data["scouter"],
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
      "scouter": scouter,
      "start": startingPosition.index
    });
  }
}

class PrelimUpdateEvent extends ScoutingSessionEvents {}

class PrelimState extends ScoutingSessionStates {
  final PrelimInfo data;
  PrelimState(this.data);
}

// this class data is optimized af in order for us to utilize the QR code and DUC formatting
class CommentsInfo extends ScoutingInfo
    implements QRCompatibleData<CommentsInfo> {
  String? comment;
  String associatedId;
  int matchNumber;
  int teamNumber;

  CommentsInfo(
      {required this.comment,
      required this.associatedId,
      required this.matchNumber,
      required this.teamNumber});

  factory CommentsInfo.optional(
          {String comment = "",
          required String associatedId,
          required int matchNumber,
          required int teamNumber}) =>
      CommentsInfo(
          comment: comment,
          associatedId: associatedId,
          matchNumber: matchNumber,
          teamNumber: teamNumber);

  bool get isEmpty =>
      comment == null || comment!.isEmpty || comment! == "";

  bool get isNotEmpty =>
      comment != null && comment!.isNotEmpty && comment != "";

  @override
  Map<String, dynamic> exportMap() => <String, dynamic>{
        "cmt": comment,
        "assoc": associatedId,
        "match#": matchNumber,
        "team#": teamNumber
      };

  @override
  String toCompatibleFormat() => jsonEncode(<String, dynamic>{
        "cmt": comment ?? "",
        "assoc": associatedId,
        "match#": matchNumber,
        "team#": teamNumber
      });

  static CommentsInfo fromCompatibleFormat(String rawData) {
    final Map<String, dynamic> data =
        jsonDecode(rawData) as Map<String, dynamic>;
    return CommentsInfo(
        comment: data["cmt"] == null || data["cmt"].toString() == ""
            ? null
            : data["cmt"],
        associatedId: data["assoc"],
        matchNumber: data["match#"],
        teamNumber: data["team#"]);
  }
}

class CommentsUpdateEvent extends ScoutingSessionEvents {}

class CommentsState extends ScoutingSessionStates {
  final CommentsInfo data;
  CommentsState(this.data);
}

/// represents the intermediate representation of the data between
class ScoutingSessionBloc
    extends Bloc<ScoutingSessionEvents, ScoutingSessionStates> {
  PrelimInfo prelim;
  AutoInfo auto;
  TeleOpInfo teleop;
  EndgameInfo endgame;
  MiscInfo misc;
  CommentsInfo
      comments; // this is routed differently as compared to the other data stuffs (whats data plural again?)
  late final String id;

  ScoutingSessionBloc()
      : prelim = PrelimInfo.optional(),
        auto = AutoInfo.optional(),
        teleop = TeleOpInfo.optional(),
        endgame = EndgameInfo.optional(),
        comments = CommentsInfo.optional(
            associatedId: "000", matchNumber: 0, teamNumber: 0),
        misc = MiscInfo.optional(),
        super(PrelimState(PrelimInfo.optional())) {
    id = const Uuid()
        .v1(); // generate UUID using v1 which is time based
    comments.associatedId = id;
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
    on<CommentsUpdateEvent>((CommentsUpdateEvent event,
        Emitter<ScoutingSessionStates> emit) {
      emit(CommentsState(comments));
      Debug().info(
          "[Update] SCOUTING_SESSION$hashCode COMMENTS#${comments.associatedId}->updated");
    });
  }

  void _packCommentsClass() {
    comments.matchNumber = prelim.matchNumber;
    comments.teamNumber = prelim.teamNumber;
  }

  ({
    PrelimInfo prelim,
    AutoInfo auto,
    TeleOpInfo teleop,
    EndgameInfo endgame,
    MiscInfo misc,
    CommentsInfo comments,
  }) export() {
    _packCommentsClass();
    return (
      prelim: prelim,
      auto: auto,
      teleop: teleop,
      endgame: endgame,
      misc: misc,
      comments: comments
    );
  }

  Map<String, dynamic> exportMapDeep() {
    _packCommentsClass();
    Map<String, dynamic> map = <String, dynamic>{
      "prelim": prelim.exportMap(),
      "auto": auto.exportMap(),
      "teleop": teleop.exportMap(),
      "endgame": endgame.exportMap(),
      "misc": misc.exportMap(),
    };
    if (comments.isNotEmpty) {
      map["cmt"] = comments.exportMap();
    }
    return map;
  }

  Map<String, dynamic> exportMap() {
    _packCommentsClass();
    Map<String, dynamic> map = <String, dynamic>{
      "prelim": prelim,
      "auto": auto,
      "teleop": teleop,
      "endgame": endgame,
      "misc": misc
    };
    if (comments.isNotEmpty) {
      map["cmt"] = comments;
    }
    return map;
  }

  HollisticMatchScoutingData exportHollistic() {
    _packCommentsClass();
    return HollisticMatchScoutingData(
        id: id,
        misc: misc,
        preliminary: prelim,
        auto: auto,
        teleop: teleop,
        comments: comments,
        endgame: endgame);
  }
}
