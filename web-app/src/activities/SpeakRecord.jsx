import React, { useState, useRef, useEffect } from 'react';
import { HeaderZone } from '../components/HeaderZone';
import { MascotSpeechBubble } from '../components/MascotSpeechBubble';
import { BottomActionDrawer } from '../components/BottomActionDrawer';
import { CompletionModal } from '../components/CompletionModal';
import { speakText, sfx } from '../utils/audio';
import { Mic, Square, Play, Volume2, AlertCircle, CheckCircle2 } from 'lucide-react';

const SPEAK_QUESTIONS = [
  {
    id: 1,
    question: 'Tell me about your sister.',
    keywords: ['sister', 'she', 'likes', 'dancing', 'music', 'kind', 'friendly', 'girl', 'plays', 'love', 'tall', 'little', 'big', 'my', 'is', 'has', 'student'],
    helpfulHint: 'Say: "She likes dancing" or "My sister is friendly!"',
  },
  {
    id: 2,
    question: 'What does your brother like?',
    keywords: ['brother', 'he', 'likes', 'football', 'games', 'play', 'video', 'pizza', 'sport', 'cars', 'music', 'reading', 'soccer', 'running', 'my', 'is', 'has'],
    helpfulHint: 'Say: "He likes playing football" or "He likes video games!"',
  },
  {
    id: 3,
    question: 'Who is your best friend?',
    keywords: ['friend', 'best', 'my', 'is', 'name', 'he', 'she', 'friendly', 'kind', 'nice', 'fun', 'we', 'play', 'school', 'alex', 'emma', 'together'],
    helpfulHint: 'Say: "My best friend is kind and we play together!"',
  },
  {
    id: 4,
    question: 'What does your mother do?',
    keywords: ['mother', 'mom', 'she', 'works', 'doctor', 'teacher', 'cooking', 'cooks', 'delicious', 'food', 'home', 'kind', 'love', 'office', 'nurse', 'my', 'is', 'takes'],
    helpfulHint: 'Say: "She likes cooking delicious food" or "My mother is a teacher!"',
  },
  {
    id: 5,
    question: 'What do you like doing with your friends?',
    keywords: ['we', 'like', 'playing', 'play', 'games', 'park', 'soccer', 'football', 'together', 'friends', 'talk', 'fun', 'cycling', 'running', 'toys', 'draw', 'read'],
    helpfulHint: 'Say: "We like playing games at the park!"',
  },
];

