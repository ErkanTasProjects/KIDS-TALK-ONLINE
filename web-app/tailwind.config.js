/** @type {import('tailwindcss').Config} */
export default {
  darkMode: 'class',
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        bubble: ['"Fredoka"', '"Comic Neue"', 'sans-serif'],
      },
      colors: {
        // Kids Talk brand palette
        kt: {
          green:   '#58cc02',
          'green-dark': '#46a302',
          blue:    '#1cb0f6',
          'blue-dark': '#0a9fd8',
          purple:  '#ce82ff',
          red:     '#ff4b4b',
          orange:  '#ff9600',
          gold:    '#ffc800',
          pink:    '#ff86d0',
        },
        // Dark mode surface palette
        dark: {
          bg:      '#0f172a',  // slate-900ish deep
          surface: '#1e293b',  // slate-800
          card:    '#334155',  // slate-700
          border:  '#475569',  // slate-600
          text:    '#e2e8f0',  // slate-200
          muted:   '#94a3b8',  // slate-400
        }
      },
      boxShadow: {
        'chunky':    '0 6px 0 0 rgba(0,0,0,0.15)',
        'chunky-sm': '0 3px 0 0 rgba(0,0,0,0.12)',
        'chunky-lg': '0 8px 0 0 rgba(0,0,0,0.18)',
        'node-active': '0 0 0 6px rgba(88,204,2,0.3), 0 8px 0 0 rgba(70,163,2,1)',
        'node-done':   '0 8px 0 0 rgba(161,120,0,1)',
        'node-locked': '0 6px 0 0 rgba(100,116,139,1)',
        'glow-green': '0 0 20px rgba(88,204,2,0.5)',
        'glow-blue':  '0 0 20px rgba(28,176,246,0.5)',
      },
      animation: {
        'bounce-subtle':     'bounceSubtle 2s infinite',
        'wiggle':            'wiggle 0.5s ease-in-out',
        'float':             'float 3s ease-in-out infinite',
        'pop':               'pop 0.3s cubic-bezier(0.175,0.885,0.32,1.275)',
        'gigi-walk':         'gigiWalk 0.8s ease-in-out infinite alternate',
        'gigi-dance':        'gigiDance 1.2s ease-in-out infinite',
        'gigi-celebration':  'gigiCelebration 0.6s ease-in-out 3',
        'node-pulse':        'nodePulse 2s ease-in-out infinite',
        'star-pop':          'starPop 0.4s cubic-bezier(0.175,0.885,0.32,1.275) forwards',
        'slide-up':          'slideUp 0.5s cubic-bezier(0.16,1,0.3,1) forwards',
        'fade-in':           'fadeIn 0.3s ease forwards',
        'shake':             'shake 0.4s ease forwards',
        'spin-slow':         'spin 3s linear infinite',
      },
      keyframes: {
        bounceSubtle: {
          '0%,100%': { transform: 'translateY(0)' },
          '50%':     { transform: 'translateY(-6px)' },
        },
        wiggle: {
          '0%,100%': { transform: 'rotate(0deg)' },
          '25%':     { transform: 'rotate(-4deg)' },
          '75%':     { transform: 'rotate(4deg)' },
        },
        float: {
          '0%,100%': { transform: 'translateY(0)' },
          '50%':     { transform: 'translateY(-10px)' },
        },
        pop: {
          '0%':   { transform: 'scale(0.8)', opacity: '0' },
          '100%': { transform: 'scale(1)',   opacity: '1' },
        },
        gigiWalk: {
          '0%':   { transform: 'translateY(0) rotate(-3deg)' },
          '100%': { transform: 'translateY(-8px) rotate(3deg)' },
        },
        gigiDance: {
          '0%':   { transform: 'rotate(-8deg) translateY(0) scale(1)' },
          '25%':  { transform: 'rotate(8deg) translateY(-6px) scale(1.05)' },
          '50%':  { transform: 'rotate(-5deg) translateY(0) scale(1)' },
          '75%':  { transform: 'rotate(5deg) translateY(-4px) scale(1.03)' },
          '100%': { transform: 'rotate(-8deg) translateY(0) scale(1)' },
        },
        gigiCelebration: {
          '0%':   { transform: 'scale(1) rotate(0deg)' },
          '25%':  { transform: 'scale(1.2) rotate(-10deg)' },
          '50%':  { transform: 'scale(1.3) rotate(10deg)' },
          '75%':  { transform: 'scale(1.15) rotate(-5deg)' },
          '100%': { transform: 'scale(1) rotate(0deg)' },
        },
        nodePulse: {
          '0%,100%': { boxShadow: '0 0 0 0 rgba(88,204,2,0.5), 0 8px 0 0 rgba(70,163,2,1)' },
          '50%':     { boxShadow: '0 0 0 14px rgba(88,204,2,0), 0 8px 0 0 rgba(70,163,2,1)' },
        },
        starPop: {
          '0%':   { transform: 'scale(0) rotate(-30deg)', opacity: '0' },
          '60%':  { transform: 'scale(1.3) rotate(5deg)', opacity: '1' },
          '100%': { transform: 'scale(1) rotate(0deg)',   opacity: '1' },
        },
        slideUp: {
          from: { transform: 'translateY(24px)', opacity: '0' },
          to:   { transform: 'translateY(0)',    opacity: '1' },
        },
        fadeIn: {
          from: { opacity: '0' },
          to:   { opacity: '1' },
        },
        shake: {
          '0%,100%': { transform: 'translateX(0)' },
          '20%':     { transform: 'translateX(-8px)' },
          '40%':     { transform: 'translateX(8px)' },
          '60%':     { transform: 'translateX(-6px)' },
          '80%':     { transform: 'translateX(6px)' },
        },
      },
    },
  },
  plugins: [],
}
