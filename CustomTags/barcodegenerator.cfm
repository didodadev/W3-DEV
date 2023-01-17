<cfsetting showdebugoutput="No">
<!-- ************************************** -->
<!-- EVALUATION VERSION                     -->
<!-- (C) Andy Brookfield                    -->
<!-- andyb@webcaterers.com                  -->
<!-- All rights reserved, all wrongs denied -->
<!-- Portions by Ray Thompson (thanks Ray!) -->
<!-- EVALUATION VERSION                     -->
<!-- ************************************** -->
<cfsetting enablecfoutputonly="Yes">
<cfparam name="Attributes.BarCodeType" default="1">
<cfparam name="Attributes.BarCode" default="1234567890">
<cfparam name="Attributes.Height" default="30">
<cfparam name="Attributes.ImageDir" default="/images/barcode/">
<cfparam name="Attributes.ThinWidth" default="#0.06 * (8 / 3.14)#">
<cfparam name="Attributes.ThickWidth" default="2">

<cfscript>
if(Attributes.BarCodeType eq 1 or Attributes.BarCodeType eq 2)
{
	TwoOfFive=ArrayNew(2);
	TwoOfFive[01]=ListToArray("0,0,1,1,0"); // Character 0
	TwoOfFive[02]=ListToArray("1,0,0,0,1"); // Character 1
	TwoOfFive[03]=ListToArray("0,1,0,0,1"); // Character 2
	TwoOfFive[04]=ListToArray("1,1,0,0,0"); // Character 3
	TwoOfFive[05]=ListToArray("0,0,1,0,1"); // Character 4
	TwoOfFive[06]=ListToArray("1,0,1,0,0"); // Character 5
	TwoOfFive[07]=ListToArray("0,1,1,0,0"); // Character 6
	TwoOfFive[08]=ListToArray("0,0,0,1,1"); // Character 7
	TwoOfFive[09]=ListToArray("1,0,0,1,0"); // Character 8
	TwoOfFive[10]=ListToArray("0,1,0,1,0"); // Character 9
	TwoOfFiveStart="0000";
	TwoOfFiveStop="101";
}
</cfscript>
<!--- 2 of 5 --->
<cfif Attributes.BarCodeType eq 1>
<cfset td_sayisi = 0>
<table cellpadding="0" cellspacing="0"><tr>
  <!--- 2 of 5 Interleaved --->
  <!--- Start character - thin, thin, thin, thin --->
  <cfset td_sayisi = td_sayisi + 1><cfoutput><td valign="top"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"></td></cfoutput>
  <!--- Main BarCode generator --->
  <cfloop index="c" from="1" to="#len(Attributes.BarCode)#" step="2">
    <cfset first=mid(Attributes.BarCode,c,1)+1>
    <cfset second=mid(Attributes.BarCode,c+1,1)+1>
    <cfloop index="t" from="1" to="5">
      <!--- Send a  bar, decide thin / thick --->
      <cfif TwoOfFive[first][t] eq 0>
        <!--- Thin bar --->
  		  <cfset td_sayisi = td_sayisi + 1><cfoutput><td valign="top"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"></td></cfoutput>
      <cfelse>
  	    <!--- Thick Bar --->
  		 <cfset td_sayisi = td_sayisi + 1> <cfoutput><td valign="top"><img width="#Attributes.ThickWidth#" src="#Attributes.ImageDir#thickbar.gif" height="#Attributes.height#"></td></cfoutput>
  	  </cfif>
      <!--- Send a space, decide thin / thick --->
      <cfif TwoOfFive[second][t] eq 0>
        <!--- Thin space --->
  		  <cfset td_sayisi = td_sayisi + 1><cfoutput><td valign="top"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"></td></cfoutput>
    	<cfelse>
  	    <!--- Thick Space --->
  		 <cfset td_sayisi = td_sayisi + 1><cfoutput><td valign="top"><img width="#Attributes.ThickWidth#" src="#Attributes.ImageDir#thickspace.gif" height="#Attributes.height#"></td></cfoutput>
  	  </cfif>
    </cfloop>
  </cfloop>
  <!--- Stop character, thick, thin, thin --->
  <cfset td_sayisi = td_sayisi + 1><cfoutput><td valign="top"><img width="#Attributes.ThickWidth#" src="#Attributes.ImageDir#thickbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"></td></cfoutput>
</tr>
  <tr>
  	<cfoutput><td colspan="#td_sayisi#" align="center" class="print" style="text-align:center;">#Attributes.BarCode#</td></cfoutput>
  </tr>
</table>
</cfif>

<!--- 2 of 5 Interleaved --->
<cfif Attributes.BarCodeType eq 2>
  <cfset td_sayisi = 0>
  <table cellpadding="0" cellspacing="0"><tr>
  <!--- Start character --->
	<cfset td_sayisi = td_sayisi + 1>
	<cfoutput><td valign="top"><img width="#Attributes.ThickWidth#" src="#Attributes.ImageDir#thickbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"><img width="#Attributes.ThickWidth#" src="#Attributes.ImageDir#thickbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"></td></cfoutput>
	<cfloop index="c" from="1" to="#len(Attributes.BarCode)#">
		<cfset number=mid(Attributes.BarCode,c,1)+1>
		<cfloop index="t" from="1" to="5">
		<cfif TwoOfFive[number][t] eq 0>
			<cfset td_sayisi = td_sayisi + 1><cfoutput><td valign="top"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"></td></cfoutput>
		<cfelse>
			<cfset td_sayisi = td_sayisi + 1> <cfoutput><td valign="top"><img width="#Attributes.ThickWidth#" src="#Attributes.ImageDir#thickbar.gif" height="#Attributes.height#"></td></cfoutput>
		</cfif>
		<cfset td_sayisi = td_sayisi + 1><cfoutput><td valign="top"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
		</cfloop>
	</cfloop>
	<!--- Stop character, thick, thin, thin --->
<cfset td_sayisi = td_sayisi + 1><cfoutput><td valign="top"><img width="#Attributes.ThickWidth#" src="#Attributes.ImageDir#thickbar.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#Attributes.ThickWidth#" src="#Attributes.ImageDir#thickbar.gif" height="#Attributes.Height#"></td></cfoutput>
  </tr>
  <tr>
  	<cfoutput><td colspan="#td_sayisi#" align="center" class="print" style="text-align:center;">#Attributes.BarCode#</td></cfoutput>
  </tr>
  </table>
</cfif>

