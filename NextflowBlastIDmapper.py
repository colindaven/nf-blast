#!/usr/bin/python3
import os
import sys
import string
import re

## Colin Davenport, September 2018

# Reads in all Uniprot BLAST headers
# Reads in all Nextflow Blast hit IDs
# Maps name to ID and appends to Nextflow blast results

if (len(sys.argv) <= 2):		
	print("Nextflow BLAST ID Mapper/Annotator")
	print("Usage: python3 NextflowBlastIDmapper.py input_filt.csv output.txt")
	sys.exit(0)

splitLine = []

# Read all nt headers into dictionary
headersDict={}
#with open ("/mnt/ngsnfs/seqres/nt_db/nt_headers_500k.txt", "r") as blastHeaderFile:
with open ("/mnt/ngsnfs/seqres/nt_db/nt_2018/nt_headers.txt", "r") as blastHeaderFile:
	for line in blastHeaderFile.readlines():
		# Remove first character >
		line = line[1:]
		splitLine = line.split(" ")
		ID = splitLine[0]
		#print('ID in dict', ID)
		headersDict[ID] = line


# Read Nextflow blast file to be annotated
blastResultFile = open(sys.argv[1], 'r')
blastline = blastResultFile.readline()

outFile = open(sys.argv[2], 'w')

if blastline != "":

	counter = 1
	hits = 0
	noHit = 0

	while blastline != "":

		#remove line break chars
		if blastline[-1:] == '\n':
		   blastline = blastline[:-1]

		#split line by any number of spaces
		posSplitLine = re.split(' +', blastline)

		sequenceID = posSplitLine[len(posSplitLine)-1]
		#print('posSplitLine ', posSplitLine)
		#print('sequenceID ', sequenceID)

		outString = ''
		try:
			outString = blastline + " " + headersDict[sequenceID]
			hits = hits + 1
		except:
			noHit = noHit + 1
	
		if outString != "":
			outFile.write(outString)


		blastline = blastResultFile.readline()

print("Number of ID hits: "+str(hits))

#print(dict.keys()[1190])
#print(dict[.keys()[1192])


blastResultFile.close()
blastHeaderFile.close()
outFile.close()
