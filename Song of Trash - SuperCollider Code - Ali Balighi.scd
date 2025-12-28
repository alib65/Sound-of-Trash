/*
The Sound of Trash examines the sounds and aesthetic qualities of waste, turning discarded materials into creative inspiration. Using animated notation and sound synthesis, the piece encourages listeners to view trash not as useless leftovers but as active elements in an abstract soundscape.

With SuperCollider, the work creates synthetic sounds that imitate the unpredictable and chaotic noises of trash, such as the rustling of paper and the clanging of metal objects.

Composer, and visual artist: Ali Balighi
www.alibalighi.com

Youtube link: "https://www.youtube.com/watch?v=NDToNWrAB3o"

*/


// Specify the audio device
ServerOptions.devices;
s.options.inDevice = "Scarlett 18i20 USB";
s.options.outDevice = "Soundflower (2ch)";
s.reboot;

(
// Define the sound process as a SynthDef
SynthDef(\micDelayReverb, {
    var mic, delayTime, delaySig, pitchShift1, pitchShift2, pitchShift3, pitchShift4, combinedPitchShift, reverb;

    // Capture microphone input
    mic = SoundIn.ar(0);

    // Random delay time between 3 and 10 seconds
    delayTime = LFNoise1.kr(1).exprange(3, 10);
    delaySig = DelayN.ar(mic, delayTime, delayTime);

    // Define multiple pitch shifts with different pitch ratios
    pitchShift1 = Select.ar(LFNoise1.kr(1).range(0, 2).round, [
        PitchShift.ar(delaySig, pitchRatio: 1.0),  // Repeat the same pitch
        PitchShift.ar(delaySig, pitchRatio: 1.2),  // Slightly higher
        PitchShift.ar(delaySig, pitchRatio: 0.8)   // Slightly lower
    ]);

    pitchShift2 = Select.ar(LFNoise1.kr(1.5).range(0, 2).round, [
        PitchShift.ar(delaySig, pitchRatio: 1.3),  // Lower pitch
        PitchShift.ar(delaySig, pitchRatio: 0.5),  // Higher pitch
        PitchShift.ar(delaySig, pitchRatio: 1.1)   // Very low pitch
    ]);

    pitchShift3 = Select.ar(LFNoise1.kr(0.5).range(0, 2).round, [
        PitchShift.ar(delaySig, pitchRatio: 0.6),  // One octave up
        PitchShift.ar(delaySig, pitchRatio: 1.2),  // One octave down
        PitchShift.ar(delaySig, pitchRatio: 0.3)   // Moderate upward shift
    ]);

    pitchShift4 = Select.ar(LFNoise1.kr(0.75).range(0, 2).round, [
        PitchShift.ar(delaySig, pitchRatio: 1.2),  // Lower pitch
        PitchShift.ar(delaySig, pitchRatio: 0.4),  // Higher pitch
        PitchShift.ar(delaySig, pitchRatio: 0.9)  // Slight downward shift
    ]);

    // Combine the pitch-shifted signals
    combinedPitchShift = Mix([pitchShift1, pitchShift2, pitchShift3, pitchShift4]);

    // Add panning with slow oscillation and apply reverb
    reverb = FreeVerb.ar(Pan2.ar(combinedPitchShift, SinOsc.kr(0.25), 0.2), mix: 0.3, room: 0.7, damp: 0.5);

    // Output the final sound to stereo channels
    Out.ar(0, reverb ! 2);
}).add;

// Play the Synth after the server is booted
s.waitForBoot {
    Synth(\micDelayReverb);
};
)
