// NANCY RICO-MINEROS
// MUSIC 256A FINAL: WEIRD FISHES VIDEO GAME

// SCENE SETUP ================================================================
// CAMERA VIEW
GWindow.title("Weird Fishes");
GG.scene().light().intensity(1.5);
GG.scene() @=> GScene @ scene;
GG.camera() @=> GCamera @ cam;

// CREATE YOUR SYSTEMS
GKoi koiSystem --> GG.scene();
GClown clownSystem --> GG.scene();
GHydrophone hydrophoneSystem --> GG.scene();
GDolphin dolphinSystem --> GG.scene();

// INSTRUCTUTIONS ===============================================================
// TEXT SETUP
GText text --> GG.scene();
text.color(@(1, 0, 0.498, 1 ));
text.posY(0.1);
text.posX(-0.3);
text.sca(0.05);
text.text("Your fish is lost at sea. Help it make it back
home by creating a melody. A world of adventure is waiting 
for you. Just make sure you don't get eaten by the worms 
and weird fishes.

(That totally wasn't a Radiohead refernece lol.

If you feel so inclined to follow the weird fishes 
- follow this map:
Keyboard Pattern:
W - S - A (4x)
R - D - F (4X)
Y - H - F (2X)
T - H - F (2x)
U - G - F (4X)

and repeat :)");

// ORCA SETUP ====================================================================
GPlane orca --> GG.scene();
orca.scaX(5.0);
orca.scaY(6.0);
orca.posX(0.0);
Texture.load(me.dir() + "assets/pixel_whale.png") @=> Texture tex;
orca.colorMap(tex);

// WHALE TEXT ====================================================================
GPlane whale_text --> GG.scene();
whale_text.scaX(3);
whale_text.scaY(1);
whale_text.posY(0);
whale_text.posX(2.3);
whale_text.posZ(1);
whale_text.rotX(180 * Math.PI / 180);
Texture.load(me.dir() + "assets/whale_text.png") @=> Texture text_whale;
whale_text.colorMap(text_whale);

// BACKGROUND SETUP ==============================================================
// *** POND SETUP ***
@(0, 0.302, 0.396) => GG.scene().backgroundColor;
Texture.load(me.dir() + "assets/water.png") @=> Texture water_text;
GPoints water --> GG.scene();
[@(0, 0, -40)] @=> vec3 water_positions[];
water.texture(water_text);
water.positions(water_positions);
water.size(70);

// ORANGE FISH (SINGLE)============================================================
class GKoi extends GGen {
  GCircle koi --> this;
  FlatMaterial mat; 
  koi.scaX(0.4);
  koi.posY(-1.5);
  koi.posX(1.5);
  koi.posZ(0.4);
  koi.scaX(0.4); 
  koi.rotX(180 * Math.PI / 180);
  Texture.load(me.dir() + "assets/orangefish.png") @=> Texture tex;
  koi.colorMap(tex);
}
// WHITE FISH (CHORDS) ============================================================
class GClown extends GGen {
  GCircle clown --> this;
  FlatMaterial mat; 
  clown.scaX(4);
  clown.scaY(2);
  clown.posY(-1.1);
  clown.posZ(0.4);
  clown.rotX(180 * Math.PI / 180);
  Texture.load(me.dir() + "assets/schooloffish.png") @=> Texture tex;
  clown.colorMap(tex);
}


// HYDROPHONE WIRE ================================================================
// WINDOW SIZE
1024 => int WINDOW_SIZE;

// WIDTH OF WAVEFORM
10 => float DISPLAY_WIDTH;

// WAVEFORM READER
GLines waveform --> GG.scene(); waveform.width(.02);

// TRANSLATE THE WIRE TO WHERE THE HYDROPHONE IS
waveform.posX(1);
waveform.posY(2);
waveform.rotY(45);
waveform.color( @(0, 0, 0) );

// INPUT SETUP
dac => Gain input;
input => Flip accum => blackhole;
// TAKE THE FFT
input => PoleZero dcbloke => FFT fft => blackhole;
// SET DC BLOCKER
.95 => dcbloke.blockZero;
// SET THE SIZE OF THE FLIPPER
WINDOW_SIZE => accum.size;
// SET WINDOW SIZE AND TYPE
Windowing.hann(WINDOW_SIZE) => fft.window;
// SET FFT SIZE
WINDOW_SIZE*2 => fft.size;
// WINDOW REFERENCE
Windowing.hann(WINDOW_SIZE) @=> float window[];

// SAMPLE ARRAY
float samples[0];
// FFT RESPONSE
complex response[0];
// WINDOW POSITIONS
vec2 positions[WINDOW_SIZE];

// MAP AUDIO BUFFER ===============================================================
fun void map2waveform( float in[], vec2 out[] )
{
    if( in.size() != out.size() )
    {
        <<< "size mismatch in map2waveform()", "" >>>;
        return;
    }
    
    // MAPPING XYZ COORDINATES
    int i;
    DISPLAY_WIDTH => float width;
    for( auto s : in )
    {
        -width/2 + width/WINDOW_SIZE*i => out[i].x;
        s*2 * window[i] => out[i].y;
        i++;
    }
}
// DO AUDIO STUFF ==================================================================
fun void doAudio()
{
    while( true )
    {
        accum.upchuck();
        accum.output( samples );
        fft.upchuck();
        fft.spectrum( response );
        WINDOW_SIZE::samp/2 => now;
    }
}
spork ~ doAudio();

// NANCY LOST HER HYDROPHONE TEXT ===================================================
GPlane nancy_plane --> GG.scene();
nancy_plane.scaX(3);
nancy_plane.scaY(1);
nancy_plane.posY(4);
nancy_plane.posX(-4);
nancy_plane.posZ(1);
nancy_plane.rotX(180 * Math.PI / 180);
Texture.load(me.dir() + "assets/lol.png") @=> Texture bubble;
nancy_plane.colorMap(bubble);

// DOLPHIN CREW
class GDolphin extends GGen {
    GPlane blue_dolphin --> this;
    blue_dolphin.posY(4);
    blue_dolphin.posX(-3.5);
    blue_dolphin.scaX(3);
    blue_dolphin.scaY(2);
    blue_dolphin.rotX(180 * Math.PI / 180);
    Texture.load(me.dir() + "assets/blue_pixel_dolphin.png") @=> Texture blue;
    blue_dolphin.colorMap(blue);

    GPlane aqua_dolphin --> this;
    aqua_dolphin.posY(3.5);
    aqua_dolphin.posX(-2.5);
    aqua_dolphin.scaX(3);
    aqua_dolphin.scaY(2);
    aqua_dolphin.rotX(180 * Math.PI / 180);
    Texture.load(me.dir() + "assets/pixel_aqua_dolphin.png") @=> Texture aqua;
    aqua_dolphin.colorMap(aqua);
}

// HYRDOPHONE CLASS ===============================================================
class GHydrophone extends GGen{
    GCircle hydrophone --> this;
    hydrophone.scaX(0.2);
    hydrophone.scaY(0.2);
    hydrophone.posX(2.2);
    hydrophone.posY(1.2);
    hydrophone.posZ(-0.5);
}
fun void kbListener()
{
    // CREATE A SOUND BUFFER
    SndBuf whale_recording => dac;
    SndBuf dolphin_recording => dac;
    // SET GAIN FOR YOUR RECORDING
    whale_recording.gain(0.4);
    dolphin_recording.gain(0.4);

    // LOAD YOUR AUDIO RECORDING
    "assets/whale_recording.wav" => whale_recording.read;

    // PLAY WHALE RECORDING
    5::second => now;

}
fun void kbListener2()
{
    // CREATE A SOUND BUFFER
    SndBuf dolphin_recording => dac;
    // SET GAIN FOR YOUR RECORDING;
    dolphin_recording.gain(0.4);

    // LOAD YOUR AUDIO RECORDING
    "assets/dolphin_recording.wav" => dolphin_recording.read;
    // PLAY DOLPHIN RECORDINGS

    5::second => now;

}
fun void drumTrack(){
    SndBuf track => dac;
    "assets/drum.wav" => track.read;
    200::second => now;
} 
    
// *** MUSIC SETUP ***
// APPEGI INSTRUMENT SETUP ======================================================
Rhodey r[5];
NRev rev[2] => dac; 0.05 => rev[0].mix; 0.05 => rev[1].mix;
Rhodey solo  => rev;
Pan2 p[2]; p[0] => rev[0]; p[1] => rev[1];
Delay d[2]; rev[0] => d[0] => d[1] => rev[1]; 
0.7 => d[0].gain => d[1].gain;
second => d[0].max => d[0].delay => d[1].max => d[1].delay;
SinOsc panner => blackhole;
1 => panner.freq;
r[0] => p[0]; r[1] => p[0]; 
r[2] => p[1]; r[3] => p[1]; r[4] => p[0]; r[4] => p[1];

for (int i; i < r.cap(); i++) {
    1 => r[i].lfoSpeed;
    0.0 => r[i].lfoDepth;
    r[i].opAM(0,0.4);
    r[i].opAM(2,0.4);
    r[i].opADSR(0, 0.001, 3.50, 0.0, 0.04);
    r[i].opADSR(2, 0.001, 3.00, 0.0, 0.04);
}  

// APPEPGI PANNER SETUP ===========================================================
spork ~ doPan();
second/2 => dur Q; Q/2 => dur E; E/2 => dur S;

fun void doPan() {
    while( true ) {
        1.0 - panner.last() => float temp;
        temp => p[0].pan;
        1.0 - temp => p [1].pan;
        ms => now;
    }
}
// CHORD INSTRUMENT SETUP =========================================================
Rhodey voice => JCRev reverb => LPF lpf => dac; 
0.3 => reverb.mix;

// CHORDS WE ARE USING
[52, 59, 62, 67] @=> int EMin7[];   // Emin7
[45, 62, 64, 67] @=> int A7sus4[]; // A7sus4
[50, 59, 64, 67] @=> int EMinD[];  //  Emin/D
[42, 49, 52, 57] @=> int FSharpMin7[]; // F#Min7
[45, 49, 52, 57] @=> int AMaj[]; // AMaj
[43, 47, 50, 54] @=> int GMaj7[]; // GMaj7

// CREATE CHORD FUNCTION
fun void chord(int chord[], float vel) {
    for (int i; i < chord.cap(); i++) {
        Std.mtof(chord[i]) => r[i].freq;
        vel => r[i].noteOn;
    }
}
// CREATE ROLL FUNCTION
fun void rollChord(int chord[], float vel) {
    for (int i; i < chord.cap(); i++) {
        Std.mtof(chord[i]) => r[i].freq;
        vel => r[i].noteOn;
        Math.random2f(0.01,0.08)::second => now;
    }
}

// KEYBOARD INPUT =============================================================
fun void keyboard() {
  if (GWindow.key(87)) {
    Texture.load(me.dir() + "assets/orangefishmirrored.png") @=> Texture tex1;
    koiSystem.koi.colorMap(tex1);
    koiSystem.koi.posY() + 0.1 => koiSystem.koi.posY;
    GG.camera().posY() + 0.1 => GG.camera().posY;
    Std.mtof(62) => solo.freq; 0.2 => solo.noteOn; E => now; 
    <<< "W" >>>;
  }
  if (GWindow.key(83)) {
    Texture.load(me.dir() + "assets/orangefish.png") @=> Texture tex;
    koiSystem.koi.colorMap(tex);
    koiSystem.koi.posY() - 0.1 => koiSystem.koi.posY;
    GG.camera().posY() - 0.1 => GG.camera().posY;
    Std.mtof(55) => solo.freq; 0.3 => solo.noteOn; E => now; 
    <<< "S" >>>;
  }
  if (GWindow.key(65)) {
    Texture.load(me.dir() + "assets/orangefishmirrored.png") @=> Texture tex1;
    koiSystem.koi.colorMap(tex1);
    koiSystem.koi.posX() - 0.1 => koiSystem.koi.posX;
    GG.camera().posX() - 0.1 => GG.camera().posX;
    Std.mtof(52) => solo.freq; 0.1 => solo.noteOn; E => now;
    <<< "A" >>>;
  }
  if (GWindow.key(82)) {
    Texture.load(me.dir() + "assets/orangefish.png") @=> Texture tex;
    koiSystem.koi.colorMap(tex);
    koiSystem.koi.posX() + 0.1 => koiSystem.koi.posX;
    GG.camera().posX() + 0.1 => GG.camera().posX;
    Std.mtof(64) => solo.freq; 0.3 => solo.noteOn; E => now;
    <<< "R" >>>;
  }
  if (GWindow.key(70)) {
    Texture.load(me.dir() + "assets/orangefishmirrored.png") @=> Texture tex1;
    koiSystem.koi.colorMap(tex1);
    koiSystem.koi.posY() + 0.1 => koiSystem.koi.posY;
    GG.camera().posY() + 0.1 => GG.camera().posY;
    Std.mtof(57) => solo.freq; 0.2 => solo.noteOn; E => now; 
    <<< "F" >>>;
  }
  if (GWindow.key(68)) {
    Texture.load(me.dir() + "assets/orangefish.png") @=> Texture tex;
    koiSystem.koi.colorMap(tex);
    koiSystem.koi.posY() - 0.1 => koiSystem.koi.posY;
    GG.camera().posY() - 0.1 => GG.camera().posY;
    Std.mtof(54) => solo.freq; 0.2 => solo.noteOn; E => now;
    <<< "D" >>>;
  }
  if (GWindow.key(89)) {
    Texture.load(me.dir() + "assets/orangefishmirrored.png") @=> Texture tex1;
    koiSystem.koi.colorMap(tex1);
    koiSystem.koi.posX() - 0.1 => koiSystem.koi.posX;
    GG.camera().posX() - 0.1 => GG.camera().posX;
    Std.mtof(69) => solo.freq; 0.1 => solo.noteOn; E => now;
    <<< "Y" >>>;
  }
  if (GWindow.key(72)) {
    Texture.load(me.dir() + "assets/orangefish.png") @=> Texture tex;
    koiSystem.koi.colorMap(tex);
    koiSystem.koi.posX() - 0.1 => koiSystem.koi.posX;
    GG.camera().posX() + 0.1 => GG.camera().posX;
    Std.mtof(61) => solo.freq; 0.1 => solo.noteOn; E => now;
    <<< "H" >>>;
  }
  if (GWindow.key(84)) {  
    Texture.load(me.dir() + "assets/orangefishmirrored.png") @=> Texture tex1;
    koiSystem.koi.colorMap(tex1);
    koiSystem.koi.posY() + 0.1 => koiSystem.koi.posY;
    GG.camera().posY() + 0.1 => GG.camera().posY;
    Std.mtof(67) => solo.freq; 0.1 => solo.noteOn; E => now;
    <<< "T" >>>;
  }
  if (GWindow.key(85)) {  
    Texture.load(me.dir() + "assets/orangefish.png") @=> Texture tex;
    koiSystem.koi.colorMap(tex);
    koiSystem.koi.posY() - 0.1 => koiSystem.koi.posY;
    GG.camera().posY() - 0.1 => GG.camera().posY;
    Std.mtof(66) => solo.freq; 0.1 => solo.noteOn; E => now;
    <<< "U" >>>;
  }
  if (GWindow.key(69)) {
    Texture.load(me.dir() + "assets/orangefishmirrored.png") @=> Texture tex1;
    koiSystem.koi.colorMap(tex1);
    koiSystem.koi.posX() - 0.1 => koiSystem.koi.posX;
    GG.camera().posX() - 0.1 => GG.camera().posX;
    Std.mtof(59) => solo.freq; 0.1 => solo.noteOn; E => now;
    <<< "E" >>>;
  }
  if (GWindow.key(81)) { 
    Texture.load(me.dir() + "assets/orangefish.png") @=> Texture tex;
    koiSystem.koi.colorMap(tex); 
    koiSystem.koi.posX() + 0.1 => koiSystem.koi.posX;
    GG.camera().posX() + 0.1 => GG.camera().posX;
    Std.mtof(55) => solo.freq; 0.1 => solo.noteOn; E => now;
    <<< "Q" >>>;
  }

// SCHOOL FISH KEYBOARD KEYS
  if (GWindow.key(73)) {
    Texture.load(me.dir() + "assets/schooloffish.png") @=> Texture tex;
    clownSystem.clown.colorMap(tex);
    clownSystem.clown.posY() + 0.1 => clownSystem.clown.posY;
    GG.camera().posY() + 0.1 => GG.camera().posY;
    spork ~ rollChord(EMin7, 0.9); 
    <<< "I" >>>;
  }
  if (GWindow.key(75)) {
    Texture.load(me.dir() + "assets/schoolfishflipped.png") @=> Texture tex;
    clownSystem.clown.colorMap(tex);
    clownSystem.clown.posY() -  0.1 => clownSystem.clown.posY;
    GG.camera().posY() - 0.1 => GG.camera().posY;
    spork ~ rollChord(A7sus4, 0.9); 
    <<< "K" >>>;
  } 
  if (GWindow.key(74)) {
    Texture.load(me.dir() + "assets/schooloffish.png") @=> Texture tex;
    clownSystem.clown.colorMap(tex);
    clownSystem.clown.posX() - 0.1 => clownSystem.clown.posX;
    GG.camera().posX() - 0.1 => GG.camera().posX;
    spork ~ rollChord(EMinD, 0.9); 
    <<< "J" >>>;
  }
  if (GWindow.key(76)) {
  Texture.load(me.dir() + "assets/schoolfishflipped.png") @=> Texture tex;
  clownSystem.clown.colorMap(tex);
  clownSystem.clown.posX() + 0.1 => clownSystem.clown.posX;
  GG.camera().posX() + 0.1 => GG.camera().posX;
  spork ~ rollChord(FSharpMin7, 0.9); 
  <<< "L" >>>;
  }
  if (GWindow.key(79)) {
  Texture.load(me.dir() + "assets/schooloffish.png") @=> Texture tex;
  clownSystem.clown.colorMap(tex);
  clownSystem.clown.posY() + 0.1 => clownSystem.clown.posY;
  GG.camera().posY() + 0.1 => GG.camera().posY;
  spork ~ rollChord(AMaj, 0.9); 
  <<< "O" >>>;
  }
  if (GWindow.key(80)) {
    Texture.load(me.dir() + "assets/schoolfishflipped.png") @=> Texture tex;
    clownSystem.clown.colorMap(tex);
    clownSystem.clown.posY() -  0.1 => clownSystem.clown.posY;
    GG.camera().posY() - 0.1 => GG.camera().posY;
    spork ~ rollChord(GMaj7, 0.9); 
    <<< "P" >>>;
  }
  // WHALE NOISE KEYBOARD CONTROLS
   if (GWindow.keyDown(32)){
    Texture.load(me.dir() + "assets/orangefish.png") @=> Texture hydro;
    hydrophoneSystem.hydrophone.colorMap(hydro);
    hydrophoneSystem.hydrophone.posX() - 0.1 => hydrophoneSystem.hydrophone.posX;
    spork ~ kbListener();
  }

  if (GWindow.keyUp(32)){
    Texture.load(me.dir() + "assets/fishbone.png") @=> Texture hydro;
    hydrophoneSystem.hydrophone.colorMap(hydro);
    hydrophoneSystem.hydrophone.posX() - 0.1 => hydrophoneSystem.hydrophone.posX;
    spork ~ kbListener();
  }
  // DOLPHIN LAUGH
  if (GWindow.keyDown(46)){
    spork ~kbListener2();
  }

  // Play Audio Track
  if (GWindow.key(48)){
    spork ~ drumTrack();
  }
}
// GENERATE FLOWERS ===============================================================
GLotus lotusSystem --> GG.scene();
GLotus1 lotusSystem1 --> GG.scene();
GLotus2 lotusSystem2 --> GG.scene();
GBlob blobSystem --> GG.scene();

// FLOWER CLASS ====================================================================
class GLotus extends GGen{
  GPlane lotus --> GG.scene();
  lotus.scaX(1.0);
  lotus.scaY(1.0);
  lotus.posX(2.5);
  lotus.posY(-1.0);
  lotus.posZ(0.0);
  lotus.rotX(180 * Math.PI / 180);
  Texture.load(me.dir() + "assets/pixel_flower.png") @=> Texture flower_text;
  lotus.colorMap(flower_text);
}
class GLotus1 extends GGen{
  GPlane lotus1 --> GG.scene();
  lotus1.scaX(1.0);
  lotus1.scaY(1.0);
  lotus1.posX(-4.0);
  lotus1.posY(3.0);
  lotus1.posZ(0.0);
  lotus1.rotX(180 * Math.PI / 180);
  Texture.load(me.dir() + "assets/pixel_flower.png") @=> Texture flower_text;
  lotus1.colorMap(flower_text);
}

class GLotus2 extends GGen{
  GPlane lotus2 --> GG.scene();
  lotus2.scaX(1.0);
  lotus2.scaY(1.0);
  lotus2.posX(-5.0);
  lotus2.posY(0.0);
  lotus2.posZ(0.0);
  lotus2.rotX(180 * Math.PI / 180);
  Texture.load(me.dir() + "assets/purpleflower.png") @=> Texture flower_text2;
  lotus2.colorMap(flower_text2);
}

class GBlob extends GGen{
  GPlane blob --> GG.scene();
  blob.scaX(1.0);
  blob.scaY(1.0);
  blob.posX(-3.0);
  blob.posY(2.0);
  blob.posZ(0.0);
  blob.rotX(180 * Math.PI / 180);
  Texture.load(me.dir() + "assets/pixel_blob.png") @=> Texture flower_text2;
  blob.colorMap(flower_text2);
}

// GAME LOOP ===================================================================
while (true)
{
      // map to interleaved format
    map2waveform( samples, positions );
    // set the mesh position
    waveform.positions( positions );
    // map to spectrum display
    // map2spectrum( response, positions );
  GG.nextFrame() => now; 
  keyboard();
}   

// =============================================================================























































