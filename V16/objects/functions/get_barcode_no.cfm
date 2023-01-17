<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="get_barcode_no" returntype="any" output="false">
<cfargument name="barcode_for_ean8" default="">
	<!---
	by :   20040110 , 20050407 barkod kullanan sistemlerde otomatik barkod olusturmak icin gerekli (sadece EAN13 simbolojisi icin)
	notes :
		DB deki son barkod elemanini alir ve 12. elemani 1 arttirip sonra da kontrol karakteri ekler..
	usage :
		get_barcode_no()
	<cfset barcode_no = get_barcode_no()>
		revisions : 20050107 20050409
	--->
    <cfif arguments.barcode_for_ean8 neq 1>
        <cflock name="#CreateUUID()#" timeout="20">
            <cftransaction>
                <cfquery name="GET_BARCODE_NO_" datasource="#DSN1#">
                    SELECT BARCODE FROM PRODUCT_NO
                </cfquery>
                <cfif GET_BARCODE_NO_.recordcount>
                    <cfset wrk_barcode = left(trim(GET_BARCODE_NO_.BARCODE),12)>
                    <cfquery name="UPDATE_BARCODE_NO_" datasource="#DSN1#">
                        UPDATE PRODUCT_NO SET BARCODE = '#wrk_barcode+1#X'<!--- 20050107 buradaki X in onemi yok kontorl karakteri yerine temporary bir deger --->
                    </cfquery>
                <cfelse>
                    <cfset wrk_barcode = ''>
                </cfif>
            </cftransaction>
        </cflock>
        <cfscript>
            if(len(wrk_barcode)){
                wrk_barcode = wrk_barcode+1;
                if(len(wrk_barcode) eq 12)
                    return wrk_barcode & UPCEANCheck(wrk_barcode);
                if(Len(wrk_barcode) lt 13)
                    return '';
                }
            else
                return '';
        </cfscript>
    <cfelse>
        <cflock name="#CreateUUID()#" timeout="20">
            <cftransaction>
                <cfquery name="GET_BARCODE_NO_" datasource="#DSN1#">
                    SELECT BARCODE_EAN8 FROM PRODUCT_NO
                </cfquery>
                <cfif GET_BARCODE_NO_.recordcount>
                    <cfset wrk_barcode = left(trim(GET_BARCODE_NO_.BARCODE_EAN8),7)>                    
                    <cfset wrk_barcode = Int(wrk_barcode)>
                	<cfset len1= len(wrk_barcode)>
					<cfset deger = 7 - (len1)>
                    <cfset wrk_barcode = wrk_barcode+1>
                    <cfloop from = "1" to = "#deger#" index = "xxx"> 
                    <cfset wrk_barcode = 0 & wrk_barcode>
                    </cfloop> 
                             
                    <cfquery name="UPDATE_BARCODE_NO_" datasource="#DSN1#">
                        UPDATE PRODUCT_NO SET BARCODE_EAN8 = '#wrk_barcode#X'<!--- 20050107 buradaki X in onemi yok kontorl karakteri yerine temporary bir deger --->
                    </cfquery>
                <cfelse>
                    <cfset wrk_barcode = ''>
                </cfif>
            </cftransaction>
        </cflock>
        <cfscript>
            if(len(wrk_barcode)){
               	wrk_barcode = Int(wrk_barcode);
				 wrk_barcode = wrk_barcode;
				 len1 = len(wrk_barcode);
				 deger = 7 - (len1);
				for(index=1; index LTE deger; index = index + 1) 
				    wrk_barcode = 0 & wrk_barcode;
               
                if(len(wrk_barcode) eq 7)
                    return wrk_barcode & UPCEANCheck_EAN8(wrk_barcode,7);
                if(Len(wrk_barcode) lt 8)
                    return '';
                }
            else
                return '';
        </cfscript>
    </cfif>
</cffunction>
<cfscript>
	/* 20050409
	alttaki iki function get_barcode_no() function icinde cagriliyor,
	eger cf_barcode custom tag vb yerlerde birden fazla function declare etme hatasi olursa kontrol edilecek
	
	20050409 bu function a gerek yok cf de zaten mod function var...(yine de silmeyin)
	function mode(d1, d2)
	{
		d3 = d1 / d2;
		d4 = Round(d3 + 0.5);
		if(d4 gt d3) d4 = d4 - 1;
		return d1 - d2 * d4;
	}
	orn : k = mode(13, 4); (yani 13 mod 4)
	*/

	function UPCEANCheck(s)
	{
		flag = true; i = 0; j = 0; k = 0;
		for( l = Len(s); l gte 1; l = l - 1)
			{
			if(flag) i = i + Mid(trim(s),l,1);
			else j = j + Mid(s,l,1);
			flag = not flag;
			}
		j = i * 3 + j;
		/*k = mode(j, 10);*/
		k = j mod 10;
		if(k neq 0)
			k = 10 - k;
		return k;
	}
	
	function UPCEANCheck_EAN8(s,number)
	{
		barcode_no = s;
		tek_karakterler = 0;
		cift_karakterler = 0;
		toplam = 0;
		ilk_hane = 0;
		check_digit = 0;
		hedef_sayi = 0;
		for(i=1; i<=7; i++)
		{
			if(i % 2 == 1)
			{
				tek_karakterler = tek_karakterler + (3 * Mid(trim(s),i,1));
			}
			else
			{
				cift_karakterler = cift_karakterler + Mid(trim(s),i,1);
			}
		}
		toplam = tek_karakterler + cift_karakterler;
		son_hane = toplam%10;
		if(son_hane == 0)
			check_digit = 0;
		else
			check_digit = 10 - son_hane;
		
		yeni_barkod = check_digit;
		s = yeni_barkod;
		return s;
	}
</cfscript>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
