enum MaintenanceStatus {
  pending,
  accepted,
  technicianAssigned,
  completed,
}

class MaintenanceTicket {
  const MaintenanceTicket({
    required this.id,
    required this.deviceName,
    required this.issue,
    required this.description,
    required this.submittedDate,
    required this.status,
  });

  final String id;
  final String deviceName;
  final String issue;
  final String description;
  final String submittedDate;
  final MaintenanceStatus status;
}