export function SpeakRecord({ onComplete, onNext, onExit, currentStars = 0, onOpenSubscribe }) {
  const [currentIdx, setCurrentIdx] = useState(0);
  const [isRecording, setIsRecording] = useState(false);
  const [hasRecorded, setHasRecorded] = useState(false);
  const [audioUrl, setAudioUrl] = useState(null);
  const [isPlayingBack, setIsPlayingBack] = useState(false);
  const [transcript, setTranscript] = useState('');
  const [liveHeard, setLiveHeard] = useState('');
  const [speechFeedback, setSpeechFeedback] = useState('');
  const [wrongAttempts, setWrongAttempts] = useState(0);
  const [status, setStatus] = useState('idle');
  const [mascotPose, setMascotPose] = useState('pointing');
  const [isCompleted, setIsCompleted] = useState(false);

  const mediaRecorderRef = useRef(null);
  const audioChunksRef = useRef([]);
  const recognitionRef = useRef(null);
  const recordedTextRef = useRef('');

  const q = SPEAK_QUESTIONS[currentIdx];

  useEffect(() => {
    setHasRecorded(false);
    setIsRecording(false);
    setAudioUrl(null);
    setTranscript('');
    setLiveHeard('');
    setSpeechFeedback('');
    setStatus('idle');
    setMascotPose('pointing');
    speakText(q.question);
  }, [currentIdx]);

  // Clean up recognition on unmount
  useEffect(() => {
    return () => {
      if (recognitionRef.current) {
        try {
          recognitionRef.current.abort();
        } catch (e) {}
      }
      if (mediaRecorderRef.current && mediaRecorderRef.current.state === 'recording') {
        try {
          mediaRecorderRef.current.stop();
        } catch (e) {}
      }
    };
  }, []);

  const startRecording = async () => {
    sfx.playTap();
    audioChunksRef.current = [];
    recordedTextRef.current = '';
    setTranscript('');
    setLiveHeard('');
    setSpeechFeedback('');
    setIsRecording(true);
    setMascotPose('thinking');

    // 1. Start SpeechRecognition if available
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (SpeechRecognition) {
      try {
        const recognition = new SpeechRecognition();
        recognition.lang = 'en-US';
        recognition.continuous = true;
        recognition.interimResults = true;

        recognition.onresult = (event) => {
          let interimTranscript = '';
          let finalTranscript = '';
          for (let i = event.resultIndex; i < event.results.length; ++i) {
            if (event.results[i].isFinal) {
              finalTranscript += event.results[i][0].transcript;
            } else {
              interimTranscript += event.results[i][0].transcript;
            }
          }
          const spoken = (finalTranscript || interimTranscript).trim();
          setLiveHeard(spoken);
          recordedTextRef.current = spoken;
        };

        recognition.onerror = () => {};
        recognition.start();
        recognitionRef.current = recognition;
      } catch (err) {}
    }

    // 2. Start MediaRecorder for user playback
    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
      try {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        const mediaRecorder = new MediaRecorder(stream);
        mediaRecorderRef.current = mediaRecorder;

        mediaRecorder.ondataavailable = (e) => {
          if (e.data.size > 0) {
            audioChunksRef.current.push(e.data);
          }
        };

        mediaRecorder.onstop = () => {
          const blob = new Blob(audioChunksRef.current, { type: 'audio/webm' });
          const url = URL.createObjectURL(blob);
          setAudioUrl(url);
          stream.getTracks().forEach(track => track.stop());

          // Save to Parent Zone Voice Portfolio
          try {
            const reader = new FileReader();
            reader.onloadend = () => {
              try {
                const base64Audio = reader.result;
                const existing = JSON.parse(localStorage.getItem('kids_talk_voice_clips') || '[]');
                const newClip = {
                  id: Date.now(),
                  question: q.question,
                  transcript: recordedTextRef.current || 'Great speaking attempt!',
                  audioUrl: base64Audio,
                  timestamp: new Date().toISOString()
                };
                const updated = [newClip, ...existing.filter(c => c.question !== q.question).slice(0, 9)];
                localStorage.setItem('kids_talk_voice_clips', JSON.stringify(updated));
              } catch (err) {}
            };
            reader.readAsDataURL(blob);
          } catch (err) {}
        };

        mediaRecorder.start();
      } catch (err) {}
    }
  };

  const stopRecording = () => {
    setIsRecording(false);

    // Stop Speech Recognition
    if (recognitionRef.current) {
      try {
        recognitionRef.current.stop();
      } catch (e) {}
    }

    // Stop Media Recorder
    if (mediaRecorderRef.current && mediaRecorderRef.current.state === 'recording') {
      try {
        mediaRecorderRef.current.stop();
      } catch (e) {}
    }

    setHasRecorded(true);

    // Analyze spoken result after a brief moment
    setTimeout(() => {
      evaluateSpeech(recordedTextRef.current);
    }, 400);
  };

  // Real Speech Analysis & Validation
  const evaluateSpeech = (spokenText) => {
    const clean = (spokenText || '').toLowerCase().trim();
    setTranscript(clean);

    // Case 1: USER SAID NOTHING / SILENCE
    if (!clean || clean.length < 3) {
      sfx.playError();
      setMascotPose('thinking');
      setWrongAttempts(prev => prev + 1);
      setStatus('incorrect');
      setSpeechFeedback("I couldn't hear you speak! Please speak louder into your microphone in English.");
      speakText("I didn't hear you! Please speak louder into your microphone.");
      return;
    }

    // Case 2: USER SPOKE WORDS - CHECK KEYWORDS & LENGTH
    const words = clean.split(/\s+/);
    const matchedKeywords = q.keywords.filter(k => clean.includes(k));

    // Valid if user spoke at least 2 words AND at least one relevant topic keyword, or a full English sentence (>= 4 words)
    const isPassing = (words.length >= 2 && matchedKeywords.length >= 1) || words.length >= 4;

    if (isPassing) {
      sfx.playSuccess();
      setMascotPose('celebrating');
      setStatus('correct');
      setSpeechFeedback(`Wonderful! You said: "${clean}"`);
      speakText('Great speaking! I loved hearing your answer!');
    } else {
      // User said something unrelated or too short
      sfx.playError();
      setMascotPose('thinking');
      setWrongAttempts(prev => prev + 1);
      setStatus('incorrect');
      setSpeechFeedback(`I heard: "${clean}". Try to answer: ${q.helpfulHint}`);
      speakText(`Try again! ${q.helpfulHint}`);
    }
  };

  const playRecordedAudio = () => {
    if (audioUrl) {
      const audio = new Audio(audioUrl);
      setIsPlayingBack(true);
      audio.onended = () => setIsPlayingBack(false);
      audio.play().catch(() => setIsPlayingBack(false));
    } else {
      setIsPlayingBack(true);
      speakText(transcript || 'No recording found', () => setIsPlayingBack(false));
    }
  };

  const handleContinue = () => {
    if (currentIdx + 1 < SPEAK_QUESTIONS.length) {
      setCurrentIdx(prev => prev + 1);
    } else {
      const earned = wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1;
      setIsCompleted(true);
      if (onComplete) onComplete(earned);
    }
  };

  const handleTryAgain = () => {
    setHasRecorded(false);
    setIsRecording(false);
    setAudioUrl(null);
    setTranscript('');
    setLiveHeard('');
    setSpeechFeedback('');
    setStatus('idle');
    setMascotPose('pointing');
  };

  return (
    <div className="min-h-screen bg-[#ffffff] dark:bg-[#131f24] flex flex-col justify-between pb-32 transition-colors select-none font-bubble">
      <HeaderZone
        currentStep={currentIdx + 1}
        totalSteps={SPEAK_QUESTIONS.length}
        stars={currentStars}
        onClose={onExit}
        title="Speak & Record"
        onOpenSubscribe={onOpenSubscribe}
      />

      <div className="max-w-2xl mx-auto flex-1 flex flex-col justify-center px-4 w-full">
        {/* Gigi Speech Bubble with Audio */}
        <MascotSpeechBubble
          pose={mascotPose}
          speechText={q.question}
          onSpeakerClick={() => speakText(q.question)}
        />

        {/* Recording Studio Card (NO SPOILERS UPFRONT!) */}
        <div className="my-6 p-6 sm:p-8 bg-white dark:bg-[#1f2c34] border-2 border-slate-200 dark:border-[#37464f] border-b-6 rounded-3xl shadow-sm text-center flex flex-col items-center">

          {/* Microphone Big Button */}
          <div className="my-3 relative">
            {isRecording && (
              <div className="absolute inset-0 rounded-full bg-rose-500 animate-ping opacity-60"></div>
            )}
            <button
              onClick={isRecording ? stopRecording : startRecording}
              className={`relative z-10 w-28 h-28 rounded-full border-4 border-b-8 flex flex-col items-center justify-center transition-all shadow-lg active:translate-y-1 ${
                isRecording
                  ? 'bg-rose-500 border-rose-600 text-white animate-pulse'
                  : status === 'correct'
                  ? 'bg-[#58cc02] border-[#46a302] text-white'
                  : status === 'incorrect'
                  ? 'bg-rose-500 border-rose-600 text-white'
                  : 'bg-[#1cb0f6] hover:bg-sky-400 border-[#0f8fd4] text-white'
              }`}
            >
              {isRecording ? (
                <>
                  <Square className="w-10 h-10 fill-current" />
                  <span className="text-[11px] font-black mt-1">STOP</span>
                </>
              ) : (
                <>
                  <Mic className="w-10 h-10" />
                  <span className="text-[11px] font-black mt-1">
                    {hasRecorded ? 'REC AGAIN' : 'TAP TO TALK'}
                  </span>
                </>
              )}
            </button>
          </div>

          {/* Status Message */}
          <p className="font-black text-base sm:text-lg text-slate-800 dark:text-white mt-2">
            {isRecording
              ? '🎙️ Listening... Answer Gigi in English!'
              : liveHeard
              ? `Heard: "${liveHeard}"`
              : 'Press the microphone and answer out loud!'}
          </p>

          {/* Feedback banner (Only after speaking, showing real recognition results) */}
          {speechFeedback && (
            <div className={`mt-4 p-3.5 rounded-2xl flex items-center gap-2.5 text-xs font-black max-w-md ${
              status === 'correct'
                ? 'bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-300 dark:border-emerald-700 text-emerald-800 dark:text-emerald-200'
                : 'bg-rose-50 dark:bg-rose-950/40 border border-rose-300 dark:border-rose-700 text-rose-800 dark:text-rose-200'
            }`}>
              {status === 'correct' ? (
                <CheckCircle2 className="w-5 h-5 text-[#58cc02] shrink-0" />
              ) : (
                <AlertCircle className="w-5 h-5 text-rose-500 shrink-0" />
              )}
              <p className="text-left leading-relaxed">{speechFeedback}</p>
            </div>
          )}

          {/* Listen to your voice button */}
          {hasRecorded && audioUrl && (
            <button
              onClick={playRecordedAudio}
              disabled={isPlayingBack}
              className="mt-4 flex items-center gap-2 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 border-2 border-slate-300 dark:border-slate-600 border-b-4 rounded-xl px-5 py-2 font-black text-xs transition-all"
            >
              <Play className="w-4 h-4 fill-current" />
              <span>{isPlayingBack ? 'Playing Back...' : 'Listen to Your Voice'}</span>
            </button>
          )}
        </div>
      </div>

      <BottomActionDrawer
        status={status}
        onCheck={() => {}}
        onContinue={handleContinue}
        onTryAgain={handleTryAgain}
        checkLabel="CHECK"
        encouragement="Terrific pronunciation! Gigi loved hearing your answer!"
        hint="Speak loudly and clearly in English into your microphone."
      />

      {isCompleted && (
        <CompletionModal
          starsEarned={wrongAttempts === 0 ? 3 : wrongAttempts <= 2 ? 2 : 1}
          hasMistake={wrongAttempts > 0}
          activityTitle="Speak & Record: Family & Friends"
          paradeWords={SPEAK_QUESTIONS.map(q => q.helpfulHint.replace('Say: ', '').replace(/"/g, ''))}
          onNextActivity={onNext}
          onBackToMap={onExit}
        />
      )}
    </div>
  );
}
