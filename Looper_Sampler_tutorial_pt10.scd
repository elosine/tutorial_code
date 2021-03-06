(
~bpm = 60.0;
~tbts = 16.0;
~tsecs = (60.0/~bpm) * ~tbts;
~numtrx = 8;
//Empty Arrays to hold synths
~recsynths = Array.newClear(~numtrx);
~playsynths = Array.newClear(~numtrx);
~trx = { Buffer.alloc(s, s.sampleRate*~tsecs) }!~numtrx;
~ixb = Buffer.alloc(s, s.sampleRate*~tsecs);
~zerobuf = Buffer.alloc(s, s.sampleRate*~tsecs);
~ixabus = Bus.audio(s, 1);
~ixkbus = Bus.control(s, 1);
~ixgr = Group.new(s);
~ingr = Group.after(~ixgr);
~ogr = Group.after(~ingr);
~proc = NetAddr("127.0.0.1", 12321);

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
	arg ich=0, buf, idxbus, gate=0;
	var in, idx, env;
	env = EnvGen.ar( Env.asr(releaseTime:0.01, curve:0), gate);
	in = SoundIn.ar(ich);
	idx = In.ar(idxbus);
	BufWr.ar(in*env, buf, idx);
}).add;

SynthDef(\bufpl,{
	arg och=0, buf, idxbus, gate=0;
	var sig, idx, env;
	env = EnvGen.ar( Env.asr(releaseTime:0.01, curve:0), gate);
	idx = In.ar(idxbus);
	sig = BufRd.ar(1, buf, idx);
	Out.ar(och, sig*env);
}).add;

OSCdef(\getidx, {
	~ixkbus.get( { arg val; ~proc.sendMsg("/ix", val.asFloat) } );
}, "/getidx");

OSCdef(\recon, {
	arg msg;
	var trk;
	trk = msg[1].asInteger;
	~playsynths[trk].set(\gate, 0);
	~recsynths[trk].set( \gate, 1, \buf, ~trx[trk] );
}, "/recon");

OSCdef(\recoff, {
	arg msg;
	var trk;
	trk = msg[1].asInteger;
	~recsynths[trk].set( \gate, 0, \buf, ~zerobuf );
	~playsynths[trk].set(\gate, 1);
}, "/recoff");

OSCdef(\play, {
	arg msg;
	var trk;
	trk = msg[1].asInteger;
	~playsynths[trk].set(\gate, 1);
}, "/play");

OSCdef(\pause, {
	arg msg;
	var trk;
	trk = msg[1].asInteger;
	~playsynths[trk].set(\gate, 0);
}, "/pause");

OSCdef(\wavfrm, {
	arg msg;
	var trk;
	trk = msg[1].asInteger;
	~waveform.value(~trx[trk], trk);
}, "/wavfrm");

~waveform = {
	arg buf, trkn;
	var bufarray, sampsize, resamp, resampArray, ct;
	buf.loadToFloatArray( action:{
		arg array;
		bufarray = array;
		sampsize = 1000;
		resamp = (bufarray.size/sampsize).round;
		resampArray = Array.newClear(sampsize+2);
		ct = 0;
		bufarray.do{
			arg it, ix;
			if( ix%resamp == 0, { resampArray[ct] =  it.asFloat; ct = ct+1; } );
		};
		resampArray.insert(0, trkn.asInteger);
		resampArray.insert(0, "/sbuf");
		~proc.sendBundle(0.0, resampArray);
	} );

};

)

( //start initial synths
~ixsynth = Synth( \bufidx, [\buf, ~ixb, \abus, ~ixabus, \kbus, ~ixbus], ~ixgr );
~numtrx.do{
	arg ix;
	~recsynths[ix] =  Synth(\bufrec, [\buf, ~zerobuf, \idxbus, ~ixabus, \gate, 0], ~ingr  );
	~playsynths[ix] = Synth(\bufpl, [\buf, ~trx[ix], \idxbus, ~ixabus, \gate, 1], ~ogr);
};
)










