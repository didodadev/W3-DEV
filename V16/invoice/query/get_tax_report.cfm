<cfset current_month=datepart("m",now())>
<cfquery name="get_tax_cur_month1" datasource="#dsn2#">
	SELECT 
		SUM(TAXTOTAL) as S_T
	FROM
		INVOICE
	WHERE
		<cfif database_type  eq "MSSQL">
		DATEPART("M",INVOICE_DATE)=#current_month#
		<cfelseif database_type  eq "DB2">>
		MONTH(INVOICE_DATE)=#current_month#
		</cfif>
	AND
		PURCHASE_SALES=1
</cfquery>
<cfquery name="get_tax_cur_month2" datasource="#dsn2#">
	SELECT 
		sum(taxtotal) as p_t
	FROM
		INVOICE
	WHERE
		<cfif database_type  eq "MSSQL">
		DATEPART("M",INVOICE_DATE)=#current_month#
		<cfelseif database_type  eq "DB2">>
		MONTH(INVOICE_DATE)=#current_month#
		</cfif>
	AND
		PURCHASE_SALES=0
</cfquery>
<cfquery name="get_tax1" datasource="#dsn2#">
	SELECT 
		sum(taxtotal) as s_t_t
	FROM
		INVOICE
	WHERE
		PURCHASE_SALES=1
</cfquery>
<cfquery name="get_tax2" datasource="#dsn2#">
	SELECT 
		sum(taxtotal) as p_t_t
	FROM
		INVOICE
	WHERE
		PURCHASE_SALES=0
</cfquery>
