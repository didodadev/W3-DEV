<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery  name="del_rec" datasource="#DSN#">
			UPDATE
				CORRESPONDENCE_PAYMENT
			SET
				
				AMOUNT= <cfif isdefined("attributes.AMOUNT") and len(attributes.AMOUNT)><cfqueryparam cfsqltype="cf_sql_float" value = "#attributes.AMOUNT#"><cfelse>NULL</cfif>,
				IN_OUT_ID= <cfif isdefined("attributes.employee_in_out_id") and len(attributes.employee_in_out_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_in_out_id#"><cfelse>NULL</cfif>,
				DEMAND_TYPE= <cfif isdefined("attributes.DEMAND_TYPE") and len(attributes.DEMAND_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEMAND_TYPE#"><cfelse>NULL</cfif>
			WHERE
				ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		</cfquery>
		<cfquery name="get_payment" datasource="#dsn#">
			SELECT SPG_ID FROM SALARYPARAM_GET WHERE PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		</cfquery>
		<cfif get_payment.recordcount>
			<cfquery name="upd_pay" datasource="#DSN#">
				UPDATE
					SALARYPARAM_GET
				SET
					IN_OUT_ID= <cfif isdefined("attributes.employee_in_out_id") and len(attributes.employee_in_out_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_in_out_id#"><cfelse>NULL</cfif>,
					AMOUNT_GET = <cfif isdefined("attributes.AMOUNT") and len(attributes.AMOUNT)><cfqueryparam cfsqltype="cf_sql_float" value = "#attributes.AMOUNT#"><cfelse>NULL</cfif>,
					TOTAL_GET = <cfif isdefined("attributes.AMOUNT") and len(attributes.AMOUNT)><cfqueryparam cfsqltype="cf_sql_float" value = "#attributes.AMOUNT#"><cfelse>NULL</cfif>
				WHERE
					SPG_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment.SPG_ID#">	
			</cfquery>
		</cfif>
		<cf_add_log  log_type="0" action_id="#attributes.id#" action_name="Employee:#attributes.employee_id# Avans Düzeltme- Eski Tutar : #attributes.old_amount# Yeni Tutar : #attributes.amount#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
