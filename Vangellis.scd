(
SynthDef( \chariots, {
	arg atk=0.410, rel=6.1, crv = 0, trig=1, lffreq=0.06, detune = 0.06,
	lpfreq=6000, fatk=1.6, frel=7.7, fcrv=0,
	mix=0.7, rm=0.9, dmp=0.07;
	var osc1, osc2, freq1, freq2, env, pitch, amp, sig, lfo1, pitch2,
	fenv;
	fenv = EnvGen.ar( Env.asr(fatk, 1, frel, fcrv), trig );
	lfo1 = SinOsc.kr(lffreq);
	pitch = \pitch.kr(60, 0.017);
	pitch2 = pitch + (lfo1*detune) ;
	amp = \amp.kr(0.85, 0.017);
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), trig );
	freq1 = pitch.midicps;
	freq2 = pitch2.midicps;
	osc1 = Saw.ar(freq1);
	osc2 = Saw.ar(freq2);
	sig = Mix.ar( [osc1, osc2] );
	sig = RLPF.ar(sig, (lpfreq*fenv)+100 );
	//sig = FreeVerb2.ar(sig, sig, mix, rm, dmp);
	sig = JPverb.ar(sig, 4, 0, 4);
	Out.ar(0, sig*amp*env);
}).add;
)
a = Synth(\chariots);
a.set(\trig, 0);
a.set(\trig, 1, \pitch, 60);
a.set(\trig, 1, \pitch, 67);
a.free;

350 2200