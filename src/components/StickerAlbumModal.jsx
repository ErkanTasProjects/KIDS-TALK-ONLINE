import React, { useState } from 'react';
import confetti from 'canvas-confetti';
import {
  X,
  Crown,
  Sparkles,
  Volume2,
  CheckCircle2,
  Lock,
  Star,
  Award,
  BookOpen,
  Trophy,
  Zap,
  HelpCircle
} from 'lucide-react';
import { usePremium } from '../context/PremiumContext';
import { speakText, sfx } from '../utils/audio';

const STICKER_COLLECTION = [
  // Page 1: Starter Explorer Badges (Free)
  {
    id: 'star',
    word: 'Star',
    phonics: 'S - T - A - R',
    emoji: '⭐',
    description: 'Awarded for earning your first gold stars in English!',
    sentence: 'You are a shining English superstar!',
    isVip: false,
    requiredStars: 3,
    color: 'from-amber-400 to-yellow-300',
    borderColor: 'border-amber-400',
  },
  {
    id: 'giraffe',
    word: 'Giraffe',
    phonics: 'G - I - R - A - F - F - E',
    emoji: '🦒',
    description: 'Gigi the Giraffe! Your cheerful English learning guide.',
    sentence: 'Gigi is a tall, friendly giraffe who loves speaking English!',
    isVip: false,
    requiredStars: 6,
    color: 'from-amber-500 to-orange-400',
    borderColor: 'border-orange-400',
  },
  {
    id: 'apple',
    word: 'Apple',
    phonics: 'A - P - P - L - E',
    emoji: '🍎',
    description: 'Crisp and sweet! Great for healthy English morning routines.',
    sentence: 'I eat a delicious red apple for breakfast.',
    isVip: false,
    requiredStars: 9,
    color: 'from-rose-500 to-red-400',
    borderColor: 'border-rose-400',
  },
  {
    id: 'balloon',
    word: 'Balloon',
    phonics: 'B - A - L - L - O - O - N',
    emoji: '🎈',
    description: 'Floating high in the sky! Pop it when you hear greetings.',
    sentence: 'The party balloon floats high in the blue sky.',
    isVip: false,
    requiredStars: 12,
    color: 'from-pink-500 to-rose-400',
    borderColor: 'border-pink-400',
  },
  {
    id: 'book',
    word: 'Book',
    phonics: 'B - O - O - K',
    emoji: '📚',
    description: 'Full of wonderful English stories and magical adventures.',
    sentence: 'I love reading English story books every day.',
    isVip: false,
    requiredStars: 15,
    color: 'from-sky-500 to-blue-400',
    borderColor: 'border-sky-400',
  },
  {
    id: 'pencil',
    word: 'Pencil',
    phonics: 'P - E - N - C - I - L',
    emoji: '✏️',
    description: 'Sharp and ready for tracing letters and writing words.',
    sentence: 'This is my pencil. I write and draw with it.',
    isVip: false,
    requiredStars: 18,
    color: 'from-emerald-500 to-teal-400',
    borderColor: 'border-emerald-400',
  },

  // Page 2: VIP Mythic Champions (VIP Exclusive)
  {
    id: 'trophy',
    word: 'Golden Trophy',
    phonics: 'T - R - O - P - H - Y',
    emoji: '🏆',
    description: 'VIP Grand Champion Cup for mastering English speaking!',
    sentence: 'Congratulations, you won the grand English champion trophy!',
    isVip: true,
    requiredStars: 20,
    color: 'from-yellow-400 to-amber-500',
    borderColor: 'border-yellow-400',
  },
  {
    id: 'unicorn',
    word: 'Rainbow Unicorn',
    phonics: 'U - N - I - C - O - R - N',
    emoji: '🦄',
    description: 'Mythical VIP companion with rainbow magic pronunciation!',
    sentence: 'The magical rainbow unicorn speaks English with pride.',
    isVip: true,
    requiredStars: 25,
    color: 'from-purple-400 to-pink-500',
    borderColor: 'border-purple-400',
  },
  {
    id: 'rocket',
    word: 'Space Rocket',
    phonics: 'R - O - C - K - E - T',
    emoji: '🚀',
    description: 'Blasts your English vocabulary to the moon and stars!',
    sentence: 'The space rocket zooms 3-2-1 blast off into the galaxy!',
    isVip: true,
    requiredStars: 30,
    color: 'from-sky-400 to-indigo-500',
    borderColor: 'border-sky-400',
  },
  {
    id: 'dragon',
    word: 'Magic Dragon',
    phonics: 'D - R - A - G - O - N',
    emoji: '🐉',
    description: 'Friendly guardian of the English vocabulary treasure!',
    sentence: 'The kind green dragon loves practicing English words.',
    isVip: true,
    requiredStars: 35,
    color: 'from-emerald-400 to-teal-600',
    borderColor: 'border-emerald-400',
  },
];

