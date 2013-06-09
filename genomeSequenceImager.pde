//genomeSequenceImager - Last Update 08 June 2013
//Open a file and read its binary data 
//Load a file containing UTF-8 characters "A", "T", "G", & "C" into an array of bytes
//Convert those to an array of bits as bytes containing only 0 or 1 two bits at a time for each base pair
//interpret the array of bits as RGB values grouped in pairs for each color channel RGB
//each pixel represents three base pairs in the sequence

//Contains Code from "ByteWriter" - Last Update 29 May 2013
//This program was written by Jeroen Holtuis and Phillip Stearns,
//inspired by the LoomPreview application developed by Paul Kerchen.
//It's purpose is to provide a flexible tool for visualizing raw binary data.
//This preliminary program only offers translation of binary data to 0-8 bits per channel RGB
//shift+s to save output

// Jeroen Holthuis: http://www.jeroenholthuis.nl/
// Phillip Stearns: http://phillipstearns.com
// Paul Kerchen: http://github.com/kerchen

//byte imgBytes[];

int bRed = 2; // set bit resolution for red channel pixel value in Color mode
int bGreen = 2; // set bit resolution for gree channel pixel value in Color mode
int bBlue = 2; // set bit resolution for blue channel pixel value in Color mode
int bppColor = bRed + bGreen + bBlue; //total number of bits per pixel
int imgWidth =500;   //set image width here
int imgHeight = 0;  //optional
int imgLength = 0;     //calculated later from file size and rendering method
int numPixel = 0;      //calculated later from file size and rendering method
byte rawData[];        //contains raw file data
byte rawBits[];        //contains a binary representation of raw file data
byte groupedBits[];    //contains bits, grouped into a color byte, with bits length specified by bit resolutions for each (color) channel specified aboveint numBits;
String fileName = "Homo sapiens chromosome 15 genomic contig, GRCh37.p10 Primary Assembly"; //give path and file name to render (keep under 30MB!!!) see "split" terminal command for MacOSX for help breaking files into managable chunks
int seqInt[];


void setup(){  
  rawData = loadBytes(fileName); //loads file into array as bytes
  int numBits = rawData.length * 2; //stores file length in bits
  rawBits = new byte[2*rawData.length];
  numPixel = (numBits / bppColor);
  groupedBits = new byte[(numPixel+imgWidth) * 3];
  imgLength = (numPixel / imgWidth) + 1; //calcutlate image length
  seqInt = new int[rawData.length]; //holds int values of rawData[]


size(imgWidth, imgLength);



convertSequenceToBits();
bitsToRGB();
renderImageFromBytes();
save(fileName+ "_"+ bRed + "" + bGreen + "" + bBlue + "-RGB_" + imgWidth +"px" + ".tif");
println("File saved to: " + fileName+ "_"+ bRed + "" + bGreen + "" + bBlue + "-RGB_" + imgWidth +"px" + ".tif");

}


//Thar Be Functions Below!!!!

void convertSequenceToBits() {
// Converts each byte to int, from 0 to 255 
for (int i = 0; i < rawData.length; i++) { 
  seqInt[i] = rawData[i] & 0xFF;
//  print(seqInt[i] + " "); 
} 

for(int j = 0; j < rawData.length*2; j+=2){
    if (seqInt[j/2] == 65) {
      rawBits[j] = 0;
      rawBits[j+1] = 0;
      //print ("A");
    } else if (seqInt[j/2] == 67) {
      rawBits[j] = 0;
      rawBits[j+1] = 1;
      //print ("C");
    } else if (seqInt[j/2] == 71) {
      rawBits[j] = 1;
      rawBits[j+1] = 0;
      //print ("G");
    } else  if (seqInt[j/2] == 84) {
      rawBits[j] = 1;
      rawBits[j+1] = 1;
      //print ("T");
    } else {
      rawBits[j] = 0;
      rawBits[j+1] = 0;
      print(" non-valid based pair found at location: " + j + ", value = " + seqInt[j/2] + " ");
    }
  }
}


void renderImageFromBytes() {
  PImage img = new PImage(imgWidth, imgLength);
  img.loadPixels();
  for (int i = 0; i < (img.pixels.length * 3); i += 3) {
    img.pixels[i/3] = color((groupedBits[i] & 0xFF) * (255/(pow(2,bRed)-1)), (groupedBits[i+1] & 0xFF) * (255/(pow(2,bGreen)-1)), (groupedBits[i+2] & 0xFF) * (255/(pow(2,bBlue)-1)));    
  }
  img.updatePixels();
  image(img, 0, 0);
}


void bitsToRGB() {  //packs the bits stored in rawBits[] into variable 0-8 bit color channel values
  int k = 0;
  for (int j = 0; j < (rawBits.length - (bRed + bBlue + bGreen)); j += (bRed + bBlue + bGreen)) {
    
    // RED packing
    byte tempRedBytes[] = new byte[bRed];
    for (int i = 0; i < bRed; i++) {
      tempRedBytes[i] = rawBits[j + i];
    }
    byte redByte = storeBitsInByte(tempRedBytes);
    groupedBits[k] = redByte; 
    
    // GREEN packing
    byte tempGreenBytes[] = new byte[bGreen];
    for (int i = 0; i < bGreen; i++) {
      tempGreenBytes[i] = rawBits[j + i + bRed]; 
    }
    byte greenByte = storeBitsInByte(tempGreenBytes);
    groupedBits[k+1] = greenByte;
   
    // BLUE packing
    byte tempBlueBytes[] = new byte[bBlue];
    for (int i = 0; i < bBlue; i++) {
      tempBlueBytes[i] = rawBits[j + i + bRed + bGreen];
    }
    byte blueByte = storeBitsInByte(tempBlueBytes);
    groupedBits[k+2] = blueByte;
    
    k+=3;
  }
  
}


// Stores bits in a byte
byte storeBitsInByte(byte[] bits) { // send in maximum of 8 bits in array
  byte bitBuffer = 0;
  for (int i = 0; i < bits.length; i++) {
    bitBuffer <<= 1;
    bitBuffer += bits[i];
  }  
  return bitBuffer;
}

