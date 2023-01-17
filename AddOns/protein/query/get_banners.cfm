<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif isdefined("attributes.cat") and len(attributes.cat)>
	<cfif listgetat(attributes.cat,1,"-") is "cat">
		<cfset cont_st = "cat">
	<cfelse>
		<cfset cont_st = "ch">
	</cfif>
</cfif>
<cfquery name="GET_BANNERS" datasource="#DSN#">
	SELECT
		CB.RECORD_EMP,
		CB.BANNER_FILE,
		CB.BANNER_NAME,
		CB.IS_FLASH,
		CB.IS_HOMEPAGE,
		CB.IS_LOGIN_PAGE_EMPLOYEE,
		CB.IS_LOGIN_PAGE,
		CB.BANNER_AREA_ID,
		CB.BANNER_BRAND_ID,
		CB.BANNER_PRODUCT_ID,
		CB.BANNER_ID,
		CB.START_DATE,
		CB.FINISH_DATE,
        CB.LANGUAGE,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM 
		CONTENT_BANNERS CB,
		EMPLOYEES E
	WHERE
		E.EMPLOYEE_ID = CB.RECORD_EMP
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>AND BANNER_NAME LIKE #sql_unicode()#'%#attributes.keyword#%'</cfif>
		<cfif len(attributes.start_date) and len(attributes.finish_date)>
			AND (START_DATE >= #attributes.start_date# AND FINISH_DATE <= #attributes.finish_date#)
		</cfif>
		<cfif isDefined("cont_st") and cont_st is "CH">
			AND CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.cat,2,"-")#">
		<cfelseif isDefined("cont_st") and cont_st is "CAT">
			AND CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.cat,2,"-")#">
		</cfif>	
		<cfif isdefined("attributes.product_id") and len(attributes.product_id) and isdefined("attributes.product_name") and len(attributes.product_name)>AND BANNER_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>
		<cfif isdefined("attributes.banner_area_id") and len(attributes.banner_area_id)>AND BANNER_AREA_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.banner_area_id#"></cfif>
		<cfif isdefined("attributes.menu_id") and len(attributes.menu_id)>AND MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#"></cfif>
		<cfif isdefined("attributes.durum_type") and attributes.durum_type eq 1>AND IS_ACTIVE = 1</cfif>
		<cfif isdefined("attributes.durum_type") and attributes.durum_type eq 2>AND IS_ACTIVE = 0</cfif>
		<cfif isdefined("attributes.yayin_type") and attributes.yayin_type eq 1>AND IS_FLASH = 1</cfif>
		<cfif isdefined("attributes.yayin_type") and attributes.yayin_type eq 2>AND IS_HOMEPAGE = 1</cfif>
		<cfif isdefined("attributes.yayin_type") and attributes.yayin_type eq 3>AND IS_LOGIN_PAGE = 1</cfif>
		<cfif isdefined("attributes.yayin_type") and attributes.yayin_type eq 4>AND IS_LOGIN_PAGE_EMPLOYEE = 1</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>AND BANNER_BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"></cfif>
		<cfif isdefined("attributes.productcat_id") and len(attributes.productcat_id) and isdefined("attributes.product_cat") and len(attributes.product_cat)>AND BANNER_PRODUCTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.productcat_id#"></cfif>
        <cfif isdefined("attributes.language_id") and len(attributes.language_id)>AND LANGUAGE = '#attributes.language_id#'</cfif>
	ORDER BY
		CB.RECORD_DATE DESC
</cfquery>
