function [newTable] = RenameTable(table)
%takes table from ReadTable and names fields after col names.
%table = RenameTable(ReadTable('filename');


for i=1:length(table.cols_names)
    comString = ['newTable.' table.cols_names{i} ' = table.col' num2str(i) ';'];
    eval(comString);
end
