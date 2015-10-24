s.boot;
SynthDef( \mt, { } ).add;

SynthDef( \mt, {
	var synth;
	synth = SinOsc.ar();
	Out.ar(0, synth);
} ).add;


SynthDef( \mt, {
	arg freq=300;
	var synth;
	synth = SinOsc.ar(freq);
	Out.ar(0, synth);
} ).add;

SynthDef( \mt, {
	arg pitchlo=48, pitchhi=72;
	var synth;
	synth = SinOsc.ar( MouseX.kr(pitchlo, pitchhi).midicps );
	Out.ar(0, synth);
} ).add;

SynthDef( \mt, {
	arg pitchlo=48, pitchhi=72, atk=0.001, rel=0.1;
	var synth, env;
	env = EnvGen.ar( Env.asr(atk, releaseTime:rel), MouseButton.kr(lag:0) );
	synth = SinOsc.ar( MouseX.kr(pitchlo, pitchhi).midicps );
	Out.ar(0, synth*env);
} ).add;

SynthDef( \mt, {
	arg pitchlo=48, pitchhi=72, atk=0.001, rel=0.1;
	var synth, env, amp;
	amp = MouseY.kr(1.0, 0.0, lag:0);
	env = EnvGen.ar( Env.asr(atk, releaseTime:rel), MouseButton.kr(lag:0) );
	synth = SinOsc.ar( MouseX.kr(pitchlo, pitchhi, lag:0.03).midicps );
	Out.ar(0, synth*env*amp);
} ).add;

SynthDef( \mt, {
	arg pitchlo=48, pitchhi=72, atk=0.001, rel=0.1,
	osc1amp=0.33, osc2amp=0.33, osc3amp=0.33;
	var synth, env, amp, osc1, osc2, osc3;
	amp = MouseY.kr(1.0, 0.0, lag:0);
	env = EnvGen.ar( Env.asr(atk, releaseTime:rel), MouseButton.kr(lag:0) );
	osc1 = SinOsc.ar( MouseX.kr(pitchlo, pitchhi, lag:0.03).midicps );
	osc2 = Saw.ar( MouseX.kr(pitchlo, pitchhi, lag:0.03).midicps );
	osc3 = Pulse.ar( MouseX.kr(pitchlo, pitchhi, lag:0.03).midicps );
	synth = Mix.ar( [osc1*osc1amp, osc2*osc2amp, osc3*osc3amp] );
	Out.ar(0, synth*env*amp);
} ).add;

SynthDef( \mt, {
	arg pitchlo=48, pitchhi=72, atk=0.001, rel=0.1,
	osc1amp=0.33, osc2amp=0.33, osc3amp=0.33,
	osc1tune=0, osc2tune=0, osc3tune=0,
	rate=1, ffreqlo=50, ffreqhi=15000;
	var synth, env, amp, osc1, osc2, osc3, pitch;
	amp = MouseY.kr(1.0, 0.0, lag:0);
	pitch = MouseX.kr(pitchlo, pitchhi, lag:0.03);
	env = EnvGen.ar( Env.asr(atk, releaseTime:rel), MouseButton.kr(lag:0) );
	osc1 = SinOsc.ar( (pitch + osc1tune).midicps );
	osc2 = Saw.ar( (pitch + osc2tune).midicps );
	osc3 = Pulse.ar( (pitch + osc3tune).midicps );
	synth = Mix.ar( [osc1*osc1amp, osc2*osc2amp, osc3*osc3amp] );
	synth = RLPF.ar(synth, SinOsc.kr(rate).range(ffreqlo, ffreqhi) );
	Out.ar(0, synth*env*amp);
} ).add;


Env.asr(0.2, releaseTime:0.01).plot;

a = Synth(\mt);

a = Synth(\mt, [
	\rate, 0.3, \ffreqlo, 200, \ffreqhi, 7000,
	\osc2amp, 0.3, \osc3amp, 0.5, \osc1amp, 0.2,
	\osc3tune, -24, \osc1tune, -1
]);

a.set(\ffreq, 10000);
a.set(\rate, 0.3, \ffreqlo, 200, \ffreqhi, 7000);
a.set(\osc3tune, -24, \osc1tune, -1);
a.set(\pitchlo, 35, \pitchhi, 55);
a.set(\osc2amp, 0, \osc3amp, 0, \osc1amp, 1);
a.set(\osc2amp, 0.3, \osc3amp, 0.5, \osc1amp, 0.2);
a.set(\osc2amp, 0, \osc3amp, 1, \osc1amp, 0);
a.set(\osc2amp, 0.5, \osc3amp, 0.5, \osc1amp, 0);
a.free;
