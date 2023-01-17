<cf_date tarih="attributes.EXITDATE">
<cf_date tarih="attributes.entry_date">
<cftransaction>
	<cfquery name="add_employee_ın_out" datasource="#dsn#">
		UPDATE
			EMPLOYEES_IN_OUT
		SET
			IS_EMPTY_POSITION = <cfif isdefined("attributes.IS_EMPTY_POSITION")>1<cfelse>0</cfif>,
			FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.EXITDATE#">,
			DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EXIT_DETAIL#">,
			EXPLANATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.explanation_id#">,
			IN_COMPANY_REASON_ID = <cfif isdefined('attributes.reason_id') and len(attributes.reason_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_id#">,<cfelse>NULL,</cfif>
			VALID = 1,<!--- toplu islemde hepsi onaylı kabul ediliyor--->
			VALID_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
			VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
		WHERE
			IN_OUT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.in_out_id_list#">)
	</cfquery>
 <cfif isdefined('attributes.pass_branch')>
	<cfloop list="#attributes.in_out_id_list#" index="ch">
		<cfquery name="add_employee_ın_out_work_entry" datasource="#dsn#"><!--- yeni subeye giris yapar --->
			INSERT INTO
				EMPLOYEES_IN_OUT
				(
				BRANCH_ID,
				DEPARTMENT_ID,
				EMPLOYEE_ID,
				START_DATE,
				SALARY,
				IS_5084,
				SOCIALSECURITY_NO,
				DUTY_TYPE,
				EFFECTED_CORPORATE_CHANGE,
				PAYMETHOD_ID,
				ALLOCATION_DEDUCTION,
				ALLOCATION_DEDUCTION_MONEY,
				GROSS_NET,
				SALARY_TYPE,
				SABIT_PRIM,
				SALARY1,
				MONEY,
				CUMULATIVE_TAX_TOTAL,
				RETIRED_SGDP_NUMBER,
				USE_SSK,
				USE_TAX,
				TRADE_UNION,
				TRADE_UNION_NO,
				TRADE_UNION_DEDUCTION,
				TRADE_UNION_DEDUCTION_MONEY,
				SSK_STATUTE,
				DEFECTION_LEVEL,
				SALARY_VISIBLE,
				FIRST_SSK_DATE,
				OLD_COMPANY_START_DATE,
				START_CUMULATIVE_TAX,
				SURELI_IS_AKDI,
				SURELI_IS_FINISHDATE,
				IS_VARDIYA,
				USE_PDKS,
				PDKS_NUMBER,
				IS_SSK_ISVEREN,
				OZEL_GIDER_INDIRIM,
				OZEL_GIDER_VERGI,
				MAHSUP_IADE,
				FAZLA_MESAI_SAAT,
				POSITION_CODE,
				IS_TAX_FREE,
				SHIFT_ID,
				IS_DISCOUNT_OFF,
				IS_USE_506,
				IS_PUANTAJ_OFF,
				DAYS_506,
				DOC_REPEAT,
				IS_5510,
				IS_DAMGA_FREE,
				BUSINESS_CODE_ID,
				PUANTAJ_GROUP_IDS,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				EX_IN_OUT_ID,<!---nakil hangi giris/cikis kaydi uzerinden yapildigini tutmak icin eklenmistir SG20120813 --->
				IN_OUT_STAGE
				)
					SELECT
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,
						EMPLOYEE_ID,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.entry_date#">,
						SALARY,
						IS_5084,
						SOCIALSECURITY_NO,
						DUTY_TYPE,
						EFFECTED_CORPORATE_CHANGE,
						PAYMETHOD_ID,
						ALLOCATION_DEDUCTION,
						ALLOCATION_DEDUCTION_MONEY,
						GROSS_NET,
						SALARY_TYPE,
						SABIT_PRIM,
						SALARY1,
						MONEY,
						CUMULATIVE_TAX_TOTAL,
						RETIRED_SGDP_NUMBER,
						USE_SSK,
						USE_TAX,
						TRADE_UNION,
						TRADE_UNION_NO,
						TRADE_UNION_DEDUCTION,
						TRADE_UNION_DEDUCTION_MONEY,
						SSK_STATUTE,
						DEFECTION_LEVEL,
						SALARY_VISIBLE,
						FIRST_SSK_DATE,
						OLD_COMPANY_START_DATE,
						START_CUMULATIVE_TAX,
						SURELI_IS_AKDI,
						SURELI_IS_FINISHDATE,
						IS_VARDIYA,
						USE_PDKS,
						PDKS_NUMBER,
						IS_SSK_ISVEREN,
						OZEL_GIDER_INDIRIM,
						OZEL_GIDER_VERGI,
						MAHSUP_IADE,
						FAZLA_MESAI_SAAT,
						POSITION_CODE,
						IS_TAX_FREE,
						SHIFT_ID,
						IS_DISCOUNT_OFF,
						IS_USE_506,
						IS_PUANTAJ_OFF,
						DAYS_506,
						DOC_REPEAT,
						IS_5510,
						IS_DAMGA_FREE,
						BUSINESS_CODE_ID,
						PUANTAJ_GROUP_IDS,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ch#">,
						<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>
					FROM
						EMPLOYEES_IN_OUT
					WHERE
						IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ch#">
		</cfquery>
		<cfquery name="get_last_id" datasource="#dsn#">
			SELECT MAX(IN_OUT_ID) AS LAST_ID FROM EMPLOYEES_IN_OUT
		</cfquery>
		<cfset attributes.IN_OUT_ID = get_last_id.LAST_ID>
<cfif isdefined('attributes.is_salary')>
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_SALARY
				(
				IN_OUT_ID,
				EMPLOYEE_ID,
				PERIOD_YEAR,
				MONEY,
				M1,
				M2,
				M3,
				M4,
				M5,
				M6,
				M7,
				M8,
				M9,
				M10,
				M11,
				M12,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
				)
				SELECT
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
					EMPLOYEE_ID,
					PERIOD_YEAR,
					MONEY,
					M1,
					M2,
					M3,
					M4,
					M5,
					M6,
					M7,
					M8,
					M9,
					M10,
					M11,
					M12,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				FROM
					EMPLOYEES_SALARY
				WHERE
					IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ch#"> AND
					PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
		</cfquery>
</cfif>	
<cfif isdefined('attributes.is_salary_detail')>	
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				SALARYPARAM_PAY
				(
				IN_OUT_ID,
				COMMENT_PAY,
                COMMENT_PAY_ID,
				PERIOD_PAY,
				METHOD_PAY,
				AMOUNT_PAY,
				SSK,
				TAX,
				SHOW,
				START_SAL_MON,
				END_SAL_MON,
				EMPLOYEE_ID,
				TERM,
				CALC_DAYS,
				IS_KIDEM,
				FROM_SALARY,	
				IS_EHESAP,
				IS_DAMGA,
				IS_ISSIZLIK,
				FILE_NAME,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				SSK_STATUE,
				STATUE_TYPE,
				PROJECT_ID
				)
				SELECT
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
					COMMENT_PAY,
                    COMMENT_PAY_ID,
					PERIOD_PAY,
					METHOD_PAY,
					AMOUNT_PAY,
					SSK,
					TAX,
					SHOW,
					START_SAL_MON,
					END_SAL_MON,
					EMPLOYEE_ID,
					TERM,
					CALC_DAYS,
					IS_KIDEM,
					FROM_SALARY,	
					IS_EHESAP,
					IS_DAMGA,
					IS_ISSIZLIK,
					FILE_NAME,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					SSK_STATUE,
					STATUE_TYPE,
					PROJECT_ID
				FROM
					SALARYPARAM_PAY
				WHERE
					IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ch#"> AND
					TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
		</cfquery>
		
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				SALARYPARAM_GET
				(
				IN_OUT_ID,
				COMMENT_GET,
				PERIOD_GET,
				METHOD_GET,
				AMOUNT_GET,
				SHOW,
				START_SAL_MON,
				END_SAL_MON,
				EMPLOYEE_ID,
				ACCOUNT_CODE,
				ACCOUNT_NAME,
				ACC_TYPE_ID,
				CONSUMER_ID,
				COMPANY_ID,
				MONEY,
				TAX,
				TERM,
				CALC_DAYS,
				FROM_SALARY,
				IS_INST_AVANS,
				DETAIL,	
				IS_EHESAP,
				FILE_NAME,
				TOTAL_GET,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				IS_NET_TO_GROSS
				)
				SELECT
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
					COMMENT_GET,
					PERIOD_GET,
					METHOD_GET,
					AMOUNT_GET,
					SHOW,
					START_SAL_MON,
					END_SAL_MON,
					EMPLOYEE_ID,
					ACCOUNT_CODE,
					ACCOUNT_NAME,
					ACC_TYPE_ID,
					CONSUMER_ID,
					COMPANY_ID,
					MONEY,
					TAX,
					TERM,
					CALC_DAYS,
					FROM_SALARY,
					IS_INST_AVANS,
					DETAIL,	
					IS_EHESAP,
					FILE_NAME,
					TOTAL_GET,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					IS_NET_TO_GROSS
				FROM
					SALARYPARAM_GET
				WHERE
					IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ch#"> AND
					TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
		</cfquery>
		
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				SALARYPARAM_EXCEPT_TAX
				(
				IN_OUT_ID,
				TAX_EXCEPTION,
				START_MONTH,
				FINISH_MONTH,
				AMOUNT,
				EMPLOYEE_ID,
				TERM,
				CALC_DAYS,
				YUZDE_SINIR,
				IS_ALL_PAY,
				IS_ISVEREN,
				FILE_NAME,
				IS_SSK,
				EXCEPTION_TYPE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
				)
				SELECT
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
					TAX_EXCEPTION,
					START_MONTH,
					FINISH_MONTH,
					AMOUNT,
					EMPLOYEE_ID,
					TERM,
					CALC_DAYS,
					YUZDE_SINIR,
					IS_ALL_PAY,
					IS_ISVEREN,
					FILE_NAME,
					IS_SSK,
					EXCEPTION_TYPE,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				FROM
					SALARYPARAM_EXCEPT_TAX
				WHERE
					IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ch#"> AND
					TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
		</cfquery>
		
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				SALARYPARAM_BES
				(
					COMMENT_BES,
                    RATE_BES,
                    START_SAL_MON,
                    END_SAL_MON,
                    EMPLOYEE_ID,
                    TERM,
                    IN_OUT_ID,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
					COMMENT_BES_ID
				)
				SELECT					
                    COMMENT_BES,
                    RATE_BES,
                    START_SAL_MON,
                    END_SAL_MON,
                    EMPLOYEE_ID,
                    TERM,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					COMMENT_BES_ID
				FROM
					SALARYPARAM_BES
				WHERE
					IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ch#"> AND
					TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
		</cfquery>
</cfif>	
<!--- muhasebe bilgileri--->
<cfif isdefined("attributes.is_accounting")>
		<cfquery name="add_period" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_IN_OUT_PERIOD
				(
					IN_OUT_ID,
					PERIOD_ID,
					ACCOUNT_BILL_TYPE,
					ACCOUNT_CODE,
					EXPENSE_CODE,
					EXPENSE_ITEM_ID,
					ACCOUNT_NAME,
					EXPENSE_CODE_NAME,
					EXPENSE_ITEM_NAME,
					RECORD_PERIOD_ID,
					PERIOD_YEAR,
					PERIOD_COMPANY_ID,
					EXPENSE_CENTER_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				SELECT
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
					PERIOD_ID,
					ACCOUNT_BILL_TYPE,
					ACCOUNT_CODE,
					EXPENSE_CODE,
					EXPENSE_ITEM_ID,
					ACCOUNT_NAME,
					EXPENSE_CODE_NAME,
					EXPENSE_ITEM_NAME,
					RECORD_PERIOD_ID,
					PERIOD_YEAR,
					PERIOD_COMPANY_ID,
					EXPENSE_CENTER_ID,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				FROM
					EMPLOYEES_IN_OUT_PERIOD
				WHERE
					IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ch#">
		</cfquery>
</cfif>	
<cfif isdefined("attributes.is_update_position")><!--- pozisyon bilgileri guncellensin isaretlendi ise pozisyon karti ve gorev degisikligine kayıt at SG20120813--->
	<cfquery name="get_employee_id" datasource="#dsn#">
		SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ch#">
	</cfquery>
	<!--- master pozisyondaki departman bilgisi guncelleniyor---->
	<cfquery name="upd_pos_dept" datasource="#dsn#">
		UPDATE EMPLOYEE_POSITIONS SET DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee_id.employee_id#"> AND IS_MASTER = 1
	</cfquery>
		<!--- gorev degisikligi kartina kayit at--->
		<cfquery name="get_history" datasource="#dsn#" maxrows="1">
			SELECT ID FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee_id.employee_id#"> AND FINISH_DATE IS NULL ORDER BY START_DATE DESC
		</cfquery>
		<cfif get_history.recordcount>
		<cfquery name="upd_change_history" datasource="#dsn#" maxrows="1">
			UPDATE 
				EMPLOYEE_POSITIONS_CHANGE_HISTORY 
			SET 
				FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.exitdate#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#"> 
			WHERE 
				ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_history.id#"> 
		</cfquery>
		</cfif>
		<cfquery name="get_master_position" datasource="#dsn#" maxrows="1">
			SELECT POSITION_ID,POSITION_NAME,POSITION_CAT_ID,TITLE_ID,FUNC_ID,ORGANIZATION_STEP_ID,COLLAR_TYPE,UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee_id.employee_id#"> AND IS_MASTER = 1
		</cfquery>
        <cfif get_master_position.recordcount>
            <cfquery name="add_new" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEE_POSITIONS_CHANGE_HISTORY
                    (
                        EMPLOYEE_ID,
                        DEPARTMENT_ID,
                        POSITION_ID,
                        POSITION_NAME,
                        POSITION_CAT_ID,
                        TITLE_ID,
                        FUNC_ID,
                        ORGANIZATION_STEP_ID,
                        COLLAR_TYPE,
                        UPPER_POSITION_CODE,
                        UPPER_POSITION_CODE2,
                        START_DATE,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP,
                        REASON_ID
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee_id.employee_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.position_id#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_master_position.position_name#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.position_cat_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.title_id#">,
                        <cfif len(get_master_position.func_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.func_id#"><cfelse>NULL</cfif>,
                        <cfif len(get_master_position.organization_step_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.organization_step_id#"><cfelse>NULL</cfif>,
                        <cfif len(get_master_position.collar_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.collar_type#"><cfelse>NULL</cfif>,
                        <cfif len(get_master_position.upper_position_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.upper_position_code#"><cfelse>NULL</cfif>,
                        <cfif len(get_master_position.upper_position_code2)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.upper_position_code2#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.entry_date#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                        <cfif isdefined('attributes.reason_id') and len(attributes.reason_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_id#"><cfelse>NULL</cfif>
                    )
            </cfquery>
        </cfif>
</cfif>
		<cfinclude template="../query/add_in_out_history.cfm"><!--- Historye kayıt atıyor..--->
        <cfquery name="getEmpName" datasource="#dsn#">
            SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IN_OUT_ID_LIST#" list="yes">)
        </cfquery>
		<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#'
			record_date='#now()#' 
			action_table='EMPLOYEES_IN_OUT'
			action_column='IN_OUT_ID'
			action_id='#get_last_id.last_id#' 
			action_page='#request.self#?fuseaction=#fusebox.circuit#.list_salary&event=upd&in_out_id=#get_last_id.last_id#&empName=#UrlEncodedFormat("#getEmpName.EMPLOYEE#")#' 
			warning_description='Ücret Bilgileri'>
	</cfloop>
</cfif>
</cftransaction>
	<cfif not isdefined('attributes.in_out_id_list') OR (ListLen(attributes.in_out_id_list,',') eq 0)>
		<script type="text/javascript">
			alert('Seçilen Şubede Çalışan Bulunmamaktadır!');
			history.back();
		</script>
	</cfif>
	<cfif isdefined('attributes.pass_branch') and isdefined('attributes.in_out_id_list')>
		<script type="text/javascript">
			alert('Giriş Tamamlanmıştır');
			history.back();
		</script>
	<cfelseif  isdefined('attributes.in_out_id_list')>
		<script type="text/javascript">
			alert('İşten Çıkarma İşlemi Tamamlanmıştır!');
			history.back();
		</script>
	</cfif>
