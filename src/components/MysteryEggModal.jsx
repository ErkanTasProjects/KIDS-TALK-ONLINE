import React, { useState } from 'react';
import confetti from 'canvas-confetti';
import { Sparkles, Star, Gift, Check, ArrowRight } from 'lucide-react';
import { sfx, speakText } from '../utils/audio';

const REWARD_STICKERS = [
  { id: 'unicorn', name: 'Rainbow Unicorn', emoji: '🦄', rarity: 'Legendary' },
  { id: 'trophy', name: 'Golden Champion Cup', emoji: '🏆', rarity: 'Epic' },
  { id: 'crown', name: 'Royal Crown', emoji: '👑', rarity: 'Rare' },
  { id: 'rocket', name: 'Galaxy Rocket', emoji: '🚀', rarity: 'Epic' },
  { id: 'dragon', name: 'Magic Dragon', emoji: '🐉', rarity: 'Legendary' },
  { id: 'lion', name: 'Brave Lion', emoji: '🦁', rarity: 'Rare' },
  { id: 'star_gem', name: 'Super Star Gem', emoji: '⭐', rarity: 'Common' },
];

export function MysteryEggModal({ isOpen, onCompleteReward }) {
  const [crackCount, setCrackCount] = useState(0);
  const [isOpened, setIsOpened] = useState(false);
  const [reward, setReward] = useState(null);

  if (!isOpen) return null;

  const handleEggTap = () => {
    if (isOpened) return;

    const nextCount = crackCount + 1;
    setCrackCount(nextCount);

    if (nextCount < 3) {
      sfx.playTap();
    } else {
      // Crack open on 3rd tap!
      sfx.playVictory();
      setIsOpened(true);
      const selected = REWARD_STICKERS[Math.floor(Math.random() * REWARD_STICKERS.length)];
      setReward(selected);

      // Save to stickers in localStorage
      try {
        const saved = JSON.parse(localStorage.getItem('kids_talk_stickers') || '[]');
        const updated = [...saved, { id: Date.now(), emoji: selected.emoji, name: selected.name }];
        localStorage.setItem('kids_talk_stickers', JSON.stringify(updated));
      } catch {}

      speakText(`Surprise! You found a ${selected.name}!`);

      try {
        confetti({
          particleCount: 70,
          spread: 80,
          origin: { y: 0.6 },
        });
      } catch {}
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/85 backdrop-blur-md animate-fade-in font-bubble select-none">
      <div className="relative w-full max-w-sm bg-gradient-to-b from-amber-50 via-white to-amber-100 dark:from-[#1a2328] dark:via-[#1f2c34] dark:to-[#131f24] rounded-3xl border-4 border-amber-300 dark:border-amber-500 shadow-2xl p-6 text-center flex flex-col items-center">
        {/* Header */}
        <div className="flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-100 dark:bg-amber-950/70 border border-amber-300 text-amber-800 dark:text-amber-300 text-xs font-black uppercase mb-3">
          <Sparkles className="w-3.5 h-3.5 fill-current" />
          <span>Mystery Surprise Egg!</span>
        </div>

        <h3 className="text-xl font-black text-slate-800 dark:text-white leading-tight">
          {!isOpened ? 'Tap the Egg to Hatch!' : 'Surprise Reward Unlocked!'}
        </h3>
        <p className="text-xs font-bold text-slate-400 mt-1 mb-4">
          {!isOpened
            ? `Tap ${3 - crackCount} more time${3 - crackCount > 1 ? 's' : ''} to crack it open!`
            : `Added to your Sticker Book collection!`}
        </p>

        {/* Wobbling Egg / Unhatched Stage */}
        {!isOpened ? (
          <div
            onClick={handleEggTap}
            className={`relative w-44 h-52 flex items-center justify-center cursor-pointer active:scale-95 transition-transform my-3 select-none ${
              crackCount === 1 ? 'animate-wiggle' : crackCount === 2 ? 'animate-bounce' : 'animate-float'
            }`}
          >
            {/* Egg Glow */}
            <div className="absolute inset-0 bg-amber-300/30 rounded-full blur-xl pointer-events-none" />

            {/* Giant Egg */}
            <div className="relative w-36 h-48 rounded-[50%_50%_50%_50%_/_60%_60%_40%_40%] bg-gradient-to-tr from-amber-300 via-yellow-200 to-amber-400 border-4 border-amber-400 shadow-2xl flex flex-col items-center justify-center overflow-hidden">
              {/* Egg Patterns (Polka dots & gold stripes) */}
              <div className="absolute top-4 left-6 w-5 h-5 rounded-full bg-amber-400/50" />
              <div className="absolute bottom-6 right-6 w-7 h-7 rounded-full bg-amber-400/50" />
              <div className="absolute top-16 right-5 w-4 h-4 rounded-full bg-amber-400/50" />
              <div className="w-full h-3 bg-amber-400/40 transform -rotate-12 my-2" />

              {/* Cracks Visual */}
              {crackCount >= 1 && (
                <div className="absolute z-20 text-3xl font-black text-amber-900 drop-shadow">
                  ⚡
                </div>
              )}
              {crackCount >= 2 && (
                <div className="absolute z-20 text-4xl font-black text-amber-950 -rotate-45 drop-shadow">
                  💥
                </div>
              )}

              <span className="text-5xl z-10 filter drop-shadow">🥚</span>
            </div>
          </div>
        ) : (
          /* Hatched Reward Display */
          <div className="my-3 flex flex-col items-center animate-pop">
            <div className="relative w-36 h-36 rounded-3xl bg-gradient-to-tr from-amber-200 via-yellow-100 to-amber-300 border-4 border-amber-400 shadow-xl flex items-center justify-center mb-3">
              <span className="text-7xl animate-bounce filter drop-shadow-md">
                {reward?.emoji}
              </span>
              <div className="absolute -top-2 -right-2 px-2 py-0.5 rounded-full bg-[#58cc02] text-white text-[10px] font-black uppercase shadow">
                {reward?.rarity}
              </div>
            </div>
            <h4 className="text-lg font-black text-slate-800 dark:text-white">
              {reward?.name}
            </h4>
            <p className="text-xs font-bold text-amber-600 dark:text-amber-400 mt-0.5">
              ✨ New Collectible Sticker! ✨
            </p>
          </div>
        )}

        {/* Bottom Button */}
        {!isOpened ? (
          <button
            onClick={handleEggTap}
            className="w-full mt-4 py-3.5 rounded-2xl duo-btn-green font-black text-sm uppercase tracking-wider flex items-center justify-center gap-2 shadow-md"
          >
            <span>Tap to Crack ({crackCount}/3)</span>
          </button>
        ) : (
          <button
            onClick={() => {
              sfx.playTap();
              if (onCompleteReward) onCompleteReward(reward);
            }}
            className="w-full mt-4 py-3.5 rounded-2xl duo-btn-blue font-black text-sm uppercase tracking-wider flex items-center justify-center gap-2 shadow-md"
          >
            <span>Collect &amp; Continue</span>
            <ArrowRight className="w-5 h-5 stroke-[3]" />
          </button>
        )}
      </div>
    </div>
  );
}

export default MysteryEggModal;
