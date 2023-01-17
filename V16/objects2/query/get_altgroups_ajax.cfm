<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.anagrup_id") and len(attributes.anagrup_id)>
	<cfquery name="GET_ANA_GROUP" datasource="#DSN1#">
		SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.anagrup_id#">
	</cfquery>
	<cfquery name="GET_ALT_GRUPS" datasource="#DSN1#">
		SELECT 
			PC.PRODUCT_CAT,
			PC.PRODUCT_CATID,
			PC.HIERARCHY,
			PC.LIST_ORDER_NO
		FROM 
			PRODUCT_CAT PC,
			PRODUCT_CAT_OUR_COMPANY PCO
		WHERE 
			PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_ana_group.hierarchy#.%"> AND
			PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
			PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			PC.IS_PUBLIC = 1 AND
			PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.%">
		ORDER BY 
			PC.LIST_ORDER_NO,PC.HIERARCHY
	</cfquery>
<cfelse>
	<cfset get_alt_grups.recordcount = 0>
</cfif>
<cfsavecontent variable="message"><cf_get_lang no ='1040.Tüm Alt Gruplar'></cfsavecontent>
<cfset mystr = '<select name="altgrup" style="width:197px;height:110px;" size="8"  onChange="showaltbrands()"><option value="">#message#</option>'>
<cfif get_alt_grups.recordcount>
<cfloop query="get_alt_grups">
	<cfset mystr = mystr & '<option value=#product_catid#>#product_cat#</option>'>
</cfloop>
</cfif>
<cfset mystr = mystr & '</select>'>
<cfoutput>#mystr#</cfoutput>
