
function closewriteKIDtofile(fid,synumber)
%synumber is number of the symbol, should be 1 higher than highest symbol # used.
fprintf(fid,['DF;\nC ' num2str(synumber) ';\nE\n']);
fclose(fid);
end
