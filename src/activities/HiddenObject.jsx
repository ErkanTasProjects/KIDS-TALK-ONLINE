import React, { useState } from 'react';
import confetti from 'canvas-confetti';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { speakText, sfx } from '../utils/audio';
import { Check } from 'lucide-react';

const HIDDEN_OBJECTS = [
  {
    id: 'name',
    name: 'Name Tag',
    speech: 'My name is Alex.',
    top: '25%',
    left: '32%',
    svg: (
      <g>
        <rect x="0" y="0" width="40" height="26" rx="4" fill="#3B82F6" stroke="#1D4ED8" strokeWidth="2" />
        <rect x="4" y="4" width="32" height="18" fill="#FFFFFF" rx="2" />
        <text x="20" y="17" textAnchor="middle" fontSize="10" fontWeight="bold" fill="#1E293B">Alex</text>
      </g>
    )
  },
  {
    id: 'age',
    name: 'Birthday Cake',
    speech: 'I am ten years old.',
    top: '64%',
    left: '18%',
    svg: (
      <g>
        <rect x="2" y="14" width="36" height="18" rx="4" fill="#F472B6" />
        <line x1="20" y1="14" x2="20" y2="4" stroke="#FBBF24" strokeWidth="3" strokeLinecap="round" />
        <circle cx="20" cy="3" r="3" fill="#EF4444" />
        <text x="20" y="27" textAnchor="middle" fontSize="11" fontWeight="extrabold" fill="#FFFFFF">10</text>
      </g>
    )
  },
  {
    id: 'city',
    name: 'City Snow Globe',
    speech: 'I live in a city.',
    top: '28%',
    left: '68%',
    svg: (
      <g>
        <circle cx="20" cy="18" r="16" fill="#BAE6FD" stroke="#0284C7" strokeWidth="2" />
        <rect x="10" y="32" width="20" height="6" rx="2" fill="#64748B" />
        <rect x="14" y="10" width="5" height="16" fill="#0284C7" />
        <rect x="21" y="14" width="6" height="12" fill="#0369A1" />
      </g>
    )
  },
  {
    id: 'school',
    name: 'School Backpack',
    speech: 'I go to school.',
    top: '68%',
    left: '74%',
    svg: (
      <g>
        <rect x="6" y="8" width="28" height="28" rx="6" fill="#10B981" stroke="#047857" strokeWidth="2" />
        <rect x="11" y="20" width="18" height="12" rx="3" fill="#059669" />
        <line x1="12" y1="18" x2="28" y2="18" stroke="#FDE047" strokeWidth="2" />
      </g>
    )
  },
  {
    id: 'football',
    name: 'Soccer Ball',
    speech: 'I like playing football.',
    top: '74%',
    left: '46%',
    svg: (
      <g>
        <circle cx="20" cy="20" r="18" fill="#FFFFFF" stroke="#1E293B" strokeWidth="2" />
        <polygon points="20,13 25,17 23,23 17,23 15,17" fill="#1E293B" />
      </g>
    )
  },
];

