<cflock name="#CreateUUID()#" timeout="80">
	<cftransaction>
		<cfquery name="UPD_OFFER" datasource="#DSN3#">
			UPDATE 
				OFFER
			SET
				SALES_PARTNER_ID = #session.pp.userid#,
				<cfif len(attributes.member) and ((#listgetat(attributes.member,3,',')# eq 3) or (#listgetat(attributes.member,3,',')# eq 4))><!--- yenin partnermi consumermi oldugunu anlamak iin --->
					PARTNER_ID = #listgetat(attributes.member,1,',')#,
					COMPANY_ID = #listgetat(attributes.member,2,',')#,		
				<cfelseif len(attributes.member) and (#listgetat(attributes.member,3,',')#) eq 5>
					CONSUMER_ID = #listgetat(attributes.member,1,',')#,
				</cfif>
				OFFER_HEAD = '#attributes.offer_head#',
				OFFER_DETAIL = '#attributes.offer_detail#',
				OFFER_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#<cfelse>NULL</cfif>,
				PAYMETHOD = <cfif len(attributes.paymethod_id) and len(attributes.paymethod)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
					CARD_PAYMETHOD_ID = #attributes.card_paymethod_id#,
					CARD_PAYMETHOD_RATE = <cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>#attributes.commission_rate#,<cfelse>NULL,</cfif>,
				<cfelse>
					CARD_PAYMETHOD_ID = NULL,
					CARD_PAYMETHOD_RATE = NULL,
				</cfif>
				SHIP_ADDRESS = '#attributes.ship_address#',
				DUE_DATE = #now()#,
				CITY_ID = <cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
				COUNTY_ID = <cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				<!--- Fatihe sor 20080404 BK		
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.remote_addr#', --->
			<cfif isdefined("session.ww")>
				UPDATE_CONS = #session.ww.userid#
				UPDATE_PAR = NULL
			<cfelse>
				UPDATE_CONS = NULL,
				UPDATE_PAR = #session.pp.userid#
			</cfif>			
			WHERE
				OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
		</cfquery>

		<cfquery name="GET_OFFER_ROWS" datasource="#DSN3#">
			SELECT * FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> ORDER BY OFFER_ROW_ID
		</cfquery>
		<cfoutput query="get_offer_rows">
			<cfif isdefined("attributes.quantity_#offer_row_id#")>
				<cfquery name="UPD_OFFER_ROW" datasource="#DSN3#">
					UPDATE 
						OFFER_ROW
					SET
						QUANTITY = #evaluate("attributes.quantity_#offer_row_id#")#
					WHERE
						OFFER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#offer_row_id#">
				</cfquery>
			</cfif>
		</cfoutput>
	</cftransaction>
</cflock>
<!--- <cf_workcube_process 
		is_upd='1' 
		data_source='#dsn3#' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.pp.userid#'
		record_date='#now()#' 
		action_table='OFFER'
		action_column='OFFER_ID'
		action_id='#attributes.offer_id#' 
		action_page='#request.self#?fuseaction=objects2.dsp_offer_detail&offer_id=#form.offer_id#' 
		warning_description='Teklif : #form.offer_id#'>	 --->
<cflocation url="#request.self#/#attributes.offer_id#" addtoken="no">

