import React from 'react';
import { Home, Shield, Award, Heart, User, Crown } from 'lucide-react';
import { sfx } from '../utils/audio';

export function BottomNavBar({ activeTab, onSelectTab, isDark }) {
  const tabs = [
    {
      id: 'learn',
      label: 'Learn',
      icon: (active) => (
        <div className={`w-7 h-7 flex items-center justify-center transition-transform ${active ? 'scale-110' : ''}`}>
          <Home className={`w-6 h-6 stroke-[2.5] ${active ? 'text-[#58cc02] fill-[#58cc02]' : 'text-slate-400'}`} />
        </div>
      ),
    },
    {
      id: 'quests',
      label: 'Quests',
      icon: (active) => (
        <div className={`w-7 h-7 flex items-center justify-center transition-transform ${active ? 'scale-110' : ''}`}>
          <span className="text-xl">🎁</span>
        </div>
      ),
    },
    {
      id: 'leagues',
      label: 'Leagues',
      icon: (active) => (
        <div className={`w-7 h-7 flex items-center justify-center transition-transform ${active ? 'scale-110' : ''}`}>
          <Shield className={`w-6 h-6 stroke-[2.5] ${active ? 'text-[#1cb0f6] fill-[#1cb0f6]' : 'text-slate-400'}`} />
        </div>
      ),
    },
    {
      id: 'vip',
      label: 'VIP Club',
      icon: (active) => (
        <div className={`w-7 h-7 flex items-center justify-center transition-transform ${active ? 'scale-110' : ''}`}>
          <Crown className={`w-6 h-6 stroke-[2.5] ${active ? 'text-amber-400 fill-amber-400 animate-bounce' : 'text-amber-400'}`} />
        </div>
      ),
    },
    {
      id: 'profile',
      label: 'Profile',
      icon: (active) => (
        <div className={`w-7 h-7 flex items-center justify-center transition-transform ${active ? 'scale-110' : ''}`}>
          <User className={`w-6 h-6 stroke-[2.5] ${active ? 'text-[#ce82ff] fill-[#ce82ff]' : 'text-slate-400'}`} />
        </div>
      ),
    },
  ];

  return (
    <nav className={`fixed bottom-0 left-0 right-0 z-40 safe-pb border-t-2 select-none transition-colors ${
      isDark
        ? 'bg-[#131f24] border-[#37464f]'
        : 'bg-white border-slate-200'
    }`}>
      <div className="max-w-md mx-auto flex items-center justify-around px-2 pt-2 pb-1">
        {tabs.map((tab) => {
          const isActive = activeTab === tab.id;

          return (
            <button
              key={tab.id}
              onClick={() => {
                sfx.playTap();
                onSelectTab(tab.id);
              }}
              className="flex-1 flex flex-col items-center justify-center py-1 cursor-pointer active:scale-90 transition-transform"
              aria-label={tab.label}
            >
              {tab.icon(isActive)}
              <span className={`text-[10px] font-black mt-0.5 tracking-tight ${
                isActive
                  ? tab.id === 'learn'
                    ? 'text-[#58cc02]'
                    : tab.id === 'leagues'
                    ? 'text-[#1cb0f6]'
                    : tab.id === 'vip'
                    ? 'text-amber-500'
                    : 'text-[#ce82ff]'
                  : 'text-slate-400'
              }`}>
                {tab.label}
              </span>
            </button>
          );
        })}
      </div>
    </nav>
  );
}
