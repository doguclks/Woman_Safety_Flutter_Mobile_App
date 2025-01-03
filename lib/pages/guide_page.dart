import 'package:flutter/material.dart';
import '../themes/colors.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasıl Kullanılır?'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Uygulama Hakkında',
              'Bu uygulama, kadınların güvenliğini sağlamak için tasarlanmış bir güvenlik asistanıdır. '
                  'Acil durumlarda sesinizi kaydederek yardım çağırmanızı sağlar.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Nasıl Çalışır?',
              '1. Öncelikle "Acil Durumda Ulaşılacak Kişi" bölümünden bir kişi belirlemelisiniz.\n\n'
                  '2. Tehlike anında ana sayfadaki mikrofon butonuna basın.\n\n'
                  '3. Uygulama sesinizi dinlemeye başlayacak ve tehlike içeren ifadeleri otomatik olarak algılayacaktır.\n\n'
                  '4. Tehlike algılandığında, belirlediğiniz kişiye konumunuzla birlikte otomatik olarak SMS gönderilecektir.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Önemli Notlar',
              '• Uygulamanın düzgün çalışması için mikrofon iznini vermeyi unutmayın.\n\n'
                  '• Acil durum kişisinin güncel telefon numarasını kaydettiğinizden emin olun.\n\n'
                  '• Uygulamayı kolay erişilebilir bir yerde tutun.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}
