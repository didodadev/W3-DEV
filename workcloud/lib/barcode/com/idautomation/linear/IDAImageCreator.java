package com.idautomation.linear;

import java.awt.*;

/** This class enables the paint() method in the main BarCode class to
rotate a barcode when it is not visable. */

public class IDAImageCreator {

  private java.awt.Image im;
  public Graphics g;

  public IDAImageCreator() {
  }

  public Image getImage(  int w,int h) {

   	im=new java.awt.image.BufferedImage(w,h,java.awt.image.BufferedImage.TYPE_BYTE_INDEXED);
        g = ((java.awt.image.BufferedImage) im).createGraphics();

        return im;

  }

  public Graphics getGraphics() {

    return g;

  }


}