import React from 'react';

export function Illustration({ name, className = "w-16 h-16" }) {
  switch (name) {
    // Greetings & Expressions
    case 'hello':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <circle cx="50" cy="50" r="45" fill="#FED7AA" />
          <circle cx="50" cy="45" r="35" fill="#FDBA74" />
          {/* Smiling face waving */}
          <circle cx="38" cy="40" r="4" fill="#431407" />
          <circle cx="62" cy="40" r="4" fill="#431407" />
          <path d="M 38 52 Q 50 64 62 52" stroke="#431407" strokeWidth="3" fill="none" strokeLinecap="round" />
          <ellipse cx="32" cy="46" rx="4" ry="2" fill="#FB7185" />
          <ellipse cx="68" cy="46" rx="4" ry="2" fill="#FB7185" />
          {/* Hand waving */}
          <path d="M 72 32 C 82 22 92 25 86 38 L 76 46" fill="#FDBA74" stroke="#EA580C" strokeWidth="2" strokeLinecap="round" />
        </svg>
      );
    case 'morning':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#BAE6FD" />
          {/* Horizon & Mountains */}
          <path d="M 0 75 Q 35 60 70 75 L 100 70 L 100 100 L 0 100 Z" fill="#86EFAC" />
          <path d="M 0 85 Q 50 75 100 85 L 100 100 L 0 100 Z" fill="#4ADE80" />
          {/* Rising Sun */}
          <circle cx="50" cy="58" r="24" fill="#FBBF24" />
          <circle cx="50" cy="58" r="28" stroke="#FDE047" strokeWidth="3" strokeDasharray="6,4" fill="none" />
          <circle cx="42" cy="54" r="2.5" fill="#78350F" />
          <circle cx="58" cy="54" r="2.5" fill="#78350F" />
          <path d="M 44 63 Q 50 68 56 63" stroke="#78350F" strokeWidth="2" fill="none" strokeLinecap="round" />
        </svg>
      );
    case 'afternoon':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FED7AA" />
          {/* Bright bright high sun */}
          <circle cx="50" cy="48" r="26" fill="#F59E0B" />
          <circle cx="50" cy="48" r="19" fill="#FDE047" />
          {/* Sun rays */}
          <g stroke="#F59E0B" strokeWidth="4" strokeLinecap="round">
            <line x1="50" y1="12" x2="50" y2="4" />
            <line x1="50" y1="84" x2="50" y2="92" />
            <line x1="16" y1="48" x2="8" y2="48" />
            <line x1="84" y1="48" x2="92" y2="48" />
            <line x1="26" y1="24" x2="20" y2="18" />
            <line x1="74" y1="72" x2="80" y2="78" />
            <line x1="74" y1="24" x2="80" y2="18" />
            <line x1="26" y1="72" x2="20" y2="78" />
          </g>
          {/* Cool sunglasses on sun */}
          <rect x="36" y="42" width="12" height="9" rx="2" fill="#1E293B" />
          <rect x="52" y="42" width="12" height="9" rx="2" fill="#1E293B" />
          <line x1="47" y1="46" x2="53" y2="46" stroke="#1E293B" strokeWidth="2" />
          <path d="M 44 56 Q 50 61 56 56" stroke="#B45309" strokeWidth="2" fill="none" strokeLinecap="round" />
        </svg>
      );
    case 'howareyou':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#DDD6FE" />
          <circle cx="50" cy="48" r="32" fill="#C4B5FD" />
          <circle cx="50" cy="48" r="28" fill="#FEF08A" />
          {/* Big smiling face with questioning eyebrows */}
          <circle cx="40" cy="45" r="4" fill="#312E81" />
          <circle cx="60" cy="45" r="4" fill="#312E81" />
          <path d="M 36 36 Q 40 33 44 36" stroke="#312E81" strokeWidth="2.5" fill="none" strokeLinecap="round" />
          <path d="M 56 34 Q 60 30 64 34" stroke="#312E81" strokeWidth="2.5" fill="none" strokeLinecap="round" />
          <path d="M 40 56 Q 50 66 60 56" stroke="#312E81" strokeWidth="3" fill="#F43F5E" strokeLinecap="round" />
          {/* Question mark bubble */}
          <circle cx="75" cy="22" r="14" fill="#6366F1" />
          <text x="75" y="27" textAnchor="middle" fill="#FFFFFF" fontSize="16" fontWeight="bold">?</text>
        </svg>
      );
    case 'goodbye':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FBCFE8" />
          <circle cx="50" cy="50" r="35" fill="#F472B6" />
          <circle cx="50" cy="50" r="30" fill="#FDF2F8" />
          {/* Cute waving hand with motion trails */}
          <g fill="#F472B6">
            <rect x="42" y="38" width="16" height="22" rx="4" />
            <rect x="36" y="44" width="7" height="12" rx="3" transform="rotate(-20 36 44)" />
            <rect x="42" y="30" width="4.5" height="14" rx="2" />
            <rect x="48" y="28" width="4.5" height="16" rx="2" />
            <rect x="54" y="30" width="4.5" height="14" rx="2" />
            <rect x="60" y="34" width="4.5" height="10" rx="2" />
          </g>
          {/* Motion trails */}
          <path d="M 28 32 C 26 38 26 46 30 52" stroke="#DB2777" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeDasharray="3,3" />
          <path d="M 72 32 C 74 38 74 46 70 52" stroke="#DB2777" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeDasharray="3,3" />
        </svg>
      );

    // Daily Activities
    case 'alarm':
    case 'wake_up':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FEF08A" />
          {/* Alarm bells */}
          <circle cx="28" cy="28" r="10" fill="#EF4444" />
          <circle cx="72" cy="28" r="10" fill="#EF4444" />
          {/* Clock body */}
          <circle cx="50" cy="55" r="32" fill="#F87171" />
          <circle cx="50" cy="55" r="26" fill="#FFFFFF" />
          {/* Clock feet */}
          <rect x="30" y="80" width="6" height="10" rx="2" fill="#B91C1C" transform="rotate(20 30 80)" />
          <rect x="64" y="80" width="6" height="10" rx="2" fill="#B91C1C" transform="rotate(-20 64 80)" />
          {/* Clock hands pointing at 7:00 */}
          <circle cx="50" cy="55" r="3" fill="#1E293B" />
          <line x1="50" y1="55" x2="50" y2="38" stroke="#1E293B" strokeWidth="3" strokeLinecap="round" />
          <line x1="50" y1="55" x2="38" y2="68" stroke="#EF4444" strokeWidth="2.5" strokeLinecap="round" />
          {/* Bell striker */}
          <rect x="47" y="20" width="6" height="7" fill="#991B1B" rx="1" />
        </svg>
      );
    case 'toothbrush':
    case 'brush_teeth':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#BAE6FD" />
          {/* Sparkles */}
          <path d="M 24 24 L 27 30 L 33 33 L 27 36 L 24 42 L 21 36 L 15 33 L 21 30 Z" fill="#38BDF8" />
          <path d="M 76 22 L 78 26 L 82 28 L 78 30 L 76 34 L 74 30 L 70 28 L 74 26 Z" fill="#38BDF8" />
          {/* Toothbrush angled */}
          <g transform="rotate(35 50 50)">
            <rect x="46" y="15" width="8" height="65" rx="4" fill="#0EA5E9" />
            <rect x="46" y="55" width="8" height="25" rx="4" fill="#38BDF8" />
            {/* Bristles */}
            <rect x="43" y="15" width="14" height="15" rx="2" fill="#FFFFFF" stroke="#0284C7" strokeWidth="1" />
            {/* Toothpaste swirl */}
            <path d="M 43 14 Q 50 6 57 14" stroke="#F43F5E" strokeWidth="4" fill="none" strokeLinecap="round" />
          </g>
          {/* Big smiling clean tooth */}
          <path d="M 28 62 C 28 52 40 50 44 56 C 48 50 60 52 60 62 C 60 74 54 86 44 86 C 34 86 28 74 28 62 Z" fill="#FFFFFF" stroke="#0284C7" strokeWidth="2" />
          <circle cx="38" cy="62" r="2" fill="#0369A1" />
          <circle cx="50" cy="62" r="2" fill="#0369A1" />
          <path d="M 40 70 Q 44 74 48 70" stroke="#0369A1" strokeWidth="1.5" fill="none" strokeLinecap="round" />
        </svg>
      );
    case 'pancakes':
    case 'eat_breakfast':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FED7AA" />
          {/* Plate */}
          <ellipse cx="50" cy="74" rx="42" ry="14" fill="#E2E8F0" />
          <ellipse cx="50" cy="73" rx="36" ry="10" fill="#FFFFFF" />
          {/* Pancakes stack */}
          <ellipse cx="50" cy="66" rx="30" ry="8" fill="#D97706" />
          <ellipse cx="50" cy="64" rx="29" ry="7" fill="#F59E0B" />
          <ellipse cx="50" cy="56" rx="28" ry="8" fill="#D97706" />
          <ellipse cx="50" cy="54" rx="27" ry="7" fill="#FBBF24" />
          <ellipse cx="50" cy="46" rx="26" ry="8" fill="#D97706" />
          <ellipse cx="50" cy="44" rx="25" ry="7" fill="#FDE047" />
          {/* Butter cube on top */}
          <polygon points="45,34 55,34 57,39 47,39" fill="#FEF08A" />
          <polygon points="45,34 47,39 47,44 45,39" fill="#FACC15" />
          <polygon points="47,39 57,39 57,44 47,44" fill="#EAB308" />
          {/* Syrup drip */}
          <path d="M 48 42 C 48 48 44 54 44 58 C 44 62 48 64 48 64" stroke="#B45309" strokeWidth="3" fill="none" strokeLinecap="round" />
        </svg>
      );
    case 'backpack':
    case 'go_to_school':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#BBF7D0" />
          {/* Backpack handle */}
          <path d="M 38 32 C 38 20 62 20 62 32" stroke="#15803D" strokeWidth="4" fill="none" strokeLinecap="round" />
          {/* Main bag */}
          <rect x="25" y="30" width="50" height="52" rx="14" fill="#22C55E" />
          {/* Front pocket */}
          <rect x="33" y="52" width="34" height="24" rx="8" fill="#16A34A" />
          {/* Zipper details */}
          <line x1="33" y1="52" x2="67" y2="52" stroke="#FEF08A" strokeWidth="2.5" />
          <circle cx="50" cy="52" r="3" fill="#EAB308" />
          {/* Side pockets */}
          <rect x="20" y="48" width="6" height="22" rx="3" fill="#15803D" />
          <rect x="74" y="48" width="6" height="22" rx="3" fill="#15803D" />
          {/* Cute patch */}
          <polygon points="50,60 53,65 59,65 54,69 56,75 50,71 44,75 46,69 41,65 47,65" fill="#FACC15" />
        </svg>
      );
    case 'park_slide':
    case 'play_park':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#E0F2FE" />
          {/* Grass base */}
          <path d="M 0 85 Q 50 80 100 85 L 100 100 L 0 100 Z" fill="#4ADE80" />
          {/* Ladder */}
          <line x1="28" y1="30" x2="28" y2="86" stroke="#0284C7" strokeWidth="4" />
          <line x1="20" y1="42" x2="36" y2="42" stroke="#0284C7" strokeWidth="3" />
          <line x1="20" y1="56" x2="36" y2="56" stroke="#0284C7" strokeWidth="3" />
          <line x1="20" y1="70" x2="36" y2="70" stroke="#0284C7" strokeWidth="3" />
          {/* Slide platform & chute */}
          <rect x="26" y="28" width="16" height="5" fill="#EF4444" rx="2" />
          <path d="M 38 30 C 44 32 50 50 62 68 C 70 80 82 85 86 85" stroke="#F87171" strokeWidth="10" fill="none" strokeLinecap="round" />
          <path d="M 38 30 C 44 32 50 50 62 68 C 70 80 82 85 86 85" stroke="#EF4444" strokeWidth="6" fill="none" strokeLinecap="round" />
          {/* Support pole */}
          <line x1="62" y1="68" x2="62" y2="86" stroke="#94A3B8" strokeWidth="3" />
        </svg>
      );

    // School Objects
    case 'bag':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FEF3C7" />
          <path d="M 36 28 C 36 18 64 18 64 28" stroke="#D97706" strokeWidth="4" fill="none" strokeLinecap="round" />
          <rect x="24" y="28" width="52" height="54" rx="12" fill="#F59E0B" />
          <rect x="32" y="50" width="36" height="24" rx="6" fill="#D97706" />
          <circle cx="50" cy="50" r="3" fill="#FEF08A" />
        </svg>
      );
    case 'book':
    case 'read_book':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#E0E7FF" />
          {/* Open Book */}
          <path d="M 50 75 C 40 70 24 70 14 74 L 14 36 C 24 32 40 32 50 37 C 60 32 76 32 86 36 L 86 74 C 76 70 60 70 50 75 Z" fill="#6366F1" />
          {/* Pages */}
          <path d="M 48 72 C 38 67 25 67 16 71 L 16 38 C 25 34 38 34 48 39 Z" fill="#FFFFFF" />
          <path d="M 52 72 C 62 67 75 67 84 71 L 84 38 C 75 34 62 34 52 39 Z" fill="#FFFFFF" />
          {/* Page text lines */}
          <line x1="22" y1="46" x2="42" y2="46" stroke="#CBD5E1" strokeWidth="2" strokeLinecap="round" />
          <line x1="22" y1="52" x2="40" y2="52" stroke="#CBD5E1" strokeWidth="2" strokeLinecap="round" />
          <line x1="22" y1="58" x2="36" y2="58" stroke="#CBD5E1" strokeWidth="2" strokeLinecap="round" />
          <line x1="58" y1="46" x2="78" y2="46" stroke="#CBD5E1" strokeWidth="2" strokeLinecap="round" />
          <line x1="58" y1="52" x2="76" y2="52" stroke="#CBD5E1" strokeWidth="2" strokeLinecap="round" />
          <line x1="58" y1="58" x2="72" y2="58" stroke="#CBD5E1" strokeWidth="2" strokeLinecap="round" />
        </svg>
      );
    case 'pencil':
    case 'write':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FEF9C3" />
          <g transform="rotate(45 50 50)">
            {/* Eraser */}
            <rect x="42" y="14" width="16" height="14" rx="3" fill="#F43F5E" />
            <rect x="42" y="24" width="16" height="6" fill="#94A3B8" />
            {/* Body */}
            <rect x="42" y="30" width="16" height="42" fill="#FACC15" />
            <line x1="47" y1="30" x2="47" y2="72" stroke="#EAB308" strokeWidth="2" />
            <line x1="53" y1="30" x2="53" y2="72" stroke="#CA8A04" strokeWidth="2" />
            {/* Tip */}
            <polygon points="42,72 58,72 50,86" fill="#FED7AA" />
            <polygon points="47,81 53,81 50,86" fill="#1E293B" />
          </g>
        </svg>
      );
    case 'ruler':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#DCFCE7" />
          <g transform="rotate(-30 50 50)">
            <rect x="20" y="40" width="60" height="20" rx="4" fill="#3B82F6" stroke="#1D4ED8" strokeWidth="2" />
            {/* Measurement lines */}
            <line x1="26" y1="40" x2="26" y2="48" stroke="#FFFFFF" strokeWidth="2" />
            <line x1="32" y1="40" x2="32" y2="45" stroke="#FFFFFF" strokeWidth="1.5" />
            <line x1="38" y1="40" x2="38" y2="48" stroke="#FFFFFF" strokeWidth="2" />
            <line x1="44" y1="40" x2="44" y2="45" stroke="#FFFFFF" strokeWidth="1.5" />
            <line x1="50" y1="40" x2="50" y2="48" stroke="#FFFFFF" strokeWidth="2" />
            <line x1="56" y1="40" x2="56" y2="45" stroke="#FFFFFF" strokeWidth="1.5" />
            <line x1="62" y1="40" x2="62" y2="48" stroke="#FFFFFF" strokeWidth="2" />
            <line x1="68" y1="40" x2="68" y2="45" stroke="#FFFFFF" strokeWidth="1.5" />
            <line x1="74" y1="40" x2="74" y2="48" stroke="#FFFFFF" strokeWidth="2" />
          </g>
        </svg>
      );
    case 'notebook':
    case 'study_english':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FCE7F3" />
          {/* Spiral notebook */}
          <rect x="28" y="20" width="52" height="64" rx="6" fill="#EC4899" />
          <rect x="34" y="24" width="42" height="56" rx="4" fill="#FFFFFF" />
          {/* Spirals */}
          <circle cx="28" cy="30" r="3" fill="#475569" />
          <circle cx="28" cy="42" r="3" fill="#475569" />
          <circle cx="28" cy="54" r="3" fill="#475569" />
          <circle cx="28" cy="66" r="3" fill="#475569" />
          <circle cx="28" cy="74" r="3" fill="#475569" />
          {/* ABC header on notebook */}
          <text x="55" y="46" textAnchor="middle" fill="#EC4899" fontSize="16" fontWeight="bold">ABC</text>
          <line x1="40" y1="56" x2="70" y2="56" stroke="#F472B6" strokeWidth="2" strokeLinecap="round" />
          <line x1="40" y1="64" x2="66" y2="64" stroke="#F472B6" strokeWidth="2" strokeLinecap="round" />
        </svg>
      );
    case 'draw':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FFEDD5" />
          {/* Paint palette */}
          <path d="M 50 18 C 30 18 16 32 16 52 C 16 70 28 82 46 82 C 54 82 58 76 58 70 C 58 66 60 62 66 62 C 76 62 84 56 84 46 C 84 30 68 18 50 18 Z" fill="#F97316" />
          <circle cx="32" cy="36" r="5" fill="#EF4444" />
          <circle cx="50" cy="28" r="5" fill="#FACC15" />
          <circle cx="68" cy="36" r="5" fill="#3B82F6" />
          <circle cx="72" cy="52" r="5" fill="#10B981" />
          {/* Thumb hole */}
          <ellipse cx="36" cy="66" rx="6" ry="8" fill="#FFEDD5" />
        </svg>
      );
    case 'play':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#CCFBF1" />
          {/* Soccer ball */}
          <circle cx="50" cy="50" r="32" fill="#FFFFFF" stroke="#0F766E" strokeWidth="3" />
          <polygon points="50,38 58,44 55,54 45,54 42,44" fill="#0F766E" />
          <line x1="50" y1="38" x2="50" y2="22" stroke="#0F766E" strokeWidth="2.5" />
          <line x1="58" y1="44" x2="74" y2="38" stroke="#0F766E" strokeWidth="2.5" />
          <line x1="55" y1="54" x2="68" y2="68" stroke="#0F766E" strokeWidth="2.5" />
          <line x1="45" y1="54" x2="32" y2="68" stroke="#0F766E" strokeWidth="2.5" />
          <line x1="42" y1="44" x2="26" y2="38" stroke="#0F766E" strokeWidth="2.5" />
        </svg>
      );

    // Family Members
    case 'mother':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FCE7F3" />
          <circle cx="50" cy="46" r="24" fill="#FED7AA" />
          {/* Brown wavy hair */}
          <path d="M 26 44 C 26 26 36 20 50 20 C 64 20 74 26 74 44 C 74 54 70 64 66 64 C 64 56 64 42 60 38 C 54 38 46 38 40 38 C 36 42 36 56 34 64 C 30 64 26 54 26 44 Z" fill="#78350F" />
          {/* Face */}
          <circle cx="44" cy="46" r="2.5" fill="#451A03" />
          <circle cx="56" cy="46" r="2.5" fill="#451A03" />
          <path d="M 46 54 Q 50 58 54 54" stroke="#E11D48" strokeWidth="2" fill="none" strokeLinecap="round" />
          <ellipse cx="40" cy="50" rx="3" ry="1.5" fill="#FB7185" />
          <ellipse cx="60" cy="50" rx="3" ry="1.5" fill="#FB7185" />
          {/* Dress */}
          <path d="M 32 86 C 32 70 42 66 50 66 C 58 66 68 70 68 86 Z" fill="#EC4899" />
          {/* Pearl necklace */}
          <circle cx="46" cy="68" r="2" fill="#FFFFFF" />
          <circle cx="50" cy="69" r="2" fill="#FFFFFF" />
          <circle cx="54" cy="68" r="2" fill="#FFFFFF" />
        </svg>
      );
    case 'father':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#E0F2FE" />
          <circle cx="50" cy="46" r="24" fill="#FED7AA" />
          {/* Short neat hair */}
          <path d="M 28 42 C 28 26 38 22 50 22 C 62 22 72 26 72 42 C 72 34 64 28 50 28 C 36 28 28 34 28 42 Z" fill="#1E293B" />
          {/* Friendly glasses */}
          <rect x="36" y="42" width="10" height="8" rx="2" stroke="#0284C7" strokeWidth="2" fill="none" />
          <rect x="54" y="42" width="10" height="8" rx="2" stroke="#0284C7" strokeWidth="2" fill="none" />
          <line x1="46" y1="46" x2="54" y2="46" stroke="#0284C7" strokeWidth="2" />
          <circle cx="41" cy="46" r="2" fill="#0F172A" />
          <circle cx="59" cy="46" r="2" fill="#0F172A" />
          <path d="M 45 56 Q 50 60 55 56" stroke="#0F172A" strokeWidth="2" fill="none" strokeLinecap="round" />
          {/* Blue shirt & tie */}
          <path d="M 32 86 C 32 72 40 68 50 68 C 60 68 68 72 68 86 Z" fill="#0284C7" />
          <polygon points="50,68 53,74 51,86 49,86 47,74" fill="#EF4444" />
        </svg>
      );
    case 'brother':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FEF3C7" />
          <circle cx="50" cy="48" r="22" fill="#FED7AA" />
          {/* Cap turned backwards */}
          <path d="M 28 40 C 28 28 40 22 56 24 C 68 25 72 34 72 42 L 28 40 Z" fill="#EF4444" />
          <path d="M 68 36 L 82 38" stroke="#EF4444" strokeWidth="4" strokeLinecap="round" />
          {/* Boy face */}
          <circle cx="43" cy="48" r="2.5" fill="#1E293B" />
          <circle cx="57" cy="48" r="2.5" fill="#1E293B" />
          <path d="M 44 56 Q 50 62 56 56" stroke="#1E293B" strokeWidth="2.5" fill="#F43F5E" strokeLinecap="round" />
          {/* Green hoodie */}
          <path d="M 30 86 C 30 72 40 68 50 68 C 60 68 70 72 70 86 Z" fill="#10B981" />
        </svg>
      );
    case 'sister':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FEE2E2" />
          <circle cx="50" cy="48" r="22" fill="#FED7AA" />
          {/* Pigtails */}
          <circle cx="26" cy="42" r="10" fill="#F59E0B" />
          <circle cx="74" cy="42" r="10" fill="#F59E0B" />
          {/* Hair band */}
          <circle cx="32" cy="44" r="3" fill="#EC4899" />
          <circle cx="68" cy="44" r="3" fill="#EC4899" />
          <path d="M 32 38 C 36 26 48 24 50 24 C 52 24 64 26 68 38 Z" fill="#F59E0B" />
          {/* Cheerful girl face */}
          <circle cx="43" cy="48" r="2.5" fill="#78350F" />
          <circle cx="57" cy="48" r="2.5" fill="#78350F" />
          <path d="M 44 56 Q 50 62 56 56" stroke="#78350F" strokeWidth="2" fill="none" strokeLinecap="round" />
          <ellipse cx="38" cy="52" rx="3" ry="1.5" fill="#FB7185" />
          <ellipse cx="62" cy="52" rx="3" ry="1.5" fill="#FB7185" />
          {/* Yellow dress */}
          <path d="M 32 86 C 32 72 40 68 50 68 C 60 68 68 72 68 86 Z" fill="#FBBF24" />
        </svg>
      );
    case 'grandmother':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#EDE9FE" />
          <circle cx="50" cy="48" r="22" fill="#FED7AA" />
          {/* Gray hair bun */}
          <circle cx="50" cy="22" r="12" fill="#94A3B8" />
          <path d="M 28 42 C 28 26 38 24 50 24 C 62 24 72 26 72 42 Z" fill="#CBD5E1" />
          {/* Round granny spectacles */}
          <circle cx="42" cy="48" r="5" stroke="#7C3AED" strokeWidth="2" fill="none" />
          <circle cx="58" cy="48" r="5" stroke="#7C3AED" strokeWidth="2" fill="none" />
          <line x1="47" y1="48" x2="53" y2="48" stroke="#7C3AED" strokeWidth="2" />
          <circle cx="42" cy="48" r="2" fill="#4B5563" />
          <circle cx="58" cy="48" r="2" fill="#4B5563" />
          <path d="M 46 58 Q 50 61 54 58" stroke="#4B5563" strokeWidth="2" fill="none" strokeLinecap="round" />
          {/* Purple cardigan */}
          <path d="M 30 86 C 30 70 40 68 50 68 C 60 68 70 70 70 86 Z" fill="#8B5CF6" />
        </svg>
      );
    case 'friend':
    case 'best_friend':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#CCFBF1" />
          {/* Two best buddies hugging */}
          <circle cx="38" cy="44" r="16" fill="#FED7AA" />
          <path d="M 24 38 C 24 28 32 26 42 26 C 46 26 50 28 50 36 Z" fill="#B45309" />
          <circle cx="34" cy="44" r="2" fill="#451A03" />
          <circle cx="44" cy="44" r="2" fill="#451A03" />
          <path d="M 36 50 Q 39 53 42 50" stroke="#451A03" strokeWidth="1.5" fill="none" />
          
          <circle cx="62" cy="46" r="16" fill="#FCD34D" />
          <path d="M 50 40 C 50 30 58 28 68 28 C 76 28 78 34 78 40 Z" fill="#1E293B" />
          <circle cx="58" cy="46" r="2" fill="#1E293B" />
          <circle cx="68" cy="46" r="2" fill="#1E293B" />
          <path d="M 60 52 Q 63 55 66 52" stroke="#1E293B" strokeWidth="1.5" fill="none" />
          {/* Shared hearts */}
          <path d="M 50 20 C 47 16 43 18 45 22 L 50 26 L 55 22 C 57 18 53 16 50 20 Z" fill="#EF4444" />
          <path d="M 24 86 C 24 66 40 64 50 64 C 60 64 76 66 76 86 Z" fill="#0D9488" />
        </svg>
      );

    // School Life & Subjects
    case 'math':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FEF08A" />
          <rect x="20" y="20" width="60" height="60" rx="10" fill="#EAB308" />
          <text x="36" y="44" fill="#FFFFFF" fontSize="22" fontWeight="bold">+</text>
          <text x="60" y="44" fill="#FFFFFF" fontSize="22" fontWeight="bold">−</text>
          <text x="36" y="68" fill="#FFFFFF" fontSize="20" fontWeight="bold">×</text>
          <text x="60" y="68" fill="#FFFFFF" fontSize="20" fontWeight="bold">÷</text>
        </svg>
      );
    case 'english':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#E0E7FF" />
          <rect x="22" y="22" width="56" height="56" rx="12" fill="#4F46E5" />
          <text x="50" y="58" textAnchor="middle" fill="#FFFFFF" fontSize="22" fontWeight="bold">EN</text>
          <polygon points="50,28 54,36 63,36 56,41 59,49 50,44 41,49 44,41 37,36 46,36" fill="#FDE047" />
        </svg>
      );
    case 'science':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#CFFAFE" />
          {/* Flask */}
          <path d="M 44 26 L 56 26 L 56 42 L 72 68 C 76 74 72 80 64 80 L 36 80 C 28 80 24 74 28 68 L 44 42 Z" fill="#06B6D4" stroke="#0891B2" strokeWidth="3" />
          <path d="M 32 74 C 36 66 64 66 68 74 Z" fill="#67E8F9" />
          {/* Bubbles */}
          <circle cx="50" cy="62" r="3" fill="#FFFFFF" />
          <circle cx="42" cy="70" r="2.5" fill="#FFFFFF" />
          <circle cx="58" cy="68" r="4" fill="#FFFFFF" />
          <circle cx="50" cy="36" r="2" fill="#FFFFFF" />
        </svg>
      );
    case 'art':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FCE7F3" />
          <path d="M 50 20 C 30 20 18 34 18 52 C 18 70 30 80 48 80 C 56 80 60 74 60 68 C 60 64 64 60 70 60 C 78 60 84 54 84 44 C 84 30 68 20 50 20 Z" fill="#F43F5E" />
          <circle cx="34" cy="38" r="4.5" fill="#FDE047" />
          <circle cx="52" cy="32" r="4.5" fill="#38BDF8" />
          <circle cx="68" cy="40" r="4.5" fill="#4ADE80" />
        </svg>
      );
    case 'pe':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#FFEDD5" />
          <circle cx="50" cy="50" r="30" fill="#EA580C" />
          <path d="M 50 20 L 50 80" stroke="#FFFFFF" strokeWidth="2.5" />
          <path d="M 20 50 L 80 50" stroke="#FFFFFF" strokeWidth="2.5" />
          <path d="M 30 28 C 40 40 40 60 30 72" stroke="#FFFFFF" strokeWidth="2.5" fill="none" />
          <path d="M 70 28 C 60 40 60 60 70 72" stroke="#FFFFFF" strokeWidth="2.5" fill="none" />
        </svg>
      );
    case 'monday':
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#DDD6FE" />
          {/* Calendar */}
          <rect x="22" y="24" width="56" height="56" rx="10" fill="#8B5CF6" />
          <rect x="22" y="24" width="56" height="18" rx="8" fill="#6D28D9" />
          <line x1="34" y1="18" x2="34" y2="28" stroke="#FFFFFF" strokeWidth="3" strokeLinecap="round" />
          <line x1="66" y1="18" x2="66" y2="28" stroke="#FFFFFF" strokeWidth="3" strokeLinecap="round" />
          <text x="50" y="62" textAnchor="middle" fill="#FFFFFF" fontSize="22" fontWeight="bold">MON</text>
        </svg>
      );

    default:
      return (
        <svg viewBox="0 0 100 100" className={className}>
          <rect width="100" height="100" rx="20" fill="#E2E8F0" />
          <circle cx="50" cy="50" r="24" fill="#94A3B8" />
          <text x="50" y="58" textAnchor="middle" fill="#FFFFFF" fontSize="24" fontWeight="bold">★</text>
        </svg>
      );
  }
}

