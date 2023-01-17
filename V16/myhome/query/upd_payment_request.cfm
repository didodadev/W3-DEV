<cf_date tarih='attributes.due_date'>
<cfset CC_EMPS = attributes.EMP_ID_CC>
<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="ADD_PAYMENT_REQUEST" datasource="#dsn#">
			UPDATE
				CORRESPONDENCE_PAYMENT
			SET
				CC_EMP='#cc_emps#',
				PRIORITY=<cfqueryparam cfsqltype="cf_sql_integer" value="#priority#">,
				DUEDATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date#">,                                                
				PAYMETHOD_ID=<cfif isdefined("attributes.pay_method") and len(attributes.pay_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pay_method#"><cfelse>NULL</cfif>,
				AMOUNT=<cfqueryparam cfsqltype="cf_sql_float" value="#amount#">, 
				MONEY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_id#">,
				<cfif isdefined('attributes.detail')>
					DETAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,                             
				</cfif>                                                                                                                                                                    
				SUBJECT=<cfqueryparam cfsqltype="cf_sql_varchar" value="#subject#">,
				PERIOD_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">,
				DEMAND_TYPE = <cfif isdefined("attributes.demand_type") and len(attributes.demand_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_type#"><cfelse>NULL</cfif>,
				PROCESS_STAGE = <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>
			WHERE
				ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<cfset id_ = contentEncryptingandDecodingAES(isEncode:1,content:attributes.id,accountKey:'wrk')>
<cf_workcube_process 
        is_upd='1' 
        old_process_line='attributes.old_process_line'
        process_stage='#attributes.PROCESS_STAGE#' 
        record_member='#session.ep.userid#' 
        record_date='#now()#'
        action_table='CORRESPONDENCE_PAYMENT'
        action_column='ID'
        action_id='#attributes.id#'
        action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payment_request&event=upd&id=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.id,accountKey:'wrk')#' 
        warning_description='Avans Talebi : #attributes.subject#'>
<script type="text/javascript">
	<cfif listgetat(attributes.fuseaction,1,'.') eq 'myhome'>
		window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payment_request&event=upd&id=#id_#</cfoutput>";

	<cfelse>
		window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payment_request&event=upd&id=#attributes.id#</cfoutput>";
	</cfif>
</script>
