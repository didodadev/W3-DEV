<!--- f_add_espos_row fonksiyonundaki EsPOS kasa için MSSQL db ye kayit atar. BK 20080820 --->

<cffunction name="f_add_espos_row" output="false" returntype="numeric">
	<cfargument name="FLAG" type="string" required="yes">
	<cfargument name="PLU_NO" type="string" required="yes">
	<cfargument name="BARCODE" type="string" required="yes">
	<cfargument name="NAME" type="string" required="yes">
	<cfargument name="UNIT_PRICE" type="numeric" required="yes">
	<cfargument name="DEPARTMENT" type="string" required="yes">
	<cfargument name="UNIT" type="string" required="yes">
	<cfargument name="CURRENCY" type="string" required="yes">
	<cfargument name="REYON_CODE" type="numeric" required="yes">
	<cfargument name="KDV" type="numeric" required="yes">
	<cfargument name="PRODUCT_ID" type="numeric" required="yes">
	<cfargument name="STOCK_ID" type="numeric" required="yes">
	<cfargument name="BRANCH_ID" type="numeric" required="yes">
	<cfargument name="BALANCE" type="numeric" required="yes">
	<cfscript>
		add_espos_row[Arraylen(add_espos_row)+1] = "INSERT INTO POS_PRUDUCT_DEFINITION(FLAG,PLU_NO,BARCODE,NAME,UNIT_PRICE,DEPARTMENT,UNIT,CURRENCY,REYON_CODE,KDV,PRODUCT_ID,STOCK_ID,BRANCH_ID,IS_BALANCE,RECORD_DATE,RECORD_EMP,RECORD_IP) VALUES('#arguments.flag#','#arguments.plu_no#','#arguments.barcode#','#arguments.name#',#arguments.unit_price#,#arguments.department#,'#arguments.unit#','#arguments.currency#',#arguments.reyon_code#,#arguments.kdv#,#arguments.product_id#,#arguments.stock_id#,#arguments.branch_id#,#arguments.balance#,#now()#,#session.ep.userid#,'#cgi.remote_addr#')";
	</cfscript>
	<cfreturn true>
</cffunction>
