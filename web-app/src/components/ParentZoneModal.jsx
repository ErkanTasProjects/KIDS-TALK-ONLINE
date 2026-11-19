import React, { useState, useEffect, useRef } from 'react';
import {
  X,
  Lock,
  Printer,
  Award,
  BarChart3,
  CheckCircle2,
  Star,
  BookOpen,
  Calendar,
  Sparkles,
  Crown,
  Clock,
  Mic,
  Play,
  Pause,
  Timer,
  Moon,
  FileText,
  Volume2,
  Trash2,
  Eye
} from 'lucide-react';
import { usePremium } from '../context/PremiumContext';
import { sfx } from '../utils/audio';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { WorksheetModal } from './WorksheetModal';
import { BedtimeModal } from './BedtimeModal';

export function ParentZoneModal({
  isOpen,
  onClose,
  stars = 0,
  completedActivityIds = [],
  onOpenSubscribe
}) {
  const { isVip } = usePremium();
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [mathAnswer, setMathAnswer] = useState('');
  const [errorMsg, setErrorMsg] = useState(false);
  const [childName, setChildName] = useState(() => {
    try { return localStorage.getItem('kids_talk_child_name') || 'Alex'; } catch { return 'Alex'; }
  });
  const [showCertificate, setShowCertificate] = useState(false);
  const [activeSection, setActiveSection] = useState('stats');

  // Screen Time Limiter state
  const [timeLimit, setTimeLimit] = useState(() => {
    try { return localStorage.getItem('kids_talk_time_limit') || 'unlimited'; } catch { return 'unlimited'; }
  });

  // Worksheet modal
  const [showWorksheet, setShowWorksheet] = useState(false);

  // Bedtime preview
  const [showBedtime, setShowBedtime] = useState(false);

  // Voice clips
  const [voiceClips, setVoiceClips] = useState(() => {
    try {
      const saved = localStorage.getItem('kids_talk_voice_clips');
      return saved ? JSON.parse(saved) : [];
    } catch { return []; }
  });
  const [playingClipId, setPlayingClipId] = useState(null);
  const audioRef = useRef(null);

  // Security gate
  const n1 = 8;
  const n2 = 6;
  const expected = 14;

  if (!isOpen) return null;

  // Save time limit
  const handleSetTimeLimit = (val) => {
    setTimeLimit(val);
    try { localStorage.setItem('kids_talk_time_limit', val); } catch {}
  };

  // Save child name
  const handleSetChildName = (name) => {
    setChildName(name);
    try { localStorage.setItem('kids_talk_child_name', name); } catch {}
  };

  const handleVerify = (e) => {
    e.preventDefault();
    if (parseInt(mathAnswer.trim(), 10) === expected) {
      sfx.playSuccess?.();
      setIsAuthenticated(true);
      setErrorMsg(false);
    } else {
      sfx.playError?.();
      setErrorMsg(true);
    }
  };

  const handlePrint = () => {
    sfx.playTap();
    window.print();
  };

  // Voice clip playback
  const handlePlayClip = (clip) => {
    if (playingClipId === clip.id) {
      if (audioRef.current) audioRef.current.pause();
      setPlayingClipId(null);
      return;
    }
    if (audioRef.current) audioRef.current.pause();
    const audio = new Audio(clip.audioUrl);
    audioRef.current = audio;
    setPlayingClipId(clip.id);
    audio.onended = () => setPlayingClipId(null);
    audio.play().catch(() => setPlayingClipId(null));
  };

  const handleDeleteClip = (clipId) => {
    const updated = voiceClips.filter(c => c.id !== clipId);
    setVoiceClips(updated);
    try { localStorage.setItem('kids_talk_voice_clips', JSON.stringify(updated)); } catch {}
  };

  const sections = [
    { id: 'stats', label: 'Stats', icon: <BarChart3 className="w-4 h-4" /> },
    { id: 'time', label: 'Screen Time', icon: <Clock className="w-4 h-4" /> },
    { id: 'voice', label: 'Voice Clips', icon: <Mic className="w-4 h-4" /> },
    { id: 'cert', label: 'Certificate', icon: <Award className="w-4 h-4" /> },
  ];

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-4 bg-slate-900/80 backdrop-blur-md animate-fade-in font-bubble select-none overflow-y-auto">
      <div className="relative w-full max-w-xl bg-white dark:bg-[#1f2c34] rounded-3xl border-4 border-slate-200 dark:border-[#37464f] shadow-2xl overflow-hidden flex flex-col max-h-[92vh] my-auto text-slate-800 dark:text-slate-100">
        {/* Header */}
        <div className="p-4 sm:p-5 border-b border-slate-200 dark:border-[#37464f] flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-sky-100 dark:bg-sky-950/40 text-[#1cb0f6] flex items-center justify-center text-xl shadow-xs">
              👨‍👩‍👧
            </div>
            <div>
              <h3 className="text-lg font-black text-slate-800 dark:text-white leading-tight">
                Parent &amp; Educator Zone
              </h3>
              <p className="text-xs font-bold text-slate-400">
                Track progress, manage screen time & print materials
              </p>
            </div>
          </div>
          <button
            onClick={() => { sfx.playTap(); onClose(); }}
            className="p-2 rounded-full text-slate-400 hover:text-slate-600 dark:hover:text-white"
          >
            <X className="w-6 h-6 stroke-[2.5]" />
          </button>
        </div>

        {/* Security Gate */}
        {!isAuthenticated ? (
          <div className="p-6 sm:p-8 flex flex-col items-center text-center space-y-4">
            <div className="w-16 h-16 rounded-full bg-amber-100 dark:bg-amber-950/50 text-amber-500 flex items-center justify-center text-2xl shadow-inner">
              <Lock className="w-8 h-8" />
            </div>
            <div className="max-w-xs">
              <h4 className="text-xl font-black">Parent Security Check</h4>
              <p className="text-xs font-bold text-slate-500 dark:text-slate-400 mt-1">
                Please solve this quick math problem to access parent settings:
              </p>
            </div>
            <form onSubmit={handleVerify} className="w-full max-w-xs space-y-3">
              <div className="p-4 rounded-2xl bg-slate-100 dark:bg-slate-800 border text-center">
                <span className="text-xl font-black tracking-widest">
                  {n1} + {n2} = ?
                </span>
              </div>
              <input
                type="number"
                value={mathAnswer}
                onChange={(e) => setMathAnswer(e.target.value)}
                placeholder="Enter answer"
                autoFocus
                className="w-full px-4 py-3 rounded-2xl border-2 border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-center font-black text-lg focus:outline-none focus:ring-2 focus:ring-[#58cc02]"
              />
              <button
                type="submit"
                className="w-full py-3.5 rounded-2xl duo-btn-green font-black text-sm uppercase tracking-wider"
              >
                Access Dashboard
              </button>
              {errorMsg && (
                <p className="text-xs font-bold text-rose-500">
                  Incorrect! Try again.
                </p>
              )}
            </form>
          </div>
        ) : (
          /* Parent Dashboard Content */
          <>
            {/* Tab Navigation */}
            <div className="flex border-b border-slate-200 dark:border-[#37464f] px-3 overflow-x-auto">
              {sections.map(s => (
                <button
                  key={s.id}
                  onClick={() => { sfx.playTap(); setActiveSection(s.id); }}
                  className={`flex items-center gap-1.5 px-3 py-3 text-xs font-black uppercase tracking-wider border-b-3 transition-colors whitespace-nowrap ${
                    activeSection === s.id
                      ? 'border-[#1cb0f6] text-[#1cb0f6]'
                      : 'border-transparent text-slate-400 hover:text-slate-600 dark:hover:text-slate-300'
                  }`}
                >
                  {s.icon}
                  <span>{s.label}</span>
                </button>
              ))}
            </div>

            <div className="p-5 overflow-y-auto space-y-5 flex-1">

              {/* ═══ STATS SECTION ═══ */}
              {activeSection === 'stats' && (
                <>
                  {/* Quick Stats Grid */}
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                    <div className="p-3.5 rounded-2xl bg-amber-50 dark:bg-slate-800 border border-amber-200 dark:border-slate-700 text-center">
                      <p className="text-[11px] font-bold text-slate-400">Total Stars</p>
                      <p className="text-2xl font-black text-amber-500 mt-0.5">{stars}</p>
                    </div>
                    <div className="p-3.5 rounded-2xl bg-emerald-50 dark:bg-slate-800 border border-emerald-200 dark:border-slate-700 text-center">
                      <p className="text-[11px] font-bold text-slate-400">Lessons Done</p>
                      <p className="text-2xl font-black text-emerald-500 mt-0.5">
                        {completedActivityIds.length} / 11
                      </p>
                    </div>
                    <div className="p-3.5 rounded-2xl bg-sky-50 dark:bg-slate-800 border border-sky-200 dark:border-slate-700 text-center">
                      <p className="text-[11px] font-bold text-slate-400">Words Practiced</p>
                      <p className="text-2xl font-black text-sky-500 mt-0.5">
                        {completedActivityIds.length * 6 + 12}
                      </p>
                    </div>
                    <div className="p-3.5 rounded-2xl bg-purple-50 dark:bg-slate-800 border border-purple-200 dark:border-slate-700 text-center">
                      <p className="text-[11px] font-bold text-slate-400">Accuracy Rate</p>
                      <p className="text-2xl font-black text-purple-500 mt-0.5">
                        {completedActivityIds.length > 0 ? Math.round(90 + (stars / Math.max(completedActivityIds.length, 1))) + '%' : '—'}
                      </p>
                    </div>
                  </div>

                  {/* Curriculum Progression */}
                  <div className="p-4 rounded-2xl border-2 border-slate-200 dark:border-[#37464f] space-y-3">
                    <h4 className="text-xs font-black uppercase text-slate-400 tracking-wider">
                      Curriculum Progression
                    </h4>
                    <div>
                      <div className="flex justify-between text-xs font-black mb-1">
                        <span>Starter (Ages 4-6)</span>
                        <span className="text-[#58cc02]">Free Access</span>
                      </div>
                      <div className="w-full h-2.5 rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden">
                        <div className="h-full bg-[#58cc02] rounded-full transition-all" style={{ width: `${Math.min(100, completedActivityIds.length * 15)}%` }} />
                      </div>
                    </div>
                    <div>
                      <div className="flex justify-between text-xs font-black mb-1">
                        <span>Movers (Ages 6-8)</span>
                        <span className={isVip ? 'text-[#1cb0f6]' : 'text-amber-500'}>
                          {isVip ? 'VIP Active' : 'VIP Locked'}
                        </span>
                      </div>
                      <div className="w-full h-2.5 rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden">
                        <div className={`h-full rounded-full ${isVip ? 'bg-[#1cb0f6]' : 'bg-amber-400 opacity-60'}`} style={{ width: isVip ? '50%' : '0%' }} />
                      </div>
                    </div>
                    <div>
                      <div className="flex justify-between text-xs font-black mb-1">
                        <span>Flyers (Ages 8-10)</span>
                        <span className={isVip ? 'text-[#ce82ff]' : 'text-amber-500'}>
                          {isVip ? 'VIP Active' : 'VIP Locked'}
                        </span>
                      </div>
                      <div className="w-full h-2.5 rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden">
                        <div className={`h-full rounded-full ${isVip ? 'bg-[#ce82ff]' : 'bg-purple-400 opacity-60'}`} style={{ width: isVip ? '25%' : '0%' }} />
                      </div>
                    </div>
                  </div>

                  {/* Print Worksheet Shortcut */}
                  <button
                    onClick={() => { sfx.playTap(); setShowWorksheet(true); }}
                    className="w-full p-4 rounded-2xl border-2 border-sky-200 dark:border-sky-800 bg-sky-50 dark:bg-sky-950/40 flex items-center gap-3 active:scale-[0.98] transition-transform"
                  >
                    <div className="w-10 h-10 rounded-2xl bg-sky-500 text-white flex items-center justify-center shadow-xs shrink-0">
                      <FileText className="w-5 h-5" />
                    </div>
                    <div className="text-left flex-1">
                      <h4 className="text-sm font-black text-slate-800 dark:text-white">Print Weekly Worksheet</h4>
                      <p className="text-[11px] font-bold text-slate-400">Letter tracing, vocabulary matching & fill-in exercises</p>
                    </div>
                    <Printer className="w-5 h-5 text-sky-500 shrink-0" />
                  </button>
                </>
              )}

              {/* ═══ SCREEN TIME SECTION ═══ */}
              {activeSection === 'time' && (
                <>
                  <div className="p-4 rounded-2xl border-2 border-slate-200 dark:border-[#37464f] space-y-4">
                    <div className="flex items-center gap-2.5">
                      <div className="w-10 h-10 rounded-2xl bg-indigo-100 dark:bg-indigo-950/40 text-indigo-500 flex items-center justify-center">
                        <Timer className="w-5 h-5" />
                      </div>
                      <div>
                        <h4 className="text-sm font-black">Daily Screen Time Limit</h4>
                        <p className="text-[11px] font-bold text-slate-400">
                          Set a healthy daily limit for your child's learning sessions
                        </p>
                      </div>
                    </div>

                    <div className="grid grid-cols-3 gap-2">
                      {[
                        { val: '15', label: '15 min', emoji: '⏱️' },
                        { val: '30', label: '30 min', emoji: '🕐' },
                        { val: 'unlimited', label: 'Unlimited', emoji: '♾️' },
                      ].map(opt => (
                        <button
                          key={opt.val}
                          onClick={() => { sfx.playTap(); handleSetTimeLimit(opt.val); }}
                          className={`p-3 rounded-2xl border-2 border-b-4 text-center transition-all active:scale-95 ${
                            timeLimit === opt.val
                              ? 'border-[#58cc02] bg-emerald-50 dark:bg-emerald-950/40 ring-2 ring-[#58cc02]/30'
                              : 'border-slate-200 dark:border-[#37464f] bg-white dark:bg-[#233138]'
                          }`}
                        >
                          <div className="text-2xl mb-1">{opt.emoji}</div>
                          <span className="text-xs font-black">{opt.label}</span>
                          {timeLimit === opt.val && (
                            <div className="mt-1">
                              <CheckCircle2 className="w-4 h-4 text-[#58cc02] mx-auto" />
                            </div>
                          )}
                        </button>
                      ))}
                    </div>

                    {timeLimit !== 'unlimited' && (
                      <p className="text-xs font-bold text-indigo-600 dark:text-indigo-300 bg-indigo-50 dark:bg-indigo-950/40 p-3 rounded-xl border border-indigo-200 dark:border-indigo-800 text-center">
                        ⏰ Gigi will gently remind your child to take a break after {timeLimit} minutes of play!
                      </p>
                    )}
                  </div>

                  {/* Bedtime Mode Preview */}
                  <div className="p-4 rounded-2xl border-2 border-indigo-200 dark:border-indigo-800 bg-gradient-to-r from-indigo-50 to-purple-50 dark:from-indigo-950/40 dark:to-purple-950/40 space-y-3">
                    <div className="flex items-center gap-2">
                      <Moon className="w-5 h-5 text-indigo-500" />
                      <h4 className="text-sm font-black">Gigi Bedtime Mode</h4>
                    </div>
                    <p className="text-xs font-bold text-slate-500 dark:text-slate-400">
                      When time's up, Gigi wears a nightcap and gently tells your child it's rest time. No abrupt interruptions!
                    </p>
                    <button
                      onClick={() => { sfx.playTap(); setShowBedtime(true); }}
                      className="w-full py-3 rounded-2xl duo-btn-blue font-black text-xs uppercase flex items-center justify-center gap-2"
                    >
                      <Eye className="w-4 h-4" />
                      <span>Preview Bedtime Mode</span>
                    </button>
                  </div>
                </>
              )}

              {/* ═══ VOICE CLIPS SECTION ═══ */}
              {activeSection === 'voice' && (
                <>
                  <div className="flex items-center gap-2.5 mb-2">
                    <div className="w-10 h-10 rounded-2xl bg-rose-100 dark:bg-rose-950/40 text-rose-500 flex items-center justify-center">
                      <Mic className="w-5 h-5" />
                    </div>
                    <div>
                      <h4 className="text-sm font-black">My Child's Voice Clips</h4>
                      <p className="text-[11px] font-bold text-slate-400">
                        Recordings from Speak & Record activities
                      </p>
                    </div>
                  </div>

                  {voiceClips.length === 0 ? (
                    <div className="p-8 rounded-2xl border-2 border-dashed border-slate-300 dark:border-[#37464f] text-center space-y-3">
                      <div className="text-5xl">🎤</div>
                      <h4 className="text-sm font-black text-slate-500">No Voice Clips Yet</h4>
                      <p className="text-xs font-bold text-slate-400">
                        When your child completes the "Speak & Record" activity, their voice recordings will appear here automatically!
                      </p>
                    </div>
                  ) : (
                    <div className="space-y-2">
                      {voiceClips.map(clip => (
                        <div
                          key={clip.id}
                          className={`p-3.5 rounded-2xl border-2 flex items-center gap-3 transition-all ${
                            playingClipId === clip.id
                              ? 'border-[#58cc02] bg-emerald-50 dark:bg-emerald-950/40'
                              : 'border-slate-200 dark:border-[#37464f] bg-white dark:bg-[#233138]'
                          }`}
                        >
                          {/* Play/Pause button */}
                          <button
                            onClick={() => handlePlayClip(clip)}
                            className={`w-10 h-10 rounded-full flex items-center justify-center shrink-0 shadow-xs transition-all ${
                              playingClipId === clip.id
                                ? 'bg-[#58cc02] text-white'
                                : 'bg-sky-500 text-white'
                            }`}
                          >
                            {playingClipId === clip.id ? (
                              <Pause className="w-5 h-5 fill-current" />
                            ) : (
                              <Play className="w-5 h-5 fill-current" />
                            )}
                          </button>

                          <div className="flex-1 min-w-0">
                            <p className="text-xs font-black text-slate-800 dark:text-white truncate">
                              Q: "{clip.question}"
                            </p>
                            <p className="text-[11px] font-bold text-slate-400 truncate">
                              A: "{clip.transcript}"
                            </p>
                            <p className="text-[10px] font-bold text-slate-300 mt-0.5">
                              {new Date(clip.timestamp).toLocaleDateString('en-US', {
                                month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit'
                              })}
                            </p>
                          </div>

                          {/* Delete button */}
                          <button
                            onClick={() => handleDeleteClip(clip.id)}
                            className="w-8 h-8 rounded-full bg-slate-100 dark:bg-slate-700 text-slate-400 hover:text-rose-500 flex items-center justify-center shrink-0 transition-colors"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      ))}
                    </div>
                  )}
                </>
              )}

              {/* ═══ CERTIFICATE SECTION ═══ */}
              {activeSection === 'cert' && (
                <div className="p-4 rounded-2xl border-2 border-amber-300 dark:border-amber-700/60 bg-gradient-to-r from-amber-50/70 to-yellow-50/70 dark:from-[#233138] dark:to-[#1f2c34] space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <Award className="w-5 h-5 text-amber-500" />
                      <h4 className="text-sm font-black text-slate-900 dark:text-white">
                        Official English Explorer Certificate
                      </h4>
                    </div>
                    {!isVip && (
                      <span className="px-2 py-0.5 rounded-md bg-amber-400 text-amber-950 text-[10px] font-black uppercase flex items-center gap-1">
                        <Crown className="w-3 h-3 fill-current" /> VIP
                      </span>
                    )}
                  </div>

                  <p className="text-xs font-bold text-slate-500 dark:text-slate-400">
                    Generate a personalized, printable diploma celebrating your child's speaking achievements!
                  </p>

                  {isVip ? (
                    <div className="space-y-3">
                      <div className="flex gap-2">
                        <input
                          type="text"
                          value={childName}
                          onChange={(e) => handleSetChildName(e.target.value)}
                          placeholder="Child's Full Name"
                          className="flex-1 px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-sm font-black focus:outline-none"
                        />
                        <button
                          onClick={() => setShowCertificate(v => !v)}
                          className="px-4 py-2 rounded-xl duo-btn-blue font-black text-xs uppercase"
                        >
                          {showCertificate ? 'Hide' : 'Preview'}
                        </button>
                      </div>

                      {showCertificate && (
                        <div id="printable-certificate" className="p-6 rounded-2xl border-4 border-amber-400 bg-amber-50 text-slate-900 text-center space-y-2 shadow-inner">
                          <div className="flex justify-center gap-2 text-3xl">🏆🦒🏆</div>
                          <h2 className="text-xl font-black uppercase tracking-widest text-amber-800">
                            Certificate of Achievement
                          </h2>
                          <p className="text-[10px] font-bold text-slate-500">Kids Talk Online • English Explorer Program</p>
                          <p className="text-xs font-bold text-slate-600">This certifies that</p>
                          <h3 className="text-2xl font-black text-slate-900 border-b-2 border-amber-300 pb-1 max-w-xs mx-auto">
                            {childName || 'Young Explorer'}
                          </h3>
                          <p className="text-xs font-bold text-slate-600 max-w-xs mx-auto">
                            has successfully completed English speaking and listening activities with Gigi the Giraffe on Kids Talk Online!
                          </p>
                          <div className="flex items-center justify-around pt-3 border-t border-amber-200 text-xs font-black text-amber-900">
                            <span>⭐ {stars} Stars Earned</span>
                            <span>📚 {completedActivityIds.length} Lessons</span>
                            <span>Official Gigi Stamp 🦒</span>
                          </div>
                          <button
                            onClick={handlePrint}
                            className="mt-3 px-5 py-2 rounded-xl bg-amber-500 hover:bg-amber-600 text-white font-black text-xs uppercase flex items-center justify-center gap-1.5 mx-auto shadow"
                          >
                            <Printer className="w-4 h-4" />
                            <span>Print Diploma</span>
                          </button>
                        </div>
                      )}
                    </div>
                  ) : (
                    <button
                      onClick={() => { sfx.playTap(); onOpenSubscribe(); }}
                      className="w-full py-3 rounded-xl duo-btn-green font-black text-xs uppercase flex items-center justify-center gap-1.5"
                    >
                      <Sparkles className="w-4 h-4 fill-white" />
                      <span>Unlock Certificate with VIP</span>
                    </button>
                  )}
                </div>
              )}
            </div>
          </>
        )}
      </div>

      {/* Worksheet Modal */}
      <WorksheetModal isOpen={showWorksheet} onClose={() => setShowWorksheet(false)} />

      {/* Bedtime Mode Preview */}
      <BedtimeModal isOpen={showBedtime} onClose={() => setShowBedtime(false)} starsToday={stars} />
    </div>
  );
}
