import React from 'react';
import { CheckCircle2, AlertCircle, ArrowRight, RotateCcw } from 'lucide-react';
import { sfx } from '../utils/audio';

export function BottomActionDrawer({
  status = 'idle', // 'idle' | 'ready' | 'correct' | 'incorrect'
  onCheck,
  onContinue,
  onTryAgain,
  checkLabel = 'CHECK',
  encouragement = 'Awesome job! You got it!',
  hint = "Let's try that again! Listen carefully.",
}) {
  const isCorrect = status === 'correct';
  const isIncorrect = status === 'incorrect';
  const isFeedback = isCorrect || isIncorrect;

  const bgClasses = isCorrect
    ? 'bg-emerald-100 dark:bg-emerald-950/90 border-emerald-300 dark:border-emerald-700'
    : isIncorrect
    ? 'bg-rose-100 dark:bg-rose-950/90 border-rose-300 dark:border-rose-700'
    : 'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800';

  const handleAction = () => {
    if (isCorrect) {
      sfx.playTap();
      if (onContinue) onContinue();
    } else if (isIncorrect) {
      sfx.playTap();
      if (onTryAgain) onTryAgain();
    } else if (status === 'ready') {
      sfx.playTap();
      if (onCheck) onCheck();
    }
  };

  return (
    <div
      className={`fixed bottom-0 left-0 right-0 h-28 border-t-4 transition-colors duration-300 z-40 flex items-center justify-center px-4 ${bgClasses}`}
    >
      <div className="w-full max-w-3xl mx-auto flex items-center justify-between gap-4">
        {/* Left side: Feedback message or status */}
        <div className="flex-1 flex items-center gap-3">
          {isCorrect && (
            <div className="flex items-center gap-2 text-emerald-800 dark:text-emerald-200 animate-pop">
              <div className="w-10 h-10 rounded-full bg-emerald-500 text-white flex items-center justify-center shrink-0 shadow-sm">
                <CheckCircle2 className="w-6 h-6 stroke-[3]" />
              </div>
              <div>
                <p className="font-extrabold text-lg leading-tight">Super!</p>
                <p className="text-xs sm:text-sm font-semibold text-emerald-700 dark:text-emerald-300">{encouragement}</p>
              </div>
            </div>
          )}

          {isIncorrect && (
            <div className="flex items-center gap-2 text-rose-800 dark:text-rose-200 animate-pop">
              <div className="w-10 h-10 rounded-full bg-rose-500 text-white flex items-center justify-center shrink-0 shadow-sm">
                <AlertCircle className="w-6 h-6 stroke-[3]" />
              </div>
              <div>
                <p className="font-extrabold text-lg leading-tight">Almost!</p>
                <p className="text-xs sm:text-sm font-semibold text-rose-700 dark:text-rose-300">{hint}</p>
              </div>
            </div>
          )}

          {!isFeedback && (
            <div className="hidden sm:block text-slate-400 dark:text-slate-500 font-bold text-sm">
              {status === 'ready' ? 'Ready to check? Press the button!' : 'Pick your answer above!'}
            </div>
          )}
        </div>

        {/* Right side: Action Button */}
        <div>
          {isCorrect ? (
            <button
              onClick={handleAction}
              className="bg-emerald-500 hover:bg-emerald-400 active:translate-y-1 border-b-4 border-emerald-600 active:border-b-2 text-white font-extrabold text-lg tracking-wide rounded-2xl px-8 sm:px-12 py-3.5 shadow-md flex items-center gap-2 transition-all"
            >
              <span>CONTINUE</span>
              <ArrowRight className="w-5 h-5 stroke-[3]" />
            </button>
          ) : isIncorrect ? (
            <button
              onClick={handleAction}
              className="bg-rose-500 hover:bg-rose-400 active:translate-y-1 border-b-4 border-rose-600 active:border-b-2 text-white font-extrabold text-lg tracking-wide rounded-2xl px-8 sm:px-10 py-3.5 shadow-md flex items-center gap-2 transition-all"
            >
              <RotateCcw className="w-5 h-5 stroke-[3]" />
              <span>TRY AGAIN</span>
            </button>
          ) : (
            <button
              onClick={handleAction}
              disabled={status !== 'ready'}
              className={`font-extrabold text-lg tracking-wide rounded-2xl px-8 sm:px-12 py-3.5 transition-all shadow-sm ${
                status === 'ready'
                  ? 'bg-emerald-500 hover:bg-emerald-400 active:translate-y-1 border-b-4 border-emerald-600 active:border-b-2 text-white cursor-pointer'
                  : 'bg-slate-200 dark:bg-slate-800 border-b-4 border-slate-300 dark:border-slate-700 text-slate-400 dark:text-slate-600 cursor-not-allowed'
              }`}
            >
              {checkLabel}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
