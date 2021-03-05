writetable(struct2table(result),'overall_results.xlsx','WriteMode','overwrite')
for i=2:4
    load(strcat('compV2_',string(i),'.mat'))
    writetable(struct2table(result),'overall_results.xlsx','WriteMode','Append')
end