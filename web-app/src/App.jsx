import React, { useState, useEffect } from 'react';
import { CURRICULUM } from './data/curriculum';
import { SplashScreen } from './components/SplashScreen';
import { AdventureMap } from './components/AdventureMap';
import { BottomNavBar } from './components/BottomNavBar';
import { ProfilePage } from './components/ProfilePage';
import { LeaguePage } from './components/LeaguePage';
import { QuestsPage } from './components/QuestsPage';
import { SubscriptionModal } from './components/SubscriptionModal';
import { OutOfHeartsModal } from './components/OutOfHeartsModal';
import { BedtimeModal } from './components/BedtimeModal';
import { MatchingGreetings } from './activities/MatchingGreetings';
import { TapMatchRoutines } from './activities/TapMatchRoutines';
import { LetterTracing } from './activities/LetterTracing';
import { ListenChoose } from './activities/ListenChoose';
import { BalloonPop } from './activities/BalloonPop';
import { SentenceBuilder } from './activities/SentenceBuilder';
import { MemoryCards } from './activities/MemoryCards';
import { SubjectSorter } from './activities/SubjectSorter';
import { HiddenObject } from './activities/HiddenObject';
import { FillInTheBlank } from './activities/FillInTheBlank';
import { SpeakRecord } from './activities/SpeakRecord';
import { stopSpeech } from './utils/audio';
import { ThemeProvider, useTheme } from './context/ThemeContext';
import { PremiumProvider, usePremium } from './context/PremiumContext';
import { ProfileProvider, useActiveProfile } from './context/ProfileContext';

