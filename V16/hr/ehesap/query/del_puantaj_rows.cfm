<cfsetting showdebugoutput="no">
<cfquery name="get_puantaj_" datasource="#dsn#">
	SELECT 
		EP.PUANTAJ_TYPE,
		EP.PUANTAJ_ID,
		EP.SAL_MON,
		EP.SAL_YEAR,
		EPR.IN_OUT_ID,
		EPR.SSK_DEVIR,
		EPR.SSK_DEVIR_LAST,
		EP.SSK_OFFICE,
		EP.SSK_OFFICE_NO,
		EP.SSK_BRANCH_ID,
		EPR.EMPLOYEE_ID,
		EP.STAGE_ROW_ID
	FROM 
		EMPLOYEES_PUANTAJ_ROWS EPR,
		EMPLOYEES_PUANTAJ EP
	WHERE 
		EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
		EPR.EMPLOYEE_PUANTAJ_ID = #attributes.EMPLOYEE_PUANTAJ_ID#
</cfquery>
<cfif len(get_puantaj_.stage_row_id)>
	<cfset x_select_process=1>
<cfelse>
	<cfset x_select_process=0>
</cfif>
<cfquery name="control" datasource="#dsn#">
	SELECT 
		EP.SAL_MON,
		EP.SAL_YEAR,
		EP.PUANTAJ_TYPE,
		EPR.IN_OUT_ID,
		EPR.SSK_DEVIR,
		EPR.SSK_DEVIR_LAST,
		EP.SSK_OFFICE,
		EP.SSK_OFFICE_NO,
		EPR.EMPLOYEE_ID
	FROM 
		EMPLOYEES_PUANTAJ_ROWS EPR,
		EMPLOYEES_PUANTAJ EP
	WHERE 
		EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
		(
		(EPR.SSK_DEVIR IS NOT NULL AND EPR.SSK_DEVIR > 0)
		OR
		(EPR.SSK_DEVIR_LAST IS NOT NULL AND EPR.SSK_DEVIR_LAST > 0)
		)
		AND
		EPR.EMPLOYEE_PUANTAJ_ID = #attributes.EMPLOYEE_PUANTAJ_ID#
