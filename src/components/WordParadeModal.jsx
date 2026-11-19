import React, { useState, useEffect } from 'react';
import confetti from 'canvas-confetti';
import { Volume2, Sparkles, ArrowRight } from 'lucide-react';
import { speakText, sfx } from '../utils/audio';
import { MASCOT_IMAGES } from '../data/mascotImages';

export function WordParadeModal({ isOpen, words = [], onFinish }) {
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    if (!isOpen || words.length === 0) return;

    // Play initial fanfare
    sfx.playVictory?.();
    try {
      confetti({
        particleCount: 40,
        spread: 60,
        origin: { y: 0.6 },
      });
    } catch {}

    // Announce first word
    speakText(words[0]);

    // Timer to parade through words
    const interval = setInterval(() => {
      setCurrentIndex((prev) => {
        const next = prev + 1;
        if (next < words.length) {
          speakText(words[next]);
          return next;
        } else {
          clearInterval(interval);
          return prev;
        }
      });
    }, 1600);

    return () => clearInterval(interval);
  }, [isOpen, words]);

  if (!isOpen || words.length === 0) return null;

  const currentWord = words[currentIndex] || words[0];
  const isLast = currentIndex >= words.length - 1;

  const handleNextOrFinish = () => {
    sfx.playTap();
    if (!isLast) {
      const next = currentIndex + 1;
      setCurrentIndex(next);
      speakText(words[next]);
    } else {
      if (onFinish) onFinish();
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/85 backdrop-blur-md animate-fade-in font-bubble select-none">
      <div className="relative w-full max-w-md bg-gradient-to-b from-sky-400 via-blue-500 to-indigo-600 rounded-3xl border-4 border-yellow-300 shadow-2xl p-6 text-center text-white flex flex-col items-center overflow-hidden">
        {/* Decorative Top Pill */}
        <div className="flex items-center gap-1.5 px-4 py-1 rounded-full bg-white/20 backdrop-blur-md border border-white/30 text-yellow-200 text-xs font-black uppercase mb-3">
          <Sparkles className="w-3.5 h-3.5 fill-current" />
          <span>🎪 Vocabulary Parade! 🎪</span>
        </div>

        <h3 className="text-xl sm:text-2xl font-black text-white leading-tight">
          Repeat After Gigi!
        </h3>
        <p className="text-xs text-blue-100 font-bold mt-1">
          Reviewing your {words.length} mastered phrases ({currentIndex + 1}/{words.length})
        </p>

        {/* Mascot & Big Word Card Stage */}
        <div className="my-5 w-full flex flex-col items-center">
          {/* Gigi */}
          <div className="w-24 h-24 mb-2 flex items-center justify-center animate-bounce-subtle">
            <img
              src={MASCOT_IMAGES.celebrating}
              alt="Gigi Parade"
              className="w-full h-full object-contain filter drop-shadow-lg"
            />
          </div>

          {/* Word Card */}
          <div
            onClick={() => speakText(currentWord)}
            className="w-full bg-white text-slate-800 rounded-3xl p-6 border-4 border-yellow-300 shadow-xl flex flex-col items-center justify-center cursor-pointer active:scale-95 transition-transform"
          >
            <span className="text-xs font-black text-sky-500 uppercase tracking-wider mb-1 flex items-center gap-1">
              <Volume2 className="w-4 h-4 fill-current" /> Tap to Hear Gigi
            </span>
            <h2 className="text-2xl sm:text-3xl font-black text-slate-900 leading-tight">
              "{currentWord}"
            </h2>
          </div>
        </div>

        {/* Progress Dots */}
        <div className="flex items-center gap-2 mb-4">
          {words.map((_, idx) => (
            <div
              key={idx}
              className={`h-2.5 rounded-full transition-all duration-300 ${
                idx === currentIndex
                  ? 'w-6 bg-yellow-300'
                  : idx < currentIndex
                  ? 'w-2.5 bg-white'
                  : 'w-2.5 bg-white/30'
              }`}
            />
          ))}
        </div>

        {/* Bottom Button */}
        <button
          onClick={handleNextOrFinish}
          className="w-full py-3.5 rounded-2xl bg-yellow-400 hover:bg-yellow-300 active:translate-y-1 text-slate-900 font-black text-sm uppercase tracking-wider border-b-4 border-yellow-500 flex items-center justify-center gap-2 shadow-lg"
        >
          <span>{isLast ? 'Open Mystery Egg! 🥚' : 'Next Word ⏩'}</span>
          <ArrowRight className="w-5 h-5 stroke-[3]" />
        </button>
      </div>
    </div>
  );
}

export default WordParadeModal;
