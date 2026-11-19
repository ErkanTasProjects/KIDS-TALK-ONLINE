import React, { useState } from 'react';
import confetti from 'canvas-confetti';
import {
  X,
  Crown,
  Check,
  Sparkles,
  Zap,
  Star,
  ShieldCheck,
  Heart,
  Unlock,
  Shirt,
  Award,
  BookOpen,
  ArrowRight,
  RotateCcw
} from 'lucide-react';
import { usePremium } from '../context/PremiumContext';
import { sfx } from '../utils/audio';

export function SubscriptionModal({ isOpen, onClose }) {
  const { isVip, activateVip, deactivateVip } = usePremium();
  const [showParentGate, setShowParentGate] = useState(false);
  const [mathAnswer, setMathAnswer] = useState('');
  const [mathError, setMathError] = useState(false);

  // Simple math challenge: 7 + 5 = 12
  const num1 = 7;
  const num2 = 5;
  const correctAnswer = 12;

  if (!isOpen) return null;

  const handleParentUnlock = (e) => {
    e.preventDefault();
    if (parseInt(mathAnswer.trim(), 10) === correctAnswer) {
      sfx.playVictory?.();
      activateVip();
      setShowParentGate(false);
      setMathAnswer('');
      setMathError(false);
      try {
        confetti({
          particleCount: 100,
          spread: 80,
          origin: { y: 0.5 }
        });
      } catch (err) {}
      setTimeout(() => {
        onClose();
      }, 1000);
    } else {
      sfx.playError?.();
      setMathError(true);
    }
  };

  const handleInstantSubscribe = () => {
    sfx.playVictory?.();
    activateVip();
    try {
      confetti({ particleCount: 90, spread: 80, origin: { y: 0.6 } });
    } catch (e) {}
    setTimeout(() => {
      onClose();
    }, 900);
  };

  const handleDeactivate = () => {
    sfx.playTap();
    deactivateVip();
  };

  return (
    <div className="fixed inset-0 bg-slate-900/80 backdrop-blur-md z-50 flex items-center justify-center p-3 sm:p-4 select-none animate-fade-in font-bubble overflow-y-auto">
      <div className="bg-white dark:bg-[#1f2c34] border-4 border-amber-400 dark:border-amber-500 rounded-3xl max-w-lg w-full p-5 sm:p-7 shadow-2xl relative overflow-hidden animate-pop text-slate-800 dark:text-slate-100 my-auto">
        {/* Glow ambient background */}
        <div className="absolute -top-16 -right-16 w-48 h-48 bg-amber-400/25 rounded-full blur-3xl pointer-events-none"></div>
        <div className="absolute -bottom-16 -left-16 w-48 h-48 bg-purple-500/25 rounded-full blur-3xl pointer-events-none"></div>

        {/* Close Button */}
        <button
          onClick={() => {
            sfx.playTap();
            onClose();
          }}
          className="absolute top-4 right-4 w-9 h-9 rounded-full bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-500 dark:text-slate-300 flex items-center justify-center transition-all z-10"
        >
          <X className="w-5 h-5 stroke-[2.5]" />
        </button>

        {/* Header with 3D Crown */}
        <div className="flex flex-col items-center text-center">
          <div className="w-16 h-16 rounded-2xl bg-gradient-to-tr from-amber-400 to-yellow-300 flex items-center justify-center shadow-lg mb-2.5 border-2 border-amber-300">
            <Crown className="w-9 h-9 text-amber-950 fill-amber-950 animate-bounce-subtle" />
          </div>

          <span className="text-[11px] font-black uppercase tracking-widest text-amber-600 dark:text-amber-400 bg-amber-50 dark:bg-amber-950/60 border border-amber-200 dark:border-amber-800 px-3 py-1 rounded-full mb-1">
            Kids Talk VIP Membership
          </span>

          <h2 className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white leading-tight">
            {isVip ? 'VIP Membership Active! 🌟' : 'Unlock Kids Talk VIP Pass'}
          </h2>
          <p className="text-xs sm:text-sm font-bold text-slate-500 dark:text-slate-400 mt-1 max-w-sm">
            {isVip
              ? 'All 5 VIP perks, outfits, infinite hearts, and advanced levels are unlocked!'
              : 'Empower your child with unlimited access, custom outfits & parent insights!'}
          </p>
        </div>

        {/* 5 Real Functional Perks List */}
        <div className="space-y-2.5 my-5">
          <div className="flex items-center gap-3 p-2.5 sm:p-3 rounded-2xl bg-amber-50 dark:bg-slate-800/80 border border-amber-200 dark:border-slate-700">
            <div className="w-8 h-8 rounded-xl bg-amber-400 text-amber-950 flex items-center justify-center shrink-0 font-black text-sm">
              <Unlock className="w-4 h-4 stroke-[2.5]" />
            </div>
            <div className="text-left flex-1">
              <p className="font-black text-xs sm:text-sm text-slate-900 dark:text-white">
                Movers &amp; Flyers World Unlock
              </p>
              <p className="text-[11px] font-semibold text-slate-500 dark:text-slate-400">
                Unlock all intermediate and advanced activities instantly.
              </p>
            </div>
            <span className="text-xs font-black text-amber-500">VIP</span>
          </div>

          <div className="flex items-center gap-3 p-2.5 sm:p-3 rounded-2xl bg-sky-50 dark:bg-slate-800/80 border border-sky-200 dark:border-slate-700">
            <div className="w-8 h-8 rounded-xl bg-sky-400 text-sky-950 flex items-center justify-center shrink-0 font-black text-sm">
              <Shirt className="w-4 h-4 stroke-[2.5]" />
            </div>
            <div className="text-left flex-1">
              <p className="font-black text-xs sm:text-sm text-slate-900 dark:text-white">
                Gigi's Wardrobe (4 Exclusive Outfits)
              </p>
              <p className="text-[11px] font-semibold text-slate-500 dark:text-slate-400">
                Superhero Cape, Astronaut Helmet, Crown &amp; Wizard Hat!
              </p>
            </div>
            <span className="text-xs font-black text-sky-500">VIP</span>
          </div>

          <div className="flex items-center gap-3 p-2.5 sm:p-3 rounded-2xl bg-rose-50 dark:bg-slate-800/80 border border-rose-200 dark:border-slate-700">
            <div className="w-8 h-8 rounded-xl bg-rose-500 text-white flex items-center justify-center shrink-0 font-black text-sm">
              <Heart className="w-4 h-4 fill-white stroke-[2.5]" />
            </div>
            <div className="text-left flex-1">
              <p className="font-black text-xs sm:text-sm text-slate-900 dark:text-white">
                Unlimited Hearts (∞) &amp; Magic Hints
              </p>
              <p className="text-[11px] font-semibold text-slate-500 dark:text-slate-400">
                Never run out of lives and use magic hints when stuck.
              </p>
            </div>
            <span className="text-xs font-black text-rose-500">VIP</span>
          </div>

          <div className="flex items-center gap-3 p-2.5 sm:p-3 rounded-2xl bg-purple-50 dark:bg-slate-800/80 border border-purple-200 dark:border-slate-700">
            <div className="w-8 h-8 rounded-xl bg-purple-500 text-white flex items-center justify-center shrink-0 font-black text-sm">
              <Star className="w-4 h-4 fill-white stroke-[2.5]" />
            </div>
            <div className="text-left flex-1">
              <p className="font-black text-xs sm:text-sm text-slate-900 dark:text-white">
                2X Stars &amp; VIP Sticker Album
              </p>
              <p className="text-[11px] font-semibold text-slate-500 dark:text-slate-400">
                Double points and exclusive animated stickers for jungle scenes.
              </p>
            </div>
            <span className="text-xs font-black text-purple-500">VIP</span>
          </div>

          <div className="flex items-center gap-3 p-2.5 sm:p-3 rounded-2xl bg-emerald-50 dark:bg-slate-800/80 border border-emerald-200 dark:border-slate-700">
            <div className="w-8 h-8 rounded-xl bg-emerald-500 text-white flex items-center justify-center shrink-0 font-black text-sm">
              <Award className="w-4 h-4 stroke-[2.5]" />
            </div>
            <div className="text-left flex-1">
              <p className="font-black text-xs sm:text-sm text-slate-900 dark:text-white">
                Parent Report &amp; Printable Certificate
              </p>
              <p className="text-[11px] font-semibold text-slate-500 dark:text-slate-400">
                Detailed learning analytics and official completion diploma.
              </p>
            </div>
            <span className="text-xs font-black text-emerald-500">VIP</span>
          </div>
        </div>

        {/* Action Controls */}
        {isVip ? (
          <div className="space-y-3">
            <div className="bg-emerald-100 dark:bg-emerald-950/70 border-2 border-emerald-400 rounded-2xl p-3.5 text-center flex items-center justify-center gap-2">
              <ShieldCheck className="w-5 h-5 text-emerald-600 dark:text-emerald-400 shrink-0" />
              <p className="text-emerald-800 dark:text-emerald-300 font-black text-sm">
                VIP Access is active across all devices!
              </p>
            </div>

            <div className="flex gap-2">
              <button
                onClick={() => {
                  sfx.playTap();
                  onClose();
                }}
                className="flex-1 py-3.5 rounded-2xl duo-btn-green font-black text-sm uppercase tracking-wider"
              >
                Keep Exploring
              </button>

              <button
                onClick={handleDeactivate}
                className="px-4 py-3.5 rounded-2xl duo-btn-white text-slate-500 dark:text-slate-400 font-black text-xs flex items-center gap-1.5"
                title="Switch back to Free Mode for testing"
              >
                <RotateCcw className="w-4 h-4" />
                <span>Test Free Mode</span>
              </button>
            </div>
          </div>
        ) : (
          <div className="space-y-3">
            {/* Primary CTA */}
            <button
              onClick={handleInstantSubscribe}
              className="w-full bg-gradient-to-r from-amber-500 via-amber-400 to-yellow-400 hover:from-amber-400 hover:to-yellow-300 border-b-4 border-amber-600 text-amber-950 font-black text-base sm:text-lg py-3.5 rounded-2xl shadow-lg active:translate-y-1 active:border-b-2 flex items-center justify-center gap-2 transition-all cursor-pointer"
            >
              <Sparkles className="w-5 h-5 fill-current" />
              <span>ACTIVATE VIP MEMBERSHIP</span>
            </button>

            {/* 1-Click Parent/Demo Unlock Button with Math Gate */}
            {!showParentGate ? (
              <button
                onClick={() => {
                  sfx.playTap();
                  setShowParentGate(true);
                }}
                className="w-full py-2.5 rounded-xl border border-dashed border-slate-300 dark:border-slate-600 text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-white text-xs font-black flex items-center justify-center gap-1.5 transition-colors"
              >
                <span>🔒 Parent / Teacher Demo Instant Unlock</span>
              </button>
            ) : (
              <form onSubmit={handleParentUnlock} className="p-3 bg-slate-50 dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 animate-slide-up space-y-2">
                <p className="text-xs font-black text-slate-700 dark:text-slate-300">
                  Parent Security Check: What is {num1} + {num2} = ?
                </p>
                <div className="flex gap-2">
                  <input
                    type="number"
                    value={mathAnswer}
                    onChange={(e) => setMathAnswer(e.target.value)}
                    placeholder="Enter 12"
                    autoFocus
                    className="flex-1 px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-800 dark:text-white text-sm font-black focus:outline-none focus:ring-2 focus:ring-[#58cc02]"
                  />
                  <button
                    type="submit"
                    className="px-4 py-2 rounded-xl duo-btn-green font-black text-xs uppercase"
                  >
                    Unlock
                  </button>
                  <button
                    type="button"
                    onClick={() => setShowParentGate(false)}
                    className="p-2 rounded-xl text-slate-400 hover:text-slate-600"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>
                {mathError && (
                  <p className="text-[11px] font-bold text-rose-500">
                    Incorrect answer! Try again: {num1} + {num2} = {correctAnswer}
                  </p>
                )}
              </form>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
