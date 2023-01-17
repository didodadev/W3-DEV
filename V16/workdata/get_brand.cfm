<!--- 
	amac            : BRAND_NAME vererek BRAND_ID,BRAND_NAME bilgisini getirmek
	parametre adi   : brand_name
	ayirma isareti  : YOK
	kullanim        : get_brand('Asu') 
	Yazan           : A.Selam Karatas
	Tarih           : 16.5.2007
	Guncelleme      : 16.5.2007
 --->
<cffunction name="get_brand" access="public" returntype="query" output="no">
	<cfargument name="brand_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfif len(arguments.maxrows)>
		<cfquery name="GET_BRAND" datasource="#DSN1#" maxrows="#arguments.maxrows#">
			SELECT 
				BRAND_ID,
				BRAND_NAME,
                BRAND_CODE
			FROM 
				PRODUCT_BRANDS
			WHERE
				BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.brand_name#%">
			ORDER BY 
				BRAND_NAME
		</cfquery>
	<cfelse>
		<cfquery name="GET_BRAND" datasource="#DSN1#">
			SELECT 
				BRAND_ID,
				BRAND_NAME,
                BRAND_CODE
			FROM 
				PRODUCT_BRANDS
			WHERE
				BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.brand_name#%">
			ORDER BY 
				BRAND_NAME
		</cfquery>
	</cfif>
	<cfreturn get_brand>
</cffunction>

