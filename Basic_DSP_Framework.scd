(
s.waitForBoot{
	fork{

		SynthDef(\micin, {
			arg ich=0, obs=0, inamp=1;
			var source;
			source = SoundIn.ar(ich)*inamp;
			Out.ar(obs, source);
		}).add;




	}
}
)