export function StickerAlbumModal({ isOpen, onClose, onOpenSubscribe }) {
  const { isVip, placedStickers, saveStickerPlacement } = usePremium();
  const [activeTab, setActiveTab] = useState('free'); // 'free' | 'vip'
  const [selectedBadge, setSelectedBadge] = useState(null);

  // Read current user stars
  const userStars = (() => {
    try {
      const s = localStorage.getItem('kids_talk_stars');
      return s ? parseInt(s, 10) : 0;
    } catch (e) {
      return 0;
    }
  })();

  // Collected sticker IDs are stored in localStorage or determined by stars & VIP
  const collectedIds = placedStickers && placedStickers.length > 0
    ? placedStickers.map(s => s.id || s)
    : STICKER_COLLECTION.filter(s => {
        if (s.isVip && !isVip) return false;
        return userStars >= s.requiredStars;
      }).map(s => s.id);

  if (!isOpen) return null;

  const filteredStickers = STICKER_COLLECTION.filter(s =>
    activeTab === 'vip' ? s.isVip : !s.isVip
  );

  const totalCollectedCount = STICKER_COLLECTION.filter(s => collectedIds.includes(s.id)).length;
  const progressPercent = Math.min(100, Math.round((totalCollectedCount / STICKER_COLLECTION.length) * 100));

  const handleCardClick = (sticker) => {
    sfx.playTap();
    if (sticker.isVip && !isVip) {
      onOpenSubscribe();
      return;
    }

    const isUnlocked = collectedIds.includes(sticker.id) || (userStars >= sticker.requiredStars && (!sticker.isVip || isVip));

    if (isUnlocked) {
      // Mark as collected if not yet
      if (!collectedIds.includes(sticker.id)) {
        const updated = [...collectedIds, sticker.id];
        saveStickerPlacement(updated);
        sfx.playVictory?.();
        try {
          confetti({ particleCount: 50, spread: 60, origin: { y: 0.6 } });
        } catch (e) {}
      } else {
        sfx.playSuccess?.();
      }

      setSelectedBadge(sticker);
      // Speak the English word and sentence
      speakText(`${sticker.word}! ${sticker.sentence}`);
    } else {
      sfx.playWrong?.();
      setSelectedBadge(sticker);
    }
  };

  const handleHearAudio = (badge) => {
    sfx.playTap();
    speakText(`${badge.word}! ${badge.sentence}`);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-4 bg-slate-900/80 backdrop-blur-md animate-fade-in font-bubble select-none">
      <div className="relative w-full max-w-xl bg-white dark:bg-[#1f2c34] rounded-3xl border-4 border-amber-300 dark:border-amber-500 shadow-2xl overflow-hidden flex flex-col max-h-[92vh]">
        {/* Header */}
        <div className="p-4 sm:p-5 border-b border-slate-200 dark:border-[#37464f] flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-amber-400 to-yellow-300 text-amber-950 flex items-center justify-center text-xl shadow-xs">
              🏅
            </div>
            <div>
              <h3 className="text-lg font-black text-slate-800 dark:text-white leading-tight">
                English Vocabulary Album &amp; Badges
              </h3>
              <p className="text-xs font-bold text-slate-400">
                Collect vocabulary stickers as you earn stars in lessons!
              </p>
            </div>
          </div>

          <button
            onClick={() => {
              sfx.playTap();
              onClose();
            }}
            className="p-2 rounded-full text-slate-400 hover:text-slate-600 dark:hover:text-white"
          >
            <X className="w-6 h-6 stroke-[2.5]" />
          </button>
        </div>

        {/* Milestone Progress Bar Header */}
        <div className="px-5 py-3.5 bg-gradient-to-r from-amber-50 to-yellow-50 dark:from-[#131f24] dark:to-[#1a252b] border-b border-slate-200 dark:border-[#37464f] flex items-center justify-between gap-4">
          <div className="flex-1">
            <div className="flex items-center justify-between text-xs font-black mb-1">
              <span className="text-amber-900 dark:text-amber-300 flex items-center gap-1.5">
                <Trophy className="w-4 h-4 text-amber-500 fill-amber-400" />
                Album Progress: {totalCollectedCount} of {STICKER_COLLECTION.length} Unlocked
              </span>
              <span className="text-amber-600 dark:text-amber-400">{progressPercent}%</span>
            </div>
            <div className="w-full h-3 rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-amber-400 to-[#58cc02] rounded-full transition-all duration-500"
                style={{ width: `${progressPercent}%` }}
              />
            </div>
          </div>

          <div className="shrink-0 flex items-center gap-1.5 px-3 py-1.5 rounded-2xl bg-amber-200/60 dark:bg-amber-950/60 border border-amber-300 dark:border-amber-800 text-amber-900 dark:text-amber-200 text-xs font-black">
            <Star className="w-4 h-4 fill-amber-400 text-amber-500" />
            <span>{userStars} Stars</span>
          </div>
        </div>

        {/* Tab Switcher: Starter vs VIP Mythics */}
        <div className="px-5 pt-3 pb-1 flex gap-2 border-b border-slate-200 dark:border-[#37464f] bg-slate-50 dark:bg-[#1f2c34]">
          <button
            onClick={() => {
              sfx.playTap();
              setActiveTab('free');
            }}
            className={`flex-1 py-2 rounded-xl text-xs font-black uppercase tracking-wider flex items-center justify-center gap-1.5 transition-all ${
              activeTab === 'free'
                ? 'bg-white dark:bg-[#2b3942] text-slate-800 dark:text-white shadow-xs border border-slate-200 dark:border-slate-700'
                : 'text-slate-400 hover:text-slate-600 dark:hover:text-slate-200'
            }`}
          >
            <span>🌿 Starter Badges (6)</span>
          </button>

          <button
            onClick={() => {
              sfx.playTap();
              setActiveTab('vip');
            }}
            className={`flex-1 py-2 rounded-xl text-xs font-black uppercase tracking-wider flex items-center justify-center gap-1.5 transition-all ${
              activeTab === 'vip'
                ? 'bg-gradient-to-r from-amber-400 to-yellow-300 text-amber-950 shadow-xs border border-amber-400'
                : 'text-amber-500 hover:text-amber-600'
            }`}
          >
            <Crown className="w-3.5 h-3.5 fill-current" />
            <span>VIP Mythic Badges (4)</span>
          </button>
        </div>

        {/* Sticker Cards Grid (Structured Educational Slots, Not Messy Piles) */}
        <div className="p-4 sm:p-5 overflow-y-auto grid grid-cols-2 sm:grid-cols-3 gap-3 flex-1">
          {filteredStickers.map((sticker) => {
            const isCollected = collectedIds.includes(sticker.id);
            const isUnlocked = isCollected || (userStars >= sticker.requiredStars && (!sticker.isVip || isVip));
            const isVipLocked = sticker.isVip && !isVip;

            return (
              <div
                key={sticker.id}
                onClick={() => handleCardClick(sticker)}
                className={`relative p-3.5 rounded-3xl border-2 flex flex-col items-center text-center transition-all cursor-pointer select-none active:scale-95 ${
                  isCollected
                    ? `bg-white dark:bg-[#233138] ${sticker.borderColor} shadow-md ring-2 ring-amber-300/30`
                    : isUnlocked
                    ? 'bg-emerald-50 dark:bg-emerald-950/40 border-[#58cc02] shadow-sm animate-pulse'
                    : 'bg-slate-50 dark:bg-slate-800/60 border-slate-200 dark:border-slate-700 opacity-60'
                }`}
              >
                {/* Status Badge in corner */}
                <div className="absolute top-2.5 right-2.5">
                  {isCollected ? (
                    <CheckCircle2 className="w-5 h-5 text-[#58cc02] fill-[#58cc02]/20" />
                  ) : isVipLocked ? (
                    <div className="px-1.5 py-0.5 rounded-md bg-amber-400 text-amber-950 text-[9px] font-black uppercase flex items-center gap-0.5">
                      <Crown className="w-2.5 h-2.5 fill-current" /> VIP
                    </div>
                  ) : isUnlocked ? (
                    <span className="px-2 py-0.5 rounded-full bg-[#58cc02] text-white text-[9px] font-black uppercase animate-bounce">
                      CLAIM!
                    </span>
                  ) : (
                    <Lock className="w-4 h-4 text-slate-400" />
                  )}
                </div>

                {/* Big Sticker Emoji / Icon */}
                <div className={`w-16 h-16 rounded-2xl flex items-center justify-center text-3xl my-2 shadow-xs transition-transform ${
                  isUnlocked
                    ? `bg-gradient-to-tr ${sticker.color} text-white scale-105`
                    : 'bg-slate-200 dark:bg-slate-700 text-slate-400 grayscale'
                }`}>
                  {sticker.emoji}
                </div>

                {/* Word Label & Phonics */}
                <h4 className="text-sm font-black text-slate-800 dark:text-white leading-snug">
                  {sticker.word}
                </h4>
                <p className="text-[10px] font-bold text-slate-400 dark:text-slate-400 uppercase tracking-wider">
                  {isUnlocked ? sticker.phonics : `Unlocks at ⭐ ${sticker.requiredStars}`}
                </p>

                {/* Audio button if collected */}
                {isCollected && (
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      handleHearAudio(sticker);
                    }}
                    className="mt-2 px-2.5 py-1 rounded-xl bg-sky-50 dark:bg-sky-900/40 text-[#1cb0f6] text-[10px] font-black uppercase flex items-center gap-1 hover:bg-sky-100 transition-colors"
                  >
                    <Volume2 className="w-3 h-3 stroke-[2.5]" />
                    <span>Listen</span>
                  </button>
                )}
              </div>
            );
          })}
        </div>

        {/* Selected Badge Flashcard Preview Bottom Drawer */}
        {selectedBadge && (
          <div className="p-4 bg-amber-50/90 dark:bg-slate-800 border-t-2 border-amber-300 dark:border-slate-700 animate-slide-up flex items-center justify-between gap-3">
            <div className="flex items-center gap-3">
              <span className="text-3xl">{selectedBadge.emoji}</span>
              <div>
                <div className="flex items-center gap-2">
                  <h4 className="text-sm font-black text-slate-800 dark:text-white">
                    "{selectedBadge.word}"
                  </h4>
                  <span className="text-[10px] font-bold text-amber-600 dark:text-amber-400 uppercase">
                    {selectedBadge.phonics}
                  </span>
                </div>
                <p className="text-xs font-semibold text-slate-600 dark:text-slate-300 max-w-xs line-clamp-1">
                  {selectedBadge.sentence}
                </p>
              </div>
            </div>

            <button
              onClick={() => handleHearAudio(selectedBadge)}
              className="px-3.5 py-2 rounded-xl duo-btn-blue text-xs font-black uppercase flex items-center gap-1.5 shrink-0"
            >
              <Volume2 className="w-4 h-4" />
              <span>Hear</span>
            </button>
          </div>
        )}

        {/* Footer */}
        <div className="p-4 border-t border-slate-200 dark:border-[#37464f] flex items-center justify-between bg-white dark:bg-[#1f2c34]">
          <p className="text-xs font-bold text-slate-400">
            Earn stars in English games to unlock all {STICKER_COLLECTION.length} collectible badges!
          </p>
          <button
            onClick={() => {
              sfx.playTap();
              onClose();
            }}
            className="px-6 py-2.5 rounded-2xl duo-btn-green font-black text-xs uppercase"
          >
            Done
          </button>
        </div>
      </div>
    </div>
  );
}
