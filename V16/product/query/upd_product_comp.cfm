<cfset structdelete(session.product,"emps_status")>
<cfset structdelete(session.product,"pars_status")>
<cfquery name="UPD_PRO_COMP" datasource="#DSN3#">
	UPDATE
		PRODUCT_COMP
	SET
		COMPETITIVE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pro_comp#">,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_DATE = 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE
		COMPETITIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
</cfquery>

<cfquery name="DEL_PERM" datasource="#DSN3#">
	DELETE FROM PRODUCT_COMP_PERM WHERE COMPETITIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
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
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">,
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
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#I#">
			)
		</cfquery>	
	</cfloop>
</cfif>
<cfscript>structdelete(session.product,"joins");</cfscript>
<script type="text/javascript">
	<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
