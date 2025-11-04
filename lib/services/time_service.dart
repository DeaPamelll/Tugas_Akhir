class TimeService {

  static DateTime toZone(DateTime utc, String zone) {

    final base = utc.toUtc();
    switch (zone) {
      case 'WIB':  return base.add(const Duration(hours: 7));
      case 'WITA': return base.add(const Duration(hours: 8));
      case 'WIT':  return base.add(const Duration(hours: 9));
      case 'London':
      default:
        return base; 
    }
  }
}
