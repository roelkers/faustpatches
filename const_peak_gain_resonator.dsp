no = library("noises.lib");


process = no.noise: firpart : + ~ feedback
with {
  bw = 50; fr = 300; g = 1; // parameters - see caption
  SR = fconstant(int fSamplingFreq, <math.h>); // Faust fn
  pi = 4*atan(1.0);    // circumference over diameter
  R = exp(0-pi*bw/SR); // pole radius [0 required]
  A = 2*pi*fr/SR;      // pole angle (radians)
  RR = R*R;
  firpart(x) = (x - x'') * g * ((1-RR)/2);
  // time-domain coefficients ASSUMING ONE PIPELINE DELAY:
  feedback(v) = 0 + 2*R*cos(A)*v - RR*v';
};
