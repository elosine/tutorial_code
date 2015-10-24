//Create a SynthDef Template
(
SynthDef( \siney, {
	arg freq=300, amp=0.85, atk=0.01, sus=0.5, rel=0.1, crv = -2;
	var syn, env;
	env = EnvGen.ar( Env.linen(atk, sus, rel, curve:crv), \t_gate.kr(0, 0) );
	syn = SinOsc.ar(freq);
	Out.ar(0, syn*amp*env);
} ).add;

SynthDef(\blippy, {
	arg freq=300, harms=200, amp=0.85, atk=0.07, sus=0.8, rel=0.01, crv= -4;
	var syn, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel, curve:crv), \t_gate.kr(0, 0) );
	syn = Blip.ar(freq, harms);
	Out.ar(0, syn*amp*env);
} ).add;

SynthDef(\toothy, {
	arg freq=300, amp=0.85, atk=0.07, sus=0.8, rel=0.01, crv= -4;
	var syn, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel, curve:crv), \t_gate.kr(0, 0) );
	syn = Saw.ar(freq);
	Out.ar(0, syn*amp*env);
} ).add;

SynthDef(\cubey, {
	arg freq=300, width=0.5, amp=0.85, atk=0.07, sus=0.8, rel=0.01, crv= -4;
	var syn, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel, curve:crv), \t_gate.kr(0, 0) );
	syn = Pulse.ar(freq,width);
	Out.ar(0, syn*amp*env);
} ).add;

SynthDef(\formey, {
	arg freq=300, ffreq=1000, bwfreq=5000, amp=0.85, atk=0.07, sus=0.8, rel=0.01, crv= -4;
	var syn, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel, curve:crv), \t_gate.kr(0, 0) );
	syn = Formant.ar(freq, ffreq, bwfreq);
	Out.ar(0, syn*amp*env);
} ).add;
)

arg freq=300, amp=0.85, atk=0.01, sus=0.5, rel=0.1, crv = -2;
~s5 = Synth(\cubey, [\freq, 36.midicps, \width, 0.99, \atk, 0.003, \sus, 62.8, \rel, 0.1, \crv, 3 ]);

~s1 = Synth(\siney, [\freq, 60.midicps,  \atk, 0.4, \sus, 4, \rel, 0.3, \crv, 3]);
~s2 = Synth(\siney, [\freq, 79.midicps,  \atk, 2.5, \sus, 0, \rel, 2.5, \crv, 6]);

~s5 = Synth(\cubey, [\freq, 36.midicps, \width, 0.99, \atk, 0.003, \sus, 62.8, \rel, 0.1, \crv, 3 ]);
~s5.set(\t_gate, 1);
~s5.free;
(
~s1.set(\t_gate, 1);
~s2.set(\t_gate, 1);
)
~s1.free;
Env.linen(0.2, 4, 0.3, curve: 4).plot

(
~s1 = Synth(\siney, [\freq, 60.midicps, \sus, 2 ]);
~s2 = Synth(\siney, [\freq, 61.midicps, \atk, 2, \sus, 0, \rel, 2, \crv, 4 ]);
~s3 = Synth(\blippy, [\freq, 65.midicps, \harms, 10, \atk, 0.003, \sus, 2, \rel, 2, \crv, 3 ]);
~s3b = Synth(\blippy, [\freq, 65.midicps, \harms, 10, \atk, 0.003, \sus, 2, \rel, 2, \crv, 3 ]);
~s4 = Synth(\toothy, [\freq, 67.midicps, \atk, 0.003, \sus, 0.1, \rel, 0.01, \crv, 3 ]);
~s5 = Synth(\cubey, [\freq, 36.midicps, \width, 0.99, \atk, 0.003, \sus, 62.8, \rel, 0.1, \crv, 3 ]);
~s6 = Synth(\cubey, [\freq, 40.midicps, \width, 0.99, \atk, 0.003, \sus, 62.8, \rel, 0.1, \crv, 3 ]);
~s7 = Synth(\cubey, [\freq, 43.midicps, \width, 0.99, \atk, 0.003, \sus, 62.8, \rel, 0.1, \crv, 3 ]);
~s8 = Synth(\formey, [\freq, 64.midicps, \width, 0.99, \atk, 0.1, \sus, 2, \rel, 0.1, \crv, 3 ]);
~s9 = Synth(\formey, [\freq, 64.midicps, \width, 0.99, \atk, 0.1, \sus, 2, \rel, 0.1, \crv, 3 ]);
)

~s3.set(\t_gate, 1);
~s3b.set(\t_gate, 1, \freq, 64.midicps);

~s8.set(\t_gate, 1, \ffreq, 3000, \bwfreq, 1000, \sus, 3, \amp, 0.5);
~s9.set(\t_gate, 1, \ffreq, 3000, \bwfreq, 1000, \freq, 63.midicps, \sus, 3, \amp, 0.5);

(
~s1.set(\t_gate, 1, \sus, 4, \rel, 1.5);
~s2.set(\t_gate, 1, \freq, 79.midicps, \rel, 5.5);
)

~s4.set(\t_gate, 1, \freq, 55.midicps);
~s4.set(\t_gate, 1, \freq, 67.midicps);
(
~s5.set(\t_gate, 1, \freq, 36.midicps, \amp, 0.6);
~s6.set(\t_gate, 1, \freq, 40.midicps, \amp, 0.6);
~s7.set(\t_gate, 1, \freq, 43.midicps, \amp, 0.6);
)

s.makeGui