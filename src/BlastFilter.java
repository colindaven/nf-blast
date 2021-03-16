import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

public class BlastFilter {

	public static void main(String[] args) throws Exception {
		
		/**
		* Filters and prints unique data from first column of tabular data
		* Input - tabular formatted file as first command line argument
		* Output - blast_firsthits.csv
		*/

		Hashtable<String, Boolean> ht = new Hashtable<String, Boolean>();
		String line = "";
		String inFile = args[0];
		String outFile = (args[0]);
		outFile = outFile.substring(0, (outFile.length()-4));
		outFile = outFile + "_filt.txt";
		String[] sl;
		List firstHitList = new ArrayList<String>();
		ListWriter lw = new ListWriter();

		try {	
			//reads in tabular blast output file	
			File inputFile2 = new File(inFile);
			FileReader file2 = new FileReader(inputFile2);
			BufferedReader oligoCounterResults = new BufferedReader(file2);
			line = oligoCounterResults.readLine();
//			System.out.println(line);

			while(line != null) {
				//System.out.println(line);
				sl = line.split("\t");


				if (ht.get(sl[0]) == null) {

					//first blast hit, add to list and to hashtable - tests for uniqueness
					ht.put(sl[0].toString(), true);
					line = line.replace("|","\t");
					line = line.replace("AC_000092.1","");
					firstHitList.add(line);
				}
				else {
					//not first hit, do nothing				
				}

				line = oligoCounterResults.readLine();
				if (line == null) {
					break;
				}
			}


		}
		catch (IOException e) {
			e.printStackTrace();
		}
		catch (NullPointerException n) {
			n.printStackTrace();
		}
		lw.writeFile(outFile, firstHitList);
	}
//	catch (Exception e) {
//		e.printStackTrace();
//	}
}

