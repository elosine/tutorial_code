(
b = Buffer.read(s, "/home/ddmi/Documents/wavetablesynthesis-master/wavetables/Add Saw 2+5.wav");
c = Buffer.read(s, "/home/ddmi/Documents/wavetablesynthesis-master/wavetables/WT27.aif");

SynthDef(\snh, {
	arg osc1ampf=0.40, osc2ampf=0.40,
	osc3ampf=0.15, osc4ampf=0.05,
	detune1=0, detune2 = -7, detune3=0, detune4=0,
	offset=0.64279, wtbuf, res=1.2, shfreq=7.5;
	var amp, sig, pitch, sh;
	var osc1, osc2, osc3, osc4;
	var osc1amp, osc2amp, osc3amp, osc4amp;
	var osc1freq, osc2freq, osc3freq, osc4freq;
	sh = LFNoise0.kr(shfreq);
	pitch = \pitch.kr(60, 0.03);
	amp = \amp.kr(1.0, 0.03);
	osc1freq = (pitch + detune1).midicps;
	osc2freq = (pitch + detune2).midicps;
	osc3freq = (pitch + detune3).midicps;
	osc4freq = (pitch + detune4).midicps;
	osc1amp = amp*osc1ampf;
	osc2amp = amp*osc2ampf;
	osc3amp = amp*osc3ampf;
	osc4amp = amp*osc4ampf;
	osc1 = Saw.ar(osc1freq);
	osc2 = Saw.ar(osc2freq);
	osc3 = VOsc3.ar( wtbuf+offset, osc3freq, osc3freq+0.37, osc3freq+0.43, 0.33333);
	//osc4 = Resonz.ar();
	osc4 = DFM1.ar( In.ar(50), osc4freq, 1.1);
	sig = Mix.ar( [osc1*osc1amp, osc2*osc2amp,
		osc3*osc3amp, osc4*osc4amp] );
	sig = DFM1.ar( sig, sh.range(pitch-12, pitch+36).midicps, res);
	//sig = DFM1.ar( sig, sh.range(100, 5000), res);
	Out.ar(0, sig);
}).add;
)

a = Synth(\snh, [\wtbuf, b.bufnum, \pitch, 60]);
a.set(\shfreq, 7.5, \res, 1.4, \pitch, 65);

{DFM1.ar(In.ar(50), 300,1.5)}.play