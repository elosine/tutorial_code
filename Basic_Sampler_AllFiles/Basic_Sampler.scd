(
~samps = SoundFile.collectIntoBuffers("/Users/jyang/Downloads/Basic_Sampler/samples/*", s);
SynthDef(\buffy, {
	arg buf, spd=1, amp=1;
	var sig;
	sig = PlayBuf.ar(1, buf, spd, \t_tr.kr(1,0), doneAction:2);
	Out.ar(0, sig*amp);
}).add;
OSCdef(\playbuf,{
	arg msg;
	var bufnum = msg[1].asInteger;
	var amp = msg[2].asFloat;
	Synth( \buffy, [ \buf, ~samps[bufnum], \amp, amp ] );
}, "/playbuf");
)





	