## Next step: Allocation

Once you have your participant data, the next step is the allocation. Usually in a clinical trial the statistician would be blind to which arm is which, but in this trial it is known. 

The participants must each be allocated to arm "A" (control) or arm "B" (intervention) of the trial. You should store your allocation as a .csv file, with exactly the same data as in the file you downloaded, but with an extra column 'arm', containing the values 'A' and 'B'. The rows do not have to be in the same order as in the file you downloaded. You can save a data frame `df` to a CSV file in R using the command

`write.csv(df, file = "filepath", quote=FALSE, row.names=FALSE)`

Once you have performed the allocation and created the CSV file, please go to the 'Part 2' panel.