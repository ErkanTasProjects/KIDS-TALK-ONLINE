import React, { useState } from 'react';
import { X, Star, Moon, Sun, Crown, Heart, Flame } from 'lucide-react';
import { sfx, speakText } from '../utils/audio';
import { useTheme } from '../context/ThemeContext';
import { usePremium } from '../context/PremiumContext';

export function HeaderZone({
  currentStep = 1,
  totalSteps = 5,
  stars = 0,
  onClose,
  title = '',
  onOpenSubscribe,
}) {
  const percentage = Math.min(100, Math.max(0, (currentStep / totalSteps) * 100));
  const { isDark, toggleTheme } = useTheme();
  const { isVip, hearts, hasUnlimitedHearts } = usePremium();

  const [streakDays] = useState(() => {
    try {
      const saved = localStorage.getItem('kids_talk_streak_days');
      return saved ? parseInt(saved, 10) : 3;
    } catch {
      return 3;
    }
  });

  const handleStreakTap = () => {
    sfx.playTap();
    speakText(`You have a ${streakDays} day learning streak! Keep it burning!`);
  };

  const handleClose = () => {
    sfx.playTap();
    if (onClose) onClose();
  };

  const handleToggleTheme = () => {
    sfx.playTap();
    toggleTheme();
  };

  return (
    <header className="h-16 w-full max-w-4xl mx-auto px-4 flex items-center justify-between gap-3 select-none">
      {/* Left: Circular Close Button */}
      <button
        onClick={handleClose}
        aria-label="Back to Adventure Map"
        className="w-10 h-10 rounded-full bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 border-b-4 hover:bg-slate-100 dark:hover:bg-slate-700 active:translate-y-0.5 active:border-b-2 flex items-center justify-center text-slate-500 dark:text-slate-300 transition-all shadow-sm shrink-0"
      >
        <X className="w-5 h-5 stroke-[2.5]" />
      </button>

      {/* Center: Thick segmented progress bar */}
      <div className="flex-1 flex flex-col items-center max-w-md">
        <div className="w-full h-4 bg-slate-200 dark:bg-slate-700 rounded-full p-0.5 relative overflow-hidden shadow-inner">
          <div
            className="h-full bg-gradient-to-r from-emerald-400 to-emerald-500 rounded-full transition-all duration-500 ease-out shadow-sm relative"
            style={{ width: `${percentage}%` }}
          >
            <div className="absolute top-0 left-0 right-0 h-1 bg-white/40 rounded-full"></div>
          </div>
        </div>
        {title && (
          <span className="text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider mt-0.5 truncate">
            {title} ({currentStep}/{totalSteps})
          </span>
        )}
      </div>

      {/* Right Controls: Hearts + Dark Mode Toggle + VIP Crown + Star Badge */}
      <div className="flex items-center gap-2 shrink-0">
        {/* Daily Streak Flame */}
        <div
          onClick={handleStreakTap}
          className="flex items-center gap-1 font-black text-xs text-orange-500 bg-orange-50 dark:bg-orange-950/60 border-2 border-orange-200 dark:border-orange-800 border-b-4 px-2 py-1.5 rounded-2xl cursor-pointer active:scale-95 transition-transform"
          title={`${streakDays} Day Learning Streak!`}
        >
          <Flame className="w-3.5 h-3.5 fill-orange-500 text-orange-500 animate-pulse" />
          <span>{streakDays}</span>
        </div>

        {/* Hearts counter (5 or ∞) */}
        <div
          onClick={onOpenSubscribe}
          className={`flex items-center gap-1 px-2.5 py-1.5 rounded-2xl border-2 border-b-4 cursor-pointer active:scale-95 transition-transform ${
            hasUnlimitedHearts
              ? 'bg-amber-100 dark:bg-amber-950/70 border-amber-300 dark:border-amber-700 text-amber-800 dark:text-amber-300'
              : 'bg-rose-50 dark:bg-rose-950/60 border-rose-200 dark:border-rose-800 text-rose-600 dark:text-rose-400'
          }`}
          title={hasUnlimitedHearts ? 'Unlimited VIP Hearts' : 'Hearts Remaining'}
        >
          <Heart className={`w-4 h-4 fill-current ${hasUnlimitedHearts ? 'animate-pulse' : ''}`} />
          <span className="text-xs font-black">
            {hasUnlimitedHearts ? '∞' : hearts}
          </span>
        </div>

        {/* Dark Mode toggle */}
        <button
          onClick={handleToggleTheme}
          aria-label="Toggle Dark / Light Theme"
          className="w-9 h-9 rounded-2xl bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 border-b-4 hover:bg-slate-100 dark:hover:bg-slate-700 text-amber-500 dark:text-amber-400 flex items-center justify-center transition-all shadow-sm"
        >
          {isDark ? <Sun className="w-4 h-4" /> : <Moon className="w-4 h-4 text-indigo-600" />}
        </button>

        {onOpenSubscribe && (
          <button
            onClick={() => {
              sfx.playTap();
              onOpenSubscribe();
            }}
            className={`w-9 h-9 rounded-2xl border-2 border-b-4 flex items-center justify-center transition-all shadow-sm ${
              isVip
                ? 'bg-amber-400 border-amber-500 text-amber-950'
                : 'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 text-amber-500'
            }`}
            title="VIP Membership"
          >
            <Crown className="w-4 h-4 fill-current" />
          </button>
        )}

        {/* Stars */}
        <div className="flex items-center gap-1.5 bg-amber-100 dark:bg-amber-950/70 border-2 border-amber-300 dark:border-amber-700 border-b-4 px-2.5 py-1.5 rounded-2xl shadow-sm text-amber-800 dark:text-amber-300 font-extrabold text-xs sm:text-sm">
          <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-500 animate-pulse" />
          <span>{stars}</span>
        </div>
      </div>
    </header>
  );
}
