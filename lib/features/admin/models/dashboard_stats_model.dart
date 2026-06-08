class DashboardStatsModel {
  final int activeDevices;
  final int offlineDevices;
  final int openTickets;
  final int ordersToday;

  DashboardStatsModel({
    this.activeDevices = 0,
    this.offlineDevices = 0,
    this.openTickets = 0,
    this.ordersToday = 0,
  });
}