<!--- Code 39 --->
<cfif Attributes.BarCodeType eq 3>
<!--- Code 3 of 9 representation --->
<cfset ThreeOfNine=ArrayNew(2)>
<cfset TNL=ArrayNew(2)>
<cfset ThreeOfNine[01]=ListToArray("1,0,0,1,0,0,0,0,1")> <!--- Code39 Character 1 --->
<cfset ThreeOfNine[02]=ListToArray("0,0,1,1,0,0,0,0,1")> <!--- Code39 Character 2 --->
<cfset ThreeOfNine[03]=ListToArray("1,0,1,1,0,0,0,0,0")> <!--- Code39 Character 3 --->
<cfset ThreeOfNine[04]=ListToArray("0,0,0,1,1,0,0,0,1")> <!--- Code39 Character 4 --->
<cfset ThreeOfNine[05]=ListToArray("1,0,0,1,1,0,0,0,0")> <!--- Code39 Character 5 --->
<cfset ThreeOfNine[06]=ListToArray("0,0,1,1,1,0,0,0,0")> <!--- Code39 Character 6 --->
<cfset ThreeOfNine[07]=ListToArray("0,0,0,1,0,0,1,0,1")> <!--- Code39 Character 7 --->
<cfset ThreeOfNine[08]=ListToArray("1,0,0,1,0,0,1,0,0")> <!--- Code39 Character 8 --->
<cfset ThreeOfNine[09]=ListToArray("0,0,1,1,0,0,1,0,0")> <!--- Code39 Character 9 --->
<cfset ThreeOfNine[10]=ListToArray("0,0,0,1,1,0,1,0,0")> <!--- Code39 Character 0 --->
<cfset ThreeOfNine[11]=ListToArray("1,0,0,0,0,1,0,0,1")> <!--- Code39 Character A --->
<cfset ThreeOfNine[12]=ListToArray("0,0,1,0,0,1,0,0,1")> <!--- Code39 Character B --->
<cfset ThreeOfNine[13]=ListToArray("1,0,1,0,0,1,0,0,0")> <!--- Code39 Character C --->
<cfset ThreeOfNine[14]=ListToArray("0,0,0,0,1,1,0,0,1")> <!--- Code39 Character D --->
<cfset ThreeOfNine[15]=ListToArray("1,0,0,0,1,1,0,0,0")> <!--- Code39 Character E --->
<cfset ThreeOfNine[16]=ListToArray("0,0,1,0,1,1,0,0,0")> <!--- Code39 Character F --->
<cfset ThreeOfNine[17]=ListToArray("0,0,0,0,0,1,1,0,1")> <!--- Code39 Character G --->
<cfset ThreeOfNine[18]=ListToArray("1,0,0,0,0,1,1,0,0")> <!--- Code39 Character H --->
<cfset ThreeOfNine[19]=ListToArray("0,0,1,0,0,1,1,0,0")> <!--- Code39 Character I --->
<cfset ThreeOfNine[20]=ListToArray("0,0,0,0,1,1,1,0,0")> <!--- Code39 Character J --->
<cfset ThreeOfNine[21]=ListToArray("1,0,0,0,0,0,0,1,1")> <!--- Code39 Character K --->
<cfset ThreeOfNine[22]=ListToArray("0,0,1,0,0,0,0,1,1")> <!--- Code39 Character L --->
<cfset ThreeOfNine[23]=ListToArray("1,0,1,0,0,0,0,1,0")> <!--- Code39 Character M --->
<cfset ThreeOfNine[24]=ListToArray("0,0,0,0,1,0,0,1,1")> <!--- Code39 Character N --->
<cfset ThreeOfNine[25]=ListToArray("1,0,0,0,1,0,0,1,0")> <!--- Code39 Character O --->
<cfset ThreeOfNine[26]=ListToArray("0,0,1,0,1,0,0,1,0")> <!--- Code39 Character P --->
<cfset ThreeOfNine[27]=ListToArray("0,0,0,0,0,0,1,1,1")> <!--- Code39 Character Q --->
<cfset ThreeOfNine[28]=ListToArray("1,0,0,0,0,0,1,1,0")> <!--- Code39 Character R --->
<cfset ThreeOfNine[29]=ListToArray("0,0,1,0,0,0,1,1,0")> <!--- Code39 Character S --->
<cfset ThreeOfNine[30]=ListToArray("0,0,0,0,1,0,1,1,0")> <!--- Code39 Character T --->
<cfset ThreeOfNine[31]=ListToArray("1,1,0,0,0,0,0,0,1")> <!--- Code39 Character U --->
<cfset ThreeOfNine[32]=ListToArray("0,1,1,0,0,0,0,0,1")> <!--- Code39 Character V --->
<cfset ThreeOfNine[33]=ListToArray("1,1,1,0,0,0,0,0,0")> <!--- Code39 Character W --->
<cfset ThreeOfNine[34]=ListToArray("0,1,0,0,1,0,0,0,1")> <!--- Code39 Character X --->
<cfset ThreeOfNine[35]=ListToArray("1,1,0,1,0,0,0,0,0")> <!--- Code39 Character Y --->
<cfset ThreeOfNine[36]=ListToArray("0,1,1,0,1,0,0,0,0")> <!--- Code39 Character Z --->
<cfset ThreeOfNine[37]=ListToArray("0,0,0,0,0,0,0,0,0")> <!--- Code39 Character - --->
<cfset ThreeOfNine[38]=ListToArray("1,1,0,0,0,0,1,0,0")> <!--- Code39 Character . --->
<cfset ThreeOfNine[39]=ListToArray("0,1,1,0,0,0,1,0,0")> <!--- Code39 Character (space) --->
<cfset ThreeOfNine[40]=ListToArray("0,1,0,0,1,0,1,0,0")> <!--- Code39 Start/Stop Character --->
<cfset ThreeOfNine[41]=ListToArray("0,1,0,1,0,1,0,0,0")> <!--- Code39 Character $ --->
<cfset ThreeOfNine[42]=ListToArray("0,1,0,1,0,0,0,1,0")> <!--- Code39 Character / --->
<cfset ThreeOfNine[43]=ListToArray("0,1,0,0,0,1,0,1,0")> <!--- Code39 Character + (LowerCase) --->
<cfset ThreeOfNine[44]=ListToArray("0,0,0,1,0,1,0,1,0")> <!--- Code39 Character % --->

