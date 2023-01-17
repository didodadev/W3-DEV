
<cfquery name="add_pro_comp" datasource="#DSN3#" result="MAX_ID">
    INSERT INTO
        PRODUCT_COMP
	(
		COMPETITIVE,
		DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
    VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pro_comp#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	)
</cfquery>
<cfscript>
	if(isdefined("to_par_ids")) s_PARS = ListSort(to_par_ids,"Numeric", "Desc"); else s_PARS ='';
	if(isdefined("to_pos_codes")) s_PCODES =ListSort(to_pos_codes,"Numeric", "Desc") ; else s_PCODES ='';
</cfscript>
<cfif ListLen(s_PARS)>
	<cfloop list="#s_PARS#" index="I" delimiters=",">
		<cfquery name="ADD_PRO_COMP_PERM" datasource="#DSN3#">
            INSERT INTO 
                PRODUCT_COMP_PERM
			(
			  COMPETITIVE_ID,
			  PARTNER_ID
			)
            VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#I#">
			)			
		</cfquery>	
	</cfloop>
</cfif>
<cfif ListLen(s_PCODES)>
	<cfloop list="#s_PCODES#" index="I" delimiters=",">
		<cfquery name="ADD_PRO_EMP_PERM" datasource="#DSN3#">
        INSERT INTO 
            PRODUCT_COMP_PERM
		(
			COMPETITIVE_ID,
			POSITION_CODE
		)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#I#">
		)
		</cfquery>	
	</cfloop>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>

