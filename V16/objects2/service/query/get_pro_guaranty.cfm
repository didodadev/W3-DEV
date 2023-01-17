<cfquery name="GET_PRO_GUARANTY" datasource="#DSN3#">
	SELECT
		SGN.SALE_FINISH_DATE,
		P.PRODUCT_NAME,
		P.PRODUCT_ID
	FROM
		SERVICE_GUARANTY_NEW SGN,
		#dsn_alias#.SETUP_GUARANTY AS SG,
		STOCKS S,
		PRODUCT P
	WHERE
		SGN.SALE_GUARANTY_CATID = SG.GUARANTYCAT_ID AND
		SGN.IS_SALE = 1 AND
		<!--- SGN.STOCK_ID = #stock_id# AND --->
		SGN.STOCK_ID = S.STOCK_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID
      	<cfif isdefined("pro_serial_no") and len(pro_serial_no)>
	    	AND SGN.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_serial_no#">
	  	</cfif>
</cfquery>

<cfset out=0>
<cfif get_pro_guaranty.recordcount>
	<cfif now() gt get_pro_guaranty.sale_finish_date>
		<cfset out=1>
		<cfset garanti_bilgisi="Garanti Süresi Dolu!">
	<cfelse>
		<cfset garanti_bilgisi="">
	</cfif>
<cfelse>
	<cfset out=1>
	<cfset garanti_bilgisi="Ürün bulunamadı,ya da garanti kapsamında değil.">
</cfif>
