
/*1*/ s.boot;

(///2////
SynthDef( \chippy,{
	arg trig=0, atk=0.01, rel=0.2, crv= -4;
	var freq, synth, vol, pitch, amp, env, h1, h2;
	pitch = \pitch.kr(60, 0.017);
	amp = \amp.kr(0.85, 0.017);
	freq = pitch.midicps;
	h1 = TIRand.kr( 2, 7, Impulse.kr(1) );
	h2 = TIRand.kr( 2, 7, Impulse.kr(1) );
	env = EnvGen.ar( Env.perc(atk, rel, 1, crv), trig );
	synth = AY.ar( AY.freqtotone(freq), AY.freqtotone(freq*h1), AY.freqtotone(freq*h2),
	0.25, 3, 15, 10, 7);
	Out.ar(0, synth*env*amp);
}).add;

OSCdef( \trig, {|msg| ~mt.set(\trig, msg[1].asFloat)}, "/trig" );
OSCdef( \pitch, {|msg| ~mt.set(\pitch, msg[1].asFloat)}, "/pitch" );
OSCdef( \amp, {|msg| ~mt.set(\amp, msg[1].asFloat)}, "/amp" );

)

/*3*/ ~mt = Synth(\chippy);
~mt.set(\rel, 0.15);

~mt.free;