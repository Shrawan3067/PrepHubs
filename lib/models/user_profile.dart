class UserProfile {
  final String name;
  final String email;
  final bool isGuest;
  final bool isPro;
  final String dreamCompany;
  final String targetRole;
  final int streakDays;
  final DateTime? lastActiveDate;
  final List<String> favoriteCompanies;
  final List<int> bookmarkedQuestionIds;
  final String referralCode;
  final int referralsCount;
  final int referralEarnings;
  final bool isAdmin;

  UserProfile({
    required this.name,
    required this.email,
    this.isGuest = true,
    this.isPro = false,
    this.dreamCompany = 'TCS',
    this.targetRole = 'Software Engineer',
    this.streakDays = 3,
    this.lastActiveDate,
    this.favoriteCompanies = const [],
    this.bookmarkedQuestionIds = const [],
    required this.referralCode,
    this.referralsCount = 2,
    this.referralEarnings = 500,
    this.isAdmin = false,
  });

  factory UserProfile.guest() {
    return UserProfile(
      name: 'Guest Scholar',
      email: 'guest@prephubs.com',
      isGuest: true,
      isPro: false,
      dreamCompany: 'TCS',
      targetRole: 'System Engineer',
      streakDays: 1,
      lastActiveDate: DateTime.now(),
      favoriteCompanies: ['TCS', 'Infosys'],
      bookmarkedQuestionIds: [1, 3],
      referralCode: 'PREP-GUEST-99',
      referralsCount: 0,
      referralEarnings: 0,
      isAdmin: false,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? 'Placement Aspirant',
      email: json['email'] as String? ?? 'user@prephubs.com',
      isGuest: json['isGuest'] as bool? ?? false,
      isPro: json['isPro'] as bool? ?? false,
      dreamCompany: json['dreamCompany'] as String? ?? 'TCS',
      targetRole: json['targetRole'] as String? ?? 'Software Engineer',
      streakDays: json['streakDays'] as int? ?? 1,
      lastActiveDate: DateTime.tryParse(json['lastActiveDate'] as String? ?? ''),
      favoriteCompanies: (json['favoriteCompanies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      bookmarkedQuestionIds: (json['bookmarkedQuestionIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      referralCode: json['referralCode'] as String? ?? 'PREP-PRO-2026',
      referralsCount: json['referralsCount'] as int? ?? 0,
      referralEarnings: json['referralEarnings'] as int? ?? 0,
      isAdmin: json['isAdmin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'isGuest': isGuest,
      'isPro': isPro,
      'dreamCompany': dreamCompany,
      'targetRole': targetRole,
      'streakDays': streakDays,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'favoriteCompanies': favoriteCompanies,
      'bookmarkedQuestionIds': bookmarkedQuestionIds,
      'referralCode': referralCode,
      'referralsCount': referralsCount,
      'referralEarnings': referralEarnings,
      'isAdmin': isAdmin,
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    bool? isGuest,
    bool? isPro,
    String? dreamCompany,
    String? targetRole,
    int? streakDays,
    DateTime? lastActiveDate,
    List<String>? favoriteCompanies,
    List<int>? bookmarkedQuestionIds,
    String? referralCode,
    int? referralsCount,
    int? referralEarnings,
    bool? isAdmin,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      isPro: isPro ?? this.isPro,
      dreamCompany: dreamCompany ?? this.dreamCompany,
      targetRole: targetRole ?? this.targetRole,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      favoriteCompanies: favoriteCompanies ?? this.favoriteCompanies,
      bookmarkedQuestionIds: bookmarkedQuestionIds ?? this.bookmarkedQuestionIds,
      referralCode: referralCode ?? this.referralCode,
      referralsCount: referralsCount ?? this.referralsCount,
      referralEarnings: referralEarnings ?? this.referralEarnings,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
