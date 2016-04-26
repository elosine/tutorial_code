(s.options.numAudioBusChannels = 1000; s.waitForBoot{ fork{
	SynthDef(\tsin, {
		Out.ar(0, SinOsc.ar());
	}).add;
	0.1.wait;
	a = Synth(\tsin);
}})
s.options.numAudioBusChannels
fork{  1.postln; 1.wait; 2.postln;}
