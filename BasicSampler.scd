b = SoundFile.collectIntoBuffers("/Users/jyang/GitHub/ringmod/samples/*");
SynthDef(\sampy, {
	arg buf, obs=0, atk=0.01, rel=0.1, crv= -3, gate=1, amp=1, rate=1, start=0, loop=0;
	var env, in;
	in = PlayBuf.ar(1, buf, rate,\t_tr.kr(1,0),start,loop) ;
	Out.ar(obs, in*amp);
}).add;

a = Synth(\sampy, [\buf, b[1].bufnum]);
a.set(\t_tr, 1);
a.free;