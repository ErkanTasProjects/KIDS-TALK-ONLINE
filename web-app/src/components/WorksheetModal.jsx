import React from 'react';
import { X, Printer } from 'lucide-react';
import { useTheme } from '../context/ThemeContext';
import { MASCOT_IMAGES } from '../data/mascotImages';
import { sfx } from '../utils/audio';

const WorksheetModal = ({ isOpen, onClose }) => {
  const { isDark } = useTheme();

  if (!isOpen) return null;

  const today = new Date();
  const weekStart = new Date(today);
  weekStart.setDate(today.getDate() - today.getDay());
  const weekEnd = new Date(weekStart);
  weekEnd.setDate(weekStart.getDate() + 6);
  const fmt = (d) => d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
  const weekLabel = `${fmt(weekStart)} – ${fmt(weekEnd)}`;

  const letterPairs = [
    { upper: 'M', lower: 'm' },
    { upper: 'F', lower: 'f' },
    { upper: 'B', lower: 'b' },
    { upper: 'S', lower: 's' },
    { upper: 'G', lower: 'g' },
  ];

  const vocabWords = [
    { word: 'Cat', emoji: '🐱' },
    { word: 'Dog', emoji: '🐶' },
    { word: 'Sun', emoji: '☀️' },
    { word: 'Apple', emoji: '🍎' },
    { word: 'Book', emoji: '📖' },
  ];

  // Scrambled order for matching
  const scrambledEmojis = ['📖', '☀️', '🐱', '🍎', '🐶'];

  const fillWords = [
    { display: '_at', hint: 'Cat' },
    { display: '_og', hint: 'Dog' },
    { display: 'Su_', hint: 'Sun' },
    { display: '_pple', hint: 'Apple' },
    { display: 'Boo_', hint: 'Book' },
  ];

  const handlePrint = () => {
    sfx.playTap?.();
    window.print();
  };

  const handleClose = () => {
    sfx.playTap?.();
    onClose();
  };

  return (
    <>
      {/* Print-only styles */}
      <style>{`
        @media print {
          body * {
            visibility: hidden !important;
          }
          #printable-worksheet,
          #printable-worksheet * {
            visibility: visible !important;
          }
          #printable-worksheet {
            position: fixed !important;
            left: 0 !important;
            top: 0 !important;
            width: 210mm !important;
            min-height: 297mm !important;
            margin: 0 !important;
            padding: 12mm 16mm !important;
            background: white !important;
            color: black !important;
            font-family: 'Georgia', 'Times New Roman', serif !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
            overflow: visible !important;
            box-shadow: none !important;
            border-radius: 0 !important;
          }
          #printable-worksheet img {
            filter: grayscale(100%) !important;
            max-width: 60px !important;
          }
          @page {
            size: A4 portrait;
            margin: 0;
          }
        }
      `}</style>

      {/* Modal Overlay */}
      <div
        className="fixed inset-0 z-50 flex items-start justify-center bg-black/60 backdrop-blur-sm overflow-y-auto p-4"
        onClick={handleClose}
      >
        <div
          className={`relative w-full max-w-2xl my-4 rounded-2xl shadow-2xl ${
            isDark ? 'bg-[#1a2a32] text-white' : 'bg-slate-100 text-slate-800'
          }`}
          onClick={(e) => e.stopPropagation()}
        >
          {/* Modal Header */}
          <div className="flex items-center justify-between p-4 border-b border-slate-300/30">
            <h2 className="text-xl md:text-2xl font-bold font-bubble flex items-center gap-2">
              📝 Weekly Practice Worksheet
            </h2>
            <button
              onClick={handleClose}
              className={`p-2 rounded-full transition-colors ${
                isDark ? 'hover:bg-white/10' : 'hover:bg-slate-200'
              }`}
            >
              <X size={22} />
            </button>
          </div>

          {/* Print Button */}
          <div className="flex justify-center p-4 pb-2">
            <button
              onClick={handlePrint}
              className="duo-btn-green px-6 py-3 rounded-xl text-lg font-bold font-bubble flex items-center gap-2 border-b-4 border-green-700 bg-[#58cc02] text-white hover:bg-[#4db801] active:border-b-0 active:mt-1 transition-all"
            >
              <Printer size={20} />
              Print Worksheet 🖨️
            </button>
          </div>

          {/* Worksheet Preview Container */}
          <div className="p-4 pt-2 overflow-y-auto max-h-[70vh]">
            <div
              id="printable-worksheet"
              className="bg-white text-black rounded-xl shadow-lg p-6 md:p-8"
              style={{ fontFamily: "'Georgia', 'Times New Roman', serif" }}
            >
              {/* Worksheet Header */}
              <div className="flex items-center gap-3 mb-1 pb-3 border-b-2 border-slate-300">
                <img
                  src={MASCOT_IMAGES?.waving || '/mascot/gigi-waving.png'}
                  alt="Gigi the Giraffe"
                  className="w-14 h-14 object-contain"
                />
                <div className="flex-1">
                  <h1 className="text-2xl md:text-3xl font-bold text-slate-800" style={{ fontFamily: "'Georgia', serif" }}>
                    Kids Talk Online
                  </h1>
                  <p className="text-sm text-slate-500">Weekly Practice Worksheet • {weekLabel}</p>
                </div>
                <div className="text-right">
                  <p className="text-xs text-slate-400">Name:</p>
                  <div className="border-b-2 border-dashed border-slate-400 w-32 mt-1" />
                </div>
              </div>

              {/* ═══ SECTION 1: Letter Tracing ═══ */}
              <div className="mt-6">
                <h2 className="text-xl font-bold text-slate-700 mb-4 flex items-center gap-2">
                  <span className="bg-amber-100 text-amber-700 rounded-lg px-2 py-0.5 text-sm font-bold">1</span>
                  ✏️ Trace the Letters
                </h2>
                <div className="grid grid-cols-5 gap-3">
                  {letterPairs.map((pair, i) => (
                    <div key={i} className="flex flex-col items-center">
                      <div className="border-dashed border-2 border-slate-400 rounded-xl w-full aspect-square flex items-center justify-center">
                        <span
                          className="text-3xl md:text-4xl font-bold text-slate-300 select-none"
                          style={{
                            WebkitTextStroke: '1.5px #94a3b8',
                            color: 'transparent',
                            letterSpacing: '4px',
                          }}
                        >
                          {pair.upper} {pair.lower}
                        </span>
                      </div>
                      <p className="text-xs text-slate-400 mt-2 tracking-[4px] select-none">
                        _ _ _ _ _ _ _
                      </p>
                    </div>
                  ))}
                </div>
              </div>

              {/* ═══ SECTION 2: Vocabulary Matching ═══ */}
              <div className="mt-8">
                <h2 className="text-xl font-bold text-slate-700 mb-4 flex items-center gap-2">
                  <span className="bg-blue-100 text-blue-700 rounded-lg px-2 py-0.5 text-sm font-bold">2</span>
                  🔗 Match the Words to Pictures
                </h2>
                <p className="text-xs text-slate-400 mb-3 italic">Draw a line from each word to the correct picture.</p>
                <div className="flex justify-between items-start px-2 md:px-6">
                  {/* Left column: Words */}
                  <div className="flex flex-col gap-5">
                    {vocabWords.map((item, i) => (
                      <div
                        key={i}
                        className="flex items-center gap-2 border border-slate-300 rounded-lg px-3 py-1.5 bg-slate-50"
                      >
                        <span className="text-xs text-slate-400 font-bold">{i + 1}.</span>
                        <span className="text-base font-bold text-slate-700">{item.word}</span>
                      </div>
                    ))}
                  </div>

                  {/* Middle: Dotted connection lines */}
                  <div className="flex-1 flex flex-col gap-5 mx-2 md:mx-4 pt-2">
                    {vocabWords.map((_, i) => (
                      <div
                        key={i}
                        className="border-b-2 border-dashed border-slate-300 h-6"
                      />
                    ))}
                  </div>

                  {/* Right column: Scrambled emojis */}
                  <div className="flex flex-col gap-5">
                    {scrambledEmojis.map((emoji, i) => (
                      <div
                        key={i}
                        className="flex items-center justify-center border border-slate-300 rounded-lg px-3 py-1.5 bg-slate-50"
                      >
                        <span className="text-2xl">{emoji}</span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>

              {/* ═══ SECTION 3: Fill in the Missing Letter ═══ */}
              <div className="mt-8">
                <h2 className="text-xl font-bold text-slate-700 mb-4 flex items-center gap-2">
                  <span className="bg-green-100 text-green-700 rounded-lg px-2 py-0.5 text-sm font-bold">3</span>
                  🔤 Complete the Word
                </h2>
                <p className="text-xs text-slate-400 mb-3 italic">Fill in the missing letter to complete each word.</p>
                <div className="grid grid-cols-1 sm:grid-cols-5 gap-3">
                  {fillWords.map((item, i) => (
                    <div
                      key={i}
                      className="flex flex-col items-center border border-slate-200 rounded-xl p-3 bg-slate-50"
                    >
                      <span className="text-2xl md:text-3xl font-bold text-slate-700 tracking-wider">
                        {item.display.split('').map((char, ci) => (
                          <span
                            key={ci}
                            className={
                              char === '_'
                                ? 'inline-block w-7 md:w-8 border-b-2 border-dashed border-slate-400 text-center mx-0.5'
                                : ''
                            }
                          >
                            {char === '_' ? '\u00A0' : char}
                          </span>
                        ))}
                      </span>
                      <span className="text-xs text-slate-400 mt-2">({item.hint})</span>
                    </div>
                  ))}
                </div>
              </div>

              {/* ═══ BONUS: Star Rating ═══ */}
              <div className="mt-8 border-t-2 border-dashed border-slate-200 pt-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm font-bold text-slate-600">⭐ How did I do today?</p>
                    <div className="flex gap-1 mt-1 text-2xl text-slate-300">
                      {['⭐', '⭐', '⭐', '⭐', '⭐'].map((star, i) => (
                        <span key={i} className="opacity-30 select-none">{star}</span>
                      ))}
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-xs text-slate-400">Teacher / Parent signature:</p>
                    <div className="border-b-2 border-dashed border-slate-400 w-36 mt-2" />
                  </div>
                </div>
              </div>

              {/* ═══ Footer ═══ */}
              <div className="mt-6 pt-3 border-t border-slate-200 text-center">
                <p className="text-xs text-slate-400">
                  Kids Talk Online • Practice with Gigi 🦒 • kidstalk.online
                </p>
                <p className="text-[10px] text-slate-300 mt-1">
                  Week of {weekLabel}
                </p>
              </div>
            </div>
          </div>

          {/* Modal Footer */}
          <div className="p-4 pt-2 flex justify-center gap-3 border-t border-slate-300/20">
            <button
              onClick={handleClose}
              className={`px-5 py-2.5 rounded-xl font-bold font-bubble text-sm border-b-4 transition-all active:border-b-0 active:mt-1 ${
                isDark
                  ? 'bg-slate-700 border-slate-800 text-slate-200 hover:bg-slate-600'
                  : 'bg-white border-slate-300 text-slate-600 hover:bg-slate-50'
              }`}
            >
              Close
            </button>
            <button
              onClick={handlePrint}
              className="px-5 py-2.5 rounded-xl font-bold font-bubble text-sm border-b-4 border-blue-700 bg-[#1cb0f6] text-white hover:bg-[#18a0e0] active:border-b-0 active:mt-1 transition-all flex items-center gap-2"
            >
              <Printer size={16} />
              Print
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export { WorksheetModal };
export default WorksheetModal;
