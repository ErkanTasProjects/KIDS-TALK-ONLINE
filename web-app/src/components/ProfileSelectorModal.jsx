import React, { useState, useEffect, useRef } from 'react';
import { useProfileContext, useActiveProfile } from '../context/ProfileContext';
import { X, Trash2, Plus, Sparkles, Check } from 'lucide-react';

const AVATARS = ['🦁', '🐼', '🦊', '🐸', '🐱', '🐶'];

const CARD_COLORS = [
  { ring: 'ring-[#58cc02]', border: 'border-[#58cc02]', bg: 'from-green-50 to-emerald-50', bgDark: 'from-green-900/20 to-emerald-900/20', glow: 'shadow-[#58cc02]/30' },
  { ring: 'ring-[#1cb0f6]', border: 'border-[#1cb0f6]', bg: 'from-blue-50 to-cyan-50', bgDark: 'from-blue-900/20 to-cyan-900/20', glow: 'shadow-[#1cb0f6]/30' },
  { ring: 'ring-[#ff9600]', border: 'border-[#ff9600]', bg: 'from-orange-50 to-amber-50', bgDark: 'from-orange-900/20 to-amber-900/20', glow: 'shadow-[#ff9600]/30' },
];

function ProfileCard({ profile, index, isSelected, onSelect, onDelete, onUpdateName, onUpdateAvatar, isDark }) {
  const [isEditing, setIsEditing] = useState(false);
  const [editName, setEditName] = useState(profile.name);
  const [showAvatarPicker, setShowAvatarPicker] = useState(false);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const nameInputRef = useRef(null);
  const colors = CARD_COLORS[index % CARD_COLORS.length];

  // Load star count from this profile's localStorage
  const stars = (() => {
    try {
      const val = localStorage.getItem(`${profile.key}stars`);
      return val ? parseInt(val, 10) : 0;
    } catch {
      return 0;
    }
  })();

  useEffect(() => {
    if (isEditing && nameInputRef.current) {
      nameInputRef.current.focus();
      nameInputRef.current.select();
    }
  }, [isEditing]);

  const handleNameSave = () => {
    const trimmed = editName.trim();
    if (trimmed) {
      onUpdateName(profile.id, trimmed);
    } else {
      setEditName(profile.name);
    }
    setIsEditing(false);
  };

  return (
    <div className="relative">
      {/* Delete Confirmation Overlay */}
      {showDeleteConfirm && (
        <div className="absolute inset-0 z-20 flex items-center justify-center rounded-3xl bg-black/60 backdrop-blur-sm">
          <div className="text-center p-4">
            <p className="text-white font-black text-sm mb-3 font-bubble">Delete {profile.name}? 😢</p>
            <p className="text-white/70 text-xs mb-4">All progress will be lost!</p>
            <div className="flex gap-2 justify-center">
              <button
                onClick={() => setShowDeleteConfirm(false)}
                className="px-4 py-2 rounded-xl bg-white/20 text-white text-xs font-bold hover:bg-white/30 transition-colors border-b-2 border-white/10"
              >
                Cancel
              </button>
              <button
                onClick={() => {
                  setShowDeleteConfirm(false);
                  onDelete(profile.id);
                }}
                className="px-4 py-2 rounded-xl bg-red-500 text-white text-xs font-bold hover:bg-red-600 transition-colors border-b-2 border-red-700"
              >
                Delete 🗑️
              </button>
            </div>
          </div>
        </div>
      )}

      <button
        onClick={() => onSelect(profile)}
        className={`
          w-full p-4 rounded-3xl border-2 border-b-4 transition-all duration-200
          ${isSelected
            ? `${colors.border} ${isDark ? `bg-gradient-to-br ${colors.bgDark}` : `bg-gradient-to-br ${colors.bg}`} ring-2 ${colors.ring} shadow-lg ${colors.glow} scale-[1.02]`
            : `${isDark ? 'border-gray-700 bg-[#1a2d35] hover:border-gray-500' : 'border-gray-200 bg-white hover:border-gray-300'} hover:scale-[1.01]`
          }
          text-left relative
        `}
      >
        {/* Selected badge */}
        {isSelected && (
          <div className="absolute -top-2 -right-2 w-7 h-7 bg-[#58cc02] rounded-full flex items-center justify-center shadow-md border-2 border-white dark:border-[#131f24]">
            <Check size={14} className="text-white" strokeWidth={3} />
          </div>
        )}

        {/* Delete button */}
        <button
          onClick={(e) => {
            e.stopPropagation();
            setShowDeleteConfirm(true);
          }}
          className={`absolute top-2 right-2 p-1.5 rounded-full transition-colors ${
            isDark ? 'hover:bg-red-500/20 text-gray-500 hover:text-red-400' : 'hover:bg-red-50 text-gray-300 hover:text-red-400'
          }`}
        >
          <Trash2 size={14} />
        </button>

        <div className="flex items-center gap-3">
          {/* Avatar */}
          <div
            onClick={(e) => {
              e.stopPropagation();
              setShowAvatarPicker(!showAvatarPicker);
            }}
            className={`
              w-16 h-16 rounded-2xl flex items-center justify-center text-3xl
              cursor-pointer transition-all hover:scale-110 border-b-4
              ${isDark ? 'bg-[#131f24] border-gray-700' : 'bg-gray-50 border-gray-200'}
            `}
          >
            {profile.avatar}
          </div>

          {/* Info */}
          <div className="flex-1 min-w-0">
            {isEditing ? (
              <input
                ref={nameInputRef}
                value={editName}
                onChange={(e) => setEditName(e.target.value)}
                onBlur={handleNameSave}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') handleNameSave();
                  if (e.key === 'Escape') {
                    setEditName(profile.name);
                    setIsEditing(false);
                  }
                }}
                onClick={(e) => e.stopPropagation()}
                maxLength={15}
                className={`
                  w-full text-base font-black font-bubble px-2 py-1 rounded-xl border-2 outline-none
                  ${isDark
                    ? 'bg-[#131f24] border-[#1cb0f6] text-white'
                    : 'bg-white border-[#1cb0f6] text-gray-800'
                  }
                `}
              />
            ) : (
              <p
                onClick={(e) => {
                  e.stopPropagation();
                  setIsEditing(true);
                  setEditName(profile.name);
                }}
                className={`text-base font-black font-bubble truncate cursor-text hover:underline decoration-dashed underline-offset-4 ${
                  isDark ? 'text-white' : 'text-gray-800'
                }`}
              >
                {profile.name}
              </p>
            )}
            <div className="flex items-center gap-1.5 mt-1">
              <span className="text-lg">⭐</span>
              <span className={`text-sm font-bold ${isDark ? 'text-yellow-400' : 'text-yellow-600'}`}>
                {stars.toLocaleString()} stars
              </span>
            </div>
          </div>
        </div>

        {/* Avatar picker dropdown */}
        {showAvatarPicker && (
          <div
            onClick={(e) => e.stopPropagation()}
            className={`
              mt-3 p-3 rounded-2xl border-2 border-b-4
              ${isDark ? 'bg-[#131f24] border-gray-700' : 'bg-gray-50 border-gray-200'}
            `}
          >
            <p className={`text-xs font-bold mb-2 text-center ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
              Pick your buddy!
            </p>
            <div className="grid grid-cols-6 gap-2">
              {AVATARS.map((emoji) => (
                <button
                  key={emoji}
                  onClick={(e) => {
                    e.stopPropagation();
                    onUpdateAvatar(profile.id, emoji);
                    setShowAvatarPicker(false);
                  }}
                  className={`
                    w-10 h-10 rounded-xl flex items-center justify-center text-xl
                    transition-all hover:scale-125 border-b-2
                    ${profile.avatar === emoji
                      ? `${isDark ? 'bg-[#1cb0f6]/20 border-[#1cb0f6]' : 'bg-blue-100 border-[#1cb0f6]'} scale-110`
                      : `${isDark ? 'bg-[#1a2d35] border-gray-700 hover:bg-[#243d4a]' : 'bg-white border-gray-200 hover:bg-gray-100'}`
                    }
                  `}
                >
                  {emoji}
                </button>
              ))}
            </div>
          </div>
        )}
      </button>
    </div>
  );
}

export function ProfileSelectorModal({ isOpen, onClose, onSelectProfile }) {
  const { profiles, activeProfile, setActiveProfile, addProfile, deleteProfile, updateProfile } = useProfileContext();
  const [selectedProfile, setSelectedProfile] = useState(null);
  const [isAnimating, setIsAnimating] = useState(false);

  // Determine dark mode
  const isDark = document.documentElement.classList.contains('dark') ||
    localStorage.getItem('kids_talk_theme') === 'dark';

  // Set initial selected profile
  useEffect(() => {
    if (isOpen) {
      setSelectedProfile(activeProfile || profiles[0] || null);
      setIsAnimating(true);
    }
  }, [isOpen, activeProfile, profiles]);

  if (!isOpen) return null;

  const handleSelect = (profile) => {
    setSelectedProfile(profile);
    // Play tap sound if available
    try {
      const sfx = window.__sfx;
      if (sfx?.playTap) sfx.playTap();
    } catch {}
  };

  const handleConfirm = () => {
    if (!selectedProfile) return;
    setActiveProfile(selectedProfile);
    // Play success sound if available
    try {
      const sfx = window.__sfx;
      if (sfx?.playSuccess) sfx.playSuccess();
    } catch {}
    if (onSelectProfile) {
      onSelectProfile({
        id: selectedProfile.id,
        name: selectedProfile.name,
        avatar: selectedProfile.avatar,
        key: selectedProfile.key,
      });
    }
    if (onClose) onClose();
  };

  const handleAddProfile = () => {
    if (profiles.length >= 3) return;
    // Pick a random unused avatar
    const usedAvatars = new Set(profiles.map((p) => p.avatar));
    const available = AVATARS.filter((a) => !usedAvatars.has(a));
    const avatar = available.length > 0 ? available[0] : AVATARS[profiles.length % AVATARS.length];
    const name = `Player ${profiles.length + 1}`;
    addProfile(name, avatar);
  };

  const handleDelete = (id) => {
    deleteProfile(id);
    // If we deleted the selected one, pick the first remaining
    if (selectedProfile?.id === id) {
      const remaining = profiles.filter((p) => p.id !== id);
      setSelectedProfile(remaining[0] || null);
    }
  };

  const handleUpdateName = (id, newName) => {
    updateProfile(id, { name: newName });
    if (selectedProfile?.id === id) {
      setSelectedProfile((prev) => (prev ? { ...prev, name: newName } : prev));
    }
  };

  const handleUpdateAvatar = (id, newAvatar) => {
    updateProfile(id, { avatar: newAvatar });
    if (selectedProfile?.id === id) {
      setSelectedProfile((prev) => (prev ? { ...prev, avatar: newAvatar } : prev));
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      {/* Backdrop */}
      <div
        className="absolute inset-0 bg-black/50 backdrop-blur-sm"
        onClick={onClose}
      />

      {/* Modal */}
      <div
        className={`
          relative w-full max-w-md max-h-[90vh] overflow-y-auto rounded-3xl border-2 border-b-4 shadow-2xl
          ${isDark
            ? 'bg-[#1a2d35] border-gray-700'
            : 'bg-white border-gray-200'
          }
          ${isAnimating ? 'animate-bounce-in' : ''}
        `}
      >
        {/* Header gradient bar */}
        <div className="h-2 rounded-t-3xl bg-gradient-to-r from-[#58cc02] via-[#1cb0f6] to-[#ff9600]" />

        {/* Close button */}
        <button
          onClick={onClose}
          className={`
            absolute top-5 right-4 p-2 rounded-xl transition-colors z-10
            ${isDark ? 'hover:bg-white/10 text-gray-400' : 'hover:bg-gray-100 text-gray-400'}
          `}
        >
          <X size={20} />
        </button>

        <div className="p-6">
          {/* Title */}
          <div className="text-center mb-6">
            <h2 className={`text-2xl font-black font-bubble ${isDark ? 'text-white' : 'text-gray-800'}`}>
              Who's Playing Today?
            </h2>
            <p className="text-3xl mt-1">🎮</p>
            <p className={`text-sm mt-2 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
              Tap a profile to select, then hit Let's Go!
            </p>
          </div>

          {/* Profile Cards */}
          <div className="space-y-3 mb-5">
            {profiles.map((profile, index) => (
              <ProfileCard
                key={profile.id}
                profile={profile}
                index={index}
                isSelected={selectedProfile?.id === profile.id}
                onSelect={handleSelect}
                onDelete={handleDelete}
                onUpdateName={handleUpdateName}
                onUpdateAvatar={handleUpdateAvatar}
                isDark={isDark}
              />
            ))}
          </div>

          {/* Add Profile Button */}
          {profiles.length < 3 && (
            <button
              onClick={handleAddProfile}
              className={`
                w-full py-3 rounded-2xl border-2 border-dashed transition-all
                flex items-center justify-center gap-2 font-bold text-sm
                hover:scale-[1.01] active:scale-[0.99]
                ${isDark
                  ? 'border-gray-600 text-gray-400 hover:border-[#1cb0f6] hover:text-[#1cb0f6] hover:bg-[#1cb0f6]/5'
                  : 'border-gray-300 text-gray-400 hover:border-[#1cb0f6] hover:text-[#1cb0f6] hover:bg-blue-50'
                }
              `}
            >
              <Plus size={18} />
              Add New Profile
            </button>
          )}

          {/* Sibling count hint */}
          <p className={`text-xs text-center mt-2 ${isDark ? 'text-gray-500' : 'text-gray-400'}`}>
            {profiles.length}/3 profiles • Perfect for siblings! 👦👧
          </p>

          {/* Let's Go Button */}
          <button
            onClick={handleConfirm}
            disabled={!selectedProfile}
            className={`
              w-full mt-5 py-4 rounded-2xl font-black text-lg font-bubble
              transition-all duration-200 flex items-center justify-center gap-2
              ${selectedProfile
                ? 'bg-[#58cc02] hover:bg-[#4caf00] text-white border-b-4 border-[#46a302] active:border-b-0 active:mt-[calc(1.25rem+4px)] shadow-lg hover:shadow-xl'
                : `${isDark ? 'bg-gray-700 text-gray-500 border-b-4 border-gray-800' : 'bg-gray-200 text-gray-400 border-b-4 border-gray-300'} cursor-not-allowed`
              }
            `}
          >
            {selectedProfile ? (
              <>
                <span>Let's Go!</span>
                <span className="text-xl">🚀</span>
              </>
            ) : (
              'Select a Profile'
            )}
          </button>

          {/* Selected profile hint */}
          {selectedProfile && (
            <p className={`text-center text-sm mt-3 font-bold ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
              Playing as{' '}
              <span className={isDark ? 'text-white' : 'text-gray-800'}>
                {selectedProfile.avatar} {selectedProfile.name}
              </span>
            </p>
          )}
        </div>
      </div>

      {/* Bounce-in animation */}
      <style>{`
        @keyframes bounceIn {
          0% { transform: scale(0.8) translateY(20px); opacity: 0; }
          50% { transform: scale(1.03); opacity: 1; }
          100% { transform: scale(1) translateY(0); opacity: 1; }
        }
        .animate-bounce-in {
          animation: bounceIn 0.35s ease-out;
        }
      `}</style>
    </div>
  );
}

export { useActiveProfile } from '../context/ProfileContext';
export default ProfileSelectorModal;
