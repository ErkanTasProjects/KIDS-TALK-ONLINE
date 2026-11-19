import React, { useState } from 'react';
import { X, Trophy, Clock, Sparkles, ChevronRight, Play, Star, Shield, ArrowUp } from 'lucide-react';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { sfx } from '../utils/audio';

export function LeaguePage({ onClose, onStartLesson, isDark }) {
  const [showLeaderboard, setShowLeaderboard] = useState(false);

  const leagues = [
    { name: 'Sapphire', color: 'from-sky-400 to-blue-500', icon: '💎', active: false, done: true },
    { name: 'Ruby', color: 'from-rose-500 to-red-600', icon: '🔴', active: false, done: true },
    { name: 'Emerald', color: 'from-emerald-400 to-green-600', icon: '🍀', active: true, done: false },
    { name: 'Amethyst', color: 'from-purple-400 to-indigo-600', icon: '💜', active: false, done: false, locked: true },
    { name: 'Diamond', color: 'from-cyan-300 to-sky-400', icon: '✨', active: false, done: false, locked: true },
  ];

  const dummyLeaderboard = [
    { rank: 1, name: 'Alex K.', xp: 620, avatar: '🦁', promotion: true },
    { rank: 2, name: 'Emma Watson', xp: 580, avatar: '🦊', promotion: true },
    { rank: 3, name: 'Liam Smith', xp: 540, avatar: '🐼', promotion: true },
    { rank: 4, name: 'You (Gigi)', xp: 480, avatar: '🦒', isMe: true },
    { rank: 5, name: 'Noah Brown', xp: 410, avatar: '🐯' },
    { rank: 6, name: 'Sophia Miller', xp: 390, avatar: '🐰' },
    { rank: 7, name: 'Lucas Green', xp: 350, avatar: '🐨' },
    { rank: 8, name: 'Mia Taylor', xp: 310, avatar: '🦄' },
    { rank: 9, name: 'Ethan Jones', xp: 260, avatar: '🐻' },
    { rank: 10, name: 'Olivia White', xp: 220, avatar: '🐱' },
  ];

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

        <div className="text-center">
          <h2 className="text-base font-black">Emerald League</h2>
          <div className="flex items-center justify-center gap-1 text-[11px] font-bold text-slate-400">
            <Clock className="w-3 h-3 text-amber-500" />
            <span>2 DAYS LEFT</span>
          </div>
        </div>

        <div className="w-8" />
      </div>

      <div className="max-w-md mx-auto px-4 py-6 pb-28 space-y-6">
        {/* Trophy progression row */}
        <div className="flex items-center justify-around py-3 border-b border-slate-200 dark:border-[#37464f]">
          {leagues.map((lg, idx) => (
            <div key={idx} className="flex flex-col items-center">
              <div className={`relative w-12 h-12 rounded-2xl flex items-center justify-center text-xl transition-all ${
                lg.active
                  ? 'bg-gradient-to-b from-emerald-400 to-green-600 text-white scale-110 shadow-lg ring-4 ring-emerald-300/40 animate-pulse'
                  : lg.done
                  ? 'bg-slate-200 dark:bg-slate-800 text-slate-500 opacity-90'
                  : 'bg-slate-100 dark:bg-slate-800/50 text-slate-300 dark:text-slate-600 opacity-50'
              }`}>
                <span>{lg.icon}</span>
                {lg.active && (
                  <div className="absolute -top-1 -right-1 w-3 h-3 bg-amber-400 rounded-full border-2 border-white" />
                )}
              </div>
              <span className={`text-[10px] font-black mt-1.5 ${
                lg.active ? 'text-emerald-500' : 'text-slate-400'
              }`}>
                {lg.name}
              </span>
            </div>
          ))}
        </div>

        {/* Tab switch between preview / active leaderboard */}
        <div className="flex rounded-2xl p-1 bg-slate-100 dark:bg-[#1f2c34] border border-slate-200 dark:border-[#37464f]">
          <button
            onClick={() => { sfx.playTap(); setShowLeaderboard(false); }}
            className={`flex-1 py-2 rounded-xl text-xs font-black transition-all ${
              !showLeaderboard
                ? 'bg-white dark:bg-[#2b3942] text-slate-800 dark:text-white shadow-xs'
                : 'text-slate-400 hover:text-slate-600'
            }`}
          >
            League Status
          </button>
          <button
            onClick={() => { sfx.playTap(); setShowLeaderboard(true); }}
            className={`flex-1 py-2 rounded-xl text-xs font-black transition-all ${
              showLeaderboard
                ? 'bg-white dark:bg-[#2b3942] text-slate-800 dark:text-white shadow-xs'
                : 'text-slate-400 hover:text-slate-600'
            }`}
          >
            Live Rankings
          </button>
        </div>

        {!showLeaderboard ? (
          /* Sleeping Mascot State (Exact screenshot match) */
          <div className="flex flex-col items-center text-center py-8 space-y-4">
            <div className="relative w-44 h-44 flex items-center justify-center">
              {/* Sleeping ZZZ animation */}
              <div className="absolute -top-2 right-4 flex flex-col items-center">
                <span className="text-xl font-black text-[#58cc02] animate-bounce" style={{ animationDelay: '0s' }}>Z</span>
                <span className="text-sm font-black text-[#58cc02]/70 animate-bounce" style={{ animationDelay: '0.3s' }}>z</span>
                <span className="text-xs font-black text-[#58cc02]/40 animate-bounce" style={{ animationDelay: '0.6s' }}>z</span>
              </div>

              {/* Gigi resting */}
              <div className="w-36 h-36 rounded-full bg-emerald-100 dark:bg-emerald-950/40 p-4 border-2 border-emerald-300 dark:border-emerald-700/50 flex items-center justify-center shadow-inner">
                <img
                  src={MASCOT_IMAGES.thinking}
                  alt="Gigi Resting"
                  className="w-full h-full object-contain filter drop-shadow-md animate-duo-bounce"
                />
              </div>
            </div>

            <div className="max-w-xs space-y-2">
              <h3 className="text-xl font-black text-slate-800 dark:text-white">
                Don't Miss This Week!
              </h3>
              <p className="text-sm font-bold text-slate-500 dark:text-slate-400 leading-relaxed">
                Complete a lesson today to enter this week's Emerald League and compete with kids worldwide!
              </p>
            </div>

            <button
              onClick={() => {
                sfx.playTap();
                onClose();
                onStartLesson();
              }}
              className="w-full max-w-xs py-4 rounded-2xl duo-btn-green font-black text-sm uppercase tracking-wider shadow-lg flex items-center justify-center gap-2 mt-4"
            >
              <Play className="w-5 h-5 fill-white" />
              <span>Start A Lesson</span>
            </button>
          </div>
        ) : (
          /* Live Leaderboard List */
          <div className="space-y-2">
            <div className="p-3 rounded-2xl bg-emerald-50 dark:bg-emerald-950/30 border border-emerald-200 dark:border-emerald-800/40 flex items-center justify-between text-xs font-black text-emerald-700 dark:text-emerald-300">
              <div className="flex items-center gap-1.5">
                <ArrowUp className="w-4 h-4 text-emerald-500" />
                <span>TOP 3 ADVANCE TO AMETHYST LEAGUE!</span>
              </div>
              <span>🔥</span>
            </div>

            {dummyLeaderboard.map((user, idx) => (
              <div
                key={idx}
                className={`flex items-center justify-between p-3.5 rounded-2xl border-2 transition-all ${
                  user.isMe
                    ? 'border-[#58cc02] bg-emerald-50/70 dark:bg-emerald-950/40 shadow-sm'
                    : 'border-slate-200 dark:border-[#37464f] bg-white dark:bg-[#1f2c34]'
                }`}
              >
                <div className="flex items-center gap-3">
                  <span className={`w-6 text-center text-sm font-black ${
                    user.rank === 1 ? 'text-amber-500 text-base' :
                    user.rank === 2 ? 'text-slate-400 text-base' :
                    user.rank === 3 ? 'text-amber-700 text-base' :
                    'text-slate-400'
                  }`}>
                    {user.rank}
                  </span>

                  <div className="w-10 h-10 rounded-full bg-slate-100 dark:bg-slate-800 flex items-center justify-center text-xl shadow-xs">
                    {user.avatar}
                  </div>

                  <div>
                    <h4 className="text-sm font-black text-slate-800 dark:text-white">
                      {user.name}
                    </h4>
                    {user.promotion && (
                      <span className="text-[10px] font-bold text-emerald-500 flex items-center gap-0.5">
                        <ArrowUp className="w-3 h-3" /> Promotion Zone
                      </span>
                    )}
                  </div>
                </div>

                <div className="text-right">
                  <span className="text-sm font-black text-slate-800 dark:text-white">
                    {user.xp} XP
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
