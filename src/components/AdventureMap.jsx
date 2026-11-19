import React, { useState } from 'react';
import { CURRICULUM } from '../data/curriculum';
import { Illustration } from './Illustration';
import {
  Star,
  Play,
  Lock,
  Crown,
  Moon,
  Sun,
  Flame,
  Zap,
  Check,
  ChevronDown,
  BookOpen,
  Sparkles,
  Heart,
  Shirt,
  Award,
  Users
} from 'lucide-react';
import confetti from 'canvas-confetti';
import { sfx } from '../utils/audio';
import { useTheme } from '../context/ThemeContext';
import { usePremium } from '../context/PremiumContext';
import { MASCOT_IMAGES } from '../data/mascotImages';

import { SectionPickerModal } from './SectionPickerModal';
import { GuidebookModal } from './GuidebookModal';
import { LessonPreviewDrawer } from './LessonPreviewDrawer';
import { GigiClosetModal } from './GigiClosetModal';
import { StickerAlbumModal } from './StickerAlbumModal';
import { ParentZoneModal } from './ParentZoneModal';
import { ProfileSelectorModal } from './ProfileSelectorModal';
import { FeedGigiModal } from './FeedGigiModal';
import { useActiveProfile } from '../context/ProfileContext';
import { speakText } from '../utils/audio';

