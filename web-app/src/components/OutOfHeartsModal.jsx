import React from 'react';
import { X, Heart, Sparkles, Crown, RotateCcw } from 'lucide-react';
import { usePremium } from '../context/PremiumContext';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { sfx } from '../utils/audio';

export function OutOfHeartsModal({ isOpen, onClose, onOpenSubscribe }) {
  const { refillHearts } = usePremium();

  if (!isOpen) return null;

  const handleRefill = () => {
    sfx.playSuccess?.();
    refillHearts();
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/80 backdrop-blur-md animate-fade-in font-bubble select-none">
      <div className="bg-white dark:bg-[#1f2c34] rounded-3xl border-4 border-rose-400 dark:border-rose-500 max-w-sm w-full p-6 text-center shadow-2xl animate-pop relative overflow-hidden">
        {/* Mascot Thinking */}
        <div className="w-28 h-28 mx-auto mb-2 flex items-center justify-center">
          <img
            src={MASCOT_IMAGES.thinking}
            alt="Gigi thinking"
            className="w-full h-full object-contain filter drop-shadow-md animate-duo-bounce"
          />
        </div>

        <div className="w-12 h-12 rounded-full bg-rose-100 dark:bg-rose-950 text-rose-500 flex items-center justify-center mx-auto mb-2 shadow-inner">
          <Heart className="w-7 h-7 fill-rose-500 animate-pulse" />
        </div>

        <h3 className="text-xl font-black text-slate-800 dark:text-white">
          You Ran Out of Hearts!
        </h3>
        <p className="text-xs font-bold text-slate-500 dark:text-slate-400 mt-1 mb-5">
          Don't worry, mistakes help us learn! Unlock unlimited hearts with VIP so you never have to stop playing!
        </p>

        <div className="space-y-2.5">
          <button
            onClick={() => {
              sfx.playTap();
              onOpenSubscribe();
            }}
            className="w-full py-3.5 rounded-2xl duo-btn-green font-black text-xs uppercase tracking-wider flex items-center justify-center gap-2 shadow-md"
          >
            <Crown className="w-4 h-4 fill-white" />
            <span>Get Unlimited Hearts (∞)</span>
          </button>

          <button
            onClick={handleRefill}
            className="w-full py-3 rounded-2xl duo-btn-white font-black text-xs uppercase"
          >
            Refill 5 Hearts for Free
          </button>
        </div>
      </div>
    </div>
  );
}
