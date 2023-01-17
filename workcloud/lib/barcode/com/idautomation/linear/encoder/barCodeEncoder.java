
package com.idautomation.linear.encoder;

public class barCodeEncoder {

   String sFile;
   String sFormat;
   com.idautomation.linear.BarCode bc;
   public boolean result;

  public barCodeEncoder(com.idautomation.linear.BarCode c,String psFormat,String psFile) {

     sFormat=psFormat;
     sFile=psFile;
     bc=c;

     result=encode();
  }

  private boolean encode() {
    if (sFormat.toUpperCase().compareTo("GIF")==0) return saveToGIF();
    if (sFormat.toUpperCase().compareTo("JPEG")==0) return saveToJPEG();
    return false;
  }

   private boolean saveToGIF() {
          String v=java.lang.System.getProperty("java.version");
          if (v.indexOf("1.1")==0) return false;
           try {

            //create bufferred image
            java.awt.image.BufferedImage image = new java.awt.image.BufferedImage( bc.getSize().width,bc.getSize().height,java.awt.image.BufferedImage.TYPE_BYTE_INDEXED );

            //java.awt.Image image=c.createImage(c.getSize().width,c.getSize().height);
            java.awt.Graphics imgGraphics = image.createGraphics();
             bc.paint(imgGraphics );

            // open file
            java.io.File f=new java.io.File(sFile);
            f.delete();
            java.io.FileOutputStream of=new java.io.FileOutputStream(f);

            // encode buffered image to a gif
            GifEncoder encoder = new GifEncoder(image,of);
            encoder.encode();
            of.close();
            }
            catch (Exception e) {
            return false;}

            return true;
        }

        private boolean saveToJPEG() {
          String v=java.lang.System.getProperty("java.version");
          if (v.indexOf("1.1")==0) return false;
           try {

            // create bufferred image
            java.awt.image.BufferedImage image = new java.awt.image.BufferedImage( bc.getSize().width,bc.getSize().height,java.awt.image.BufferedImage.TYPE_INT_RGB );
            java.awt.Graphics imgGraphics = image.createGraphics();
             bc.paint(imgGraphics );

            // open file
            java.io.File f=new java.io.File(sFile);
            f.delete();
            java.io.FileOutputStream of=new java.io.FileOutputStream(f);

            // encode buffered image to a jpeg
            com.sun.image.codec.jpeg.JPEGImageEncoder encoder = com.sun.image.codec.jpeg.JPEGCodec.createJPEGEncoder(of );
            encoder.encode( image );
            of.close();
            }
            catch (Exception e) {return false;}
            return true;
        }

}
