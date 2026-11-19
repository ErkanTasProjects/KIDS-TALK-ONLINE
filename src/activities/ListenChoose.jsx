import React, { useState, useEffect } from 'react';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { Illustration } from '../components/Illustration';
import { shuffleArray } from '../utils/shuffle';
import { speakText, sfx } from '../utils/audio';

const QUESTIONS = [
  {
    sentence: 'This is my bag.',
    correctId: 'bag',
    options: [
      { id: 'bag', label: 'Bag', icon: 'bag' },
      { id: 'book', label: 'Book', icon: 'book' },
      { id: 'pencil', label: 'Pencil', icon: 'pencil' },
    ]
  },
  {
    sentence: 'This is my book.',
    correctId: 'book',
    options: [
      { id: 'ruler', label: 'Ruler', icon: 'ruler' },
      { id: 'book', label: 'Book', icon: 'book' },
      { id: 'notebook', label: 'Notebook', icon: 'notebook' },
    ]
  },
  {
    sentence: 'This is my pencil.',
    correctId: 'pencil',
    options: [
      { id: 'pencil', label: 'Pencil', icon: 'pencil' },
      { id: 'bag', label: 'Bag', icon: 'bag' },
      { id: 'ruler', label: 'Ruler', icon: 'ruler' },
    ]
  },
  {
    sentence: 'This is my ruler.',
    correctId: 'ruler',
    options: [
      { id: 'book', label: 'Book', icon: 'book' },
      { id: 'notebook', label: 'Notebook', icon: 'notebook' },
      { id: 'ruler', label: 'Ruler', icon: 'ruler' },
    ]
  },
  {
    sentence: 'This is my notebook.',
    correctId: 'notebook',
    options: [
      { id: 'notebook', label: 'Notebook', icon: 'notebook' },
      { id: 'pencil', label: 'Pencil', icon: 'pencil' },
      { id: 'bag', label: 'Bag', icon: 'bag' },
    ]
  },
  {
    sentence: 'I study English.',
    correctId: 'notebook',
    options: [
      { id: 'play', label: 'Play', icon: 'play' },
      { id: 'notebook', label: 'Study English', icon: 'study_english' },
      { id: 'draw', label: 'Draw', icon: 'draw' },
    ]
  },
  {
    sentence: 'I read a book.',
    correctId: 'book',
    options: [
      { id: 'book', label: 'Read a book', icon: 'read_book' },
      { id: 'pencil', label: 'Write', icon: 'write' },
      { id: 'play', label: 'Play', icon: 'play' },
    ]
  },
  {
    sentence: 'I write.',
    correctId: 'pencil',
    options: [
      { id: 'draw', label: 'Draw', icon: 'draw' },
      { id: 'pencil', label: 'Write', icon: 'write' },
      { id: 'book', label: 'Read', icon: 'read_book' },
    ]
  },
  {
    sentence: 'I draw.',
    correctId: 'draw',
    options: [
      { id: 'draw', label: 'Draw', icon: 'draw' },
      { id: 'notebook', label: 'Study', icon: 'study_english' },
      { id: 'pencil', label: 'Write', icon: 'write' },
    ]
  },
  {
    sentence: 'I play.',
    correctId: 'play',
    options: [
      { id: 'ruler', label: 'Measure', icon: 'ruler' },
      { id: 'play', label: 'Play', icon: 'play' },
      { id: 'bag', label: 'Pack Bag', icon: 'bag' },
    ]
  },
];

