<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.HIERARCHY") and len(attributes.HIERARCHY)>
	<cfquery name="get_alt_grups" datasource="#dsn1#">
		SELECT
			PC.PRODUCT_CAT,
			PC.PRODUCT_CATID,
			PC.HIERARCHY,
			PC.LIST_ORDER_NO
		FROM 
			PRODUCT_CAT PC,
			PRODUCT_CAT_OUR_COMPANY PCO
		WHERE 
			PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HIERARCHY#.%"> AND
			PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
			PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			PC.IS_PUBLIC = 1
		GROUP BY 
			PC.PRODUCT_CAT,
			PC.PRODUCT_CATID,
			PC.HIERARCHY,
			PC.LIST_ORDER_NO
		ORDER BY 
			PC.LIST_ORDER_NO,
			PC.HIERARCHY
	</cfquery>
<cfelse>
	<cfset get_alt_grups.recordcount = 0>
</cfif>
<cfif attributes.type eq 1>
	<cfsavecontent variable="message1"><cf_get_lang dictionary_id="60558.Kurulum Yeri">/<cf_get_lang_main no="74.Kategori"></cfsavecontent>
	<cfset aa=0>
	<cfif isdefined("attributes.alt")>
		<cfset mystr = '<select name="main_category2_#alt#" style="width:150px;" onChange="showaltcategory_#alt#(2)">'>
	<cfelse>
		<cfset mystr = '<select name="main_category2" style="width:150px;" onChange="showaltcategory(2)">'>
	</cfif>
	<cfset mystr = mystr & '<option value="">#message1#</option>'>
	<cfif get_alt_grups.recordcount>
		<cfloop query="get_alt_grups">
			<cfif listlen(get_alt_grups.hierarchy,'.') eq 2>
				<cfset mystr = mystr & '<option value=#HIERARCHY#>#PRODUCT_CAT#</option>'>
				<cfset aa=HIERARCHY>
			</cfif>
		</cfloop>
	</cfif>
	<cfset mystr = mystr & '</select>'>
	<cfoutput>#mystr#</cfoutput>
	<script type="text/javascript">
		<cfif get_alt_grups.recordcount and not len(get_alt_grups.HIERARCHY)><cfset get_alt_grups.HIERARCHY =0></cfif>
	</script>
</cfif>
<cfif attributes.type eq 2>
	<cfsavecontent variable="message2"><cf_get_lang dictionary_id="60557.Kurulum Tipi">/<cf_get_lang_main no="74.Kategori"></cfsavecontent>
	<cfset aa=0>
	<cfif isdefined("attributes.alt")>
		<cfset mystr2 = '<select name="main_category3_#alt#" style="width:150px;" onChange="showaltcategory_#alt#(3)">'>
	<cfelse>
		<cfset mystr2 = '<select name="main_category3" style="width:150px;" onChange="showaltcategory(3)">'>
	</cfif>
	<cfset mystr2 = mystr2 & '<option value="">#message2#</option>'>
	<cfif get_alt_grups.recordcount>
		<cfloop query="get_alt_grups">
			<cfif listlen(get_alt_grups.hierarchy,'.') eq 3>
				<cfset mystr2 = mystr2 & '<option value="#HIERARCHY#">#PRODUCT_CAT#</option>'>
				<cfset aa=HIERARCHY>
			</cfif>
		</cfloop>
	</cfif>
	<cfset mystr2 = mystr2 & '</select>'>
	<cfoutput>#mystr2#</cfoutput>
	<script type="text/javascript">
		<cfif get_alt_grups.recordcount and not len(get_alt_grups.HIERARCHY)><cfset get_alt_grups.HIERARCHY =0></cfif>
	</script>
</cfif>
<cfif attributes.type eq 3>
	<cfsavecontent variable="message3"><cf_get_lang no="185.Tipoloji"></cfsavecontent>
	<cfif isdefined("attributes.alt")>
		<cfset mystr3 = '<select name="main_category4_#alt#" style="width:150px;" onChange="showaltcategory_#alt#(4)">'>
	<cfelse>
		<cfset mystr3 = '<select name="main_category4" style="width:150px;" onChange="showaltcategory(4)">'>
	</cfif>
	<cfset mystr3 = '<select name="main_category4" style="width:150px;">'>
	<cfset mystr3 = mystr3 & '<option value="">#message3#</option>'>
	<cfif get_alt_grups.recordcount>
		<cfloop query="get_alt_grups">
			<cfif listlen(get_alt_grups.hierarchy,'.') eq 4>
				<cfset mystr3 = mystr3 & '<option value="#HIERARCHY#">#PRODUCT_CAT#</option>'>
			</cfif>
		</cfloop>
	</cfif>
	<cfset mystr3 = mystr3 & '</select>'>
	<cfoutput>#mystr3#</cfoutput>
</cfif>
