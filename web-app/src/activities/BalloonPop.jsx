import React, { useState, useEffect } from 'react';
import confetti from 'canvas-confetti';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { shuffleArray } from '../utils/shuffle';
import { speakText, sfx } from '../utils/audio';

const BALLOON_PHRASES = [
  { id: '1', phrase: "How's it going?", fill: '#FB7185' },
  { id: '2', phrase: 'Nice to meet you.', fill: '#FBBF24' },
  { id: '3', phrase: 'Hi there!', fill: '#34D399' },
  { id: '4', phrase: 'See you later!', fill: '#38BDF8' },
  { id: '5', phrase: 'Have a nice day!', fill: '#C084FC' },
];

export function BalloonPop({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [currentIdx, setCurrentIdx] = useState(0);
  const [balloons, setBalloons] = useState([]);
  const [poppedIds, setPoppedIds] = useState(new Set());
  const [wobblingId, setWobblingId] = useState(null);
  const [wrongAttempts, setWrongAttempts] = useState(0);
  const [status, setStatus] = useState('idle');
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);

  const targetItem = BALLOON_PHRASES[currentIdx];

  useEffect(() => {
    setBalloons(shuffleArray(BALLOON_PHRASES));
    setPoppedIds(new Set());
    setCurrentIdx(0);
    setWrongAttempts(0);
  }, []);

  useEffect(() => {
    if (targetItem) {
      setStatus('idle');
      setMascotPose('pointing');
      // Speak the prompt so the child must listen
      speakText(targetItem.phrase);
    }
  }, [currentIdx]);

  const handleReplayAudio = () => {
    if (targetItem) {
      speakText(targetItem.phrase);
    }
  };

  const handleBalloonClick = (balloon) => {
    if (poppedIds.has(balloon.id)) return;

    if (balloon.id === targetItem.id) {
      sfx.playPop();
      try {
        confetti({
          particleCount: 35,
          spread: 60,
          origin: { y: 0.5 }
        });
      } catch (e) {}

      const newPopped = new Set(poppedIds);
      newPopped.add(balloon.id);
      setPoppedIds(newPopped);

      sfx.playSuccess();
      setMascotPose('celebrating');
      setStatus('correct');
      speakText(`Pop! ${balloon.phrase}`);
    } else {
      sfx.playError();
      setMascotPose('thinking');
      setWrongAttempts(prev => prev + 1);
      setWobblingId(balloon.id);
      setTimeout(() => setWobblingId(null), 600);
      speakText(balloon.phrase);
    }
  };

  const handleContinue = () => {
    if (currentIdx + 1 < BALLOON_PHRASES.length) {
      setCurrentIdx(prev => prev + 1);
      setBalloons(shuffleArray(BALLOON_PHRASES));
    } else {
      const awardedStars = wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1;
      setIsCompleted(true);
      if (onComplete) onComplete(awardedStars);
    }
  };

  return (
    <div className="min-h-screen bg-sky-50 dark:bg-slate-950 flex flex-col justify-between pb-32 overflow-hidden transition-colors">
      <HeaderZone
        currentStep={currentIdx + 1}
        totalSteps={BALLOON_PHRASES.length}
        stars={currentStars}
        onClose={onExit}
        title="Balloon Pop"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-3xl mx-auto flex-1 flex flex-col justify-center px-4 w-full">
        {/* Balloon Listening Instruction: NO CHEAT TEXT! Shows "Listen carefully & pop the right balloon!" */}
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={
            status === 'correct'
              ? `Great job! "${targetItem?.phrase}"`
              : wrongAttempts >= 2
              ? "💡 Gigi's Hint: Pop the glowing balloon!"
              : 'Listen carefully & pop the matching balloon!'
          }
          onSpeakerClick={handleReplayAudio}
        />

        {/* Floating Balloons Arena */}
        <div className="relative min-h-[340px] flex items-center justify-center gap-3 sm:gap-6 flex-wrap my-4 select-none">
          {balloons.map((b, idx) => {
            const isPopped = poppedIds.has(b.id);
            const isWobbling = wobblingId === b.id;
            const isScaffoldTarget = wrongAttempts >= 2 && targetItem && b.id === targetItem.id;
            const isScaffoldDimmed = wrongAttempts >= 2 && targetItem && b.id !== targetItem.id;

            if (isPopped) {
              return (
                <div
                  key={b.id}
                  className="w-28 sm:w-34 h-44 flex flex-col items-center justify-center opacity-20 pointer-events-none"
                >
                  <span className="text-3xl">💥</span>
                </div>
              );
            }

            return (
              <div
                key={b.id}
                onClick={() => handleBalloonClick(b)}
                className={`relative w-28 sm:w-34 h-44 flex flex-col items-center cursor-pointer transition-transform duration-300 ${
                  isScaffoldTarget
                    ? 'scale-110 animate-pulse ring-4 ring-yellow-400 rounded-full'
                    : isScaffoldDimmed
                    ? 'opacity-35 grayscale'
                    : isWobbling
                    ? 'animate-wiggle'
                    : 'animate-float'
                } hover:scale-110 active:scale-95`}
                style={{ animationDelay: `${idx * 0.4}s` }}
              >
                <div className="relative w-28 h-36 flex items-center justify-center p-3 text-center filter drop-shadow-md">
                  <svg viewBox="0 0 100 125" className="absolute inset-0 w-full h-full">
                    <path
                      d="M 50 5 C 20 5 10 35 10 65 C 10 95 44 110 47 114 L 46 118 L 54 118 L 53 114 C 56 110 90 95 90 65 C 90 35 80 5 50 5 Z"
                      fill={b.fill}
                      stroke="#ffffff"
                      strokeWidth="2"
                    />
                    <ellipse cx="32" cy="35" rx="8" ry="16" fill="#ffffff" fillOpacity="0.4" transform="rotate(-25 32 35)" />
                    <polygon points="46,118 54,118 50,123" fill={b.fill} />
                  </svg>

                  <span className="relative z-10 text-xs sm:text-sm font-extrabold text-slate-900 leading-snug px-1">
                    {b.phrase}
                  </span>
                </div>
                <div className="w-0.5 h-10 bg-slate-300 dark:bg-slate-700"></div>
              </div>
            );
          })}
        </div>
      </div>

      <BottomActionDrawer
        status={status}
        onCheck={() => {}}
        onContinue={handleContinue}
        onTryAgain={() => {}}
        encouragement="POP! Fantastic ear! You found the right balloon!"
        hint="Listen closely! Tap the blue speaker on Gigi's bubble to hear it again."
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1}
          hasMistake={wrongAttempts > 0}
          activityTitle="Balloon Pop: Everyday Greetings"
          paradeWords={BALLOON_PHRASES.map(b => b.phrase)}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
