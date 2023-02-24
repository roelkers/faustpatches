import("stdfaust.lib");
import("owl.lib");
import("all.lib");

declare owl "[voct:input]";

tune = hslider("Tune[OWL:A]", 0, -2, 2, 0.01);

/////////////////////////////////////////////////////////
// UI ELEMENTS
/////////////////////////////////////////////////////////

//frequency = hslider("Frequency", 0, 0, 10000,0.01);

// GENERAL, Keyboard
crossfm = hslider("Crossfm[OWL:D]",0,0,1000,0.01);
spread = hslider("Spread[OWL:B]",0,0,1,0.001);
bal = hslider("balance[OWL:C]", 1.01,1.01,16,0.001);

numOscs = 16;

//============================================ DSP =======================================
//========================================================================================

fosc(i,f) = f * (1 + i * spread) : quantize(f, eolian);
//f2(f) = f * (1 + spread) : qu.quantize(pitch, qu.eolian); 
//f3(f) = f * (1 + 2* spread) : qu.quantize(pitch, qu.eolian); 
//f4(f) = f * (1 + 4* spread) : qu.quantize(pitch, qu.eolian); 

gainComp(n) = n/sum(i,n,i);

ensosc1(n,f) = (1 - abs(1 / (n-1) * (bal - 1))) * os.osci(fosc(1,f));
ensosc(i,n,f) = (1 - abs(1 / (n-1) * (bal - i))) * os.osci(fosc(i,f) + crossfm * ensosc1(n,fosc(1,f)));
//osc2(f) = os.osci(f2(f) + crossfm * osc1(f1(f)));
//osc3(f) = os.osci(f3(f) + crossfm * osc2(f2(f)));
//osc4(f) = os.osci(f4(f) + crossfm * osc3(f3(f)));

FMall(f) = sum(i,numOscs,ensosc(i,numOscs,f)) * gainComp(numOscs);

process = sample2hertz(tune): FMall;