<cfset TNL[01]=ListToArray("!,2,42,11")>
<cfset TNL[02][01]=""><cfset TNL[02][02]=2><cfset TNL[02][03]=42><cfset TNL[02][04]=12>
<cfset TNL[03][01]=""><cfset TNL[03][02]=2><cfset TNL[03][03]=42><cfset TNL[03][04]=13>
<cfset TNL[04]=ListToArray("$,2,42,14")>
<cfset TNL[05]=ListToArray("%,2,42,15")>
<cfset TNL[06]=ListToArray("&,2,42,16")>
<cfset TNL[07]=ListToArray("',2,42,17")>
<cfset TNL[08]=ListToArray("(,2,42,18")>
<cfset TNL[09]=ListToArray("),2,42,19")>
<cfset TNL[10]=ListToArray("*,2,42,20")>
<cfset TNL[11]=ListToArray("+,2,42,21")>
<cfset TNL[12]=ListToArray(",|2|42|22","|")>
<cfset TNL[13]=ListToArray("-,1,37")>
<cfset TNL[14]=ListToArray(".,1,38")>
<cfset TNL[15]=ListToArray("/,2,42,25")>
<cfset TNL[16]=ListToArray("0,1,10")>
<cfset TNL[17]=ListToArray("1,1,1")>
<cfset TNL[18]=ListToArray("2,1,2")>
<cfset TNL[19]=ListToArray("3,1,3")>
<cfset TNL[20]=ListToArray("4,1,4")>
<cfset TNL[21]=ListToArray("5,1,5")>
<cfset TNL[22]=ListToArray("6,1,6")>
<cfset TNL[23]=ListToArray("7,1,2")>
<cfset TNL[24]=ListToArray("8,1,8")>
<cfset TNL[25]=ListToArray("9,1,9")>
<cfset TNL[26]=ListToArray(":,2,42,36")>
<cfset TNL[27]=ListToArray(";,2,44,16")>
<cfset TNL[28]=ListToArray("<,2,44,17")>
<cfset TNL[29]=ListToArray("=,2,44,18")>
<cfset TNL[30]=ListToArray(">,2,44,19")>
<cfset TNL[31]=ListToArray("?,2,44,20")>
<cfset TNL[32]=ListToArray("@,2,44,32")>
<cfset TNL[33]=ListToArray("A,1,11")>
<cfset TNL[34]=ListToArray("B,1,12")>
<cfset TNL[35]=ListToArray("C,1,13")>
<cfset TNL[36]=ListToArray("D,1,14")>
<cfset TNL[37]=ListToArray("E,1,15")>
<cfset TNL[38]=ListToArray("F,1,16")>
<cfset TNL[39]=ListToArray("G,1,17")>
<cfset TNL[40]=ListToArray("H,1,18")>



<cfset TNL[41]=ListToArray("I,1,19")>
<cfset TNL[42]=ListToArray("J,1,20")>
<cfset TNL[43]=ListToArray("K,1,21")>
<cfset TNL[44]=ListToArray("L,1,22")>
<cfset TNL[45]=ListToArray("M,1,23")>
<cfset TNL[46]=ListToArray("N,1,24")>
<cfset TNL[47]=ListToArray("O,1,25")>
<cfset TNL[48]=ListToArray("P,1,26")>
<cfset TNL[49]=ListToArray("Q,1,27")>
<cfset TNL[50]=ListToArray("R,1,28")>
<cfset TNL[51]=ListToArray("S,1,29")>
<cfset TNL[52]=ListToArray("T,1,30")>
<cfset TNL[53]=ListToArray("U,1,31")>
<cfset TNL[54]=ListToArray("V,1,32")>
<cfset TNL[55]=ListToArray("W,1,33")>
<cfset TNL[56]=ListToArray("X,1,34")>
<cfset TNL[57]=ListToArray("Y,1,35")>
<cfset TNL[58]=ListToArray("Z,1,36")>
<cfset TNL[59]=ListToArray("[,2,44,21")>
<cfset TNL[60]=ListToArray("\,2,44,22")>
<cfset TNL[61]=ListToArray("],2,44,23")>
<cfset TNL[62]=ListToArray("^,2,44,24")>
<cfset TNL[63]=ListToArray("_,2,44,25")>
<cfset TNL[64]=ListToArray("`,2,44,33")>
<cfset TNL[65]=ListToArray("{,2,44,26")>
<cfset TNL[66]=ListToArray("|,2,44,27")>
<cfset TNL[67]=ListToArray("},2,44,28")>
<cfset TNL[68]=ListToArray("~,2,44,29")>
<cfset TNL[69]=ListToArray("[,2,44,21")>
<cfset TNL[70][1]=" ">
<cfset TNL[70][2]=1>
<cfset TNL[70][3]=39>
<table cellpadding="0" cellspacing="0"><tr>
<cfset Code39ThickWidth=Attributes.ThinWidth * 3>
<cfset Code39ThinWidth=Attributes.ThinWidth>
  <!--- Code39 Start Character --->
  <cfloop index="t" from="1" to="9">
    <cfif t mod 2 eq 1>
      <cfif ThreeOfNine[40][t] eq 1>
        <!--- Thick Bar --->
      	<cfoutput><td valign="top"><img width="#Code39ThickWidth#" src="#Attributes.ImageDir#code39thickbar.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfelse>
        <!--- Thin Bar --->
      	<cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
      </cfif>
    <cfelse>
      <cfif ThreeOfNine[40][t] eq 1>
        <!--- Thick Space --->
    	  <cfoutput><td valign="top"><img  width="#Code39ThickWidth#" src="#Attributes.ImageDir#code39thickspace.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfelse>
        <!--- Thin Space --->
    	  <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
      </cfif>
    </cfif>
  </cfloop>
  <!--- Inter character gap --->
  <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
  <cfloop index="c" from="1" to="#len(Attributes.BarCode)#">
    <!--- Grab the character and find the number of elements to --->
    <!--- make up this character                                --->
    <cfset char = mid(Attributes.BarCode,c,1)>
    <cfloop index="cc" from="1" to="70">
      <cfif TNL[cc][1] eq "#UCase(char)#">
        <cfset ndx=cc>
        <cfbreak>
      </cfif>
    </cfloop>
  
    <!--- Add lower case character --->
    <cfif Asc(char) gte Asc("a") AND Asc(char) lte Asc("z")>
      <cfloop index="t" from="1" to="9">
      <cfif t mod 2 eq 1>
        <cfif ThreeOfNine[40][t] eq 1>
          <!--- Thick Bar --->
	        <cfoutput><td valign="top"><img  width="#Code39ThickWidth#" src="#Attributes.ImageDir#code39thickbar.gif" height="#Attributes.Height#"></td></cfoutput>
        <cfelse>
          <!--- Thin Bar --->
	        <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
        </cfif>
      <cfelse>
        <cfif ThreeOfNine[40][t] eq 1>
          <!--- Thick Space --->
	        <cfoutput><td valign="top"><img  width="#Code39ThickWidth#" src="#Attributes.ImageDir#code39thickspace.gif" height="#Attributes.Height#"></td></cfoutput>
        <cfelse>
          <!--- Thin Space --->
	        <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
        </cfif>
      </cfif>
      </cfloop>
      <!--- Inter character gap --->
      <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
    </cfif>
  
    <cfloop index="CharacterCounter" from="1" to="#TNL[ndx][2]#">
    <cfset Character=CharacterCounter+2>
      <cfloop index="t" from="1" to="9">
        <cfif t mod 2 eq 1> 
          <cfif ThreeOfNine[TNL[ndx][Character]][t] eq 1>
            <!--- Thick Bar --->
            <cfoutput><td valign="top"><img  width="#Code39ThickWidth#" src="#Attributes.ImageDir#code39thickbar.gif" height="#Attributes.Height#"></td></cfoutput>
          <cfelse>
            <!--- Thin Bar --->
            <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
          </cfif>
        <cfelse>
          <cfif ThreeOfNine[TNL[ndx][Character]][t] eq 1>
            <!--- Thick Space --->
            <cfoutput><td valign="top"><img  width="#Code39ThickWidth#" src="#Attributes.ImageDir#code39thickspace.gif" height="#Attributes.Height#"></td></cfoutput>
          <cfelse>
            <!--- Thin Space --->
            <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
          </cfif>
        </cfif>
      </cfloop>
      <!--- Inter character gap --->
      <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
    </cfloop>
  </cfloop>
  
  <!--- Code39 Stop Character --->
  <cfloop index="t" from="1" to="9">
    <cfif t mod 2 eq 1>
      <cfif ThreeOfNine[40][t] eq 1>
        <!--- Thick Bar --->
    	  <cfoutput><td valign="top"><img  width="#Code39ThickWidth#" src="#Attributes.ImageDir#code39thickbar.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfelse>
        <!--- Thin Bar --->
    	  <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
      </cfif>
    <cfelse>
      <cfif ThreeOfNine[40][t] eq 1>
        <!--- Thick Space --->
    	  <cfoutput><td valign="top"><img  width="#Code39ThickWidth#" src="#Attributes.ImageDir#code39thickspace.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfelse>
        <!--- Thin Space --->
    	  <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
      </cfif>
    </cfif>
  </cfloop>
  <!--- Inter character gap --->
  <cfoutput><td valign="top"><img  width="#Code39ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
