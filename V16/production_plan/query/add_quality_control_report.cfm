<cfquery name="ADD_ORDER_RESULT_QUALITY" datasource="#DSN3#">
	SET NOCOUNT ON
	INSERT INTO
		ORDER_RESULT_QUALITY
		(
			CONTROL_AMOUNT,
			IS_REPROCESS,
			STOCK_ID,
			RESULT_NO,
			Q_CONTROL_NO,
			RECORD_DATE,
			PROCESS_ID,
			PROCESS_ROW_ID, 
			SHIP_WRK_ROW_ID,
			SHIP_PERIOD_ID,
			PROCESS_CAT,
			RECORD_EMP,
			STAGE,
			CONTROLLER_EMP_ID,
			CONTROL_DATE
		)
	 VALUES
		(
			<cfif isDefined("attributes.control_amount_control") and Len(attributes.control_amount_control)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.control_amount_control#"><cfelse>NULL</cfif>,
			<cfif isDefined("attributes.is_reprocess") and Len(attributes.is_reprocess)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_reprocess#"><cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.result_no#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.q_control_no#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PROCESS_ID#">,<!--- üRETİMDEN GELİYORSA P_ORDER_ID İRSALİYEDEN GELİYOR İSE SHIP_ID--->
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">,<!--- üRETİMDEN GELİYORSA PR_ORDER_ID İRSALİYEDEN GELİYOR İSE SHIP_ROW_ID...--->
			<cfif len(attributes.ship_wrk_row_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id#"><cfelse>NULL</cfif>,<!--- irsaliyeler güncellendiğinde satırlar yeniden eklendiği için satır bağlantısı kaybolmasın diye wrk_row_id ekledik --->
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
			<cfif isdefined("attributes.controller_emp_id") and len(attributes.controller_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.controller_emp_id#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.control_date") and len(attributes.control_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.control_date#"><cfelse>NULL</cfif>
		)
	SELECT @@Identity AS MAX_ID      
	SET NOCOUNT OFF
</cfquery>
<cfloop from="1" to="#attributes.rowcount_#" index="i">
	<cfquery name="ADD_ORDER_RESULT_QUALITY_ROW" datasource="#dsn3#">
		INSERT INTO
			ORDER_RESULT_QUALITY_ROW
			(
				QUALITY_DETAIL, <!--- Aciklama --->
				CONTROL_TYPE_ID, <!--- Kontrol Tipi --->
				CONTROL_ROW_ID, <!--- Kontrol Kriteri --->
				SAMPLE_COLUMN, <!--- Numune Sirasi --->
				CONTROL_RESULT, <!--- Kontrol Sonucu --->
				QUALITY_VALUE, <!--- Sonuc Durumu, Kabul Red --->
				OR_Q_ID, <!--- Bagli Belge Id --->
				MAIN_QUALITY_VALUE
			)
			VALUES
			(
				<cfif isDefined("attributes.type_description_#i#") and len(Evaluate("attributes.type_description_#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("attributes.type_description_#i#")#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.quality_type_id_#i#") and len(Evaluate("attributes.quality_type_id_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate("attributes.quality_type_id_#i#")#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.q_control_row_id_#i#") and len(Evaluate("attributes.q_control_row_id_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate("attributes.q_control_row_id_#i#")#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
				<cfif isDefined('attributes.result_#i#') and len(Evaluate('attributes.result_#i#'))><cfqueryparam cfsqltype="cf_sql_float" value="#FilterNum(Evaluate('attributes.result_#i#'))#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.accept_#i#") and Len(Evaluate('attributes.accept_#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.accept_#i#')#"><cfelse>NULL</cfif>,
				<cfif len(ADD_ORDER_RESULT_QUALITY.MAX_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#ADD_ORDER_RESULT_QUALITY.MAX_ID#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.q_row_accept_#i#") and Len(Evaluate('attributes.q_row_accept_#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.q_row_accept_#i#')#"><cfelse>NULL</cfif>
			)
	</cfquery>
</cfloop>

<cfloop from="1" to="#row_count#" index="ind">
	<cfif isDefined("attributes.q_success_id#ind#") and Len(Evaluate('attributes.q_success_id#ind#'))><cfset q_success_id = Evaluate('attributes.q_success_id#ind#')><cfelse><cfset q_success_id =""></cfif>
	<cfif isDefined("attributes.success_amount#ind#") and Len(Evaluate('attributes.success_amount#ind#'))><cfset success_amount = filterNum(Evaluate('attributes.success_amount#ind#'))><cfelse><cfset success_amount =0></cfif>
	<cfquery name="add_quality_success" datasource="#dsn3#">
		INSERT INTO
			ORDER_RESULT_QUALITY_SUCCESS_TYPE
			(
				SUCCESS_ID,
				AMOUNT,
				ORDER_RESULT_QUALITY_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfif isdefined('q_success_id') and len("q_success_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#q_success_id#"><cfelse>NULL</cfif>,
				<cfif isdefined('success_amount') and len("success_amount")><cfqueryparam cfsqltype="cf_sql_float" value="#success_amount#"><cfelse>NULL</cfif>,
				<cfif isdefined("ADD_ORDER_RESULT_QUALITY.MAX_ID") and len(ADD_ORDER_RESULT_QUALITY.MAX_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#ADD_ORDER_RESULT_QUALITY.MAX_ID#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
	</cfquery>
</cfloop>

 <!--- Belge No update ediliyor --->
 <cfif ListLen(attributes.q_control_no,"-")>
	<cfquery name="Get_General_Papers" datasource="#dsn3#">
		SELECT MAX(<cfif attributes.process_cat eq 171>PRODUCTION_QUALITY_CONTROL_NUMBER<cfelse>QUALITY_CONTROL_NUMBER</cfif>) MAX_NO FROM #dsn3_alias#.GENERAL_PAPERS WHERE <cfif attributes.process_cat eq 171>PRODUCTION_QUALITY_CONTROL_NUMBER<cfelse>QUALITY_CONTROL_NUMBER</cfif> IS NOT NULL
	</cfquery>
	<cfif Get_General_Papers.RecordCount>
		<cfquery name="Upd_General_Papers" datasource="#dsn3#">
			UPDATE
				#dsn3_alias#.GENERAL_PAPERS
			SET
				<cfif attributes.process_cat eq 171>PRODUCTION_QUALITY_CONTROL_NUMBER<cfelse>QUALITY_CONTROL_NUMBER</cfif> = #Get_General_Papers.Max_No+1#
			WHERE
				<cfif attributes.process_cat eq 171>PRODUCTION_QUALITY_CONTROL_NUMBER<cfelse>QUALITY_CONTROL_NUMBER</cfif> IS NOT NULL
		</cfquery>
	</cfif>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn3#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='ORDER_RESULT_QUALITY'
	action_column='OR_Q_ID'
	action_id='#ADD_ORDER_RESULT_QUALITY.MAX_ID#'
	action_page='#request.self#?fuseaction=stock.list_quality_controls&event=upd&or_q_id=#ADD_ORDER_RESULT_QUALITY.MAX_ID#' 
	warning_description='Kalite : #attributes.q_control_no#'>

<script type="text/javascript">
	window.location.href= '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls&event=upd&or_q_id=#ADD_ORDER_RESULT_QUALITY.MAX_ID#</cfoutput>';
</script>