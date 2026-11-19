import React, { useState } from 'react';
import confetti from 'canvas-confetti';
import { X, Heart, Star, Sparkles, Smile, RefreshCw } from 'lucide-react';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { speakText, sfx } from '../utils/audio';

const FOOD_TREATS = [
  {
    id: 'leaf',
    name: 'Crunchy Leaf',
    emoji: '🍃',
    cost: 2,
    hungerValue: 20,
    phrase: 'Yummy green leaf! Giraffes love this!',
    color: 'from-emerald-400 to-green-500',
  },
  {
    id: 'apple',
    name: 'Sweet Apple',
    emoji: '🍎',
    cost: 3,
    hungerValue: 30,
    phrase: 'Delicious sweet apple! So crunchy!',
    color: 'from-rose-400 to-red-500',
  },
  {
    id: 'icecream',
    name: 'Strawberry Ice Cream',
    emoji: '🍦',
    cost: 5,
    hungerValue: 40,
    phrase: 'Mmm, strawberry ice cream! Super yummy!',
    color: 'from-pink-400 to-rose-400',
  },
  {
    id: 'cookie',
    name: 'Golden Cookie',
    emoji: '🍪',
    cost: 6,
    hungerValue: 50,
    phrase: 'A magic golden cookie! Thank you, best friend!',
    color: 'from-amber-400 to-yellow-500',
  },
];

