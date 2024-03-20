import 'package:pretty_qr_code/pretty_qr_code.dart';

const int EPHEMERAL_MODELS_VERSION = 2; // 1-9
const int QR_CODE_ERROR_CORRECTION_LEVEL = QrErrorCorrectLevel.M;
const int COMMENTS_MAX_CHARS =
    170; // tested with the javascript console and a qr code generator for char length XD (scuffed dev env!)