</tr></table>

</cfif>

<!--- PostNet --->
<!--- PostNet --->
<cfif Attributes.BarCodeType eq 4>
<!--- PostNet Character Representation --->
<cfset PostNet=ArrayNew(2)>
<cfset PostNet[1]=ListToArray("1,1,0,0,0")><!--- Character 0 --->
<cfset PostNet[2]=ListToArray("0,0,0,1,1")><!--- Character 1 --->
<cfset PostNet[3]=ListToArray("0,0,1,0,1")><!--- character 2 --->
<cfset PostNet[4]=ListToArray("0,0,1,1,0")><!--- Character 3 --->
<cfset PostNet[5]=ListToArray("0,1,0,0,1")><!--- Character 4 --->
<cfset PostNet[6]=ListToArray("0,1,0,1,0")><!--- Character 5 --->
<cfset PostNet[7]=ListToArray("0,1,1,0,0")><!--- Character 6 --->
<cfset PostNet[8]=ListToArray("1,0,0,0,1")><!--- Character 7 --->
<cfset PostNet[9]=ListToArray("1,0,0,1,0")><!--- Character 8 --->
<cfset PostNet[10]=ListToArray("1,0,1,0,0")><!--- Character 9 --->


<cfloop index="c" from="1" to="#len(Attributes.BarCode)#">
  <cfset char = mid(Attributes.BarCode,c,1) + 1>
  <cfloop index="t" from="1" to="5"> <!--- Character generation --->
    <cfif PostNet[char][t] is 1>
  	    <cfset ht="30">
	  <cfelse>
	    <cfset ht="15">
	</cfif>
   <cfoutput><img width="2" src="#Attributes.ImageDir#thickbar.gif" height="#ht#"><img width="2" src="#Attributes.ImageDir#thickspace.gif"></cfoutput>
  </cfloop>
</cfloop>
</cfif>

<!--- Codabar --->
<cfif Attributes.BarcodeType eq 5>
<cfset Codabar=ArrayNew(2)>
<cfset Codabar[1]=ListToArray("0,0,0,0,0,0,1,1")> <!--- Character 0 --->
<cfset Codabar[2]=ListToArray("1,0,0,0,0,1,0,1")> <!--- Character 1 --->
<cfset Codabar[3]=ListToArray("2,0,0,0,1,0,1,0")> <!--- Character 2 --->
<cfset Codabar[4]=ListToArray("3,1,1,0,0,0,0,0")> <!--- Character 3 --->
<cfset Codabar[5]=ListToArray("4,0,0,1,0,0,1,0")> <!--- Character 4 --->
<cfset Codabar[6]=ListToArray("5,1,0,0,0,0,1,0")> <!--- Character 5 --->
<cfset Codabar[7]=ListToArray("6,0,1,0,0,0,0,1")> <!--- Character 6 --->
<cfset Codabar[8]=ListToArray("7,0,1,0,0,1,0,0")> <!--- Character 7 --->
<cfset Codabar[9]=ListToArray("8,0,1,1,0,0,0,0")> <!--- Character 8 --->
<cfset Codabar[10]=ListToArray("9,1,0,0,1,0,0,0")> <!--- Character 9 --->
<cfset Codabar[11]=ListToArray("-,0,0,0,1,1,0,0")> <!--- Character - --->
<cfset Codabar[12]=ListToArray("$,0,0,1,1,0,0,0")> <!--- Character $ --->
<cfset Codabar[13]=ListToArray(":,1,0,0,0,1,0,1")> <!--- Character : --->
<cfset Codabar[14]=ListToArray("/,1,0,1,0,0,0,1")> <!--- Character / --->
<cfset Codabar[15]=ListToArray(".,1,0,1,0,1,0,0")> <!--- Character . --->
<cfset Codabar[16]=ListToArray("+,0,0,1,0,1,0,1")> <!--- Character + --->
<cfset Codabar[17]=ListToArray("a,0,0,1,1,0,1,0")> <!--- Character a --->
<cfset Codabar[18]=ListToArray("b,0,1,0,1,0,0,1")> <!--- Character b --->
<cfset Codabar[19]=ListToArray("c,0,0,0,1,0,1,1")> <!--- Character c --->
<cfset Codabar[20]=ListToArray("d,0,0,0,1,1,1,0")> <!--- Character d --->
<table cellpadding="0" cellspacing="0"><tr>
  <cfloop index="c" from="1" to="#len(Attributes.BarCode)#">
    <!--- Grab the character and find the number of elements to --->
    <!--- make up this character                                --->
    <cfset char = mid(Attributes.BarCode,c,1)>
    <cfloop index="cc" from="1" to="70">
      <cfif Codabar[cc][1] eq "#UCase(char)#">
        <cfset ndx=cc>
        <cfbreak>
      </cfif>
    </cfloop>
    <!--- Generate the character --->
    <cfloop index="t" from="2" to="8">
    <cfif t mod 2 eq 1>
      <cfif Codabar[ndx][t] eq 1>
        <!--- Thick Bar --->
      	<cfoutput><td valign="top"><img width="#Attributes.ThickWidth#" src="#Attributes.ImageDir#thickspace.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfelse>
        <!--- Thin Bar --->
      	<cfoutput><td valign="top"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
      </cfif>
    <cfelse>
      <cfif Codabar[ndx][t] eq 1>
        <!--- Thick Space --->
    	  <cfoutput><td valign="top"><img width="#Attributes.ThickWidth#" src="#Attributes.ImageDir#thickbar.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfelse>
        <!--- Thin Space --->
    	  <cfoutput><td valign="top"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
      </cfif>
    </cfif>
	</cfloop>
</cfloop>
</tr></table>
</cfif>

<!--- UPC(e) --->
<!--- UPC(e) --->
<cfif Attributes.BarcodeType eq 6> 
<table cellpadding="0" cellspacing="0"><tr>
<cfset UPC_E=ArrayNew(2)>
<cfset UPC_CheckCode=ArrayNew(2)>

