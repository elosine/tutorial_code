~g0 = Group.new(s);
~g1 = Group.after(~g0);
~g2 = Group.after(~g1);
~insbus = Bus.audio(s, 1);
~kbus = Bus.control(s,1);
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
SynthDef(\bufpl, {
	arg buf, obs=0;
	var sig, index;
	index = Phasor.ar( 0, BufRateScale.kr(buf), 0, BufFrames.kr(buf) );
	sig = BufRd.ar(1, buf, index);
	Out.ar(obs, sig);
}).add;
SynthDef(\amplify, {
	arg ibs, obs=0, amp=0.85;
	var sig;
	sig = In.ar(ibs);
	Out.ar(obs, sig*amp);
}).add;

d = Buffer.alloc(s, s.sampleRate*2, 1);
SynthDef(\tap, {
	arg obs=0, ibs, buf, deltimes = #[0.2, 0.4, 0.6, 0.8, 1.0, 1.2],
	amps = #[0.85, 0.85, 0.85, 0.85, 0.85, 0.85];
	var src, tap, d1,d2,d3,d4,d5,d6, sig;
	src = In.ar(ibs);
	tap = DelTapWr.ar(buf, src);
	#d1, d2, d3, d4, d5, d6 = DelTapRd.ar( buf, tap, deltimes, 4, amps);
	sig = Mix.ar( [d1,d2,d3,d4,d5,d6] );
	Out.ar(obs, sig);
}).add;


SynthDef(\singlefilter, {
	arg obs=0, ibs, amp=1, ffreq=1000, q=0.2, mode=0, sat=0.95;
	var src, sig;
	src = In.ar(ibs);
	sig = BMoog.ar(src, ffreq, q, mode, sat);
	Out.ar(obs, sig);
}).add;

SynthDef(\multifilter, {
	arg obs=0, ibs, amp=1,
	freqs = #[200, 400, 600, 800, 1000, 1200, 1400],
	amps = #[0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1],
	rings = #[2, 2, 2, 2, 2, 2, 2];
	var src, sig;
	src = In.ar(ibs);
	sig = Klank.ar( `[ freqs, amps, rings  ], src);
	Out.ar(obs, sig*amp);
}).add;
a = Synth( \bufpl, [\buf, b, \obs, ~insbus], ~g1 );
e = Synth( \multifilter, [\ibs, ~insbus], ~g2 );
e.set(\freqs, #[400, 450, 513, 667, 839, 912, 1001]);
e = Synth( \singlefilter, [\ibs, ~insbus], ~g2 );
e.set(\q, 1, \mode, 2, \);
e.set(\q, 0.7, \mode, 0, \ffreq, 450);

(
w = Window.new.front;
c = NumberBox(w, Rect(20, 20, 150, 20));
a = Slider(w, Rect(20, 60, 150, 20))
    .action_({

	~kbus.set(a.value.linlin(0.0, 1.0, 150.0, 10000.0));
        c.value_(a.value.linlin(0.0, 1.0, 150.0, 10000.0))
        });
a.action.value;
)

e.map(\ffreq, ~kbus);

~kbus.get
~kbus.set(100);


c = Synth( \amplify, [\ibs, ~insbus], ~g2 );
e = Synth( \tap, [ \ibs, ~insbus, \buf, d ], ~g2);
e = Synth( \tap, [
	\ibs, ~insbus,
	\buf, d,
	\deltimes, [ 0.75, 0.25, 0.75, 0.25, 0.75, 0.25],
	\amps, [ 0.9, 0.8, 0.7, 0.6, 0.5, 0.4 ]
], ~g2);
c.free;
e.free;

s.queryAllNodes;

//Template
SynthDef(\name, {
	arg obs=0, ibs, amp=1;
	var src, sig;
	src = In.ar(ibs);
	sig =
	Out.ar(obs, sig);
}).add;










