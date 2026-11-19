/**
 * Unified Bulletproof Audio Engine for Kids Talk Online
 * - Plays real sound effects (.wav) with instant fallback to Web Audio synthesizer
 * - Robust SpeechSynthesis queue management (cancels overlaps, retries voices)
 */

class SoundEffectsEngine {
  constructor() {
    this.soundPaths = {
      tap: '/tap.wav',
      correct: '/correct.wav',
      wrong: '/wrong.wav',
      pop: '/pop.wav',
      victory: '/victory.wav',
      whoosh: '/whoosh.wav',
    };
    this.ctx = null;
  }

  getAudioContext() {
    if (!this.ctx) {
      const AudioCtx = window.AudioContext || window.webkitAudioContext;
      if (AudioCtx) {
        this.ctx = new AudioCtx();
      }
    }
    if (this.ctx && this.ctx.state === 'suspended') {
      this.ctx.resume().catch(() => {});
    }
    return this.ctx;
  }

  // Play audio file with fallback to synthesized tone
  playSoundFile(name, fallbackFn) {
    try {
      const path = this.soundPaths[name];
      if (path) {
        const audio = new Audio(path);
        audio.volume = 0.85;
        const playPromise = audio.play();
        if (playPromise !== undefined) {
          playPromise.catch(() => {
            if (fallbackFn) fallbackFn();
          });
          return;
        }
      }
    } catch (e) {
      if (fallbackFn) fallbackFn();
    }
    if (fallbackFn) fallbackFn();
  }

  playTap() {
    this.playSoundFile('tap', () => {
      const ctx = this.getAudioContext();
      if (!ctx) return;
      try {
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = 'sine';
        osc.frequency.setValueAtTime(520, ctx.currentTime);
        osc.frequency.exponentialRampToValueAtTime(880, ctx.currentTime + 0.05);
        gain.gain.setValueAtTime(0.2, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.05);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(ctx.currentTime + 0.06);
      } catch (err) {}
    });
  }

  playPop() {
    this.playSoundFile('pop', () => {
      const ctx = this.getAudioContext();
      if (!ctx) return;
      try {
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = 'triangle';
        osc.frequency.setValueAtTime(340, ctx.currentTime);
        osc.frequency.exponentialRampToValueAtTime(70, ctx.currentTime + 0.08);
        gain.gain.setValueAtTime(0.3, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.08);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(ctx.currentTime + 0.09);
      } catch (e) {}
    });
  }

  playSuccess() {
    this.playSoundFile('correct', () => {
      const ctx = this.getAudioContext();
      if (!ctx) return;
      try {
        const notes = [523.25, 659.25, 783.99, 1046.50];
        notes.forEach((freq, index) => {
          const osc = ctx.createOscillator();
          const gain = ctx.createGain();
          osc.type = 'sine';
          osc.frequency.setValueAtTime(freq, ctx.currentTime + index * 0.07);
          gain.gain.setValueAtTime(0, ctx.currentTime);
          gain.gain.setValueAtTime(0.25, ctx.currentTime + index * 0.07);
          gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + index * 0.07 + 0.25);
          osc.connect(gain);
          gain.connect(ctx.destination);
          osc.start(ctx.currentTime + index * 0.07);
          osc.stop(ctx.currentTime + index * 0.07 + 0.26);
        });
      } catch (e) {}
    });
  }

  playError() {
    this.playSoundFile('wrong', () => {
      const ctx = this.getAudioContext();
      if (!ctx) return;
      try {
        const notes = [240, 180];
        notes.forEach((freq, index) => {
          const osc = ctx.createOscillator();
          const gain = ctx.createGain();
          osc.type = 'triangle';
          osc.frequency.setValueAtTime(freq, ctx.currentTime + index * 0.1);
          gain.gain.setValueAtTime(0.2, ctx.currentTime + index * 0.1);
          gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + index * 0.1 + 0.18);
          osc.connect(gain);
          gain.connect(ctx.destination);
          osc.start(ctx.currentTime + index * 0.1);
          osc.stop(ctx.currentTime + index * 0.1 + 0.19);
        });
      } catch (e) {}
    });
  }

  playVictory() {
    this.playSoundFile('victory', () => {
      const ctx = this.getAudioContext();
      if (!ctx) return;
      try {
        const notes = [
          { f: 523.25, d: 0.12 },
          { f: 523.25, d: 0.12 },
          { f: 523.25, d: 0.12 },
          { f: 659.25, d: 0.35 },
          { f: 587.33, d: 0.15 },
          { f: 659.25, d: 0.15 },
          { f: 783.99, d: 0.5 }
        ];
        let t = ctx.currentTime;
        notes.forEach((n) => {
          const osc = ctx.createOscillator();
          const gain = ctx.createGain();
          osc.type = 'triangle';
          osc.frequency.setValueAtTime(n.f, t);
          gain.gain.setValueAtTime(0.25, t);
          gain.gain.exponentialRampToValueAtTime(0.001, t + n.d);
          osc.connect(gain);
          gain.connect(ctx.destination);
          osc.start(t);
          osc.stop(t + n.d);
          t += n.d;
        });
      } catch (e) {}
    });
  }
}

export const sfx = new SoundEffectsEngine();

/**
 * Robust Speech Engine
 */
let currentUtterance = null;

export function speakText(text, onEnd) {
  if (typeof window === 'undefined' || !('speechSynthesis' in window)) {
    if (onEnd) onEnd();
    return;
  }

  try {
    window.speechSynthesis.cancel();

    if (!text || text.trim() === '') {
      if (onEnd) onEnd();
      return;
    }

    const cleanText = text.replace(/___+/g, 'blank');
    const utterance = new SpeechSynthesisUtterance(cleanText);
    utterance.lang = 'en-US';
    utterance.rate = 0.90;
    utterance.pitch = 1.10;

    const voices = window.speechSynthesis.getVoices();
    const enVoice = voices.find(v =>
      (v.lang === 'en-US' || v.lang.startsWith('en')) &&
      (v.name.includes('Natural') || v.name.includes('Google') || v.name.includes('Samantha') || v.name.includes('Junior') || v.name.includes('Zira'))
    ) || voices.find(v => v.lang.startsWith('en'));

    if (enVoice) {
      utterance.voice = enVoice;
    }

    utterance.onend = () => {
      currentUtterance = null;
      if (onEnd) onEnd();
    };

    utterance.onerror = (e) => {
      currentUtterance = null;
      if (onEnd) onEnd();
    };

    currentUtterance = utterance;
    setTimeout(() => {
      window.speechSynthesis.speak(utterance);
    }, 40);
  } catch (err) {
    if (onEnd) onEnd();
  }
}

export function stopSpeech() {
  if (typeof window !== 'undefined' && 'speechSynthesis' in window) {
    try {
      window.speechSynthesis.cancel();
      currentUtterance = null;
    } catch (e) {}
  }
}
