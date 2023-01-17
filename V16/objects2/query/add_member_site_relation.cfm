<cfquery name="GET_DOMAINS" datasource="#DSN#">
	DELETE FROM 
		COMPANY_CONSUMER_DOMAINS 
	WHERE 
	<cfif isDefined("session.ww")>CONSUMER_ID<cfelseif isDefined("session.pp")>COMPANY_ID</cfif> = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
</cfquery>

<cfif isdefined("attributes.site_domain")>
	<cfloop list="#attributes.site_domain#" index="sd">
		<cfquery name="ADD_" datasource="#DSN#">
			INSERT INTO
				COMPANY_CONSUMER_DOMAINS
				(
					<cfif isDefined("session.ww")>
						CONSUMER_ID,
					<cfelseif isDefined("session.pp")>
						COMPANY_ID,
					</cfif>
                    <!---SITE_DOMAIN,--->
                    MENU_ID,
                    RECORD_DATE,
					<cfif isDefined("session.ww")>
                    	RECORD_CONS,
					<cfelseif isDefined("session.pp")>
						RECORD_PAR,
					</cfif>
                    RECORD_IP
				)
				VALUES
				(
					<cfif isDefined("session.ww")>
						#session.ww.userid#,
					<cfelseif isDefined("session.pp")>
						#session.pp.userid#,
					</cfif>
                    #sd#,
                    #now()#,
                    <cfif isDefined("session.ww")>
						#session.ww.userid#,
					<cfelseif isDefined("session.pp")>
						#session.pp.userid#,
					</cfif>
                    '#cgi.remote_addr#'
				)
		</cfquery>
	</cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=objects2.me" addtoken="No">
