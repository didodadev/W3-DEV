<cflock name="#CreateUUID()#" timeout="30">
	<cftransaction>
		<cfif len(DOCUMENT_APPROVA_DATE)><cf_date tarih = "DOCUMENT_APPROVA_DATE"></cfif>
		<cfif len(VISA_DATE)><cf_date tarih = "VISA_DATE"></cfif>
		<cfquery name="upd_product_guaranty" datasource="#dsn3#">
			UPDATE
				PRODUCT_GUARANTY
			SET
				SALE_GUARANTY_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sale_guaranty_cat#">,
				SALE2_GUARANTY_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sale2_guaranty_cat#">,
				TAKE_GUARANTY_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#take_guaranty_cat#">,
				SUPPORT_DURATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#support_duration#">,
				DOCUMENT_APPROVA_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DOCUMENT_APPROVA_DATE#" null="#not len(DOCUMENT_APPROVA_DATE)#">,
				DOCUMENT_APPROVA_NUMBER = <cfqueryparam cfsqltype="cf_sql_float" value="#DOCUMENT_APPROVA_NUMBER#" null="#not len(DOCUMENT_APPROVA_NUMBER)#">,
				VISA_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#VISA_DATE#" null="#not len(VISA_DATE)#">,
				<cfif  support_cat gt 0> 
					SUPPORT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#support_cat#">,
				<cfelse>
					SUPPORT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				</cfif>
				IS_LOCAL_SERIAL = <cfif isDefined('form.is_local_serial')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				IS_REPAIR = <cfif isDefined('form.is_repair')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				IS_GUARANTY_WRITE = <cfif isDefined('form.is_write')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				REJECT_RATE = <cfif isdefined('attributes.reject_rate') and len(attributes.reject_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.reject_rate#"><cfelse>NULL</cfif>,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
			WHERE
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		</cfquery>
	</cftransaction>
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='PRODUCT_GUARANTY'
		action_column='PRODUCT_ID'
		action_id='#attributes.pid#'
		action_page='#request.self#?fuseaction=product.emptypopup_product_guaranty_upd_act&pid=#attributes.pid#' 
		warning_description = 'İlgili Ürün ID: #attributes.pid#'>
</cflock>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
