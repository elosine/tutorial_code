
~bpm = 60.0;
~tbts = 16.0;
~tsecs = (60.0/~bpm) * ~tbts;
~ixb = Buffer.alloc(s, s.sampleRate*~tsecs);
~ixabus = Bus.audio(s, 1);
~ixkbus = Bus.control(s, 1);
~ixgr = Group.new(s);

SynthDef(\bufidx, {
	arg buf, spd=1, start=0.0, end=1.0, abus, kbus;
	var indexer, indexernorm;
	indexer = Phasor.ar(0, BufRateScale.kr(buf)*spd,
		start*BufFrames.kr(buf), end*BufFrames.kr(buf));
	indexernorm = indexer.linlin(0.0, BufFrames.kr(buf), 0.0, 1.0);
	Out.ar(abus, indexer);
	Out.kr(kbus, indexernorm);
}).add;




a = Synth( \bufidx, [\buf, b, \abus, ~ixabus, \kbus, ~ixbus], ~ixgr );