export function FeedGigiModal({ isOpen, onClose, stars = 0, onSpendStars }) {
  const [happiness, setHappiness] = useState(() => {
    try {
      const saved = localStorage.getItem('kids_talk_gigi_happiness');
      return saved ? parseInt(saved, 10) : 60;
    } catch {
      return 60;
    }
  });

  const [isChewing, setIsChewing] = useState(false);
  const [activeHeartFeed, setActiveHeartFeed] = useState(false);
  const [gigiSpeech, setGigiSpeech] = useState("I'm hungry! Can I have a treat?");
  const [selectedFoodId, setSelectedFoodId] = useState(null);

  if (!isOpen) return null;

  const handleFeed = (food) => {
    // Check if enough stars or give free treat if 0
    const canAfford = stars >= food.cost;
    if (canAfford && onSpendStars) {
      onSpendStars(food.cost);
    }

    sfx.playSuccess?.();
    setIsChewing(true);
    setActiveHeartFeed(true);
    setSelectedFoodId(food.id);
    setGigiSpeech(food.phrase);
    speakText(food.phrase);

    const newHappiness = Math.min(100, happiness + food.hungerValue);
    setHappiness(newHappiness);
    try {
      localStorage.setItem('kids_talk_gigi_happiness', newHappiness.toString());
    } catch {}

    try {
      confetti({
        particleCount: 30,
        spread: 60,
        origin: { y: 0.5 },
      });
    } catch {}

    setTimeout(() => {
      setIsChewing(false);
      setActiveHeartFeed(false);
      setSelectedFoodId(null);
    }, 2000);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-4 bg-slate-900/80 backdrop-blur-md animate-fade-in font-bubble select-none">
      <div className="relative w-full max-w-md bg-white dark:bg-[#1f2c34] rounded-3xl border-4 border-amber-300 dark:border-amber-500 shadow-2xl overflow-hidden flex flex-col text-slate-800 dark:text-slate-100">
        {/* Header */}
        <div className="p-4 border-b border-slate-200 dark:border-[#37464f] flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-2xl bg-amber-100 dark:bg-amber-950/50 text-2xl flex items-center justify-center shadow-xs">
              🍰
            </div>
            <div>
              <h3 className="text-lg font-black leading-tight">Feed &amp; Care for Gigi</h3>
              <p className="text-xs font-bold text-slate-400">Give Gigi yummy treats to keep him happy!</p>
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

        {/* Stage with Gigi */}
        <div className="p-5 bg-gradient-to-b from-amber-50 via-white to-orange-50/40 dark:from-[#131f24] dark:via-[#1a252b] dark:to-[#1f2c34] flex flex-col items-center justify-center relative overflow-hidden">
          {/* Floating Hearts Animation */}
          {activeHeartFeed && (
            <div className="absolute inset-0 pointer-events-none flex items-center justify-center z-30">
              <span className="text-4xl animate-ping absolute -top-4">💖</span>
              <span className="text-3xl animate-bounce absolute top-10 left-12">💕</span>
              <span className="text-4xl animate-bounce absolute top-8 right-12">❤️</span>
              <span className="text-2xl animate-pulse absolute bottom-16">✨</span>
            </div>
          )}

          {/* Gigi Character */}
          <div className="relative w-40 h-44 flex items-center justify-center">
            {/* Pedestal */}
            <div className="absolute bottom-1 w-32 h-6 rounded-[50%] bg-gradient-to-r from-amber-300 via-yellow-200 to-amber-400 border border-amber-400 shadow-md"></div>

            <img
              src={isChewing ? MASCOT_IMAGES.celebrating : MASCOT_IMAGES.waving}
              alt="Gigi"
              className={`h-full w-full object-contain z-10 transition-transform ${
                isChewing ? 'scale-110 animate-bounce' : 'animate-float'
              }`}
            />

            {/* Food fly-in item */}
            {selectedFoodId && (
              <div className="absolute top-12 z-20 text-5xl animate-spin">
                {FOOD_TREATS.find((f) => f.id === selectedFoodId)?.emoji}
              </div>
            )}
          </div>

          {/* Gigi Speech Bubble */}
          <div className="mt-3 px-4 py-2 rounded-2xl bg-white dark:bg-[#233138] border-2 border-amber-200 dark:border-amber-700/60 shadow-sm max-w-xs text-center">
            <p className="text-xs font-black text-amber-900 dark:text-amber-200 leading-snug">
              "{gigiSpeech}"
            </p>
          </div>

          {/* Happiness Meter */}
          <div className="w-full max-w-xs mt-4">
            <div className="flex items-center justify-between text-xs font-black mb-1">
              <span className="flex items-center gap-1 text-rose-500">
                <Heart className="w-3.5 h-3.5 fill-current" /> Gigi's Happiness
              </span>
              <span className="text-emerald-500">{happiness}% Full</span>
            </div>
            <div className="w-full h-3 rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden p-0.5 shadow-inner">
              <div
                className="h-full rounded-full bg-gradient-to-r from-rose-400 via-amber-400 to-emerald-400 transition-all duration-500"
                style={{ width: `${happiness}%` }}
              />
            </div>
          </div>
        </div>

        {/* Treats Grid */}
        <div className="p-4 space-y-3">
          <div className="flex items-center justify-between text-xs font-black">
            <span className="uppercase tracking-wider text-slate-400">Select a Treat:</span>
            <div className="flex items-center gap-1 text-amber-500 font-black">
              <Star className="w-3.5 h-3.5 fill-current" />
              <span>{stars} Stars Available</span>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-2.5">
            {FOOD_TREATS.map((food) => {
              const canAfford = stars >= food.cost;
              return (
                <button
                  key={food.id}
                  onClick={() => handleFeed(food)}
                  disabled={isChewing}
                  className={`p-3 rounded-2xl border-2 border-b-4 flex items-center gap-2.5 text-left transition-all active:scale-95 ${
                    canAfford
                      ? 'border-slate-200 dark:border-[#37464f] bg-white dark:bg-[#233138] hover:border-amber-400'
                      : 'border-slate-200 dark:border-[#37464f] bg-slate-50 dark:bg-slate-800/50 opacity-90'
                  }`}
                >
                  <div className={`w-11 h-11 rounded-2xl bg-gradient-to-tr ${food.color} text-2xl flex items-center justify-center shadow-xs shrink-0 text-white`}>
                    {food.emoji}
                  </div>
                  <div className="min-w-0 flex-1">
                    <h4 className="text-xs font-black truncate leading-tight">{food.name}</h4>
                    <div className="flex items-center gap-1 mt-1 text-[11px] font-bold text-amber-500">
                      <Star className="w-3 h-3 fill-current" />
                      <span>{food.cost} Stars</span>
                    </div>
                  </div>
                </button>
              );
            })}
          </div>
        </div>

        {/* Footer */}
        <div className="p-3 bg-slate-50 dark:bg-[#1f2c34] border-t border-slate-200 dark:border-[#37464f] text-center">
          <p className="text-[11px] font-bold text-slate-400">
            Keep Gigi well-fed and happy by completing English lessons! 🦒🌟
          </p>
        </div>
      </div>
    </div>
  );
}

export default FeedGigiModal;
