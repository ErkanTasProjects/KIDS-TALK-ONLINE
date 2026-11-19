import React from 'react';
import { X, Check, Lock, ChevronRight, Sparkles } from 'lucide-react';
import { sfx } from '../utils/audio';

export function SectionPickerModal({ isOpen, onClose, worlds, selectedWorldId, onSelectWorld }) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-black/60 backdrop-blur-xs p-0 sm:p-4 animate-fade-in">
      <div className="relative w-full max-w-md bg-white dark:bg-[#1f2c34] rounded-t-3xl sm:rounded-3xl max-h-[85vh] overflow-y-auto border-t-2 sm:border-2 border-slate-200 dark:border-[#37464f] shadow-2xl animate-slide-up flex flex-col">
        {/* Header */}
        <div className="sticky top-0 bg-white/95 dark:bg-[#1f2c34]/95 backdrop-blur-md px-5 py-4 border-b border-slate-200 dark:border-[#37464f] flex items-center justify-between z-10">
          <div>
            <h3 className="text-lg font-black text-slate-800 dark:text-white">Choose Section</h3>
            <p className="text-xs font-bold text-slate-400">Select your age group and level</p>
          </div>
          <button
            onClick={() => { sfx.playTap(); onClose(); }}
            className="p-1.5 rounded-full hover:bg-slate-100 dark:hover:bg-[#2b3942] text-slate-400 hover:text-slate-600 dark:hover:text-white"
          >
            <X className="w-6 h-6 stroke-[2.5]" />
          </button>
        </div>

        {/* Section List */}
        <div className="p-5 space-y-3">
          {worlds.map((w, index) => {
            const isSelected = w.id === selectedWorldId;

            return (
              <div
                key={w.id}
                onClick={() => {
                  sfx.playSuccess?.();
                  onSelectWorld(w.id);
                  onClose();
                }}
                className={`flex items-center justify-between p-4 rounded-2xl border-2 cursor-pointer transition-all active:scale-[0.98] ${
                  isSelected
                    ? 'border-[#58cc02] bg-emerald-50/60 dark:bg-emerald-950/30 shadow-md ring-2 ring-[#58cc02]/30'
                    : 'border-slate-200 dark:border-[#37464f] bg-white dark:bg-[#233138] hover:border-slate-300 dark:hover:border-slate-600'
                }`}
              >
                <div className="flex items-center gap-3.5">
                  <div className={`w-12 h-12 rounded-2xl flex items-center justify-center text-2xl shadow-xs ${
                    isSelected ? 'bg-[#58cc02] text-white' : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300'
                  }`}>
                    {w.emoji}
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="text-[11px] font-black uppercase tracking-wider text-[#1cb0f6]">
                        {w.section} · {w.unit}
                      </span>
                      {isSelected && (
                        <span className="px-2 py-0.5 rounded-full bg-[#58cc02] text-white text-[9px] font-black uppercase">
                          Active
                        </span>
                      )}
                    </div>
                    <h4 className="text-base font-black text-slate-800 dark:text-white leading-snug">
                      {w.title}
                    </h4>
                    <p className="text-xs font-bold text-slate-400 dark:text-slate-400">
                      {w.badge}
                    </p>
                  </div>
                </div>

                <div className="shrink-0 ml-2">
                  {isSelected ? (
                    <div className="w-8 h-8 rounded-full bg-[#58cc02] text-white flex items-center justify-center shadow-xs">
                      <Check className="w-5 h-5 stroke-[3]" />
                    </div>
                  ) : (
                    <ChevronRight className="w-5 h-5 text-slate-300 dark:text-slate-600" />
                  )}
                </div>
              </div>
            );
          })}
        </div>

        {/* Footer info */}
        <div className="p-4 border-t border-slate-200 dark:border-[#37464f] text-center">
          <p className="text-xs font-bold text-slate-400">
            Progress and stars are automatically saved across all sections!
          </p>
        </div>
      </div>
    </div>
  );
}
