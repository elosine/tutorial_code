//MULTI-TAP DELAY TUTORIAL
b = Buffer.alloc(s, s.sampleRate*4);
SynthDef(\multitap, {
	arg ich = 0, obs=0, buf, panrate=3,
	delaytimes = #[0.4, 0.6, 0.8, 1.2, 1.4, 1.6, 1.8],
	amps = #[0.9, 0.8, 0.7,0.6,0.5,0.5,0.4];
	var source, sig;
	source = SoundIn.ar(ich);
	sig = MultiTap.ar( delaytimes, amps, source, bufnum:buf );
	sig  = Pan2.ar( sig, SinOsc.kr(panrate) );
	Out.ar(obs, sig);
}).add;
a = Synth(\multitap, [\buf, b.bufnum, \panrate, 3]);
a = Synth(\multitap, [ \buf, b.bufnum, \delaytimes, [0.1, 0.2,0.3,0.4,0.5,0.6,0.7] ]);
a.free;