<!--- 1=Even, 0=Odd --->
<cfset UPC_CheckCode[1]=ListToArray("1,1,1,0,0,0")>
<cfset UPC_CheckCode[2]=ListToArray("1,1,0,1,0,0")>
<cfset UPC_CheckCode[3]=ListToArray("1,1,0,0,1,0,")>
<cfset UPC_CheckCode[4]=ListToArray("1,1,0,0,0,1,")>
<cfset UPC_CheckCode[5]=ListToArray("1,0,1,1,0,0,")>
<cfset UPC_CheckCode[6]=ListToArray("1,0,0,1,1,0,")>
<cfset UPC_CheckCode[7]=ListToArray("1,0,0,0,1,1,")>
<cfset UPC_CheckCode[8]=ListToArray("1,0,1,0,1,0,")>
<cfset UPC_CheckCode[9]=ListToArray("1,0,1,0,0,1,")>
<cfset UPC_CheckCode[10]=ListToArray("1,0,0,1,0,1,")>

<cfset UPC_E[1]=ListToArray("0,0,0,1,1,0,1,0,1,0,0,1,1,1")>
<cfset UPC_E[2]=ListToArray("0,0,1,1,0,0,1,0,1,1,0,0,1,1")>

<cfset UPC_E[3]=ListToArray("0,0,1,0,0,1,1,0,0,1,1,0,1,1")>
<cfset UPC_E[4]=ListToArray("0,1,1,1,1,0,1,0,1,0,0,0,0,1")>
<cfset UPC_E[5]=ListToArray("0,1,0,0,0,1,1,0,0,1,1,1,0,1")>
<cfset UPC_E[6]=ListToArray("0,1,1,0,0,0,1,0,1,1,1,0,0,1")>
<cfset UPC_E[7]=ListToArray("0,1,0,1,1,1,1,0,0,0,0,1,0,1")>
<cfset UPC_E[8]=ListToArray("0,1,1,1,0,1,1,0,0,1,0,0,0,1")>
<cfset UPC_E[9]=ListToArray("0,1,1,0,1,1,1,0,0,0,1,0,0,1")>
<cfset UPC_E[10]=ListToArray("0,0,0,1,0,1,1,0,0,1,0,1,1,1")>

<cfset M1=0>
<!--- 10-( ((1,3,5)*3) + (2,4,6)) MOD 10) --->
<cfloop index="BCG_c" from="1" to="5" step="2">
<cfset M1=M1+val(mid(Attributes.BarCode,BCG_c,1))>
</cfloop>
<cfset M1=M1*3>
<cfloop index="BCG_c" from="2" to="6" step="2">
<cfset M1=M1+val(mid(Attributes.BarCode,BCG_c,1))>
</cfloop>
<cfset BCG_Check_Char=(10 - (M1 MOD 10))+1>
<!--- Guard bars --->
<cfset TrueDescender=(Attributes.height * 0.1)+Attributes.height>
<cfoutput><td valign="top"><img  width="2" align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><img  width="2" align="texttop" src="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><img  width="2" align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"></td></cfoutput>

<cfloop index="BCG_c" from="1" to="6">
<cfset BCG_char=mid(Attributes.BarCode,BCG_c,1)+1>
<cfset BCG_Offset=UPC_CheckCode[BCG_Check_Char][BCG_c] * 7>

  <cfloop index="BCG_l" from="1" to="7">
    <cfif UPC_E[BCG_char][BCG_Offset+BCG_l] eq 1>
       <cfoutput><td valign="top"><img   width="2" align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"></td></cfoutput>
	<cfelse>
       <cfoutput><td valign="top"><img   width="2" align="texttop" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"></td></cfoutput>
	</cfif>
  </cfloop>
</cfloop>

<!--- Guard bars --->
<cfoutput><td valign="top"><img  width="2" align="texttop"  src="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><img  width="2" align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><img   width="2" align="texttop" src="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><img   width="2" align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><img   width="2" align="texttop" src="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><img   width="2" align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"></td></cfoutput>
</tr></table>
</cfif>

<!--- UPC(a) --->
<cfif Attributes.BarcodeType eq 7>
<table cellpadding="0" cellpadding="0"><tr>
	<cfset UPC_A=ArrayNew(2)>
	<cfset UPC_A[1] =ListToArray("0,0,0,1,1,0,1,1,1,1,0,0,1,0")>
	<cfset UPC_A[2] =ListToArray("0,0,1,1,0,0,1,1,1,0,0,1,1,0")>
	<cfset UPC_A[3] =ListToArray("0,0,1,0,0,1,1,1,1,0,1,1,0,0")>
	<cfset UPC_A[4] =ListToArray("0,1,1,1,1,0,1,1,0,0,0,0,1,0")>
	<cfset UPC_A[5] =ListToArray("0,1,0,0,0,1,1,1,0,1,1,1,0,0")>
	<cfset UPC_A[6] =ListToArray("0,1,1,0,0,0,1,1,0,0,1,1,1,0")>
	<cfset UPC_A[7] =ListToArray("0,1,0,1,1,1,1,1,0,1,0,0,0,0")>
	<cfset UPC_A[8] =ListToArray("0,1,1,1,0,1,1,1,0,0,0,1,0,0")>
	<cfset UPC_A[9] =ListToArray("0,1,1,0,1,1,1,1,0,0,1,0,0,0")>
	<cfset UPC_A[10]=ListToArray("0,0,0,1,0,1,1,1,1,1,0,1,0,0")>

	<!--- Guard bars --->
	<cfset TrueDescender=(Attributes.height * 0.15)+Attributes.height>
	<cfoutput><td valign="top"><img align="texttop"  width="1" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"  width="2" ><img  align="texttop"  width="1" src="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><img  align="texttop"  width="1" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"></td></cfoutput>
	<cfloop index="BCG_c" from="1" to="12">
	<cfset BCG_char=mid(Attributes.BarCode,BCG_c,1)+1>
	<cfset BCG_Offset=((BCG_c \ 7) * 7)>
	<!--- First and Last Character uses True-Descenders --->
		<cfif ( (BCG_c eq 1) OR (BCG_c eq 12) )>
		  <cfset BarHeight=(Attributes.height * 0.15)+Attributes.height>
		<cfelse>
		  <cfset BarHeight=Attributes.height>
		</cfif>
	  <cfloop index="BCG_l" from="1" to="7">
		<cfif UPC_A[BCG_char][BCG_Offset+BCG_l] eq 1>
		   <cfoutput><td valign="top"><img  width="1"  align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#BarHeight#"></td></cfoutput>
		<cfelse>
		   <cfoutput><td valign="top"><img  width="1"  align="texttop" src="#Attributes.ImageDir#thinspace.gif" height="#BarHeight#"></td></cfoutput>
		</cfif>
	  </cfloop>
  <!--- Center Bars --->
	  <cfif BCG_c eq 6>
	  <cfoutput><td valign="top"><img  width="1"  align="texttop" src="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><img  width="1"  align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><img  width="1"  align="texttop" src="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><img  width="1"  align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><img  width="1"  align="texttop" src="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"></td></cfoutput>
	  </cfif>
	</cfloop>

	<!--- Guard bars --->
	<cfoutput><td valign="top"><img  width="1" align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><img   width="1" align="texttop" src="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><img   width="1" align="texttop" src="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"></td></cfoutput>

