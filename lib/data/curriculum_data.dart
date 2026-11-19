class ActivityItem {
  final String id;
  final String stage; // 'Starter', 'Movers', 'Flyers'
  final String stageNumber; // '1-2', '3-4', '5-6', '7-8'
  final String title;
  final String topic;
  final String activityType; // 'matching', 'drag_drop', 'trace', 'listen_choose', 'balloon_pop', 'sentence_builder', 'memory', 'hidden_object', 'fill_blank', 'speak_record'
  final String emoji;
  final String characterName;
  final String characterQuote;
  final Map<String, dynamic> gameData;

  const ActivityItem({
    required this.id,
    required this.stage,
    required this.stageNumber,
    required this.title,
    required this.topic,
    required this.activityType,
    required this.emoji,
    required this.characterName,
    required this.characterQuote,
    required this.gameData,
  });
}

class CurriculumData {
  static const List<ActivityItem> activities = [
    // =========================================================================
    // 1. SEVIYE: STARTER (Pre-A1)
    // =========================================================================

    // 1. STARTER 1–2: MATCHING
    // Topic: Greetings & Farewells (100% Visual & English, Duolingo Style)
    ActivityItem(
      id: 'starter_1_2',
      stage: 'Starter',
      stageNumber: '1–2',
      title: 'Greetings & Goodbyes',
      topic: 'Greetings & Farewells',
      activityType: 'matching',
      emoji: '👋',
      characterName: 'Gigi',
      characterQuote: 'Match each greeting with its joyful picture!',
      gameData: {
        'targetGoal': 'Golden Leaves 🌿',
        'pairs': [
          {'id': 'hello', 'english': 'Hello!', 'meaning': 'Friendly Wave 👋', 'icon': '👋'},
          {'id': 'morning', 'english': 'Good morning!', 'meaning': 'Sunrise 🌅', 'icon': '🌅'},
          {'id': 'afternoon', 'english': 'Good afternoon!', 'meaning': 'Sunny Day ☀️', 'icon': '☀️'},
          {'id': 'how_are_you', 'english': 'How are you?', 'meaning': 'Happy Smile 😊', 'icon': '😊'},
          {'id': 'goodbye', 'english': 'Goodbye!', 'meaning': 'See You 🙋‍♂️', 'icon': '🙋‍♂️'},
        ]
      },
    ),

    // 2. STARTER 3–4: SURUKLE–BIRAK (DRAG & DROP)
    // Konu: Gunluk aktiviteler
    ActivityItem(
      id: 'starter_3_4',
      stage: 'Starter',
      stageNumber: '3–4',
      title: 'Daily Activities',
      topic: 'Daily Routines',
      activityType: 'drag_drop',
      emoji: '⏰',
      characterName: 'Gigi',
      characterQuote: 'Drag each routine sentence to the matching picture!',
      gameData: {
        'targets': [
          {'sentence': 'I wake up at 7.', 'icon': '⏰'},
          {'sentence': 'I brush my teeth.', 'icon': '🪥'},
          {'sentence': 'I eat breakfast.', 'icon': '🥞'},
          {'sentence': 'I go to school.', 'icon': '🎒'},
          {'sentence': 'I play in the park.', 'icon': '🛝'},
        ]
      },
    ),

    // 3. STARTER 5–6: HARF CIZME (TRACE)
    // Konu: Aile uyeleri
    ActivityItem(
      id: 'starter_5_6',
      stage: 'Starter',
      stageNumber: '5–6',
      title: 'Family Letter Trace',
      topic: 'Family Members',
      activityType: 'trace',
      emoji: '✏️',
      characterName: 'Gigi',
      characterQuote: 'Trace the starting letters of family words!',
      gameData: {
        'letters': [
          {'letter': 'M', 'word': 'mother', 'icon': '👩'},
          {'letter': 'F', 'word': 'father', 'icon': '👨'},
          {'letter': 'B', 'word': 'brother', 'icon': '👦'},
          {'letter': 'S', 'word': 'sister', 'icon': '👧'},
          {'letter': 'G', 'word': 'grandmother', 'icon': '👵'},
        ]
      },
    ),

    // 4. STARTER 7–8: DINLE VE SEC (LISTEN & CHOOSE)
    // Konu: Okul esyalari ve aktiviteleri
    ActivityItem(
      id: 'starter_7_8',
      stage: 'Starter',
      stageNumber: '7–8',
      title: 'School Objects & Activities',
      topic: 'School Supplies & Activities',
      activityType: 'listen_choose',
      emoji: '🎧',
      characterName: 'Gigi',
      characterQuote: 'Listen carefully and choose the correct school item or action!',
      gameData: {
        'questions': [
          {
            'soundText': 'This is my bag.',
            'target': 'Bag',
            'options': [
              {'name': 'Bag', 'icon': '🎒'},
              {'name': 'Book', 'icon': '📖'},
              {'name': 'Pencil', 'icon': '✏️'},
            ]
          },
          {
            'soundText': 'This is my book.',
            'target': 'Book',
            'options': [
              {'name': 'Ruler', 'icon': '📏'},
              {'name': 'Book', 'icon': '📖'},
              {'name': 'Notebook', 'icon': '📓'},
            ]
          },
          {
            'soundText': 'This is my pencil.',
            'target': 'Pencil',
            'options': [
              {'name': 'Pencil', 'icon': '✏️'},
              {'name': 'Eraser', 'icon': '🧼'},
              {'name': 'Bag', 'icon': '🎒'},
            ]
          },
          {
            'soundText': 'This is my ruler.',
            'target': 'Ruler',
            'options': [
              {'name': 'Book', 'icon': '📖'},
              {'name': 'Ruler', 'icon': '📏'},
              {'name': 'Notebook', 'icon': '📓'},
            ]
          },
          {
            'soundText': 'This is my notebook.',
            'target': 'Notebook',
            'options': [
              {'name': 'Notebook', 'icon': '📓'},
              {'name': 'Pencil', 'icon': '✏️'},
              {'name': 'Bag', 'icon': '🎒'},
            ]
          },
          {
            'soundText': 'I study English.',
            'target': 'Study English',
            'options': [
              {'name': 'Study English', 'icon': '🇬🇧'},
              {'name': 'Play', 'icon': '⚽'},
              {'name': 'Draw', 'icon': '🎨'},
            ]
          },
          {
            'soundText': 'I read a book.',
            'target': 'Read a book',
            'options': [
              {'name': 'Draw', 'icon': '🎨'},
              {'name': 'Play', 'icon': '⚽'},
              {'name': 'Read a book', 'icon': '📚'},
            ]
          },
          {
            'soundText': 'I write.',
            'target': 'Write',
            'options': [
              {'name': 'Write', 'icon': '✍️'},
              {'name': 'Draw', 'icon': '🎨'},
              {'name': 'Play', 'icon': '⚽'},
            ]
          },
          {
            'soundText': 'I draw.',
            'target': 'Draw',
            'options': [
              {'name': 'Draw', 'icon': '🎨'},
              {'name': 'Write', 'icon': '✍️'},
              {'name': 'Study English', 'icon': '🇬🇧'},
            ]
          },
          {
            'soundText': 'I play.',
            'target': 'Play',
            'options': [
              {'name': 'Play', 'icon': '⚽'},
              {'name': 'Study English', 'icon': '🇬🇧'},
              {'name': 'Read a book', 'icon': '📚'},
            ]
          },
        ]
      },
    ),

    // =========================================================================
    // 2. SEVIYE: MOVERS (A1)
    // =========================================================================

    // 5. MOVERS 1–2: BALON PATLATMA (BALLOON POP)
    // Konu: Gunluk konusmalarda selamlasma
    ActivityItem(
      id: 'movers_1_2',
      stage: 'Movers',
      stageNumber: '1–2',
      title: 'Daily Greetings Balloon Pop',
      topic: 'Daily Conversations',
      activityType: 'balloon_pop',
      emoji: '🎈',
      characterName: 'Gigi',
      characterQuote: 'Listen to the greeting and pop the correct balloon!',
      gameData: {
        'rounds': [
          {
            'prompt': 'Listen & Pop:',
            'target': "How's it going?",
            'options': ["How's it going?", 'Goodbye!', 'Good night!'],
          },
          {
            'prompt': 'Listen & Pop:',
            'target': 'Nice to meet you.',
            'options': ['Nice to meet you.', 'I am tired.', 'See you!'],
          },
          {
            'prompt': 'Listen & Pop:',
            'target': 'Hi there!',
            'options': ['Hi there!', 'No thanks.', 'Sleep well.'],
          },
          {
            'prompt': 'Listen & Pop:',
            'target': 'See you later!',
            'options': ['See you later!', 'Good morning!', 'Hello!'],
          },
          {
            'prompt': 'Listen & Pop:',
            'target': 'Have a nice day!',
            'options': ['Have a nice day!', 'I am hungry.', 'How are you?'],
          },
        ]
      },
    ),

    // 6. MOVERS 3–4: CUMLE KURMA (SENTENCE BUILDER)
    // Konu: Gunluk rutinler
    ActivityItem(
      id: 'movers_3_4',
      stage: 'Movers',
      stageNumber: '3–4',
      title: 'Daily Routines Builder',
      topic: 'Daily Routines',
      activityType: 'sentence_builder',
      emoji: '🧩',
      characterName: 'Gigi',
      characterQuote: 'Arrange the word cards in the right order!',
      gameData: {
        'sentences': [
          {
            'icon': '🚌',
            'words': ['I', 'go', 'to', 'school', 'by', 'bus'],
            'distractors': ['car', 'eat'],
            'correct': 'I go to school by bus',
          },
          {
            'icon': '🥞',
            'words': ['I', 'eat', 'breakfast', 'at', '8'],
            'distractors': ['sleep', 'the'],
            'correct': 'I eat breakfast at 8',
          },
          {
            'icon': '⏰',
            'words': ['I', 'get', 'up', 'at', '7'],
            'distractors': ['down', '9'],
            'correct': 'I get up at 7',
          },
          {
            'icon': '📝',
            'words': ['I', 'do', 'my', 'homework', 'after', 'school'],
            'distractors': ['play', 'morning'],
            'correct': 'I do my homework after school',
          },
          {
            'icon': '🛌',
            'words': ['I', 'go', 'to', 'bed', 'at', '9'],
            'distractors': ['park', 'walk'],
            'correct': 'I go to bed at 9',
          },
        ]
      },
    ),

    // 7. MOVERS 5–6: HAFIZA KARTLARI (MEMORY)
    // Konu: Aile uyeleri ve arkadaslar
    ActivityItem(
      id: 'movers_5_6',
      stage: 'Movers',
      stageNumber: '5–6',
      title: 'Family & Friends Memory',
      topic: 'Family & Friends',
      activityType: 'memory',
      emoji: '🃏',
      characterName: 'Gigi',
      characterQuote: 'Flip cards to match people with what they like!',
      gameData: {
        'cards': [
          {'pairId': 1, 'text': 'mother 👩', 'isPerson': true},
          {'pairId': 1, 'text': 'She likes cooking. 🍳', 'isPerson': false},
          {'pairId': 2, 'text': 'father 👨', 'isPerson': true},
          {'pairId': 2, 'text': 'He likes football. ⚽', 'isPerson': false},
          {'pairId': 3, 'text': 'brother 👦', 'isPerson': true},
          {'pairId': 3, 'text': 'He likes games. 🎮', 'isPerson': false},
          {'pairId': 4, 'text': 'sister 👧', 'isPerson': true},
          {'pairId': 4, 'text': 'She likes dancing. 💃', 'isPerson': false},
          {'pairId': 5, 'text': 'best friend 🤝', 'isPerson': true},
          {'pairId': 5, 'text': 'She likes music. 🎵', 'isPerson': false},
        ]
      },
    ),

    // 8. MOVERS 7–8: SURUKLE–BIRAK (DRAG & DROP)
    // Konu: Okul hayati, ders programi ve favori dersler
    ActivityItem(
      id: 'movers_7_8',
      stage: 'Movers',
      stageNumber: '7–8',
      title: 'School Schedule & Subjects',
      topic: 'School Schedule',
      activityType: 'drag_drop',
      emoji: '📅',
      characterName: 'Gigi',
      characterQuote: 'Drag each sentence to the matching school subject or day!',
      gameData: {
        'targets': [
          {'sentence': 'I have English on Monday.', 'icon': '🇬🇧'},
          {'sentence': 'Math is my favorite subject.', 'icon': '📐'},
          {'sentence': 'I like English.', 'icon': '⭐'},
          {'sentence': 'I have Science today.', 'icon': '🔬'},
          {'sentence': 'Art is fun.', 'icon': '🎨'},
          {'sentence': 'I have PE on Friday.', 'icon': '🏃'},
        ]
      },
    ),

    // =========================================================================
    // 3. SEVIYE: FLYERS (A2)
    // =========================================================================

    // 9. FLYERS 1–2: GIZLI NESNEYI BUL (HIDDEN OBJECT)
    // Konu: Kendini tanitma ve gunluk hayat
    ActivityItem(
      id: 'flyers_1_2',
      stage: 'Flyers',
      stageNumber: '1–2',
      title: 'Find Hidden Objects',
      topic: 'All About Me',
      activityType: 'hidden_object',
      emoji: '🔍',
      characterName: 'Gigi',
      characterQuote: 'Tap the hidden items in the room to discover facts about Alex!',
      gameData: {
        'objects': [
          {'name': 'Name Badge', 'icon': '🏷️', 'sentence': 'My name is Alex.'},
          {'name': 'Birthday Cake', 'icon': '🎂', 'sentence': 'I am ten years old.'},
          {'name': 'City Picture', 'icon': '🏙️', 'sentence': 'I live in a city.'},
          {'name': 'School Bag', 'icon': '🎒', 'sentence': 'I go to school.'},
          {'name': 'Football', 'icon': '⚽', 'sentence': 'I like playing football.'},
        ]
      },
    ),

    // 10. FLYERS 3–4: BOSLUGU DOLDUR (FILL IN THE BLANK)
    // Konu: Kisisel aliskanliklar ve hobiler
    ActivityItem(
      id: 'flyers_3_4',
      stage: 'Flyers',
      stageNumber: '3–4',
      title: 'Habits & Hobbies Detective',
      topic: 'Habits & Hobbies',
      activityType: 'fill_blank',
      emoji: '🔤',
      characterName: 'Gigi',
      characterQuote: 'Pick the correct missing word to complete the sentence!',
      gameData: {
        'questions': [
          {
            'sentence': 'I usually ___ TV after dinner.',
            'options': ['watch', 'read', 'eat'],
            'answer': 'watch',
            'icon': '📺',
          },
          {
            'sentence': 'I love ___ football.',
            'options': ['playing', 'sleeping', 'drinking'],
            'answer': 'playing',
            'icon': '⚽',
          },
          {
            'sentence': 'I ___ listen to music after school.',
            'options': ['usually', 'never', 'apple'],
            'answer': 'usually',
            'icon': '🎧',
          },
          {
            'sentence': 'I like ___ books.',
            'options': ['reading', 'flying', 'washing'],
            'answer': 'reading',
            'icon': '📚',
          },
          {
            'sentence': 'I play games ___ homework.',
            'options': ['after', 'under', 'blue'],
            'answer': 'after',
            'icon': '🎮',
          },
        ]
      },
    ),

    // 11. FLYERS 5–6: KONUS VE KAYDET (SPEAK & RECORD)
    // Konu: Aile, arkadaslar ve iliskiler
    ActivityItem(
      id: 'flyers_5_6',
      stage: 'Flyers',
      stageNumber: '5–6',
      title: 'Speak & Record Your Voice',
      topic: 'Family & Friends',
      activityType: 'speak_record',
      emoji: '🎙️',
      characterName: 'Gigi',
      characterQuote: 'Tap the microphone and say your answer in English!',
      gameData: {
        'prompts': [
          {
            'question': 'Tell me about your sister.',
            'suggested': 'My sister is very nice. She likes dancing.',
            'icon': '👧',
          },
          {
            'question': 'What does your brother like?',
            'suggested': 'My brother likes playing computer games.',
            'icon': '👦',
          },
          {
            'question': 'Who is your best friend?',
            'suggested': 'My best friend is Maya. We study together.',
            'icon': '🤝',
          },
          {
            'question': 'What does your mother do?',
            'suggested': 'My mother is a teacher and she cooks great food.',
            'icon': '👩',
          },
          {
            'question': 'What do you like doing with friends?',
            'suggested': 'I like playing football and riding bikes.',
            'icon': '🚲',
          },
        ]
      },
    ),
  ];

  static List<ActivityItem> getActivitiesByStage(String stage) {
    return activities.where((a) => a.stage.toLowerCase() == stage.toLowerCase()).toList();
  }
}
