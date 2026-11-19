import React, { useState, useEffect } from 'react';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { Illustration } from '../components/Illustration';
import { shuffleArray } from '../utils/shuffle';
import { speakText, sfx } from '../utils/audio';

const CARDS_DATA = [
  { pairId: 1, type: 'person', text: 'Mother', icon: 'mother', speech: 'Mother' },
  { pairId: 1, type: 'like', text: 'She likes cooking.', icon: 'pancakes', speech: 'She likes cooking.' },

  { pairId: 2, type: 'person', text: 'Father', icon: 'father', speech: 'Father' },
  { pairId: 2, type: 'like', text: 'He likes football.', icon: 'play', speech: 'He likes football.' },

  { pairId: 3, type: 'person', text: 'Brother', icon: 'brother', speech: 'Brother' },
  { pairId: 3, type: 'like', text: 'He likes games.', icon: 'play', speech: 'He likes games.' },

  { pairId: 4, type: 'person', text: 'Sister', icon: 'sister', speech: 'Sister' },
  { pairId: 4, type: 'like', text: 'She likes dancing.', icon: 'park_slide', speech: 'She likes dancing.' },

  { pairId: 5, type: 'person', text: 'Best Friend', icon: 'friend', speech: 'Best Friend' },
  { pairId: 5, type: 'like', text: 'She likes music.', icon: 'howareyou', speech: 'She likes music.' },
];

export function MemoryCards({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [cards, setCards] = useState([]);
  const [flippedIndices, setFlippedIndices] = useState([]);
  const [matchedPairIds, setMatchedPairIds] = useState(new Set());
  const [wrongAttempts, setWrongAttempts] = useState(0);
  const [status, setStatus] = useState('idle');
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);
  const [isEvaluating, setIsEvaluating] = useState(false);

  useEffect(() => {
    const deck = CARDS_DATA.map((card, i) => ({
      ...card,
      instanceId: `${card.pairId}-${card.type}-${i}`,
    }));
    setCards(shuffleArray(deck));
    setFlippedIndices([]);
    setMatchedPairIds(new Set());
    setWrongAttempts(0);
    setStatus('idle');
    setMascotPose('pointing');
    speakText('Flip cards to match each person with what they like!');
  }, []);

  const handleCardClick = (index) => {
    if (isEvaluating) return;
    if (flippedIndices.includes(index)) return;
    if (matchedPairIds.has(cards[index].pairId)) return;

    sfx.playTap();
    speakText(cards[index].speech);

    const newFlipped = [...flippedIndices, index];
    setFlippedIndices(newFlipped);

    if (newFlipped.length === 2) {
      setIsEvaluating(true);
      const [firstIdx, secondIdx] = newFlipped;
      const firstCard = cards[firstIdx];
      const secondCard = cards[secondIdx];

      if (firstCard.pairId === secondCard.pairId && firstCard.type !== secondCard.type) {
        setTimeout(() => {
          sfx.playSuccess();
          const newMatched = new Set(matchedPairIds);
          newMatched.add(firstCard.pairId);
          setMatchedPairIds(newMatched);
          setFlippedIndices([]);
          setIsEvaluating(false);
          setMascotPose('celebrating');

          if (newMatched.size === 5) {
            setStatus('correct');
            speakText('Hooray! All memory pairs matched!');
          }
        }, 600);
      } else {
        setTimeout(() => {
          sfx.playError();
          setMascotPose('thinking');
          setWrongAttempts(prev => prev + 1);
          setFlippedIndices([]);
          setIsEvaluating(false);
        }, 1200);
      }
    }
  };

  const handleContinue = () => {
    const awardedStars = wrongAttempts <= 3 ? 3 : wrongAttempts <= 6 ? 2 : 1;
    setIsCompleted(true);
    if (onComplete) onComplete(awardedStars);
  };

  return (
    <div className="min-h-screen bg-amber-50 dark:bg-slate-950 flex flex-col justify-between pb-32 transition-colors">
      <HeaderZone
        currentStep={matchedPairIds.size}
        totalSteps={5}
        stars={currentStars}
        onClose={onExit}
        title="Memory Match"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-4xl mx-auto flex-1 flex flex-col justify-center px-4 w-full">
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={
            matchedPairIds.size === 5
              ? 'You did it! All 5 pairs found!'
              : 'Flip two cards to find matching pairs!'
          }
          onSpeakerClick={() => speakText('Flip two cards to find matching pairs!')}
        />

        {/* 5x2 (10 cards) Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-5 gap-3 sm:gap-4 my-4">
          {cards.map((card, index) => {
            const isFlipped = flippedIndices.includes(index) || matchedPairIds.has(card.pairId);
            const isMatched = matchedPairIds.has(card.pairId);

            return (
              <div
                key={card.instanceId}
                onClick={() => handleCardClick(index)}
                className={`h-36 sm:h-40 rounded-3xl border-2 border-b-6 transition-all duration-300 cursor-pointer flex flex-col items-center justify-center p-2 text-center select-none ${
                  isMatched
                    ? 'bg-emerald-50 dark:bg-emerald-950/60 border-emerald-400 border-b-emerald-600 scale-95 opacity-90'
                    : isFlipped
                    ? 'bg-white dark:bg-slate-800 border-sky-400 border-b-sky-600 shadow-md ring-2 ring-sky-300'
                    : 'bg-gradient-to-b from-amber-300 to-amber-400 dark:from-amber-600 dark:to-amber-700 border-amber-500 border-b-amber-600 hover:from-amber-200 active:translate-y-1'
                }`}
              >
                {isFlipped ? (
                  <div className="flex flex-col items-center justify-center animate-pop">
                    <div className="w-14 h-14 mb-1">
                      <Illustration name={card.icon} className="w-full h-full" />
                    </div>
                    <p className="font-extrabold text-xs sm:text-sm text-slate-800 dark:text-slate-100 leading-tight">
                      {card.text}
                    </p>
                  </div>
                ) : (
                  <div className="flex flex-col items-center justify-center text-amber-900 dark:text-amber-100">
                    <span className="text-3xl font-black">?</span>
                    <span className="text-[10px] font-extrabold uppercase tracking-widest mt-1 opacity-70">
                      Flip
                    </span>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>

      <BottomActionDrawer
        status={matchedPairIds.size === 5 ? 'correct' : 'idle'}
        onCheck={() => {}}
        onContinue={handleContinue}
        onTryAgain={() => {}}
        encouragement="Terrific memory! All 5 pairs found!"
        hint="Keep flipping to find all pairs!"
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={wrongAttempts <= 3 ? 3 : wrongAttempts <= 6 ? 2 : 1}
          hasMistake={wrongAttempts > 3}
          activityTitle="Memory Cards: Family & Friends"
          paradeWords={['Mother: She likes cooking.', 'Father: He likes football.', 'Brother: He likes games.', 'Sister: She likes dancing.', 'Best Friend: She likes music.']}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