export function AdventureMap({
  stars = 0,
  completedActivityIds = [],
  onSelectActivity,
  onResetProgress,
  onSpendStars,
  onOpenSubscribe,
}) {
  const { isDark, toggleTheme } = useTheme();
  const {
    isVip,
    hearts,
    hasUnlimitedHearts,
    canAccessWorld,
  } = usePremium();

  const { profileName, profileAvatar } = useActiveProfile();
  const [selectedWorldId, setSelectedWorldId] = useState('starter');
  const [streakDays] = useState(3);
  const [energy] = useState(25);

  // Modals & Drawers state
  const [isProfileSelectorOpen, setIsProfileSelectorOpen] = useState(false);
  const [isFeedGigiOpen, setIsFeedGigiOpen] = useState(false);
  const [isSectionPickerOpen, setIsSectionPickerOpen] = useState(false);
  const [isGuidebookOpen, setIsGuidebookOpen] = useState(false);
  const [isClosetOpen, setIsClosetOpen] = useState(false);
  const [isStickersOpen, setIsStickersOpen] = useState(false);
  const [isParentZoneOpen, setIsParentZoneOpen] = useState(false);
  const [previewActivity, setPreviewActivity] = useState(null);
  const [chestOpened, setChestOpened] = useState(false);

  const worlds = [
    {
      id: 'starter',
      section: 'SECTION 1',
      unit: 'UNIT 1',
      title: 'Greetings & Daily Life',
      badge: 'Starter · Ages 4–6',
      emoji: '🌱',
      bannerBg: 'bg-[#58cc02] border-[#46a302]',
      color: 'bg-[#58cc02]',
      isVipOnly: false,
      activities: CURRICULUM.filter(a => a.worldId === 'starter'),
    },
    {
      id: 'movers',
      section: 'SECTION 2',
      unit: 'UNIT 2',
      title: 'Movers Quest & Friends',
      badge: 'Movers · Ages 6–8',
      emoji: '🚀',
      bannerBg: 'bg-[#1cb0f6] border-[#0f8fd4]',
      color: 'bg-[#1cb0f6]',
      isVipOnly: true,
      activities: CURRICULUM.filter(a => a.worldId === 'movers'),
    },
    {
      id: 'flyers',
      section: 'SECTION 3',
      unit: 'UNIT 3',
      title: 'Flyers Champions Stage',
      badge: 'Flyers · Ages 8–10',
      emoji: '🏆',
      bannerBg: 'bg-[#ce82ff] border-[#a855f7]',
      color: 'bg-[#ce82ff]',
      isVipOnly: true,
      activities: CURRICULUM.filter(a => a.worldId === 'flyers'),
    },
  ];

  const activeWorld = worlds.find(w => w.id === selectedWorldId) || worlds[0];
  const isWorldLocked = !canAccessWorld(activeWorld.id);

  // S-Curve horizontal X offsets for stepping nodes (Duolingo snake path)
  const getNodeOffset = (index) => {
    const offsets = [0, 48, 76, 48, 0, -48, -76, -48];
    return offsets[index % offsets.length];
  };

  const handleNodeClick = (act, isDone, isLocked, isVipLocked) => {
    if (isVipLocked) {
      sfx.playTap();
      onOpenSubscribe();
      return;
    }
    if (isLocked) {
      sfx.playWrong?.();
      return;
    }
    sfx.playTap();
    setPreviewActivity({ act, isDone, isLocked });
  };

  const handleCloudTap = (e) => {
    sfx.playTap();
    try {
      const rect = e.currentTarget.getBoundingClientRect();
      confetti({
        particleCount: 18,
        spread: 50,
        origin: {
          x: (rect.left + rect.width / 2) / window.innerWidth,
          y: (rect.top + rect.height / 2) / window.innerHeight,
        },
        colors: ['#38bdf8', '#fbbf24', '#f472b6', '#a855f7'],
        scalar: 0.8,
      });
    } catch {}
  };

  const handleGigiMascotTap = () => {
    sfx.playSuccess?.();
    speakText("Hello my friend! You are doing amazing in English! Keep it up! 🦒✨");
    try {
      confetti({
        particleCount: 25,
        spread: 60,
        origin: { y: 0.4 },
      });
    } catch {}
  };

  const handleOpenChest = () => {
    if (chestOpened) return;
    sfx.playVictory?.();
    setChestOpened(true);
    try {
      confetti({
        particleCount: 70,
        spread: 60,
        origin: { y: 0.6 }
      });
    } catch (e) {}
  };

  return (
    <div className={`min-h-screen select-none font-bubble pb-32 transition-colors duration-300 ${
      isDark ? 'bg-[#131f24] text-white' : 'bg-[#ffffff] text-slate-800'
    }`}>
      {/* ── Top Duolingo Sticky Header Bar ── */}
      <header className={`sticky top-0 z-30 px-3 py-2 border-b-2 transition-colors ${
        isDark ? 'bg-[#131f24]/95 border-[#37464f]' : 'bg-white/95 border-slate-200'
      } backdrop-blur-md`}>
        <div className="max-w-md mx-auto flex items-center justify-between">
          {/* Section / World Switcher Pill (Fixes clicking bug!) */}
          <button
            onClick={() => {
              sfx.playTap();
              setIsSectionPickerOpen(true);
            }}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-2xl border-2 transition-all active:scale-95 ${
              isDark
                ? 'bg-[#1f2c34] border-[#37464f] hover:border-slate-500 text-white'
                : 'bg-white border-slate-200 hover:border-slate-300 text-slate-800 shadow-2xs'
            }`}
          >
            <span className="text-base">{activeWorld.emoji}</span>
            <span className="text-xs font-black uppercase tracking-tight">
              {activeWorld.section.replace('SECTION ', 'S')} · {activeWorld.unit.replace('UNIT ', 'U')}
            </span>
            {isWorldLocked && (
              <Crown className="w-3 h-3 text-amber-400 fill-amber-400" />
            )}
            <ChevronDown className="w-3.5 h-3.5 text-slate-400 stroke-[3]" />
          </button>

          {/* Stats & Quick Perks Bar */}
          <div className="flex items-center gap-2 sm:gap-2.5">
            {/* Hearts counter: 5 or ∞ */}
            <div
              onClick={() => {
                sfx.playTap();
                onOpenSubscribe();
              }}
              className={`flex items-center gap-1 px-2.5 py-1.5 rounded-2xl border-2 border-b-4 cursor-pointer active:scale-95 transition-transform ${
                hasUnlimitedHearts
                  ? 'bg-amber-100 dark:bg-amber-950/70 border-amber-300 dark:border-amber-700 text-amber-800 dark:text-amber-300'
                  : 'bg-rose-50 dark:bg-rose-950/60 border-rose-200 dark:border-rose-800 text-rose-600 dark:text-rose-400'
              }`}
              title={hasUnlimitedHearts ? 'Unlimited Hearts (VIP)' : 'Hearts Remaining'}
            >
              <Heart className={`w-3.5 h-3.5 fill-current ${hasUnlimitedHearts ? 'animate-pulse' : ''}`} />
              <span className="text-xs font-black">
                {hasUnlimitedHearts ? '∞' : hearts}
              </span>
            </div>

            {/* Streak Flame */}
            <div className="flex items-center gap-1 font-black text-xs text-orange-500">
              <Flame className="w-3.5 h-3.5 fill-orange-500 animate-pulse" />
              <span>{streakDays}</span>
            </div>

            {/* Stars */}
            <div className="flex items-center gap-1 font-black text-xs text-amber-500">
              <Star className="w-3.5 h-3.5 fill-amber-400" />
              <span>{stars}</span>
            </div>

            {/* Dark Mode toggle */}
            <button
              onClick={() => {
                sfx.playTap();
                toggleTheme();
              }}
              className={`p-1.5 rounded-xl border transition-colors ${
                isDark
                  ? 'bg-[#1f2c34] border-[#37464f] text-amber-400'
                  : 'bg-slate-100 border-slate-200 text-indigo-600'
              }`}
              title="Toggle Dark/Light Mode"
            >
              {isDark ? <Sun className="w-4 h-4" /> : <Moon className="w-4 h-4" />}
            </button>
          </div>
        </div>
      </header>

      {/* ── Sub-header Quick VIP Perks & Profile Shortcuts Bar ── */}
      <div className="max-w-md mx-auto px-4 pt-3 grid grid-cols-5 gap-1 text-[11px] font-black">
        {/* Who's Playing / Kid Profile Switcher */}
        <button
          onClick={() => {
            sfx.playTap();
            setIsProfileSelectorOpen(true);
          }}
          className={`py-2 px-1 rounded-2xl border-2 flex flex-col items-center justify-center gap-0.5 transition-all active:scale-95 shadow-2xs ${
            isDark ? 'bg-[#1f2c34] border-[#37464f] text-slate-200' : 'bg-white border-slate-200 text-slate-700'
          }`}
          title="Switch Kid Profile (Who's Playing?)"
        >
          <span className="text-sm">{profileAvatar || '🦁'}</span>
          <span className="truncate max-w-[38px]">{profileName || 'Player'}</span>
        </button>

        {/* Feed Gigi Button */}
        <button
          onClick={() => {
            sfx.playTap();
            setIsFeedGigiOpen(true);
          }}
          className={`py-2 px-1 rounded-2xl border-2 flex flex-col items-center justify-center gap-0.5 transition-all active:scale-95 shadow-2xs ${
            isDark ? 'bg-[#1f2c34] border-[#37464f] text-slate-200' : 'bg-white border-slate-200 text-slate-700'
          }`}
          title="Feed & Care for Gigi"
        >
          <span className="text-sm">🍰</span>
          <span>Feed</span>
        </button>

        {/* Gigi Closet Button */}
        <button
          onClick={() => {
            sfx.playTap();
            setIsClosetOpen(true);
          }}
          className={`py-2 px-1 rounded-2xl border-2 flex flex-col items-center justify-center gap-0.5 transition-all active:scale-95 shadow-2xs ${
            isDark ? 'bg-[#1f2c34] border-[#37464f] text-slate-200' : 'bg-white border-slate-200 text-slate-700'
          }`}
        >
          <Shirt className="w-3.5 h-3.5 text-sky-500" />
          <span>Closet</span>
        </button>

        {/* Sticker Album Button */}
        <button
          onClick={() => {
            sfx.playTap();
            setIsStickersOpen(true);
          }}
          className={`py-2 px-1 rounded-2xl border-2 flex flex-col items-center justify-center gap-0.5 transition-all active:scale-95 shadow-2xs ${
            isDark ? 'bg-[#1f2c34] border-[#37464f] text-slate-200' : 'bg-white border-slate-200 text-slate-700'
          }`}
        >
          <span className="text-sm">🎨</span>
          <span>Stickers</span>
        </button>

        {/* Parent Zone Button */}
        <button
          onClick={() => {
            sfx.playTap();
            setIsParentZoneOpen(true);
          }}
          className={`py-2 px-1 rounded-2xl border-2 flex flex-col items-center justify-center gap-0.5 transition-all active:scale-95 shadow-2xs ${
            isDark ? 'bg-[#1f2c34] border-[#37464f] text-slate-200' : 'bg-white border-slate-200 text-slate-700'
          }`}
        >
          <span className="text-sm">👨‍👩‍👧</span>
          <span>Parents</span>
        </button>
      </div>

      {/* ── Main Container ── */}
      <main className="max-w-md mx-auto px-4 pt-3">
        {/* Unit Top Banner (Duolingo Style Solid Pill Banner) */}
        <div className={`w-full rounded-3xl p-5 text-white shadow-md mb-8 ${activeWorld.bannerBg} border-b-4 flex items-center justify-between relative overflow-hidden`}>
          <div>
            <div className="flex items-center gap-2">
              <span className="text-[11px] font-black uppercase tracking-wider text-white/90">
                {activeWorld.section} · {activeWorld.unit}
              </span>
              {isWorldLocked && (
                <span className="px-2 py-0.5 rounded-full bg-amber-400 text-amber-950 text-[9px] font-black uppercase flex items-center gap-1">
                  <Crown className="w-3 h-3 fill-current" /> VIP Level
                </span>
              )}
            </div>
            <h2 className="text-xl font-black mt-0.5 leading-tight">
              {activeWorld.title}
            </h2>
            <p className="text-xs text-white/80 font-bold mt-1">
              {activeWorld.badge}
            </p>
          </div>

          {/* Guidebook Button */}
          <button
            onClick={() => {
              sfx.playTap();
              setIsGuidebookOpen(true);
            }}
            className="w-12 h-12 rounded-2xl bg-white/20 hover:bg-white/30 backdrop-blur-md flex flex-col items-center justify-center text-white border border-white/30 shadow-xs transition-all active:scale-95 shrink-0"
            title="Open Unit Guidebook"
          >
            <BookOpen className="w-5 h-5 stroke-[2.5]" />
            <span className="text-[9px] font-black uppercase mt-0.5">Guide</span>
          </button>
        </div>

        {/* VIP Lock Banner for Movers & Flyers if Free */}
        {isWorldLocked && (
          <div
            onClick={onOpenSubscribe}
            className="mb-6 p-4 rounded-3xl border-2 border-amber-300 dark:border-amber-700 bg-gradient-to-r from-amber-100 to-yellow-100 dark:from-amber-950/60 dark:to-yellow-950/60 flex items-center justify-between cursor-pointer active:scale-98 transition-transform shadow-sm"
          >
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-2xl bg-amber-400 text-amber-950 flex items-center justify-center text-xl shadow-xs shrink-0">
                👑
              </div>
              <div>
                <h4 className="text-sm font-black text-amber-950 dark:text-amber-200">
                  Unlock {activeWorld.section} with VIP
                </h4>
                <p className="text-[11px] font-bold text-amber-800 dark:text-amber-400">
                  Tap to unlock intermediate and advanced levels!
                </p>
              </div>
            </div>
            <button className="px-3.5 py-1.5 rounded-xl duo-btn-green text-[10px] font-black uppercase tracking-wider shrink-0">
              Unlock
            </button>
          </div>
        )}

        {/* ── Interactive Clouds Floating in the Living World ── */}
        <div className="relative w-full h-8 flex justify-between px-2 mb-2 pointer-events-auto">
          <button
            onClick={handleCloudTap}
            title="Tap the magic cloud for sparkles! ✨"
            className="text-2xl animate-float active:scale-125 transition-transform cursor-pointer"
          >
            ☁️
          </button>
          <button
            onClick={handleCloudTap}
            title="Tap the magic cloud for sparkles! ✨"
            className="text-3xl animate-float active:scale-125 transition-transform cursor-pointer"
            style={{ animationDelay: '1.2s' }}
          >
            ☁️
          </button>
          <button
            onClick={handleCloudTap}
            title="Tap the magic cloud for sparkles! ✨"
            className="text-2xl animate-float active:scale-125 transition-transform cursor-pointer"
            style={{ animationDelay: '2.4s' }}
          >
            ☁️
          </button>
        </div>

        {/* ── Stepping Path (Duolingo S-Curve) ── */}
        <div className="relative flex flex-col items-center gap-8 py-6 select-none">
          {/* Animated Mascot Beside Path (Tap for Easter Egg) */}
          <div
            onClick={handleGigiMascotTap}
            title="Tap Gigi for a happy giggle! 🦒"
            className="absolute top-24 -right-2 sm:-right-4 w-28 h-28 z-10 animate-duo-bounce flex items-center justify-center cursor-pointer hover:scale-110 active:scale-95 transition-transform"
          >
            <img
              src={MASCOT_IMAGES.pointing}
              alt="Gigi"
              className="h-full w-full object-contain filter drop-shadow-md"
            />
          </div>

          {/* Second Mascot pose further down */}
          <div
            onClick={handleGigiMascotTap}
            title="Tap Gigi for a happy giggle! 🦒"
            className="absolute top-96 -left-3 sm:-left-5 w-24 h-24 z-10 animate-duo-bounce flex items-center justify-center cursor-pointer hover:scale-110 active:scale-95 transition-transform"
            style={{ animationDelay: '1s' }}
          >
            <img
              src={MASCOT_IMAGES.waving}
              alt="Gigi"
              className="h-full w-full object-contain filter drop-shadow-md"
            />
          </div>

          {/* Activity Nodes */}
          {activeWorld.activities.map((act, index) => {
            const isDone = completedActivityIds.includes(act.id);
            const isUnlocked = !isWorldLocked && (index === 0 || isDone || completedActivityIds.includes(activeWorld.activities[index - 1]?.id));
            const isCurrent = isUnlocked && !isDone;
            const isLocked = !isUnlocked;
            const xOffset = getNodeOffset(index);

            return (
              <React.Fragment key={act.id}>
                <div
                  className="relative flex flex-col items-center"
                  style={{ transform: `translateX(${xOffset}px)` }}
                >
                  {/* Floating "START!" bubble above active node */}
                  {isCurrent && (
                    <div className="absolute -top-11 z-20 animate-bounce">
                      <div className="bg-white dark:bg-[#1f2c34] text-slate-800 dark:text-white text-xs font-black px-3.5 py-1.5 rounded-2xl border-2 border-slate-300 dark:border-[#37464f] shadow-md flex items-center gap-1.5 whitespace-nowrap">
                        <span className="text-[#58cc02]">START!</span>
                      </div>
                      <div className="absolute -bottom-1.5 left-1/2 -translate-x-1/2 w-0 h-0 border-l-[6px] border-l-transparent border-r-[6px] border-r-transparent border-t-[6px] border-t-white dark:border-t-[#1f2c34]" />
                    </div>
                  )}

                  {/* 3D Round Node Button */}
                  <button
                    onClick={() => handleNodeClick(act, isDone, isLocked, isWorldLocked)}
                    className={`relative w-[76px] h-[76px] rounded-full flex flex-col items-center justify-center transition-all duration-150 select-none ${
                      isDone
                        ? 'duo-node-completed text-amber-950'
                        : isCurrent
                        ? 'duo-node-active text-white ring-pulse-duo'
                        : isWorldLocked
                        ? 'bg-amber-100 dark:bg-amber-950/60 border-2 border-amber-300 dark:border-amber-700 border-b-6 text-amber-600 cursor-pointer shadow-xs'
                        : 'duo-node-locked text-slate-400 cursor-not-allowed opacity-90'
                    }`}
                  >
                    {isDone ? (
                      <Check className="w-9 h-9 stroke-[4] text-amber-950" />
                    ) : isCurrent ? (
                      <div className="w-9 h-9 flex items-center justify-center">
                        <Illustration name={act.icon} className="w-full h-full" />
                      </div>
                    ) : isWorldLocked ? (
                      <div className="flex flex-col items-center text-amber-600 dark:text-amber-400">
                        <Crown className="w-6 h-6 fill-current mb-0.5" />
                        <span className="text-[8px] font-black uppercase">VIP</span>
                      </div>
                    ) : (
                      <Lock className="w-7 h-7 text-slate-400" />
                    )}
                  </button>

                  {/* Mini Activity Label Under the Node */}
                  <span className="text-[11px] font-black text-slate-600 dark:text-slate-400 mt-2 max-w-[120px] text-center truncate">
                    {act.shortTitle}
                  </span>

                  {/* 3 mini stars under completed nodes */}
                  {isDone && (
                    <div className="flex gap-0.5 mt-0.5">
                      <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-500" />
                      <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-500" />
                      <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-500" />
                    </div>
                  )}
                </div>

                {/* Duolingo Treasure Chest between lessons */}
                {index === 1 && (
                  <div
                    onClick={handleOpenChest}
                    className="relative flex flex-col items-center cursor-pointer my-2 active:scale-95 transition-transform"
                    style={{ transform: `translateX(${-xOffset * 0.5}px)` }}
                  >
                    <div className={`w-14 h-14 rounded-2xl flex items-center justify-center text-3xl shadow-md transition-all ${
                      chestOpened
                        ? 'bg-slate-200 dark:bg-slate-800 opacity-60'
                        : 'bg-amber-400 text-amber-950 ring-4 ring-amber-300 animate-pulse'
                    }`}>
                      {chestOpened ? '✨' : '🎁'}
                    </div>
                    <span className="text-[10px] font-black uppercase text-amber-500 mt-1">
                      {chestOpened ? 'Opened!' : 'Bonus Chest'}
                    </span>
                  </div>
                )}
              </React.Fragment>
            );
          })}
        </div>
      </main>

      {/* ── Section Picker Modal ── */}
      <SectionPickerModal
        isOpen={isSectionPickerOpen}
        onClose={() => setIsSectionPickerOpen(false)}
        worlds={worlds}
        selectedWorldId={selectedWorldId}
        onSelectWorld={(id) => setSelectedWorldId(id)}
      />

      {/* ── Guidebook Modal ── */}
      <GuidebookModal
        isOpen={isGuidebookOpen}
        onClose={() => setIsGuidebookOpen(false)}
        world={activeWorld}
      />

      {/* ── Gigi Closet Modal ── */}
      <GigiClosetModal
        isOpen={isClosetOpen}
        onClose={() => setIsClosetOpen(false)}
        onOpenSubscribe={onOpenSubscribe}
      />

      {/* ── Jungle Sticker Album Modal ── */}
      <StickerAlbumModal
        isOpen={isStickersOpen}
        onClose={() => setIsStickersOpen(false)}
        onOpenSubscribe={onOpenSubscribe}
      />

      {/* ── Parent Zone Modal ── */}
      <ParentZoneModal
        isOpen={isParentZoneOpen}
        onClose={() => setIsParentZoneOpen(false)}
        stars={stars}
        completedActivityIds={completedActivityIds}
        onOpenSubscribe={onOpenSubscribe}
      />

      {/* ── Feed Gigi Modal ── */}
      <FeedGigiModal
        isOpen={isFeedGigiOpen}
        onClose={() => setIsFeedGigiOpen(false)}
        stars={stars}
        onSpendStars={onSpendStars}
      />

      {/* ── Multi-Child Profile Selector Modal ("Who's Playing?") ── */}
      <ProfileSelectorModal
        isOpen={isProfileSelectorOpen}
        onClose={() => setIsProfileSelectorOpen(false)}
      />

      {/* ── Lesson Preview Drawer ── */}
      <LessonPreviewDrawer
        isOpen={!!previewActivity}
        onClose={() => setPreviewActivity(null)}
        activity={previewActivity?.act}
        isDone={previewActivity?.isDone}
        isLocked={previewActivity?.isLocked}
        onStart={(act) => onSelectActivity(act)}
      />
    </div>
  );
}
