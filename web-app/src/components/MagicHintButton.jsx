import React from 'react';
import { Sparkles, Crown } from 'lucide-react';
import { usePremium } from '../context/PremiumContext';
import { sfx } from '../utils/audio';

export function MagicHintButton({ onUseHint, onOpenSubscribe }) {
  const { isVip } = usePremium();

  const handleClick = (e) => {
    e?.stopPropagation();
    sfx.playTap();
    if (isVip) {
      sfx.playVictory?.();
      if (onUseHint) onUseHint();
    } else {
      if (onOpenSubscribe) onOpenSubscribe();
    }
  };

  return (
    <button
      onClick={handleClick}
      className={`px-3 py-2 rounded-2xl border-2 flex items-center gap-1.5 transition-all shadow-xs active:scale-95 ${
        isVip
          ? 'bg-gradient-to-r from-amber-400 to-yellow-300 border-amber-400 text-amber-950 font-black'
          : 'bg-white dark:bg-[#1f2c34] border-slate-200 dark:border-[#37464f] text-slate-600 dark:text-slate-300'
      }`}
      title={isVip ? 'Use VIP Magic Hint' : 'Unlock Magic Hint with VIP'}
    >
      <Sparkles className="w-4 h-4 text-amber-500 fill-amber-400 animate-pulse" />
      <span className="text-xs font-black">
        {isVip ? 'Gigi Hint ✨' : 'Hint'}
      </span>
      {!isVip && (
        <Crown className="w-3.5 h-3.5 text-amber-500 fill-amber-400 ml-0.5" />
      )}
    </button>
  );
}
