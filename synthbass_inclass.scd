(
SynthDef( \synthbass, {
	arg atk=0.03, decay=0.0, sus=1, rel=0.1, crv= 0, gate=1,
	ffreqhi=1800, ffreqlo=80, res=0.6,
	fatk=0.01, fdecay=0.14, fsus=0.1, frel=0.1, fcrv= 0;
	var env, sig, pitch, amp, fenv, sig2;
	var osc1, freq1;
	var osc2, freq2;
	var osc3, freq3;
	pitch = \pitch.kr(60, 0.03);
	amp = \amp.kr(0.85, 0.03);
	freq1 = pitch.midicps;
	freq2 = (pitch+0.06).midicps;
	freq3 = (pitch-12).midicps;
	env = EnvGen.ar( Env.adsr(atk,decay,sus,rel,curve:crv), gate );
	fenv = EnvGen.ar( Env.adsr(fatk,fdecay,fsus,frel,curve:fcrv), gate );
	osc1 = Saw.ar(freq1);
	osc2 = Saw.ar(freq2);
	osc3 = SinOsc.ar(freq3);
	sig = Mix.ar( [osc1, osc2, osc3]*0.333 );
	sig = MoogLadder.ar( sig, (ffreqhi*fenv)+ffreqlo, res );
	sig = sig.softclip;
	sig2 = DelayC.ar(sig, 0.2, 0.03);
	Out.ar(0, [sig, sig2]*amp*env);
} ).add;
)

a = Synth( \synthbass, [\pitch, 37, \amp, 2] );
a.set(\res, 0.2);
a.free;



 Env.adsr(0.8, 0.2, 0.5, 0.04, curve: 2).plot

			DFM1.ar(
			BMoog.ar(
				MoogLadder.ar(