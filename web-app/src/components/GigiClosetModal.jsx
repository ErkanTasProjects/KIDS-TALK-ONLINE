import React, { useState } from 'react';
import confetti from 'canvas-confetti';
import { X, Crown, Check, Sparkles, Shirt, Lock, CheckCircle2 } from 'lucide-react';
import { usePremium, GIGI_OUTFITS } from '../context/PremiumContext';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { sfx } from '../utils/audio';

export function GigiClosetModal({ isOpen, onClose, onOpenSubscribe }) {
  const { isVip, equippedOutfit, setEquippedOutfit } = usePremium();
  const [selectedOutfit, setSelectedOutfit] = useState(equippedOutfit);

  if (!isOpen) return null;

  const handleSelectOutfit = (outfit) => {
    sfx.playTap();
    if (outfit.isVipOnly && !isVip) {
      onOpenSubscribe();
      return;
    }
    setSelectedOutfit(outfit.id);
  };

  const handleEquip = () => {
    const success = setEquippedOutfit(selectedOutfit);
    if (success) {
      sfx.playSuccess?.();
      try {
        confetti({ particleCount: 60, spread: 70, origin: { y: 0.6 } });
      } catch (e) {}
      onClose();
    } else {
      onOpenSubscribe();
    }
  };

  const currentOutfit = GIGI_OUTFITS.find(o => o.id === selectedOutfit);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-4 bg-slate-900/80 backdrop-blur-md animate-fade-in font-bubble select-none">
      <div className="relative w-full max-w-lg bg-white dark:bg-[#1f2c34] rounded-3xl border-4 border-amber-300 dark:border-amber-500 shadow-2xl overflow-hidden flex flex-col max-h-[92vh]">
        {/* Header */}
        <div className="p-4 sm:p-5 border-b border-slate-200 dark:border-[#37464f] flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-amber-100 dark:bg-amber-900/40 text-amber-500 flex items-center justify-center shadow-xs">
              <Shirt className="w-5 h-5 stroke-[2.5]" />
            </div>
            <div>
              <h3 className="text-lg font-black text-slate-800 dark:text-white leading-tight">
                Gigi's Wardrobe (Kostüm Dolabı)
              </h3>
              <p className="text-xs font-bold text-slate-400">
                Choose Gigi's style badge!
              </p>
            </div>
          </div>
          <button
            onClick={() => { sfx.playTap(); onClose(); }}
            className="p-2 rounded-full text-slate-400 hover:text-slate-600 dark:hover:text-white"
          >
            <X className="w-6 h-6 stroke-[2.5]" />
          </button>
        </div>

        {/* Center: Gigi Preview with Badge */}
        <div className="p-5 bg-gradient-to-b from-amber-50 via-white to-amber-50/50 dark:from-[#131f24] dark:via-[#1a252b] dark:to-[#1f2c34] flex flex-col items-center justify-center border-b border-slate-200 dark:border-[#37464f]">
          <div className="relative w-52 h-64 sm:w-60 sm:h-72 flex items-center justify-center p-2 rounded-3xl bg-white/70 dark:bg-slate-800/70 shadow-inner border-2 border-amber-200 dark:border-amber-700/50">
            {/* Golden Pedestal */}
            <div className="absolute bottom-3 w-40 h-8 rounded-[50%] bg-gradient-to-r from-amber-300 via-yellow-200 to-amber-400 border border-amber-400 shadow-md"></div>

            {/* Plain Gigi image */}
            <img
              src={MASCOT_IMAGES.waving}
              alt="Gigi"
              className="h-full w-full object-contain z-10 animate-duo-bounce drop-shadow-md"
            />

            {/* Badge overlay — simple emoji floating above Gigi's head */}
            {selectedOutfit !== 'default' && currentOutfit && (
              <div className="absolute top-2 right-2 z-20 text-4xl animate-bounce drop-shadow-lg">
                {currentOutfit.icon}
              </div>
            )}
          </div>

          {/* Outfit Name Pill */}
          <div className="mt-3 flex items-center gap-2 px-4 py-1.5 rounded-full bg-amber-100 dark:bg-slate-800 text-amber-950 dark:text-amber-200 text-xs font-black shadow-xs">
            <span>{currentOutfit?.icon}</span>
            <span>{currentOutfit?.name}</span>
            {equippedOutfit === selectedOutfit && (
              <span className="text-[10px] text-[#58cc02] font-black uppercase flex items-center gap-0.5">
                <CheckCircle2 className="w-3.5 h-3.5" /> Equipped
              </span>
            )}
          </div>
        </div>

        {/* Outfit Selection Cards List */}
        <div className="p-4 sm:p-5 overflow-y-auto space-y-2.5 flex-1">
          {GIGI_OUTFITS.map((outfit) => {
            const isSelected = selectedOutfit === outfit.id;
            const isEquipped = equippedOutfit === outfit.id;
            const isLocked = outfit.isVipOnly && !isVip;

            return (
              <div
                key={outfit.id}
                onClick={() => handleSelectOutfit(outfit)}
                className={`flex items-center justify-between p-3.5 rounded-2xl border-2 transition-all cursor-pointer active:scale-[0.98] ${
                  isSelected
                    ? 'border-[#58cc02] bg-emerald-50/70 dark:bg-emerald-950/40 ring-2 ring-[#58cc02]/30 shadow-sm'
                    : 'border-slate-200 dark:border-[#37464f] bg-white dark:bg-[#233138] hover:border-slate-300 dark:hover:border-slate-600'
                }`}
              >
                <div className="flex items-center gap-3">
                  <div className={`w-12 h-12 rounded-2xl bg-gradient-to-tr ${outfit.color} text-white text-2xl flex items-center justify-center shadow-xs shrink-0`}>
                    {outfit.icon}
                  </div>
                  <div>
                    <div className="flex items-center gap-1.5">
                      <h4 className="text-sm font-black text-slate-800 dark:text-white leading-tight">
                        {outfit.name}
                      </h4>
                      {outfit.isVipOnly && (
                        <span className="px-1.5 py-0.5 rounded-md bg-amber-400 text-amber-950 text-[9px] font-black uppercase flex items-center gap-0.5">
                          <Crown className="w-2.5 h-2.5 fill-current" /> VIP
                        </span>
                      )}
                      {isEquipped && (
                        <span className="px-1.5 py-0.5 rounded-md bg-[#58cc02] text-white text-[9px] font-black uppercase">
                          Equipped
                        </span>
                      )}
                    </div>
                    <p className="text-[11px] font-bold text-slate-400 mt-0.5">
                      {outfit.description}
                    </p>
                  </div>
                </div>

                <div className="shrink-0 ml-2">
                  {isLocked ? (
                    <div className="w-8 h-8 rounded-full bg-slate-200 dark:bg-slate-700 text-slate-400 flex items-center justify-center">
                      <Lock className="w-4 h-4" />
                    </div>
                  ) : isSelected ? (
                    <div className="w-8 h-8 rounded-full bg-[#58cc02] text-white flex items-center justify-center shadow-xs">
                      <Check className="w-5 h-5 stroke-[3]" />
                    </div>
                  ) : (
                    <div className="w-8 h-8 rounded-full border-2 border-slate-200 dark:border-slate-600" />
                  )}
                </div>
              </div>
            );
          })}
        </div>

        {/* Footer Actions */}
        <div className="p-4 border-t border-slate-200 dark:border-[#37464f] bg-slate-50 dark:bg-[#1f2c34] flex gap-2">
          <button
            onClick={() => { sfx.playTap(); onClose(); }}
            className="flex-1 py-3 rounded-2xl duo-btn-white font-black text-xs uppercase"
          >
            Cancel
          </button>
          <button
            onClick={handleEquip}
            className="flex-1 py-3 rounded-2xl duo-btn-green font-black text-xs uppercase shadow-md flex items-center justify-center gap-1.5"
          >
            <Sparkles className="w-4 h-4 fill-white" />
            <span>Equip Badge</span>
          </button>
        </div>
      </div>
    </div>
  );
}
