<cfquery name="GET_PRO_GUARANTY" datasource="#dsn3#">
	SELECT
    TOP 1
		SGN.*,
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
		SGN.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
		SGN.STOCK_ID = S.STOCK_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID
      <cfif len(PRO_SERIAL_NO)>
	    AND SGN.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PRO_SERIAL_NO#">
	  </cfif>
      ORDER BY
    GUARANTY_ID DESC
</cfquery>


<cfset out=0>
<cfif get_pro_guaranty.recordcount>
	<cfif now() gt get_pro_guaranty.SALE_FINISH_DATE>
		<cfset out=1>
		<cfset garanti_bilgisi="Garanti Süresi Dolu!">
	<cfelse>
		<cfset garanti_bilgisi="">
	</cfif>
<cfelse>
	<cfset out=1>
	<cfset garanti_bilgisi="Ürün bulunamadı,ya da garanti kapsamında değil.">
</cfif>
