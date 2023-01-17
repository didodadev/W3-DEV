<cfsetting showdebugoutput="no">
<cfscript>
function stringToBinary( String stringValue )
{
	var base64Value = toBase64( stringValue );
	var binaryValue = toBinary( base64Value );
	return( binaryValue );
}
 
function stringToHex( String stringValue ){
	var binaryValue = stringToBinary( stringValue );
	var hexValue = binaryEncode( binaryValue, "hex" );
	return(lcase(hexValue));
}

	CRLF = Chr(13) & Chr(10); // satır atlama karakteri
	file_name = "GNSTAFF.GTF";
	dosya = ArrayNew(1);
</cfscript>

<cfquery name="get_pos_users" datasource="#DSN_Dev#">
	SELECT
		PU.*,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME
	FROM
		POS_USERS PU,
        #dsn_alias#.EMPLOYEES E,
        #dsn_alias#.BRANCH B,
        #dsn_alias#.DEPARTMENT D
	WHERE
    	<cfif attributes.is_all eq 0>
        (
        PU.RECORD_DATE BETWEEN #attributes.product_startdate# AND #dateadd('d',1,attributes.product_finishdate)#
        OR
        PU.UPDATE_DATE BETWEEN #attributes.product_startdate# AND #dateadd('d',1,attributes.product_finishdate)#
        )
        AND
        </cfif>
        D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        D.DEPARTMENT_ID = #attributes.department_id# AND
		PU.BRANCH_ID = B.BRANCH_ID AND
        B.BRANCH_ID = D.BRANCH_ID AND
        E.EMPLOYEE_ID = PU.EMPLOYEE_ID AND
        PU.EMPLOYEE_ID IS NOT NULL
</cfquery>

<cfif get_pos_users.recordcount>
	<cffile action="write" nameconflict="overwrite" output="<SIGNATURE=GNDSTF.GDF><VERSION=0227000>" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
	
	<cfoutput query="get_pos_users">
		<cfscript>
			yeni_sifre_ = "";
			
			for(i = 1; i lte len(PASSWORD); i=i+1)
			{
				harf_ = mid(password,i,1);
				harf_c = reverse(stringToHex(harf_));
				yeni_sifre_ = yeni_sifre_ & harf_c;		
			}
			
			sifre = yeni_sifre_;
			
			satir1 = "01" & repeatString(" ", 436);	

			satir1 = yerles(satir1,"0",5,1,''); // yeni kayit
			
			satir1 = yerles(satir1,USERNAME,6,8," "); //eski username
			satir1 = yerles(satir1,USERNAME,14,8," "); //yeni username
			
			satir1 = yerles(satir1,EMPLOYEE_NAME,22,15," "); //adi
			satir1 = yerles(satir1,EMPLOYEE_SURNAME,37,25," "); //soyadi
			
			satir1 = yerles(satir1,POS_TYPE,62,8," "); //pos type
			
			satir1 = yerles(satir1,"0",70,3," "); // urun max indirim
			satir1 = yerles(satir1,"0",73,3," "); // total max indirim
			
			satir1 = yerles(satir1,"0",76,15," "); // total max indirim
			satir1 = yerles(satir1,"0",91,15," "); // total max indirim
			satir1 = yerles(satir1,"0",106,15," "); // total max indirim
			
			satir1 = yerles(satir1,"0",121,3," "); // urun max indirim
			satir1 = yerles(satir1,"0",124,3," "); // total max indirim
			
			satir1 = yerles(satir1,"0",127,15," "); // total max indirim
			satir1 = yerles(satir1,"0",142,15," "); // total max indirim
			
			satir1 = yerles(satir1,"0",157,6," "); // total max indirim
			satir1 = yerles(satir1,"0",163,6," "); // total max indirim
			satir1 = yerles(satir1,"0",169,6," "); // total max indirim
			satir1 = yerles(satir1,"0",175,6," "); // total max indirim
			
			satir1 = yerles(satir1,".",181,30," "); // total max indirim
			satir1 = yerles(satir1,".",211,30," "); // total max indirim
			satir1 = yerles(satir1,".",241,30," "); // total max indirim
			
			satir1 = yerles(satir1,".",271,25," "); // total max indirim
			satir1 = yerles(satir1,".",296,25," "); // total max indirim
			satir1 = yerles(satir1,".",321,25," "); // total max indirim
			
			
			satir1 = yerles(satir1,".",346,30," "); // total max indirim
			satir1 = yerles(satir1,"0",376,1,""); // kasada calisma durumu
			satir1 = yerles(satir1,"1",377,1,""); // total max indirim
			satir1 = yerles(satir1,"1",378,1,""); // total max indirim

			satir1 = yerles(satir1," ",379,15," ");
			satir1 = yerles(satir1,"1",394,1,""); // total max indirim
			
			satir1 = yerles(satir1,"01/01/2014",395,14," "); // total max indirim
			satir1 = yerles(satir1,"01/01/2050",409,14," "); // total max indirim
			
			satir1 = yerles(satir1,sifre,423,16," "); // sifre
			
			ArrayAppend(dosya,satir1);
		</cfscript>
	</cfoutput>
	
	<cffile action="append" output="#ArrayToList(dosya,CRLF)#" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
<!---
<cfelse>
	<cffile action="write" nameconflict="overwrite" output="<SIGNATURE=GDNSTF.GDF><VERSION=0227000>" addnewline="yes" file="#upload_folder##file_name#">
--->
</cfif>
<cfset satir1 = "">