</tr></table> 
</cfif>



<!--- Code128 --->
<cfset Code128=ArrayNew(2)>
<cfset The128Code=ArrayNew(1)>
<cfset Code128[1]=ListToArray(" ,2,1,2,2,2,2")> <!--- (space) (space) 00 --->
<cfset Code128[2]=ListToArray("!,2,2,2,1,2,2")> <!---    !       !    01 --->
<cfset Code128[3]=ListToArray(" ,2,1,2,2,2,2")>
<cfset Code128[4]=ListToArray(" ,2,1,2,2,2,2")>
<cfset Code128[5]=ListToArray("$,1,2,1,3,2,2")>
<cfset Code128[6]=ListToArray("%,1,3,1,2,2,2")>
<cfset Code128[7]=ListToArray("&,1,2,2,2,1,3")>
<cfset Code128[8]=ListToArray("',1,2,2,3,1,2")>
<cfset Code128[9]=ListToArray("(,1,3,2,2,1,2")>
<cfset Code128[10]=ListToArray("),2,2,1,2,1,3")>
<cfset Code128[11]=ListToArray("*,2,2,1,3,1,2")>
<cfset Code128[12]=ListToArray("+,2,3,1,2,1,2")>
<cfset Code128[13]=ListToArray("',1,1,2,2,3,2")>
<cfset Code128[14]=ListToArray("-,1,2,2,1,3,2")>
<cfset Code128[15]=ListToArray(".,1,2,2,2,3,1")>
<cfset Code128[16]=ListToArray("/,1,1,3,2,2,2")>
<cfset Code128[17]=ListToArray("0,1,2,3,1,2,2")>
<cfset Code128[18]=ListToArray("1,1,2,3,2,2,1")>
<cfset Code128[19]=ListToArray("2,2,2,3,2,1,1")>
<cfset Code128[20]=ListToArray("3,2,2,1,1,3,2")>
<cfset Code128[21]=ListToArray("4,2,2,1,2,3,1")>
<cfset Code128[22]=ListToArray("5,2,1,3,2,1,2")>
<cfset Code128[23]=ListToArray("6,2,2,3,1,1,2")>
<cfset Code128[24]=ListToArray("7,3,1,2,1,3,1")>
<cfset Code128[25]=ListToArray("8,3,1,1,2,2,2")>
<cfset Code128[26]=ListToArray("9,3,2,1,1,2,2")>
<cfset Code128[27]=ListToArray(":,3,2,1,2,2,1")>
<cfset Code128[28]=ListToArray(";,3,1,2,2,1,2")>
<cfset Code128[29]=ListToArray("<,3,2,2,1,1,2")>
<cfset Code128[30]=ListToArray("=,3,2,2,2,1,1")>
<cfset Code128[31]=ListToArray(">,2,1,2,1,2,3")>
<cfset Code128[32]=ListToArray("?,2,1,2,3,2,1")>
<cfset Code128[33]=ListToArray("@,2,3,2,1,2,1")>
<cfset Code128[34]=ListToArray("A,1,1,1,3,2,3")>
<cfset Code128[35]=ListToArray("B,1,3,1,1,2,3")>
<cfset Code128[36]=ListToArray("C,1,3,1,3,2,1")>
<cfset Code128[37]=ListToArray("D,1,1,2,3,1,3")>
<cfset Code128[38]=ListToArray("E,1,3,2,1,1,3")>
<cfset Code128[39]=ListToArray("F,1,3,2,3,1,1")>
<cfset Code128[40]=ListToArray("G,2,1,1,3,1,3")>
<cfset Code128[41]=ListToArray("H,2,3,1,1,1,3")>
<cfset Code128[42]=ListToArray("I,2,3,1,3,1,1")>
<cfset Code128[43]=ListToArray("J,1,1,2,1,3,3")>
<cfset Code128[44]=ListToArray("K,1,1,2,3,3,1")>
<cfset Code128[45]=ListToArray("L,1,3,2,1,3,1")>
<cfset Code128[46]=ListToArray("M,1,1,3,1,2,3")>
<cfset Code128[47]=ListToArray("N,1,1,3,3,2,1")>
<cfset Code128[48]=ListToArray("O,1,3,3,1,2,1")>
<cfset Code128[49]=ListToArray("P,3,1,3,1,2,1")>
<cfset Code128[50]=ListToArray("Q,2,1,1,3,3,1")>
<cfset Code128[51]=ListToArray("R,2,3,1,1,3,1")>
<cfset Code128[52]=ListToArray("S,2,1,3,1,1,3")>
<cfset Code128[53]=ListToArray("T,2,1,3,3,1,1")>
<cfset Code128[54]=ListToArray("U,2,1,3,1,3,1")>
<cfset Code128[55]=ListToArray("V,3,1,1,1,2,3")>
<cfset Code128[56]=ListToArray("W,3,1,1,3,2,1")>
<cfset Code128[57]=ListToArray("X,3,3,1,1,2,1")>
<cfset Code128[58]=ListToArray("Y,3,1,2,1,1,3")>
<cfset Code128[59]=ListToArray("Z,3,1,2,3,1,1")>
<cfset Code128[60]=ListToArray("[,3,3,2,1,1,1")>
<cfset Code128[61]=ListToArray("\,3,1,4,1,1,1")>
<cfset Code128[62]=ListToArray("],2,2,1,4,1,1")>
<cfset Code128[63]=ListToArray("^,4,3,1,1,1,1")>
<cfset Code128[64]=ListToArray("_,1,1,1,2,2,4")>
<cfset Code128[65]=ListToArray("`,1,1,1,4,2,2")>
<cfset Code128[66]=ListToArray("a,1,2,1,1,2,4")>
<cfset Code128[67]=ListToArray("b,1,2,1,4,2,1")>
<cfset Code128[68]=ListToArray("c,1,4,1,1,2,2")>
<cfset Code128[69]=ListToArray("d,1,4,1,2,2,1")>
<cfset Code128[70]=ListToArray("e,1,1,2,2,1,4")>
<cfset Code128[71]=ListToArray("f,1,1,2,4,1,2")>
<cfset Code128[72]=ListToArray("g,1,2,2,1,1,4")>
<cfset Code128[73]=ListToArray("h,1,2,2,4,1,1")>
<cfset Code128[74]=ListToArray("i,1,4,2,1,1,2")>
<cfset Code128[75]=ListToArray("j,1,4,2,2,1,1")>
<cfset Code128[76]=ListToArray("k,2,4,1,2,1,1")>
<cfset Code128[77]=ListToArray("l,2,2,1,1,1,4")>
<cfset Code128[78]=ListToArray("m,4,1,3,1,1,1")>
<cfset Code128[79]=ListToArray("n,2,4,1,1,1,2")>
<cfset Code128[80]=ListToArray("o,1,3,4,1,1,1")>
<cfset Code128[81]=ListToArray("p,1,1,1,2,4,2")>
<cfset Code128[82]=ListToArray("q,1,2,1,1,4,2")>
<cfset Code128[83]=ListToArray("r,1,2,1,2,4,1")>
<cfset Code128[84]=ListToArray("s,1,1,4,2,1,2")>
<cfset Code128[85]=ListToArray("t,1,2,4,1,1,2")>
<cfset Code128[86]=ListToArray("u,1,2,4,2,1,1")>
<cfset Code128[87]=ListToArray("v,4,1,1,2,1,2")>
<cfset Code128[88]=ListToArray("w,4,2,1,1,1,2")>
<cfset Code128[89]=ListToArray("x,4,2,1,2,1,1")>
<cfset Code128[90]=ListToArray("y,2,1,2,1,4,1")>
<cfset Code128[91]=ListToArray("z,2,1,4,1,2,1")>
<cfset Code128[92]=ListToArray("{,4,1,2,1,2,1")>
<cfset Code128[93]=ListToArray("|,1,1,1,1,4,3")>
<cfset Code128[94]=ListToArray("},1,1,1,3,4,1")>
<cfset Code128[95]=ListToArray("~,1,3,1,1,4,1")>
<cfset Code128[96]=ListToArray("^_,1,1,4,1,1,3")>
<cfset Code128[97]=ListToArray("FNC3,1,1,4,3,1,1")>
<cfset Code128[98]=ListToArray("FNC2,4,1,1,1,1,3")>
<cfset Code128[99]=ListToArray("SHIFTB,4,1,1,3,1,1")>
<cfset Code128[100]=ListToArray("CODEC,1,1,3,1,4,1")>
<cfset Code128[101]=ListToArray("CODEB,1,1,4,1,3,1")>
<cfset Code128[102]=ListToArray("FNC4,3,1,1,1,4,1")>
<cfset Code128[103]=ListToArray("FNC1,4,1,1,1,3,1")>
<cfset Code128[104]=ListToArray("STARTA,2,1,1,4,1,2")>
<cfset Code128[105]=ListToArray("STARTB,2,1,1,2,1,4")>
<cfset Code128[106]=ListToArray("STARTC,2,1,1,2,3,2")>
<cfset Code128[107]=ListToArray("STOP,2,3,3,1,1,1,2")>

