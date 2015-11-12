(
~mybuf = Buffer.alloc(s, s.sampleRate*13.0);

~netdest = NetAddr("127.0.0.1", 57120);

~sendBufFunc = {
	~mybuf.loadToFloatArray( action:{
		arg bufar;
		var pksz, numpkts, splitarrays, inc;
		pksz = 44100*0.25;
		numpkts = (bufar.size/pksz).ceil;
		splitarrays = {Array.newClear(pksz)}!numpkts;

		fork{

			//Make A starting message "I'm sending you lots of stuff"
			~netdest.sendMsg("/receivesamp", 0);

			0.1.wait;
			inc = 0;
			//Populate smaller packet size arrays with values from larger buffer array
			bufar.do({|it ix|
				var ixs = ix%pksz;
				if( ix>0 && ixs == 0, {inc = inc+1} );
				splitarrays[inc][ixs] = it;
			});
			//Sends array values to receiver
			splitarrays.do{ |it ix|
				var newbuf;
				newbuf = Array.newFrom(it);
				newbuf = newbuf.insert(0, 1);
				newbuf = newbuf.insert(0, "/receivesamp");
				~netdest.sendBundle(0.0, newbuf);
				0.1.wait;
			};

			0.1.wait;
			//make a done message
			~netdest.sendMsg("/receivesamp", 2);
		}

	} );
};

OSCdef(\receivesamp, {
	arg msg;
	//check which msg it is
	switch( msg[1].asInteger,
		0, { ~bufarray = Array.newClear(0) },
		1, { msg.do{ |it ix| if(ix>1, { ~bufarray = ~bufarray.add(it) } ) } };
		2, { ~newbuf2 = Buffer.loadCollection(s, ~bufarray, 1, {|bf|} ) }
	);
}, "/receivesamp");



SynthDef(\bufrec_ph,{
	arg ibs=0, buf, gate=1;
	var in, index, env;
	env = EnvGen.ar(Env.asr(releaseTime:0.1), gate, doneAction:2);
	in = SoundIn.ar(ibs);
	index = Phasor.ar( 0, 1, 0.0, BufFrames.kr(buf));
	BufWr.ar(in*env, buf, index);
}).add;


SynthDef(\bufpl_ph,{
	arg obs=0, buf, gate=1, rate=1, start=0, end=1;
	var in, index, env, sig;
	env = EnvGen.ar(Env.asr(releaseTime:0.1), gate, doneAction:0);
	index = Phasor.ar( 0, rate, start*BufRateScale.kr(buf), end*BufFrames.kr(buf) );
	sig = BufRd.ar(1, buf, index);
	Out.ar(obs, sig*env);
}).add;
)

//start recording buffer to send
~rec = Synth( \bufrec_ph, [\ibs, 0 /*mic in channel*/, \buf, ~mybuf.bufnum, \gate, 1] );
~rec.set(\gate, 0); //stop recording

//play back what I recorded
~playme = Synth( \bufpl_ph, [\obs, 0 /*speaker out channel*/, \buf, ~mybuf, \gate, 1] );
~playme.set(\gate, 0); //pause playback
~playme.set(\gate, 1); //resume playback
~playme.free;

//send your buffer to the remote destination (if you use 127.0.0.1, you can test it locally)
~sendBufFunc.value;

//play back what I received
//Received Sound Buffer Playback
~playyou = Synth( \bufpl_ph, [\obs, 0 /*speaker out channel*/, \buf, ~newbuf2.bufnum, \gate, 1] ); //play back what I received
~playyou.set(\gate, 0); //pause playback
~playyou.set(\gate, 1); //resume playback
~playyou.free;







