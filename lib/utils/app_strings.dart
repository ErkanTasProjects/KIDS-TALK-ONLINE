class AppStrings {
  static String tr(String key, [bool? isTurkish]) {
    return _enMap[key] ?? key;
  }

  static const Map<String, String> _enMap = {
    // Navigation
    'nav_map': 'Map',
    'nav_quests': 'Quests',
    'nav_words': 'Words',
    'nav_club': 'Club',
    'nav_profile': 'Profile',

    // Top Header & Stats
    'app_name': 'KIDS TALK ONLINE 🦒',
    'world_title': 'English World',
    'xp': 'XP',
    'streak_days': 'Day Streak',
    'hearts': 'Hearts',
    'hearts_full': 'Full Hearts',

    // Home Screen
    'banner_title': 'English Adventure with Gigi! 🦒',
    'banner_subtitle': '3 Cambridge Stages • 24 Fun Missions',
    'stage_starter': 'Starter (Pre-A1)',
    'stage_movers': 'Movers (A1)',
    'stage_flyers': 'Flyers (A2)',
    'level': 'Level',
    'btn_start': 'START ⭐',
    'btn_replay': 'REPLAY 🔄',
    'btn_locked': 'LOCKED 🔒',
    'activities_count': 'Activities',
    'stage_progress': 'Stage Progress',

    // Quests Screen
    'quest_center': 'QUEST CENTER 🎯',
    'daily_adventures': 'Daily Adventures',
    'quest_header_desc': 'Complete quests, open the treasure chest and collect badges!',
    'weekly_chest': 'WEEKLY TREASURE CHEST 📦',
    'chest_ready': 'READY! ✨',
    'chest_opened': 'OPENED 💎',
    'stars_progress': 'Stars to Open Chest',
    'daily_quests': 'DAILY MISSIONS ⚡',
    'quest_1_title': 'Learn Daily Words',
    'quest_1_desc': 'Listen to 5 new English words',
    'quest_2_title': 'Complete 1 Activity',
    'quest_2_desc': 'Earn 3 stars in any mission',
    'quest_3_title': 'Collect 5 Stars',
    'quest_3_desc': 'Finish stages with excellence',
    'badges_title': 'CHARACTER BADGES 🏅',
    'chest_modal_title': '🎁 Treasure Chest Opened!',
    'chest_modal_desc': '+50 XP and "Super Star" Badge Earned!',
    'btn_awesome': 'AWESOME! ⭐',

    // Vocabulary Screen
    'vocab_title': 'Word Vault 📚',
    'vocab_subtitle': 'Listen and master words you unlocked!',
    'filter_all': 'All',
    'filter_animals': 'Animals',
    'filter_daily': 'Routines',
    'filter_school': 'School',
    'tap_to_listen': 'Tap to hear clear native English pronunciation',

    // Subscription / Club
    'club_title': 'Kids Talk Club ⭐',
    'club_subtitle': 'Unlimited fun learning with interactive adventures!',
    'plan_monthly': 'Monthly Explorer',
    'plan_yearly': 'Annual Champion (Best Value)',
    'feature_1': '✓ Unlimited daily learning adventures',
    'feature_2': '✓ Offline voice recognition & pronunciation',
    'feature_3': '✓ Parent progress & Cambridge YLE reports',
    'feature_4': '✓ Ad-free, 100% child-safe environment',
    'btn_subscribe': 'START 7-DAY FREE TRIAL 🚀',

    // Profile & Parent Settings
    'profile_title': 'Student Passport 🌟',
    'student_name': 'Star Explorer',
    'total_xp': 'Total XP',
    'stars_earned': 'Stars Won',
    'current_stage': 'Current Stage',
    'settings_title': 'PARENT & APP SETTINGS ⚙️',
    'app_language': 'App Language',
    'lang_en': 'English 🇬🇧 (Default)',
    'lang_tr': 'Turkish 🇹🇷',
    'speech_rate': 'Pronunciation Speed',
    'speech_slow': 'Slow 🐢',
    'speech_normal': 'Normal',
    'speech_fast': 'Fast 🐇',
    'test_audio': 'TEST PRONUNCIATION 🔊',
    'sound_effects': 'Fun Sound Effects',
    'sound_desc': 'Balloons, victory chimes and cheerful pops',
    'music_title': 'Background Adventure Music',
    'music_desc': 'Gentle melodic music for learning focus',
    'parent_gate_title': 'Parent Gate 🛡️',
    'parent_gate_desc': 'To enter the parent zone, please solve this math puzzle:',
    'parent_report_title': 'Cambridge YLE Progress Report 📊',
    'metric_completion': 'Stage Completion',
    'metric_listening': 'Listening Accuracy',
    'metric_vocabulary': 'Active Vocabulary',
    'metric_streak': 'Learning Streak',
    'btn_refill_hearts': 'REFILL 5 HEARTS ❤️',
    'hearts_refilled_msg': 'Hearts refilled successfully!',

    // Victory Dialog
    'victory_title': 'CONGRATULATIONS! 🎉',
    'victory_subtitle': 'Super job! Mission successfully completed!',
    'earned_stars': 'Stars Earned',
    'earned_xp': 'XP Gained',
    'btn_continue': 'CONTINUE ADVENTURE 🚀',

    // Welcome & Auth
    'welcome_headline': 'Welcome to\nKids Talk Online! ⭐',
    'welcome_tagline': '"Let\'s learn English together! ⭐"',
    'btn_get_started': 'GET STARTED 🚀',
    'btn_have_account': 'I ALREADY HAVE AN ACCOUNT',
    'login_title': 'Welcome Back!',
    'login_subtitle': 'Sign in to continue your English journey',
    'signup_title': 'Join the Adventure!',
    'signup_subtitle': 'Create your account and start exploring',
    'field_email': 'Email Address',
    'field_password': 'Password',
    'field_name': 'Student Name',
    'btn_login': 'LOG IN ⭐',
    'btn_signup': 'SIGN UP 🚀',
    'no_account': 'Don\'t have an account? Sign up',
    'already_account': 'Already have an account? Log in',
  };
}
