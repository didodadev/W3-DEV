// Decompiled by Jad v1.5.7d. Copyright 2000 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/SiliconValley/Bridge/8617/jad.html
// Decompiler options: packimports(3)
// Source File Name:   com/idautomation/linear/BarCode

package com.idautomation.linear;

import java.awt.*;
import java.awt.image.MemoryImageSource;
import java.awt.image.PixelGrabber;
import java.io.PrintStream;
import java.io.Serializable;
import com.eteks.awt.*;

// Referenced classes of package com.idautomation.linear:
//            IDAImageCreator

public class BarCode extends Canvas
    implements Serializable
{

    PJAToolkit pja = new PJAToolkit();
    String system = System.getProperty("os.name");

    public BarCode()
    {
        barType = 13;
        code = "";
        codeSup = "";
        checkCharacter = true;
        checkCharacterInText = true;
        postnetHeightTallBar = 0.29999999999999999D;
        postnetHeightShortBar = 0.125D;
        leftMarginCM = 0.20000000000000001D;
        topMarginCM = 0.1D;
        leftMarginPixels = 0;
        topMarginPixels = 0;
        leftGuardBar = 0;
        centerGuardBarStart = 0;
        centerGuardBarEnd = 0;
        rightGuardBar = 0;
        endOfCode = 0;
        supplement = "";
        guardBars = true;
        backColor = Color.white;
        codeText = "asd";
        narrowBarPixels = 0.0D;
        widthBarPixels = 0.0D;
        narrowBarCM = 0.0D;
        widthBarCM = 0.0D;
        if(system.indexOf("Linux") == -1)
          resolution = (int)((double)getToolkit().getScreenResolution() / 2.54D);
        else
          resolution = (int)((double)pja.getScreenResolution() / 2.54D);
        barHeightPixels = 0;
        barHeightCM = 0.0D;
        width = 170;
        height = 70;
        pWidth = width;
        pHeight = height;
        textFont = new Font("Arial", 0, 11);
        fontColor = Color.black;
        barColor = Color.white;
        extraHeight = 0;
        UPCESytem = '1';
        CODABARStartChar = 'A';
        CODABARStopChar = 'B';
        UPCEANSupplement2 = false;
        UPCEANSupplement5 = false;
        Code128Set = '0';
        X = 0.029999999999999999D;
        N = 2D;
        I = 1.0D;
        H = 0.45000000000000001D;
        L = 0.0D;
        rotate = 0;
        supSeparationCM = 0.5D;
        supHeight = 0.80000000000000004D;
        currentX = 0;
        currentY = 0;
    }

    public void setSymbologyID(int i)
    {
        barType = i;
        invalidate();
    }

    public int getSymbologyID()
    {
        return barType;
    }

    public void setDataToEncode(String s)
    {
        code = s;
        invalidate();
    }

    public String getDataToEncode()
    {
        return code;
    }

    public void setCheckCharacter(boolean flag)
    {
        checkCharacter = flag;
        invalidate();
    }

    public boolean getCheckCharacter()
    {
        return checkCharacter;
    }

    public void setCheckCharacterInText(boolean flag)
    {
        checkCharacterInText = flag;
        invalidate();
    }

    public boolean getCheckCharacterInText()
    {
        return checkCharacterInText;
    }

    public void setPostnetHeightTall(double d1)
    {
        postnetHeightTallBar = d1;
        invalidate();
    }

    public double getPostnetHeightTall()
    {
        return postnetHeightTallBar;
    }

    public void setPostnetHeightShort(double d1)
    {
        postnetHeightShortBar = d1;
        invalidate();
    }

    public double getPostnetHeightShort()
    {
        return postnetHeightShortBar;
    }

    public void setLeftMarginCM(double d1)
    {
        leftMarginCM = d1;
        invalidate();
    }

    public double getLeftMarginCM()
    {
        return leftMarginCM;
    }

    public void setTopMarginCM(double d1)
    {
        topMarginCM = d1;
        invalidate();
    }

    public double getTopMarginCM()
    {
        return topMarginCM;
    }

    public void setSupplementToEncode(String s)
    {
        supplement = s;
        invalidate();
    }

    public String getSupplementToEncode()
    {
        return supplement;
    }

    public void setBackground(Color color)
    {
        backColor = color;
        invalidate();
    }

    public Color getBackground()
    {
        return backColor;
    }

    public void setPixelsPerCM(int i)
    {
        resolution = i;
        invalidate();
    }

    public int getPixelsPerCM()
    {
        return resolution;
    }

    public void setBarHeightCM(double d1)
    {
        barHeightCM = d1;
        invalidate();
    }

    public double getBarHeightCM()
    {
        return barHeightCM;
    }

    public Dimension getPreferredSize()
    {
        return new Dimension(pWidth, pHeight);
    }

    public Dimension getMinimumSize()
    {
        Dimension dimension = new Dimension(10, 10);
        return dimension;
    }

    public void setFont(Font font)
    {
        textFont = font;
        invalidate();
    }

    public Font getFont()
    {
        return textFont;
    }

    public void setTextFontColor(Color color)
    {
        fontColor = color;
        invalidate();
    }

    public Color getTextFontColor()
    {
        return fontColor;
    }

    public void setForeground(Color color)
    {
        barColor = color;
        invalidate();
    }

    public Color getForeground()
    {
        return barColor;
    }

    public void setUPCESytem(String s)
    {
        if(s.equals("0"))
            UPCESytem = '0';
        if(s.equals("1"))
            UPCESytem = '1';
        invalidate();
    }

    public String getUPCESytem()
    {
        String s = "";
        if(UPCESytem == '0')
            s = "0";
        if(UPCESytem == '1')
            s = "1";
        return s;
    }

    public void setCODABARStartChar(String s)
    {
        if(s.equals("B"))
            CODABARStartChar = 'B';
        if(s.equals("A"))
            CODABARStartChar = 'A';
        if(s.equals("C"))
            CODABARStartChar = 'C';
        if(s.equals("D"))
            CODABARStartChar = 'D';
        invalidate();
    }

    public String getCODABARStartChar()
    {
        String s = "";
        if(CODABARStartChar == 'B')
            s = "B";
        if(CODABARStartChar == 'A')
            s = "A";
        if(CODABARStartChar == 'C')
            s = "C";
        if(CODABARStartChar == 'D')
            s = "D";
        return s;
    }

    public void setCODABARStopChar(String s)
    {
        if(s.equals("B"))
            CODABARStopChar = 'B';
        if(s.equals("A"))
            CODABARStopChar = 'A';
        if(s.equals("C"))
            CODABARStopChar = 'C';
        if(s.equals("D"))
            CODABARStopChar = 'D';
        invalidate();
    }

    public String getCODABARStopChar()
    {
        String s = "";
        if(CODABARStopChar == 'B')
            s = "B";
        if(CODABARStopChar == 'A')
            s = "A";
        if(CODABARStopChar == 'C')
            s = "C";
        if(CODABARStopChar == 'D')
            s = "D";
        return s;
    }

    public void setUPCEANSupplement2(boolean flag)
    {
        UPCEANSupplement2 = flag;
        invalidate();
    }

    public boolean getUPCEANSupplement2()
    {
        return UPCEANSupplement2;
    }

    public void setUPCEANSupplement5(boolean flag)
    {
        UPCEANSupplement5 = flag;
        invalidate();
    }

    public boolean getUPCEANSupplement5()
    {
        return UPCEANSupplement5;
    }

    public void setCode128Set(String s)
    {
        if(s.toUpperCase().equals("B"))
            Code128Set = 'B';
        if(s.toUpperCase().equals("A"))
            Code128Set = 'A';
        if(s.toUpperCase().equals("C"))
            Code128Set = 'C';
        if(s.toUpperCase().equals("AUTO"))
            Code128Set = '0';
        if(s.toUpperCase().equals("0"))
            Code128Set = '0';
        invalidate();
    }

    public String getCode128Set()
    {
        String s = "";
        if(Code128Set == 'B')
            s = "B";
        if(Code128Set == 'A')
            s = "A";
        if(Code128Set == 'C')
            s = "C";
        if(Code128Set == '0')
            s = "0";
        return s;
    }

    public void setXDimensionCM(double d1)
    {
        X = d1;
        invalidate();
    }

    public double getXDimensionCM()
    {
        return X;
    }

    public void setNarrowToWideRatio(double d1)
    {
        N = d1;
        invalidate();
    }

    public double getNarrowToWideRatio()
    {
        return N;
    }

    public void setRotationAngle(int i)
    {
        rotate = i;
        invalidate();
    }

    public int getRotationAngle()
    {
        return rotate;
    }

    protected void addBar(Graphics g, double i, boolean flag, int j)
    {
        if(flag)
        {
            //System.out.println(currentX + " : " +  topMarginPixels + " : " + barHeightPixels + " : " + extraHeight + " : " + i + " : " + j);
            g.setColor(barColor);
            g.fillRect(currentX, topMarginPixels + j, (int)i, (barHeightPixels + extraHeight) - j);
        }
        currentX = currentX + (int)i;
    }

    protected void paintPostNetChar(Graphics g, String s)
    {
        int i = (int)(postnetHeightTallBar * (double)resolution);
        int j = (int)(postnetHeightShortBar * (double)resolution);
        g.setColor(barColor);
        for(int k = 0; k < s.length(); k++)
        {
            char c = s.charAt(k);
            if(c == '0')
                g.fillRect(currentX, topMarginPixels, (int)narrowBarPixels, j + extraHeight);
            if(c == '1')
                g.fillRect(currentX, topMarginPixels + (j - i), (int)narrowBarPixels, i + extraHeight);
            currentX = currentX + (int)narrowBarPixels;
            currentX = currentX + (int)widthBarPixels;
        }

    }

    protected void paintPOSTNET(Graphics g)
    {
        boolean flag = false;
        int j = 0;
        String s2 = code;
        paintPostNetChar(g, "1");
        for(int k = code.length() - 1; k >= 0; k--)
        {
            String s = "" + code.charAt(k);
            j += findChar(setPOSTNET, s);
        }

        int l = (int)mod(j, 10D);
        if(l != 0)
            l = 10 - l;
        if(checkCharacter)
            s2 = s2 + (new Integer(l)).toString();
        for(int i1 = 0; i1 < s2.length(); i1++)
        {
            String s1 = "" + s2.charAt(i1);
            int i = findChar(setPOSTNET, s1);
            paintPostNetChar(g, setPOSTNET[i][1]);
        }

        paintPostNetChar(g, "1");
    }

    protected int findChar(String as[][], String s)
    {
        for(int i = 0; i < as.length; i++)
            if(s.compareTo(as[i][0]) == 0)
                return i;

        return -1;
    }

    protected void paintPLANET(Graphics g)
    {
        boolean flag = false;
        int j = 0;
        String s2 = code;
        paintPostNetChar(g, "1");
        for(int k = code.length() - 1; k >= 0; k--)
        {
            String s = "" + code.charAt(k);
            j += findChar(setPLANET, s);
        }

        int l = (int)mod(j, 10D);
        if(l != 0)
            l = 10 - l;
        if(checkCharacter)
            s2 = s2 + (new Integer(l)).toString();
        for(int i1 = 0; i1 < s2.length(); i1++)
        {
            String s1 = "" + s2.charAt(i1);
            int i = findChar(setPLANET, s1);
            paintPostNetChar(g, setPLANET[i][1]);
        }

        paintPostNetChar(g, "1");
    }

    protected void paintInterleaved25(Graphics g)
    {
        boolean flag = false;
        boolean flag1 = false;
        boolean flag2 = false;
        String s3 = code;
        paintChar(g, "bwbw", "nnnn");
        String s4 = "";
        if(mod(code.length(), 2D) == 0.0D && checkCharacter)
            s3 = "0" + code;
        if(mod(code.length(), 2D) == 1.0D && !checkCharacter)
            s3 = "0" + code;
        int k = 0;
        int l = 0;
        boolean flag3 = true;
        for(int i1 = s3.length() - 1; i1 >= 0; i1--)
        {
            String s = "" + s3.charAt(i1);
            if(flag3)
                k += findChar(set25, s);
            else
                l += findChar(set25, s);
            flag3 = !flag3;
        }

        int j1 = k * 3 + l;
        j1 = (int)mod(j1, 10D);
        if(j1 != 0)
            j1 = 10 - j1;
        if(checkCharacter)
            s3 = s3 + (new Integer(j1)).toString();
        for(int k1 = 0; k1 < s3.length(); k1 += 2)
        {
            String s1 = "" + s3.charAt(k1);
            String s2 = "" + s3.charAt(k1 + 1);
            int i = findChar(set25, s1);
            int j = findChar(set25, s2);
            for(int l1 = 0; l1 < 5; l1++)
            {
                paintChar(g, "b", "" + set25[i][1].charAt(l1));
                paintChar(g, "w", "" + set25[j][1].charAt(l1));
            }

        }

        paintChar(g, "bwb", "wnn");
        if(checkCharacterInText)
            codeText = s3;
        else
            codeText = code;
    }

    protected void paintIND25(Graphics g)
    {
        boolean flag = false;
        boolean flag1 = false;
        String s2 = code;
        paintChar(g, "bwbwbw", "wwwwnw");
        int j = 0;
        int k = 0;
        boolean flag2 = true;
        for(int l = s2.length() - 1; l >= 0; l--)
        {
            String s = "" + s2.charAt(l);
            if(flag2)
                j += findChar(set25, s);
            else
                k += findChar(set25, s);
            flag2 = !flag2;
        }

        int i1 = j * 3 + k;
        i1 = (int)mod(i1, 10D);
        if(i1 != 0)
            i1 = 10 - i1;
        if(checkCharacter)
            s2 = s2 + (new Integer(i1)).toString();
        for(int j1 = 0; j1 < s2.length(); j1++)
        {
            String s1 = "" + s2.charAt(j1);
            int i = findChar(set25, s1);
            if(i >= 0)
            {
                for(int k1 = 0; k1 < set25[i][1].length(); k1++)
                {
                    paintChar(g, "b", "" + set25[i][1].charAt(k1));
                    paintChar(g, "w", "w");
                }

            }
        }

        paintChar(g, "bwbwb", "wwnww");
    }

    protected String UPCEANCheck(String s)
    {
        boolean flag = true;
        int i = 0;
        int j = 0;
        int k = 0;
        for(int l = s.length() - 1; l >= 0; l--)
        {
            if(flag)
                i += (new Integer("" + s.charAt(l))).intValue();
            else
                j += (new Integer("" + s.charAt(l))).intValue();
            flag = !flag;
        }

        j = i * 3 + j;
        k = (int)mod(j, 10D);
        if(k != 0)
            k = 10 - k;
        if(ext_code < 0)
          ext_code = k;
        System.out.println(k + " ---- " + ext_code);
        return "" + k;
    }

    protected void paintUPCA(Graphics g)
    {
        boolean flag = false;
        boolean flag1 = false;
        if(code.length() == 13)
        {
            supplement = code.substring(11, 13);
            UPCEANSupplement2 = true;
            code = code.substring(0, 11);
        }
        if(code.length() == 14)
        {
            supplement = code.substring(12, 14);
            UPCEANSupplement2 = true;
            code = code.substring(0, 11);
        }
        if(code.length() == 16)
        {
            supplement = code.substring(11, 16);
            UPCEANSupplement5 = true;
            code = code.substring(0, 11);
        }
        if(code.length() == 17)
        {
            supplement = code.substring(12, 17);
            UPCEANSupplement5 = true;
            code = code.substring(0, 11);
        }
        code = code.substring(0, 11) + UPCEANCheck(code);
        paintGuardChar(g, "bwb", "nnn", 0);
        leftGuardBar = currentX;
        for(int k = 0; k < code.length(); k++)
        {
            String s = "" + code.charAt(k);
            byte byte0 = -1;
            if(k <= 5)
            {
                int i = findChar(setUPCALeft, s);
                paintChar(g, "wbwb", setUPCALeft[i][1]);
            } else
            {
                int j = findChar(setUPCARight, s);
                paintChar(g, "bwbw", setUPCARight[j][1]);
            }
            if(k == 5)
            {
                centerGuardBarStart = currentX;
                paintGuardChar(g, "wbwbw", "nnnnn", 0);
                centerGuardBarEnd = currentX;
            }
        }

        rightGuardBar = currentX;
        paintGuardChar(g, "bwb", "nnn", 0);
        endOfCode = currentX;
        if(UPCEANSupplement2)
            paintSup2(g, code.substring(1, 3));
        else
        if(UPCEANSupplement5)
            paintSup5(g, code.substring(1, 6));
    }

    protected void paintEAN13(Graphics g)
    {
        int i = 0;
        boolean flag = false;
        if(code.length() == 12 && checkCharacter)
            code = code + UPCEANCheck(code);
        if(code.length() < 13)
            return;
        paintGuardChar(g, "bwb", "nnn", 0);
        leftGuardBar = currentX;
        String s1 = setEANCode[(new Integer("" + code.charAt(0))).intValue()];
        i = findChar(setEANLeftA, "" + code.charAt(1));
        System.out.println(checkCharacter + " : " + s1 + " : " + i);
        paintChar(g, "wbwb", setEANLeftA[i][1]);
        for(int j = 2; j < 12; j++)
        {
            String s = "" + code.charAt(j);
            i = -1;
            if(j <= 6)
            {
                String as[][] = setEANLeftA;
                if(s1.charAt(j - 2) == 'B')
                    as = setEANLeftB;
                i = findChar(as, s);
                paintChar(g, "wbwb", as[i][1]);
            } else
            {
                i = findChar(setEANRight, s);
                paintChar(g, "bwbw", setEANRight[i][1]);
            }
            if(j == 6)
            {
                centerGuardBarStart = currentX;
                paintGuardChar(g, "wbwbw", "nnnnn", 0);
                centerGuardBarEnd = currentX;
            }
        }

        i = findChar(setEANRight, "" + code.charAt(12));
        paintChar(g, "bwbw", setEANRight[i][1]);
        rightGuardBar = currentX;
        paintGuardChar(g, "bwb", "nnn", 0);
        endOfCode = currentX;
        if(UPCEANSupplement2)
            paintSup2(g, code.substring(2, 4));
        else
        if(UPCEANSupplement5)
            paintSup5(g, code.substring(2, 7));
    }

    private int C0(String as[], String s)
    {
        for(int i = 0; i < as.length; i++)
            if(as[i].compareTo(s) == 0)
                return i;

        return -1;
    }

    protected void paintCode128(Graphics g)
    {
        boolean flag = false;
        boolean flag1 = false;
        String s2 = code;
        codeText = code;
        boolean flag2 = false;
        boolean flag3 = false;
        int k1 = code.length();
        String as[] = set128B;
        int l1 = 103;
        if(Code128Set != '0')
        {
            s2 = "";
            codeText = "";
            for(int i2 = 1; i2 <= k1; i2++)
            {
                int l = code.charAt(i2 - 1);
                if(l < 32 && l >= 0)
                {
                    if(Code128Set == 'A')
                        s2 = s2 + (char)(l + 96);
                    if(Code128Set == 'B')
                        if(code.charAt(i2) < ' ')
                        {
                            s2 = s2 + '\311' + (char)(l + 96) + (char)(code.charAt(i2) + 96) + '\310';
                            i2++;
                        } else
                        {
                            s2 = s2 + '\311' + (char)(l + 96) + '\310';
                        }
                    if(Code128Set == 'C')
                        if(code.charAt(i2) < ' ')
                        {
                            s2 = s2 + '\311' + '\311' + (l + 64) + (code.charAt(i2) + 64) + "99";
                            i2++;
                        } else
                        {
                            s2 = s2 + '\311' + '\311' + (l + 64) + "99";
                        }
                    if(l == 13 || l == 9)
                        codeText = codeText + "  ";
                } else
                {
                    codeText = codeText + (char)l;
                    s2 = s2 + (char)l;
                }
            }

        }
        if(Code128Set == '0')
        {
            as = set128B;
            codeText = "";
            s2 = "";
            char c2 = '\314';
            byte byte0 = 66;
            char c = code.charAt(0);
            if(c < ' ')
                c2 = '\313';
            if(c > '\037' && c < '\177')
                c2 = '\314';
            if(k1 > 3 && c > '/' && c < ':' && code.charAt(1) > '/' && code.charAt(1) < ':' && code.charAt(2) > '/' && code.charAt(2) < ':' && code.charAt(3) > '/' && code.charAt(3) < ':')
                c2 = '\315';
            if(c == '\312')
                c2 = '\315';
            if(c2 == '\313')
            {
                byte0 = 65;
                l1 = 103;
                paintChar(g, "bwbwbw", "211412");
            }
            if(c2 == '\314')
            {
                byte0 = 66;
                l1 = 104;
                paintChar(g, "bwbwbw", "211214");
            }
            if(c2 == '\315')
            {
                byte0 = 67;
                l1 = 105;
                paintChar(g, "bwbwbw", "211232");
            }
            for(int l2 = 1; l2 <= k1; l2++)
            {
                int i1 = code.charAt(l2 - 1);
                if(l2 < k1 - 1 && i1 == 202)
                    s2 = s2 + (char)i1;
                else
                if(l2 <= k1 - 3 && i1 > 47 && i1 < 58 && code.charAt(l2) > '/' && code.charAt(l2) < ':' && code.charAt(l2 + 1) > '/' && code.charAt(l2 + 1) < ':' && code.charAt(l2 + 2) > '/' && code.charAt(l2 + 2) < ':' || l2 <= k1 - 1 && i1 > 47 && i1 < 58 && code.charAt(l2) > '/' && code.charAt(l2) < ':' && byte0 == 67)
                {
                    if(byte0 != 67)
                    {
                        s2 = s2 + '\307';
                        byte0 = 67;
                    }
                    i1 = (code.charAt(l2 - 1) - 48) * 10 + (code.charAt(l2) - 48);
                    if(i1 < 95 && i1 >= 0)
                        s2 = s2 + (char)(i1 + 32);
                    else
                    if(i1 > 94)
                        s2 = s2 + (char)(i1 + 100);
                    l2++;
                } else
                if(l2 <= k1 && (i1 < 32 || byte0 == 65 && i1 < 96))
                {
                    if(byte0 != 65)
                    {
                        s2 = s2 + '\311';
                        byte0 = 65;
                    }
                    if(i1 < 32)
                        s2 = s2 + (char)(i1 + 96);
                    else
                    if(i1 > 31)
                        s2 = s2 + (char)i1;
                } else
                if(l2 <= k1 && i1 > 31 && i1 < 127)
                {
                    if(byte0 != 66)
                    {
                        s2 = s2 + '\310';
                        byte0 = 66;
                    }
                    s2 = s2 + (char)i1;
                }
            }

            for(int i3 = 1; i3 <= k1; i3++)
            {
                char c1 = code.charAt(i3 - 1);
                if(i3 < k1 - 1 && c1 == '\312')
                {
                    int j1 = (code.charAt(i3) - 48) * 10 + (code.charAt(i3 + 1) - 48);
                    if(i3 < k1 - 3 && (j1 <= 81 && j1 >= 80 || j1 <= 34 && j1 >= 31))
                    {
                        codeText = codeText + " (" + code.charAt(i3) + code.charAt(i3 + 1) + code.charAt(i3 + 2) + code.charAt(i3 + 3) + ") ";
                        i3 += 4;
                    } else
                    if(i3 < k1 - 2 && (j1 <= 49 && j1 >= 40 || j1 <= 25 && j1 >= 23))
                    {
                        codeText = codeText + " (" + code.charAt(i3) + code.charAt(i3 + 1) + code.charAt(i3 + 2) + ") ";
                        i3 += 3;
                    } else
                    if(j1 <= 30 && j1 >= 0 || j1 <= 99 && j1 >= 90)
                    {
                        codeText = codeText + " (" + code.charAt(i3) + code.charAt(i3 + 1) + ") ";
                        i3 += 2;
                    }
                } else
                if(code.charAt(i3 - 1) < ' ')
                    codeText = codeText + " ";
                else
                if(code.charAt(i3 - 1) > '\037' && code.charAt(i3 - 1) < '\200')
                    codeText = codeText + code.charAt(i3 - 1);
            }

        }
        if(Code128Set == 'B')
        {
            as = set128B;
            l1 = 104;
        }
        if(Code128Set == 'C')
        {
            as = set128C;
            l1 = 105;
            if(s2.length() % 2 == 1)
            {
                s2 = "0" + s2;
                codeText = s2;
            }
        }
        if(Code128Set == 'B')
            paintChar(g, "bwbwbw", "211214");
        if(Code128Set == 'C')
            paintChar(g, "bwbwbw", "211232");
        if(Code128Set == 'A')
            paintChar(g, "bwbwbw", "211412");
        int j2 = 1;
        for(int k2 = 0; k2 < s2.length(); k2++)
        {
            String s = "" + s2.charAt(k2);
            if(Code128Set == 'C')
            {
                String s1 = "" + s;
                if(++k2 < s2.length())
                    s1 = s1 + s2.charAt(k2);
                int i = C0(set128C, s1);
                if(i >= 0)
                {
                    paintChar(g, "bwbwbw", set128[i]);
                    l1 += i * j2;
                }
            } else
            {
                int j = C0(as, s);
                if(j >= 0)
                {
                    paintChar(g, "bwbwbw", set128[j]);
                    l1 += j * j2;
                }
            }
            j2++;
        }

        if(checkCharacter)
        {
            int k = (int)mod(l1, 103D);
            paintChar(g, "bwbwbw", set128[k]);
        }
        paintChar(g, "bwbwbwb", "2331112");
    }

    protected void paintUCC128(Graphics g)
    {
        boolean flag = false;
        boolean flag1 = false;
        String s2 = code;
        codeText = code;
        boolean flag2 = false;
        String as[] = set128C;
        Code128Set = 'C';
        int l = 105;
        if(s2.length() % 2 == 1)
        {
            s2 = "0" + s2;
            codeText = s2;
        }
        if(s2.charAt(0) != '\312' && s2.charAt(1) != '\312')
            s2 = "\312\312" + s2;
        boolean flag3 = false;
        int j1 = s2.length();
        codeText = "";
        for(int k1 = 0; k1 < j1; k1++)
        {
            char c = s2.charAt(k1);
            if(k1 < j1 - 3 && s2.charAt(k1) == '\312' && s2.charAt(k1 + 1) == '\312')
            {
                int i1 = (s2.charAt(k1 + 2) - 48) * 10 + (s2.charAt(k1 + 3) - 48);
                if(k1 < j1 - 5 && (i1 <= 81 && i1 >= 80 || i1 <= 34 && i1 >= 31))
                {
                    codeText = codeText + " (" + s2.charAt(k1 + 2) + s2.charAt(k1 + 3) + s2.charAt(k1 + 4) + s2.charAt(k1 + 5) + ") ";
                    k1 += 5;
                } else
                if(k1 < j1 - 4 && (i1 <= 49 && i1 >= 40 || i1 <= 25 && i1 >= 23))
                {
                    codeText = codeText + " (" + s2.charAt(k1 + 2) + s2.charAt(k1 + 3) + s2.charAt(k1 + 4) + ") ";
                    k1 += 4;
                } else
                if(i1 <= 30 && i1 >= 0 || i1 <= 99 && i1 >= 90)
                {
                    codeText = codeText + " (" + s2.charAt(k1 + 2) + s2.charAt(k1 + 3) + ") ";
                    k1 += 3;
                }
            } else
            {
                codeText = codeText + s2.charAt(k1);
            }
        }

        paintChar(g, "bwbwbw", "211232");
        int l1 = 1;
        for(int i2 = 0; i2 < s2.length(); i2++)
        {
            String s = "" + s2.charAt(i2);
            if(Code128Set == 'C')
            {
                String s1 = "" + s;
                if(++i2 < s2.length())
                    s1 = s1 + s2.charAt(i2);
                int i = C0(set128C, s1);
                if(i >= 0)
                {
                    paintChar(g, "bwbwbw", set128[i]);
                    l += i * l1;
                }
            } else
            {
                int j = C0(as, s);
                if(j >= 0)
                {
                    paintChar(g, "bwbwbw", set128[j]);
                    l += j * l1;
                }
            }
            l1++;
        }

        if(checkCharacter)
        {
            int k = (int)mod(l, 103D);
            paintChar(g, "bwbwbw", set128[k]);
        }
        paintChar(g, "bwbwbwb", "2331112");
    }

    protected void paintEAN8(Graphics g)
    {
        boolean flag = false;
        boolean flag1 = false;
        if(code.length() == 7 && checkCharacter)
            code = code + UPCEANCheck(code);
        if(code.length() < 8)
            return;
        paintGuardChar(g, "bwb", "nnn", 0);
        leftGuardBar = currentX;
        for(int k = 0; k < 8; k++)
        {
            String s = "" + code.charAt(k);
            byte byte0 = -1;
            if(k <= 3)
            {
                int i = findChar(setEANLeftA, s);
                paintChar(g, "wbwb", setEANLeftA[i][1]);
            } else
            {
                int j = findChar(setEANRight, s);
                paintChar(g, "bwbw", setEANRight[j][1]);
            }
            if(k == 3)
            {
                centerGuardBarStart = currentX;
                paintGuardChar(g, "wbwbw", "nnnnn", 0);
                centerGuardBarEnd = currentX;
            }
        }

        rightGuardBar = currentX;
        paintGuardChar(g, "bwb", "nnn", 0);
        endOfCode = currentX;
        if(UPCEANSupplement2)
            paintSup2(g, code.substring(2, 4));
        else
        if(UPCEANSupplement5)
            paintSup5(g, code.substring(2, 7));
    }

    protected void paintUPCE(Graphics g)
    {
        boolean flag = false;
        boolean flag1 = false;
        int j = 0;
        String s1 = "";
        if(code.length() == 11 && checkCharacter)
            code = code + UPCEANCheck(code);
        if(code.length() < 12)
            return;
        j = (new Integer("" + code.charAt(11))).intValue();
        if(code.substring(3, 6).compareTo("000") == 0 || code.substring(3, 6).compareTo("100") == 0 || code.substring(3, 6).compareTo("200") == 0)
            s1 = code.substring(1, 3) + code.substring(8, 11) + code.charAt(3);
        if(code.substring(3, 6).compareTo("300") == 0 || code.substring(3, 6).compareTo("400") == 0 || code.substring(3, 6).compareTo("500") == 0 || code.substring(3, 6).compareTo("600") == 0 || code.substring(3, 6).compareTo("700") == 0 || code.substring(3, 6).compareTo("800") == 0 || code.substring(3, 6).compareTo("900") == 0)
            s1 = code.substring(1, 4) + code.substring(9, 11) + "3";
        if(code.substring(4, 6).compareTo("10") == 0 || code.substring(4, 6).compareTo("20") == 0 || code.substring(4, 6).compareTo("30") == 0 || code.substring(4, 6).compareTo("40") == 0 || code.substring(4, 6).compareTo("50") == 0 || code.substring(4, 6).compareTo("60") == 0 || code.substring(4, 6).compareTo("70") == 0 || code.substring(4, 6).compareTo("80") == 0 || code.substring(4, 6).compareTo("90") == 0)
            s1 = code.substring(1, 5) + code.substring(10, 11) + "4";
        if(code.substring(5, 6).compareTo("0") != 0)
            s1 = code.substring(1, 6) + code.substring(10, 11);
        codeText = s1 + j;
        paintGuardChar(g, "bwb", "nnn", 0);
        leftGuardBar = currentX;
        String s2 = UPCESystem0[j];
        if(UPCESytem == '1')
            s2 = UPCESystem1[j];
        for(int k = 0; k < s1.length(); k++)
        {
            String s = "" + s1.charAt(k);
            int i = -1;
            String as[][] = setUPCEOdd;
            if(s2.charAt(k) == 'E')
                as = setUPCEEven;
            i = findChar(as, s);
            paintChar(g, "wbwb", as[i][1]);
        }

        rightGuardBar = currentX;
        paintGuardChar(g, "wbwbwb", "nnnnnn", 0);
        endOfCode = currentX;
        if(UPCEANSupplement2)
            paintSup2(g, s1.substring(0, 2));
        else
        if(UPCEANSupplement5)
            paintSup5(g, s1.substring(0, 5));
    }

    protected void paintSup2(Graphics g, String s)
    {
        if(supplement.length() > 0)
            s = supplement;
        suplementTopMargin = (int)((double)barHeightPixels * (1.0D - supHeight));
        codeSup = s;
        if(s.length() != 2)
            return;
        currentX = (int)((double)currentX + (double)resolution * supSeparationCM);
        startSuplement = currentX;
        int i;
        try
        {
            i = Integer.valueOf(s).intValue();
        }
        catch(Exception exception)
        {
            i = 0;
        }
        String s1 = "OO";
        if(mod(i, 4D) == 1.0D)
            s1 = "OE";
        if(mod(i, 4D) == 2D)
            s1 = "EO";
        if(mod(i, 4D) == 3D)
            s1 = "EE";
        paintGuardChar(g, "bwb", "112", suplementTopMargin);
        String as[][] = setUPCEOdd;
        if(s1.charAt(0) == 'E')
            as = setUPCEEven;
        int j = findChar(as, "" + s.charAt(0));
        paintGuardChar(g, "wbwb", as[j][1], suplementTopMargin);
        paintGuardChar(g, "wb", "11", suplementTopMargin);
        as = setUPCEOdd;
        if(s1.charAt(1) == 'E')
            as = setUPCEEven;
        j = findChar(as, "" + s.charAt(1));
        paintGuardChar(g, "wbwb", as[j][1], suplementTopMargin);
        endSuplement = currentX;
    }

    protected void paintSup5(Graphics g, String s)
    {
        if(supplement.length() > 0)
            s = supplement;
        suplementTopMargin = (int)((double)barHeightPixels * (1.0D - supHeight));
        codeSup = s;
        if(s.length() != 5)
            return;
        boolean flag = true;
        int i = 0;
        int j = 0;
        for(int l = s.length() - 1; l >= 0; l--)
        {
            if(flag)
                i += (new Integer("" + s.charAt(l))).intValue();
            else
                j += (new Integer("" + s.charAt(l))).intValue();
            flag = !flag;
        }

        j = i * 3 + j * 9;
        String s1 = "" + j;
        int k = (new Integer("" + s1.charAt(s1.length() - 1))).intValue();
        String s2 = fiveSuplement[k];
        currentX = (int)((double)currentX + (double)resolution * supSeparationCM);
        startSuplement = currentX;
        paintGuardChar(g, "bwb", "112", suplementTopMargin);
        Object obj = null;
        for(int j1 = 0; j1 < 5; j1++)
        {
            String as[][] = setUPCEOdd;
            if(s2.charAt(j1) == 'E')
                as = setUPCEEven;
            int i1 = findChar(as, "" + s.charAt(j1));
            paintGuardChar(g, "wbwb", as[i1][1], suplementTopMargin);
            if(j1 < 4)
                paintGuardChar(g, "wb", "11", suplementTopMargin);
        }

        endSuplement = currentX;
    }

    protected void paintMAT25(Graphics g)
    {
        boolean flag = false;
        boolean flag1 = false;
        String s1 = code;
        paintChar(g, "bwbwbw", "wnnnnn");
        for(int j = 0; j < s1.length(); j++)
        {
            String s = "" + code.charAt(j);
            int i = findChar(set25, s);
            if(i >= 0)
                paintChar(g, "bwbwbw", set25[i][1] + "n");
        }

        paintChar(g, "bwbwbw", "wnnnnn");
    }

    protected void paintCODE39(Graphics g)
    {
        boolean flag = false;
        int k = 0;
        code = code.toUpperCase();
        paintChar(g, "bwbwbwbwb", set39[findChar(set39, "*")][1]);
        currentX = currentX + (int)narrowBarPixels;

        for(int l = 0; l < code.length(); l++)
        {
            String s = "" + code.charAt(l);
            int i = findChar(set39, s);
            if(i > -1)
            {
                k += i;
                paintChar(g, "bwbwbwbwb", set39[i][1]);
                currentX = currentX + (int)narrowBarPixels;
            }
        }

        if(checkCharacter)
        {
            int j = (int)mod(k, 43D);
            paintChar(g, "bwbwbwbwb", set39[j][1]);
            currentX = currentX + (int)narrowBarPixels;
            if(checkCharacterInText)
                codeText = code + "" + set39[j][0];
            else
                codeText = code;
        }
        paintChar(g, "bwbwbwbwb", set39[findChar(set39, "*")][1]);
    }

    protected void paintCODE11(Graphics g)
    {
        boolean flag = false;
        int l = 0;
        paintChar(g, "bwbwbw", "nnwwnn");
        int i1 = 1;
        l = 0;
        for(int j1 = code.length() - 1; j1 >= 0; j1--)
        {
            l += findChar(set11, "" + code.charAt(j1)) * i1;
            if(++i1 == 11)
                i1 = 1;
        }

        int j = (int)mod(l, 11D);
        i1 = 2;
        l = j;
        for(int k1 = code.length() - 1; k1 >= 0; k1--)
        {
            l += findChar(set11, "" + code.charAt(k1)) * i1;
            if(++i1 == 10)
                i1 = 1;
        }

        int k = (int)mod(l, 11D);
        for(int l1 = 0; l1 < code.length(); l1++)
        {
            String s = "" + code.charAt(l1);
            int i = findChar(set11, s);
            if(i > -1)
                paintChar(g, "bwbwbw", set11[i][1] + "n");
        }

        if(checkCharacter)
        {
            paintChar(g, "bwbwbw", set11[j][1] + "n");
            if(checkCharacterInText)
                codeText = code + set11[j][0];
            else
                codeText = code;
            if(code.length() > 10)
            {
                paintChar(g, "bwbwbw", set11[k][1] + "n");
                if(checkCharacterInText)
                    codeText = codeText + set11[k][0];
                else
                    codeText = code;
            }
        }
        paintChar(g, "bwbwbw", "nnwwnn");
    }

    protected void paintCODABAR(Graphics g)
    {
        boolean flag = false;
        int k = 0;
        paintChar(g, "bwbwbwbw", setCODABAR[findChar(setCODABAR, "" + CODABARStartChar)][1] + "n");
        k = findChar(setCODABAR, "" + CODABARStartChar) + findChar(setCODABAR, "" + CODABARStopChar);
        for(int l = code.length() - 1; l >= 0; l--)
            k += findChar(setCODABAR, "" + code.charAt(l));

        int j = (int)mod(k, 16D);
        if(j != 0)
            j = 16 - j;
        for(int i1 = 0; i1 < code.length(); i1++)
        {
            String s = "" + code.charAt(i1);
            int i = findChar(setCODABAR, s);
            if(i > -1)
                paintChar(g, "bwbwbwbw", setCODABAR[i][1] + "n");
        }

        if(checkCharacter)
        {
            if(checkCharacterInText)
                codeText = code + setCODABAR[j][0];
            else
                codeText = code;
            paintChar(g, "bwbwbwbw", setCODABAR[j][1] + "n");
        }
        paintChar(g, "bwbwbwb", setCODABAR[findChar(setCODABAR, "" + CODABARStopChar)][1]);
    }

    protected void paintMSI(Graphics g)
    {
        boolean flag = false;
        int k = 0;
        paintChar(g, "bw", "wn");
        k = 0;
        String s1 = "";
        boolean flag1 = true;
        for(int l = code.length() - 1; l >= 0; l--)
        {
            if(!flag1)
                k += findChar(setMSI, "" + code.charAt(l));
            if(flag1)
                s1 = findChar(setMSI, "" + code.charAt(l)) + s1;
            flag1 = !flag1;
        }

        s1 = "" + (new Long(s1)).longValue() * 2L;
        for(int i1 = s1.length() - 1; i1 >= 0; i1--)
            k += findChar(setMSI, "" + s1.charAt(i1));

        int j = (int)mod(k, 10D);
        if(j != 0)
            j = 10 - j;
        for(int j1 = 0; j1 < code.length(); j1++)
        {
            String s = "" + code.charAt(j1);
            int i = findChar(setMSI, s);
            if(i > -1)
                paintChar(g, "bwbwbwbw", setMSI[i][1]);
        }

        if(checkCharacter)
        {
            paintChar(g, "bwbwbwb", setMSI[j][1]);
            if(checkCharacterInText)
                codeText = code + setMSI[j][0];
            else
                codeText = code;
        }
        paintChar(g, "wbwb", "nnwn");
    }

    protected static double mod(double d1, double d2)
    {
        double d3 = d1 / d2;
        double d4 = Math.round(d3);
        if(d4 > d3)
            d4--;
        return d1 - d2 * d4;
    }

    protected void paintCODE39Ext(Graphics g)
    {
        boolean flag = false;
        int k = 0;
        paintChar(g, "bwbwbwbwb", set39[findChar(set39, "*")][1]);
        currentX = currentX + (int)narrowBarPixels;
        for(int l = 0; l < code.length(); l++)
        {
            byte byte0 = (byte)code.charAt(l);
            if(byte0 <= 128)
            {
                String s1 = set39Ext[byte0];
                for(int i1 = 0; i1 < s1.length(); i1++)
                {
                    String s = "" + s1.charAt(i1);
                    int i = findChar(set39, s);
                    if(i > -1)
                    {
                        k += i;
                        paintChar(g, "bwbwbwbwb", set39[i][1]);
                        currentX = currentX + (int)narrowBarPixels;
                    }
                }

            }
        }

        codeText = "";
        boolean flag1 = false;
        for(int k1 = 1; k1 <= code.length(); k1++)
        {
            int j1 = code.charAt(k1 - 1);
            if(j1 < 32 && j1 >= 0)
            {
                if(j1 == 13 || j1 == 9)
                    codeText = codeText + "  ";
            } else
            {
                codeText = codeText + (char)j1;
            }
        }

        if(checkCharacter)
        {
            int j = (int)mod(k, 43D);
            paintChar(g, "bwbwbwbwb", set39[j][1]);
            currentX = currentX + (int)narrowBarPixels;
            if(checkCharacterInText)
                codeText = codeText + "" + set39[j][0];
        }
        paintChar(g, "bwbwbwbwb", set39[findChar(set39, "*")][1]);
    }

    protected void paintBAR93(Graphics g)
    {
        boolean flag = false;
        int j = 0;
        int k = 0;
        int l = 0;
        paintChar(g, "bwbwbw", "111141");
        for(int i1 = 0; i1 < code.length(); i1++)
        {
            String s = "" + code.charAt(i1);
            int i = findChar(set93, s);
            if(i > -1)
            {
                j += i;
                paintChar(g, "bwbwbw", set93[i][1]);
            }
        }

        int j1 = 1;
        j = 0;
        for(int k1 = code.length() - 1; k1 >= 0; k1--)
        {
            j += findChar(set93, "" + code.charAt(k1)) * j1;
            if(++j1 == 21)
                j1 = 1;
        }

        l = (int)mod(j, 47D);
        j1 = 2;
        j = l;
        for(int l1 = code.length() - 1; l1 >= 0; l1--)
        {
            j += findChar(set93, "" + code.charAt(l1)) * j1;
            if(++j1 == 16)
                j1 = 1;
        }

        k = (int)mod(j, 47D);
        if(checkCharacter)
        {
            paintChar(g, "bwbwbw", set93[l][1]);
            paintChar(g, "bwbwbw", set93[k][1]);
            if(checkCharacterInText)
                codeText = code + set93[l][0].charAt(0) + set93[k][0].charAt(0);
            else
                codeText = code;
        }
        paintChar(g, "bwbwbwb", "1111411");
    }

    protected void paintBAR93Ext(Graphics g)
    {
        boolean flag = false;
        int k1 = 0;
        int l1 = 0;
        int i2 = 0;
        paintChar(g, "bwbwbw", "111141");
        for(int j2 = 0; j2 < code.length(); j2++)
        {
            byte byte0 = (byte)code.charAt(j2);
            if(byte0 <= 128)
            {
                String s5 = set93Ext[byte0];
                String s;
                if(s5.length() == 3)
                {
                    s = "" + s5.charAt(0) + s5.charAt(1);
                    int i = findChar(set93, s);
                    paintChar(g, "bwbwbw", set93[i][1]);
                    s = "" + s5.charAt(2);
                } else
                {
                    s = "" + s5.charAt(0);
                }
                int j = findChar(set93, s);
                k1 += j;
                paintChar(g, "bwbwbw", set93[j][1]);
            }
        }

        int k2 = 1;
        k1 = 0;
        for(int l2 = code.length() - 1; l2 >= 0; l2--)
        {
            byte byte1 = (byte)code.charAt(l2);
            if(byte1 <= 128)
            {
                String s6 = set93Ext[byte1];
                if(s6.length() == 3)
                {
                    String s1 = "" + s6.charAt(0) + s6.charAt(1);
                    int k = findChar(set93, s1);
                    k1 += k * (k2 + 1);
                    s1 = "" + s6.charAt(2);
                    k = findChar(set93, s1);
                    k1 += k * k2;
                    if(++k2 == 21)
                        k2 = 1;
                    if(++k2 == 21)
                        k2 = 1;
                } else
                {
                    String s2 = "" + s6.charAt(0);
                    int l = findChar(set93, s2);
                    k1 += l * k2;
                    if(++k2 == 21)
                        k2 = 1;
                }
            }
        }

        i2 = (int)mod(k1, 47D);
        k2 = 2;
        k1 = i2;
        for(int i3 = code.length() - 1; i3 >= 0; i3--)
        {
            byte byte2 = (byte)code.charAt(i3);
            if(byte2 <= 128)
            {
                String s7 = set93Ext[byte2];
                if(s7.length() == 3)
                {
                    String s3 = "" + s7.charAt(0) + s7.charAt(1);
                    int i1 = findChar(set93, s3);
                    k1 += i1 * (k2 + 1);
                    s3 = "" + s7.charAt(2);
                    i1 = findChar(set93, s3);
                    k1 += i1 * k2;
                    if(++k2 == 16)
                        k2 = 1;
                    if(++k2 == 16)
                        k2 = 1;
                } else
                {
                    String s4 = "" + s7.charAt(0);
                    int j1 = findChar(set93, s4);
                    k1 += j1 * k2;
                    if(++k2 == 16)
                        k2 = 1;
                }
            }
        }

        l1 = (int)mod(k1, 47D);
        if(checkCharacter)
        {
            paintChar(g, "bwbwbw", set93[i2][1]);
            paintChar(g, "bwbwbw", set93[l1][1]);
            if(checkCharacterInText)
                codeText = code + set93[i2][0].charAt(0) + set93[l1][0].charAt(0);
            else
                codeText = code;
        }
        paintChar(g, "bwbwbwb", "1111411");
    }

    protected void paintChar(Graphics g, String s, String s1)
    {
        paintChar2(g, s, s1, 0);
    }

    protected void paintChar2(Graphics g, String s, String s1, int i)
    {
        for(int j = 0; j < s.length(); j++)
        {
            char c = s.charAt(j);
            char c1 = s1.charAt(j);
            if(c1 == 'n')
                addBar(g, narrowBarPixels, c == 'b', i);
            if(c1 == 'w')
                addBar(g, widthBarPixels, c == 'b', i);
            if(c1 == '1')
                addBar(g, narrowBarPixels, c == 'b', i);
            if(c1 == '2')
                addBar(g, narrowBarPixels * 2, c == 'b', i);
            if(c1 == '3')
                addBar(g, narrowBarPixels * 3, c == 'b', i);
            if(c1 == '4')
                addBar(g, narrowBarPixels * 4, c == 'b', i);
        }

    }

    protected void paintGuardChar(Graphics g, String s, String s1, int i)
    {
        if(textFont != null && guardBars)
        {
            g.setFont(textFont);
            extraHeight = g.getFontMetrics().getHeight();
        }
        paintChar2(g, s, s1, i);
        extraHeight = 0;
    }

    protected void calculateSizes()
    {
        int i = code.length();
        narrowBarCM = X;
        widthBarCM = X * N;
		//System.out.println("narrowBarCM : " + narrowBarCM + " - widthBarCM : " + widthBarCM);
        if(barType == 2)
        {
            if(mod(i, 2D) == 0.0D && checkCharacter)
                i++;
            if(mod(i, 2D) == 1.0D && !checkCharacter)
                i++;
            if(checkCharacter)
                i++;
            L = (double)(i / 2) * (3D + 2D * N) * X + 7D * X;
        }
        if(barType == 6)
        {
            if(checkCharacter)
                i++;
            L = (double)(i * 7) * X + 11D * X;
        }
        if(barType == 10)
            L = (double)(i * 7) * X + 11D * X;
        if(barType == 11)
            L = (double)(i * 7) * X + 11D * X;
        if(barType == 13)
        {
            if(checkCharacter)
                i++;
            if(Code128Set == 'C')
                L = (double)(11 * i + 35) * X;
            else
                L = (5.5D * (double)i + 35D) * X;
        }
        if(barType == 12)
            L = 56D * X + 11D * X;
        if(barType == 7)
        {
            if(checkCharacter)
                i++;
            L = (double)i * (3D + 2D * N) * X + 7D * X;
        }
        if(barType == 8)
        {
            if(checkCharacter)
                i++;
            L = (double)i * (3D + 2D * N) * X + 7D * X;
        }
        if(barType == 5)
        {
            if(checkCharacter)
                i++;
            L = (double)i * (4D + 4D * N) * X + (1.0D + N) * X + (2D + N) * X;
        }
        if(barType == 4)
        {
            if(checkCharacter)
                i++;
            L = (double)(i + 2) * (4D + 3D * N) * X;
        }
        if(barType == 3)
        {
            if(checkCharacter || code.length() > 10)
                i++;
            L = (double)(i + 2 + 1) * (3D + 2D * N) * X;
        }
        if(barType == 15)
        {
            if(checkCharacter)
                i++;
            L = X * 10D;
        }
        if(barType == 0)
        {
            if(checkCharacter)
                i++;
            L = (double)(i + 2) * (3D * N + 6D) * X + (double)(i + 1) * I * X;
        }
        if(barType == 1)
        {
            int j = 0;
            if(checkCharacter)
                j++;
            for(int l = 0; l < code.length(); l++)
            {
                byte byte0 = (byte)code.charAt(l);
                if(byte0 <= 128)
                {
                    String s = set39Ext[byte0];
                    j += s.length();
                }
            }

            L = (double)(j + 2) * (3D * N + 6D) * X + (double)(j + 1) * I * X;
        }
        if(barType == 9 || barType == 14)
        {
            int k = 0;
            if(checkCharacter)
                k++;
            for(int i1 = 0; i1 < code.length(); i1++)
            {
                byte byte1 = (byte)code.charAt(i1);
                if(byte1 <= 128)
                {
                    String s1 = set39Ext[byte1];
                    if(s1.length() == 1)
                        k++;
                    else
                        k += 2;
                }
            }

            L = (double)(k + 2) * (9D * X) + (double)(k + 1) * I * X;
        }
        if(barHeightCM == 0.0D)
        {
            barHeightCM = L * H;
            if(barHeightCM < 0.625D)
                barHeightCM = 0.625D;
        }
        if(barHeightCM != 0.0D)
            barHeightPixels = (int)(barHeightCM * (double)resolution);
        if(narrowBarCM != 0.0D)
            narrowBarPixels = narrowBarCM * (double)resolution;
        if(widthBarCM != 0.0D)
            widthBarPixels = (double)narrowBarPixels * N;
        if(narrowBarPixels <= 0)
            narrowBarPixels = 1;
        if(widthBarPixels <= 1)
            widthBarPixels = narrowBarPixels * N;
		//System.out.println("barHeightCM : " + barHeightCM + " - L : " + L + " - narrowBarPixels : " + narrowBarPixels + " - widthBarPixels : " + widthBarPixels);
    }

    public void paint(Graphics g,int w,int h)
    {
        Graphics g1 = g;
        Image image = null;
        if(rotate != 0)
        {
            String s = System.getProperty("java.version");
            if(s.indexOf("1.0") == 0 || s.indexOf("1.1") == 0)
            {
                image = createImage(getSize().width, getSize().height);
                g1 = image.getGraphics();
            } else
            {
                IDAImageCreator idaimagecreator = new IDAImageCreator();
                image = idaimagecreator.getImage(getSize().width, getSize().height);
                g1 = idaimagecreator.getGraphics();
            }
        }
        g.setColor(backColor);
        g.fillRect(0, 0, w, h);
        user_defined_w = w;
        user_defined_h = h;
        paintBasis(g1);
        if(rotate != 0)
        {
            int i = currentX + leftMarginPixels;
            int j = currentY + topMarginPixels;
            Image image1 = rotate(image, rotate, i, j);
            if(image1 == null)
                g.drawImage(image, 0, 0, null);
            else
                g.drawImage(image1, 0, 0, null);
        }
    }

    protected void paintBasis(Graphics g)
    {
        codeText = "";
        calculateSizes();
        topMarginPixels = (int)(topMarginCM * (double)resolution);
        leftMarginPixels = (int)(leftMarginCM * (double)resolution);
        currentX = leftMarginPixels;
        g.setColor(barColor);
        int i = getSize().width;
        int j = getSize().height;
        int k = i;
        if(j > k)
            k = j;
        g.fillRect(0, 0, k, k);
        endOfCode = 0;
        if(barType == 3)
            paintCODE11(g);
        if(barType == 5)
            paintMSI(g);
        if(barType == 4)
            paintCODABAR(g);
        if(barType == 0)
            paintCODE39(g);
        if(barType == 1)
            paintCODE39Ext(g);
        if(barType == 2)
            paintInterleaved25(g);
        if(barType == 9)
            paintBAR93(g);
        if(barType == 11)
            paintEAN8(g);
        if(barType == 10)
            paintEAN13(g);
        if(barType == 6)
            paintUPCA(g);
        if(barType == 12)
            paintUPCE(g);
        if(barType == 13)
            paintCode128(g);
        if(barType == 14)
            paintBAR93Ext(g);
        if(barType == 7)
            paintIND25(g);
        if(barType == 8)
            paintMAT25(g);
        if(barType == 15)
            paintPOSTNET(g);
        if(barType == 16)
            paintPLANET(g);
        if(barType == 17)
            paintUCC128(g);
        if(endOfCode == 0)
            endOfCode = currentX;
        if(codeText.length() == 0)
            codeText = code;
        g.setColor(barColor);
        g.setFont(new Font("Arial", 0, 11));
        int l = g.getFontMetrics().getHeight();
        //g.drawString("IDAutomation.com, Inc. DEMO", leftMarginPixels, l + 1);
        if(rotate == 0 || rotate == 180)
        {
            pHeight = barHeightPixels + topMarginPixels + 20;
            pWidth = (int)widthBarPixels + topMarginPixels + 20;
        } else
        {
            pWidth = barHeightPixels + topMarginPixels + 20;
            pHeight = (int)widthBarPixels + topMarginPixels + 20;
        }
        currentY = barHeightPixels + topMarginPixels;
        if(textFont != null)
        {
            g.setColor(fontColor);
            g.setFont(textFont);
            int i1 = g.getFontMetrics().getHeight();
            int j1 = g.getFontMetrics().stringWidth("X");
            if((UPCEANSupplement2 || UPCEANSupplement5) && (barType == 11 || barType == 6 || barType == 12 || barType == 10))
            {
                int k1 = (endSuplement - startSuplement - g.getFontMetrics().stringWidth(codeSup)) / 2;
                if(k1 < 0)
                    k1 = 0;
                g.drawString(codeSup, startSuplement + k1, (topMarginPixels + suplementTopMargin) - 2);
            }
            if(barType == 15)
            {
                int l1 = (endOfCode - leftMarginPixels - g.getFontMetrics().stringWidth(codeText)) / 2;
                if(l1 < 0)
                    l1 = 0;
                g.drawString(codeText, leftMarginPixels + l1, (int)(postnetHeightTallBar * (double)resolution + (double)i1 + 1.0D + (double)topMarginPixels));
                currentY = barHeightPixels + i1 + 1 + topMarginPixels;
                return;
            }
            if(barType == 10 && guardBars && codeText.length() >= 13)
            {
                int i2 = 0;
                g.drawString(codeText.substring(0, 1), leftMarginPixels - j1, barHeightPixels + i1 + 1 + topMarginPixels);
                i2 = (centerGuardBarStart - leftGuardBar - g.getFontMetrics().stringWidth(codeText.substring(1, 7))) / 2;
                if(i2 < 0)
                    i2 = 0;
                g.drawString(codeText.substring(1, 7), leftGuardBar + i2, barHeightPixels + i1 + 1 + topMarginPixels);
                i2 = (rightGuardBar - centerGuardBarEnd - g.getFontMetrics().stringWidth(codeText.substring(7, 13))) / 2;
                if(i2 < 0)
                    i2 = 0;
                g.drawString(codeText.substring(7, 13), centerGuardBarEnd + i2, barHeightPixels + i1 + 1 + topMarginPixels);
                currentY = barHeightPixels + i1 + 1 + topMarginPixels;
                return;
            }
            if(barType == 6 && guardBars && codeText.length() >= 12)
            {
                int j2 = 0;
                g.drawString(codeText.substring(0, 1), leftMarginPixels - j1, barHeightPixels + i1 + 1 + topMarginPixels);
                j2 = (centerGuardBarStart - leftGuardBar - g.getFontMetrics().stringWidth(codeText.substring(1, 6))) / 2;
                if(j2 < 0)
                    j2 = 0;
                g.drawString(codeText.substring(1, 6), leftGuardBar + j2, barHeightPixels + i1 + 1 + topMarginPixels);
                j2 = (rightGuardBar - centerGuardBarEnd - g.getFontMetrics().stringWidth(codeText.substring(6, 11))) / 2;
                if(j2 < 0)
                    j2 = 0;
                g.drawString(codeText.substring(6, 11), centerGuardBarEnd + j2, barHeightPixels + i1 + 1 + topMarginPixels);
                g.drawString(codeText.substring(11, 12), endOfCode + 3, barHeightPixels + i1 + 1 + topMarginPixels);
                currentY = barHeightPixels + i1 + 1 + topMarginPixels;
                return;
            }
            if(barType == 11 && guardBars && codeText.length() >= 8)
            {
                int k2 = 0;
                k2 = (centerGuardBarStart - leftGuardBar - g.getFontMetrics().stringWidth(codeText.substring(0, 4))) / 2;
                if(k2 < 0)
                    k2 = 0;
                g.drawString(codeText.substring(0, 4), leftGuardBar + k2, barHeightPixels + i1 + 1 + topMarginPixels);
                k2 = (rightGuardBar - centerGuardBarEnd - g.getFontMetrics().stringWidth(codeText.substring(4, 8))) / 2;
                if(k2 < 0)
                    k2 = 0;
                g.drawString(codeText.substring(4, 8), centerGuardBarEnd + k2, barHeightPixels + i1 + 1 + topMarginPixels);
                currentY = barHeightPixels + i1 + 1 + topMarginPixels;
                return;
            }
            if(barType == 12 && guardBars)
            {
                int l2 = 0;
                g.drawString(codeText.substring(0, 1), leftMarginPixels - j1, barHeightPixels + i1 + 1 + topMarginPixels);
                l2 = (rightGuardBar - leftGuardBar - g.getFontMetrics().stringWidth(codeText)) / 2;
                if(l2 < 0)
                    l2 = 0;
                g.drawString(codeText.substring(1, 6), leftGuardBar + l2, barHeightPixels + i1 + 1 + topMarginPixels);
                g.drawString(codeText.substring(7, 1), rightGuardBar, barHeightPixels + i1 + 1 + topMarginPixels);
                currentY = barHeightPixels + i1 + 1 + topMarginPixels;
                return;
            }
            int i3 = (endOfCode - leftMarginPixels - g.getFontMetrics().stringWidth(codeText)) / 2;
            if(i3 < 0)
                i3 = 0;
            g.drawString(codeText, leftMarginPixels + i3, barHeightPixels + i1 + 1 + topMarginPixels);
            currentY = barHeightPixels + i1 + 1 + topMarginPixels;
        }
    }

    protected Image rotate(Image image, int i, int j, int k)
    {
        int l = image.getWidth(null);
        int i1 = image.getHeight(null);
        if(j > l)
            j = l;
        if(k > i1)
            k = i1;
        int ai[] = new int[l * i1];
        int ai1[] = new int[j * k];
        PixelGrabber pixelgrabber = new PixelGrabber(image, 0, 0, l, i1, ai, 0, l);
        try
        {
            pixelgrabber.grabPixels();
        }
        catch(InterruptedException interruptedexception)
        {
            System.err.println("interrupted waiting for pixels!");
            return null;
        }
        if((pixelgrabber.getStatus() & 0x80) != 0)
        {
            System.err.println("image fetch aborted or errored");
            return null;
        }
        if(i == 90)
        {
            for(int j1 = 0; j1 < j; j1++)
            {
                for(int i2 = 0; i2 < k; i2++)
                    ai1[k * (j - (j1 + 1)) + i2] = ai[i2 * l + j1];

            }

            if(system.indexOf("Linux") == -1)
              return Toolkit.getDefaultToolkit().createImage(new MemoryImageSource(k, j, ai1, 0, k));
            else
              return pja.createImage(new MemoryImageSource(k, j, ai1, 0, k));
        }
        if(i == 180)
        {
            for(int k1 = 0; k1 < j; k1++)
            {
                for(int j2 = 0; j2 < k; j2++)
                    ai1[(k - (j2 + 1)) * j + (j - (k1 + 1))] = ai[j2 * l + k1];

            }

            if(system.indexOf("Linux") == -1)
              return Toolkit.getDefaultToolkit().createImage(new MemoryImageSource(j, k, ai1, 0, j));
            else
              return pja.createImage(new MemoryImageSource(j, k, ai1, 0, j));
        }
        if(i == 270)
        {
            for(int l1 = 0; l1 < j; l1++)
            {
                for(int k2 = 0; k2 < k; k2++)
                    ai1[k * l1 + (k - (k2 + 1))] = ai[k2 * l + l1];

            }

            if(system.indexOf("Linux") == -1)
              return Toolkit.getDefaultToolkit().createImage(new MemoryImageSource(k, j, ai1, 0, k));
            else
              return pja.createImage(new MemoryImageSource(k, j, ai1, 0, k));
        } else
        {
            return null;
        }
    }

    public static int ext_code = -1;

    public static final int CODE39 = 0;
    public static final int CODE39EXT = 1;
    public static final int INTERLEAVED25 = 2;
    public static final int CODE11 = 3;
    public static final int CODABAR = 4;
    public static final int MSI = 5;
    public static final int UPCA = 6;
    public static final int IND25 = 7;
    public static final int MAT25 = 8;
    public static final int CODE93 = 9;
    public static final int EAN13 = 10;
    public static final int EAN8 = 11;
    public static final int UPCE = 12;
    public static final int CODE128 = 13;
    public static final int CODE93EXT = 14;
    public static final int POSTNET = 15;
    public static final int PLANET = 16;
    public static final int UCC128 = 17;
    public int barType;
    public String code;
    private String codeSup;
    public boolean checkCharacter;
    public boolean checkCharacterInText;
    public double postnetHeightTallBar;
    public double postnetHeightShortBar;
    public double leftMarginCM;
    protected static final int d = 3;
    public double topMarginCM;
    protected int leftMarginPixels;
    protected int topMarginPixels;
    private int leftGuardBar;
    private int centerGuardBarStart;
    private int centerGuardBarEnd;
    private int rightGuardBar;
    private int endOfCode;
    private int startSuplement;
    private int endSuplement;
    private int suplementTopMargin;
    public String supplement;
    public boolean guardBars;
    public Color backColor;
    public String codeText;
    protected double narrowBarPixels;
    protected double widthBarPixels;
    protected double narrowBarCM;
    protected double widthBarCM;
    public int resolution;
    protected int barHeightPixels;
    public double barHeightCM;
    public int width;
    public int height;
    private int pWidth;
    private int pHeight;
    public Font textFont;
    public Color fontColor;
    public Color barColor;
    private int extraHeight;
    public char UPCESytem;
    public char CODABARStartChar;
    public char CODABARStopChar;
    public boolean UPCEANSupplement2;
    public boolean UPCEANSupplement5;
    public char Code128Set;
    public double X;
    public double N;
    public double I;
    public double H;
    public double L;
    public int rotate;
    public double supSeparationCM;
    public double supHeight;
    public int currentX;
    protected int currentY;
    protected int user_defined_w;
    protected int user_defined_h;
    protected String set39[][] = {
        {
            "0", "nnnwwnwnn"
        }, {
            "1", "wnnwnnnnw"
        }, {
            "2", "nnwwnnnnw"
        }, {
            "3", "wnwwnnnnn"
        }, {
            "4", "nnnwwnnnw"
        }, {
            "5", "wnnwwnnnn"
        }, {
            "6", "nnwwwnnnn"
        }, {
            "7", "nnnwnnwnw"
        }, {
            "8", "wnnwnnwnn"
        }, {
            "9", "nnwwnnwnn"
        }, {
            "A", "wnnnnwnnw"
        }, {
            "B", "nnwnnwnnw"
        }, {
            "C", "wnwnnwnnn"
        }, {
            "D", "nnnnwwnnw"
        }, {
            "E", "wnnnwwnnn"
        }, {
            "F", "nnwnwwnnn"
        }, {
            "G", "nnnnnwwnw"
        }, {
            "H", "wnnnnwwnn"
        }, {
            "I", "nnwnnwwnn"
        }, {
            "J", "nnnnwwwnn"
        }, {
            "K", "wnnnnnnww"
        }, {
            "L", "nnwnnnnww"
        }, {
            "M", "wnwnnnnwn"
        }, {
            "N", "nnnnwnnww"
        }, {
            "O", "wnnnwnnwn"
        }, {
            "P", "nnwnwnnwn"
        }, {
            "Q", "nnnnnnwww"
        }, {
            "R", "wnnnnnwwn"
        }, {
            "S", "nnwnnnwwn"
        }, {
            "T", "nnnnwnwwn"
        }, {
            "U", "wwnnnnnnw"
        }, {
            "V", "nwwnnnnnw"
        }, {
            "W", "wwwnnnnnn"
        }, {
            "X", "nwnnwnnnw"
        }, {
            "Y", "wwnnwnnnn"
        }, {
            "Z", "nwwnwnnnn"
        }, {
            "-", "nwnnnnwnw"
        }, {
            ".", "wwnnnnwnn"
        }, {
            " ", "nwwnnnwnn"
        }, {
            "$", "nwnwnwnnn"
        }, {
            "/", "nwnwnnnwn"
        }, {
            "+", "nwnnnwnwn"
        }, {
            "%", "nnnwnwnwn"
        }, {
            "*", "nwnnwnwnn"
        }
    };
    protected String set25[][] = {
        {
            "0", "nnwwn"
        }, {
            "1", "wnnnw"
        }, {
            "2", "nwnnw"
        }, {
            "3", "wwnnn"
        }, {
            "4", "nnwnw"
        }, {
            "5", "wnwnn"
        }, {
            "6", "nwwnn"
        }, {
            "7", "nnnww"
        }, {
            "8", "wnnwn"
        }, {
            "9", "nwnwn"
        }
    };
    protected String setMSI[][] = {
        {
            "0", "nwnwnwnw"
        }, {
            "1", "nwnwnwwn"
        }, {
            "2", "nwnwwnnw"
        }, {
            "3", "nwnwwnwn"
        }, {
            "4", "nwwnnwnw"
        }, {
            "5", "nwwnnwwn"
        }, {
            "6", "nwwnwnnw"
        }, {
            "7", "nwwnwnwn"
        }, {
            "8", "wnnwnwnw"
        }, {
            "9", "wnnwnwwn"
        }
    };
    protected String set11[][] = {
        {
            "0", "nnnnw"
        }, {
            "1", "wnnnw"
        }, {
            "2", "nwnnw"
        }, {
            "3", "wwnnn"
        }, {
            "4", "nnwnw"
        }, {
            "5", "wnwnn"
        }, {
            "6", "nwwnn"
        }, {
            "7", "nnnww"
        }, {
            "8", "wnnwn"
        }, {
            "9", "wnnnn"
        }, {
            "-", "nnwnn"
        }
    };
    protected String setCODABAR[][] = {
        {
            "0", "nnnnnww"
        }, {
            "1", "nnnnwwn"
        }, {
            "2", "nnnwnnw"
        }, {
            "3", "wwnnnnn"
        }, {
            "4", "nnwnnwn"
        }, {
            "5", "wnnnnwn"
        }, {
            "6", "nwnnnnw"
        }, {
            "7", "nwnnwnn"
        }, {
            "8", "nwwnnnn"
        }, {
            "9", "wnnwnnn"
        }, {
            "-", "nnnwwnn"
        }, {
            "$", "nnwwnnn"
        }, {
            ":", "wnnnwnw"
        }, {
            "/", "wnwnnnw"
        }, {
            ".", "wnwnwnn"
        }, {
            "+", "nnwnwnw"
        }, {
            "A", "nnwwnwn"
        }, {
            "B", "nwnwnnw"
        }, {
            "C", "nnnwnww"
        }, {
            "D", "nnnwwwn"
        }
    };
    protected String set93[][] = {
        {
            "0", "131112"
        }, {
            "1", "111213"
        }, {
            "2", "111312"
        }, {
            "3", "111411"
        }, {
            "4", "121113"
        }, {
            "5", "121212"
        }, {
            "6", "121311"
        }, {
            "7", "111114"
        }, {
            "8", "131211"
        }, {
            "9", "141111"
        }, {
            "A", "211113"
        }, {
            "B", "211212"
        }, {
            "C", "211311"
        }, {
            "D", "221112"
        }, {
            "E", "221211"
        }, {
            "F", "231111"
        }, {
            "G", "112113"
        }, {
            "H", "112212"
        }, {
            "I", "112311"
        }, {
            "J", "122112"
        }, {
            "K", "132111"
        }, {
            "L", "111123"
        }, {
            "M", "111222"
        }, {
            "N", "111321"
        }, {
            "O", "121122"
        }, {
            "P", "131121"
        }, {
            "Q", "212112"
        }, {
            "R", "212211"
        }, {
            "S", "211122"
        }, {
            "T", "211221"
        }, {
            "U", "221121"
        }, {
            "V", "222111"
        }, {
            "W", "112122"
        }, {
            "X", "112221"
        }, {
            "Y", "122121"
        }, {
            "Z", "123111"
        }, {
            "-", "121131"
        }, {
            ".", "311112"
        }, {
            " ", "311211"
        }, {
            "$", "321111"
        }, {
            "/", "112131"
        }, {
            "+", "113121"
        }, {
            "%", "211131"
        }, {
            "_1", "121221"
        }, {
            "_2", "312111"
        }, {
            "_3", "311121"
        }, {
            "_4", "122211"
        }
    };
    protected String setUPCALeft[][] = {
        {
            "0", "3211"
        }, {
            "1", "2221"
        }, {
            "2", "2122"
        }, {
            "3", "1411"
        }, {
            "4", "1132"
        }, {
            "5", "1231"
        }, {
            "6", "1114"
        }, {
            "7", "1312"
        }, {
            "8", "1213"
        }, {
            "9", "3112"
        }
    };
    protected String setUPCARight[][] = {
        {
            "0", "3211"
        }, {
            "1", "2221"
        }, {
            "2", "2122"
        }, {
            "3", "1411"
        }, {
            "4", "1132"
        }, {
            "5", "1231"
        }, {
            "6", "1114"
        }, {
            "7", "1312"
        }, {
            "8", "1213"
        }, {
            "9", "3112"
        }
    };
    protected String setUPCEOdd[][] = {
        {
            "0", "3211"
        }, {
            "1", "2221"
        }, {
            "2", "2122"
        }, {
            "3", "1411"
        }, {
            "4", "1132"
        }, {
            "5", "1231"
        }, {
            "6", "1114"
        }, {
            "7", "1312"
        }, {
            "8", "1213"
        }, {
            "9", "3112"
        }
    };
    protected String setUPCEEven[][] = {
        {
            "0", "1123"
        }, {
            "1", "1222"
        }, {
            "2", "2212"
        }, {
            "3", "1141"
        }, {
            "4", "2311"
        }, {
            "5", "1321"
        }, {
            "6", "4111"
        }, {
            "7", "2131"
        }, {
            "8", "3121"
        }, {
            "9", "2113"
        }
    };
    protected String set39Ext[] = {
        "%U", "$A", "$B", "$C", "$D", "$E", "$F", "$G", "$H", "$I",
        "$J", "$K", "$L", "$M", "$N", "$O", "$P", "$Q", "$R", "$S",
        "$T", "$U", "$V", "$W", "$X", "$Y", "$Z", "%A", "%B", "%C",
        "%D", "%E", " ", "/A", "/B", "/C", "/D", "/E", "/F", "/G",
        "/H", "/I", "/J", "/K", "/L", "-", ".", "/O", "0", "1",
        "2", "3", "4", "5", "6", "7", "8", "9", "/Z", "%F",
        "%G", "%H", "%I", "%J", "%V", "A", "B", "C", "D", "E",
        "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
        "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y",
        "Z", "%K", "%L", "%M", "%N", "%O", "%W", "+A", "+B", "+C",
        "+D", "+E", "+F", "+G", "+H", "+I", "+J", "+K", "+L", "+M",
        "+N", "+O", "+P", "+Q", "+R", "+S", "+T", "+U", "+V", "+W",
        "+X", "+Y", "+Z", "%P", "%Q", "%R", "%S", "%T"
    };
    protected String set93Ext[] = {
        "_2U", "_1A", "_1B", "_1C", "_1D", "_1E", "_1F", "_1G", "_1H", "_1I",
        "_1J", "_1K", "_1L", "_1M", "_1N", "_1O", "_1P", "_1Q", "_1R", "_1S",
        "_1T", "_1U", "_1V", "_1W", "_1X", "_1Y", "_1Z", "_2A", "_2B", "_2C",
        "_2D", "_2E", " ", "_3A", "_3B", "_3C", "_3D", "_3E", "_3F", "_3G",
        "_3H", "_3I", "_3J", "_3K", "_3L", "-", ".", "_3O", "0", "1",
        "2", "3", "4", "5", "6", "7", "8", "9", "_3Z", "_2F",
        "_2G", "_2H", "_2I", "_2J", "_2V", "A", "B", "C", "D", "E",
        "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
        "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y",
        "Z", "_2K", "_2L", "_2M", "_2N", "_2O", "_2W", "_4A", "_4B", "_4C",
        "_4D", "_4E", "_4F", "_4G", "_4H", "_4I", "_4J", "_4K", "_4L", "_4M",
        "_4N", "_4O", "_4P", "_4Q", "_4R", "_4S", "_4T", "_4U", "_4V", "_4W",
        "_4X", "_4Y", "_4Z", "_2P", "_2Q", "_2R", "_2S", "_2T"
    };
    protected String UPCESystem0[] = {
        "EEEOOO", "EEOEOO", "EEOOEO", "EEOOOE", "EOEEOO", "EOOEEO", "EOOOEE", "EOEOEO", "EOEOOE", "EOOEOE"
    };
    protected String UPCESystem1[] = {
        "OOOEEE", "OOEOEE", "OOEEOE", "OOEEEO", "OEOOEE", "OEEOOE", "OEEEOO", "OEOEOE", "OEOEEO", "OEEOEO"
    };
    protected String setEANLeftA[][] = {
        {
            "0", "3211"
        }, {
            "1", "2221"
        }, {
            "2", "2122"
        }, {
            "3", "1411"
        }, {
            "4", "1132"
        }, {
            "5", "1231"
        }, {
            "6", "1114"
        }, {
            "7", "1312"
        }, {
            "8", "1213"
        }, {
            "9", "3112"
        }
    };
    protected String setEANLeftB[][] = {
        {
            "0", "1123"
        }, {
            "1", "1222"
        }, {
            "2", "2212"
        }, {
            "3", "1141"
        }, {
            "4", "2311"
        }, {
            "5", "1321"
        }, {
            "6", "4111"
        }, {
            "7", "2131"
        }, {
            "8", "3121"
        }, {
            "9", "2113"
        }
    };
    protected String setEANRight[][] = {
        {
            "0", "3211"
        }, {
            "1", "2221"
        }, {
            "2", "2122"
        }, {
            "3", "1411"
        }, {
            "4", "1132"
        }, {
            "5", "1231"
        }, {
            "6", "1114"
        }, {
            "7", "1312"
        }, {
            "8", "1213"
        }, {
            "9", "3112"
        }
    };
    protected String setEANCode[] = {
        "AAAAA", "ABABB", "ABBAB", "ABBBA", "BAABB", "BBAAB", "BBBAA", "BABAB", "BABBA", "BBABA"
    };
    protected String fiveSuplement[] = {
        "EEOOO", "EOEOO", "EOOEO", "EOOOE", "OEEOO", "OOEEO", "OOOEE", "OEOEO", "OEOOE", "OOEOE"
    };
    protected String set128[] = {
        "212222", "222122", "222221", "121223", "121322", "131222", "122213", "122312", "132212", "221213",
        "221312", "231212", "112232", "122132", "122231", "113222", "123122", "123221", "223211", "221132",
        "221231", "213212", "223112", "312131", "311222", "321122", "321221", "312212", "322112", "322211",
        "212123", "212321", "232121", "111323", "131123", "131321", "112313", "132113", "132311", "211313",
        "231113", "231311", "112133", "112331", "132131", "113123", "113321", "133121", "313121", "211331",
        "231131", "213113", "213311", "213131", "311123", "311321", "331121", "312113", "312311", "332111",
        "314111", "221411", "431111", "111224", "111422", "121124", "121421", "141122", "141221", "112214",
        "112412", "122114", "122411", "142112", "142211", "241211", "221114", "413111", "241112", "134111",
        "111242", "121142", "121241", "114212", "124112", "124211", "411212", "421112", "421211", "212141",
        "214121", "412121", "111143", "111341", "131141", "114113", "114311", "411113", "411311", "113141",
        "114131", "311141", "411131"
    };
    protected String set128B[] = {
        " ", "!", "\"", "#", "$", "%", "&", "'", "(", ")",
        "*", "+", ",", "-", ".", "/", "0", "1", "2", "3",
        "4", "5", "6", "7", "8", "9", ":", ";", "<", "=",
        ">", "?", "@", "A", "B", "C", "D", "E", "F", "G",
        "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q",
        "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[",
        "\\", "]", "^", "_", "`", "a", "b", "c", "d", "e",
        "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
        "p", "q", "r", "s", "t", "u", "v", "w", "x", "y",
        "z", "{", "|", "}", "~", "\303", "\304", "\305", "\306", "\307",
        "\310", "\311", "\312"
    };
    protected String set128C[] = {
        "00", "01", "02", "03", "04", "05", "06", "07", "08", "09",
        "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
        "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
        "30", "31", "32", "33", "34", "35", "36", "37", "38", "39",
        "40", "41", "42", "43", "44", "45", "46", "47", "48", "49",
        "50", "51", "52", "53", "54", "55", "56", "57", "58", "59",
        "60", "61", "62", "63", "64", "65", "66", "67", "68", "69",
        "70", "71", "72", "73", "74", "75", "76", "77", "78", "79",
        "80", "81", "82", "83", "84", "85", "86", "87", "88", "89",
        "90", "91", "92", "93", "94", "95", "96", "97", "98", "99",
        "\310\310", "\311\311", "\312\312"
    };
    protected String setPOSTNET[][] = {
        {
            "0", "11000"
        }, {
            "1", "00011"
        }, {
            "2", "00101"
        }, {
            "3", "00110"
        }, {
            "4", "01001"
        }, {
            "5", "01010"
        }, {
            "6", "01100"
        }, {
            "7", "10001"
        }, {
            "8", "10010"
        }, {
            "9", "10100"
        }
    };
    protected String setPLANET[][] = {
        {
            "0", "00111"
        }, {
            "1", "11100"
        }, {
            "2", "11010"
        }, {
            "3", "11001"
        }, {
            "4", "10110"
        }, {
            "5", "10101"
        }, {
            "6", "10011"
        }, {
            "7", "01110"
        }, {
            "8", "01101"
        }, {
            "9", "01011"
        }
    };
}
