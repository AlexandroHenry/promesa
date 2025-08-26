import 'package:flutter/material.dart';

/// 알림 설정 화면 - 설정 화면에서 접근 가능
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // 알림 설정 상태들
  bool _pushNotificationEnabled = true;
  bool _emailNotificationEnabled = false;
  bool _marketingNotificationEnabled = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
      ),
      body: ListView(
        children: [
          // 기본 알림 설정
          _buildSectionHeader(context, '기본 알림'),
          SwitchListTile(
            title: const Text('푸시 알림'),
            subtitle: const Text('앱 알림을 받습니다'),
            value: _pushNotificationEnabled,
            onChanged: (value) {
              setState(() {
                _pushNotificationEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('이메일 알림'),
            subtitle: const Text('중요한 소식을 이메일로 받습니다'),
            value: _emailNotificationEnabled,
            onChanged: (value) {
              setState(() {
                _emailNotificationEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('마케팅 알림'),
            subtitle: const Text('이벤트 및 혜택 정보를 받습니다'),
            value: _marketingNotificationEnabled,
            onChanged: (value) {
              setState(() {
                _marketingNotificationEnabled = value;
              });
            },
          ),
          
          const Divider(),
          
          // 알림 방식 설정
          _buildSectionHeader(context, '알림 방식'),
          SwitchListTile(
            title: const Text('소리'),
            subtitle: const Text('알림 소리를 재생합니다'),
            value: _soundEnabled,
            onChanged: _pushNotificationEnabled
                ? (value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                  }
                : null,
          ),
          SwitchListTile(
            title: const Text('진동'),
            subtitle: const Text('알림 시 진동을 울립니다'),
            value: _vibrationEnabled,
            onChanged: _pushNotificationEnabled
                ? (value) {
                    setState(() {
                      _vibrationEnabled = value;
                    });
                  }
                : null,
          ),
          
          const Divider(),
          
          // 알림 시간 설정
          _buildSectionHeader(context, '알림 시간'),
          ListTile(
            title: const Text('방해 금지 시간'),
            subtitle: const Text('22:00 - 08:00'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showTimePickerDialog(context);
            },
          ),
          
          const SizedBox(height: 32),
          
          // 저장 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _saveSettings(context);
              },
              child: const Text('설정 저장'),
            ),
          ),
        ],
      ),
    );
  }

  /// 섹션 헤더 빌드
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 시간 선택 다이얼로그
  void _showTimePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('방해 금지 시간 설정'),
        content: const Text('개발 예정 기능입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// 설정 저장
  void _saveSettings(BuildContext context) {
    // TODO: 실제 설정 저장 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('알림 설정이 저장되었습니다.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
