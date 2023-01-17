<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.altgrup_id") and len(attributes.altgrup_id)>
	<cfquery name="GET_MARKALAR" datasource="#DSN1#">
		SELECT
			PRODUCT_BRANDS.BRAND_ID,
			PRODUCT_BRANDS.BRAND_NAME,
			PRODUCT_CAT_BRANDS.PRODUCT_CAT_ID
		FROM
			PRODUCT_CAT_BRANDS,
			PRODUCT_BRANDS,
			PRODUCT_BRANDS_OUR_COMPANY PBO
		WHERE
			PRODUCT_CAT_BRANDS.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.altgrup_id#"> AND
			PRODUCT_CAT_BRANDS.BRAND_ID = PRODUCT_BRANDS.BRAND_ID AND
			PBO.BRAND_ID = PRODUCT_BRANDS.BRAND_ID AND
			PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			PRODUCT_BRANDS.IS_ACTIVE = 1 AND
			PRODUCT_BRANDS.IS_INTERNET = 1
	</cfquery>
<cfelse>
	<cfset get_markalar.recordcount = 0>
</cfif>
<cfsavecontent variable="message"><cf_get_lang no ='1039.Tüm Markalar'></cfsavecontent>
<cfset mystr = '<select name="marka" style="width:197px;height:110px;" size="8" onChange="katalog.submit();"><option value="">#message#</option>'>
<cfif get_markalar.recordcount>
<cfloop query="get_markalar">
	<cfset mystr = mystr & '<option value=#brand_id#'>
	<cfset mystr = mystr & '>#brand_name#</option>'>
</cfloop>
</cfif>
<cfset mystr = mystr & '</select>'>
<cfoutput>#mystr#</cfoutput>
