SerialPort.listDevices

~ino = ArduinoSMS("/dev/tty.wchusbserial1a1140", 38400);

~ino.send($a); //send any character to initialize mpu6050 lib

~kb = {Bus.control(s)}!3;

~xv = 60.0;
~xinc = 0.2;
~xmin = 38;
~xmax = 80;
~yv = 60.0;
~yinc = 0.2;
~ymin = 38;
~ymax = 80;
~zv = 60.0;
~zinc = 0.2;
~zmin = 38;
~zmax = 80;

//v1
//~ino.action = { |msg| msg.postln };

/*
//v2
~ino.action = { |msg|
	var msgsplit = split(msg, $:);
	msgsplit.postln;
};*/

/*
//v3
~ino.action = { |msg|
	var msgsplit = split(msg, $:);
	var header = msgsplit[0].asSymbol;
	var val = msgsplit[1].asFloat;
	//sort by header
	switch( header,
		\accx, {val.postln},
		\accy, {},
		\accz, {}
	);
};
*/
/*
//v4 - map raw accl values
~ino.action = { |msg|
	var msgsplit = split(msg, $:);
	var header = msgsplit[0].asSymbol;
	var val = msgsplit[1].asFloat;
	//sort by header
	switch( header,
		\accx, {
			var vmp = val.linlin(-82.0, 87.0, 40.0, 70.0);
			~kb[0].set(vmp);
			},
		\accy, {},
		\accz, {}
	);
};
*/


//v5 - incremental shifting
~ino.action = { |msg|
	var msgsplit = split(msg, $:);
	var header = msgsplit[0].asSymbol;
	var val = msgsplit[1].asFloat;
	//sort by header
	switch( header,
		\accx, {
			var vmp = val.linlin(-82.0, 87.0, (~xinc * -1), ~xinc);
			~xv = (~xv + vmp).max(~xmin).min(~xmax);
			~kb[0].set(~xv);
			//~xv.postln;
			},
		\accy, {
			var vmp2 = val.linlin(-82.0, 87.0, (~yinc * -1), ~yinc);
			~yv = (~yv + vmp2).max(~ymin).min(~ymax);
			~kb[1].set(~yv);
		},
		\accz, {
			var vmp3 = val.linlin(0.0, 180.0, (~zinc * -1), ~zinc);
			~zv = (~zv + vmp3).max(~zmin).min(~zmax);
			~kb[2].set(~zv);
		}
	);
};

SynthDef(\acctest, {
	arg pitch=60;
	var sig = SinOsc.ar(pitch.midicps);
	Out.ar(0, sig);
}).add;

a = Synth(\acctest);
a.map(\pitch, ~kb[0]);


