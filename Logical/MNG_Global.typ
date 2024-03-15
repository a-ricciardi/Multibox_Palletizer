(* 3d position *)
(* position and orientation as an euler based pose *)
(* position and orientation as a 4x4 matrix *)

TYPE
	VEC3 : 	STRUCT 
		x : REAL;
		y : REAL;
		z : REAL;
	END_STRUCT;
	POSE6 : 	STRUCT 
		x : REAL;
		y : REAL;
		z : REAL;
		a : REAL;
		b : REAL;
		c : REAL;
	END_STRUCT;
	TRAFO : 	STRUCT 
		baseX : VEC3;
		fill0 : REAL;
		baseY : VEC3;
		fill1 : REAL;
		baseZ : VEC3;
		fill2 : REAL;
		origin : VEC3;
		fill3 : REAL;
	END_STRUCT;
END_TYPE
