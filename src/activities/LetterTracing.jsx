import React, { useState, useRef, useEffect } from 'react';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { Illustration } from '../components/Illustration';
import { speakText, sfx } from '../utils/audio';
import { RotateCcw } from 'lucide-react';

const FAMILY_LETTERS = [
  {
    letterUpper: 'M',
    letterLower: 'm',
    word: 'Mother',
    icon: 'mother',
    speech: 'M is for Mother!',
  },
  {
    letterUpper: 'F',
    letterLower: 'f',
    word: 'Father',
    icon: 'father',
    speech: 'F is for Father!',
  },
  {
    letterUpper: 'B',
    letterLower: 'b',
    word: 'Brother',
    icon: 'brother',
    speech: 'B is for Brother!',
  },
  {
    letterUpper: 'S',
    letterLower: 's',
    word: 'Sister',
    icon: 'sister',
    speech: 'S is for Sister!',
  },
  {
    letterUpper: 'G',
    letterLower: 'g',
    word: 'Grandmother',
    icon: 'grandmother',
    speech: 'G is for Grandmother!',
  },
];

export function LetterTracing({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [tracedPoints, setTracedPoints] = useState(0);
  const [status, setStatus] = useState('idle');
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);
  const [revealed, setRevealed] = useState(false);

  const canvasRef = useRef(null);
  const isDrawing = useRef(false);

  const currentItem = FAMILY_LETTERS[currentIndex];

  useEffect(() => {
    resetCanvas();
    setStatus('idle');
    setRevealed(false);
    setTracedPoints(0);
    setMascotPose('pointing');
    speakText(`Trace the letter ${currentItem.letterUpper} for ${currentItem.word}`);
  }, [currentIndex]);

  const resetCanvas = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setTracedPoints(0);
    setStatus('idle');
    setRevealed(false);
  };

  const getCanvasPos = (e) => {
    const canvas = canvasRef.current;
    if (!canvas) return { x: 0, y: 0 };
    const rect = canvas.getBoundingClientRect();
    const clientX = e.touches ? e.touches[0].clientX : e.clientX;
    const clientY = e.touches ? e.touches[0].clientY : e.clientY;
    return {
      x: ((clientX - rect.left) / rect.width) * canvas.width,
      y: ((clientY - rect.top) / rect.height) * canvas.height,
    };
  };

  const startDraw = (e) => {
    e.preventDefault();
    isDrawing.current = true;
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    const pos = getCanvasPos(e);
    ctx.beginPath();
    ctx.moveTo(pos.x, pos.y);
    ctx.strokeStyle = '#38BDF8';
    ctx.lineWidth = 26;
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
    sfx.playTap();
  };

  const draw = (e) => {
    if (!isDrawing.current) return;
    e.preventDefault();
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    const pos = getCanvasPos(e);
    ctx.lineTo(pos.x, pos.y);
    ctx.stroke();

    setTracedPoints(prev => {
      const next = prev + 1;
      if (next > 25 && status !== 'ready' && status !== 'correct') {
        setStatus('ready');
      }
      return next;
    });
  };

  const stopDraw = () => {
    isDrawing.current = false;
  };

  const handleCheck = () => {
    sfx.playSuccess();
    setMascotPose('celebrating');
    setStatus('correct');
    setRevealed(true);
    speakText(currentItem.speech);
  };

  const handleContinue = () => {
    if (currentIndex + 1 < FAMILY_LETTERS.length) {
      setCurrentIndex(prev => prev + 1);
    } else {
      setIsCompleted(true);
      if (onComplete) onComplete(3);
    }
  };

  const handleTryAgain = () => {
    resetCanvas();
    setMascotPose('pointing');
  };

  return (
    <div className="min-h-screen bg-amber-50 dark:bg-slate-950 flex flex-col justify-between pb-32 transition-colors">
      <HeaderZone
        currentStep={currentIndex + 1}
        totalSteps={FAMILY_LETTERS.length}
        stars={currentStars}
        onClose={onExit}
        title="Letter Tracing"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-2xl mx-auto flex-1 flex flex-col justify-center items-center px-4 w-full">
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={
            status === 'correct'
              ? `${currentItem.word}!`
              : `Trace letter ${currentItem.letterUpper} for ${currentItem.word}!`
          }
          onSpeakerClick={() => speakText(currentItem.speech)}
        />

        {/* Tracing Board Stage */}
        <div className="relative w-72 h-72 sm:w-80 sm:h-80 bg-white dark:bg-slate-900 border-4 border-slate-200 dark:border-slate-800 border-b-8 rounded-3xl shadow-lg flex items-center justify-center my-3 overflow-hidden select-none">
          <div className="absolute inset-0 flex items-center justify-center pointer-events-none select-none">
            <span className="text-[170px] sm:text-[190px] font-black text-slate-200 dark:text-slate-800 tracking-tighter select-none font-bubble">
              {currentItem.letterUpper}
            </span>
          </div>

          <div className="absolute top-6 left-8 bg-sky-100 dark:bg-sky-950 text-sky-700 dark:text-sky-300 px-2.5 py-1 rounded-full text-xs font-extrabold shadow-sm pointer-events-none flex items-center gap-1">
            <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-ping"></span>
            <span>Start here & trace!</span>
          </div>

          <canvas
            ref={canvasRef}
            width={320}
            height={320}
            onMouseDown={startDraw}
            onMouseMove={draw}
            onMouseUp={stopDraw}
            onMouseLeave={stopDraw}
            onTouchStart={startDraw}
            onTouchMove={draw}
            onTouchEnd={stopDraw}
            className="absolute inset-0 w-full h-full cursor-crosshair touch-none"
          />

          <button
            onClick={resetCanvas}
            className="absolute bottom-3 right-3 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 rounded-xl px-2.5 py-1 text-xs font-bold flex items-center gap-1 border border-slate-300 dark:border-slate-700 shadow-sm"
          >
            <RotateCcw className="w-3.5 h-3.5" />
            <span>Clear</span>
          </button>

          {revealed && (
            <div className="absolute inset-0 bg-white/95 dark:bg-slate-900/95 backdrop-blur-xs flex flex-col items-center justify-center p-4 animate-pop z-20">
              <div className="w-28 h-28 mb-2">
                <Illustration name={currentItem.icon} className="w-full h-full drop-shadow-md" />
              </div>
              <p className="text-2xl font-black text-slate-800 dark:text-white">{currentItem.word}</p>
            </div>
          )}
        </div>

        <div className="flex gap-2 mt-1">
          {FAMILY_LETTERS.map((item, idx) => (
            <span
              key={item.letterUpper}
              className={`w-3 h-3 rounded-full transition-all ${
                idx === currentIndex
                  ? 'bg-sky-500 scale-125'
                  : idx < currentIndex
                  ? 'bg-emerald-400'
                  : 'bg-slate-300 dark:bg-slate-700'
              }`}
            />
          ))}
        </div>
      </div>

      <BottomActionDrawer
        status={status}
        onCheck={handleCheck}
        onContinue={handleContinue}
        onTryAgain={handleTryAgain}
        checkLabel="DONE TRACING"
        encouragement={`Awesome! ${currentItem.letterUpper} is for ${currentItem.word}!`}
        hint="Follow the shape of the letter with your finger or mouse!"
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={3}
          hasMistake={false}
          activityTitle="Letter Tracing: Family Members"
          paradeWords={FAMILY_LETTERS.map(f => `${f.letterUpper} is for ${f.word}`)}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
