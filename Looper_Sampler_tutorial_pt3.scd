
~bpm = 60.0;
~tbts = 16.0;
~tsecs = (60.0/~bpm) * ~tbts;
~ixb = Buffer.alloc(s, s.sampleRate*~tsecs);
~sndbuf = Buffer.alloc(s, s.sampleRate*~tsecs);
~ixabus = Bus.audio(s, 1);
~ixkbus = Bus.control(s, 1);
~ixgr = Group.new(s);
~ingr = Group.after(~ixgr);
~ogr = Group.after(~ingr);

SynthDef(\bufidx, {
	arg buf, spd=1, start=0.0, end=1.0, abus, kbus;
	var indexer, indexernorm;
	indexer = Phasor.ar(0, BufRateScale.kr(buf)*spd,
		start*BufFrames.kr(buf), end*BufFrames.kr(buf));
	indexernorm = indexer.linlin(0.0, BufFrames.kr(buf), 0.0, 1.0);
	Out.ar(abus, indexer);
	Out.kr(kbus, indexernorm);
}).add;

SynthDef(\bufrec,{
	arg ich=0, buf, idxbus, gate=1;
	var in, idx, env;
	env = EnvGen.ar( Env.asr(releaseTime:0.01, curve:0), gate, doneAction:2);
	in = SoundIn.ar(ich);
	idx = In.ar(idxbus);
	BufWr.ar(in*env, buf, idx);
}).add;

SynthDef(\bufpl,{
	arg och=0, buf, idxbus, gate=1;
	var sig, idx, env;
	env = EnvGen.ar( Env.asr(releaseTime:0.01, curve:0), gate, doneAction:2);
	idx = In.ar(idxbus);
	sig = BufRd.ar(1, buf, idx);
	Out.ar(och, sig*env);
}).add;


a = Synth( \bufidx, [\buf, b, \abus, ~ixabus, \kbus, ~ixbus], ~ixgr );
b = Synth( \bufrec, [\buf, ~sndbuf, \idxbus, ~ixabus], ~ingr);
c = Synth( \bufpl, [\buf, ~sndbuf, \idxbus, ~ixabus], ~ogr );

b.set(\gate, 0);
c.set(\gate, 0);





