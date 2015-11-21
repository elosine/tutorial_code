(
s.waitForBoot{
	fork{
		var nummics = 2;
		var g0 = Group.new;
		var g1 = Group.after(g0);
		var micbus = {Bus.audio(s,1)}!nummics;
		var iMicIdx = 2000;

		//SYNTH DEFS ///////////////////////////
		SynthDef(\micin, {
			arg ich=0, obs=0, inamp=1, gate=1;
			var source, env;
			env = EnvGen.ar(Env.asr(releaseTime:0.08), gate);
			source = SoundIn.ar(ich)*inamp;
			Out.ar(obs, source*env);
		}).add;

		SynthDef(\amplify, {
			arg ibs=0, obs=0, amp=1, gate=1;
			var sig, env;
			env = EnvGen.ar(Env.asr(releaseTime:0.08), gate, doneAction:2);
			sig = In.ar(ibs);
			Out.ar(obs, sig*amp);
		}).add;

		//OSC DEFS /////////////////////////////
		OSCdef(\amplify, {
			arg msg;
			var pl = msg[1].asInteger;
			var mode = msg[2].asInteger;
			var amp = msg[3].asFloat ? 1;
			if(mode==1,
				{ s.sendMsg(\s_new, \amplify, 3000+pl, 0, g1.nodeID, \ibs, micbus[pl].index, \obs, pl, \amp, amp) },
				{ s.sendMsg(\n_set, 3000+pl, \gate, 0) }
			);
		}, "/Amplify");

		0.1.wait;

		//Create Mic In Synths
		nummics.do{ |ix| s.sendMsg(\s_new, \micin, iMicIdx+ix, 0, g0.nodeID, \ich, ix,\obs, micbus[ix].index)};


	} //end fork
} //end s.waitForBoot
)

n = NetAddr("127.0.0.1", 57120);
n.sendMsg("/Amplify", 0, 1, 1);
n.sendMsg("/Amplify", 0, 0, 0);
s.queryAllNodes









