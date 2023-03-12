no = library("noises.lib");
re = library("reverbs.lib");

resonator(fr, bw, g) = firpart : + ~ feedback
with {
  //bw = 50; fr = 2200; 
  // parameters - see caption
  SR = fconstant(int fSamplingFreq, <math.h>); // Faust fn
  pi = 4*atan(1.0);    // circumference over diameter
  R = exp(0-pi*bw/SR); // pole radius [0 required]
  A = 2*pi*fr/SR;      // pole angle (radians)
  RR = R*R;
  firpart(x) = (x - x'') * g * ((1-RR)/2);
  // time-domain coefficients ASSUMING ONE PIPELINE DELAY:
  feedback(v) = 0 + 2*R*cos(A)*v - RR*v';
};
nResonators = hslider("nRenators[OWL:A]",4,1,50,1);
bandwidth = hslider("Bandwidth[OWL:B]",40,10,1000,10);
spectrum = hslider("Spectrum[OWL:C]",20000,1000,20000,100);
gainLoss = hslider("Spectrum[OWL:D]",1,0.01,1,0.01);

interval = spectrum/nResonators;

gainRes(i) = 1 - ((i*gainLoss)/(nResonators-1));

resonatorIf(i,fr, bw, g)= resonator(interval*i, bandwidth, gainRes(i)), 0 : select2(i > nResonators); 

process = no.noise <: par(i,50,resonatorIf(i,interval*i, bandwidth, gainRes(i))) :> /(nResonators) <: re.stereo_freeverb(0.5,0.5,0.9,512);
