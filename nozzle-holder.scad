nozzleDiameter=6.2;
holeDepth=10;

wallThickness=1;
zFightFix=0.01;
fontHeight=1;
height=8;
segmentLength=18;
width=25;
sizes=["0.2", "0.3", "0.4", "0.5", "0.6", "0.8", "1.0"];
count=len(sizes);

module holder(nozzleSize, fontHeight, height, segmentLength) {
  difference() {
    cube([segmentLength, width, height]);
    translate([segmentLength/4, 20, height-fontHeight]) title(nozzleSize, fontHeight);
  }
}

module title(text, fontHeight) {
  translate([0, 2, 0]) rotate([0,0,-90]) linear_extrude(height=fontHeight+zFightFix) text(text=text, size=8, font="Arial Black", $fn=64);
}

module holes() {
  for(i=[0:1:len(sizes)-1])
    translate([5+i*segmentLength ,0,nozzleDiameter/2]) rotate([90,0,0]) {
      cylinder(r1=nozzleDiameter/2, r2=nozzleDiameter/2, h=holeDepth+1+zFightFix, $fn=64);
        translate([nozzleDiameter+3, 0, 0]) cylinder(r1=nozzleDiameter/2, r2=nozzleDiameter/2, h=holeDepth+1+zFightFix, $fn=64);
    }
}

module grooves() {
  for(i=[1:1:count-1]) {
          translate([segmentLength * i, 0, height+0.5]) rotate([-90,0,0]) cylinder(r1=1, r2=1, h=width, $fn=4);
  }
}

module all() {
  union() {
    for(i=[0:1:count-1])
        translate([segmentLength * i, 0, 0]) holder(sizes[i], fontHeight, height, segmentLength);
  }
  difference() {
      minkowski() {
         cube([segmentLength*count, width, height-1]);
          sphere(r=1, $fn=32);
      }
      cube([segmentLength*count, width, height+0.01]);
  }
}

difference() {
  all();
  translate([0, holeDepth-1, 0.5]) holes();
  grooves();
};

