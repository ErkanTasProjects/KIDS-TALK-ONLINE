import React, { useState } from 'react';
import {
  X,
  Settings,
  UserPlus,
  QrCode,
  Flame,
  Zap,
  Shield,
  Star,
  Award,
  Share2,
  ChevronRight,
  Smile,
  Crown
} from 'lucide-react';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { usePremium } from '../context/PremiumContext';
import { sfx } from '../utils/audio';

export function ProfilePage({ stars = 0, streak = 0, onClose, isDark }) {
  const { isVip } = usePremium();
  const [activeTab, setActiveTab] = useState('overview');

  // Real stats derived from actual star count
  const totalXP = stars * 15;
  const coursesCompleted = Math.floor(stars / 10);

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

        <h2 className="text-base font-black tracking-wide">My Profile</h2>

        <button
          onClick={() => sfx.playTap()}
          className="text-slate-400 hover:text-slate-600 dark:hover:text-white"
        >
          <Settings className="w-5 h-5" />
        </button>
      </div>

      <div className="max-w-md mx-auto px-4 py-6 pb-28 space-y-6">
        {/* Profile Avatar — plain Gigi image, NO costume overlay */}
        <div className="flex flex-col items-center text-center">
          <div className="relative w-32 h-32 rounded-full p-2 bg-gradient-to-b from-amber-200 to-amber-400 border-4 border-amber-300 shadow-xl flex items-center justify-center overflow-hidden">
            <img
              src={MASCOT_IMAGES.celebrating}
              alt="Gigi"
              className="w-full h-full object-contain animate-duo-bounce"
            />
            {/* VIP Crown badge — only shown when VIP */}
            {isVip && (
              <div className="absolute top-1 right-1 w-7 h-7 rounded-full bg-amber-400 text-white flex items-center justify-center shadow-md">
                <Crown className="w-4 h-4 fill-white" />
              </div>
            )}
          </div>

          <h1 className="text-2xl font-black mt-3">Gigi Learner</h1>
          <p className="text-xs font-bold text-slate-400 uppercase tracking-wider mt-0.5">
            @gigilearner · Joined 2024
          </p>

          {/* Real stats row */}
          <div className="flex items-center gap-6 mt-4 text-xs font-bold text-slate-400">
            <div className="flex items-center gap-1.5">
              <span>🇺🇸</span>
              <span className="text-slate-800 dark:text-white font-black text-sm">{coursesCompleted}</span>
              <span>Courses</span>
            </div>
            <div className="w-1 h-1 rounded-full bg-slate-300 dark:bg-slate-700" />
            <div>
              <span className="text-slate-800 dark:text-white font-black text-sm">0</span> Following
            </div>
            <div className="w-1 h-1 rounded-full bg-slate-300 dark:bg-slate-700" />
            <div>
              <span className="text-slate-800 dark:text-white font-black text-sm">0</span> Followers
            </div>
          </div>

          {/* Action buttons */}
          <div className="flex items-center gap-3 w-full mt-5">
            <button
              onClick={() => sfx.playTap()}
              className="flex-1 py-3 px-4 rounded-2xl duo-btn-white font-black text-xs uppercase tracking-wider flex items-center justify-center gap-2 shadow-xs"
            >
              <UserPlus className="w-4 h-4" />
              <span>Add Friends</span>
            </button>
            <button
              onClick={() => sfx.playTap()}
              className="p-3 rounded-2xl duo-btn-white text-slate-600 dark:text-slate-300 shadow-xs"
            >
              <QrCode className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Motivational Banner */}
        <div className="relative overflow-hidden rounded-3xl p-4 bg-gradient-to-r from-sky-500 to-blue-600 text-white shadow-lg flex items-center justify-between">
          <div className="z-10 max-w-[210px]">
            <h4 className="text-sm font-black leading-snug">Share Your English Journey!</h4>
            <p className="text-[11px] font-bold text-sky-100 mt-1">
              Show your parents and teacher your {stars} stars collection!
            </p>
            <button
              onClick={() => sfx.playSuccess?.()}
              className="mt-3 px-4 py-2 rounded-xl bg-white text-sky-600 font-black text-xs uppercase tracking-wider shadow-sm active:scale-95 transition-transform"
            >
              Share Now
            </button>
          </div>
          <div className="w-20 h-20 shrink-0">
            <img src={MASCOT_IMAGES.waving} alt="Gigi" className="w-full h-full object-contain filter drop-shadow-md" />
          </div>
        </div>

        {/* OVERVIEW SECTION */}
        <div className="space-y-3">
          <h3 className="text-xs font-black uppercase tracking-wider text-slate-400">
            Overview
          </h3>

          <div className="grid grid-cols-2 gap-3">
            {/* Streak */}
            <div className={`p-4 rounded-2xl border-2 flex items-center gap-3 ${
              isDark ? 'bg-[#1f2c34] border-[#37464f]' : 'bg-white border-slate-200'
            }`}>
              <div className="w-10 h-10 rounded-xl bg-orange-100 dark:bg-orange-950/40 text-orange-500 flex items-center justify-center">
                <Flame className="w-6 h-6 fill-orange-500" />
              </div>
              <div>
                <p className="text-xs font-bold text-slate-400">Streak</p>
                <p className="text-base font-black">{streak} Days</p>
              </div>
            </div>

            {/* Stars Earned — real value from prop */}
            <div className={`p-4 rounded-2xl border-2 flex items-center gap-3 ${
              isDark ? 'bg-[#1f2c34] border-[#37464f]' : 'bg-white border-slate-200'
            }`}>
              <div className="w-10 h-10 rounded-xl bg-amber-100 dark:bg-amber-950/40 text-amber-500 flex items-center justify-center">
                <Star className="w-6 h-6 fill-amber-400" />
              </div>
              <div>
                <p className="text-xs font-bold text-slate-400">Stars Earned</p>
                <p className="text-base font-black">{stars} Stars</p>
              </div>
            </div>

            {/* League */}
            <div className={`p-4 rounded-2xl border-2 flex items-center gap-3 ${
              isDark ? 'bg-[#1f2c34] border-[#37464f]' : 'bg-white border-slate-200'
            }`}>
              <div className="w-10 h-10 rounded-xl bg-emerald-100 dark:bg-emerald-950/40 text-emerald-500 flex items-center justify-center">
                <Shield className="w-6 h-6 fill-emerald-500" />
              </div>
              <div>
                <p className="text-xs font-bold text-slate-400">Current League</p>
                <p className="text-base font-black text-emerald-500">Emerald</p>
              </div>
            </div>

            {/* Total XP — derived from real stars */}
            <div className={`p-4 rounded-2xl border-2 flex items-center gap-3 ${
              isDark ? 'bg-[#1f2c34] border-[#37464f]' : 'bg-white border-slate-200'
            }`}>
              <div className="w-10 h-10 rounded-xl bg-purple-100 dark:bg-purple-950/40 text-purple-500 flex items-center justify-center">
                <Zap className="w-6 h-6 fill-purple-500" />
              </div>
              <div>
                <p className="text-xs font-bold text-slate-400">Total XP</p>
                <p className="text-base font-black text-purple-500">{totalXP}</p>
              </div>
            </div>
          </div>
        </div>

        {/* FRIEND STREAKS */}
        <div className="space-y-3">
          <h3 className="text-xs font-black uppercase tracking-wider text-slate-400">
            Friend Streaks
          </h3>

          <div className="flex items-center gap-3 overflow-x-auto pb-2">
            {[1, 2, 3, 4, 5].map((i) => (
              <button
                key={i}
                onClick={() => sfx.playTap()}
                className={`w-14 h-14 rounded-full border-2 border-dashed flex items-center justify-center text-slate-400 hover:text-slate-600 dark:hover:text-white transition-colors shrink-0 ${
                  isDark ? 'border-[#37464f] hover:border-slate-400' : 'border-slate-300 hover:border-slate-400'
                }`}
              >
                <span className="text-xl font-black">+</span>
              </button>
            ))}
          </div>
        </div>

        {/* MONTHLY BADGES */}
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <h3 className="text-xs font-black uppercase tracking-wider text-slate-400">
              Monthly Badges
            </h3>
            <span className="text-xs font-black text-[#1cb0f6] cursor-pointer">View All</span>
          </div>

          <div className="grid grid-cols-3 gap-3">
            {[
              { title: 'Fast Learner', icon: '⚡', color: 'bg-amber-500', unlocked: stars >= 5 },
              { title: 'Speaking Star', icon: '🎤', color: 'bg-emerald-500', unlocked: stars >= 15 },
              { title: 'Night Owl', icon: '🦉', color: 'bg-indigo-500', unlocked: stars >= 30 },
            ].map((badge, idx) => (
              <div
                key={idx}
                className={`p-3 rounded-2xl border-2 text-center flex flex-col items-center ${
                  isDark ? 'bg-[#1f2c34] border-[#37464f]' : 'bg-white border-slate-200'
                } ${!badge.unlocked ? 'opacity-40 grayscale' : ''}`}
              >
                <div className={`w-12 h-12 rounded-2xl ${badge.color} text-white text-2xl flex items-center justify-center shadow-md mb-2`}>
                  {badge.icon}
                </div>
                <span className="text-[11px] font-black">{badge.title}</span>
                {!badge.unlocked && (
                  <span className="text-[9px] text-slate-400 font-bold mt-0.5">Locked</span>
                )}
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
