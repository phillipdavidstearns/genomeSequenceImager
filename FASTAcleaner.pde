String fileName = "";
byte rawData[] = loadBytes(fileName); //loads file into array as bytes
byte cleanedData[] = new byte[rawData.length];
byte scaledData[] = new byte[rawData.length];

byte seqInt[] = new byte[rawData.length];
int byteCounter;

for (int i = 0; i < rawData.length; i++) { 
seqInt[i] = rawData[i];
//print(seqInt[i] + " "); 
} 

byteCounter=0;

for(int j = 0; j < rawData.length; j++){
    
    if (seqInt[j] == 65) {
      cleanedData[byteCounter]=seqInt[j];
      scaledData[byteCounter]=byte(0);
      byteCounter++;  
      //print ("A");
    } else if (seqInt[j] == 67) {
      cleanedData[byteCounter]=seqInt[j];
      scaledData[byteCounter]=byte(85);
      byteCounter++;
      //print ("C");
    } else if (seqInt[j] == 71) {
      cleanedData[byteCounter]=seqInt[j];
      scaledData[byteCounter]=byte(170);
      byteCounter++;
      //print ("G");
    } else  if (seqInt[j] == 84) {
      cleanedData[byteCounter]=seqInt[j];
      scaledData[byteCounter]=byte(255);
      byteCounter++;
      //print ("T");
    } else if (seqInt[j] == 78) {
      cleanedData[byteCounter]=seqInt[j];
      byteCounter++;
      scaledData[byteCounter]=byte(127);    
      //print ("N");
    } else  {

      //print(" non-valid based pair found at location: " + j + ", value = " + seqInt[j] + " ");
    }
  }

byte trimmed[] = new byte[byteCounter];
for (int k = 0; k < byteCounter; k++) { 
trimmed[k]=cleanedData[k]; 
} 


saveBytes(fileName + "_cleaned", trimmed);
saveBytes(fileName + "_scaled", scaledData);
