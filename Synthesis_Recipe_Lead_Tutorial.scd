(
~wtb1  = Buffer.read(s, "/Users/jyang/GitHub/wavetablesynthesis/wavetables/WT7.aif");
~wtb2 = Buffer.read(s, "/Users/jyang/GitHub/wavetablesynthesis/wavetables/WT10.aif");

SynthDef(\lead,{
	arg wtbuf, offset=0.65, oscamp1=0.25, oscamp2=0.25, oscamp3=0.5,
	detune1= -0.1, detune2 = 0.1, detune3=0.1,
	trig=1, atk=0.02, rel=0.1, crv= -2,
	fatk=0.03, fdecay=1.2, fsus=0.07, frel=1, fcrv= -2,
	ffreqhi=15000, ffreqlo=100,
	lfo1freq=25, lfo1w=2.5, lfo2freq= 4, lfo3freq= 0.2, glide=0.5;
	var osc1, freq1;
	var osc2, freq2;
	var osc3, freq3;
	var sig, sig2, env, fenv;
	var lfo1, lfo2, lfo3;
	var amp, pitch;
	pitch = \pitch.kr(60, glide);
	amp = \amp.kr(1, 0.03);
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), trig);
	fenv = EnvGen.ar( Env.adsr( fatk, fdecay, fsus, frel, 1, fcrv), trig);
	lfo1 = SinOsc.kr( (lfo1freq*fenv) )*lfo1w;
	lfo2 = SinOsc.kr( lfo2freq);
	lfo3 = SinOsc.kr( lfo3freq);
	freq1 = ( pitch + (lfo2*detune1) ).midicps;
	freq2 = ( pitch + (lfo2*detune2) ).midicps;
	freq3 = ( pitch + (lfo3*detune3) ).midicps;
	osc1 = Saw.ar(freq1);
	osc2 = Saw.ar(freq2);
	osc3  = VOsc3.ar(wtbuf+offset, freq3, freq3+0.37, freq3+0.43, 0.3333);
	sig = Mix.ar([ osc1*oscamp1, osc2*oscamp2, osc3*oscamp3 ]);
	sig = RLPF.ar( sig, (((ffreqhi*fenv)+ffreqlo).cpsmidi + lfo1).midicps, 0.35 );
	sig2 = DelayC.ar(sig, 0.2, 0.03);
	Out.ar(0, [sig, sig2]*env*amp);
}).add;
)

a = Synth(\lead, [\wtbuf, ~wtb1.bufnum, \pitch, 72]);
a.set(\pitch, 65);
a.free;






