
ALPHA_MULTILAYER

start_Model Version
	1	
end_Model Version

start_Model Parms
	3	0	
	-0.04180765547465121	T	-5.0	5.0	F	'Angle Offset'	F	F	0.0	0.0	100000.0	F	100.0	
	T	
	42.576749994034095	T	-200.0	500.0	F	'Roughness'	F	F	0.0	0.0	100000.0	F	100.0	
	F	
	100	
	'(none)'	
	0.0	
	0.0	
	0	
	
	'(none)'	
	0.0	
	0.0	
	0	
	
	'(none)'	
	0.0	
	0.0	
	0	
	
	F	
	5.0	F	0.0	20.0	F	'# Back Reflections'	F	F	0.0	0.0	100000.0	F	100.0	
	100.0	F	0.0	100.0	F	'% 1st Reflection'	F	F	0.0	0.0	100000.0	F	100.0	
	
	F	
	3700.0	9000.0	
	F	
	'N,C,S'	
	T	
	F	
	20	
	0.0	F	0.0	50.0	F	'Bandwidth (eV)'	F	F	0.0	0.0	100000.0	F	100.0	
	9	
	F	
	T	
	F	
	F	
	5000.0	9000.0	
	F	
	5	
	F	
	F	
	'Ideal'	
	0.0	F	0.0	100.0	F	'% Thickness Non-uniformity'	F	F	0.0	0.0	100000.0	F	100.0	
	0.0	F	0.0	30.0	F	'Bandwidth (nm)'	F	F	0.0	0.0	100000.0	F	100.0	
	F	
	
	start_Ambient
		F	
		'(Not Specified)'	
		
	end_Ambient
	
	start_ScatteringFactor
		F	
		'(Not Specified)'	
		
	end_ScatteringFactor
	F	
	F	
	100.0	
	100.0	
	0.0	F	-5.0	5.0	F	'Wvl. Shift (nm)'	F	F	0.0	0.0	100000.0	F	100.0	
	
	start_Simulation
		250.0	1000.0	5.0	45.0	75.0	10.0	100.0	F	0.5	
		F	
		1	
		0.0	F	0.0	10.0	F	'Angular Spread'	F	F	0.0	0.0	100000.0	F	100.0	
		'None'	
		0.0	F	-20.0	20.0	F	'#1'	F	F	0.0	0.0	100000.0	F	100.0	
		0.0	F	-20.0	20.0	F	'#2'	F	F	0.0	0.0	100000.0	F	100.0	
		0.0	F	-20.0	20.0	F	'#3'	F	F	0.0	0.0	100000.0	F	100.0	
		0.0	F	-20.0	20.0	F	'#4'	F	F	0.0	0.0	100000.0	F	100.0	
		0.0	F	-180.0	180.0	F	'Source Rot.'	F	F	0.0	0.0	100000.0	F	100.0	
		0.0	F	-180.0	180.0	F	'Receiver Rot.'	F	F	0.0	0.0	100000.0	F	100.0	
		F	
	end_Simulation
	
	start_MultiSamp
		0	0	
		
	end_MultiSamp
	
	start_ParmCoupling
		0	
		
	end_ParmCoupling
	0.5	
	'Standard Ellipsometric'	
	0	
	50	
	F	
	'(none)'	
	5	
	0.0	F	0.0	1000.0	F	'Smear Width'	F	F	0.0	0.0	100000.0	F	100.0	
	F	
	0	
	
	start_BW Conv
		'Gaussian'	
		0.0	F	0.0	1.0	F	'Exp. Relative Amp.'	F	F	0.0	0.0	100000.0	F	100.0	
		1.0	F	0.0	50.0	F	'Exp. Relative Width'	F	F	0.0	0.0	100000.0	F	100.0	
		F	
		
	end_BW Conv
	
end_Model Parms

start_Derived Parms
	T	
	
end_Derived Parms

start_Derived Parms 2
	'Total Thickness'	1	6328.0	0.0	0.0	F	
	
end_Derived Parms 2

start_Previous Results
	F	
	''	
	
end_Previous Results

start_Selected Options
	
	start_Options_Model Options
		F	
		F	
		F	
		F	
		F	
		F	
		F	
		F	
		F	
		F	
		
	end_Options_Model Options
	
	start_Options_Fit Options
		F	
		F	
		F	
		F	
		F	
		
	end_Options_Fit Options
	
	start_Options_Other Options
		F	
		F	
		
	end_Options_Other Options
	
end_Selected Options

