// GigiCharacter — simplified to plain image (no SVG outfit overlays)
import React from 'react';
import { MASCOT_IMAGES } from '../data/mascotImages';

export function GigiCharacter({ pose = 'waving', className = '', onClick = null }) {
  const imgSrc = MASCOT_IMAGES[pose] || MASCOT_IMAGES.waving;
  return (
    <img
      src={imgSrc}
      alt="Gigi"
      className={`w-full h-full object-contain ${className}`}
      onClick={onClick}
    />
  );
}
