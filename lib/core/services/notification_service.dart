// ---------------------------------------------------
// lib/core/services/notification_service.dart (File Baru)
// ---------------------------------------------------

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // --- Inisialisasi Android ---
    // 'notification_icon' HARUS SAMA dengan nama file .png di android/app/src/main/res/drawable/
    final AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    // --- Inisialisasi iOS ---
    final DarwinInitializationSettings initSettingsIOS =
        DarwinInitializationSettings(
      // Meminta izin notifikasi (alert, badge, sound) saat init
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Gabungkan pengaturan
    final InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    // Inisialisasi plugin
    await _notificationsPlugin.initialize(initSettings);

    // --- Minta Izin Android 13+ (Penting) ---
    // Plugin ini menanganinya secara otomatis saat inisialisasi di atas,
    // tapi kita juga bisa memintanya secara manual jika perlu.
    _requestAndroidPermission();
  }

  Future<void> _requestAndroidPermission() async {
    // Untuk Android 13 (API 33) ke atas, kita perlu izin POST_NOTIFICATIONS
    // Versi plugin ini seharusnya sudah otomatis meminta saat init,
    // tapi ini adalah cara manual untuk memastikannya.
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  /// Menampilkan notifikasi terjadwal (misal: 5 detik dari sekarang)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required Duration duration,
  }) async {
    // Tentukan detail notifikasi untuk Android
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'anime_app_channel_id', // ID Channel
      'Anime App Channel', // Nama Channel
      channelDescription: 'Channel untuk notifikasi Anime App',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'notification_icon', // Pastikan ikon ini ada
      playSound: true,
    );

    // Tentukan detail notifikasi untuk iOS
    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Jadwalkan notifikasi
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(duration), // Waktu (dari sekarang)
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
