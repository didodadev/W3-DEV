<cfif len(DOCUMENT_APPROVA_DATE)>
	<cf_date tarih = "DOCUMENT_APPROVA_DATE">
</cfif>
<cfif len(VISA_DATE)>
	<cf_date tarih = "VISA_DATE">
</cfif>
<cfquery name="add_product_guaranty" datasource="#DSN3#">
	INSERT INTO 
		PRODUCT_GUARANTY
	(
		PRODUCT_ID,
		SALE_GUARANTY_CAT_ID,
		SALE2_GUARANTY_CAT_ID,
		TAKE_GUARANTY_CAT_ID,
		<cfif SUPPORT_CAT gt 0>
			SUPPORT_CAT_ID,
		</cfif>
		<cfif len(DOCUMENT_APPROVA_DATE)>
			DOCUMENT_APPROVA_DATE,
		</cfif>
		<cfif len(DOCUMENT_APPROVA_NUMBER)>
			DOCUMENT_APPROVA_NUMBER,
		</cfif>
		<cfif len(VISA_DATE)>
			VISA_DATE,
		</cfif>
		SUPPORT_DURATION,
		IS_REPAIR,
		IS_LOCAL_SERIAL,
		IS_GUARANTY_WRITE,
		REJECT_RATE,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		PROCESS_STAGE
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.PID#">,
		<cfif isDefined('attributes.SALE_GUARANTY_CAT')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SALE_GUARANTY_CAT#"><cfelse>NULL</cfif>,
		<cfif isDefined('attributes.SALE2_GUARANTY_CAT')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SALE2_GUARANTY_CAT#"><cfelse>NULL</cfif>,
		<cfif isDefined('attributes.TAKE_GUARANTY_CAT')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TAKE_GUARANTY_CAT#"><cfelse>NULL</cfif>,
		<cfif SUPPORT_CAT gt 0> 	
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SUPPORT_CAT#">,
		</cfif> 
		<cfif len(DOCUMENT_APPROVA_DATE)>
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.DOCUMENT_APPROVA_DATE#">,
		</cfif>
		<cfif len(DOCUMENT_APPROVA_NUMBER)>
			<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.DOCUMENT_APPROVA_NUMBER#">,
		</cfif>
		<cfif len(VISA_DATE)>
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.VISA_DATE#">,
		</cfif>
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SUPPORT_DURATION#">,
		<cfif isDefined('form.is_local_serial')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		<cfif isDefined('form.is_repair')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		<cfif isDefined('form.is_write')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		<cfif isdefined('attributes.reject_rate') and len(attributes.reject_rate)>#attributes.reject_rate#<cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#attributes.process_stage#
	)
</cfquery>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_id='#attributes.pid#'
	action_page='#request.self#?fuseaction=product.emptypopup_product_guaranty_upd_act&pid=#attributes.pid#' 
	warning_description = 'İlgili Ürün ID: #attributes.pid#'>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
</script>
