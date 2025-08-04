if(!settings.multipleView) settings.batchView=false;
settings.tex="pdflatex";
defaultfilename="test-1";
if(settings.render < 0) settings.render=4;
settings.outformat="";
settings.inlineimage=true;
settings.embed=true;
settings.toolbar=false;
viewportmargin=(2,2);

defaultpen(fontsize(10pt));
size(8cm); // set a reasonable default
usepackage("amsmath");
usepackage("amssymb");
settings.tex="pdflatex";
settings.outformat="pdf";
// Replacement for olympiad+cse5 which is not standard
import geometry;
// recalibrate fill and filldraw for conics
void filldraw(picture pic = currentpicture, conic g, pen fillpen=defaultpen, pen drawpen=defaultpen)
{ filldraw(pic, (path) g, fillpen, drawpen); }
void fill(picture pic = currentpicture, conic g, pen p=defaultpen)
{ filldraw(pic, (path) g, p); }
// some geometry
pair foot(pair P, pair A, pair B) { return foot(triangle(A,B,P).VC); }
pair orthocenter(pair A, pair B, pair C) { return orthocentercenter(A,B,C); }
pair centroid(pair A, pair B, pair C) { return (A+B+C)/3; }
// cse5 abbrevations
path CP(pair P, pair A) { return circle(P, abs(A-P)); }
path CR(pair P, real r) { return circle(P, r); }
pair IP(path p, path q) { return intersectionpoints(p,q)[0]; }
pair OP(path p, path q) { return intersectionpoints(p,q)[1]; }
path Line(pair A, pair B, real a=0.6, real b=a) { return (a*(A-B)+A)--(b*(B-A)+B); }
// cse5 more useful functions
picture CC() {
picture p=rotate(0)*currentpicture;
currentpicture.erase();
return p;
}
pair MP(Label s, pair A, pair B = plain.S, pen p = defaultpen) {
Label L = s;
L.s = "$"+s.s+"$";
label(L, A, B, p);
return A;
}
pair Drawing(Label s = "", pair A, pair B = plain.S, pen p = defaultpen) {
dot(MP(s, A, B, p), p);
return A;
}
path Drawing(path g, pen p = defaultpen, arrowbar ar = None) {
draw(g, p, ar);
return g;
}

size(250);
pair A = dir(125), B = dir(-150), C = dir(-30), H = A+B+C, M=(C+B)/2;
pair O=origin, D=foot(A,B,C), E=foot(B,C,A), F=foot(C,A,B);
pair R=extension(A,O,E,F);
pair P= 2*C*B/(C+B);
pair Q=A+P-O;
pair S=extension(E,F,P,Q);
path c1=unitcircle;
draw(c1,dotted);
draw(A--B--C--A);
draw(P--B);
draw(P--C);
draw(F--S, dashed+grey); draw(Q--S, dashed+grey);
draw(A--Q--P--O--A, blue); draw(B--E); draw(C--F);
draw(E--F);
dot("$A$",A,N); dot("$B$",B,SW);dot("$C$",C,SE); dot("$P$",P,SE);dot("$O$",O);
dot("$H$",H); dot("$D$",D,SE); dot("$E$",E,NE);dot("$F$",F,W); dot("$R$",R,W); dot("$Q$",Q,W); dot(S);
dot("$M$",M,SE);
