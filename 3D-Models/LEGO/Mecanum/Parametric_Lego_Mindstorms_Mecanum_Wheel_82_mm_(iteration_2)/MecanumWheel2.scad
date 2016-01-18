// Roller shape design according to
// http://www.chiefdelphi.com/media/papers/download/2749


$fn=100;

eps = 0.1;
bigSize = 500.0;
smallSize = 15.0;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_pinhole_r2 = PRINTABLE ? 0.0 : 0.0;
correction_pinhole_r3 = PRINTABLE ? 0.5 : 0.0;
correction_axleHoleRadius = PRINTABLE ? 0.05 : 0.0;
correction_axleHoleWidth = PRINTABLE ? 0.1 : 0.0;
correction_axleInnerRadius = PRINTABLE ? 0.1 : 0.0;
correction_radiusAxleCavity = PRINTABLE ? -0.8 : 0.0;


// lego pin hole
h1 = 7.8;
h2 = 0.7;

r1 = 23.4/2;
r2 = 4.8/2 + correction_pinhole_r2;
r3 = 6.1/2 + correction_pinhole_r3;

pitch = 8.0;


// roller
heightRoller = 30.0;
radiusWheel = 82.0/2;
radiusRoller = 15.0/2;
nrOfSteps = 40;


// roller cavity
rollerRadiusMarge = 2.0;
rollerHeightMarge = 1.0;
heightRollerCavity = heightRoller + rollerHeightMarge;
radiusWheelCavity = radiusWheel + rollerRadiusMarge;
radiusRollerCavity = radiusRoller + rollerRadiusMarge;
radiusAxleCavity = r2 + correction_radiusAxleCavity;


// mecanumwheel properties
radiusRollerAxleLocation = radiusWheel - radiusRoller;
widthMecanumWheelBase = 40.0;
innerWidthMecanumWheelBase = 2 * h1;
radiusMecanumWheelBase = radiusWheel - 1.5;
nrOfRollers = 8;


// fancy stuff
fancyAngleOffset = 4.7;
fancyTorusRadius = 2.3*pitch;
fancyTorusCylinderRadius = 4.5;
fancyTorusOffsetZ = 1.5;
fancyVerticalHoleRadius = fancyTorusCylinderRadius - 1.0;
fancyNrOfVerticalHoles = 12;
fancySphereRadius = 5;
fancySphereOffsetZ = 1.5;
fancySphereOffsetY = 3.0;
fancyInnerRadius = fancyTorusRadius + fancyTorusCylinderRadius;
fancyAngleOffsetInner = 2.5;


// axle hole
axleHoleRadius = r2 + correction_axleHoleRadius;
axleHoleLength = 2*axleHoleRadius;
axleHoleWidth = 2.3 + correction_axleHoleWidth;
axleInnerRadius = 3.6/2 + correction_axleInnerRadius;
axleLength = 39.6;


// bearing
radiusBearingHole = 7.0;
thicknessBearing = 3.0;



function calcF(S,D) = sqrt(2*D*D+S*S);
	
function calcG(S,D) = sqrt(4*D*D+S*S);

function calcT(S,D,R) = sqrt(2)*R/calcF(S,D);

function calcH(S,D,R) = S/2*(calcT(S,D,R)+1);

function calcRr(S,D,R) = calcG(S,D)/2*(calcT(S,D,R)-1);


module drawHalfRollerFlat(prmRadiusWheel,prmRadiusRoller,prmHeightRoller)
{
	D = prmRadiusWheel - prmRadiusRoller;
	R = prmRadiusWheel;
	H = prmHeightRoller;
	for (i = [1:nrOfSteps-1]) {
		assign(S=(i/(nrOfSteps-1))*H/2, prevS=((i-1)/(nrOfSteps-1))*H/2) {
			assign(x2 = calcH(S,D,R), y2 = calcRr(S,D,R), x1 = calcH(prevS,D,R), y1 = calcRr(prevS,D,R)) {
				polygon([[x1,0],[x2,0],[x2,y2],[x1,y1],[x1,0]]);
			}
		}
	}
}


module drawRollerFlatFixedLength(prmRadiusWheel,prmRadiusRoller,prmHeightRoller)
{
	difference() 
	{
		drawHalfRollerFlat(prmRadiusWheel,prmRadiusRoller,prmHeightRoller);
		translate([prmHeightRoller/2,-bigSize/2,0]) square([bigSize,bigSize]);
	}
}


module drawRollerFlat(prmRadiusWheel,prmRadiusRoller,prmHeightRoller)
{
	drawRollerFlatFixedLength(prmRadiusWheel,prmRadiusRoller,prmHeightRoller);
	mirror([1,0,0]) drawRollerFlatFixedLength(prmRadiusWheel,prmRadiusRoller,prmHeightRoller);
}


