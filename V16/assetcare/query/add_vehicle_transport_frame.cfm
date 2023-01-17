<cf_date tarih='attributes.shipping_date'>
<cfset attributes.plate = replace(attributes.plate," ","","all")>
<cfquery name="ins_transport" datasource="#dsn#"> 
	INSERT INTO 
		ASSET_P_TRANSPORT
		(
			SHIP_NUM,
			SHIP_DATE,
			SENDER_DEPOT,
			SENDER_EMP_ID,
			RECEIVER_DEPOT,
			SHIP_METHOD,
			SHIP_FIRM,
			PLATE,
			PACK_QUANTITY,
			PACK_DESI,
			STUFF_TYPE,
			TOTAL_AMOUNT,
			TOTAL_CURRENCY,
			SHIP_STATUS,
			DOCUMENT_NUM, 
			DOCUMENT_TYPE,
			DETAIL,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		) 
		VALUES 
		(
			'#attributes.shipping_num#',
			#attributes.shipping_date#,
			#attributes.sender_depot_id#,
			#attributes.sender_employee_id#,
			#attributes.receiver_depot_id#,
			#attributes.shipping_type#,
			#attributes.transporter_id#,
			<cfif len(attributes.plate)>'#attributes.plate#'<cfelse>NULL</cfif>,
			<cfif len(attributes.quantity)>#attributes.quantity#<cfelse>NULL</cfif>,
			<cfif len(attributes.desi)>#attributes.desi#<cfelse>NULL</cfif>,			
			<cfif len(attributes.stuff_type)>#attributes.stuff_type#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_amount)>#attributes.total_amount#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_amount) and len(attributes.total_currency)>'#attributes.total_currency#'<cfelse>NULL</cfif>,
			<cfif len(attributes.shipping_status)>#attributes.shipping_status#<cfelse>NULL</cfif>,
			<cfif len(attributes.document_num)>'#attributes.document_num#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.document_type") and len(attributes.document_type)>#attributes.document_type#<cfelse>NULL</cfif>,
			<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#'
		)
</cfquery>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=add_tr</cfoutput>';
</script>

