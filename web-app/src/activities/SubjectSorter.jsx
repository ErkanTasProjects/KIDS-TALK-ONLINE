import React, { useState, useEffect } from 'react';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { Illustration } from '../components/Illustration';
import { shuffleArray } from '../utils/shuffle';
import { speakText, sfx } from '../utils/audio';
import { Volume2 } from 'lucide-react';

const SUBJECT_ITEMS = [
  { id: 'monday', subject: 'Monday', sentence: 'I have English on Monday.', icon: 'monday' },
  { id: 'math', subject: 'Math', sentence: 'Math is my favorite subject.', icon: 'math' },
  { id: 'english', subject: 'English', sentence: 'I like English.', icon: 'english' },
  { id: 'science', subject: 'Science', sentence: 'I have Science today.', icon: 'science' },
  { id: 'art', subject: 'Art', sentence: 'Art is fun.', icon: 'art' },
  { id: 'pe', subject: 'PE', sentence: 'I have PE on Friday.', icon: 'pe' },
];

export function SubjectSorter({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [targets, setTargets] = useState([]);
  const [cards, setCards] = useState([]);
  const [selectedCard, setSelectedCard] = useState(null);
  const [placed, setPlaced] = useState({});
  const [wrongAttempts, setWrongAttempts] = useState(0);
  const [status, setStatus] = useState('idle');
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);

  useEffect(() => {
    // Randomize targets AND sentences
    setTargets(shuffleArray(SUBJECT_ITEMS));
    setCards(shuffleArray(SUBJECT_ITEMS));
    setPlaced({});
    setSelectedCard(null);
    setWrongAttempts(0);
    setStatus('idle');
    setMascotPose('pointing');
    speakText('Sort each school sentence onto its subject!');
  }, []);

  useEffect(() => {
    if (Object.keys(placed).length === SUBJECT_ITEMS.length) {
      setStatus('ready');
    } else {
      if (status !== 'correct' && status !== 'incorrect') {
        setStatus('idle');
      }
    }
  }, [placed]);

  const handleSelectCard = (c) => {
    sfx.playTap();
    speakText(c.sentence);
    setSelectedCard(c);

    const openTarget = targets.find(t => !placed[t.id]);
    if (openTarget) {
      setPlaced(prev => ({ ...prev, [openTarget.id]: c.id }));
      setSelectedCard(null);
    }
  };

  const handleTapTarget = (t) => {
    sfx.playTap();
    if (placed[t.id]) {
      setPlaced(prev => {
        const next = { ...prev };
        delete next[t.id];
        return next;
      });
      setStatus('idle');
    } else if (selectedCard) {
      setPlaced(prev => ({ ...prev, [t.id]: selectedCard.id }));
      setSelectedCard(null);
    }
  };

  const handleDrop = (e, t) => {
    e.preventDefault();
    const cId = e.dataTransfer.getData('text/plain');
    if (cId) {
      sfx.playTap();
      const updated = { ...placed };
      Object.keys(updated).forEach(k => {
        if (updated[k] === cId) delete updated[k];
      });
      updated[t.id] = cId;
      setPlaced(updated);
    }
  };

  const handleCheck = () => {
    let allRight = true;
    for (const t of targets) {
      if (placed[t.id] !== t.id) {
        allRight = false;
        break;
      }
    }

    if (allRight) {
      sfx.playSuccess();
      setMascotPose('celebrating');
      setStatus('correct');
      speakText('Awesome sorting! You know your school subjects!');
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
    const updated = { ...placed };
    Object.keys(updated).forEach(id => {
      if (updated[id] !== id) delete updated[id];
    });
    setPlaced(updated);
    setStatus('idle');
    setMascotPose('pointing');
  };

  const placedCardIds = new Set(Object.values(placed));
  const availableCards = cards.filter(c => !placedCardIds.has(c.id));

  return (
    <div className="min-h-screen bg-amber-50 dark:bg-slate-950 flex flex-col justify-between pb-32 transition-colors">
      <HeaderZone
        currentStep={Object.keys(placed).length}
        totalSteps={targets.length}
        stars={currentStars}
        onClose={onExit}
        title="Subject Sorter"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-4xl mx-auto flex-1 flex flex-col justify-center px-4 w-full">
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={
            status === 'correct'
              ? 'Great job! All subjects sorted!'
              : 'Match each school life sentence with its subject!'
          }
          onSpeakerClick={() => speakText('Match each sentence with its subject!')}
        />

        {/* 6 Target Boxes Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 my-3">
          {targets.map((t) => {
            const placedCardId = placed[t.id];
            const matchedCard = cards.find(c => c.id === placedCardId);
            const isCorrect = status === 'correct' && placedCardId === t.id;

            return (
              <div
                key={t.id}
                onDrop={(e) => handleDrop(e, t)}
                onDragOver={(e) => e.preventDefault()}
                onClick={() => handleTapTarget(t)}
                className={`p-3 rounded-2xl border-2 transition-all flex flex-col items-center justify-between min-h-[140px] cursor-pointer ${
                  isCorrect
                    ? 'bg-emerald-50 dark:bg-emerald-950/60 border-emerald-400'
                    : placedCardId
                    ? 'bg-amber-50 dark:bg-slate-800 border-amber-300 dark:border-slate-700'
                    : 'bg-white dark:bg-slate-900 border-dashed border-slate-300 dark:border-slate-700 hover:border-sky-400'
                }`}
              >
                <div className="flex items-center gap-2 mb-1">
                  <div className="w-9 h-9">
                    <Illustration name={t.icon} className="w-full h-full" />
                  </div>
                  <span className="font-extrabold text-sm text-slate-800 dark:text-slate-100">{t.subject}</span>
                </div>

                <div
                  className={`w-full min-h-[44px] rounded-xl p-2 text-xs font-bold text-center flex items-center justify-center border ${
                    matchedCard
                      ? 'bg-white dark:bg-slate-800 border-sky-400 border-b-2 text-sky-950 dark:text-sky-200 shadow-sm'
                      : 'border-dashed border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/40 text-slate-400'
                  }`}
                >
                  {matchedCard ? matchedCard.sentence : '+ Tap to place'}
                </div>
              </div>
            );
          })}
        </div>

        {/* Available Sentences */}
        <div className="bg-white/90 dark:bg-slate-900 border-2 border-slate-200 dark:border-slate-800 border-b-4 rounded-2xl p-4 shadow-sm mt-1">
          <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider text-center mb-2">
            Available Sentences (Tap to place)
          </p>
          <div className="flex flex-wrap gap-2 justify-center">
            {availableCards.length === 0 ? (
              <p className="text-sm font-bold text-emerald-600 dark:text-emerald-400">All placed! Now press CHECK.</p>
            ) : (
              availableCards.map((c) => (
                <div
                  key={c.id}
                  draggable
                  onDragStart={(e) => {
                    e.dataTransfer.setData('text/plain', c.id);
                    speakText(c.sentence);
                  }}
                  onClick={() => handleSelectCard(c)}
                  className="bg-white dark:bg-slate-800 hover:bg-slate-50 dark:hover:bg-slate-700 active:translate-y-1 border-2 border-slate-200 dark:border-slate-700 border-b-4 rounded-xl px-3.5 py-2 font-extrabold text-xs sm:text-sm text-slate-800 dark:text-slate-100 cursor-pointer shadow-sm flex items-center gap-1.5"
                >
                  <span>{c.sentence}</span>
                  <Volume2 className="w-3.5 h-3.5 text-sky-500" />
                </div>
              ))
            )}
          </div>
        </div>
      </div>

      <BottomActionDrawer
        status={status}
        onCheck={handleCheck}
        onContinue={handleContinue}
        onTryAgain={handleTryAgain}
        encouragement="Awesome sorting! You know your school subjects!"
        hint="Check which day or subject is mentioned in the sentence!"
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1}
          hasMistake={wrongAttempts > 0}
          activityTitle="School Life & Subjects Sorter"
          paradeWords={SUBJECT_ITEMS.map(s => s.sentence)}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
