class Company {
  final String name;
  final String logoText;
  final String tag; // e.g. "IT Services & Consulting"
  final String difficulty; // Easy, Medium, Hard
  final int totalQuestions;
  final int aptitudeCount;
  final int reasoningCount;
  final int verbalCount;
  final int codingCount;
  final int durationMinutes;
  final bool isPremiumOnly;
  final String accentHex;

  Company({
    required this.name,
    required this.logoText,
    required this.tag,
    required this.difficulty,
    required this.totalQuestions,
    required this.aptitudeCount,
    required this.reasoningCount,
    required this.verbalCount,
    required this.codingCount,
    required this.durationMinutes,
    this.isPremiumOnly = false,
    required this.accentHex,
  });

  static List<Company> defaultCompanies() {
    return [
      Company(
        name: 'TCS',
        logoText: 'TCS',
        tag: 'NQT & Digital Exam',
        difficulty: 'Medium',
        totalQuestions: 150,
        aptitudeCount: 50,
        reasoningCount: 40,
        verbalCount: 30,
        codingCount: 30,
        durationMinutes: 90,
        accentHex: '#4F46E5', // Indigo
      ),
      Company(
        name: 'Infosys',
        logoText: 'INF',
        tag: 'HackWithInfy & Specialist',
        difficulty: 'Medium',
        totalQuestions: 140,
        aptitudeCount: 45,
        reasoningCount: 35,
        verbalCount: 30,
        codingCount: 30,
        durationMinutes: 100,
        accentHex: '#0284C7', // Sky Blue
      ),
      Company(
        name: 'Wipro',
        logoText: 'WIP',
        tag: 'NLTH Exam',
        difficulty: 'Easy',
        totalQuestions: 120,
        aptitudeCount: 40,
        reasoningCount: 30,
        verbalCount: 30,
        codingCount: 20,
        durationMinutes: 75,
        accentHex: '#059669', // Emerald
      ),
      Company(
        name: 'Accenture',
        logoText: 'ACC',
        tag: 'Cognitive & Technical Assessment',
        difficulty: 'Medium',
        totalQuestions: 130,
        aptitudeCount: 40,
        reasoningCount: 40,
        verbalCount: 30,
        codingCount: 20,
        durationMinutes: 90,
        accentHex: '#7C3AED', // Violet
      ),
      Company(
        name: 'Cognizant',
        logoText: 'CTS',
        tag: 'GenC & GenC Elevate',
        difficulty: 'Medium',
        totalQuestions: 125,
        aptitudeCount: 35,
        reasoningCount: 35,
        verbalCount: 35,
        codingCount: 20,
        durationMinutes: 80,
        accentHex: '#2563EB', // Blue
      ),
      Company(
        name: 'Capgemini',
        logoText: 'CAP',
        tag: 'Exceller Drive & Pseudo Coding',
        difficulty: 'Hard',
        totalQuestions: 110,
        aptitudeCount: 30,
        reasoningCount: 30,
        verbalCount: 20,
        codingCount: 30,
        durationMinutes: 75,
        accentHex: '#D97706', // Amber
      ),
      Company(
        name: 'Deloitte',
        logoText: 'DEL',
        tag: 'Analyst & Tech Assessment',
        difficulty: 'Medium',
        totalQuestions: 100,
        aptitudeCount: 30,
        reasoningCount: 30,
        verbalCount: 30,
        codingCount: 10,
        durationMinutes: 60,
        accentHex: '#16A34A', // Green
      ),
      Company(
        name: 'HCL',
        logoText: 'HCL',
        tag: 'First Careers Drive',
        difficulty: 'Easy',
        totalQuestions: 100,
        aptitudeCount: 35,
        reasoningCount: 35,
        verbalCount: 20,
        codingCount: 10,
        durationMinutes: 60,
        accentHex: '#DC2626', // Red
      ),
      Company(
        name: 'Tech Mahindra',
        logoText: 'TM',
        tag: 'Supercoder & Elevate',
        difficulty: 'Medium',
        totalQuestions: 105,
        aptitudeCount: 35,
        reasoningCount: 30,
        verbalCount: 25,
        codingCount: 15,
        durationMinutes: 70,
        accentHex: '#EA580C', // Orange
      ),
      Company(
        name: 'LTIMindtree',
        logoText: 'LTI',
        tag: 'Software Engineer Drive',
        difficulty: 'Medium',
        totalQuestions: 115,
        aptitudeCount: 35,
        reasoningCount: 35,
        verbalCount: 25,
        codingCount: 20,
        durationMinutes: 75,
        accentHex: '#0891B2', // Cyan
      ),
    ];
  }
}
