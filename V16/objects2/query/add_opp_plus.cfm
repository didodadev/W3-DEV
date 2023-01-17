<cfsetting showdebugoutput="no">
<cfquery name="get_sender_mail" datasource="#dsn#">
    SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
</cfquery>
<cfif isdefined('attributes.is_add') and attributes.is_add eq 1>	
<cftransaction>
	<cfquery name="ADD_OPP_PLUS" datasource="#dsn3#">
		INSERT 
		INTO
			OPPORTUNITIES_PLUS
			(
			OPP_ID,
			PLUS_CONTENT,
			PLUS_DATE,
			RECORD_DATE,
			RECORD_PAR,
			OPP_ZONE,
			RECORD_IP,
			MAIL_SENDER,
			PLUS_SUBJECT
			)
		VALUES
			(
			#attributes.opp_id#,
			'#attributes.plus_content#',
			#now()#,
			#now()#,
			#session.pp.userid#,
			0,
			'#CGI.REMOTE_ADDR#',
			'#attributes.emails#',
			'#attributes.opp_header#'
			)
	</cfquery>
    </cftransaction>
    <cfquery name="get_sender_mail" datasource="#dsn#">
    	SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	</cfquery>
	<cfif isdefined('attributes.email') and attributes.email eq 1>
    	<cfmail to="#attributes.emails#" from="#get_sender_mail.company_partner_email#" subject="#attributes.opp_header#" type="html">
        #attributes.plus_content#
        </cfmail>
    </cfif> 
<cfelseif isdefined('attributes.is_upd') and attributes.is_upd eq 1>
	<cfquery name="upd_opp_plus" datasource="#dsn3#">
		UPDATE 
			OPPORTUNITIES_PLUS
		SET
			PLUS_CONTENT = '#attributes.plus_content#',
			MAIL_SENDER = '#attributes.emails#',
			PLUS_SUBJECT = '#attributes.opp_header#',
			UPDATE_DATE = #now()#,
			UPDATE_PAR = #session.pp.userid#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			OPP_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_plus_id#">
	</cfquery>
    <cfif isdefined('attributes.email') and attributes.email eq 1> 
    	<cfmail to="#attributes.emails#" from="#get_sender_mail.company_partner_email#" subject="#attributes.opp_header#" type="html">
        #attributes.plus_content#
        </cfmail>
    </cfif>    
<cfelse>
	<cfquery name="del_opp_plus" datasource="#dsn3#">
		DELETE FROM OPPORTUNITIES_PLUS WHERE OPP_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_plus_id#">
	</cfquery>
</cfif>
