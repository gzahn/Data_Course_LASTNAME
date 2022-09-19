getwd()

# find all csv files in ./Data/
csv_files <- list.files(path = "Data",
                        recursive = TRUE,
                        full.names = TRUE,
                        pattern = ".csv")

# how many are there?
length(csv_files)
length(1:10)

# find just the wingspan data set
wing <- list.files(path="Data",recursive = TRUE,full.names = TRUE,
           pattern="wingspan_vs_mass.csv")

# load that wingspan data set
df <- read.csv(file = wing)

# look at first 5 lines of it
head(df,n = 5)

# ^ = 'starts with'
# $ = 'ends with'
# * = 0-Inf of anything
# . = 'any single character'

# the dumb way of reading in all 3 files' first lines
list.files(path = "Data",
           full.names = TRUE,
           recursive = TRUE,
           pattern = "^b")
readLines("Data/data-shell/creatures/basilisk.dat",n = 1)
readLines("Data/data-shell/data/pdb/benzaldehyde.pdb",n = 1)
readLines("Data/Messy_Take2/b_df.csv",n = 1)

# the slightly better way (no copypasting required)
x <- list.files(path = "Data",
           full.names = TRUE,
           recursive = TRUE,
           pattern = "^b") # save the results as 'x'
readLines(x[1],n=1) # use [] notation to access those results
readLines(x[2],n=1) # one at a time, like a chimpanzee would do it
readLines(x[3],n=1)

# for-loop for the 1st line of 'b' files
for(eachfile in x){
  print(readLines(eachfile,n=1))
}

# do the for-loop thing for all csv files
for(eachfile in csv_files){
  print(readLines(eachfile,n=1))
}




