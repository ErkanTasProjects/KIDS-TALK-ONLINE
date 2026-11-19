import React, { useState } from 'react';
import confetti from 'canvas-confetti';
import { Trophy, Star, ArrowRight, RotateCcw, Zap } from 'lucide-react';
import { sfx } from '../utils/audio';
import { usePremium } from '../context/PremiumContext';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { WordParadeModal } from './WordParadeModal';
import { MysteryEggModal } from './MysteryEggModal';

export function CompletionModal({
  starsEarned = 3,
  hasMistake = false,
  activityTitle = 'Activity Completed!',
  paradeWords = [],
  onNextActivity,
  onBackToMap,
}) {
  const { isPremium } = usePremium();
  const finalStars = isPremium ? starsEarned * 2 : starsEarned;

  // Stages: 'parade' -> 'egg' -> 'celebration'
  const [stage, setStage] = useState(() => {
    if (paradeWords && paradeWords.length > 0) return 'parade';
    return 'egg';
  });

  React.useEffect(() => {
    if (stage === 'celebration') {
      sfx.playVictory();
      try {
        confetti({ particleCount: 80, spread: 70, origin: { y: 0.6 } });
        setTimeout(() => {
          confetti({ particleCount: 50, angle: 60, spread: 55, origin: { x: 0 } });
          confetti({ particleCount: 50, angle: 120, spread: 55, origin: { x: 1 } });
        }, 300);
      } catch (e) {}
    }
  }, [stage]);

  // Stage 1: Word Parade
  if (stage === 'parade' && paradeWords && paradeWords.length > 0) {
    return (
      <WordParadeModal
        isOpen={true}
        words={paradeWords}
        onFinish={() => setStage('egg')}
      />
    );
  }

  // Stage 2: Mystery Surprise Egg
  if (stage === 'egg') {
    return (
      <MysteryEggModal
        isOpen={true}
        onCompleteReward={() => setStage('celebration')}
      />
    );
  }

  // Stage 3: Celebration Modal
  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-white dark:bg-slate-900 border-4 border-amber-300 dark:border-amber-500 rounded-3xl p-6 sm:p-8 max-w-md w-full text-center shadow-2xl animate-pop relative overflow-hidden">
        <div className="absolute -top-12 -left-12 w-32 h-32 bg-amber-200/50 dark:bg-amber-500/20 rounded-full blur-2xl"></div>
        <div className="absolute -bottom-12 -right-12 w-32 h-32 bg-emerald-200/50 dark:bg-emerald-500/20 rounded-full blur-2xl"></div>

        {/* Mascot */}
        <div className="relative mx-auto w-32 h-32 mb-2 flex items-center justify-center">
          <img
            src={MASCOT_IMAGES.celebrating}
            alt="Gigi celebrating"
            className="h-full w-full object-contain filter drop-shadow-md animate-bounce-subtle"
          />
        </div>

        <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-800 dark:text-white tracking-tight">
          {hasMistake ? 'Good Effort! 👍' : 'Woohoo! Perfect Score! 🎉'}
        </h2>
        <p className="text-slate-500 dark:text-slate-400 font-semibold text-sm mt-1 mb-5">
          {activityTitle}
        </p>

        {/* 3 Stars display */}
        <div className="flex justify-center items-center gap-3 my-4">
          {[1, 2, 3].map((starIndex) => (
            <div
              key={starIndex}
              className={`transform transition-all duration-500 ${
                starIndex <= starsEarned ? 'scale-110 text-amber-400' : 'text-slate-200 dark:text-slate-700'
              }`}
            >
              <Star className="w-10 h-10 fill-current drop-shadow-sm animate-pulse" />
            </div>
          ))}
        </div>

        {hasMistake ? (
          <p className="text-xs font-bold text-amber-700 dark:text-amber-400 mb-2">
            You had some wrong attempts, so you received {starsEarned} of 3 stars!
          </p>
        ) : (
          <p className="text-xs font-bold text-emerald-600 dark:text-emerald-400 mb-2">
            Zero mistakes! Full 3 stars awarded!
          </p>
        )}

        <div className="text-base font-extrabold text-amber-700 dark:text-amber-300 bg-amber-50 dark:bg-amber-950/60 border-2 border-amber-200 dark:border-amber-800 rounded-xl py-2 px-4 inline-flex items-center gap-2 mb-6">
          {isPremium && <Zap className="w-4 h-4 fill-amber-400 text-amber-500" />}
          <span>+{finalStars} Stars Added! {isPremium && '(2X VIP Bonus 👑)'}</span>
        </div>

        <div className="flex flex-col sm:flex-row gap-3 justify-center">
          <button
            onClick={() => { sfx.playTap(); onBackToMap(); }}
            className="flex-1 bg-white dark:bg-slate-800 hover:bg-slate-100 dark:hover:bg-slate-700 active:translate-y-0.5 border-2 border-slate-300 dark:border-slate-700 border-b-4 rounded-2xl py-3 px-4 font-extrabold text-slate-700 dark:text-slate-200 transition-all flex items-center justify-center gap-2"
          >
            <RotateCcw className="w-4 h-4" />
            <span>Map</span>
          </button>

          {onNextActivity && (
            <button
              onClick={() => { sfx.playTap(); onNextActivity(); }}
              className="flex-1 bg-emerald-500 hover:bg-emerald-400 active:translate-y-1 border-b-4 border-emerald-600 rounded-2xl py-3 px-4 font-extrabold text-white text-base transition-all flex items-center justify-center gap-2 shadow-md"
            >
              <span>Next</span>
              <ArrowRight className="w-5 h-5 stroke-[3]" />
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

export default CompletionModal;
