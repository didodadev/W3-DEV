<cf_date tarih='attributes.shipping_date'>
<cfset attributes.plate = replace(attributes.plate," ","","all")>
<cfquery name="upd_transport" datasource="#dsn#"> 
	UPDATE
		ASSET_P_TRANSPORT
		SET 
			SHIP_NUM = '#attributes.shipping_num#',
			SHIP_DATE = #attributes.shipping_date#,
			SENDER_DEPOT = #attributes.sender_depot_id#,
			SENDER_EMP_ID = #attributes.sender_employee_id#,
			RECEIVER_DEPOT = #attributes.receiver_depot_id#,
			SHIP_METHOD = #attributes.shipping_type#,
			SHIP_FIRM = #attributes.transporter_id#,
			PLATE = <cfif isdefined("attributes.plate") and len(attributes.plate)>'#attributes.plate#'<cfelse>NULL</cfif>,
			PACK_QUANTITY = <cfif isdefined("attributes.quantity") and len(attributes.quantity)>#attributes.quantity#<cfelse>NULL</cfif>,
			PACK_DESI = <cfif isdefined("attributes.desi") and len(attributes.desi)>#attributes.desi#<cfelse>NULL</cfif>,
			STUFF_TYPE = <cfif isdefined("attributes.stuff_type") and len(attributes.stuff_type)>#attributes.stuff_type#<cfelse>NULL</cfif>,
			TOTAL_AMOUNT = <cfif isdefined("attributes.total_amount") and len(attributes.total_amount)>#attributes.total_amount#<cfelse>NULL</cfif>,
			TOTAL_CURRENCY = <cfif isdefined("attributes.total_amount") and len(attributes.total_amount) and isdefined("attributes.total_currency") and len(attributes.total_currency)>'#attributes.total_currency#'<cfelse>NULL</cfif>,
			SHIP_STATUS = <cfif isdefined("attributes.shipping_status") and len(attributes.shipping_status)>#attributes.shipping_status#<cfelse>NULL</cfif>,
			DOCUMENT_NUM = <cfif isdefined("attributes.document_num") and len(attributes.document_num)>'#attributes.document_num#'<cfelse>NULL</cfif>,
			DOCUMENT_TYPE = <cfif isdefined("attributes.document_type") and len(attributes.document_type)>#attributes.document_type#<cfelse>NULL</cfif>,
			DETAIL = <cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
			SHIP_ID = #attributes.ship_id#
</cfquery>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=add_tr</cfoutput>';
</script>


