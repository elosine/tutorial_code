SerialPort.listDevices;

~ino = ArduinoSMS("/dev/tty.usbmodem1d151", 9600);

~ino.action = {
	arg msg;
	var amsg = msg.split($:);
	//amsg.postln;
	//// bt0 ////
	if( amsg[0]=="bt0", {
		amsg[1].postln;
	});

	//// bt1 ////
	if( amsg[0]=="bt1", {
		amsg[1].postln;
	});

	//// bt2 ////
	if( amsg[0]=="bt2", {
		amsg[1].postln;
	});




};

~ino.free;