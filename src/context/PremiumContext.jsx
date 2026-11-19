import React, { createContext, useContext, useState, useEffect } from 'react';

const PremiumContext = createContext();

export const GIGI_OUTFITS = [
  {
    id: 'default',
    name: 'Classic Gigi',
    description: 'The cheerful, friendly explorer giraffe!',
    icon: '🦒',
    isVipOnly: false,
    color: 'from-amber-400 to-yellow-500',
  },
  {
    id: 'crown',
    name: 'Golden Royal Crown',
    description: 'Sparkling jeweled crown fit for an English King or Queen!',
    icon: '👑',
    isVipOnly: true,
    color: 'from-yellow-400 to-amber-500',
  },
  {
    id: 'cape_mask',
    name: 'Superhero Cape & Mask',
    description: 'Fly through vocabulary with superhero speed!',
    icon: '🦸‍♂️',
    isVipOnly: true,
    color: 'from-red-500 to-rose-600',
  },
  {
    id: 'astronaut',
    name: 'Space Astronaut Helmet',
    description: 'Explore out-of-this-world English phrases in the galaxy!',
    icon: '🧑‍🚀',
    isVipOnly: true,
    color: 'from-sky-400 to-blue-600',
  },
  {
    id: 'wizard',
    name: 'Wizard Hat & Star Wand',
    description: 'Cast magical grammar spells with a sparkling star wand!',
    icon: '🧙‍♂️',
    isVipOnly: true,
    color: 'from-purple-500 to-indigo-600',
  },
];

export function PremiumProvider({ children }) {
  // VIP state persisted in localStorage
  const [isVip, setIsVip] = useState(() => {
    try {
      return localStorage.getItem('kids_talk_is_premium') === 'true' ||
             localStorage.getItem('kids_talk_is_vip') === 'true';
    } catch (e) {
      return false;
    }
  });

  // Equipped Gigi Outfit
  const [equippedOutfit, setEquippedOutfitState] = useState(() => {
    try {
      const saved = localStorage.getItem('kids_talk_gigi_outfit');
      return saved || 'default';
    } catch (e) {
      return 'default';
    }
  });

  // Hearts System (5 hearts max, VIP gets infinite)
  const [hearts, setHearts] = useState(() => {
    try {
      const saved = localStorage.getItem('kids_talk_hearts');
      return saved !== null ? parseInt(saved, 10) : 5;
    } catch (e) {
      return 5;
    }
  });

  // Sticker Album placed items
  const [placedStickers, setPlacedStickers] = useState(() => {
    try {
      const saved = localStorage.getItem('kids_talk_stickers');
      return saved ? JSON.parse(saved) : [];
    } catch (e) {
      return [];
    }
  });

  // Keep localStorage updated
  useEffect(() => {
    try {
      localStorage.setItem('kids_talk_is_premium', isVip ? 'true' : 'false');
      localStorage.setItem('kids_talk_is_vip', isVip ? 'true' : 'false');
    } catch (e) {}
  }, [isVip]);

  useEffect(() => {
    try {
      localStorage.setItem('kids_talk_gigi_outfit', equippedOutfit);
    } catch (e) {}
  }, [equippedOutfit]);

  useEffect(() => {
    try {
      localStorage.setItem('kids_talk_hearts', hearts.toString());
    } catch (e) {}
  }, [hearts]);

  useEffect(() => {
    try {
      localStorage.setItem('kids_talk_stickers', JSON.stringify(placedStickers));
    } catch (e) {}
  }, [placedStickers]);

  // VIP Actions
  const activateVip = () => {
    setIsVip(true);
    setHearts(5); // full hearts
  };

  const deactivateVip = () => {
    setIsVip(false);
    // If wearing a VIP outfit, revert to default
    if (equippedOutfit !== 'default') {
      setEquippedOutfitState('default');
    }
  };

  const setEquippedOutfit = (outfitId) => {
    const outfit = GIGI_OUTFITS.find(o => o.id === outfitId);
    if (outfit && outfit.isVipOnly && !isVip) {
      return false; // Can't equip VIP outfit if not VIP
    }
    setEquippedOutfitState(outfitId);
    return true;
  };

  // Hearts logic
  const loseHeart = () => {
    if (isVip) return hearts; // VIP has infinite hearts!
    const newHearts = Math.max(0, hearts - 1);
    setHearts(newHearts);
    return newHearts;
  };

  const refillHearts = () => {
    setHearts(5);
  };

  // Level & World Access Check
  const canAccessWorld = (worldId) => {
    if (worldId === 'starter') return true; // Starter is 100% Free
    return isVip; // Movers and Flyers require VIP
  };

  const saveStickerPlacement = (stickers) => {
    setPlacedStickers(stickers);
  };

  return (
    <PremiumContext.Provider
      value={{
        isVip,
        isPremium: isVip, // alias for backwards compatibility
        activateVip,
        unlockPremium: activateVip, // alias
        deactivateVip,
        cancelPremium: deactivateVip, // alias
        equippedOutfit,
        setEquippedOutfit,
        outfits: GIGI_OUTFITS,
        hearts: isVip ? 999 : hearts,
        hasUnlimitedHearts: isVip,
        loseHeart,
        refillHearts,
        canAccessWorld,
        placedStickers,
        saveStickerPlacement,
      }}
    >
      {children}
    </PremiumContext.Provider>
  );
}

export function usePremium() {
  return useContext(PremiumContext);
}
