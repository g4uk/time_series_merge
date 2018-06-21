# TimeSeriesMerge


## Usage

`./bin/merge -h` for help

## Story

####Problem: Time Series Merge

Time series are stored in files with the following format:
- files are multiline plain text files in ASCII encoding
- each line contains exactly one record
- each record contains date and integer value; records are encoded like so: YYYY­MM­DD:X
- dates within single file are non­duplicate and sorted in ascending order
- files can be bigger than RAM available on target host

Script merge arbitrary number of files, up to 100, into one file. Result file follow same format
conventions as described above. Records with same date value will merged into one by summing up Xvalues.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
