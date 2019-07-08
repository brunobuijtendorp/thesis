
function writetofile(KID,fid,Layer)
global writestyle
% general settings
% writestyle = '% .0f, '; %R%'% .0f, '  or '% .0f ' in writeofile.m (last option is classic, first for Layoutediror
fprintf(fid,['L L' num2str(Layer) ';\n']);%printing KIDs
for i=1:length(KID)
    for j=1:size(KID{i}(:,:,:),1)
        fprintf(fid,'P ');
        fprintf(fid,writestyle,reshape(1000*KID{i}(j,:,:),1,[]));%to convert microns to nanometer
        fprintf(fid,';\n');
    end
end
end