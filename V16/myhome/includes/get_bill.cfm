<cfscript>
	if (isdefined('url.gun')) 
		gun = url.gun;
	else
		gun = dateformat(now(), 'dd');
	
	if (isdefined('url.ay'))
		ay = url.ay;
	else
		ay = dateformat(now(),'mm');
	
	if (isdefined('url.yil'))
		yil = url.yil;
	else
		yil = dateformat(now(),'yyyy');
	
	tarih = '#gun#/#ay#/#yil#';
	try
	{
		temp_tarih = tarih;
		attributes.to_day = date_add('h',-session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
	}
	catch(Any excpt)
	{
		tarih = '1/#ay#/#yil#';
		temp_tarih = tarih;
		attributes.to_day = date_add('h',-session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-1'));
	}
</cfscript>

<cfquery name="GET_BILL" datasource="#dsn2#" maxrows="#attributes.maxrows#">
	SELECT 
		INVOICE_ID,
		PURCHASE_SALES,
		INVOICE_NUMBER,
		NETTOTAL,
		GROSSTOTAL,
		COMPANY_ID,
		PARTNER_ID,
		CONSUMER_ID AS CON_ID,
		CONSUMER_ID,
		OTHER_MONEY_VALUE,
		OTHER_MONEY,
		ISNULL(TAXTOTAL,0) TAXTOTAL,
		INVOICE_CAT
	FROM 
		INVOICE
	WHERE
		<cfif not attributes.PURCHASE>
			PURCHASE_SALES=0
		<cfelse>
			PURCHASE_SALES=1
		</cfif>
		AND RECORD_DATE >= #attributes.to_day#
		AND RECORD_DATE < #DATEADD("d",1,attributes.to_day)# 
		AND INVOICE_CAT <> 67
		AND INVOICE_CAT <> 69
		AND IS_IPTAL <> 1 
		<cfif session.ep.their_records_only eq 1>
			AND SALE_EMP = #session.ep.userid#
		</cfif>
	ORDER BY
		RECORD_DATE DESC
</cfquery>
