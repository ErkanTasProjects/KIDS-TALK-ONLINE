import React from 'react';
import { X, Play, Star, Sparkles, BookOpen } from 'lucide-react';
import { Illustration } from './Illustration';
import { sfx } from '../utils/audio';

export function LessonPreviewDrawer({ isOpen, onClose, activity, onStart, isDone, isLocked }) {
  if (!isOpen || !activity) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center bg-black/60 backdrop-blur-xs p-0 animate-fade-in">
      {/* Clickaway backdrop */}
      <div className="absolute inset-0" onClick={onClose} />

      <div className="relative w-full max-w-md bg-white dark:bg-[#1f2c34] rounded-t-3xl border-t-2 border-slate-200 dark:border-[#37464f] p-6 shadow-2xl animate-slide-up z-10 flex flex-col items-center text-center">
        {/* Top pill bar */}
        <div className="w-12 h-1.5 rounded-full bg-slate-300 dark:bg-slate-600 mb-4" />

        {/* Close button */}
        <button
          onClick={() => { sfx.playTap(); onClose(); }}
          className="absolute top-4 right-4 p-2 rounded-full text-slate-400 hover:text-slate-600 dark:hover:text-white"
        >
          <X className="w-6 h-6 stroke-[2.5]" />
        </button>

        {/* Lesson Big Icon */}
        <div className="w-24 h-24 rounded-3xl bg-amber-100 dark:bg-amber-900/30 border-2 border-amber-300 dark:border-amber-700/50 flex items-center justify-center p-4 mb-3 shadow-inner">
          <Illustration name={activity.icon} className="w-full h-full object-contain" />
        </div>

        {/* Lesson Title & Subtitle */}
        <span className="text-xs font-black uppercase tracking-wider text-[#58cc02]">
          {isDone ? 'Completed' : 'Next Lesson'}
        </span>
        <h3 className="text-xl font-black text-slate-800 dark:text-white mt-1">
          {activity.shortTitle}
        </h3>
        <p className="text-xs font-bold text-slate-500 dark:text-slate-400 mt-1 max-w-xs">
          {activity.subtitle}
        </p>

        {/* Reward pill */}
        <div className="flex items-center gap-2 mt-4 px-3.5 py-1.5 rounded-full bg-amber-50 dark:bg-amber-950/40 border border-amber-200 dark:border-amber-800/40 text-amber-700 dark:text-amber-300 text-xs font-black">
          <Star className="w-4 h-4 fill-amber-400 text-amber-500" />
          <span>Reward: +3 Stars &amp; +15 XP</span>
        </div>

        {/* Action Button */}
        <div className="w-full mt-6 space-y-2">
          <button
            onClick={() => {
              sfx.playTap();
              onClose();
              onStart(activity);
            }}
            className="w-full py-4 rounded-2xl duo-btn-green font-black text-base uppercase tracking-wider shadow-lg flex items-center justify-center gap-2"
          >
            <Play className="w-5 h-5 fill-white" />
            <span>{isDone ? 'Practice Again' : 'Start (+15 XP)'}</span>
          </button>
        </div>
      </div>
    </div>
  );
}
