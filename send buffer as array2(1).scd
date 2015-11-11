(
s.waitForBoot{
	~mybuf = Buffer.alloc(s, s.sampleRate*13.0); //buffer to record into and eventually send

	//Destinations
	~netdest = NetAddr("127.0.0.1" /*change to destination ip*/, 57120);

	//Function to send your buffer to another
	~sendBufFunc = {
		~mybuf.loadToFloatArray( action:{
			arg bufar;
			var pksz, numpkts, splitarrays, inc;
			pksz = s.sampleRate*0.25;//because udp packets have a size limit break up array into chunks 0.25 seconds long
			numpkts = (bufar.size/pksz).ceil;
			splitarrays = {Array.newClear(pksz)}!numpkts;
			fork{
				//make a starting to send message
				~netdest.sendMsg("/receivesamp", 0);
				0.1.wait;
				inc = 0;
				bufar.do({
					|it ix|
					var ixs = ix%pksz;
					if( ix>0 && (ixs)==0, {inc = inc+1} );
					splitarrays[inc][ixs] = it;
				});
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

	//OSCdef to receive a buffer from another and convert to audio
	OSCdef(\receivesamp, {
		arg msg;
		//check which msg it is
		switch (msg[1].asInteger,
			    0, { ~bufarray = Array.newClear(0) }, //make a clean buffer array
			    1, { msg.do{ |it ix| if(ix>1, {~bufarray = ~bufarray.add(it)})  } },
			    2, { ~newbuf2 = Buffer.loadCollection(s, ~bufarray, 1, {|bf|}) } //~newbuf is the name of received buffer
		);
	}, "/receivesamp");

	//SYNTH DEFS//////////////////////////////////////////
	SynthDef(\bufrec_ph, {
		arg ich=0, buf, gate=1, start=0, end=1;
		var in, idx, env;
		env = EnvGen.ar(Env.asr(releaseTime:0.01, curve:0),gate, doneAction:2);
		idx = Phasor.ar( 0, 1, start*BufRateScale.kr(buf), end*BufFrames.kr(buf) );
		in = SoundIn.ar(ich);
		BufWr.ar(in*env, buf, idx);
	}).add;

	SynthDef(\bufpl_ph, {
		arg obs=0, buf, gate=1, rate=1, start=0, end=1;
		var idx, sig, env;
		env = EnvGen.ar(Env.asr(releaseTime:0.01, curve:0),gate);
		idx = Phasor.ar( 0, rate, start*BufRateScale.kr(buf),end*BufFrames.kr(buf) );
		sig = BufRd.ar(1, buf, idx);
		Out.ar(obs, sig*env);
	}).add;
}
)

//start recording buffer to send
~rec = Synth( \bufrec_ph, [\ich, 0 /*mic in channel*/, \buf, ~mybuf, \gate, 1] );
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
~playyou = Synth( \bufpl_ph, [\obs, 0 /*speaker out channel*/, \buf, ~newbuf2, \gate, 1] ); //play back what I received
~playyou.set(\gate, 0); //pause playback
~playyou.set(\gate, 1); //resume playback
~playyou.free;