module drawRoller(prmRadiusWheel,prmRadiusRoller,prmHeightRoller,prmAddExtrusion)
{
	rotate_extrude(convexity = 10, $fn = 100) rotate([0,0,90]) drawRollerFlat(prmRadiusWheel,prmRadiusRoller,prmHeightRoller);
	if (prmAddExtrusion) {
		rotate([0,270,0]) linear_extrude(height = bigSize, convexity = 10, twist = 0) {
			drawRollerFlat(prmRadiusWheel,prmRadiusRoller,prmHeightRoller);
			mirror([0,1,0]) drawRollerFlat(prmRadiusWheel,prmRadiusRoller,prmHeightRoller);
		}
	}
}


module drawPinHole()
{
	translate([0,0,-eps]) cylinder(h2+eps, r3, r3);
	translate([0,0,h2-eps]) cylinder(h1-2*h2+2*eps, r2, r2);
	translate([0,0,h1-h2]) cylinder(h2+eps, r3, r3);
}


module drawDoublePinHole()
{
	drawPinHole();
	translate([0,0,h1]) drawPinHole();
}


module drawDoublePinHolePassThrough()
{
	drawDoublePinHole();
	translate([0,0,-bigSize]) cylinder(bigSize, r2, r2);
}


module drawAxleHole(prmHeight)
{	
	difference()
	{
		union()
		{
			translate([-axleHoleLength/2,-axleHoleWidth/2,-eps]) cube([axleHoleLength, axleHoleWidth, prmHeight+2*eps]);
			rotate([0,0,90]) translate([-axleHoleLength/2,-axleHoleWidth/2,-eps]) cube([axleHoleLength, axleHoleWidth, prmHeight+2*eps]);
			translate([0,0,-eps]) cylinder(prmHeight+2*eps, axleInnerRadius, axleInnerRadius);
		}
		union()
		{
			difference()
			{
				translate([0,0,-2*eps]) cylinder(prmHeight+4*eps, bigSize, bigSize);
				translate([0,0,-2*eps]) cylinder(prmHeight+4*eps, axleHoleRadius, axleHoleRadius);
			}
		}
	}
}


module drawRollerWithAxle()
{
	drawRoller(radiusWheel,radiusRoller,heightRoller,false);
	translate([0,0,-axleLength/2]) drawAxleHole(axleLength);
}


module drawRollerWithAxleHole()
{
	difference()
	{
		drawRoller(radiusWheel,radiusRoller,heightRoller,false);
		translate([0,0,-heightRoller/2-eps]) drawAxleHole(heightRoller+2*eps);
	}
}


module drawBearingHole()
{
	cylinder(bigSize,radiusBearingHole,radiusBearingHole);
}


module drawRollerCavity(prmAngleX)
{
	drawRoller(radiusWheelCavity,radiusRollerCavity,heightRollerCavity,true);
	translate([0,0,-heightRollerCavity/2-bigSize-eps]) cylinder(bigSize+eps, radiusAxleCavity, radiusAxleCavity);
	translate([0,0,heightRollerCavity/2-eps]) cylinder(bigSize+eps, radiusAxleCavity, radiusAxleCavity);	
	translate([0,0,heightRollerCavity/2+thicknessBearing]) drawBearingHole();
	translate([0,0,-heightRollerCavity/2-thicknessBearing]) rotate([180,0,0]) drawBearingHole();
}


module drawRollerEx(prmIsHole,prmAngleX)
{
	if (prmIsHole) drawRollerCavity(prmAngleX,prmIsHole); else drawRollerWithAxle();
}


module drawRollers(prmIsHole,prmIsLeft)
{
	angleX = prmIsLeft ? 45 : -45;
	for (i = [0:nrOfRollers-1]) {
		assign(angle=i*360/nrOfRollers) {	
			rotate([0,0,angle]) translate([-radiusRollerAxleLocation,0,0]) rotate([angleX,0,0]) rotate([90,0,0]) drawRollerEx(prmIsHole,angleX);
		}
	}
}


module drawFancyAngleFlat()
{
	translate([radiusWheel-fancyAngleOffset,0,0]) polygon([[0,-eps],[smallSize+eps,-eps],[smallSize+eps,smallSize+eps],[0,-eps]]);
}


module drawFancyAngle()
{
	rotate_extrude(convexity = 10, $fn = 100) rotate([90,0,0]) drawFancyAngleFlat();
}


module drawFancyAngleFlatInner()
{
	translate([fancyInnerRadius-smallSize+fancyAngleOffsetInner,0,0]) polygon([[-eps,-eps],[-eps,smallSize+eps],[smallSize+eps,-eps],[-eps,-eps]]);
}


module drawFancyAngleInner()
{
	rotate_extrude(convexity = 10, $fn = 100) rotate([90,0,0]) drawFancyAngleFlatInner();
}


module drawFancyTorus() {
	rotate([0,0,180]) {
		rotate_extrude(convexity = 10, $fn = 100) {
					translate([fancyTorusRadius, 0, 0])
					circle(r = fancyTorusCylinderRadius);
		}
	}
}


