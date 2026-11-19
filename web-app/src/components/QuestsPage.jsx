import React, { useState } from 'react';
import { X, Clock, Gift, Users, Check, Sparkles, ChevronRight, Lock } from 'lucide-react';
import confetti from 'canvas-confetti';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { sfx } from '../utils/audio';

export function QuestsPage({ onClose, stars = 0, isDark }) {
  const [claimed, setClaimed] = useState(false);

  const handleClaim = () => {
    sfx.playSuccess?.();
    setClaimed(true);
    try {
      confetti({
        particleCount: 80,
        spread: 60,
        origin: { y: 0.6 }
      });
    } catch (e) {}
  };

  return (
    <div className={`fixed inset-0 z-40 overflow-y-auto font-bubble select-none ${
      isDark ? 'bg-[#131f24] text-white' : 'bg-white text-slate-800'
    }`}>
      {/* Top Mobile App Bar */}
      <div className={`sticky top-0 z-30 px-4 py-3 flex items-center justify-between border-b ${
        isDark ? 'bg-[#131f24]/95 border-[#37464f]' : 'bg-white/95 border-slate-200'
      } backdrop-blur-md`}>
        <button
          onClick={() => { sfx.playTap(); onClose(); }}
          className="p-1 rounded-full text-slate-400 hover:text-slate-600 dark:hover:text-white"
        >
          <X className="w-6 h-6 stroke-[2.5]" />
        </button>

        <h2 className="text-base font-black">Daily Quests</h2>

        <div className="w-8" />
      </div>

      <div className="max-w-md mx-auto px-4 py-4 pb-28 space-y-6">
        {/* Purple Duolingo Quests Header Banner */}
        <div className="relative overflow-hidden rounded-3xl p-5 bg-gradient-to-r from-purple-600 to-indigo-600 text-white shadow-xl flex items-center justify-between">
          <div className="z-10 max-w-[210px]">
            <h3 className="text-xl font-black leading-tight">Quests</h3>
            <p className="text-xs font-bold text-purple-200 mt-1">
              Complete quests every day to unlock treasure chests and earn bonus stars!
            </p>
          </div>
          <div className="w-24 h-24 shrink-0 -mr-2">
            <img
              src={MASCOT_IMAGES.celebrating}
              alt="Gigi Quests"
              className="w-full h-full object-contain filter drop-shadow-lg animate-duo-bounce"
            />
          </div>
        </div>

        {/* DAILY QUESTS SECTION */}
        <div className="space-y-3">
          <div className="flex items-center justify-between text-xs font-black uppercase text-slate-400">
            <span>Daily Quest</span>
            <div className="flex items-center gap-1 text-slate-400">
              <Clock className="w-3.5 h-3.5 text-amber-500" />
              <span>9 HOURS LEFT</span>
            </div>
          </div>

          {/* Active Quest Card */}
          <div className={`p-4 rounded-3xl border-2 flex items-center justify-between gap-4 ${
            isDark ? 'bg-[#1f2c34] border-[#37464f]' : 'bg-white border-slate-200 shadow-sm'
          }`}>
            <div className="flex-1 space-y-2">
              <h4 className="text-sm font-black text-slate-800 dark:text-white">
                Complete 1 Lesson
              </h4>
              <div className="w-full h-3 rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden">
                <div
                  className="h-full bg-gradient-to-r from-amber-400 to-[#58cc02] rounded-full transition-all duration-500"
                  style={{ width: stars > 0 ? '100%' : '20%' }}
                />
              </div>
              <span className="text-[11px] font-bold text-slate-400">
                {stars > 0 ? '1 / 1 Completed!' : '0 / 1 In Progress'}
              </span>
            </div>

            {/* Chest reward icon */}
            <div className="shrink-0 flex flex-col items-center">
              <div
                onClick={stars > 0 && !claimed ? handleClaim : undefined}
                className={`w-14 h-14 rounded-2xl flex items-center justify-center text-3xl shadow-md transition-transform cursor-pointer ${
                  stars > 0
                    ? claimed
                      ? 'bg-slate-200 dark:bg-slate-800 opacity-60'
                      : 'bg-amber-400 text-amber-950 animate-bounce ring-4 ring-amber-300'
                    : 'bg-slate-100 dark:bg-slate-800 opacity-50'
                }`}
              >
                {claimed ? '✨' : '🎁'}
              </div>
              <span className="text-[10px] font-black uppercase mt-1 text-amber-500">
                {claimed ? 'Claimed' : '+20 XP'}
              </span>
            </div>
          </div>
        </div>

        {/* UPCOMING QUESTS */}
        <div className="space-y-3">
          <h3 className="text-xs font-black uppercase tracking-wider text-slate-400">
            Upcoming
          </h3>

          {[
            { title: 'Score 100% on any lesson', days: 'Unlocks tomorrow' },
            { title: 'Complete 3 daily speech recordings', days: 'Unlocks in 3 days' },
          ].map((item, idx) => (
            <div
              key={idx}
              className={`p-4 rounded-3xl border-2 flex items-center justify-between opacity-60 ${
                isDark ? 'bg-[#1f2c34] border-[#37464f]' : 'bg-slate-50 border-slate-200'
              }`}
            >
              <div className="flex-1 space-y-1.5">
                <h4 className="text-sm font-black text-slate-700 dark:text-slate-300">
                  {item.title}
                </h4>
                <div className="w-3/4 h-2 rounded-full bg-slate-200 dark:bg-slate-700" />
                <span className="text-[10px] font-bold text-slate-400">
                  {item.days}
                </span>
              </div>
              <div className="w-12 h-12 rounded-2xl bg-slate-200 dark:bg-slate-700 flex items-center justify-center text-xl text-slate-400">
                <Lock className="w-5 h-5" />
              </div>
            </div>
          ))}
        </div>

        {/* FRIEND QUEST (ARKADAŞ GÖREVİ) */}
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <h3 className="text-xs font-black uppercase tracking-wider text-slate-400">
              Friend Quest
            </h3>
            <span className="text-xs font-bold text-[#1cb0f6]">Team Up</span>
          </div>

          <div className={`p-4 rounded-3xl border-2 space-y-3 ${
            isDark ? 'bg-[#1f2c34] border-[#37464f]' : 'bg-white border-slate-200'
          }`}>
            <p className="text-xs font-bold text-slate-500 dark:text-slate-400">
              Follow new friends to team up and solve weekly team challenges!
            </p>

            <div className="grid grid-cols-3 gap-2 pt-2">
              {[
                { name: 'Berfin', avatar: '👧', follows: 'Follows you' },
                { name: 'Ömer B.', avatar: '👦', follows: 'Follows you' },
                { name: 'Pelin', avatar: '🦄', follows: 'Knows you' },
              ].map((friend, idx) => (
                <div
                  key={idx}
                  className={`p-3 rounded-2xl border text-center flex flex-col items-center ${
                    isDark ? 'border-[#37464f] bg-[#233138]' : 'border-slate-200 bg-slate-50'
                  }`}
                >
                  <div className="w-10 h-10 rounded-full bg-amber-100 flex items-center justify-center text-xl mb-1 shadow-xs">
                    {friend.avatar}
                  </div>
                  <h5 className="text-xs font-black text-slate-800 dark:text-white truncate w-full">
                    {friend.name}
                  </h5>
                  <span className="text-[9px] font-bold text-slate-400">
                    {friend.follows}
                  </span>
                  <button
                    onClick={() => sfx.playTap()}
                    className="mt-2 w-full py-1 rounded-lg duo-btn-blue text-[10px] font-black uppercase"
                  >
                    Add
                  </button>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