<cfif Attributes.BarCodeType eq 8>
<table cellpadding="0" cellspacing="0"><tr>
<!--- By default characterset B --->
<cfset found=0>
<cfset swapper=2>
<cfset ndx=0>
<cfset m=1>
<cfset td_sayisi = 0>
<!--- Start Character --->
		  <cfoutput>
		   <td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td>
		   <td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td>
           <td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td>
		   <td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td>
           <td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td>
		   <td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td>
		   </cfoutput>
<cfset td_sayisi = td_sayisi + 6>
<cfset Checksum=104>
<!--- Main barcode generator --->
<cfloop index="c" from="1" to="#len(Attributes.BarCode)#">
  <cfset first=mid(Attributes.BarCode,c,1)>
    <!--- 100 charcters per character set --->
    <cfloop index="i" from="1" to="95">
       <cfif Code128[i][1] eq first>
             <cfset ndx=i>
             <cfbreak>
       </cfif>
    </cfloop>
 
  <!--- Character number is "i" --->
  <!--- Calculate checksum character --->
	<cfset Checksum=Checksum + (c*(ndx-1))>
      <cfloop index="cc" from="2" to="7"> <!--- send the character to the display --->
         <cfif cc MOD 2 eq 0> <!--- BAR --->
		   <!--- Check width of bars --->
		   <cfloop index="BCG_cc" from="1" to="#Code128[ndx][cc]#">
		   		<cfset td_sayisi = td_sayisi + 1>
				<cfoutput><td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
		   </cfloop>
		 <cfelse>
		   <!--- Check width of spaces --->
		   <cftry>
            <cfloop index="BCG_cc" from="1" to="#Code128[ndx][cc]#">
                    <cfset td_sayisi = td_sayisi + 1>
                    <cfoutput><td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
               </cfloop>
            <cfcatch type="any">
                <cfloop index="BCG_cc" from="1" to="1">
                    <cfset td_sayisi = td_sayisi + 1>
                    <cfoutput><td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
               </cfloop>
            </cfcatch>
            </cftry>
		   <!--- <cfloop index="BCG_cc" from="1" to="#Code128[ndx][cc]#">
		   		<cfset td_sayisi = td_sayisi + 1>
				<cfoutput><td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
		   </cfloop> --->
		 </cfif>
      </cfloop>
</cfloop>



<cfset ndx=(Checksum MOD 103)+1>

<!--- Checksum charcater --->
      <cfloop index="cc" from="2" to="7"> <!--- send the character to the display --->
         <cfif cc MOD 2 eq 0> <!--- BAR --->
		   <!--- Check width of bars --->
		   <cfloop index="BCG_cc" from="1" to="#Code128[ndx][cc]#">
		     <cfset td_sayisi = td_sayisi + 1>
			 <cfoutput><td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
		   </cfloop>
		 <cfelse>
		   <!--- Check width of spaces --->
		   <cftry>  
               <cfloop index="BCG_cc" from="1" to="#Code128[ndx][cc]#">
                     <cfset td_sayisi = td_sayisi + 1>
                     <cfoutput><td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
               </cfloop>
           <cfcatch type="any">
               <cfloop index="BCG_cc" from="1" to="1">
                     <cfset td_sayisi = td_sayisi + 1>
                     <cfoutput><td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
               </cfloop>
           </cfcatch>
           </cftry>
		 </cfif>
      </cfloop>

<cfoutput>
	<td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td>
	<td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td>
	<td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td>
	<td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td>
	<td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td>
	<td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td>
	<td valign="top" width="#Attributes.ThinWidth#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td>
</cfoutput>
<cfset td_sayisi = td_sayisi + 7>
</tr>
<tr>
<td colspan="<cfoutput>#td_sayisi#</cfoutput>" align="center" style="font-size:10px;text-align:center;"><cfoutput>#Attributes.BarCode#</cfoutput></td>
</tr>
</table>
</cfif>


<!--- Code128 Characterset C --->
<cfif Attributes.BarCodeType eq 11>
<cfset td_sayisi = 0>
<table cellpadding="0" cellspacing="0"><tr>
<!--- start C  --->
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
	<cfset td_sayisi = td_sayisi + 11>
  <cfset Checksum = 105>
  <cfset DigitCounter=1>
  <cfif (len(Attributes.BarCode) mod 2) eq 1>
  	<cfset Attributes.Barcode2 = "0#Attributes.BarCode#">	
