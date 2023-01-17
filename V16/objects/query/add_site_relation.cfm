<cfquery name="GET_DOMAINS" datasource="#DSN#">
	DELETE FROM 
		COMPANY_CONSUMER_DOMAINS 
	WHERE 
		<cfif isdefined("attributes.company_id")>
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		<cfelseif isdefined("attributes.consumer_id")>
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		<cfelse>
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
		</cfif>
</cfquery>

<cfif isdefined("attributes.site_domain")>
	<cfloop list="#attributes.site_domain#" index="sd">
		<cfquery name="ADD_" datasource="#DSN#">
			INSERT INTO
				COMPANY_CONSUMER_DOMAINS
				(
					<cfif isdefined("attributes.company_id")>
                        COMPANY_ID,
                    <cfelseif isdefined("attributes.consumer_id")>
                        CONSUMER_ID,
                    <cfelse>
                        PARTNER_ID,
                    </cfif>
                    <!---SITE_DOMAIN,--->
                    MENU_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
				)
				VALUES
				(
					<cfif isdefined("attributes.company_id")>
                    	#attributes.company_id#,
                    <cfelseif isdefined("attributes.consumer_id")>
                    	#attributes.consumer_id#,
                    <cfelse>
                    	#attributes.partner_id#,
                    </cfif>
                    #sd#,
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.remote_addr#'
				)
		</cfquery>
	</cfloop>
</cfif>
<script type="text/javascript">
	<cfif isDefined("attributes.draggable")>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>,'unique_box_list_domains');
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
