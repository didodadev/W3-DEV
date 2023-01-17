<!--- 
	amac            : gelen product_cat_name parametresine göre HIERARCHY,PRODUCT_CAT,PRODUCT_CATID bilgisini getirmek
	parametre adi   : product_cat_name
	kullanim        : get_product_cat('işlemci') 
	Yazan           : B.Kuz
	Tarih           : 20080116
 --->
<cffunction name="get_product_cat" access="public" returnType="query" output="no">
	<cfargument name="product_cat_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1"><!--- -1 (All) yerine kullanilabilir FBS --->
	<cfargument name="is_sub_cat" required="no" type="string" default="0"><!--- 1 gelirse sadece alt kategoriler gelir --->
	<cfquery name="GET_PRODUCT_CAT_" datasource="#DSN1#" maxrows="-1">
		SELECT
			PC.PRODUCT_CATID,
			PC.HIERARCHY,
			PC.PRODUCT_CAT,
			<cfif database_type is "MSSQL">
				(PC.HIERARCHY + ' ' +PC.PRODUCT_CAT) PRODUCT_CAT_NAME
			<cfelseif database_type is "DB2">
				(PC.HIERARCHY || ' ' || PC.PRODUCT_CAT) PRODUCT_CAT_NAME
			</cfif>
		FROM 
			PRODUCT_CAT PC,
			PRODUCT_CAT_OUR_COMPANY PCO
		WHERE
			PC.PRODUCT_CATID IS NOT NULL AND
			PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
			<cfif arguments.is_sub_cat eq 1>
				IS_SUB_PRODUCT_CAT = 0 AND
			</cfif>
			PCO.OUR_COMPANY_ID = #session_base.company_id# AND
			(
				
				PC.PRODUCT_CAT LIKE '<cfif len(arguments.product_cat_name) gt 1>%</cfif>#arguments.product_cat_name#%' OR 
				PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_cat_name#%">
			)
		ORDER BY
			PC.HIERARCHY
	</cfquery>
	<cfreturn get_product_cat_>
</cffunction>
