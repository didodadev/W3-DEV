<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfscript>
			form_consumer_transfer_id = evaluate("attributes.consumer_transfer_id#i#");
			form_delegate_city_id = evaluate("attributes.delegate_city_id#i#");
			ref_pos_code = evaluate("attributes.ref_pos_code#i#");	
		</cfscript>
		<cfif evaluate("attributes.row_kontrol#i#") and not len (form_consumer_transfer_id)>
			<cfquery datasource="#DSN#">
				INSERT INTO
					CONSUMER_TRANSFER
				(
					CITY_ID,
					DELEGATE_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					<cfif len(form_delegate_city_id)>#form_delegate_city_id#<cfelse>NULL</cfif>,
					<cfif len(ref_pos_code)>#ref_pos_code#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>
		<cfif evaluate("attributes.row_kontrol#i#") and  len (form_consumer_transfer_id)>
			<cfquery datasource="#DSN#">
				UPDATE [CONSUMER_TRANSFER]
					SET [CITY_ID] = <cfif len(form_delegate_city_id)>#form_delegate_city_id#<cfelse>NULL</cfif>,
						[DELEGATE_ID] = <cfif len(ref_pos_code)>#ref_pos_code#<cfelse>NULL</cfif>,
						[RECORD_DATE] = #now()#,
						[RECORD_EMP] =#session.ep.userid#,
						[RECORD_IP] = '#cgi.remote_addr#'
					WHERE 
					CONSUMER_TRANSFER_ID=#form_consumer_transfer_id#
			</cfquery>
		<cfelseif evaluate("attributes.row_kontrol#i#") eq 0 and len(form_consumer_transfer_id)>
			<cfquery datasource="#DSN#">
				DELETE FROM CONSUMER_TRANSFER WHERE CONSUMER_TRANSFER_ID = #form_consumer_transfer_id#
			</cfquery>
		</cfif>
	</cfloop>
</cfif>

<cflocation url="#request.self#?fuseaction=settings.popup_delegete_definition" addtoken="no" />