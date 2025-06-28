# General guidance

Welcome to the first assignment for Clinical Trials IV. 
This dashboard will enable you to generate your data, and you'll need to keep visiting it as you progress through the stages of the trial. You'll find instructions for how to start in 'Part 1', and this tab contains some more general information.

The idea of this process is to replicate the experience of being a trial statistician, and to give you as much flexibility as possible in the design and analysis choices you make. 

If you encounter any problems (particularly with this dashboard), or if you notice any behaviour or output that seems unusual, please do send me an email: r.h.oughton@durham.ac.uk.


## What's happening under the bonnet?

The participant data is randomly generated, as are the results. The mechanisms governing them are not available to you, since that would give you the answers!

Random seeds have been used, so that if you do everything the same way (same number of participants, same allocation) it will generate exactly the same output. However, if you change those things, all outcome measurements will change.

As you work through the assignment, you may also have to use random simulation. It would be sensible at these points to set a seed, so that you can recreate your results if necessary. You can read more about using seeds in R [here](https://www.statology.org/set-seed-in-r/#:~:text=seed()%20function%20in%20R,time%20you%20run%20the%20code).

## Working with CSV files

CSV stands for 'comma-separated values', and is a text-based file format that uses commas to separate values. If you open a CSV file in a text editor, it will look something like this:

```{verbatim}
"ID","Data"
1,0.037
2,-1.11
3,-0.67
4,-1.07
5,-1.27
6,-1.37
```

Notice that within each row, the entries are separated by commas. CSV files will usually automatically open in MS Excel (or equivalent). The advantage of this very simple format is that it is (or should be!) simple to work with on a variety of different operating systems and in R. If you're working on a Mac, it is best to open the file in MS Excel (not Numbers), since this will make it easier to preserve the CSV formatting. However, there is no need to open CSV files in anything other than R.

### Reading a CSV file into R

Once you've downloaded and saved your CSV file , you'll need to load it into R so that you can work with it. If you're working in RStudio, you can find the CSV file in 'Files' (in the bottom right window) and right click to import.

You can also import a CSV in R file using the command

`df = read.csv("filepath", header=TRUE)`

Here, 'filepath' is the path to the saved CSV file from the working directory, and the imported dataset will appear in R as a data frame called `df`. Setting `header` to TRUE lets R know that the file contains column headers.

One sensible way to proceed would be to make a folder/directory for clinical trials (or for this assignment), save all related files in that folder/directory and set that as the working directory whenever working on the assignment. Then, the filepath is just the filename (including the .csv extension).

### Saving a CSV file from R

You'll also need to save a data frame in R as a CSV file, to upload to this dashboard. You can do this with the command

`write.csv(df, "filepath", row.names=FALSE, quote=FALSE)`

Here, df is the name of the data frame in R that you want to write to a file, "filepath" is the path you want the CSV file to have in relation to the working directory, including the .csv extension. If you want to save it in your working directory, filepath would be "filename.csv".

Setting `row.names` and `quote` to FALSE tells R not to add row names or to put things in quotation marks. 

**You aren't being assessed on your ability to work with CSV files, so please feel free to email me if you have problems!**