export function HiddenObject({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [foundIds, setFoundIds] = useState(new Set());
  const [activeItem, setActiveItem] = useState(null);
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);

  const handleObjectClick = (obj) => {
    sfx.playTap();
    sfx.playSuccess();
    try {
      confetti({ particleCount: 25, spread: 50, origin: { y: 0.6 } });
    } catch (e) {}

    const newFound = new Set(foundIds);
    newFound.add(obj.id);
    setFoundIds(newFound);
    setActiveItem(obj);
    setMascotPose('celebrating');
    speakText(obj.speech);
  };

  const handleCloseActivePopup = () => {
    setActiveItem(null);
    setMascotPose('pointing');
    if (foundIds.size >= HIDDEN_OBJECTS.length) {
      setIsCompleted(true);
      if (onComplete) onComplete(3);
    }
  };

  return (
    <div className="min-h-screen bg-sky-50 dark:bg-slate-950 flex flex-col justify-between pb-32 transition-colors">
      <HeaderZone
        currentStep={foundIds.size}
        totalSteps={HIDDEN_OBJECTS.length}
        stars={currentStars}
        onClose={onExit}
        title="Hidden Objects"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-4xl mx-auto flex-1 flex flex-col justify-center px-4 w-full">
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={
            foundIds.size === 5
              ? 'Awesome! You found all 5 hidden objects!'
              : 'Explore Alex’s room! Click the hidden objects to learn about him.'
          }
          onSpeakerClick={() => speakText('Click the hidden objects to learn about Alex!')}
        />

        {/* Bedroom Illustrated Scene */}
        <div className="relative w-full max-w-2xl mx-auto h-[320px] sm:h-[380px] bg-amber-100/70 dark:bg-slate-900 border-4 border-amber-300 dark:border-slate-700 rounded-3xl shadow-lg my-2 overflow-hidden select-none">
          <svg viewBox="0 0 500 350" className="absolute inset-0 w-full h-full pointer-events-none">
            <rect x="0" y="0" width="500" height="240" fill="#E0F2FE" className="dark:fill-slate-800" />
            <rect x="0" y="240" width="500" height="110" fill="#FED7AA" className="dark:fill-slate-900" />
            <line x1="0" y1="240" x2="500" y2="240" stroke="#FDBA74" strokeWidth="4" />

            <rect x="180" y="30" width="140" height="110" rx="6" fill="#BAE6FD" stroke="#0284C7" strokeWidth="4" />
            <line x1="250" y1="30" x2="250" y2="140" stroke="#0284C7" strokeWidth="3" />
            <line x1="180" y1="85" x2="320" y2="85" stroke="#0284C7" strokeWidth="3" />
            <circle cx="215" cy="65" r="18" fill="#FBBF24" />

            <rect x="20" y="160" width="130" height="90" rx="8" fill="#60A5FA" stroke="#2563EB" strokeWidth="3" />
            <rect x="25" y="165" width="40" height="25" rx="4" fill="#FFFFFF" />
            <rect x="20" y="195" width="130" height="55" rx="4" fill="#3B82F6" />

            <rect x="330" y="170" width="140" height="20" rx="4" fill="#B45309" />
            <rect x="345" y="190" width="12" height="70" fill="#92400E" />
            <rect x="440" y="190" width="12" height="70" fill="#92400E" />
            <polygon points="350,150 370,150 375,170 345,170" fill="#FACC15" />
            <line x1="360" y1="150" x2="360" y2="170" stroke="#CA8A04" strokeWidth="3" />

            <ellipse cx="250" cy="285" rx="90" ry="32" fill="#FDE047" stroke="#F59E0B" strokeWidth="3" />
          </svg>

          {HIDDEN_OBJECTS.map((item) => {
            const isFound = foundIds.has(item.id);
            return (
              <button
                key={item.id}
                onClick={() => handleObjectClick(item)}
                style={{ top: item.top, left: item.left }}
                className={`absolute transform -translate-x-1/2 -translate-y-1/2 p-2 rounded-2xl transition-all duration-300 ${
                  isFound
                    ? 'ring-4 ring-emerald-400 bg-emerald-100/90 dark:bg-emerald-950/80 scale-110 shadow-lg'
                    : 'hover:scale-125 hover:ring-4 hover:ring-amber-400 active:scale-95 animate-pulse'
                }`}
              >
                <svg width="40" height="40" viewBox="0 0 40 40">
                  {item.svg}
                </svg>
                {isFound && (
                  <div className="absolute -top-2 -right-2 w-6 h-6 bg-emerald-500 text-white rounded-full flex items-center justify-center shadow-sm">
                    <Check className="w-4 h-4 stroke-[3]" />
                  </div>
                )}
              </button>
            );
          })}

          {activeItem && (
            <div className="absolute inset-x-4 bottom-4 bg-white/95 dark:bg-slate-900/95 backdrop-blur-sm border-2 border-emerald-400 rounded-2xl p-4 shadow-xl flex items-center justify-between gap-3 animate-pop z-30">
              <div>
                <p className="text-lg font-black text-slate-800 dark:text-white">{activeItem.speech}</p>
              </div>
              <button
                onClick={handleCloseActivePopup}
                className="bg-emerald-500 hover:bg-emerald-400 text-white font-extrabold px-4 py-2 rounded-xl text-sm border-b-2 border-emerald-600 active:translate-y-0.5 shadow-sm"
              >
                Cool!
              </button>
            </div>
          )}
        </div>

        {/* Found checklist */}
        <div className="flex flex-wrap items-center justify-center gap-2 mt-2">
          {HIDDEN_OBJECTS.map(item => {
            const isFound = foundIds.has(item.id);
            return (
              <span
                key={item.id}
                className={`px-3 py-1 rounded-full text-xs font-bold flex items-center gap-1.5 border ${
                  isFound
                    ? 'bg-emerald-100 dark:bg-emerald-950 border-emerald-300 dark:border-emerald-700 text-emerald-800 dark:text-emerald-200'
                    : 'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800 text-slate-400'
                }`}
              >
                {isFound ? '✓' : '○'} {item.name}
              </span>
            );
          })}
        </div>
      </div>

      <BottomActionDrawer
        status={foundIds.size === 5 ? 'correct' : 'idle'}
        onCheck={() => {}}
        onContinue={() => {
          setIsCompleted(true);
          if (onComplete) onComplete(3);
        }}
        onTryAgain={() => {}}
        encouragement="Awesome! You explored Alex’s entire room and learned his story!"
        hint="Keep searching around the room to find all items!"
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={3}
          hasMistake={false}
          activityTitle="Hidden Object: Self-Introduction"
          paradeWords={HIDDEN_OBJECTS.map(o => o.speech)}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
