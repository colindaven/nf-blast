
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class ListWriter {
	
	File outFile = null;
	FileWriter outFileWriter = null;
	String outputFile = null;
	String fileNameBase = "";
	String fileName = "";
	PrintWriter outPrintWriter = null;
	List<String> headersToWrite = new ArrayList<String>();
	List<String> listToWrite = new ArrayList<String>();
	DecimalFormat df = new DecimalFormat("###.##");
	
	
	
	public void writeFile(String outputFile, List headerList, List dataList) {
		this.outputFile = outputFile;
		headersToWrite = headerList;
		listToWrite = dataList; 
		
		System.out.println(" " + outputFile);
//		fileNameBase = outputFile;		
		
		try {
			setupFiles(outputFile);
			
			for (String header : headersToWrite) {
				outPrintWriter.write(header);
				outPrintWriter.write("\n");
			}
			
			for (String pc: listToWrite) {
//				outPrintWriter.write(pc.getPeptideString() + "\t"+ pc.getObservedPeptideFreq() + "\t"+ df.format(pc.getExpectedPeptideFreq()) + "\t"+ df.format(pc.getChiSq()) +"\n");
				outPrintWriter.write(pc+"\n");
			}
			
		}
		catch (IOException e){
			e.printStackTrace();
		}
		closeFile();
		
	}
	
	public void writeFile(String outputFile, List dataList) {
		
		/**
		 * Same as method above, but without headers
		 */
		
		this.outputFile = outputFile;
//		headersToWrite = headerList;
		listToWrite = dataList; 
		
		System.out.println(" " + outputFile);
//		fileNameBase = outputFile;		
		
		try {
			setupFiles(outputFile);
			
//			for (String header : headersToWrite) {
//				outPrintWriter.write(header);
//				outPrintWriter.write("\n");
//			}
			//outPrintWriter.write("GenomePos" +"\t"+"Data"+"\n");
			for (String pc: listToWrite) {
//				outPrintWriter.write(pc.getPeptideString() + "\t"+ pc.getObservedPeptideFreq() + "\t"+ df.format(pc.getExpectedPeptideFreq()) + "\t"+ df.format(pc.getChiSq()) +"\n");
				outPrintWriter.write(pc+"\n");
			}
			
		}
		catch (IOException e){
			e.printStackTrace();
		}
		closeFile();
		
	}
	
	public void setupFiles(String fileNameBase) throws IOException {
		fileName = fileNameBase;
		outFile = new File(fileName);
		outFileWriter = new FileWriter(outFile);
		outPrintWriter = new PrintWriter(outFileWriter);
		
	}
	public void closeFile() {
		outPrintWriter.flush();
		outPrintWriter.close();
	}
	
	
}
