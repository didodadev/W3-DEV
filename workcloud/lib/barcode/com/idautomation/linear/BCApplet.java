//*****************************************************************
// 
//  JAVA Source for com.idautomation.linear; 2.3
//  
//  Copyright, IDAutomation.com, Inc. 2000. All rights reserved.
//  
//  http://www.IDAutomation.com/
//  
//  NOTICE:
//  You may incorporate our Source Code in your application
//  only if you own a valid Java Barcode Package License
//  from IDAutomation.com, Inc. and the copyright notices 
//  are not removed from the source code.
//  
//*****************************************************************


package com.idautomation.linear;

import java.awt.*;
import java.applet.*;

/** This is the applet that contains all linear barcode functionality. */

public class BCApplet extends Applet
{
        // ** updated for servlet operation 5/31/2001
	public BarCode BC=null;
        public boolean isStandalone=false;
        // ** end of update

	public BCApplet() {

	
		this.setLayout(new java.awt.BorderLayout());
		

	}

	public void start() {

		BC.paint(this.getGraphics());
	}

	public void refresh() {
                BC.paint(BC.getGraphics());
		this.paintAll(this.getGraphics());
	}

	public void init() {
		// create bar code 1D
		if (BC==null) BC=new BarCode();	
		
		this.add("Center",BC);		
		
		initParam("CODE_TYPE");
		initParam("N");
		initParam("X");
		initParam("I");
		initParam("H");
		initParam("BAR_HEIGHT");
		initParam("CODABAR_START");
		initParam("CODABAR_STOP");
		initParam("BAR_COLOR");
		initParam("FONT_COLOR");
		initParam("TEXT_FONT");
		initParam("UPCE_SYSTEM");
		initParam("BACK_COLOR");
		initParam("CODE128_SET");
		initParam("LEFT_MARGIN");
		initParam("TOP_MARGIN");
		initParam("CHECK_CHAR");
		initParam("BARCODE");
		initParam("GUARDBARS");
		initParam("ROTATE");
		initParam("SUPPLEMENT");
		initParam("SUPPLEMENT_CODE");
		initParam("SUPPLEMENT_HEIGHT");
		initParam("SUPPLEMENT_SEPARATION");
		initParam("POSTNET_TALL");
		initParam("POSTNET_SHORT");
		initParam("CHECK_CHARINTEXT");
		

	}

	private void initParam(String p) {
		String v=getStringParam(p,"");
		if (v.length()==0) return;
	    setParameter(p,v);
	}

	public void setParameter(String p,String v) {

                if (v==null) return;

		if (p.compareTo("CODE_TYPE")==0) {
			if (v.compareTo("CODE39")==0) BC.barType=BC.CODE39;
			if (v.compareTo("CODE39EXT")==0) BC.barType=BC.CODE39EXT;
			if (v.compareTo("CODE93")==0) BC.barType=BC.CODE93;
			if (v.compareTo("CODE11")==0) BC.barType=BC.CODE11;
			if (v.compareTo("CODABAR")==0) BC.barType=BC.CODABAR;
			if (v.compareTo("CODE93EXT")==0) BC.barType=BC.CODE93EXT;
			if (v.compareTo("CODE128")==0) BC.barType=BC.CODE128;
			if (v.compareTo("MSI")==0) BC.barType=BC.MSI;
			if (v.compareTo("IND25")==0) BC.barType=BC.IND25;
			if (v.compareTo("MAT25")==0) BC.barType=BC.MAT25;
			if (v.compareTo("INTERLEAVED25")==0) BC.barType=BC.INTERLEAVED25;
			if (v.compareTo("EAN13")==0) BC.barType=BC.EAN13;
			if (v.compareTo("EAN8")==0) BC.barType=BC.EAN8;
			if (v.compareTo("UPCA")==0) BC.barType=BC.UPCA;
			if (v.compareTo("UPCE")==0) BC.barType=BC.UPCE;
			if (v.compareTo("POSTNET")==0) BC.barType=BC.POSTNET;
			if (v.compareTo("PLANET")==0) BC.barType=BC.PLANET;
			if (v.compareTo("UCC128")==0) BC.barType=BC.UCC128;
		}


		if (p.compareTo("N")==0) BC.N=new Double(v).doubleValue();
		
		
		if (p.compareTo("SUPPLEMENT_CODE")==0) BC.supplement=v;
		
		if (p.compareTo("SUPPLEMENT_SEPARATION")==0) BC.supSeparationCM=new Double(v).doubleValue();
		
		if (p.compareTo("SUPPLEMENT_HEIGHT")==0) BC.supHeight=new Double(v).doubleValue();
		
		if (p.compareTo("SUPPLEMENT")==0) {
		  BC.UPCEANSupplement2=false;
		  BC.UPCEANSupplement5=false;
		  if (v.compareTo("2")==0) BC.UPCEANSupplement2=true;
		  if (v.compareTo("5")==0) BC.UPCEANSupplement5=true;
		}
		
		if (p.compareTo("ROTATE")==0) BC.rotate=(int) (new Double(v).doubleValue());
		
		if (p.compareTo("POSTNET_TALL")==0) BC.postnetHeightTallBar=(int) (new Double(v).doubleValue());
		
		if (p.compareTo("POSTNET_SHORT")==0) BC.postnetHeightShortBar=(int) (new Double(v).doubleValue());

		if (p.compareTo("X")==0) BC.X=new Double(v).doubleValue();

		if (p.compareTo("I")==0) BC.I=new Double(v).doubleValue();

		if (p.compareTo("LEFT_MARGIN")==0) BC.leftMarginCM=new Double(v).doubleValue();

		if (p.compareTo("TOP_MARGIN")==0) BC.topMarginCM=new Double(v).doubleValue();

		if (p.compareTo("BAR_COLOR")==0) BC.barColor=convertColor(v);

		if (p.compareTo("FONT_COLOR")==0) BC.fontColor=convertColor(v);

		if (p.compareTo("BACK_COLOR")==0) BC.backColor=convertColor(v);

		if (p.compareTo("GUARDBARS")==0) BC.guardBars=(v.compareTo("Y")==0);

		if (p.compareTo("UPCE_SYSTEM")==0) BC.UPCESytem=new String(v+"1").charAt(0);

                if (p.compareTo("CODABAR_START")==0) BC.CODABARStartChar=new String(v+"A").charAt(0);

                if (p.compareTo("CODABAR_STOP")==0) BC.CODABARStopChar=new String(v+"A").charAt(0);

		if (p.compareTo("TEXT_FONT")==0) BC.textFont=convertFont(v);

		if (p.compareTo("H")==0) BC.H=new Double(v).doubleValue();

//		if (p.compareTo("BARCODE")==0) BC.code=v;

		if (p.compareTo("BARCODE")==0) BC.setDataToEncode(v);

		if (p.compareTo("CHECK_CHAR")==0) BC.checkCharacter=(v.compareTo("Y")==0);

		if (p.compareTo("CHECK_CHARINTEXT")==0) BC.checkCharacterInText=(v.compareTo("Y")==0);

		if (p.compareTo("CODE128_SET")==0) BC.Code128Set=new String(v+"B").charAt(0);

		if (p.compareTo("BAR_HEIGHT")==0) BC.barHeightCM=new Double(v).doubleValue();

		
	}