<cfelse>	
  	<cfset Attributes.Barcode2 = "#Attributes.BarCode#">	
  </cfif>
  <cfloop index="c" from="1" to="#len(Attributes.BarCode2)#" step="2">
    <cfset first=mid(Attributes.BarCode2,c,1)>
   <cfset thisChar = (first*10) + mid(Attributes.BarCode2,c+1,1)>
   <cfset thisChar = thisChar+1>
   
	<cfset Checksum=Checksum + (DigitCounter*(thisChar-1))>
     <cfset DigitCounter=DigitCounter+1>
     <!--- generate the character --->
    <cfloop index="cc" from="2" to="7">
        <cfif cc MOD 2 eq 0> <!--- BAR --->
		   <!--- Check width of bars --->
           <cfloop index="BCG_cc" from="1" to="#Code128[thisChar][cc]#">
		     <cfset td_sayisi = td_sayisi + 1>
			 <cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
           </cfloop>
		 <cfelse>
		   <!--- Check width of spaces --->
		    <cftry>
            <cfloop index="BCG_cc" from="1" to="#Code128[thisChar][cc]#">
		     <cfset td_sayisi = td_sayisi + 1>
			 <cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
           </cfloop>
            <cfcatch type="any">
                <cfloop index="BCG_cc" from="1" to="1">
		     <cfset td_sayisi = td_sayisi + 1>
			 <cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
           </cfloop>
            </cfcatch>
            </cftry>
         </cfif>
      <!--- generate the character --->
      </cfloop> 
  </cfloop> <!--- Cycle thru barcode string --->

  <cfset CheckDigit = (Checksum MOD 103)+1>
  <!--- Generate check digit --->
      <cfloop index="cc" from="2" to="7">
         <cfif cc MOD 2 eq 0> <!--- BAR --->
		   <!--- Check width of bars --->
           <cfloop index="BCG_cc" from="1" to="#Code128[CheckDigit][cc]#">
		     <cfset td_sayisi = td_sayisi + 1>
			 <cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
           </cfloop>
		 <cfelse>
		   <!--- Check width of spaces --->
		   <cfloop index="BCG_cc" from="1" to="#Code128[CheckDigit][cc]#">
		     <cfset td_sayisi = td_sayisi + 1>
			 <cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
           </cfloop>
         </cfif>
      </cfloop>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
<cfoutput><td valign="top"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfset td_sayisi = td_sayisi + 7>
</tr>
<tr>
<td colspan="<cfoutput>#td_sayisi#</cfoutput>" align="center" style="font-size:10px;text-align:center;"><cfoutput>#Attributes.BarCode#</cfoutput></td>
</tr>
</table>
</cfif>

<!--- EAN --->

<cfif Attributes.BarCodeType eq 9>
<cfset EAN=ArrayNew(2)>
<cfset EANLOOKUP=ArrayNew(2)>

<cfset EAN[1]=ListToArray("0,0,0,1,1,0,1,0,1,0,0,1,1,1,1,1,1,0,0,1,0")>
<cfset EAN[2]=ListToArray("0,0,1,1,0,0,1,0,1,1,0,0,1,1,1,1,0,0,1,1,0")>
<cfset EAN[3]=ListToArray("0,0,1,0,0,1,1,0,0,1,1,0,1,1,1,1,0,1,1,0,0")>
<cfset EAN[4]=ListToArray("0,1,1,1,1,0,1,0,1,0,0,0,0,1,1,0,0,0,0,1,0")>
<cfset EAN[5]=ListToArray("0,1,0,0,0,1,1,0,0,1,1,1,0,1,1,0,1,1,1,0,0")>
<cfset EAN[6]=ListToArray("0,1,1,0,0,0,1,0,1,1,1,0,0,1,1,0,0,1,1,1,0")>
<cfset EAN[7]=ListToArray("0,1,0,1,1,1,1,0,0,0,0,1,0,1,1,0,1,0,0,0,0")>
<cfset EAN[8]=ListToArray("0,1,1,1,0,1,1,0,0,1,0,0,0,1,1,0,0,0,1,0,0")>
<cfset EAN[9]=ListToArray("0,1,1,0,1,1,1,0,0,0,1,0,0,1,1,0,0,1,0,0,0")>
<cfset EAN[10]=ListToArray("0,0,0,1,0,1,1,0,0,1,0,1,1,1,1,1,1,0,1,0,0")>

<cfset EANLOOKUP[1]=ListToArray("0,0,0,0,0,0,1,1,1,1,1,1,1")>
<cfset EANLOOKUP[2]=ListToArray("0,0,1,0,1,1,1,1,1,1,1,1,1")>
<cfset EANLOOKUP[3]=ListToArray("0,0,1,1,0,1,1,1,1,1,1,1,1")>
<cfset EANLOOKUP[4]=ListToArray("0,0,1,1,1,0,1,1,1,1,1,1,1")>
<cfset EANLOOKUP[5]=ListToArray("0,1,0,0,1,1,1,1,1,1,1,1,1")>
<cfset EANLOOKUP[6]=ListToArray("0,1,1,0,0,1,1,1,1,1,1,1,1")>
<cfset EANLOOKUP[7]=ListToArray("0,1,1,1,0,0,1,1,1,1,1,1,1")>
<cfset EANLOOKUP[8]=ListToArray("0,1,0,1,0,1,1,1,1,1,1,1,1")>
<cfset EANLOOKUP[9]=ListToArray("0,1,0,1,1,0,1,1,1,1,1,1,1")>
<cfset EANLOOKUP[10]=ListToArray("0,1,1,0,1,0,1,1,1,1,1,1,1")>
<cfset td_sayisi = 0>
<table cellpadding="0" cellspacing="0"><tr>
<cfset EANLOOKUPCHAR=Val(left(Attributes.BarCode,1))+1>
<!--- Guard bars --->
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
<cfset td_sayisi = td_sayisi + 3>
<!--- Loop thru the barcode --->
<cfloop index="EANCHAR" from="2" to="#Len("#Attributes.BarCode#")#">
  <cfset EANBarChar=Mid(Attributes.BarCode,EANCHAR,1)+1>
  <!--- <cfoutput>#Evaluate(EANBarChar-1)#</cfoutput> --->
  <cfif EANCHAR lte 7>
    <cfset ENL=EANLOOKUP[EANLOOKUPCHAR][EANCHAR-1]>
   <cfelse>
    <cfset ENL=2>
  </cfif>
  <cfset fm=Evaluate((#ENL#*7)+1)>
  <cfset ft=Evaluate((#ENL#*7)+7)>
  <!--- <cfoutput>-#fm#-#ft#</cfoutput> --->
  <cfloop index="ELOOK" from="#fm#" to="#ft#">
    <cfif EAN[EANBarChar][ELOOK] is 1>
      <cfset td_sayisi = td_sayisi + 1><cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
     <cfelse>
      <cfset td_sayisi = td_sayisi + 1><cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
    </cfif>
  </cfloop>
  <cfif EANCHAR eq 7><!--- Middle bars --->
      <!--- <cfoutput>*</cfoutput> --->
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
  		<cfset td_sayisi = td_sayisi + 5>
  </cfif>
</cfloop>
<!--- Guard bars --->
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></td></cfoutput>
      <cfoutput><td valign="top"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></td></cfoutput>
	  <cfset td_sayisi = td_sayisi + 3>
</tr>
<cfoutput><tr><td colspan="#td_sayisi#" align="center" class="print" style="text-align:center;">#Attributes.barcode#</td></tr></cfoutput>
</table>
</cfif>
<cfsetting enablecfoutputonly="No">
