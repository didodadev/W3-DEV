<cfif not len(attributes.MAIN_STOCK_ID)><cfset attributes.MAIN_STOCK_ID = -1></cfif>
<cfif attributes.RELATED_ID gt 0>
	<cfquery name="check_sub" datasource="#dsn3#">
		SELECT
			PRODUCT_ID
		FROM
			PRODUCT_TREE
		WHERE
			RELATED_ID = #attributes.MAIN_STOCK_ID#
		AND
			STOCK_ID = #attributes.RELATED_ID#
	</cfquery>
	<cfif check_sub.recordcount >
		<script type="text/javascript">
			alert("<cf_get_lang no ='627.Bu ürünü eklerseniz Ürün Ağacınızda Hirerarşi sorunu oluşur'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif attributes.RELATED_ID neq attributes.MAIN_STOCK_ID>
 <cfinclude template="../query/get_history_product_tree.cfm"> 
	<cfquery name="upd_sub_pro" datasource="#DSN3#">
    	UPDATE
			PRODUCT_TREE
		SET
			RELATED_ID = <cfif attributes.RELATED_ID gt 0>#attributes.RELATED_ID#<cfelse>NULL</cfif>,
			<cfif attributes.MAIN_STOCK_ID gt 0>STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_stock_id#">,</cfif>
			AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value ="#attributes.AMOUNT#">,
			SPECT_MAIN_ID = <cfif len(attributes.spect_main_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_iD#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.unit_id") AND attributes.unit_id GT 0>UNIT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">,</cfif>
			IS_CONFIGURE=<cfif isdefined("attributes.is_configure")>0<cfelse>1</cfif>,
			IS_SEVK=<cfif isdefined("attributes.is_sevk")>1<cfelse>0</cfif>,
            IS_PHANTOM = <cfif isdefined("attributes.is_phantom")>1<cfelse>0</cfif>,
            LINE_NUMBER= <cfif isdefined('attributes.line_number') and len(attributes.line_number)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.line_number#"><cfelse>NULL</cfif>,
            OPERATION_TYPE_ID= <cfif isdefined('attributes.operation_type_id') and len(attributes.operation_type_id) and len(attributes.operation_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_iD#"><cfelse>NULL</cfif>,
            QUESTION_ID=<cfif isdefined('attributes.alternative_questions') and len(attributes.alternative_questions) ><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.alternative_questions#"><cfelse>NULL</cfif>,
			PROCESS_STAGE =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
            PRODUCT_ID=<cfif isdefined('attributes.product_id') and len(attributes.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_iD#"><cfelse>NULL</cfif>,
			IS_FREE_AMOUNT=<cfif isdefined("attributes.is_free_amount")>1<cfelse>0</cfif>,
			FIRE_AMOUNT=<cfif isdefined('attributes.fire_amount') and len(attributes.fire_amount)><cfqueryparam cfsqltype="cf_sql_float" value ="#attributes.fire_amount#"><cfelse>NULL</cfif>,
			FIRE_RATE=<cfif isdefined('attributes.fire_rate') and len(attributes.fire_rate)><cfqueryparam cfsqltype="cf_sql_float" value ="#attributes.fire_rate#"><cfelse>NULL</cfif>,
			DETAIL=<cfif isdefined('attributes.detail') and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
            UPDATE_EMP=	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			PRODUCT_WIDTH=<cfif isdefined('attributes.product_width') and len(attributes.product_width)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_width#"><cfelse>NULL</cfif>,
			PRODUCT_LENGTH=<cfif isdefined('attributes.product_length') and len(attributes.product_length)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_length#"><cfelse>NULL</cfif>,
			PRODUCT_HEIGHT=<cfif isdefined('attributes.product_height') and len(attributes.product_height)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_height#"><cfelse>NULL</cfif>,
			TREE_TYPE=<cfif isdefined('attributes.tree_types') and len(attributes.tree_types)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tree_types#"><cfelse>NULL</cfif>       

		
		WHERE
			PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_tree_id#">
    </cfquery>
    <!---Ek Bilgiler--->
	<!---<cfset attributes.info_id =  attributes.MAIN_STOCK_ID>
    <cfset attributes.is_upd = 1>
    <cfinclude template="../../objects/query/add_info_plus2.cfm">--->
    <!---Ek Bilgiler--->
	<cf_workcube_process is_upd='1' 
		data_source='#dsn3#' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_page='#request.self#?fuseaction=prod.add_product_tree&stock_id=#attributes.MAIN_STOCK_ID#' 
		action_id='#attributes.pro_tree_id#'
		action_table='PRODUCT_TREE'
		action_column='PRODUCT_TREE_ID'
		warning_description='Ürün Ağacı : #attributes.MAIN_STOCK_ID#'>
</cfif>
<script type="text/javascript">
	<cfif attributes.is_draggable>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