  // function to convert a String parameter to a color
  public java.awt.Color convertColor(String c) {
	if (c.compareTo("NULL")==0) return null;
    if (c.compareTo("RED")==0) return java.awt.Color.red;
    if (c.compareTo("BLACK")==0) return java.awt.Color.black;
    if (c.compareTo("BLUE")==0) return java.awt.Color.blue;
    if (c.compareTo("CYAN")==0) return java.awt.Color.cyan;
    if (c.compareTo("DARKGRAY")==0) return java.awt.Color.darkGray;
    if (c.compareTo("GRAY")==0) return java.awt.Color.gray;
    if (c.compareTo("GREEN")==0) return java.awt.Color.green;
    if (c.compareTo("LIGHTGRAY")==0) return java.awt.Color.lightGray;
    if (c.compareTo("MAGENTA")==0) return java.awt.Color.magenta;
    if (c.compareTo("ORANGE")==0) return java.awt.Color.orange;
    if (c.compareTo("PINK")==0) return java.awt.Color.pink;
    if (c.compareTo("WHITE")==0) return java.awt.Color.white;
    if (c.compareTo("YELLOW")==0) return java.awt.Color.yellow;
    try {
       return java.awt.Color.decode(c);
    } catch (Exception e) {return java.awt.Color.black;}
  }

  // convert an applet parameter to a Font
  public java.awt.Font convertFont(String f) {

    String[] items=convertList(f);

   if (items==null) return null;

    if (items.length<3) return null;

    int s=java.awt.Font.PLAIN;
    if (items[1].compareTo("BOLD")==0) s=java.awt.Font.BOLD;
    if (items[1].compareTo("ITALIC")==0) s=java.awt.Font.ITALIC;

    try {
    return new java.awt.Font(items[0],s,new Integer(items[2]).intValue());
    }
    catch (Exception e) {return null;}

  }

  // ** updated for servlet operation 5/31/2001
  // get a parameter as string
  protected String getStringParam(String Param,String def) {

      return this.getParameter(Param, def);


    }


  //Get a parameter value
  private String getParameter(String key, String def) {


    if (isStandalone) return def;

    if (this.getParameter(key) != null) return this.getParameter(key) ;
    else return def;
  }

  private String[] convertList(String items){

   String[] itema=new String[500];
   int itemCount=0;

   // count number of items
   int p=items.indexOf("|");
   while (p>=0) {
      itema[itemCount++]=items.substring(0,p);
      items=items.substring(p+1,items.length());
      p=items.indexOf("|");
   }

   if (items.compareTo("")!=0) itema[itemCount++]=items;

   if (itemCount==0) return null;

   String[] result=new String[itemCount];
   for (int i=0;i<itemCount;i++) result[i]=itema[i];

   return result;

 }

  private Integer getIntParam(String Param,Integer def) {

    try {
      String s=this.getParameter(Param ,"");
      if (s.compareTo("")==0) return def;
      return new Integer(s);
    }
    catch(Exception e) {
      return def;
    }
   }

   private Double getDoubleParam(String Param,Double def) {

      try {
       String s=this.getParameter(Param ,"");
      if (s.compareTo("")==0) return def;
     return new Double(s);
    }
    catch(Exception e) {
      return def;
    }
    }
    // ** end of update
}
