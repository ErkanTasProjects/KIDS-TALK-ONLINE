/**
 * Fisher-Yates Shuffle Algorithm
 * Guarantees that the shuffled array is in randomized order
 * and never matches the original indexing order when length >= 2.
 */
export function shuffleArray(array) {
  if (!array || array.length <= 1) return [...(array || [])];

  const result = [...array];
  let isSame = true;
  let attempts = 0;

  while (isSame && attempts < 15) {
    attempts++;
    for (let i = result.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [result[i], result[j]] = [result[j], result[i]];
    }

    // Verify it doesn't match the original sequence
    isSame = result.every((item, idx) => {
      const original = array[idx];
      if (typeof item === 'object' && item !== null) {
        if ('id' in item && 'id' in original) return item.id === original.id;
        if ('word' in item && 'word' in original) return item.word === original.word;
      }
      return item === original;
    });
  }

  // Guaranteed shift fallback if still matches by statistical anomaly
  if (isSame && result.length >= 2) {
    const first = result.shift();
    result.push(first);
  }

  return result;
}
