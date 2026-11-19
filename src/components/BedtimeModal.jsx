import React, { useState, useRef, useEffect, useCallback } from 'react';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { Moon, Star, Lock } from 'lucide-react';
import { sfx } from '../utils/audio';

const STARS = Array.from({ length: 30 }, (_, i) => ({
  id: i,
  left: `${Math.random() * 100}%`,
  top: `${Math.random() * 100}%`,
  size: Math.random() * 3 + 1,
  delay: `${Math.random() * 4}s`,
  duration: `${Math.random() * 2 + 1.5}s`,
}));

const EMOJI_STARS = Array.from({ length: 8 }, (_, i) => ({
  id: i,
  left: `${Math.random() * 90 + 5}%`,
  top: `${Math.random() * 60 + 5}%`,
  delay: `${Math.random() * 5}s`,
  duration: `${Math.random() * 2.5 + 2}s`,
  size: Math.random() * 0.4 + 0.5,
}));

export function BedtimeModal({ isOpen, onClose, starsToday = 0 }) {
  const [holdProgress, setHoldProgress] = useState(0);
  const [isHolding, setIsHolding] = useState(false);
  const holdTimerRef = useRef(null);
  const holdStartRef = useRef(null);
  const animFrameRef = useRef(null);
  const HOLD_DURATION = 3000; // 3 seconds

  useEffect(() => {
    return () => {
      if (holdTimerRef.current) clearTimeout(holdTimerRef.current);
      if (animFrameRef.current) cancelAnimationFrame(animFrameRef.current);
    };
  }, []);

  const updateProgress = useCallback(() => {
    if (!holdStartRef.current) return;
    const elapsed = Date.now() - holdStartRef.current;
    const progress = Math.min(elapsed / HOLD_DURATION, 1);
    setHoldProgress(progress);

    if (progress < 1) {
      animFrameRef.current = requestAnimationFrame(updateProgress);
    } else {
      sfx.playSuccess?.();
      onClose();
    }
  }, [onClose]);

  const startHold = () => {
    setIsHolding(true);
    holdStartRef.current = Date.now();
    animFrameRef.current = requestAnimationFrame(updateProgress);
  };

  const endHold = () => {
    setIsHolding(false);
    holdStartRef.current = null;
    if (animFrameRef.current) cancelAnimationFrame(animFrameRef.current);
    setHoldProgress(0);
  };

  if (!isOpen) return null;

  const circumference = 2 * Math.PI * 24;
  const strokeDashoffset = circumference * (1 - holdProgress);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/90 backdrop-blur-lg select-none font-bubble">
      {/* Night Sky Background with subtle glow */}
      <div className="relative w-full max-w-md bg-gradient-to-b from-[#0b0d2e] via-[#1a1050] to-[#2d1b69] rounded-3xl border-4 border-indigo-500/40 shadow-2xl overflow-hidden p-6 text-center text-white flex flex-col items-center">
        
        {/* Twinkling Stars */}
        <div className="absolute inset-0 pointer-events-none overflow-hidden">
          {STARS.map((s) => (
            <div
              key={s.id}
              className="absolute rounded-full bg-white animate-pulse"
              style={{
                left: s.left,
                top: s.top,
                width: `${s.size}px`,
                height: `${s.size}px`,
                animationDelay: s.delay,
                animationDuration: s.duration,
              }}
            />
          ))}
          {EMOJI_STARS.map((s) => (
            <span
              key={`emoji-${s.id}`}
              className="absolute text-yellow-300 animate-ping opacity-60"
              style={{
                left: s.left,
                top: s.top,
                fontSize: `${s.size}rem`,
                animationDelay: s.delay,
                animationDuration: s.duration,
              }}
            >
              ✨
            </span>
          ))}
        </div>

        {/* Crescent Moon */}
        <div className="relative z-10 mb-2">
          <div className="text-6xl animate-bounce filter drop-shadow-[0_0_15px_rgba(253,224,71,0.5)]">
            🌙
          </div>
        </div>

        {/* Gigi Sleeping Mascot with cute nightcap emoji */}
        <div className="relative z-10 w-44 h-44 my-2 flex items-center justify-center">
          <img
            src={MASCOT_IMAGES.waving}
            alt="Gigi Bedtime"
            className="w-full h-full object-contain filter drop-shadow-2xl animate-float"
          />
          {/* Nightcap / Sleeping Cap emoji placed above Gigi's head */}
          <div className="absolute -top-3 right-8 text-5xl animate-bounce drop-shadow-md">
            😴
          </div>
          {/* Zzz floating badge */}
          <div className="absolute top-4 left-6 text-2xl font-black text-indigo-300 animate-pulse">
            💤 Zzz...
          </div>
        </div>

        {/* Messages */}
        <div className="relative z-10 space-y-1.5 mt-2">
          <h2 className="text-2xl sm:text-3xl font-black tracking-tight text-white drop-shadow">
            Great Job Today! 🌟
          </h2>
          <p className="text-sm font-bold text-indigo-200">
            Time to rest, see you tomorrow!
          </p>
        </div>

        {/* Sweet Dreams Pill */}
        <div className="relative z-10 mt-4 px-4 py-1.5 rounded-full bg-indigo-900/60 border border-indigo-400/30 text-indigo-200 text-xs font-black flex items-center gap-2">
          <span>🛌</span>
          <span>Sweet Dreams! Gigi is proud of you!</span>
        </div>

        {/* Stars earned today stat */}
        <div className="relative z-10 mt-3 flex items-center gap-2 px-3 py-1 rounded-xl bg-amber-400/20 border border-amber-400/40 text-amber-300 text-xs font-black">
          <Star className="w-4 h-4 fill-amber-300" />
          <span>{starsToday} Stars Earned Today!</span>
        </div>

        {/* Hold to unlock (Parent Gate to dismiss bedtime screen) */}
        <div className="relative z-10 mt-6 flex flex-col items-center">
          <button
            onMouseDown={startHold}
            onMouseUp={endHold}
            onMouseLeave={endHold}
            onTouchStart={startHold}
            onTouchEnd={endHold}
            className="relative w-16 h-16 rounded-full bg-indigo-950/80 border-2 border-indigo-400/40 flex items-center justify-center text-indigo-300 active:scale-95 transition-transform cursor-pointer"
          >
            {/* Circular Progress Ring */}
            <svg className="absolute inset-0 w-full h-full -rotate-90" viewBox="0 0 56 56">
              <circle
                cx="28"
                cy="28"
                r="24"
                className="text-indigo-900 stroke-current"
                strokeWidth="4"
                fill="none"
              />
              <circle
                cx="28"
                cy="28"
                r="24"
                className="text-emerald-400 stroke-current transition-all"
                strokeWidth="4"
                fill="none"
                strokeDasharray={circumference}
                strokeDashoffset={strokeDashoffset}
                strokeLinecap="round"
              />
            </svg>
            <Lock className="w-6 h-6 z-10 text-indigo-300" />
          </button>
          <p className="text-[10px] font-bold text-indigo-300/60 mt-1.5">
            Hold 3 seconds (Parent unlock)
          </p>
        </div>

      </div>
    </div>
  );
}

export default BedtimeModal;
