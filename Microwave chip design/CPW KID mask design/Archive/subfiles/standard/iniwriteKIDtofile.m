
function fid=iniwriteKIDtofile(FILE)

fclose all;
fid=fopen([FILE '.cif'],'wt');
%bla to create KIDs in L1
fprintf(fid,'(CIF written by CleWin 3.1);\n(1 unit = 0.001 micron);\n(SRON);\n(Sorbonnelaan 2);\n(3584 CA  Utrecht);\n(Nederland);\n');
fprintf(fid,'(Layer names:);\nL L1; (CleWin: 1 KIDs/0f00ff00 0f00ff00);\nL L2; (CleWin: 2 SiNfront/0f00cbff 0f00cbff);\nL L3; (CleWin: 3 Backside/0f808080 0f808080);\nL L4; (CleWin: 4 Aluminium/0fff0000 0fff0000);\nL L5; (CleWin: 5 ResistPatch/0fffff00 0fffff00);\nL L6; (CleWin: 6 Polyimide/0fff00ff 0fff00ff);\nL L7; (CleWin: 7 SiNback/f000000 0f000000);\nL L8; (CleWin: 8 empty/f00000f 0f00000f);\n');

fprintf(fid,'(Symbol definitions:);');
end