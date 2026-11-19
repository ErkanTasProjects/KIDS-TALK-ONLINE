import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';

const ProfileContext = createContext(null);

const PROFILES_KEY = 'kids_talk_profiles';
const ACTIVE_PROFILE_KEY = 'kids_talk_active_profile';

const DEFAULT_PROFILE = {
  id: 'p1',
  name: 'Player 1',
  avatar: '🦁',
  key: 'kids_talk_p1_',
};

function loadProfiles() {
  try {
    const raw = localStorage.getItem(PROFILES_KEY);
    if (raw) {
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed) && parsed.length > 0) return parsed;
    }
  } catch {}
  return [DEFAULT_PROFILE];
}

function loadActiveProfile(profiles) {
  try {
    const id = localStorage.getItem(ACTIVE_PROFILE_KEY);
    if (id) {
      const found = profiles.find((p) => p.id === id);
      if (found) return found;
    }
  } catch {}
  return profiles[0] || DEFAULT_PROFILE;
}

export function ProfileProvider({ children }) {
  const [profiles, setProfiles] = useState(() => loadProfiles());
  const [activeProfile, setActiveProfileState] = useState(() => loadActiveProfile(loadProfiles()));

  // Persist profiles whenever they change
  useEffect(() => {
    localStorage.setItem(PROFILES_KEY, JSON.stringify(profiles));
  }, [profiles]);

  // Persist active profile id whenever it changes
  useEffect(() => {
    if (activeProfile) {
      localStorage.setItem(ACTIVE_PROFILE_KEY, activeProfile.id);
    }
  }, [activeProfile]);

  const setActiveProfile = useCallback((profile) => {
    setActiveProfileState(profile);
  }, []);

  const addProfile = useCallback((name, avatar) => {
    setProfiles((prev) => {
      if (prev.length >= 3) return prev;
      const nextNum = prev.length + 1;
      // Find a free slot id (p1, p2, p3)
      const usedIds = new Set(prev.map((p) => p.id));
      let slotId = null;
      for (let i = 1; i <= 3; i++) {
        if (!usedIds.has(`p${i}`)) {
          slotId = `p${i}`;
          break;
        }
      }
      if (!slotId) return prev;

      const newProfile = {
        id: slotId,
        name: name || `Player ${nextNum}`,
        avatar: avatar || '🐼',
        key: `kids_talk_${slotId}_`,
      };
      return [...prev, newProfile];
    });
  }, []);

  const updateProfile = useCallback((id, updates) => {
    setProfiles((prev) =>
      prev.map((p) => {
        if (p.id !== id) return p;
        const updated = { ...p, ...updates };
        return updated;
      })
    );
    setActiveProfileState((prev) => {
      if (prev && prev.id === id) return { ...prev, ...updates };
      return prev;
    });
  }, []);

  const deleteProfile = useCallback(
    (id) => {
      setProfiles((prev) => {
        const filtered = prev.filter((p) => p.id !== id);
        if (filtered.length === 0) return [DEFAULT_PROFILE];
        return filtered;
      });

      // Clear that profile's localStorage data
      const prefix = `kids_talk_${id}_`;
      const keysToRemove = [];
      for (let i = 0; i < localStorage.length; i++) {
        const k = localStorage.key(i);
        if (k && k.startsWith(prefix)) keysToRemove.push(k);
      }
      keysToRemove.forEach((k) => localStorage.removeItem(k));

      // If we deleted the active profile, switch to first remaining
      setActiveProfileState((prev) => {
        if (prev && prev.id === id) {
          setProfiles((current) => {
            const first = current[0] || DEFAULT_PROFILE;
            setActiveProfileState(first);
            return current;
          });
          return prev; // will be overridden by inner setState
        }
        return prev;
      });
    },
    []
  );

  const getProfileKey = useCallback(
    (key) => {
      if (!activeProfile) return `kids_talk_p1_${key}`;
      return `${activeProfile.key}${key}`;
    },
    [activeProfile]
  );

  const value = {
    activeProfile,
    setActiveProfile,
    profiles,
    addProfile,
    updateProfile,
    deleteProfile,
    getProfileKey,
  };

  return <ProfileContext.Provider value={value}>{children}</ProfileContext.Provider>;
}

/** Returns the active profile info: { profileId, profileKey, profileName, profileAvatar } */
export function useActiveProfile() {
  const ctx = useContext(ProfileContext);
  if (!ctx) {
    // Fallback when used outside provider
    const id = localStorage.getItem(ACTIVE_PROFILE_KEY) || 'p1';
    return {
      profileId: id,
      profileKey: `kids_talk_${id}_`,
      profileName: 'Player 1',
      profileAvatar: '🦁',
    };
  }
  const { activeProfile } = ctx;
  return {
    profileId: activeProfile?.id || 'p1',
    profileKey: activeProfile?.key || 'kids_talk_p1_',
    profileName: activeProfile?.name || 'Player 1',
    profileAvatar: activeProfile?.avatar || '🦁',
  };
}

export function useProfileContext() {
  const ctx = useContext(ProfileContext);
  if (!ctx) throw new Error('useProfileContext must be used within ProfileProvider');
  return ctx;
}

export default ProfileContext;
