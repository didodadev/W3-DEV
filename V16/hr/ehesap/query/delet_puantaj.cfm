<cfsetting showdebugoutput="no">
<cfinclude template="get_puantaj.cfm">
<cfquery name="get_company" datasource="#dsn#">
	SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #get_puantaj.SSK_BRANCH_ID#
</cfquery>
<cfif get_company.recordcount>
	<cfset new_dsn2 = '#dsn#_#get_puantaj.sal_year#_#get_company.COMPANY_ID#'>
	<cfquery name="get_period" datasource="#dsn#">
		SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.COMPANY_ID#"> AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.sal_year#">
	</cfquery>
	<cfif fusebox.use_period and get_period.recordcount>
        <cfquery name="get_account_card" datasource="#new_dsn2#">
            SELECT
                AC.CARD_ID,
                AC.ACTION_DATE
            FROM
                ACCOUNT_CARD AC
            WHERE
                AC.IS_ACCOUNT = 1
                AND AC.ACTION_TYPE = 130
                AND AC.CARD_TYPE = 13
                AND AC.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#">
        </cfquery>
        <cfif get_account_card.recordcount>
			<!--- e-defter islem kontrolu SG 20141222 --->
            <cfif session.ep.our_company_info.is_edefter eq 1>
                <cfstoredproc procedure="GET_NETBOOK" datasource="#new_dsn2#">
                	<cfprocparam cfsqltype="cf_sql_timestamp" value="#get_account_card.ACTION_DATE#">
                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#get_account_card.ACTION_DATE#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="">
                    <cfprocresult name="getNetbook">
                </cfstoredproc>
                <cfif getNetbook.recordcount>
                    <script language="javascript">
                        alert('Şube Puantajı Silme : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
                        window.close();
                    </script>
                    <cfabort>
                </cfif>
            </cfif>
            <!--- e-defter islem kontrolu SG 20141222 --->
        </cfif>
        <CFLOCK timeout="20">
			<CFTRANSACTION>
			<cfquery name="get_dekont_id" datasource="#new_dsn2#">
				SELECT DEKONT_ID,PROCESS_TYPE  FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE PUANTAJ_ID = #attributes.PUANTAJ_ID#
			</cfquery>
			<cfif get_dekont_id.recordcount>
				<!--- Dekont İşlemlerinin Silinmesi --->
				<cfquery name="GET_ALL_DEKONT" datasource="#new_dsn2#">
					SELECT DEKONT_ROW_ID FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW WHERE DEKONT_ID = #get_dekont_id.dekont_id#
				</cfquery>
				<cfscript>
					for (k = 1; k lte get_all_dekont.recordcount;k=k+1)
					{
						cari_sil(action_id:get_all_dekont.DEKONT_ROW_ID[k],process_type:get_dekont_id.process_type,cari_db:new_dsn2);
						butce_sil(action_id:get_all_dekont.DEKONT_ROW_ID[k],process_type:get_dekont_id.process_type,muhasebe_db:new_dsn2);
					}
				</cfscript>
				<cfquery name="DEL_DEKONT" datasource="#new_dsn2#">
					DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE DEKONT_ID = #get_dekont_id.dekont_id#
				</cfquery>
				<cfquery name="DEL_DEKONT_ROW" datasource="#new_dsn2#">
					DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW WHERE DEKONT_ID = #get_dekont_id.dekont_id#
				</cfquery>
				<cfquery name="DEL_MONEY" datasource="#new_dsn2#">
					DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY WHERE ACTION_ID = #get_dekont_id.dekont_id#
				</cfquery>	
				<!--- Dekont İşlemlerinin Silinmesi --->
			</cfif>
			</CFTRANSACTION>
		</CFLOCK>
	</cfif>
</cfif>
<cfquery name="get_puantaj" datasource="#dsn#">
	SELECT 
    	PUANTAJ_ID, 
        SAL_MON, 
        SAL_YEAR, 
        IS_ACCOUNT, 
        SSK_OFFICE, 
        SSK_OFFICE_NO, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        COMP_NICK_NAME, 
        PUANTAJ_BRANCH_NAME, 
        PUANTAJ_BRANCH_FULL_NAME, 
        SSK_BRANCH_ID, 
        PUANTAJ_TYPE,
		STAGE_ROW_ID
    FROM 
	    EMPLOYEES_PUANTAJ 
    WHERE 
    	PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#">
</cfquery>
<!---<cfif len(get_puantaj.stage_row_id)>
	<cfset x_select_process=1>
<cfelse>
	<cfset x_select_process=0>
</cfif>--->
<cfif get_company.recordcount>
	<cfif fusebox.use_period and get_period.recordcount>
		<cfquery name="get_acc_card" datasource="#new_dsn2#">
			SELECT ACTION_ID FROM ACCOUNT_CARD WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#"> AND ACTION_TYPE = 130
		</cfquery>
		<cfquery name="get_budget" datasource="#new_dsn2#">
			SELECT ACTION_ID FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#"> AND EXPENSE_COST_TYPE = 161 AND ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
		</cfquery>
	<cfelse>
		<cfset get_acc_card.recordcount = 0>
		<cfset get_budget.recordcount = 0>
	</cfif>
<cfelse>
	<cfset get_acc_card.recordcount = 0>
	<cfset get_budget.recordcount = 0>
</cfif>

<cfquery name="delete_exts" datasource="#dsn#">
	DELETE FROM 
		SALARYPARAM_GET 
	WHERE 
		START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.sal_mon#">
		AND END_SAL_MON =  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.sal_mon#">
		AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.sal_year#">
		AND RELATED_TABLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value='COMMANDMENT'>
		AND DETAIL IN (
			SELECT DETAIL FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#"> AND RELATED_TABLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value='COMMANDMENT'>
		)
</cfquery>
<cfquery name="del_rows_ext" datasource="#dsn#">
	DELETE FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#">
</cfquery>
<cfquery name="del_rows_ext" datasource="#dsn#">
	DELETE FROM EMPLOYEES_PUANTAJ_ROWS_ADD WHERE PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#">
</cfquery>
<cfquery name="control" datasource="#dsn#">
	SELECT 
		EP.SAL_MON,
		EPR.SSK_DEVIR,
		EPR.SSK_DEVIR_LAST,
		EP.PUANTAJ_TYPE,
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
		EPR.PUANTAJ_ID = #attributes.PUANTAJ_ID#
</cfquery>
<cfif control.recordcount>
	<cfoutput query="control">
		<cfset attributes.sal_mon = get_puantaj.SAL_MON>
		<cfif len(ssk_devir) and ssk_devir gt 0>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE 
					EMPLOYEES_PUANTAJ_ROWS_ADD
				SET 
					AMOUNT_USED = (AMOUNT_USED - #ssk_devir#) 
				WHERE
					(PUANTAJ_ID IS NULL OR PUANTAJ_ID IN (SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE <cfif len(control.puantaj_type)>PUANTAJ_TYPE = #control.puantaj_type#<cfelse>PUANTAJ_TYPE = -1</cfif>)) AND
					EMPLOYEE_ID = #EMPLOYEE_ID# AND
					<cfif attributes.sal_mon gt 2>
					(
					SAL_YEAR = #get_puantaj.sal_year# AND
					SAL_MON = #attributes.sal_mon - 1# 
					)
					<cfelseif attributes.sal_mon eq 1>
					(
					SAL_YEAR = #get_puantaj.sal_year-1# AND
					SAL_MON = 12
					)
					<cfelseif attributes.sal_mon eq 2>
					SAL_YEAR = #get_puantaj.sal_year# AND 
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
					(PUANTAJ_ID IS NULL OR PUANTAJ_ID IN (SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE <cfif len(control.puantaj_type)>PUANTAJ_TYPE = #control.puantaj_type#<cfelse>PUANTAJ_TYPE = -1</cfif>)) AND
					EMPLOYEE_ID = #EMPLOYEE_ID# AND
					<cfif attributes.sal_mon gt 2>
					(
					SAL_YEAR = #get_puantaj.sal_year# AND
					SAL_MON = #attributes.sal_mon - 2#
					)
					<cfelseif attributes.sal_mon eq 1>
					(
					SAL_YEAR = #get_puantaj.sal_year-1# AND
					SAL_MON = 11
					)
					<cfelseif attributes.sal_mon eq 2>
					(
					(SAL_YEAR = #get_puantaj.sal_year-1# AND SAL_MON = 12)
					)
					</cfif>
			</cfquery>
		</cfif>
	</cfoutput>
</cfif>

<!---   MUHASEBE VE BÜTÇE SİLME--->
<cfif get_company.recordcount>
	<cfif fusebox.use_period and get_period.recordcount>
		<cfquery name="fis_row_sil" datasource="#new_dsn2#">
			DELETE FROM
				ACCOUNT_CARD_ROWS
			WHERE
				CARD_ID IN
				(
					SELECT
						AC.CARD_ID
					FROM
						ACCOUNT_CARD AC
					WHERE
						AC.IS_ACCOUNT = 1
						AND AC.ACTION_TYPE = 130
						AND AC.CARD_TYPE = 13
						AND AC.ACTION_ID = #attributes.PUANTAJ_ID#
					)
		</cfquery>
		<cfquery name="fis_row_sil" datasource="#new_dsn2#">
			DELETE FROM
				ACCOUNT_ROWS_IFRS
			WHERE
				CARD_ID IN
				(
					SELECT
						AC.CARD_ID
					FROM
						ACCOUNT_CARD AC
					WHERE
						AC.IS_ACCOUNT = 1
						AND AC.ACTION_TYPE = 130
						AND AC.CARD_TYPE = 13
						AND AC.ACTION_ID = #attributes.PUANTAJ_ID#
					)
		</cfquery>
		<cfquery name="fis_sil" datasource="#new_dsn2#">
			DELETE FROM
				ACCOUNT_CARD
			WHERE
				IS_ACCOUNT = 1
				AND ACTION_TYPE = 130
				AND CARD_TYPE = 13
				AND ACTION_ID = #attributes.PUANTAJ_ID#
		</cfquery>
		<cfquery name="fis_row_sil2" datasource="#new_dsn2#">
			DELETE FROM
				ACCOUNT_CARD_ROWS
			WHERE
				CARD_ID IN
				(
					SELECT
						AC.CARD_ID
					FROM
						ACCOUNT_CARD AC
					WHERE
						IS_ACCOUNT = 1
						AND ACTION_TYPE = 161
						AND CARD_TYPE = 13
						AND ACTION_ID = #attributes.PUANTAJ_ID#
						AND ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
					)
		</cfquery>
		<cfquery name="fis_row_sil2" datasource="#new_dsn2#">
			DELETE FROM
				ACCOUNT_ROWS_IFRS
			WHERE
				CARD_ID IN
				(
					SELECT
						AC.CARD_ID
					FROM
						ACCOUNT_CARD AC
					WHERE
						IS_ACCOUNT = 1
						AND ACTION_TYPE = 161
						AND CARD_TYPE = 13
						AND ACTION_ID = #attributes.PUANTAJ_ID#
						AND ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
					)
		</cfquery>
		<cfquery name="fis_sil2" datasource="#new_dsn2#">
			DELETE FROM
				ACCOUNT_CARD
			WHERE
				IS_ACCOUNT = 1
				AND ACTION_TYPE = 161
				AND CARD_TYPE = 13
				AND ACTION_ID = #attributes.PUANTAJ_ID#
				AND ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
		</cfquery>
		<cfquery name="cari_sil" datasource="#new_dsn2#">
			DELETE FROM
				CARI_ROWS
			WHERE
				ACTION_TYPE_ID = 161
				AND ACTION_ID = #attributes.PUANTAJ_ID#
				AND ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
		</cfquery>
		<cfquery name="fis_sil" datasource="#new_dsn2#">
			DELETE FROM
				EXPENSE_ITEMS_ROWS
			WHERE
				EXPENSE_COST_TYPE = 161
				AND ACTION_ID = #attributes.PUANTAJ_ID#
				AND ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
		</cfquery>
	</cfif>
</cfif>
<cfquery name="del_rows" datasource="#dsn#">
	DELETE FROM EMPLOYEES_PUANTAJ_ROWS WHERE PUANTAJ_ID = #attributes.PUANTAJ_ID#
</cfquery>
<cfquery name="del_puantaj_rows_officer" datasource="#dsn#">
	DELETE FROM OFFICER_PAYROLL_ROW WHERE PAYROLL_ID = #attributes.PUANTAJ_ID#
</cfquery>
<cfquery name="upd_payrol_job" datasource="#dsn#">
	UPDATE
		PAYROLL_JOB   
	SET
		PERCENT_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">,
		PAYROLL_DRAFT  = NULL,
		ACCOUNT_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">,
		ACCOUNT_DRAFT  = NULL,
		EMPLOYEE_PAYROLL_ID = NULL,
		BUDGET_COMPLETED = <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">,
        BUDGET_DRAFT = NULL
	WHERE 
		BRANCH_PAYROLL_ID = #attributes.PUANTAJ_ID#
</cfquery>
<cfquery name="del_" datasource="#dsn#">
	DELETE FROM EMPLOYEES_PUANTAJ WHERE PUANTAJ_ID = #attributes.PUANTAJ_ID#
</cfquery>
<cfquery name="DEL_OFFICER_PAYROLL_ROW" datasource="#DSN#">
	DELETE FROM OFFICER_PAYROLL_ROW WHERE PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.PUANTAJ_ID#">
</cfquery>
<cf_add_log log_type="-1" action_id="#attributes.PUANTAJ_ID#" action_name="#get_puantaj.ssk_office# - #get_puantaj.ssk_office_no# / #get_puantaj.sal_year# - #get_puantaj.sal_mon# #get_puantaj.puantaj_type# Puantaj Silindi.">
<cfif not isdefined("attributes.reload_off")>
	<script type="text/javascript">
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_menu_puantaj_sube&x_select_process=#x_select_process#&x_payment_day=#x_payment_day#&branch_id=#get_puantaj.SSK_BRANCH_ID#&ssk_statue=#attributes.ssk_statue#&statue_type=#attributes.statue_type#&statue_type_individual=#attributes.statue_type_individual#</cfoutput>','menu_puantaj_1','1','Puantaj Menüsü Yükleniyor');
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_view_puantaj&branch_id=#get_puantaj.SSK_BRANCH_ID#&sal_year=#get_puantaj.sal_year#&sal_mon=#get_puantaj.sal_mon#&ssk_statue=#attributes.ssk_statue#&statue_type=#attributes.statue_type#&statue_type_individual=#attributes.statue_type_individual#</cfoutput>','puantaj_list_layer','0','Puantaj Listeleniyor');
	</script>
</cfif>
