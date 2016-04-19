a = Synth(\test, [], gr);
SynthDef(\test, {Out.ar(0,SinOsc.ar())}).add;
g = Group.new(s);
h = Group.after(g);
s.sendMsg(\g_new, 200);
s.sendMsg(\g_new, 201, 3, 200);
s.sendMsg(\s_new, \test, 3000, 0, 200);
127.0.0.1, 57110, "/s_new", "test", 3000
s.sendMsg(\n_set, \freq, 200, \amp, 1);
a.set(\freq, 200);
s.sendMsg(\n_free, 1002);
a = Synth( \test)
a.free;
Server Command Reference
node Messaging
List of OSC Commands
s.queryAllNodes

