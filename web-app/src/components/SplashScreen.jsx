import React, { useState, useEffect } from 'react';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { sfx } from '../utils/audio';

/* Floating confetti particles */
const CONFETTI = Array.from({ length: 18 }, (_, i) => ({
  id: i,
  color: ['#58cc02','#1cb0f6','#ffc800','#ff86d0','#ce82ff','#ff9600'][i % 6],
  left: `${5 + (i * 5.3) % 90}%`,
  size: 6 + (i % 4) * 3,
  delay: `${(i * 0.17).toFixed(2)}s`,
  duration: `${1.8 + (i % 5) * 0.3}s`,
}));

export function SplashScreen({ onFinish }) {
  const [stage, setStage] = useState('enter'); // enter → show → exit

  useEffect(() => {
    try { sfx.playSuccess(); } catch (_) {}

    const t1 = setTimeout(() => setStage('show'),  200);
    const t2 = setTimeout(() => setStage('exit'), 2400);
    const t3 = setTimeout(() => onFinish?.(),     2900);

    return () => { clearTimeout(t1); clearTimeout(t2); clearTimeout(t3); };
  }, [onFinish]);

  return (
    <div
      className={`fixed inset-0 z-50 flex flex-col items-center justify-between overflow-hidden select-none
        transition-all duration-500
        ${stage === 'exit' ? 'opacity-0 scale-95 pointer-events-none' : 'opacity-100 scale-100'}`}
      style={{ background: 'linear-gradient(160deg, #58cc02 0%, #46a302 40%, #2d7a00 100%)' }}
    >
      {/* Confetti rain */}
      {CONFETTI.map(c => (
        <div
          key={c.id}
          className="absolute top-0 rounded-sm opacity-80"
          style={{
            left: c.left,
            width: c.size,
            height: c.size * 1.4,
            backgroundColor: c.color,
            animationName: 'confettiFall',
            animationDuration: c.duration,
            animationDelay: c.delay,
            animationTimingFunction: 'linear',
            animationIterationCount: 'infinite',
            willChange: 'transform',
          }}
        />
      ))}

      {/* Top pill */}
      <div className="w-full flex justify-center pt-14 z-10">
        <div className="px-5 py-2 rounded-full bg-black/20 backdrop-blur-md flex items-center gap-2 text-white/90 text-xs font-black tracking-widest uppercase">
          <span className="w-2 h-2 rounded-full bg-white animate-pulse" />
          Kids Talk Online
        </div>
      </div>

      {/* Center — Gigi mascot */}
      <div
        className={`flex flex-col items-center text-center z-10 transition-all duration-700 ${
          stage === 'enter' ? 'opacity-0 translate-y-10 scale-75' : 'opacity-100 translate-y-0 scale-100'
        }`}
        style={{ willChange: 'transform, opacity' }}
      >
        {/* Gigi with glow */}
        <div
          className="relative w-52 h-52 sm:w-64 sm:h-64 mb-2"
          style={{
            filter: 'drop-shadow(0 20px 40px rgba(0,0,0,0.35))',
          }}
        >
          {/* Glow ring behind mascot */}
          <div
            className="absolute inset-0 rounded-full bg-white/10 blur-xl scale-75"
            style={{ willChange: 'transform' }}
          />
          <img
            src={MASCOT_IMAGES.celebrating}
            alt="Gigi the Giraffe"
            className="w-full h-full object-contain animate-gigi-dance"
            style={{ willChange: 'transform' }}
          />
        </div>

        <h1 className="text-4xl font-black text-white drop-shadow-md tracking-tight">
          Gigi &amp; Friends
        </h1>
        <p className="text-white/80 font-bold text-sm mt-1.5 tracking-wide">
          Let's learn English together! 🎉
        </p>

        {/* Animated dots loader */}
        <div className="flex gap-2 mt-6">
          {[0, 1, 2].map(i => (
            <div
              key={i}
              className="w-3 h-3 rounded-full bg-white/60"
              style={{
                animationName: 'bounceSubtle',
                animationDuration: '0.9s',
                animationDelay: `${i * 0.2}s`,
                animationIterationCount: 'infinite',
                animationTimingFunction: 'ease-in-out',
              }}
            />
          ))}
        </div>
      </div>

      {/* Bottom brand */}
      <div className="pb-14 z-10 text-center">
        <span className="text-white/60 text-xs font-black tracking-widest uppercase">
          kidstalk<span className="text-white/90">.online</span>
        </span>
      </div>
    </div>
  );
}
