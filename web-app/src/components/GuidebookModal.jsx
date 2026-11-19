import React from 'react';
import { X, Volume2, BookOpen, Sparkles } from 'lucide-react';
import { speakText, sfx } from '../utils/audio';

export function GuidebookModal({ isOpen, onClose, world }) {
  if (!isOpen || !world) return null;

  const phrasesByWorld = {
    starter: [
      { en: 'Hello!', tr: 'A friendly greeting' },
      { en: 'Good morning!', tr: 'Greet when waking up' },
      { en: 'How are you?', tr: 'Ask how a friend is doing' },
      { en: 'I brush my teeth.', tr: 'Daily routine' },
      { en: 'This is my bag.', tr: 'School objects' },
    ],
    movers: [
      { en: "How's it going?", tr: 'Casual hello to buddies' },
      { en: 'Nice to meet you!', tr: 'When meeting someone new' },
      { en: 'I go to school by bus.', tr: 'Transportation routine' },
      { en: 'Math is my favorite subject.', tr: 'School favorites' },
      { en: 'Art is fun!', tr: 'Expressing feelings' },
    ],
    flyers: [
      { en: 'My name is Alex.', tr: 'Introducing yourself' },
      { en: 'I am ten years old.', tr: 'Stating your age' },
      { en: 'I usually watch TV after dinner.', tr: 'Expressing habits' },
      { en: 'I love playing football.', tr: 'Hobbies and sports' },
      { en: 'Tell me about your best friend.', tr: 'Conversational prompt' },
    ],
  };

  const phrases = phrasesByWorld[world.id] || phrasesByWorld.starter;

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-black/60 backdrop-blur-xs p-0 sm:p-4 animate-fade-in">
      <div className="w-full max-w-md bg-white dark:bg-[#1f2c34] rounded-t-3xl sm:rounded-3xl max-h-[85vh] overflow-y-auto border-t-2 sm:border-2 border-slate-200 dark:border-[#37464f] shadow-2xl animate-slide-up flex flex-col">
        {/* Header */}
        <div className="sticky top-0 bg-white/95 dark:bg-[#1f2c34]/95 backdrop-blur-md px-5 py-4 border-b border-slate-200 dark:border-[#37464f] flex items-center justify-between z-10">
          <div className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-xl bg-amber-100 dark:bg-amber-900/40 flex items-center justify-center text-amber-500">
              <BookOpen className="w-5 h-5" />
            </div>
            <div>
              <span className="text-[11px] font-black uppercase text-slate-400 tracking-wider">Guidebook</span>
              <h3 className="text-base font-black text-slate-800 dark:text-white leading-tight">{world.title}</h3>
            </div>
          </div>
          <button
            onClick={() => { sfx.playTap(); onClose(); }}
            className="p-1.5 rounded-full hover:bg-slate-100 dark:hover:bg-[#2b3942] text-slate-400 hover:text-slate-600 dark:hover:text-white"
          >
            <X className="w-6 h-6 stroke-[2.5]" />
          </button>
        </div>

        {/* Content */}
        <div className="p-5 space-y-4">
          <div className="p-3.5 rounded-2xl bg-amber-50 dark:bg-amber-950/30 border border-amber-200 dark:border-amber-800/40 flex items-center gap-3">
            <Sparkles className="w-5 h-5 text-amber-500 shrink-0" />
            <p className="text-xs font-bold text-amber-800 dark:text-amber-200">
              Listen and repeat key phrases in this unit to speak like a native!
            </p>
          </div>

          <div className="space-y-2.5">
            {phrases.map((p, idx) => (
              <div
                key={idx}
                onClick={() => { sfx.playTap(); speakText(p.en); }}
                className="group flex items-center justify-between p-3.5 rounded-2xl border-2 border-slate-200 dark:border-[#37464f] bg-white dark:bg-[#233138] hover:border-[#58cc02] dark:hover:border-[#58cc02] cursor-pointer transition-all active:scale-[0.98]"
              >
                <div>
                  <p className="text-base font-black text-slate-800 dark:text-white group-hover:text-[#58cc02] transition-colors">
                    "{p.en}"
                  </p>
                  <p className="text-xs font-semibold text-slate-400 dark:text-slate-400 mt-0.5">
                    {p.tr}
                  </p>
                </div>
                <button
                  type="button"
                  className="w-10 h-10 rounded-xl bg-sky-50 dark:bg-sky-900/30 text-[#1cb0f6] flex items-center justify-center group-hover:scale-110 transition-transform shadow-xs"
                >
                  <Volume2 className="w-5 h-5 stroke-[2.5]" />
                </button>
              </div>
            ))}
          </div>
        </div>

        {/* Footer */}
        <div className="p-5 pt-2 border-t border-slate-200 dark:border-[#37464f]">
          <button
            onClick={() => { sfx.playTap(); onClose(); }}
            className="w-full py-3.5 rounded-2xl duo-btn-green font-black text-sm uppercase tracking-wider"
          >
            Got It!
          </button>
        </div>
      </div>
    </div>
  );
}