export function ListenChoose({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [currentIdx, setCurrentIdx] = useState(0);
  const [shuffledOptions, setShuffledOptions] = useState([]);
  const [selectedOption, setSelectedOption] = useState(null);
  const [wrongAttempts, setWrongAttempts] = useState(0);
  const [status, setStatus] = useState('idle');
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);

  const currentQ = QUESTIONS[currentIdx];

  // Strictly shuffle options
  useEffect(() => {
    setSelectedOption(null);
    setStatus('idle');
    setMascotPose('pointing');
    setShuffledOptions(shuffleArray(currentQ.options));
    speakText(currentQ.sentence);
  }, [currentIdx]);

  const handleSelect = (option) => {
    sfx.playTap();
    setSelectedOption(option);
    setStatus('ready');
  };

  const handleCheck = () => {
    if (!selectedOption) return;

    if (selectedOption.id === currentQ.correctId) {
      sfx.playSuccess();
      setMascotPose('celebrating');
      setStatus('correct');
      speakText(`Yes! ${currentQ.sentence}`);
    } else {
      sfx.playError();
      setMascotPose('thinking');
      setWrongAttempts(prev => prev + 1);
      setStatus('incorrect');
    }
  };

  const handleContinue = () => {
    if (currentIdx + 1 < QUESTIONS.length) {
      setCurrentIdx(prev => prev + 1);
    } else {
      const awardedStars = wrongAttempts === 0 ? 3 : wrongAttempts <= 3 ? 2 : 1;
      setIsCompleted(true);
      if (onComplete) onComplete(awardedStars);
    }
  };

  const handleTryAgain = () => {
    setSelectedOption(null);
    setStatus('idle');
    setMascotPose('pointing');
    speakText(currentQ.sentence);
  };

  return (
    <div className="min-h-screen bg-amber-50 dark:bg-slate-950 flex flex-col justify-between pb-32 transition-colors">
      <HeaderZone
        currentStep={currentIdx + 1}
        totalSteps={QUESTIONS.length}
        stars={currentStars}
        onClose={onExit}
        title="Listen & Choose"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-2xl mx-auto flex-1 flex flex-col justify-center px-4 w-full">
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={
            status === 'correct'
              ? `"${currentQ.sentence}"`
              : wrongAttempts >= 2
              ? "💡 Gigi's Hint: Look for the glowing card!"
              : 'Listen to Gigi and choose the right picture!'
          }
          onSpeakerClick={() => speakText(currentQ.sentence)}
        />

        {/* 3 Chunky 3D Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-5 my-6">
          {shuffledOptions.map((opt) => {
            const isSelected = selectedOption?.id === opt.id;
            const isScaffoldTarget = wrongAttempts >= 2 && opt.id === currentQ.correctId;
            const isScaffoldDimmed = wrongAttempts >= 2 && opt.id !== currentQ.correctId;
            return (
              <button
                key={opt.id}
                onClick={() => handleSelect(opt)}
                className={`flex flex-col items-center justify-center p-8 rounded-3xl border-2 border-b-6 transition-all select-none shadow-sm ${
                  isScaffoldTarget
                    ? 'bg-emerald-100 dark:bg-emerald-950/80 border-emerald-400 border-b-emerald-600 ring-4 ring-emerald-400 animate-pulse scale-105 shadow-lg'
                    : isScaffoldDimmed
                    ? 'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800 opacity-35 grayscale'
                    : isSelected
                    ? 'bg-sky-100 dark:bg-sky-950 border-sky-400 border-b-sky-600 text-sky-900 dark:text-sky-200 ring-4 ring-sky-200 translate-y-1'
                    : 'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800 active:translate-y-1 text-slate-800 dark:text-slate-100'
                }`}
              >
                <div className="w-24 h-24 sm:w-28 sm:h-28 flex items-center justify-center">
                  <Illustration name={opt.icon} className="w-full h-full" />
                </div>
              </button>
            );
          })}
        </div>
      </div>

      <BottomActionDrawer
        status={status}
        onCheck={handleCheck}
        onContinue={handleContinue}
        onTryAgain={handleTryAgain}
        encouragement="Super! You listened carefully and picked right!"
        hint="Listen to Gigi once more and pick the right picture!"
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={wrongAttempts === 0 ? 3 : wrongAttempts <= 3 ? 2 : 1}
          hasMistake={wrongAttempts > 0}
          activityTitle="Listen & Choose"
          paradeWords={QUESTIONS.map(q => q.sentence)}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
