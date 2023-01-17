<cfprocessingdirective suppresswhitespace="yes">
<cfsetting enablecfoutputonly="yes">
<!---
Description :   
    barcode print eder
Parameters :
    barcode	    : (required) yazdırılacak barcode
    type	    : (required) {EAN13, EAN8}
    extraHeight : (optional)  extra yükseklik miktarı
Syntax :
	<cf_barcode type="EAN13" barcode="012345678912" extra_height="0">
Sample :
	<cfif get_product_detail.add_unit neq "kg">
		<cfif (len(barcod) eq 13) or (len(barcod) eq 12)>
			<cf_barcode type="EAN13" barcode="#barcod#" extra_height="0"> <cfif len(errors)>#errors#</cfif>
		<cfelseif (len(barcod) eq 8) or (len(barcod) eq 7)>
			<cf_barcode type="EAN8" barcode="#barcod#" extra_height="0"> <cfif len(errors)>#errors#</cfif>
		</cfif>
	<cfelseif len(barcod) eq 7>
		<cf_barcode type="EAN13" barcode="#barcod#010000" extra_height="0"> <cfif len(errors)>#errors#</cfif>
	</cfif>
	
	created Ömür Camcı 20040716
	modified EK20040726,20041129
 --->
<cfset caller.errors = "">
<cfif not isDefined("attributes.barcode")>
	<cfset caller.errors = "<cfoutput>#caller.getLang('main',2178)#</cfoutput>!">
	<cfexit method="exittemplate">
</cfif>
<cfif len(attributes.barcode) gt 13>
	<cfset caller.errors = "<cfoutput>#caller.getLang('main',1679)#</cfoutput> !">
	<cfexit method="exittemplate">
</cfif>
<cfif not isDefined("attributes.type")>
	<cfset caller.errors = "<cfoutput>#caller.getLang('main',1449)#</cfoutput>!">
	<cfexit method="exittemplate">
</cfif>
<cfif not ListFindNoCase('EAN13,EAN8', attributes.type, ',')>
	<cfset caller.errors = "<cfoutput>#caller.getLang('main',2179)#</cfoutput> ! _<cfoutput>#attributes.type#</cfoutput>_">
	<cfexit method="exittemplate">
</cfif>
<cfif not isDefined("attributes.extraHeight")>
	<cfset attributes.extraHeight = 0>
</cfif>
<cfif not isDefined("attributes.height")>
	<cfset attributes.height = 0.5>
</cfif>
<cfscript>
	ext_code = -1;
	htmlCode = "";	
	EAN13 = 10;
	EAN8 = 11;
	/*
	CODE39 = 0;
	CODE39EXT = 1;
	ERLEAVED25 = 2;
	CODE11 = 3;
	CODABAR = 4;
	MSI = 5;
	UPCA = 6;
	IND25 = 7;
	MAT25 = 8;
	CODE93 = 9;
	UPCE = 12;
	CODE128 = 13;
	CODE93EXT = 14;
	POSTNET = 15;
	PLANET = 16;
	UCC128 = 17;
	supplement = "";
	CODABARStartChar = 'A';
	CODABARStopChar = 'B';
	Code128Set = '0';
	supSeparationCM = 0.5;
	supHeight = 0.8;
	user_defined_w = 0;
	user_defined_h = 0;
	rotate = 0;
	codeSup = "";
	topMarginCM = 0.1;
	leftMarginPixels = 0;
	topMarginPixels = 0;
	backColor = "white";
	width = 170;
	height = 70;
	barColor = "black";
	fontColor = "black";
	UPCESytem = '1';
	checkCharacterext = true;
	*/
	if(attributes.type eq 'EAN13')
		barType = 10;
	else
	if(attributes.type eq 'EAN8')
		barType = 11;			
	code = attributes.barcode;
	checkCharacter = true;
	leftMarginCM = 0.2;
	d = 3;
	sideGuardBar = 0;
	guardBars = true;
	codeText = "";
	narrowBarPixels = 0.0;
	widthBarPixels = 0.0;
	narrowBarCM = 0.0;
	widthBarCM = 0.0;
	/* 20041129 2.54 yerine 3.14 deneniyor kiler e gore bakilacak normalde dogru gibi*/
	//resolution = 64 / 2.54;
	resolution = 64 / 3.14;
	barHeightPixels = 0;
	barHeightCM = attributes.height;
	extraHeight = 10 + attributes.extraHeight;
	X = 0.06;
	I = 1;
	H = 0.45;
	L = 0.0;	
	N = 2;
	
	setEANCode = ArrayNew(1);
	temp1 = "AAAAA, ABABB, ABBAB, ABBBA, BAABB, BBAAB, BBBAA, BABAB, BABBA, BBABA";
	setEANCode = ListToArray(temp1, ',');
	
	setEANLeftA = ArrayNew(2);
	temp1 = "0,1,2,3,4,5,6,7,8,9";
	temp2 = "3211, 2221, 2122, 1411, 1132, 1231, 1114, 1312, 1213, 3112";
	setEANLeftA[1] = ListToArray(temp1, ',');
	setEANLeftA[2] = ListToArray(temp2, ',');
	
	setEANRight = ArrayNew(2);
	temp1 = "0,1,2,3,4,5,6,7,8,9";
	temp2 = "3211, 2221, 2122, 1411, 1132, 1231, 1114, 1312, 1213, 3112";	
	setEANRight[1] = ListToArray(temp1, ',');
	setEANRight[2] = ListToArray(temp2, ',');
	
	setEANLeftB = ArrayNew(2);
	temp1 = "0,1,2,3,4,5,6,7,8,9";
	temp2 = "1123, 1222, 2212, 1141, 2311, 1321, 4111, 2131, 3121, 2113";	
	setEANLeftB[1] = ListToArray(temp1, ',');
	setEANLeftB[2] = ListToArray(temp2, ',');
	
	setUPCEOdd = ArrayNew(2);
	temp1 = "0,1,2,3,4,5,6,7,8,9";
	temp2 = "3211, 2221, 2122, 1411, 1132, 1231, 1114, 1312, 1213, 3112";
	setUPCEOdd[1] = ListToArray(temp1, ',');
	setUPCEOdd[2] = ListToArray(temp2, ',');

	caller.paintBasis();

	WriteOutput("<table width='100%'><tr><td align='center'>" & htmlCode & "</td></tr></table>");

</cfscript>
<cfsetting enablecfoutputonly="no"></cfprocessingdirective>
