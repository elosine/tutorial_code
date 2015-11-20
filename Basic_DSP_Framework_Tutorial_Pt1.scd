(
s.waitForBoot{
	fork{
		var nummics = 2;
		var g0 = Group.new;
		var g1 = Group.after(g0);
		var micbus = {Bus.audio(s,1)}!nummics;
		var iMicIdx = 2000;

		SynthDef(\micin, {
			arg ich=0, obs=0, inamp=1;
			var source;
			source = SoundIn.ar(ich)*inamp;
			Out.ar(obs, source);
		}).add;

		0.1.wait;

		//Create Mic In Synths
		nummics.do{ |ix| s.sendMsg(\s_new, \micin, iMicIdx+ix, 0, g0.nodeID, \ich, ix,\obs, micbus[ix].index)};


	} //end fork
} //end s.waitForBoot
)