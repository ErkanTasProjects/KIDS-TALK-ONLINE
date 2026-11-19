import React, { useState } from 'react';
import confetti from 'canvas-confetti';
import { Volume2, Sparkles } from 'lucide-react';
import { speakText, sfx } from '../utils/audio';
import { MASCOT_IMAGES } from '../data/mascotImages';

const GIGI_EASTER_EGGS = [
  "You're a superstar! Keep going! ⭐",
  "Let's learn together! High five! ✋",
  "I believe in you! You can do it! ✨",
  "You are doing amazing today! 🦒",
  "English is so much fun with you! 🎈",
];

export function MascotSpeechBubble({
  pose = 'waving',
  speechText = '',
  onSpeakerClick = null,
  showSpeaker = true,
  className = ''
}) {
  const imgSrc = MASCOT_IMAGES[pose] || MASCOT_IMAGES.waving;
  const [isWiggling, setIsWiggling] = useState(false);

  // Easter Egg: Tap Gigi mascot for giggles, sparkle, and encouragement!
  const handleMascotTap = (e) => {
    e?.stopPropagation();
    sfx.playSuccess?.();
    setIsWiggling(true);

    try {
      confetti({
        particleCount: 15,
        spread: 45,
        origin: { y: 0.3 },
        scalar: 0.7,
      });
    } catch {}

    const randomPhrase = GIGI_EASTER_EGGS[Math.floor(Math.random() * GIGI_EASTER_EGGS.length)];
    speakText(randomPhrase);

    setTimeout(() => {
      setIsWiggling(false);
    }, 1200);
  };

  // Normal speech bubble audio button
  const handleSpeak = (e) => {
    e?.stopPropagation();
    sfx.playTap();
    if (onSpeakerClick) {
      onSpeakerClick();
    } else if (speechText) {
      speakText(speechText);
    }
  };

  return (
    <div className={`flex items-center gap-3 sm:gap-5 my-2 max-w-xl mx-auto w-full ${className}`}>
      {/* Gigi Mascot — Interactive Easter Egg (Tap for giggles & encouragement) */}
      <div
        onClick={handleMascotTap}
        title="Tap Gigi for a friendly giggle!"
        className="relative shrink-0 w-24 h-24 sm:w-28 sm:h-28 flex items-center justify-center cursor-pointer group"
      >
        {/* Soft shadow under Gigi */}
        <div className="absolute bottom-1 w-16 h-3 bg-slate-900/10 dark:bg-black/30 rounded-full blur-[2px] pointer-events-none"></div>

        <img
          src={imgSrc}
          alt="Gigi"
          className={`h-full w-full object-contain drop-shadow-md transition-transform ${
            isWiggling
              ? 'animate-wiggle scale-110'
              : 'animate-float group-hover:scale-105 group-active:scale-95'
          }`}
        />

        {/* Small sparkle hint badge */}
        <div className="absolute -top-1 -right-1 w-6 h-6 rounded-full bg-amber-400 text-white flex items-center justify-center shadow opacity-0 group-hover:opacity-100 transition-opacity">
          <Sparkles className="w-3.5 h-3.5 fill-current" />
        </div>
      </div>

      {/* Speech Bubble */}
      <div className="relative flex-1 bg-white dark:bg-[#1f2c34] border-2 border-slate-200 dark:border-[#37464f] border-b-4 rounded-2xl p-4 shadow-sm flex items-center justify-between gap-3 text-slate-800 dark:text-slate-100">
        <div className="absolute top-1/2 -left-2.5 -translate-y-1/2 w-0 h-0 border-t-[8px] border-t-transparent border-b-[8px] border-b-transparent border-r-[10px] border-r-white dark:border-r-[#1f2c34]"></div>
        <div className="absolute top-1/2 -left-3.5 -translate-y-1/2 w-0 h-0 border-t-[9px] border-t-transparent border-b-[9px] border-b-transparent border-r-[11px] border-r-slate-200 dark:border-[#37464f] -z-10"></div>

        <div className="flex-1 text-left">
          <p className="text-base sm:text-lg font-bold leading-tight">
            {speechText}
          </p>
        </div>

        {showSpeaker && speechText && (
          <button
            onClick={handleSpeak}
            aria-label="Listen to audio"
            className="shrink-0 w-11 h-11 bg-sky-500 hover:bg-sky-400 active:translate-y-0.5 border-b-4 border-sky-600 active:border-b-2 rounded-xl text-white flex items-center justify-center transition-all shadow-sm"
          >
            <Volume2 className="w-5 h-5 fill-current" />
          </button>
        )}
      </div>
    </div>
  );
}

export default MascotSpeechBubble;
