import 'package:app/API/send_text_to_api.dart';
import 'package:app/widgets/custom_icon_button.dart';
import 'package:app/widgets/record_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../themes/colors.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:app/pages/emergency_contact_page.dart';
import 'package:app/pages/guide_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isOffensive = false;
  String _text = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> checkAndRequestMicrophonePermission() async {
    // Mikrofon iznini kontrol et
    var status = await Permission.microphone.status;

    // Eğer izin verilmediyse, kullanıcıdan izin iste
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      PermissionStatus result = await Permission.microphone.request();

      if (result.isGranted) {
        print("Mikrofon izni verildi.");
      } else {
        print("Mikrofon izni reddedildi.");
      }
    } else if (status.isGranted) {
      print("Mikrofon izni zaten verilmiş.");
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _startListening() async {
    // Eğer zaten dinliyorsa, dinlemeyi durdur
    if (_isListening) {
      _stopListening();
      return;
    }

    await checkAndRequestMicrophonePermission(); // İzin kontrolü ve isteme

    if (await Permission.microphone.isGranted) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _listenContinuously();
      } else {
        print("Speech-to-Text başlatılamadı.");
      }
    } else {
      print("Mikrofon izni yok. İşlem durduruldu.");
    }
  }

  void _listenContinuously() {
    _speech.listen(
      onResult: (val) async {
        setState(() {
          _text = val.recognizedWords;
          print("Text = $_text");
        });

        // Metni API'ye gönder ve sonucu kontrol et
        var response = await sendTextToAPI(_text);
        
        if (response == "offensive") {
          setState(() {
            _isOffensive = true;
            _isListening = false;
          });
          _speech.stop();
          await RecordButtonWidget(onPressed: () {}, isRecording: false)
              .handleOffensiveContent(context);
        } else {
          setState(() {
            _isOffensive = false;
          });
        }
      },
      listenFor: Duration(seconds: 10), // 10 saniye boyunca dinle
      pauseFor: Duration(seconds: 20), // 1 saniye boşluk ver
      listenOptions: stt.SpeechListenOptions(partialResults: true),
      onSoundLevelChange: (level) {
        // Ses seviyesi düşük olsa da dinlemeye devam et
        if (!_speech.isListening && _isListening) {
          _listenContinuously();
        }
      },
    );

    // Dinleme durursa yeniden başlat

    _speech.statusListener = (val) {
      if (val == "notListening" && _isListening) {
        _listenContinuously();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustomIconButton(
                      iconData: Symbols.person_add,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmergencyContactPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(Acil Durumda Bildirilen Kişi)',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: AppColors.textColor,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomIconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GuidePage(),
                          ),
                        );
                      },
                      iconData: Symbols.help_outline,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(Uygulama Hakkında)',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: AppColors.textColor,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RecordButtonWidget(
                    onPressed: _startListening,
                    isRecording: _isListening,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isListening
                        ? "Ses kaydı başlatıldı"
                        : "(Ses kaydını başlatmak için tıklayınız)",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  Text(
                    _isOffensive ? "Ofansif cümle algılandı!" : "",
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 20,
                      color: _isOffensive ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
