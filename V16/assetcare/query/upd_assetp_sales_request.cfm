<cfif len(attributes.request_date)><cf_date tarih='attributes.request_date'></cfif>
<cflock name="#CreateUUID()#" timeout="60">
<cftransaction>
<cfquery name="UPD_ASSETP_REQUEST" datasource="#DSN#">
	UPDATE
		ASSET_P_REQUEST				
	SET
		ASSETP_CATID = #attributes.cat_id#,
		REQUEST_TYPE_ID = 2,
		DEPARTMENT_ID = #attributes.department_id#,
		EMPLOYEE_ID = #attributes.employee_id#,
		REQUEST_DATE = #attributes.request_date#,
		DETAIL = '#attributes.detail#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		REQUEST_ID = #attributes.request_id#
		
</cfquery>
<cfquery name="GET_MAX" datasource="#dsn#">
	SELECT MAX(REQUEST_ID) AS MAX_ID FROM ASSET_P_REQUEST
</cfquery>

<cfif isnumeric(attributes.record_num_sabit)>
<cfloop from="1" to="#attributes.record_num_sabit#" index="j">	
	<cfif evaluate("attributes.row_kontrol_sabit#j#") eq 0>
		<cfquery name="DEL_" datasource="#dsn#">
			DELETE FROM ASSET_P_REQUEST_ROW WHERE REQUEST_ROW_ID = #evaluate("attributes.row_id_sabit#j#")#
		</cfquery>
	</cfif>
</cfloop>
</cfif>
<cfif len(attributes.record_num) and attributes.record_num neq "">
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif evaluate("attributes.row_kontrol#i#")>
			<cfscript>
			form_brand_id = evaluate("attributes.brand_id#i#");
			form_brand_type = evaluate("attributes.brand_type#i#");
			form_assetp_id = evaluate("attributes.assetp_id#i#");
			form_quantity = evaluate("attributes.quantity#i#");
			form_make_year = evaluate("attributes.make_year#i#");
			</cfscript>
			<cfquery name="ADD_SALES_ROW" datasource="#dsn#">
			INSERT
			INTO
				ASSET_P_REQUEST_ROW
				(
					REQUEST_ID,
					VALID_STATUS_ID,					
					ASSETP_ID,
					BRAND_ID,
					BRAND_TYPE,
					QUANTITY,
					MAKE_YEAR
				)
			VALUES
				(
					#GET_MAX.MAX_ID#,
					#listgetat(attributes.process_cat,i)#,
					#form_assetp_id#,
					#form_brand_id#,
					<cfif len(form_brand_type)>'#form_brand_type#'<cfelse>NULL</cfif>,
					<cfif len(form_quantity)>#form_quantity#<cfelse>NULL</cfif>,
					<cfif len(form_make_year)>#form_make_year#<cfelse>NULL</cfif>
				)
		</cfquery>
	</cfif>
</cfloop>
</cfif>
</cftransaction>
</cflock>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
