<cfscript>
	attributes.amortization_rate=filternum(attributes.amortization_rate);
	attributes.inventory_duration=filternum(attributes.inventory_duration);
</cfscript>
<cfif isdefined('attributes.hierarchy1') and len(attributes.hierarchy1)>
	<cfset hier_ = '#attributes.hierarchy1#.#attributes.hierarchy2#'>
<cfelse>
	<cfset hier_ = '#attributes.hierarchy2#'>
</cfif>
<cfquery name="UPD_INVENTORY_CAT" datasource="#DSN3#">
	UPDATE 
		SETUP_INVENTORY_CAT
	SET 
		INVENTORY_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.inventory_cat_name#">,
		AMORTIZATION_RATE=#attributes.amortization_rate#,
		INVENTORY_DURATION=#attributes.inventory_duration#,
		DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
        HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hier_#">,
        SPECIAL_CODE = <cfif len(attributes.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.special_code#"><cfelse>NULL</cfif>,
        UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE 
		INVENTORY_CAT_ID = #attributes.inventory_cat_id_#
</cfquery>

<cfif hier_ neq old_hierarchy>
	<!--- hierarchy kodu degismisse alt kategoeriler update edilir --->
    <cfquery name="upd_inventory_cat_" datasource="#DSN3#">
        UPDATE
            SETUP_INVENTORY_CAT
        SET
            HIERARCHY = #sql_unicode()#'#hier_#.' + SUBSTRING(HIERARCHY, #len(old_hierarchy)#+2, LEN(HIERARCHY)-#len(old_hierarchy)#),
            UPDATE_DATE = #now()#,
            UPDATE_EMP = #session.ep.userid#,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
        WHERE
            HIERARCHY LIKE '#OLD_HIERARCHY#.%' AND
            INVENTORY_CAT_ID <> #attributes.inventory_cat_id_#
    </cfquery>
</cfif>
<script>
	location.href=document.referrer;
</script>
