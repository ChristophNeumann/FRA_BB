load('compResults1.mat')
writetable(struct2table(result),'overall_results.xlsx','WriteMode','overwrite')
indexlist = [17,101,136,255,752,830,871,1004];
for ind=1:length(indexlist)
    i=indexlist(ind);
    load(strcat('compResults',string(i),'.mat'))
    writetable(struct2table(result),'overall_results.xlsx','WriteMode','Append')
end