</cfquery>
<cfif control.recordcount>
	<cfoutput query="control">
		<cfset attributes.sal_mon = SAL_MON>
		<cfset attributes.sal_year = SAL_YEAR>
		<cfif len(ssk_devir) and ssk_devir gt 0>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE 
					EMPLOYEES_PUANTAJ_ROWS_ADD
				SET 
					AMOUNT_USED = (AMOUNT_USED - #ssk_devir#) 
				WHERE
					PUANTAJ_ID IN (SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE <cfif len(control.puantaj_type)>PUANTAJ_TYPE = #control.puantaj_type#<cfelse>PUANTAJ_TYPE = -1</cfif>) AND
					EMPLOYEE_ID = #EMPLOYEE_ID# AND
					<cfif attributes.sal_mon gt 2>
					(
					SAL_YEAR = #attributes.sal_year# AND
					SAL_MON = #attributes.sal_mon - 1# 
					)
					<cfelseif attributes.sal_mon eq 1>
					(
					SAL_YEAR = #attributes.sal_year-1# AND
					SAL_MON = 12
					)
					<cfelseif attributes.sal_mon eq 2>
					SAL_YEAR = #attributes.sal_year# AND 
					SAL_MON = 1		
					</cfif>
			</cfquery>
		</cfif>
		<cfif len(ssk_devir_last) and ssk_devir_last gt 0>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE 
					EMPLOYEES_PUANTAJ_ROWS_ADD
				SET 
					AMOUNT_USED = (AMOUNT_USED - #ssk_devir_last#) 
				WHERE					
					PUANTAJ_ID IN (SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE <cfif len(control.puantaj_type)>PUANTAJ_TYPE = #control.puantaj_type#<cfelse>PUANTAJ_TYPE = -1</cfif>) AND
					EMPLOYEE_ID = #EMPLOYEE_ID# AND
					<cfif attributes.sal_mon gt 2>
					(
					SAL_YEAR = #attributes.sal_year# AND
					SAL_MON = #attributes.sal_mon - 2#
					)
					<cfelseif attributes.sal_mon eq 1>
					(
					SAL_YEAR = #attributes.sal_year-1# AND
					SAL_MON = 11
					)
					<cfelseif attributes.sal_mon eq 2>
					(
					(SAL_YEAR = #attributes.sal_year-1# AND SAL_MON = 12)
					)
					</cfif>
			</cfquery>
		</cfif>
	</cfoutput>
</cfif>
<cflock timeout="20">
	<cftransaction>
		<cfquery name="del_puantaj_rows" datasource="#dsn#">
		  DELETE FROM EMPLOYEES_PUANTAJ_ROWS WHERE EMPLOYEE_PUANTAJ_ID = #attributes.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfquery name="DEL_PUANTAJ_ROWS_EXT" datasource="#DSN#">
		   DELETE FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = #attributes.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfquery name="del_puantaj_rows_officer" datasource="#dsn#">
			DELETE FROM OFFICER_PAYROLL_ROW WHERE  EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.EMPLOYEE_PUANTAJ_ID#">
		</cfquery>
		<cfquery name="DEL_PUANTAJ_ROWS_EXT" datasource="#DSN#">
		   DELETE FROM EMPLOYEES_PUANTAJ_ROWS_ADD WHERE EMPLOYEE_PUANTAJ_ID = #attributes.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfquery name="upd_payrol_job" datasource="#dsn#">
			UPDATE
				PAYROLL_JOB   
			SET
				PERCENT_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">,
				PAYROLL_DRAFT  = NULL,
				EMPLOYEE_PAYROLL_ID = NULL,
				ACCOUNT_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">,
				ACCOUNT_DRAFT = NULL,
				BUDGET_COMPLETED = <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">,
				BUDGET_DRAFT = NULL
			WHERE 
				EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.EMPLOYEE_PUANTAJ_ID#">
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.EMPLOYEE_PUANTAJ_ID#" action_name="#get_puantaj_.IN_OUT_ID# - #get_puantaj_.ssk_office# - #get_puantaj_.ssk_office_no# / #get_puantaj_.sal_year# - #get_puantaj_.sal_mon# (#get_puantaj_.PUANTAJ_TYPE#) Puantaj Satırı Silindi.">
	</cftransaction>
</cflock>
<cfquery name="control_other_rows" datasource="#dsn#">
	SELECT EMPLOYEE_ID FROM EMPLOYEES_PUANTAJ_ROWS WHERE PUANTAJ_ID = #get_puantaj_.PUANTAJ_ID#
</cfquery>
<cfif control_other_rows.recordcount>
	<script type="text/javascript">
		adres_ = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_view_puantaj</cfoutput>';
		adres_menu_1 = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_menu_puantaj_sube&x_select_process=#x_select_process#&x_payment_day=#x_payment_day#</cfoutput>';
		
		adres_= adres_ + '&branch_or_user=1';
		
		sal_year_ = document.employee.sal_year.value;
		sal_mon_ = document.employee.sal_mon.value;
		ssk_office_ = list_getat(document.employee.ssk_office.value,1,'-');
		ssk_no_ = list_getat(document.employee.ssk_office.value,2,'-');
		hierarchy_ = document.employee.hierarchy_puantaj.value;
		
		var listParam = sal_mon_ + "*" + sal_year_ + "<cfoutput>*#get_puantaj_.SSK_BRANCH_ID#*#get_puantaj_.PUANTAJ_TYPE#</cfoutput>";
		get_puantaj_ = wrk_safe_query("hr_get_puantaj_",'dsn',0,listParam);
		
		if(get_puantaj_.recordcount>0)
		{
			adres_= adres_ + '&puantaj_id='+get_puantaj_.PUANTAJ_ID +'&hierarchy='+hierarchy_;
			adres_menu_1= adres_menu_1 + '&puantaj_id='+get_puantaj_.PUANTAJ_ID +'&hierarchy='+hierarchy_;
			adres_menu_1 = adres_menu_1 + '&ssk_statue=' + ssk_statue;//SGK Durumu
			adres_menu_1 = adres_menu_1 + '&statue_type=' + statue_type;//maaş tipi
		}
		
		<cfif isdefined("attributes.from_list_puantaj") and len(attributes.from_list_puantaj) and attributes.from_list_puantaj eq 1>
				AjaxPageLoad(adres_,'puantaj_list_layer_from_list_puantaj','1','Puantaj Listeleniyor');
		<cfelse>
			AjaxPageLoad(adres_,'puantaj_list_layer','1',"<cf_get_lang no ='945.Puantaj Listeleniyor'>");
		</cfif>
		AjaxPageLoad(adres_menu_1,'menu_puantaj_1','1',"<cf_get_lang no ='946.Puantaj Menüsü Yükleniyor'>");
	</script>
<cfelse>
	<cfset attributes.puantaj_id = get_puantaj_.PUANTAJ_ID>
	<cfinclude template="delet_puantaj.cfm">
</cfif>
