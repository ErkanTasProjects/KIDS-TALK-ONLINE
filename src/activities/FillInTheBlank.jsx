import React, { useState, useEffect } from 'react';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { shuffleArray } from '../utils/shuffle';
import { speakText, sfx } from '../utils/audio';

const BLANK_QUESTIONS = [
  {
    prefix: 'I usually',
    blank: '___',
    suffix: 'TV after dinner.',
    fullSentence: 'I usually watch TV after dinner.',
    correctWord: 'watch',
    choices: ['watch', 'cook', 'fly'],
  },
  {
    prefix: 'I love',
    blank: '___',
    suffix: 'football.',
    fullSentence: 'I love playing football.',
    correctWord: 'playing',
    choices: ['playing', 'sleeping', 'writing'],
  },
  {
    prefix: 'I',
    blank: '___',
    suffix: 'listen to music after school.',
    fullSentence: 'I usually listen to music after school.',
    correctWord: 'usually',
    choices: ['usually', 'never', 'yesterday'],
  },
  {
    prefix: 'I like',
    blank: '___',
    suffix: 'books.',
    fullSentence: 'I like reading books.',
    correctWord: 'reading',
    choices: ['reading', 'eating', 'running'],
  },
  {
    prefix: 'I play games',
    blank: '___',
    suffix: 'homework.',
    fullSentence: 'I play games after homework.',
    correctWord: 'after',
    choices: ['after', 'before', 'inside'],
  },
];

export function FillInTheBlank({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [currentIdx, setCurrentIdx] = useState(0);
  const [selectedWord, setSelectedWord] = useState(null);
  const [shuffledChoices, setShuffledChoices] = useState([]);
  const [wrongAttempts, setWrongAttempts] = useState(0);
  const [status, setStatus] = useState('idle');
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);

  const q = BLANK_QUESTIONS[currentIdx];

  // Strictly shuffle choices on question mount
  useEffect(() => {
    setSelectedWord(null);
    setStatus('idle');
    setMascotPose('pointing');
    setShuffledChoices(shuffleArray(q.choices));
    speakText(`Fill in the blank: ${q.prefix} blank ${q.suffix}`);
  }, [currentIdx]);

  const handleSelectChoice = (word) => {
    sfx.playTap();
    speakText(word);
    setSelectedWord(word);
    setStatus('ready');
  };

  const handleCheck = () => {
    if (!selectedWord) return;

    if (selectedWord === q.correctWord) {
      sfx.playSuccess();
      setMascotPose('celebrating');
      setStatus('correct');
      speakText(q.fullSentence);
    } else {
      sfx.playError();
      setMascotPose('thinking');
      setWrongAttempts(prev => prev + 1);
      setStatus('incorrect');
    }
  };

  const handleContinue = () => {
    if (currentIdx + 1 < BLANK_QUESTIONS.length) {
      setCurrentIdx(prev => prev + 1);
    } else {
      const awardedStars = wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1;
      setIsCompleted(true);
      if (onComplete) onComplete(awardedStars);
    }
  };

  const handleTryAgain = () => {
    setSelectedWord(null);
    setStatus('idle');
    setMascotPose('pointing');
  };

  return (
    <div className="min-h-screen bg-amber-50 dark:bg-slate-950 flex flex-col justify-between pb-32 transition-colors">
      <HeaderZone
        currentStep={currentIdx + 1}
        totalSteps={BLANK_QUESTIONS.length}
        stars={currentStars}
        onClose={onExit}
        title="Fill in the Blank"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-2xl mx-auto flex-1 flex flex-col justify-center px-4 w-full">
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={
            status === 'correct'
              ? q.fullSentence
              : wrongAttempts >= 2
              ? "💡 Gigi's Hint: Choose the glowing green word!"
              : `Choose the best word to fill in the blank!`
          }
          onSpeakerClick={() => speakText(q.fullSentence)}
        />

        {/* Big Sentence Card with Glowing Blank */}
        <div className="my-6 p-6 sm:p-8 bg-white dark:bg-slate-900 border-2 border-slate-200 dark:border-slate-800 border-b-6 rounded-3xl shadow-sm text-center">
          <p className="text-xl sm:text-2xl font-black text-slate-800 dark:text-slate-100 leading-relaxed flex flex-wrap items-center justify-center gap-2">
            <span>{q.prefix}</span>
            <span
              className={`min-w-[90px] px-4 py-1.5 rounded-2xl border-2 font-black transition-all ${
                selectedWord
                  ? 'bg-sky-100 dark:bg-sky-950 border-sky-400 text-sky-900 dark:text-sky-200 border-b-4'
                  : 'bg-amber-100 dark:bg-amber-950 border-dashed border-amber-400 text-amber-700 dark:text-amber-300 animate-pulse'
              }`}
            >
              {selectedWord || '___'}
            </span>
            <span>{q.suffix}</span>
          </p>
        </div>

        {/* 3 Chunky 3D Word Choices */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3.5">
          {shuffledChoices.map((choice) => {
            const isSelected = selectedWord === choice;
            const isScaffoldTarget = wrongAttempts >= 2 && choice === q.correctWord;
            const isScaffoldDimmed = wrongAttempts >= 2 && choice !== q.correctWord;
            return (
              <button
                key={choice}
                onClick={() => handleSelectChoice(choice)}
                className={`py-4 px-6 rounded-2xl border-2 border-b-6 font-extrabold text-lg sm:text-xl transition-all select-none shadow-sm ${
                  isScaffoldTarget
                    ? 'bg-emerald-100 dark:bg-emerald-950/80 border-emerald-400 border-b-emerald-600 text-emerald-900 dark:text-emerald-100 ring-4 ring-emerald-400 animate-pulse scale-105'
                    : isScaffoldDimmed
                    ? 'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800 opacity-35 grayscale'
                    : isSelected
                    ? 'bg-sky-100 dark:bg-sky-950 border-sky-400 border-b-sky-600 text-sky-900 dark:text-sky-200 ring-4 ring-sky-200 translate-y-1'
                    : 'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800 active:translate-y-1 text-slate-800 dark:text-slate-100'
                }`}
              >
                {choice}
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
        encouragement="Awesome choice! The sentence makes total sense!"
        hint="That word doesn't fit quite right. Think about your habits and try again!"
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1}
          hasMistake={wrongAttempts > 0}
          activityTitle="Fill in the Blank: Habits & Hobbies"
          paradeWords={BLANK_QUESTIONS.map(q => q.fullSentence)}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
