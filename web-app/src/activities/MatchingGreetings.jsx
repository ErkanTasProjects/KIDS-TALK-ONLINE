import React, { useState, useEffect } from 'react';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { Illustration } from '../components/Illustration';
import { shuffleArray } from '../utils/shuffle';
import { speakText, sfx } from '../utils/audio';

const RAW_ITEMS = [
  { id: '1', english: 'Hello!', situation: 'Saying Hi to a Friend', icon: 'hello' },
  { id: '2', english: 'Good morning!', situation: 'Waking up at Sunrise', icon: 'morning' },
  { id: '3', english: 'Good afternoon!', situation: 'Sunny Lunchtime', icon: 'afternoon' },
  { id: '4', english: 'How are you?', situation: 'Asking How Someone Feels', icon: 'howareyou' },
  { id: '5', english: 'Goodbye!', situation: 'Waving Farewell', icon: 'goodbye' },
];

export function MatchingGreetings({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [leftItems, setLeftItems] = useState([]);
  const [rightItems, setRightItems] = useState([]);
  const [selectedLeft, setSelectedLeft] = useState(null);
  const [selectedRight, setSelectedRight] = useState(null);
  const [matchedIds, setMatchedIds] = useState(new Set());
  const [wrongAttempts, setWrongAttempts] = useState(0);
  const [status, setStatus] = useState('idle');
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);

  // Fisher-Yates shuffle on mount for BOTH sides
  useEffect(() => {
    setLeftItems(shuffleArray(RAW_ITEMS));
    setRightItems(shuffleArray(RAW_ITEMS));
    setMatchedIds(new Set());
    setSelectedLeft(null);
    setSelectedRight(null);
    setWrongAttempts(0);
    setStatus('idle');
    setMascotPose('pointing');
    speakText('Match each situation picture with its greeting!');
  }, []);

  useEffect(() => {
    if (selectedLeft && selectedRight) {
      setStatus('ready');
    } else {
      if (status !== 'correct' && status !== 'incorrect') {
        setStatus('idle');
      }
    }
  }, [selectedLeft, selectedRight]);

  const handleSelectLeft = (item) => {
    if (matchedIds.has(item.id)) return;
    sfx.playTap();
    setSelectedLeft(item);
    if (status === 'incorrect') {
      setStatus('idle');
      setMascotPose('pointing');
    }
  };

  const handleSelectRight = (item) => {
    if (matchedIds.has(item.id)) return;
    sfx.playTap();
    speakText(item.english);
    setSelectedRight(item);
    if (status === 'incorrect') {
      setStatus('idle');
      setMascotPose('pointing');
    }
  };

  const handleCheck = () => {
    if (!selectedLeft || !selectedRight) return;

    if (selectedLeft.id === selectedRight.id) {
      sfx.playSuccess();
      setMascotPose('celebrating');
      const newMatched = new Set(matchedIds);
      newMatched.add(selectedLeft.id);
      setMatchedIds(newMatched);
      setStatus('correct');
      speakText(`Great! ${selectedRight.english}`);
    } else {
      sfx.playError();
      setMascotPose('thinking');
      setWrongAttempts(prev => prev + 1);
      setStatus('incorrect');
    }
  };

  const handleContinue = () => {
    setSelectedLeft(null);
    setSelectedRight(null);
    setStatus('idle');
    setMascotPose('pointing');

    if (matchedIds.size >= RAW_ITEMS.length) {
      const awardedStars = wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1;
      setIsCompleted(true);
      if (onComplete) onComplete(awardedStars);
    }
  };

  const handleTryAgain = () => {
    setSelectedRight(null);
    setStatus('idle');
    setMascotPose('pointing');
  };

  return (
    <div className="min-h-screen bg-amber-50 dark:bg-slate-950 flex flex-col justify-between pb-32 transition-colors">
      <HeaderZone
        currentStep={matchedIds.size}
        totalSteps={RAW_ITEMS.length}
        stars={currentStars}
        onClose={onExit}
        title="Greetings Match"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-3xl mx-auto flex-1 flex flex-col justify-center px-4 w-full">
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={
            status === 'correct'
              ? 'Excellent pair!'
              : wrongAttempts >= 2
              ? "💡 Gigi's Hint: Look for the glowing card!"
              : status === 'incorrect'
              ? "That doesn't match! Try again."
              : 'Match each picture with the right greeting!'
          }
          onSpeakerClick={() => speakText('Match each card with the right greeting!')}
        />

        {/* 2-Column Matching Stage */}
        <div className="grid grid-cols-2 gap-4 sm:gap-6 mt-4">
          {/* Left Column: Shuffled Situations */}
          <div className="flex flex-col gap-3">
            <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider text-center">
              Situations
            </p>
            {leftItems.map((item) => {
              const isMatched = matchedIds.has(item.id);
              const isSelected = selectedLeft?.id === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => handleSelectLeft(item)}
                  disabled={isMatched}
                  className={`flex items-center gap-3 p-3 rounded-2xl border-2 border-b-4 transition-all text-left select-none ${
                    isMatched
                      ? 'bg-emerald-50 dark:bg-emerald-950/60 border-emerald-400 opacity-80 cursor-default'
                      : isSelected
                      ? 'bg-sky-100 dark:bg-sky-950/70 border-sky-400 border-b-sky-500 shadow-md ring-2 ring-sky-300'
                      : 'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700 active:translate-y-1 shadow-sm'
                  }`}
                >
                  <div className="w-12 h-12 shrink-0">
                    <Illustration name={item.icon} className="w-full h-full" />
                  </div>
                  <div className="flex-1">
                    <p className={`font-bold text-xs sm:text-sm leading-tight ${isMatched ? 'text-emerald-700 dark:text-emerald-300' : 'text-slate-800 dark:text-slate-100'}`}>
                      {item.situation}
                    </p>
                  </div>
                </button>
              );
            })}
          </div>

          {/* Right Column: Shuffled English Cards */}
          <div className="flex flex-col gap-3">
            <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider text-center">
              English Greetings
            </p>
            {rightItems.map((item) => {
              const isMatched = matchedIds.has(item.id);
              const isSelected = selectedRight?.id === item.id;
              const isScaffoldTarget = wrongAttempts >= 2 && selectedLeft && item.id === selectedLeft.id && !isMatched;
              const isScaffoldDimmed = wrongAttempts >= 2 && selectedLeft && item.id !== selectedLeft.id && !isMatched;
              return (
                <button
                  key={item.id}
                  onClick={() => handleSelectRight(item)}
                  disabled={isMatched}
                  className={`flex items-center justify-between p-3.5 rounded-2xl border-2 border-b-4 transition-all text-left select-none ${
                    isMatched
                      ? 'bg-emerald-50 dark:bg-emerald-950/60 border-emerald-400 opacity-80 cursor-default'
                      : isScaffoldTarget
                      ? 'bg-emerald-100 dark:bg-emerald-950/80 border-emerald-400 ring-4 ring-emerald-400 animate-pulse shadow-lg scale-105'
                      : isScaffoldDimmed
                      ? 'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 opacity-35 grayscale'
                      : isSelected
                      ? 'bg-sky-100 dark:bg-sky-950/70 border-sky-400 border-b-sky-500 shadow-md ring-2 ring-sky-300'
                      : 'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700 active:translate-y-1 shadow-sm'
                  }`}
                >
                  <p className={`font-extrabold text-sm sm:text-base ${isMatched ? 'text-emerald-700 dark:text-emerald-300' : 'text-slate-800 dark:text-slate-100'}`}>
                    {item.english}
                  </p>
                  <span className="text-[10px] bg-sky-100 dark:bg-sky-900 text-sky-700 dark:text-sky-300 px-2 py-0.5 rounded-full font-bold">
                    Listen
                  </span>
                </button>
              );
            })}
          </div>
        </div>
      </div>

      <BottomActionDrawer
        status={status}
        onCheck={handleCheck}
        onContinue={handleContinue}
        onTryAgain={handleTryAgain}
        encouragement="Terrific! That greeting was matched correctly!"
        hint="These cards don't match. Listen again and try another one!"
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1}
          hasMistake={wrongAttempts > 0}
          activityTitle="Greetings & Farewells"
          paradeWords={RAW_ITEMS.map(i => i.english)}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
