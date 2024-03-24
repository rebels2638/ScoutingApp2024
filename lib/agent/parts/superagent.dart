// i love superagent package from npm

import 'package:http_requests/http_requests.dart';
import 'package:scouting_app_2024/agent/parts/option.dart';
import 'package:scouting_app_2024/agent/parts/shared.dart';
import 'package:scouting_app_2024/debug.dart';

typedef JsonBody = Map<dynamic, dynamic>;
typedef JsonResponse = Option<JsonBody, String>;

const String _superagent_received_res = "Received";

sealed class Superagent {
  static Future<HttpResponse> poll(String url) async =>
      await HttpRequests.get(url);
}

final class ArgusSuperagent {
  static bool doesApiExists = false;

  static Future<void> init() async => (await pollDelegator())
    ..onBad((String reason) => doesApiExists = false)
    ..onGood((JsonBody value) {
      doesApiExists = true;
      Debug().info("Superagent API exists with ${value.toString()}");
    });

  static Future<JsonResponse> pollDelegator() async {
    try {
      HttpResponse res =
          await HttpRequests.get(ArgusAgentShared.DELEGATOR_ROOT);
      if (res.isRedirect) {
        throw HttpRequestException(
            code: "DisallowedPathway",
            message: "Expected Raw, found Redirect");
      }
      if (res.json.isNotEmpty) {
        return JsonResponse.good(
            value: res.json, reason: _superagent_received_res);
      } else {
        throw HttpRequestException(
            code: "UnexpectedEmptyJsonBody",
            message: "The length of the body is empty?");
      }
    } on HttpRequestException catch (e) {
      Debug().watchdog(
          "[ARGUS_SUPERAGENT] failed to ret ${ArgusAgentShared.DELEGATOR_ROOT} with ${e.code}");
      return JsonResponse.fuckedUp(
          reason: "Failed to retrieve [Error Code: ${e.code}]");
    }
  }
}
