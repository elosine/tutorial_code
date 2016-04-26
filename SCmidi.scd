(
//monophonic
MIDIIn.connectAll;
~pbus = Bus.control(s);
~abus = Bus.control(s);
~gbus = Bus.control(s);
MIDIFunc.noteOn({|vel note ch id|
	~pbus.set(note);
	~abus.set(vel);
	~gbus.set(1);
});
MIDIFunc.noteOff({|vel note ch id|
	~gbus.set(vel);
});

SynthDef(\miditest, {
	arg glide = 0.0, atk=0.01, rel=0.1, crv= -4, gate=0;
	var freq = \pitch.kr(60, glide).midicps;
	var amp = \vel.kr(1.0, 0.0).linlin(0, 127, 0.0, 1.0);
	var env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
	Out.ar(0, SinOsc.ar(freq)*env*amp);
}).add;
)

a = Synth(\miditest);
a.map(\pitch, ~pbus, \vel, ~abus, \gate, ~gbus);


(
//polyphony
MIDIIn.connectAll;
SynthDef(\pad, {
	arg atk=0.3, dur=3, rel=0.2, crv= -2, gate=1,
	pitch=48, tune1= -0.06, lffreq1=1.5, lf1lo=0.14, lf1hi=0.2,
	tune2= 0.06, lffreq2=2, lf2lo=0.74, lf2hi=0.8, tune3= -12.06,
	ffreq=2500;
	var env, osc1, freq1, sig, lfo1, osc2, freq2, lfo2, freq3, osc3, sig2;
	var amp = \vel.kr(1.0, 0.0).linlin(0, 127, 0.0, 1.0);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate, doneAction:2);
	lfo1 = SinOsc.kr(lffreq1).range(lf1lo, lf1hi);
	lfo2 = SinOsc.kr(lffreq2).range(lf2lo, lf2hi);
	freq1 = (pitch+tune1).midicps;
	osc1 = Pulse.ar(freq1, lfo1);
	freq2 = (pitch+tune2).midicps;
	osc2 = Pulse.ar(freq2, lfo2);
	freq3 = (pitch+tune3).midicps;
	osc3 = Pulse.ar(freq3, lfo1);
	sig = Mix.ar( [osc1*0.333, osc2*0.333, osc3*0.333] );
	sig = DFM1.ar(sig, ffreq, type:0);
	sig2 = DelayC.ar(sig, 0.2, 0.05);
	Out.ar(0, [sig,sig2]*env*amp);
}).add;
//polyphony
MIDIFunc.noteOn({|vel note ch id|
	s.sendMsg(\s_new, \pad, 2000+note, 0, 1, \pitch, note, \vel, vel);
});
MIDIFunc.noteOff({|vel note|
	s.sendMsg(\n_set, 2000+note, \gate, vel);
});
)
s.queryAllNodes

