class TimeService {
  /// Konversi dari UTC ke zona populer.
  /// WIB=UTC+7, WITA=UTC+8, WIT=UTC+9, London = UTC± (sederhana: anggap UTC+0).
  static DateTime toZone(DateTime utc, String zone) {
    // Pastikan utc benar-benar UTC
    final base = utc.toUtc();
    switch (zone) {
      case 'WIB':  return base.add(const Duration(hours: 7));
      case 'WITA': return base.add(const Duration(hours: 8));
      case 'WIT':  return base.add(const Duration(hours: 9));
      case 'London':
      default:
        return base; // sederhanakan: UTC ~ London (tanpa DST)
    }
  }
}
