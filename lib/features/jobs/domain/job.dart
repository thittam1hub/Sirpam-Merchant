/// Made-to-order work: a name magnet, a party tiffin order, a stitched
/// blouse. Taken today, delivered later, usually with an advance.
library;

enum JobStatus { taken, making, ready, delivered, cancelled }

JobStatus jobStatusFrom(String? raw) => switch (raw) {
      'making' => JobStatus.making,
      'ready' => JobStatus.ready,
      'delivered' => JobStatus.delivered,
      'cancelled' => JobStatus.cancelled,
      _ => JobStatus.taken,
    };

/// The next status a one-tap move should set; null when the job is finished.
JobStatus? nextJobStatus(JobStatus s) => switch (s) {
      JobStatus.taken => JobStatus.making,
      JobStatus.making => JobStatus.ready,
      JobStatus.ready => JobStatus.delivered,
      JobStatus.delivered || JobStatus.cancelled => null,
    };

class Job {
  final String id;
  final String title;
  final String customer;
  final String phone;
  final String note;
  final int pricePaise;
  final int advancePaise;

  /// Promised delivery, epoch ms.
  final int dueAt;
  final JobStatus status;
  final int createdAt;
  final int updatedAt;

  /// Set once the balance has been posted to the day book, so delivering the
  /// same job twice never double-counts the money.
  final bool posted;

  const Job({
    required this.id,
    required this.title,
    this.customer = '',
    this.phone = '',
    this.note = '',
    this.pricePaise = 0,
    this.advancePaise = 0,
    required this.dueAt,
    this.status = JobStatus.taken,
    this.createdAt = 0,
    this.updatedAt = 0,
    this.posted = false,
  });

  int get balancePaise =>
      (pricePaise - advancePaise) < 0 ? 0 : pricePaise - advancePaise;

  bool get open =>
      status != JobStatus.delivered && status != JobStatus.cancelled;

  bool dueOn(DateTime day) {
    final d = DateTime.fromMillisecondsSinceEpoch(dueAt);
    return d.year == day.year && d.month == day.month && d.day == day.day;
  }

  bool get overdue =>
      open && dueAt > 0 && dueAt < DateTime.now().millisecondsSinceEpoch;

  Job copyWith({
    String? title,
    String? customer,
    String? phone,
    String? note,
    int? pricePaise,
    int? advancePaise,
    int? dueAt,
    JobStatus? status,
    int? updatedAt,
    bool? posted,
  }) =>
      Job(
        id: id,
        title: title ?? this.title,
        customer: customer ?? this.customer,
        phone: phone ?? this.phone,
        note: note ?? this.note,
        pricePaise: pricePaise ?? this.pricePaise,
        advancePaise: advancePaise ?? this.advancePaise,
        dueAt: dueAt ?? this.dueAt,
        status: status ?? this.status,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        posted: posted ?? this.posted,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'customer': customer,
        'phone': phone,
        'note': note,
        'pricePaise': pricePaise,
        'advancePaise': advancePaise,
        'dueAt': dueAt,
        'status': status.name,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'posted': posted,
      };

  static Job? tryFromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final title = j['title'];
    if (id is! String || id.isEmpty || title is! String || title.isEmpty) {
      return null;
    }
    return Job(
      id: id,
      title: title,
      customer: j['customer'] as String? ?? '',
      phone: j['phone'] as String? ?? '',
      note: j['note'] as String? ?? '',
      pricePaise: (j['pricePaise'] as num?)?.toInt() ?? 0,
      advancePaise: (j['advancePaise'] as num?)?.toInt() ?? 0,
      dueAt: (j['dueAt'] as num?)?.toInt() ?? 0,
      status: jobStatusFrom(j['status'] as String?),
      createdAt: (j['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (j['updatedAt'] as num?)?.toInt() ?? 0,
      posted: j['posted'] == true,
    );
  }
}
