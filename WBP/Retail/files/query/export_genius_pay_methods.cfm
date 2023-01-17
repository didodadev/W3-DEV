<!--- Bu dosyanın gercek hali objects/query klasoru altindadir. BK 20070418 --->
<cfsetting showdebugoutput="no">

<cfquery name="get_money_dolar" datasource="#dsn#">
    SELECT TOP 1 RATE3 FROM MONEY_HISTORY WHERE MONEY = 'USD' AND PERIOD_ID = #session.ep.period_id# AND VALIDATE_DATE < #dateadd('d',1,attributes.product_finishdate)# ORDER BY VALIDATE_DATE DESC
</cfquery>
<cfquery name="get_money_euro" datasource="#dsn#">
    SELECT TOP 1 RATE3 FROM MONEY_HISTORY WHERE MONEY = 'EUR' AND PERIOD_ID = #session.ep.period_id# AND VALIDATE_DATE < #dateadd('d',1,attributes.product_finishdate)# ORDER BY VALIDATE_DATE DESC
</cfquery>
<cfset dolar_carpan = tlformat(get_money_dolar.RATE3,2)>
<cfset euro_carpan = tlformat(get_money_euro.RATE3,2)>

<cfscript>
	file_name = "GNDPAYMENT.GTF";
	CRLF=chr(13)&chr(10);
	
	file_content = ArrayNew(1);
	index_array = 1;
</cfscript>

<cfquery name="get_types" datasource="#dsn_dev#">
	SELECT
    	* 
    FROM 
    	SETUP_POS_PAYMETHODS 
    WHERE
    	<cfif attributes.is_all eq 0>
            CODE IN ('5','6')
            OR
            RECORD_DATE BETWEEN #attributes.product_startdate# AND #dateadd('d',1,attributes.product_finishdate)#
            OR
            UPDATE_DATE BETWEEN #attributes.product_startdate# AND #dateadd('d',1,attributes.product_finishdate)#
        <cfelse>
            CODE IS NOT NULL
        </cfif>
    ORDER BY 
    	CAST(CODE AS INTEGER) ASC 
</cfquery>

<cfloop query="get_types">
	<cfscript>
	satir1 = "01" & repeatString(" ",75);	
	satir1 = yerles(satir1,1,5,1," ");// şimdilik yeni kayıt olarak export ediyoruz
	
	satir1 = yerles(satir1,CODE,6,2, " ");
	satir1 = yerles(satir1,CODE,8,2, " ");
	
	satir1 = yerles(satir1,left(HEADER,20),10,20, " ");
	
	satir1 = yerles(satir1,symbol,30,5," ");
	
	satir1 = yerles(satir1,pay_limit,35,15, " ");
	
	if(code eq 5)
		satir1 = yerles(satir1,dolar_carpan,50,15," ");
	else if(code eq 6)
		satir1 = yerles(satir1,euro_carpan,50,15," ");
	else
		satir1 = yerles(satir1,daily_rate,50,15, " ");

	selects_ = 0;
	
	if(len(PROVISITION) and PROVISITION eq 1)
		selects_ = '301991075';
	else if(len(pay_selects))
		{
			for(i = 1; i lte listlen(pay_selects); i=i+1)
			{
				deger_ = listgetat(pay_selects,i);
				selects_ = selects_ + deger_;
			}
		}
	
	satir1 = yerles(satir1,selects_,65,12, " ");
		
	satir1 = yerles(satir1,decimal_count,77,1, " ");	

	file_content[index_array] = satir1;
	index_array = index_array+1;
	</cfscript>
</cfloop>
<cfif get_types.recordcount>
    <cffile action="write" nameconflict="overwrite" output="<SIGNATURE=GNDPYMT.GDF><VERSION=22000>" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
    <cffile action="append" output="#ArraytoList(file_content,CRLF)#" file="#upload_folder##file_name#" charset="ISO-8859-9">
</cfif>