import React, { useState, useEffect } from 'react';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { shuffleArray } from '../utils/shuffle';
import { speakText, sfx } from '../utils/audio';

const SENTENCE_CHALLENGES = [
  {
    targetSentence: 'I go to school by bus.',
    words: ['I', 'go', 'to', 'school', 'by', 'bus.'],
  },
  {
    targetSentence: 'I eat breakfast at 8.',
    words: ['I', 'eat', 'breakfast', 'at', '8.'],
  },
  {
    targetSentence: 'I get up at 7.',
    words: ['I', 'get', 'up', 'at', '7.'],
  },
  {
    targetSentence: 'I do my homework after school.',
    words: ['I', 'do', 'my', 'homework', 'after', 'school.'],
  },
  {
    targetSentence: 'I go to bed at 9.',
    words: ['I', 'go', 'to', 'bed', 'at', '9.'],
  },
];

export function SentenceBuilder({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [currentIdx, setCurrentIdx] = useState(0);
  const [bankTiles, setBankTiles] = useState([]);
  const [placedTiles, setPlacedTiles] = useState([]);
  const [wrongAttempts, setWrongAttempts] = useState(0);
  const [status, setStatus] = useState('idle');
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);

  const challenge = SENTENCE_CHALLENGES[currentIdx];

  useEffect(() => {
    const tilesWithIds = challenge.words.map((w, index) => ({
      id: `${w}-${index}-${Date.now()}`,
      word: w,
    }));
    setPlacedTiles([]);
    setBankTiles(shuffleArray(tilesWithIds));
    setStatus('idle');
    setMascotPose('pointing');
    speakText('Build the sentence in correct order!');
  }, [currentIdx]);

  useEffect(() => {
    if (placedTiles.length === challenge.words.length && challenge.words.length > 0) {
      setStatus('ready');
    } else {
      if (status !== 'correct' && status !== 'incorrect') {
        setStatus('idle');
      }
    }
  }, [placedTiles]);

  const handleTapBankTile = (tile) => {
    sfx.playTap();
    speakText(tile.word);
    setBankTiles(prev => prev.filter(t => t.id !== tile.id));
    setPlacedTiles(prev => [...prev, tile]);
    if (status === 'incorrect') {
      setStatus('idle');
      setMascotPose('pointing');
    }
  };

  const handleTapPlacedTile = (tile) => {
    sfx.playTap();
    setPlacedTiles(prev => prev.filter(t => t.id !== tile.id));
    setBankTiles(prev => [...prev, tile]);
    setStatus('idle');
    setMascotPose('pointing');
  };

  const handleCheck = () => {
    const constructed = placedTiles.map(t => t.word).join(' ');
    if (constructed === challenge.targetSentence) {
      sfx.playSuccess();
      setMascotPose('celebrating');
      setStatus('correct');
      speakText(challenge.targetSentence);
    } else {
      sfx.playError();
      setMascotPose('thinking');
      setWrongAttempts(prev => prev + 1);
      setStatus('incorrect');
    }
  };

  const handleContinue = () => {
    if (currentIdx + 1 < SENTENCE_CHALLENGES.length) {
      setCurrentIdx(prev => prev + 1);
    } else {
      const awardedStars = wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1;
      setIsCompleted(true);
      if (onComplete) onComplete(awardedStars);
    }
  };

  const handleTryAgain = () => {
    const all = [...bankTiles, ...placedTiles];
    setPlacedTiles([]);
    setBankTiles(shuffleArray(all));
    setStatus('idle');
    setMascotPose('pointing');
  };

  return (
    <div className="min-h-screen bg-amber-50 dark:bg-slate-950 flex flex-col justify-between pb-32 transition-colors">
      <HeaderZone
        currentStep={currentIdx + 1}
        totalSteps={SENTENCE_CHALLENGES.length}
        stars={currentStars}
        onClose={onExit}
        title="Sentence Builder"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-3xl mx-auto flex-1 flex flex-col justify-center px-4 w-full">
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={
            status === 'correct'
              ? `"${challenge.targetSentence}"`
              : wrongAttempts >= 2
              ? "💡 Gigi's Hint: Look for the glowing word tile!"
              : 'Arrange the words in the correct order!'
          }
          onSpeakerClick={() => speakText(challenge.targetSentence)}
        />

        {/* Slot Drop Zone */}
        <div className="my-6 bg-white dark:bg-slate-900 border-2 border-slate-200 dark:border-slate-800 border-b-6 rounded-3xl p-6 min-h-[110px] flex items-center justify-center flex-wrap gap-2.5 shadow-sm">
          {placedTiles.length === 0 ? (
            <p className="text-slate-400 dark:text-slate-600 font-bold text-sm sm:text-base italic select-none">
              Tap words below to build your sentence here!
            </p>
          ) : (
            placedTiles.map((tile) => (
              <button
                key={tile.id}
                onClick={() => handleTapPlacedTile(tile)}
                className="bg-sky-100 dark:bg-sky-950/80 hover:bg-rose-50 dark:hover:bg-rose-950/80 border-2 border-sky-400 border-b-4 hover:border-rose-400 rounded-2xl px-4 py-2 text-sky-950 dark:text-sky-200 hover:text-rose-700 font-extrabold text-base sm:text-lg shadow-sm transition-all"
              >
                {tile.word}
              </button>
            ))
          )}
        </div>

        {/* Word Tiles Bank */}
        <div className="p-4 bg-amber-100/60 dark:bg-slate-900/80 border-2 border-amber-200 dark:border-slate-800 border-b-4 rounded-3xl shadow-sm">
          <p className="text-xs font-bold text-amber-800 dark:text-amber-400 uppercase tracking-wider text-center mb-3">
            Word Bank (Tap to select)
          </p>
          <div className="flex flex-wrap items-center justify-center gap-3">
            {bankTiles.map((tile) => {
              const nextExpectedWord = challenge.words[placedTiles.length];
              const isScaffoldTarget = wrongAttempts >= 2 && tile.word === nextExpectedWord;
              return (
                <button
                  key={tile.id}
                  onClick={() => handleTapBankTile(tile)}
                  className={`border-2 border-b-4 active:border-b-2 active:translate-y-1 rounded-2xl px-5 py-3 font-black text-base sm:text-xl shadow-sm transition-all ${
                    isScaffoldTarget
                      ? 'bg-emerald-100 dark:bg-emerald-950/80 border-emerald-400 border-b-emerald-600 ring-4 ring-emerald-400 animate-pulse text-emerald-900 dark:text-emerald-100 scale-105'
                      : 'bg-white dark:bg-slate-800 hover:bg-slate-50 dark:hover:bg-slate-700 border-slate-200 dark:border-slate-700 text-slate-800 dark:text-slate-100'
                  }`}
                >
                  {tile.word}
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
        encouragement="Brilliant sentence structure! Keep going!"
        hint="The words aren't in quite the right order. Tap TRY AGAIN to restart the sentence."
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1}
          hasMistake={wrongAttempts > 0}
          activityTitle="Sentence Builder: Daily Routines"
          paradeWords={SENTENCE_CHALLENGES.map(c => c.targetSentence)}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