module drawFancyVerticalHoles() {
	offsetAngle = 0.5*360/fancyNrOfVerticalHoles;
	for (i = [0:fancyNrOfVerticalHoles-1]) {
		assign(angle=i*360/fancyNrOfVerticalHoles+offsetAngle) {	
			rotate([0,0,angle]) translate([-fancyTorusRadius,0,0]) translate([0,0,-bigSize/2]) cylinder(bigSize,fancyVerticalHoleRadius,fancyVerticalHoleRadius);
		}
	}
}


module drawFancySphereHoles(prmIsLeft,prmIsTop)
{
	offsetY1 = prmIsTop ? fancySphereOffsetY : -fancySphereOffsetY;
	offsetY2 = prmIsLeft ? -offsetY1 : offsetY1; 
	offsetZ = prmIsTop ? fancySphereOffsetZ : -fancySphereOffsetZ;
	topFactor = prmIsTop ? 0.5 : 1;
	R = ((fancyTorusRadius + fancyTorusCylinderRadius) + (radiusWheel-topFactor*fancyAngleOffset)) / 2;
	for (i = [0:nrOfRollers-1]) {
		assign(angle=i*360/nrOfRollers) {	
			rotate([0,0,angle]) translate([R,offsetY2,offsetZ]) sphere(fancySphereRadius);
		}
	}
}


module drawBase(prmIsLeft) 
{
	difference()
	{
		union()
		{	
			translate([0,0,-widthMecanumWheelBase/2]) cylinder(widthMecanumWheelBase,radiusMecanumWheelBase,radiusMecanumWheelBase);
		}
		union()
		{	
			translate([0,0,-widthMecanumWheelBase/2+innerWidthMecanumWheelBase]) cylinder(bigSize,fancyInnerRadius,fancyInnerRadius);
			translate([0,0,-bigSize/2]) drawAxleHole(bigSize);
			drawFancyVerticalHoles();

			// top
			translate([0,0,widthMecanumWheelBase/2-2*h1])
			{
				rotate([0,0,0]) translate([0,pitch,0]) drawDoublePinHolePassThrough();
				rotate([0,0,90]) translate([0,pitch,0]) drawDoublePinHolePassThrough();
				rotate([0,0,180]) translate([0,pitch,0]) drawDoublePinHolePassThrough();
				rotate([0,0,270]) translate([0,pitch,0]) drawDoublePinHolePassThrough();				
			}
			translate([0,0,widthMecanumWheelBase/2]) rotate([180,0,0]) drawFancyAngle();
			translate([0,0,widthMecanumWheelBase/2]) rotate([180,0,0]) drawFancyAngleInner();
			translate([0,0,-widthMecanumWheelBase/2+innerWidthMecanumWheelBase]) drawFancyTorus();
			translate([0,0,widthMecanumWheelBase/2]) drawFancySphereHoles(prmIsLeft,true);

			//bottom
			translate([0,0,-widthMecanumWheelBase/2])
			{
				rotate([0,0,0]) translate([0,pitch,0]) drawDoublePinHolePassThrough();
				rotate([0,0,90]) translate([0,pitch,0]) drawDoublePinHolePassThrough();
				rotate([0,0,180]) translate([0,pitch,0]) drawDoublePinHolePassThrough();
				rotate([0,0,270]) translate([0,pitch,0]) drawDoublePinHolePassThrough();				
			}
			translate([0,0,-widthMecanumWheelBase/2]) drawFancyAngle();
			translate([0,0,-widthMecanumWheelBase/2-fancyTorusOffsetZ]) drawFancyTorus();
			translate([0,0,-widthMecanumWheelBase/2]) drawFancySphereHoles(prmIsLeft,false);
		}
	}
}


module drawMecanumWheel(prmIsLeft)
{
	difference()
	{
		union()
		{
			drawBase(prmIsLeft);
		}
		union()
		{
			drawRollers(true,prmIsLeft);
		}
	}
}


module drawAssembly(prmIsLeft)
{
	drawMecanumWheel(prmIsLeft);
	drawRollers(false,prmIsLeft);
}



// =====================================================================
// TESTING PARTS
// =====================================================================
//drawPinHole();
//drawRoller(radiusWheel, radiusRoller, heightRoller);
//drawRoller(radiusWheel, radiusRoller, heightRoller,true);
//drawRollerWithAxleHole();
//drawBearingHole();
//drawRollerCavity(45);
//drawRollerWithAxle();
//drawFancyAngleFlat();
//drawFancyAngle();
//drawFancyAngleFlatInner();
//drawFancyAngleInner();
//drawBase(false);
//drawRollers(true, true);


// =====================================================================
// REAL END PRODUCTS
// =====================================================================
//drawRollerWithAxleHole();
drawMecanumWheel(false);
//drawMecanumWheel(true);
//drawAssembly(false);
//drawAssembly(true);

