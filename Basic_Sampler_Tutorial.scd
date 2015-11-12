~b1 = Buffer.read(s, "/Users/jyang/GitHub/superimposition/monosamples/boxing-bell-1.wav");
~bs = SoundFile.collectIntoBuffers( "/Users/jyang/GitHub/superimposition/monosamples/*");
SynthDef(\sampy, {
	arg obs=0, buf, rate=1, amp=1;
	var sig;
	sig = PlayBuf.ar( 1, buf, rate, \t_tr.kr(1, 0) );
	Out.ar(obs, sig*amp);
}).add;

a = Synth(\sampy, [\buf, ~b1.bufnum]);
a.set(\t_tr, 1);
a.set(\buf, ~bs[3].bufnum, \t_tr, 1);

~bs[4]