//*****************************************************************
// 
//  JAVA Servlet sample code for com.idautomation.linear 2.1
//  
//  Copyright, IDAutomation.com, Inc. 2001. All rights reserved.
//  
//  http://www.IDAutomation.com/
//  
//  NOTICE:
//  You may incorporate our Source Code in your application
//  only if you own a valid Java Barcode Package License
//  from IDAutomation.com, Inc. and the copyright notices 
//  are not removed from the source code.
//  
//  NOTE: "BarCode" is the class of the linear barcode class
//  For other classes such as PDF417, replace all text of "BarCode"
//  with "PDF417".
//
//*****************************************************************

package com.idautomation.linear;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.awt.Graphics2D.*;
import java.awt.*;

public class IDAutomationServlet extends HttpServlet
    {

        /**
         * Handle the HTTP POST method by sending an e-mail
         *
         *
         */
         private boolean debug=false;

	    public void init() throws ServletException  {

	    }


       // MODIFY THIS FUNCTION TO CREATE THE BARCODE USING THE request PARAMETERS
       private BarCode getChart (HttpServletRequest request) {



         BCApplet bcApplet=new BCApplet();
         // this creates the barcode object within the applet
         bcApplet.isStandalone=true;
         bcApplet.init();


         // load parameters
         if (request!=null) {

            if (request.getParameter("DEBUG")!=null)
               if (request.getParameter("DEBUG").toUpperCase().compareTo("ON")==0) debug =true;

            java.util.Enumeration ps=request.getParameterNames();
            while (ps.hasMoreElements()) {
              String name=(String) ps.nextElement();

              // set parameters  of the barcode
              bcApplet.setParameter(name,request.getParameter(name));

              if (debug) System.out.println("PARAM: "+name+"="+request.getParameter(name));

            }
         }

         return bcApplet.BC;

      }

       // Handle a request
       // 1. create barcode
       // 2. draw barcode in a Buffered Image
       // 3. encode image as GIF or JPEG and send it to the browser
        public void doGet (HttpServletRequest request,
                	   HttpServletResponse response)
        throws ServletException, IOException
        {
               PrintWriter		out;
               ServletOutputStream outb;

               String encode="jpeg";

               if (request!=null) {
                 if (request.getParameter("FORMAT")!=null)  encode=request.getParameter("FORMAT").toLowerCase();

                 if (encode.compareTo("gif")!=0) encode="jpeg";
               }

               response.setContentType("image/"+encode);

		//out=response.getWriter();
		outb=response.getOutputStream();

                // avoid caching in browser
		response.setHeader ("Pragma", "no-cache");
		response.setHeader ("Cache-Control", "no-cache");
		response.setDateHeader ("Expires",0);

               try { // Create buffer

               //the default height and width if not specified.
               int w=200;
               int h=80;


               if (request!=null) {
                 if (request.getParameter("WIDTH")!=null) w=new Integer(request.getParameter("WIDTH")).intValue();
                 if (request.getParameter("HEIGHT")!=null) h=new Integer(request.getParameter("HEIGHT")).intValue();
               }

		java.awt.image.BufferedImage BarImage=new java.awt.image.BufferedImage(w,h,java.awt.image.BufferedImage.TYPE_INT_RGB);
		java.awt.Graphics2D BarGraphics=BarImage.createGraphics();

                // get BarCode
                BarCode cb=getChart(request);

                if (debug) System.out.println("Size: "+w+" "+h);
                cb.setSize(w,h);

                cb.paint(BarGraphics);

               if (encode.compareToIgnoreCase("gif")==0) {
                 // encode buffered image to a gif
                 // GifEncoder encoder = new GifEncoder(BarImage  ,outb);
                 // encoder.encode();
                }
                else
                {

                // create JPEG image
                  com.sun.image.codec.jpeg.JPEGImageEncoder encoder = com.sun.image.codec.jpeg.JPEGCodec.createJPEGEncoder(outb );
                  encoder.encode( BarImage );
                }


		} catch (Exception e) { e.printStackTrace();}


		}


        public void doPost (HttpServletRequest request,
                	   HttpServletResponse response)
        throws ServletException
        {
        try {
              doGet(request,response);
          } catch (Exception e) { e.printStackTrace();}
	}

    }
