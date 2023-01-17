<cfscript>
	attributes.amortization_rate=filternum(attributes.amortization_rate);
	attributes.inventory_duration=filternum(attributes.inventory_duration);
</cfscript>
<cfif isdefined('attributes.hierarchy1') and len(attributes.hierarchy1)>
	<cfset hier_ = '#attributes.hierarchy1#.#attributes.hierarchy2#'>
<cfelse>
	<cfset hier_ = attributes.hierarchy2>
</cfif>
<cfquery name="ADD_INVENTORY_CAT" datasource="#DSN3#">
	INSERT INTO 
		SETUP_INVENTORY_CAT
		(
			INVENTORY_CAT,
			AMORTIZATION_RATE,
			INVENTORY_DURATION,
            HIERARCHY,
            DETAIL,
            SPECIAL_CODE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		) 
		VALUES 
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.inventory_cat_name#">,
			#attributes.amortization_rate#,
			#attributes.inventory_duration#,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#hier_#">,
			<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
            <cfif len(attributes.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.special_code#"><cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_inventory_cat" addtoken="no">