start_Model Structure
	
	start_Layer0
		5000000.0	F	-10.0	100000.0	F	'Substrate Thickness'	F	F	0.0	0.0	100000.0	F	100.0	
		'Layer'	'SI_JAW'	'EV'	''	
		start_File Info
			'Si substrate, Herzinger et.al., JAP v83p3323y1998, (multi-wavelength, multi-sample analysis)'	
			1	
			
		end_File Info
		
		start_Mat Table
			636	
			
			start_Wvl Array
				'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'	
			end_Wvl Array
			
			start_e1 Array
				'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'	
			end_e1 Array
			
			start_e2 Array
				'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'	
			end_e2 Array
			
		end_Mat Table
		
		start_SI_JAW Fit Parms
			
		end_SI_JAW Fit Parms
		
	end_Layer0
	
	start_Layer1
		1014.0534282104578	T	-10.0	100000.0	F	'Thickness # 1'	T	T	0.0	0.0	100000.0	F	100.0	
		'Layer'	'SIO2_JAW'	'EV'	''	
		start_File Info
			'Thermal SiO2, Herzinger et.al., JAP v83p3323y1998, (multi-wavelength, multi-sample analysis)'	
			1	
			
		end_File Info
		
		start_Mat Table
			586	
			
			start_Wvl Array
				'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'	
			end_Wvl Array
			
			start_e1 Array
				'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'	
			end_e1 Array
			
			start_e2 Array
				'H4sIAAAAAAAAAO3BgQAAAADDoPlTX+AIVQEA8AxP8KndKAkAAA=='	
			end_e2 Array
			
		end_Mat Table
		
		start_SIO2_JAW Fit Parms
			
		end_SIO2_JAW Fit Parms
		
	end_Layer1
	
	start_Layer2
		2612.2618669219733	T	-10.0	100000.0	F	'Thickness # 2'	F	F	0.0	0.0	100000.0	F	100.0	
		'Layer'	'EMA'	'EMA'	''	
		start_EMA Fit Parms
			'2'	
			'Bruggeman'	
			0.3333333333333333	F	0.0	1.0	F	'depolarization'	F	F	0.0	0.0	100000.0	F	100.0	
			'a-Si parameterized'	'GENOSC'	''	
			start_a-Si parameterized Misc Parms
				1	T	
				
			end_a-Si parameterized Misc Parms
			
			start_a-Si parameterized Fit Parms
				1	1.0	F	0.0	10.0	F	'Einf'	F	F	0.0	0.0	100000.0	F	100.0	
				'Cody-Lorentz'	
				121.87393563955695	F	0.0010	1000.0	F	'Amp'	F	F	0.0	0.0	100000.0	F	100.0	
				2.546546894485807	F	1.0E-4	1000.0	F	'Br'	F	F	0.0	0.0	100000.0	F	100.0	
				3.5938735374051753	F	1.0E-4	15.0	F	'Eo'	F	F	0.0	0.0	100000.0	F	100.0	
				1.582921269263096	F	0.0	15.0	F	'Eg'	F	F	0.0	0.0	100000.0	F	100.0	
				1.9429000494498927	F	0.0010	15.0	F	'Ep'	F	F	0.0	0.0	100000.0	F	100.0	
				0.0	F	0.0	15.0	F	'Et'	F	F	0.0	0.0	100000.0	F	100.0	
				0.5	F	0.0010	15.0	F	'Eu'	F	F	0.0	0.0	100000.0	F	100.0	
				F	
				
			end_a-Si parameterized Fit Parms
			
			start_a-Si parameterized Grade Parms
				F	
				0.0	F	-1000.0	1000.0	F	'Grade 1'	F	F	0.0	0.0	100000.0	F	100.0	
				0.0	F	-1000.0	1000.0	F	'Grade 2'	F	F	0.0	0.0	100000.0	F	100.0	
				F	
				0.0	F	-1000.0	1000.0	F	'Grade 1'	F	F	0.0	0.0	100000.0	F	100.0	
				0.0	F	-1000.0	1000.0	F	'Grade 2'	F	F	0.0	0.0	100000.0	F	100.0	
				F	
				0.0	F	-1000.0	1000.0	F	'Grade 1'	F	F	0.0	0.0	100000.0	F	100.0	
				0.0	F	-1000.0	1000.0	F	'Grade 2'	F	F	0.0	0.0	100000.0	F	100.0	
				F	
				0.0	F	-1000.0	1000.0	F	'Grade 1'	F	F	0.0	0.0	100000.0	F	100.0	
				0.0	F	-1000.0	1000.0	F	'Grade 2'	F	F	0.0	0.0	100000.0	F	100.0	
				F	
				0.0	F	-1000.0	1000.0	F	'Grade 1'	F	F	0.0	0.0	100000.0	F	100.0	
				0.0	F	-1000.0	1000.0	F	'Grade 2'	F	F	0.0	0.0	100000.0	F	100.0	
				F	
				0.0	F	-1000.0	1000.0	F	'Grade 1'	F	F	0.0	0.0	100000.0	F	100.0	
				0.0	F	-1000.0	1000.0	F	'Grade 2'	F	F	0.0	0.0	100000.0	F	100.0	
				F	
				0.0	F	-1000.0	1000.0	F	'Grade 1'	F	F	0.0	0.0	100000.0	F	100.0	
				0.0	F	-1000.0	1000.0	F	'Grade 2'	F	F	0.0	0.0	100000.0	F	100.0	
				
			end_a-Si parameterized Grade Parms
			
			start_a-Si parameterized Permanent Poles
				0.0	F	-1000.0	1000.0	F	'UV Pole Amp.'	F	F	0.0	0.0	100000.0	F	100.0	
				11.0	F	1.0E-8	15.0	F	'UV Pole En.'	F	F	0.0	0.0	100000.0	F	100.0	
				0.0	F	-1000.0	1000.0	F	'IR Pole Amp.'	F	F	0.0	0.0	100000.0	F	100.0	
				
			end_a-Si parameterized Permanent Poles
			'Void'	'ANGSTROMS'	''	
			start_File Info
				''Void' material'	
				1	
				
			end_File Info
			
			start_Mat Table
				2	
				
				start_Wvl Array
					'H4sIAAAAAAAAAHNUYGDwcA5gAACZOm/ZCAAAAA=='	
				end_Wvl Array
				
				start_e1 Array
					'H4sIAAAAAAAAALNvYGCwB2IAPYek+AgAAAA='	
				end_e1 Array
				
				start_e2 Array
					'H4sIAAAAAAAAAGNggAAAad8iZQgAAAA='	
				end_e2 Array
				
			end_Mat Table
			
			start_Void Fit Parms
				
			end_Void Fit Parms
			1.9263239452909549	T	-10.0	100.0	F	'EMA % (Mat 2)'	F	F	0.0	0.0	100000.0	F	100.0	
			
		end_EMA Fit Parms
		
	end_Layer2
	
end_Model Structure