function MainApp() {
  const [showSplash, setShowSplash] = useState(true);
  const [currentTab, setCurrentTab] = useState('learn'); // 'learn', 'quests', 'leagues', 'vip', 'profile'
  const [activeActivity, setActiveActivity] = useState(null);
  const [isSubscribeOpen, setIsSubscribeOpen] = useState(false);
  const [isOutOfHeartsOpen, setIsOutOfHeartsOpen] = useState(false);
  const [isBedtimeTriggered, setIsBedtimeTriggered] = useState(false);

  const { isVip, loseHeart, hearts } = usePremium();
  const { isDark } = useTheme();
  const { profileKey } = useActiveProfile();

  // Load stars for active kid profile
  const [stars, setStars] = useState(() => {
    try {
      const activeKey = profileKey || 'kids_talk_p1_';
      const saved = localStorage.getItem(`${activeKey}stars`) || localStorage.getItem('kids_talk_stars');
      return saved ? parseInt(saved, 10) : 0;
    } catch (e) {
      return 0;
    }
  });

  // Load completed activities for active kid profile
  const [completedIds, setCompletedIds] = useState(() => {
    try {
      const activeKey = profileKey || 'kids_talk_p1_';
      const saved = localStorage.getItem(`${activeKey}completed_ids`) || localStorage.getItem('kids_talk_completed_ids');
      return saved ? JSON.parse(saved) : [];
    } catch (e) {
      return [];
    }
  });

  // When active profile switches, reload stars & progress
  useEffect(() => {
    try {
      const activeKey = profileKey || 'kids_talk_p1_';
      const savedStars = localStorage.getItem(`${activeKey}stars`);
      setStars(savedStars ? parseInt(savedStars, 10) : 0);

      const savedIds = localStorage.getItem(`${activeKey}completed_ids`);
      setCompletedIds(savedIds ? JSON.parse(savedIds) : []);
    } catch (e) {}
  }, [profileKey]);

  // Persist stars & completed IDs
  useEffect(() => {
    try {
      const activeKey = profileKey || 'kids_talk_p1_';
      localStorage.setItem(`${activeKey}stars`, stars.toString());
      localStorage.setItem('kids_talk_stars', stars.toString());
    } catch (e) {}
  }, [stars, profileKey]);

  useEffect(() => {
    try {
      const activeKey = profileKey || 'kids_talk_p1_';
      localStorage.setItem(`${activeKey}completed_ids`, JSON.stringify(completedIds));
      localStorage.setItem('kids_talk_completed_ids', JSON.stringify(completedIds));
    } catch (e) {}
  }, [completedIds, profileKey]);

  // Healthy Screen-Time Limiter interval check
  useEffect(() => {
    const checkScreenTime = () => {
      try {
        const limitStr = localStorage.getItem('kids_talk_time_limit');
        if (limitStr && limitStr !== 'unlimited') {
          const limitMins = parseInt(limitStr, 10);
          const sessionStartStr = sessionStorage.getItem('kids_talk_session_start');
          const now = Date.now();
          if (!sessionStartStr) {
            sessionStorage.setItem('kids_talk_session_start', now.toString());
          } else {
            const start = parseInt(sessionStartStr, 10);
            const elapsedMins = (now - start) / 60000;
            if (elapsedMins >= limitMins) {
              setIsBedtimeTriggered(true);
            }
          }
        }
      } catch (e) {}
    };

    checkScreenTime();
    const interval = setInterval(checkScreenTime, 20000); // check every 20s
    return () => clearInterval(interval);
  }, []);

  const handleSelectActivity = (activity) => {
    if (!isVip && hearts <= 0) {
      setIsOutOfHeartsOpen(true);
      return;
    }
    stopSpeech();
    setActiveActivity(activity);
  };

  const handleExitActivity = () => {
    stopSpeech();
    setActiveActivity(null);
  };

  const handleActivityComplete = (earned = 3) => {
    if (activeActivity) {
      const multiplier = isVip ? 2 : 1;
      setStars(prev => prev + (earned * multiplier));
      if (!completedIds.includes(activeActivity.id)) {
        setCompletedIds(prev => [...prev, activeActivity.id]);
      }
    }
  };

  const handleSpendStars = (amount) => {
    setStars(prev => Math.max(0, prev - amount));
  };

  const handleNextActivity = () => {
    if (!activeActivity) return;
    const currentIndex = CURRICULUM.findIndex(a => a.id === activeActivity.id);
    if (currentIndex >= 0 && currentIndex + 1 < CURRICULUM.length) {
      const nextAct = CURRICULUM[currentIndex + 1];
      stopSpeech();
      handleSelectActivity(nextAct);
    } else {
      handleExitActivity();
    }
  };

  const handleResetProgress = () => {
    setStars(0);
    setCompletedIds([]);
    try {
      const activeKey = profileKey || 'kids_talk_p1_';
      localStorage.removeItem(`${activeKey}stars`);
      localStorage.removeItem(`${activeKey}completed_ids`);
      localStorage.removeItem('kids_talk_stars');
      localStorage.removeItem('kids_talk_completed_ids');
    } catch (e) {}
  };

  const handleSelectTab = (tabId) => {
    if (tabId === 'vip') {
      setIsSubscribeOpen(true);
    } else {
      setCurrentTab(tabId);
    }
  };

  return (
    <div className={isDark ? 'dark' : ''} style={{ minHeight: '100vh' }}>
      {showSplash && <SplashScreen onFinish={() => setShowSplash(false)} />}

      {/* VIP Subscription Modal */}
      <SubscriptionModal
        isOpen={isSubscribeOpen}
        onClose={() => setIsSubscribeOpen(false)}
      />

      {/* Out of Hearts Modal */}
      <OutOfHeartsModal
        isOpen={isOutOfHeartsOpen}
        onClose={() => setIsOutOfHeartsOpen(false)}
        onOpenSubscribe={() => {
          setIsOutOfHeartsOpen(false);
          setIsSubscribeOpen(true);
        }}
      />

      {/* Bedtime Mode (Screen Time reached) */}
      <BedtimeModal
        isOpen={isBedtimeTriggered}
        onClose={() => {
          setIsBedtimeTriggered(false);
          try {
            sessionStorage.setItem('kids_talk_session_start', Date.now().toString());
          } catch (e) {}
        }}
        starsToday={stars}
      />

      {/* Main Screen Content */}
      {!activeActivity ? (
        <>
          {/* Learn Tab: The Adventure Snake Map */}
          <AdventureMap
            stars={stars}
            completedActivityIds={completedIds}
            onSelectActivity={handleSelectActivity}
            onResetProgress={handleResetProgress}
            onSpendStars={handleSpendStars}
            onOpenSubscribe={() => setIsSubscribeOpen(true)}
          />

          {/* Quests Overlay Page */}
          {currentTab === 'quests' && (
            <QuestsPage
              stars={stars}
              onClose={() => setCurrentTab('learn')}
              isDark={isDark}
            />
          )}

          {/* Leagues Overlay Page */}
          {currentTab === 'leagues' && (
            <LeaguePage
              onClose={() => setCurrentTab('learn')}
              onStartLesson={() => {
                setCurrentTab('learn');
                const first = CURRICULUM.find(a => !completedIds.includes(a.id)) || CURRICULUM[0];
                handleSelectActivity(first);
              }}
              isDark={isDark}
            />
          )}

          {/* Profile Overlay Page */}
          {currentTab === 'profile' && (
            <ProfilePage
              stars={stars}
              onClose={() => setCurrentTab('learn')}
              isDark={isDark}
            />
          )}

          {/* Duolingo 5-Tab Bottom Bar */}
          <BottomNavBar
            activeTab={currentTab}
            onSelectTab={handleSelectTab}
            isDark={isDark}
          />
        </>
      ) : (
        /* Active Activity Player */
        (() => {
          const commonProps = {
            key: activeActivity.id,
            currentStars: stars,
            onComplete: handleActivityComplete,
            onNext: handleNextActivity,
            onExit: handleExitActivity,
            onOpenSubscribe: () => setIsSubscribeOpen(true),
          };

          switch (activeActivity.type) {
            case 'matching_greetings':
              return <MatchingGreetings {...commonProps} />;
            case 'tap_match_routines':
              return <TapMatchRoutines {...commonProps} />;
            case 'letter_tracing':
              return <LetterTracing {...commonProps} />;
            case 'listen_choose':
              return <ListenChoose {...commonProps} />;
            case 'balloon_pop':
              return <BalloonPop {...commonProps} />;
            case 'sentence_builder':
              return <SentenceBuilder {...commonProps} />;
            case 'memory_cards':
              return <MemoryCards {...commonProps} />;
            case 'subject_sorter':
              return <SubjectSorter {...commonProps} />;
            case 'hidden_object':
              return <HiddenObject {...commonProps} />;
            case 'fill_blank':
              return <FillInTheBlank {...commonProps} />;
            case 'speak_record':
              return <SpeakRecord {...commonProps} />;
            default:
              return (
                <div className="p-8 text-center dark:bg-[#131f24] dark:text-white min-h-screen">
                  <p>Activity not found.</p>
                  <button onClick={handleExitActivity} className="mt-4 px-4 py-2 bg-sky-500 text-white rounded-xl">
                    Return to Map
                  </button>
                </div>
              );
          }
        })()
      )}
    </div>
  );
}

export default function App() {
  return (
    <ThemeProvider>
      <ProfileProvider>
        <PremiumProvider>
          <MainApp />
        </PremiumProvider>
      </ProfileProvider>
    </ThemeProvider>
  );
}
