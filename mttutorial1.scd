s.boot;

(
SynthDef( \midisine, {
	arg atk=0.01, rel=0.1, crv = -3, trig=0;
	var osc, freq, env, pitch, amp;
	pitch = \pitch.kr(60, 0.017);
	amp = \amp.kr(0.85, 0.017);
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), trig );
	freq = pitch.midicps;
	osc = SinOsc.ar(freq);
	Out.ar(0, osc*amp*env);
}).add;

OSCdef( \pitch, {
	arg msg;
	~mt.set(\pitch, msg[1]);
}, "/pitch" );

OSCdef( \amp, {
	arg msg;
	~mt.set(\amp, msg[1]);
}, "/amp" );

OSCdef( \trig, {
	arg msg;
	msg[2].postln;
	~mt.set(\trig, msg[1]);
}, "/trig" );
)

~mt = Synth(\midisine);

