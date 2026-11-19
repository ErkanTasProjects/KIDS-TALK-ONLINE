import React, { useState, useEffect } from 'react';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { Illustration } from '../components/Illustration';
import { shuffleArray } from '../utils/shuffle';
import { speakText, sfx } from '../utils/audio';
import { Volume2 } from 'lucide-react';

const ROUTINE_ITEMS = [
  { id: '1', sentence: 'I wake up at 7.', icon: 'alarm', label: 'Alarm Clock' },
  { id: '2', sentence: 'I brush my teeth.', icon: 'toothbrush', label: 'Toothbrush' },
  { id: '3', sentence: 'I eat breakfast.', icon: 'pancakes', label: 'Pancakes' },
  { id: '4', sentence: 'I go to school.', icon: 'backpack', label: 'Backpack' },
  { id: '5', sentence: 'I play in the park.', icon: 'park_slide', label: 'Park Slide' },
];

export function TapMatchRoutines({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [targets, setTargets] = useState([]);
  const [sentenceCards, setSentenceCards] = useState([]);
  const [selectedCard, setSelectedCard] = useState(null);
  const [placedMatches, setPlacedMatches] = useState({});
  const [wrongAttempts, setWrongAttempts] = useState(0);
  const [status, setStatus] = useState('idle');
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);

  useEffect(() => {
    // Randomize targets AND sentence cards order
    setTargets(shuffleArray(ROUTINE_ITEMS));
    setSentenceCards(shuffleArray(ROUTINE_ITEMS));
    setPlacedMatches({});
    setSelectedCard(null);
    setWrongAttempts(0);
    setStatus('idle');
    setMascotPose('pointing');
    speakText('Match each daily routine with its picture!');
  }, []);

  useEffect(() => {
    const placedCount = Object.keys(placedMatches).length;
    if (placedCount === ROUTINE_ITEMS.length) {
      setStatus('ready');
    } else {
      if (status !== 'correct' && status !== 'incorrect') {
        setStatus('idle');
      }
    }
  }, [placedMatches]);

  const handleSelectCard = (card) => {
    sfx.playTap();
    speakText(card.sentence);
    setSelectedCard(card);

    const openTarget = targets.find(t => !placedMatches[t.id]);
    if (openTarget) {
      setPlacedMatches(prev => ({
        ...prev,
        [openTarget.id]: card.id
      }));
      setSelectedCard(null);
    }
  };

  const handleTapTarget = (target) => {
    sfx.playTap();
    if (placedMatches[target.id]) {
      setPlacedMatches(prev => {
        const next = { ...prev };
        delete next[target.id];
        return next;
      });
      setStatus('idle');
    } else if (selectedCard) {
      setPlacedMatches(prev => ({
        ...prev,
        [target.id]: selectedCard.id
      }));
      setSelectedCard(null);
    }
  };

  const handleDrop = (e, target) => {
    e.preventDefault();
    const cardId = e.dataTransfer.getData('text/plain');
    if (cardId) {
      sfx.playTap();
      const updated = { ...placedMatches };
      Object.keys(updated).forEach(k => {
        if (updated[k] === cardId) delete updated[k];
      });
      updated[target.id] = cardId;
      setPlacedMatches(updated);
    }
  };

  const handleCheck = () => {
    let allCorrect = true;
    for (const target of targets) {
      if (placedMatches[target.id] !== target.id) {
        allCorrect = false;
        break;
      }
    }

    if (allCorrect) {
      sfx.playSuccess();
      setMascotPose('celebrating');
      setStatus('correct');
      speakText('Incredible! All daily routines match perfectly!');
    } else {
      sfx.playError();
      setMascotPose('thinking');
      setWrongAttempts(prev => prev + 1);
      setStatus('incorrect');
    }
  };

  const handleContinue = () => {
    const awardedStars = wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1;
    setIsCompleted(true);
    if (onComplete) onComplete(awardedStars);
  };

  const handleTryAgain = () => {
    const updated = { ...placedMatches };
    Object.keys(updated).forEach(targetId => {
      if (updated[targetId] !== targetId) {
        delete updated[targetId];
      }
    });
    setPlacedMatches(updated);
    setStatus('idle');
    setMascotPose('pointing');
  };

  const placedCardIds = new Set(Object.values(placedMatches));
  const availableCards = sentenceCards.filter(c => !placedCardIds.has(c.id));

  return (
    <div className="min-h-screen bg-amber-50 dark:bg-slate-950 flex flex-col justify-between pb-32 transition-colors">
      <HeaderZone
        currentStep={Object.keys(placedMatches).length}
        totalSteps={targets.length}
        stars={currentStars}
        onClose={onExit}
        title="Daily Activities"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-4xl mx-auto flex-1 flex flex-col justify-center px-4 w-full">
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={
            status === 'correct'
              ? 'Awesome! You know your daily routines!'
              : wrongAttempts >= 2
              ? "💡 Gigi's Hint: Match the alarm clock with waking up!"
              : status === 'incorrect'
              ? 'Oops! Look closely at the picture and try again.'
              : 'Tap or drag each routine sentence onto its matching picture!'
          }
          onSpeakerClick={() => speakText('Tap or drag each sentence onto its picture!')}
        />

        {/* Targets Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3 my-4">
          {targets.map((target) => {
            const placedCardId = placedMatches[target.id];
            const matchedCard = sentenceCards.find(c => c.id === placedCardId);
            const isTargetCorrect = status === 'correct' && placedCardId === target.id;

            return (
              <div
                key={target.id}
                onDrop={(e) => handleDrop(e, target)}
                onDragOver={(e) => e.preventDefault()}
                onClick={() => handleTapTarget(target)}
                className={`flex flex-col items-center justify-between p-3.5 rounded-2xl border-2 transition-all cursor-pointer ${
                  isTargetCorrect
                    ? 'bg-emerald-50 dark:bg-emerald-950/60 border-emerald-400'
                    : placedCardId
                    ? 'bg-amber-50/80 dark:bg-slate-800 border-amber-300 dark:border-slate-700'
                    : 'bg-white dark:bg-slate-900 border-dashed border-slate-300 dark:border-slate-700 hover:border-sky-400'
                }`}
              >
                <div className="w-16 h-16 mb-1">
                  <Illustration name={target.icon} className="w-full h-full" />
                </div>
                <p className="text-xs font-bold text-slate-500 dark:text-slate-400 mb-2">{target.label}</p>

                <div
                  className={`w-full min-h-[46px] rounded-xl flex items-center justify-center p-2 text-center text-xs sm:text-sm font-extrabold border-2 transition-all ${
                    matchedCard
                      ? 'bg-white dark:bg-slate-800 border-sky-400 text-sky-900 dark:text-sky-300 border-b-4 shadow-sm'
                      : 'border-dashed border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/40 text-slate-400'
                  }`}
                >
                  {matchedCard ? (
                    <div className="flex items-center justify-between w-full">
                      <span>{matchedCard.sentence}</span>
                      <span className="text-[10px] bg-rose-100 dark:bg-rose-950 text-rose-700 dark:text-rose-300 px-1.5 py-0.5 rounded-md ml-1 font-bold">
                        Remove
                      </span>
                    </div>
                  ) : (
                    <span>+ Drop or Tap here</span>
                  )}
                </div>
              </div>
            );
          })}
        </div>

        {/* Shuffled Bank */}
        <div className="mt-2 bg-white/90 dark:bg-slate-900 border-2 border-slate-200 dark:border-slate-800 border-b-4 rounded-2xl p-4 shadow-sm">
          <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider mb-2 text-center">
            Sentence Bank (Tap to place)
          </p>
          <div className="flex flex-wrap gap-2.5 justify-center">
            {availableCards.length === 0 ? (
              <p className="text-sm font-bold text-emerald-600 dark:text-emerald-400">All routines placed! Press CHECK below.</p>
            ) : (
              availableCards.map((card) => {
                const isSelected = selectedCard?.id === card.id;
                return (
                  <div
                    key={card.id}
                    draggable
                    onDragStart={(e) => {
                      e.dataTransfer.setData('text/plain', card.id);
                      speakText(card.sentence);
                    }}
                    onClick={() => handleSelectCard(card)}
                    className={`px-4 py-2.5 rounded-xl border-2 border-b-4 font-extrabold text-sm sm:text-base cursor-grab active:cursor-grabbing transition-all select-none flex items-center gap-2 ${
                      isSelected
                        ? 'bg-sky-100 dark:bg-sky-950 border-sky-400 border-b-sky-500 text-sky-900 dark:text-sky-200 shadow-md ring-2 ring-sky-300'
                        : 'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700 active:translate-y-1 text-slate-800 dark:text-slate-100 shadow-sm'
                    }`}
                  >
                    <span>{card.sentence}</span>
                    <Volume2 className="w-4 h-4 text-sky-500" />
                  </div>
                );
              })
            )}
          </div>
        </div>
      </div>

      <BottomActionDrawer
        status={status}
        onCheck={handleCheck}
        onContinue={handleContinue}
        onTryAgain={handleTryAgain}
        encouragement="Brilliant work! You matched all daily routines!"
        hint="Check the pictures carefully! Tapping a card returns it to the bank."
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1}
          hasMistake={wrongAttempts > 0}
          activityTitle="Daily Activities & Routines"
          paradeWords={ROUTINE_ITEMS.map(i => i.sentence)}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
