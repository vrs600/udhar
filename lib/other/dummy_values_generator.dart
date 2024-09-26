import 'dart:math';

class DummyValueGenerator {
  String generateRandomMobileNumber() {
    final List<String> mobileNumbers = [
      "+919876543210",
      "+918765432109",
      "+917654321098",
      "+916543210987",
      "+915432109876",
    ];
    int randomNumber = Random().nextInt(mobileNumbers.length - 1);
    return mobileNumbers[randomNumber];
  }

  int generateRandomLoanInThousands() {
    final random = Random();
    // Generate a random integer between 10 (inclusive) and 31 (exclusive)
    // Multiply by 1000 to get a value in thousands
    return 10000 + random.nextInt(31) * 1000;
  }

  String generateRandomDate() {
    final random = Random();
    const year = 2024; // Adjust this if you want a different year range

    // Generate random month (1-12)
    final month = random.nextInt(12) + 1;

    // Generate random day based on the number of days in the chosen month
    final daysInMonth = _getDaysInMonth(year, month);
    final day = random.nextInt(daysInMonth) + 1;

    // Format the date string
    final formattedDate =
        "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";

    return formattedDate;
  }

// Helper function to determine the number of days in a month
  int _getDaysInMonth(int year, int month) {
    if (month == 2) {
      // Check for leap year
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      } else {
        return 28;
      }
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    } else {
      return 31;
    }
  }

  List<String> loremIpsumWords = [
    "lorem",
    "ipsum",
    "dolor",
    "sit",
    "amet",
    "consectetur",
    "adipiscing",
    "elit",
    "sed",
    "do",
    "eiusmod",
    "tempor",
    "incididunt",
    "ut",
    "labore",
    "et",
    "dolore",
    "magna",
    "aliqua",
    "ut",
    "enim",
    "ad",
    "minim",
    "veniam",
    "quis",
    "nostrud",
    "exercitation",
    "ullamco",
    "laboris",
    "nisi",
    "ut",
    "aliquip",
    "ex",
    "ea",
    "commodo",
    "consequat",
    "duis",
    "aute",
    "irure",
    "dolor",
    "in",
    "reprehenderit",
    "in",
    "voluptate",
    "velit",
    "esse",
    "cillum",
    "dolore",
    "eu",
    "fugiat",
    "nulla",
    "pariatur",
    "excepteur",
    "sint",
    "occaecat",
    "cupidatat",
    "non",
    "proident",
    "sunt",
    "in",
    "culpa",
    "qui",
    "officia",
    "deserunt",
    "mollit",
    "anim",
    "id",
    "est",
    "laborum"
  ];

  String generateRandomNote({required int minCharCount}) {
    final random = Random();
    final sentenceLength =
        random.nextInt(50) + minCharCount; // Min 100 characters, max 149
    final wordCount =
        (sentenceLength / 5).floor(); // Roughly 5 characters per word

    final buffer = StringBuffer();
    for (var i = 0; i < wordCount; i++) {
      buffer
          .write("${loremIpsumWords[random.nextInt(loremIpsumWords.length)]} ");
    }

    // Ensure last word doesn't have trailing space
    return buffer.toString().trim();
  }
}
