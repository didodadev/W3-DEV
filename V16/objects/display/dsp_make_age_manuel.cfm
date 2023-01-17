<cfsetting showdebugoutput="no"><!---bu sayfa toplu ödeme performansdan ajaxla çağrıldıgı zaman debug kapatılması gerekiyor..AE --->
<cfif not isdefined("attributes.row_id")>
	<cfset attributes.row_id = 1>
</cfif>
<cfif isdefined("attributes.is_finish_day") and attributes.is_finish_day eq 1><!--- Toplu ödeme performansından gelen parametre bitis gunune gore --->
	<cfset attributes.is_finish_day = 1>
</cfif>
<cfif isdefined ('attributes.employee_id_') and len(attributes.employee_id_)>
	<cfif listlen(attributes.employee_id_,'_') eq 2>
		<cfset attributes.employee_id = listfirst(attributes.employee_id_,'_')>
		<cfset attributes.acc_type_id = listlast(attributes.employee_id_,'_')>
	</cfif>
<cfelseif not isdefined("attributes.acc_type_id")>
	<cfset attributes.acc_type_id = "">
</cfif>
<form name="dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>" action="" method="post"></form>
<cfif isDefined("session.pp")>
	<cfset session_base_money = session.pp.money>
<cfelseif isDefined("session.ww")>
	<cfset session_base_money = session.ww.money>
<cfelse>
	<cfset session_base_money = session.ep.money>
</cfif>
<cfif isdefined("attributes.is_ajax_popup")>
	<cfif isdefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
		<cf_date tarih = "attributes.due_date_2">
	</cfif>
	<cfif isdefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
		<cf_date tarih = "attributes.due_date_1">
	</cfif>
</cfif>
<cfquery name="GET_MONEY_RATE" datasource="#DSN2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfif isdefined ('attributes.company') and len(attributes.company)>
	<cfquery name="GET_PERIODS" datasource="#DSN#">
		SELECT 
			IS_INTEGRATED,
			IS_LOCKED,
			OTHER_MONEY,
			OUR_COMPANY_ID,
			PERIOD,
			PERIOD_DATE,
			PERIOD_ID,
			PERIOD_YEAR,
			PROCESS_DATE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			STANDART_PROCESS_MONEY,
			UPDATE_DATE,
			UPDATE_IP,
			UPDATE_EMP 
		FROM 
			SETUP_PERIOD 
		WHERE 
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
			PERIOD_YEAR >= #dateformat(attributes.date1,'yyyy')# AND 
            PERIOD_YEAR <= #dateformat(attributes.date2,'yyyy')#
		ORDER BY 
			OUR_COMPANY_ID,
			PERIOD_YEAR 
	</cfquery> 
</cfif>
<cfif (isDefined("attributes.company_id") and len(attributes.company_id)) or (isDefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isdefined("attributes.employee_id") and len(attributes.employee_id))>
	<cfquery name="GET_SETUP_MONEY" datasource="#DSN2#">
		SELECT MONEY FROM SETUP_MONEY <cfif not isDefined("attributes.is_doviz_group")>WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base_money#"><cfelseif isdefined("attributes.other_money") and len(attributes.other_money)>WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money#"></cfif>
	</cfquery>

	<cfquery name="GET_ALL_ACTIONS" datasource="#DSN2#">
		SELECT 
			*
		FROM 
		(
			SELECT
				CR.ACTION_NAME,
				CR.ACTION_ID,
				CR.PAPER_NO,
				CR.ACTION_TYPE_ID,
				CR.TO_CMP_ID,
				CR.FROM_CMP_ID,
				CR.TO_CONSUMER_ID,
				CR.FROM_CONSUMER_ID,
				CR.TO_EMPLOYEE_ID,
				CR.FROM_EMPLOYEE_ID,
				CR.ACC_TYPE_ID,
				CR.ACTION_VALUE CR_ACTION_VALUE,
				ISNULL(PAPER_ACT_DATE,ACTION_DATE) ACTION_DATE,
				CR.DUE_DATE,
				CR.PROCESS_CAT,
				CR.OTHER_CASH_ACT_VALUE,
				CR.OTHER_MONEY,		
				0 TOTAL_CLOSED_AMOUNT,
				0 OTHER_CLOSED_AMOUNT,
				'' I_OTHER_MONEY,
				0 KONTROL
			FROM 
				CARI_ROWS CR
			WHERE	
				<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                    (TO_CMP_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> OR FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> ) AND
                <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                    (TO_CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> OR FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">) AND
                <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                    (TO_EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">) AND
                </cfif>	
                <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                    ISNULL(CR.ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
                </cfif>		
                CR.ACTION_TYPE_ID NOT IN (48,49,45,46) AND
                CR.ACTION_ID NOT IN (
                        SELECT 
                            ICR.ACTION_ID 
                        FROM 
                            CARI_CLOSED_ROW ICR,
                            CARI_CLOSED IC
                        WHERE 
                            ICR.CLOSED_ID = IC.CLOSED_ID 
							AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID
                            AND ICR.CLOSED_AMOUNT IS NOT NULL
                            AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
                            AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
                            AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
                            AND CR.OTHER_MONEY = ICR.OTHER_MONEY	
                            <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                                AND IC.COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                            <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                AND IC.CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                            <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                                AND IC.EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                            </cfif>
                        )
                <cfif isDefined("attributes.due_date_2") and isdate(attributes.due_date_2) and isDefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
                    AND CR.DUE_DATE BETWEEN #attributes.due_date_1# AND #attributes.due_date_2#
                <cfelseif isDefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
                    AND CR.DUE_DATE >= #attributes.due_date_1#
                <cfelseif isDefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
                    AND CR.DUE_DATE <= #attributes.due_date_2#
                </cfif>
                <cfif isDefined("attributes.action_date_1") and isdate(attributes.action_date_1) and isDefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
                    AND CR.ACTION_DATE BETWEEN #attributes.action_date_1# AND #attributes.action_date_2#
                <cfelseif isDefined("attributes.action_date_1") and isdate(attributes.action_date_1)>
                    AND CR.ACTION_DATE >= #attributes.action_date_1#
                <cfelseif isDefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
                    AND CR.ACTION_DATE <= #attributes.action_date_2#
                <cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isDefined("attributes.date1") and isdate(attributes.date1) and isDefined("attributes.date2") and isdate(attributes.date2)>
                    AND CR.ACTION_DATE BETWEEN #createodbcdatetime(attributes.date1)# AND #createodbcdatetime(attributes.date2)#
                <cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isDefined("attributes.date1") and isdate(attributes.date1)>
                    AND CR.ACTION_DATE >= #createodbcdatetime(attributes.date1)#	
                <cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isDefined("attributes.date2") and isdate(attributes.date2)>
                    AND CR.ACTION_DATE <= #createodbcdatetime(attributes.date2)#			
                </cfif>
				<cfif isDefined("attributes.other_money_2") and len(attributes.other_money_2)>
                    AND CR.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money_2#">
                </cfif>
                <cfif isDefined("attributes.other_money") and len(attributes.other_money)>
                    AND CR.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money#">
                </cfif>
                <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                    AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                <cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
                    AND CR.PROJECT_ID IS NULL						
				</cfif>
				<cfif isdefined("attributes.IS_ROW_PROJECT_BASED_CARI") and attributes.IS_ROW_PROJECT_BASED_CARI eq 1>

				</cfif>
		UNION ALL
		SELECT
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_TYPE_ID,
			CR.TO_CMP_ID,
			CR.FROM_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.FROM_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID,
			CR.FROM_EMPLOYEE_ID,
			CR.ACC_TYPE_ID,
			CR.ACTION_VALUE CR_ACTION_VALUE,
			ISNULL(CR.PAPER_ACT_DATE,CR.ACTION_DATE) ACTION_DATE,
			CR.DUE_DATE,
			CR.PROCESS_CAT,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,		
			ROUND(SUM(ICR.CLOSED_AMOUNT),2) TOTAL_CLOSED_AMOUNT,
			ROUND(SUM(ICR.OTHER_CLOSED_AMOUNT),2) OTHER_CLOSED_AMOUNT,
			ICR.OTHER_MONEY I_OTHER_MONEY,
			1 KONTROL
		FROM 
			CARI_ROWS CR
			LEFT JOIN CARI_CLOSED_ROW ICR ON CR.ACTION_ID = ICR.ACTION_ID AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID,
			CARI_CLOSED
		WHERE		
			<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
				(TO_CMP_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> OR FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">) AND
				CARI_CLOSED.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">  AND 
			<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
				(TO_CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> OR FROM_CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">) AND
				CARI_CLOSED.CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">  AND 
			<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
				(TO_EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR FROM_EMPLOYEE_ID=  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">) AND
				CARI_CLOSED.EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">  AND 
			</cfif>
			<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
				ISNULL(CR.ACC_TYPE_ID,0) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_type_id#"> AND
			</cfif>		
			CARI_CLOSED.CLOSED_ID = ICR.CLOSED_ID AND				
			CR.ACTION_TYPE_ID NOT IN (48,49,45,46) AND 
			ICR.CLOSED_AMOUNT IS NOT NULL AND
			((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
			(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
			CR.OTHER_MONEY = ICR.OTHER_MONEY				
			<cfif isDefined("attributes.due_date_2") and isdate(attributes.due_date_2) and isDefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
				AND CR.DUE_DATE BETWEEN #attributes.due_date_1# AND #attributes.due_date_2#
			<cfelseif isDefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
				AND CR.DUE_DATE >= #attributes.due_date_1#
			<cfelseif isDefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
				AND CR.DUE_DATE <= #attributes.due_date_2#
			</cfif>
			<cfif isDefined("attributes.action_date_1") and isdate(attributes.action_date_1) and isDefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
				AND CR.ACTION_DATE BETWEEN #attributes.action_date_1# AND #attributes.action_date_2#
			<cfelseif isDefined("attributes.action_date_1") and isdate(attributes.action_date_1)>
				AND CR.ACTION_DATE >= #attributes.action_date_1#
			<cfelseif isDefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
				AND CR.ACTION_DATE <= #attributes.action_date_2#
			<cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isDefined("attributes.date1") and isdate(attributes.date1) and isDefined("attributes.date2") and isdate(attributes.date2)>
				AND CR.ACTION_DATE BETWEEN #createodbcdatetime(attributes.date1)# AND #createodbcdatetime(attributes.date2)#
			<cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isDefined("attributes.date1") and isdate(attributes.date1)>
				AND CR.ACTION_DATE >= #createodbcdatetime(attributes.date1)#	
			<cfelseif isDefined("attributes.date_control") and attributes.date_control eq 1 and isDefined("attributes.date2") and isdate(attributes.date2)>
				AND CR.ACTION_DATE <= #createodbcdatetime(attributes.date2)#			
			</cfif>
			<cfif isDefined("attributes.other_money_2") and len(attributes.other_money_2)>
				AND CR.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money_2#">
			</cfif>
			<cfif isDefined("attributes.other_money") and len(attributes.other_money)>
				AND CR.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money#">
			</cfif>
			<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
				AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
				AND CR.PROJECT_ID IS NULL						
			</cfif>
			<cfif isdefined("attributes.IS_ROW_PROJECT_BASED_CARI") and attributes.IS_ROW_PROJECT_BASED_CARI eq 1>
				AND CR.CARI_aCTION_ID = ICR.CARI_ACTION_ID
			</cfif>
		GROUP BY
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_TYPE_ID,
			CR.TO_CMP_ID,
			CR.FROM_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.FROM_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID,
			CR.FROM_EMPLOYEE_ID,
			CR.ACC_TYPE_ID,
			CR.ACTION_VALUE,
			ISNULL(CR.PAPER_ACT_DATE,CR.ACTION_DATE),
			CR.DUE_DATE,
			CR.PROCESS_CAT,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,
			ICR.OTHER_MONEY	
		)T1
		WHERE
		<cfif isdefined("attributes.is_doviz_group") and len(attributes.is_doviz_group)>
			ROUND(OTHER_CLOSED_AMOUNT,2) <> ROUND(OTHER_CASH_ACT_VALUE,2)<!--- kısmi kapamaları getirsn diye.. --->
		<cfelse>
			ROUND(TOTAL_CLOSED_AMOUNT,2) <> ROUND(CR_ACTION_VALUE,2)
		</cfif>
		AND (ROUND(CR_ACTION_VALUE,2) - ROUND(TOTAL_CLOSED_AMOUNT,2)) > 0.001
		ORDER BY
			DUE_DATE
	</cfquery>
	
	<cfset process_cat_id_list = ''>
	<cfloop query="get_setup_money">
		<cfquery name="GET_CLOSEDS" datasource="#DSN2#">
			SELECT DISTINCT
				CR.CLOSED_ID 
			FROM 
				CARI_CLOSED_ROW CCR,
				CARI_CLOSED CR
			WHERE 
				CCR.CLOSED_ID = CR.CLOSED_ID AND
				<cfif isDefined("attributes.company_id") and len(attributes.company_id)>	
					CR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
					CR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">	
				<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
					CR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">	
				</cfif>
				<cfif isDefined("attributes.is_doviz_group")>
					AND CCR.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_setup_money.money#">
				</cfif>
			GROUP BY
				CR.CLOSED_ID 
		</cfquery>
		<cfquery name="GET_CLOSED_ACTIONS" datasource="#DSN2#">
			SELECT 
				CR.ACTION_NAME,
				CR.ACTION_ID,
				CR.PAPER_NO,
				CR.ACTION_TYPE_ID,
				CR.PROCESS_CAT,
				CR.TO_CMP_ID,
				CR.FROM_CMP_ID,
				CR.TO_CONSUMER_ID,
				CR.FROM_CONSUMER_ID,
				CR.TO_EMPLOYEE_ID,
				CR.FROM_EMPLOYEE_ID,
				CR.ACC_TYPE_ID,
				CR.ACTION_VALUE,
				ISNULL(CR.PAPER_ACT_DATE,CR.ACTION_DATE) ACTION_DATE,
				CR.DUE_DATE,
				CR.OTHER_CASH_ACT_VALUE,
				CR.OTHER_MONEY,
				ICR.CLOSED_ID,	
				ICR.CLOSED_AMOUNT TOTAL_CLOSED_AMOUNT,
				ICR.OTHER_CLOSED_AMOUNT OTHER_CLOSED_AMOUNT,
				ICR.OTHER_MONEY I_OTHER_MONEY,
				(ICR.CLOSED_AMOUNT/ISNULL(ICR.OTHER_CLOSED_AMOUNT,ICR.CLOSED_AMOUNT)) INV_RATE
			FROM 
				CARI_ROWS CR,
				CARI_CLOSED_ROW ICR
			WHERE
				<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
					(TO_CMP_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> OR FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">) AND
				<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
					(TO_CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> OR FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">) AND
				<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
					(TO_EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">) AND
				</cfif>	
				<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
					ISNULL(CR.ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
				</cfif>	
				<cfif isdefined("attributes.IS_ROW_PROJECT_BASED_CARI") and attributes.IS_ROW_PROJECT_BASED_CARI eq 1>
					CR.CARI_aCTION_ID = ICR.CARI_ACTION_ID AND
				</cfif>
				CR.ACTION_TYPE_ID NOT IN (48,49,45,46) AND
				CR.ACTION_ID = ICR.ACTION_ID AND
				CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND 
				ICR.CLOSED_AMOUNT IS NOT NULL AND
				((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
				(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
				CR.OTHER_MONEY = ICR.OTHER_MONEY						
				<cfif isDefined("attributes.is_doviz_group")>
					AND CR.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_setup_money.money#">
				</cfif>
				<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
					AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
					AND CR.PROJECT_ID IS NULL						
				</cfif>
				AND ROUND(ICR.CLOSED_AMOUNT,2) > 0
			ORDER BY
				ICR.CLOSED_ROW_ID
		</cfquery>
		<cfif isdefined('attributes.is_process_cat')>
			<cfoutput query="get_all_actions">
				<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
					<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
				</cfif>
			</cfoutput>
			<cfoutput query="get_closed_actions">
				<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
					<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
				</cfif>
			</cfoutput>  	
			<cfif len(process_cat_id_list)>
				<cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
				<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
					SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
				</cfquery>
				<cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat.PROCESS_CAT_ID,',')),'numeric','ASC',',')>
			</cfif>
		</cfif>
		<cfif get_closeds.recordcount and get_closed_actions.recordcount and not isdefined("is_from_collacted")>
			<table class="medium_list_search" height="35" width="99%" align="center" <cfif (isdefined("attributes.is_ajax_popup") and isdefined("attributes.detail_type") and len(attributes.detail_type) and attributes.detail_type eq 2)>style="display:none"</cfif>>
				<cfif not isdefined("attributes.is_view")>
					<tr>
						<td class="txtbold"><cfif not isdefined("attributes.is_ajax_popup")><a href="javascript:gizle_goster(make_age_<cfoutput>#currentrow#</cfoutput>);">&raquo;</a></cfif><cfif isDefined("attributes.is_doviz_group")> <cfoutput>#GET_SETUP_MONEY.MONEY#</cfoutput><cf_get_lang dictionary_id='57777.İşlemler'><cfelse> <cfoutput><cfif isdefined ('attributes.company') and len(attributes.company)>#attributes.company# #get_periods.period_year#</cfif></cfoutput><cf_get_lang dictionary_id='57802.Ödeme Performansı'></cfif></td>
					</tr>
				</cfif>
			</table>        
			<table class="medium_list" align="center" <cfif (isdefined("attributes.is_ajax_popup") and isdefined("attributes.detail_type") and len(attributes.detail_type) and attributes.detail_type eq 2)>style="display:none;width:99%;"<cfelse>style="width:99%;"</cfif> id="make_age_<cfoutput>#currentrow#</cfoutput>">
				<thead>
					<tr>
						<th align="center" style="width:60px;" nowrap><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
						<th align="center" style="width:60px;" nowrap><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
						<th style="width:55px;" nowrap><cf_get_lang dictionary_id='57880.Belge No'></th>
						<th style="width:55px;" nowrap><cf_get_lang dictionary_id='57692.İşlem'></th>
						<th nowrap style="width:60px;text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th nowrap style="width:60px;text-align:right;"><cf_get_lang dictionary_id='57882.İşlem Tutarı'></th>
						<th align="center" style="width:60px;" nowrap><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
						<th align="center" style="width:60px;" nowrap><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
						<th style="width:60px;" align="center"><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
						<th style="width:55px;" nowrap><cf_get_lang dictionary_id='57880.Belge No'></th>
						<th style="width:55px;" nowrap><cf_get_lang dictionary_id='57692.İşlem'></th>
						<th nowrap style="width:60px;text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th nowrap style="width:60px;text-align:right;"><cf_get_lang dictionary_id='57882.İşlem Tutarı'></th>
					</tr>
				</thead>
				<cfset cari_toplam_tutar1=0>
				<cfset cari_toplam_tutar2=0>
				<cfset cari_toplam_tutar1_all=0>
				<cfset cari_toplam_tutar1_all_act=0>
				<cfset cari_toplam_tutar2_all=0>
				<cfset total_kur_farki=0>
				<cfset toplam_value = 0>
				<cfoutput query="get_money_rate">
					<cfset 'cari_toplam_tutar1_#money#' = 0>
				</cfoutput>
				<cfoutput query="get_money_rate">
					<cfset 'cari_toplam_tutar2_#money#' = 0>
				</cfoutput>
				<cfoutput query="get_closeds">
					<cfquery name="GET_ROWS_B" dbtype="query">
						SELECT 
							* 
						FROM 
							GET_CLOSED_ACTIONS 
						WHERE 
							CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#closed_id#"> 
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
								AND TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
								AND TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
							<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
								AND TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
							</cfif>
							<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0>
								AND ACC_TYPE_ID = #attributes.acc_type_id#
							</cfif>		
					</cfquery>
					<cfquery name="GET_ROWS_A" dbtype="query">
						SELECT 
							* 
						FROM 
							GET_CLOSED_ACTIONS 
						WHERE 
							CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#closed_id#"> 
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
								AND FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
								AND FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
							<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
								AND FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
							</cfif>
							<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0>
								AND ACC_TYPE_ID = #attributes.acc_type_id#
							</cfif>		
					</cfquery>
					<cfset row_ = get_rows_b.recordcount>
					<cfif get_rows_a.recordcount gt get_rows_b.recordcount>
						<cfset row_ = get_rows_a.recordcount>
					</cfif>
					<cfloop from="1" to="#row_#" index="ccc">
						<tr class="color-list">
							<cfif ccc lte get_rows_b.recordcount>
								<cfif isDefined("attributes.is_doviz_group")>
									<cfset toplam_value = get_rows_b.other_closed_amount[ccc]>
								<cfelse>
									<cfset toplam_value = get_rows_b.total_closed_amount[ccc]>
								</cfif>
								<td>#dateformat(get_rows_b.action_date[ccc],dateformat_style)#</td>
								<td><cfif len(get_rows_b.due_date[ccc])>#dateformat(get_rows_b.due_date[ccc],dateformat_style)#<cfelse>#dateformat(get_rows_b.action_date[ccc],dateformat_style)#</cfif></td>
								<td>#get_rows_b.paper_no[ccc]#&nbsp;</td>
								<td>
									<cfif isdefined('attributes.is_process_cat')>
										<cfif listfind(process_cat_id_list,get_rows_b.process_cat,',')>
											#get_process_cat.process_cat[listfind(process_cat_id_list,get_rows_b.process_cat[ccc],',')]#
										<cfelse>
											#get_process_name(get_rows_b.action_type_id[ccc])#
										</cfif>
									<cfelse>
										#get_process_name(get_rows_b.action_type_id[ccc])#
									</cfif>&nbsp;
								</td>
								<td style="text-align:right;">#Tlformat(get_rows_b.total_closed_amount[ccc])# #session_base_money#</td>
								<cfset cari_toplam_tutar1 = cari_toplam_tutar1 + get_rows_b.total_closed_amount[ccc]>
								<cfif len(get_rows_b.due_date[ccc])>
									<cfset day_1 = DateDiff("d",get_rows_b.due_date[ccc],createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								<cfelse>
									<cfset day_1 = DateDiff("d",get_rows_b.action_date[ccc],createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								</cfif>
								<cfset day_2 = DateDiff("d",get_rows_b.action_date[ccc],createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								<cfset cari_toplam_tutar1_all_act = cari_toplam_tutar1_all_act + (get_rows_b.total_closed_amount[ccc]*day_2)>
								<cfset cari_toplam_tutar1_all = cari_toplam_tutar1_all + (get_rows_b.total_closed_amount[ccc]*day_1)>
								<td style="text-align:right;">#Tlformat(get_rows_b.other_closed_amount[ccc])# #get_rows_b.other_money[ccc]#</td>
								<cfset 'cari_toplam_tutar1_#get_rows_b.other_money[ccc]#' = evaluate('cari_toplam_tutar1_#get_rows_b.other_money[ccc]#') + get_rows_b.other_closed_amount[ccc]>
							<cfelse>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</cfif>
							<cfif ccc lte get_rows_a.recordcount>
								<cfset last_rate = get_rows_a.INV_RATE[ccc]>
								<td>#dateformat(get_rows_a.action_date[ccc],dateformat_style)#</td>
								<td><cfif len(get_rows_a.due_date[ccc])>#dateformat(get_rows_a.due_date[ccc],dateformat_style)#<cfelse>#dateformat(get_rows_a.action_date[ccc],dateformat_style)#</cfif></td>
								<td>&nbsp;</td>
								<td>#get_rows_a.paper_no[ccc]#&nbsp;</td>
								<td>
									<cfif isdefined('attributes.is_process_cat')>
										<cfif listfind(process_cat_id_list,get_rows_a.process_cat,',')>
											#get_process_cat.process_cat[listfind(process_cat_id_list,get_rows_a.process_cat[ccc],',')]#
										<cfelse>
											#get_process_name(get_rows_a.action_type_id[ccc])#
										</cfif>
									<cfelse>
										#get_process_name(get_rows_a.action_type_id[ccc])#
									</cfif>&nbsp;
								</td>
								<td style="text-align:right;">#Tlformat(get_rows_a.total_closed_amount[ccc])# #session_base_money#</td>
								<cfset cari_toplam_tutar2 = cari_toplam_tutar2 + get_rows_a.total_closed_amount[ccc]>
								<cfif len(get_rows_a.due_date[ccc])>
									<cfset day_2 = DateDiff("d",get_rows_a.due_date[ccc],createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								<cfelse>
									<cfset day_2 = DateDiff("d",get_rows_a.action_date[ccc],createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
								</cfif>
								<cfset cari_toplam_tutar2_all = cari_toplam_tutar2_all + (get_rows_a.total_closed_amount[ccc]*day_2)>
								<td style="text-align:right;">#Tlformat(get_rows_a.other_closed_amount[ccc])# #get_rows_a.other_money[ccc]#</td>
								<cfset 'cari_toplam_tutar2_#get_rows_a.other_money[ccc]#' = evaluate('cari_toplam_tutar2_#get_rows_a.other_money[ccc]#') + get_rows_a.other_closed_amount[ccc]>
							<cfelse>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</cfif>
						</tr>
					</cfloop>
				</cfoutput>
				<tr>
					<td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td width="80" class="txtbold">
						<cfoutput>
							<cfif cari_toplam_tutar1 neq 0>
								<cfset due_day = wrk_round((cari_toplam_tutar1_all/cari_toplam_tutar1),4)>
								<cfset due_day2 = wrk_round((cari_toplam_tutar1_all_act/cari_toplam_tutar1),4)>
								#dateformat(date_add('d',(-1*due_day),now()),dateformat_style)#
							<cfelse>&nbsp;
								<cfset due_day2 = 0>
							</cfif>
						</cfoutput>
					</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td nowrap style="text-align:right;" class="txtbold"><cfoutput>#TLFormat(cari_toplam_tutar1)# #session_base_money#</cfoutput></td>
					<td nowrap style="text-align:right;" class="txtbold">
						<cfoutput query="get_money_rate">
							<cfif evaluate('cari_toplam_tutar1_#money#') gt 0>
								#Tlformat(evaluate('cari_toplam_tutar1_#money#'))# #money#<br/>
							</cfif>
						</cfoutput>
					</td>
					<td>&nbsp;</td>
					<td width="80" class="txtbold">
						<cfoutput>
							<cfif cari_toplam_tutar2 neq 0>
								<cfset due_day = wrk_round((cari_toplam_tutar2_all/cari_toplam_tutar2),4)>
								#dateformat(date_add('d',(-1*due_day),now()),dateformat_style)#
							<cfelse>&nbsp;
								<cfset due_day = 0>
							</cfif>
						</cfoutput>
					</td>
					<td align="center" class="txtbold">						
						<cfoutput>#Tlformat(due_day2-due_day)#</cfoutput>
					</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td nowrap style="text-align:right;" class="txtbold"><cfoutput>#TLFormat(cari_toplam_tutar2)# #session_base_money#</cfoutput></td>
					<td nowrap style="text-align:right;" class="txtbold">
						<cfoutput query="get_money_rate">
							<cfif evaluate('cari_toplam_tutar2_#money#') gt 0>
								#Tlformat(evaluate('cari_toplam_tutar2_#money#'))# #money#<br/>
							</cfif>
						</cfoutput>
					</td>
				</tr>
			</table>
			<cfif isDefined("attributes.is_doviz_group")>
				<cfquery name="GET_RATE_DIFF_INV_1" datasource="#DSN2#"><!--- Alınan Kur Farkları --->
					SELECT
						ISNULL(SUM(ACTION_VALUE),0) ACTION_VALUE
					FROM
						CARI_ROWS
					WHERE
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
							FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
						<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
							FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
						<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
							FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
						</cfif>
						<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
							ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
						</cfif>
						ACTION_TYPE_ID = 49 AND
						OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_setup_money.money#">
						<cfif session.ep.isBranchAuthorization>
							AND	(FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"> OR TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
						</cfif>
						<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
							AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
						<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup")>
							AND PROJECT_ID IS NULL						
						</cfif>
				</cfquery>
				<cfquery name="GET_RATE_DIFF_INV_2" datasource="#DSN2#"><!--- Verilen Kur Farkları --->
					SELECT
						ISNULL(SUM(ACTION_VALUE),0) ACTION_VALUE
					FROM
						CARI_ROWS
					WHERE
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
							TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
						<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
							TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
						<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
							TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
						</cfif>
						<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
							ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
						</cfif>
						ACTION_TYPE_ID =48 AND
						OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_setup_money.money#">
						<cfif session.ep.isBranchAuthorization>
							AND	(FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"> OR TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
						</cfif>
						<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
							AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
						<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup")>
							AND PROJECT_ID IS NULL						
						</cfif>
				</cfquery>
				<cfquery name="GET_RATE_DIFF_DEKONT_1" datasource="#DSN2#"><!--- Alacak değerleme --->
					SELECT
						ISNULL(SUM(ACTION_VALUE),0) ACTION_VALUE
					FROM
						CARI_ACTIONS
					WHERE
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
							FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
						<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
							FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
						<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
							FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
						</cfif>
						<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
							ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
						</cfif>
						ACTION_TYPE_ID = 46 AND
						OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_setup_money.money#">
						<cfif session.ep.isBranchAuthorization>
							AND	(FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"> OR TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
						</cfif>
						<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
							AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
						<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup")>
							AND PROJECT_ID IS NULL						
						</cfif>
				</cfquery>
				<cfquery name="GET_RATE_DIFF_DEKONT_2" datasource="#dsn2#"><!--- Borç değerleme --->
					SELECT
						ISNULL(SUM(ACTION_VALUE),0) ACTION_VALUE
					FROM
						CARI_ACTIONS
					WHERE
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
							TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
						<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
							TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
						<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
							TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
						</cfif>
						<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
							ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id# AND
						</cfif>
						ACTION_TYPE_ID = 45 AND
						OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_setup_money.money#">
						<cfif session.ep.isBranchAuthorization>
							AND	(FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"> OR TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
						</cfif>
						<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
							AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
						<cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup")>
							AND PROJECT_ID IS NULL						
						</cfif>
				</cfquery>
				<table class="medium_list" align="center" style="width:99%;">
					<cfoutput>	
						<thead>					
							<tr style="height:22px;">
								<th colspan="4"><cf_get_lang dictionary_id='58916.Manuel Kapama Sonucu Oluşan'> #get_setup_money.money# <cf_get_lang dictionary_id='57886.İşlem Toplamları ve Kur Farkı'></th>
							</tr>
						</thead>
						<cfif isDefined("attributes.is_doviz_group")>
							<tr>
								<td>#get_setup_money.money# <cf_get_lang dictionary_id='57673.Tutar'></td>
								<td nowrap style="text-align:right;">#Tlformat(evaluate('cari_toplam_tutar1_#get_setup_money.money#'))# #get_setup_money.money#</td>
								<td nowrap style="text-align:right;">#Tlformat(evaluate('cari_toplam_tutar2_#get_setup_money.money#'))# #get_setup_money.money#</td>
								<td>&nbsp;</td>
							</tr>
						</cfif>
						<tr>
							<td>#session_base_money# <cf_get_lang dictionary_id='57673.Tutar'></td>
							<td nowrap style="text-align:right;">#TLFormat(cari_toplam_tutar1)# #session_base_money#</td>
							<cfset last_total= cari_toplam_tutar1-cari_toplam_tutar2>
							<td nowrap style="text-align:right;">#TLFormat(cari_toplam_tutar2)# #session_base_money#</td>
							<td>&nbsp;</td>
							<cfset total_kur_farki = wrk_round(cari_toplam_tutar2 - cari_toplam_tutar1)>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58912.Alınan Kur Farkı Faturaları Toplamı'></td>
							<td>&nbsp;</td>
							<td style="text-align:right;">
								#TLFormat(get_rate_diff_inv_1.action_value)#
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58913.Verilen Kur Farkı Faturaları Toplamı'></td>
							<td>&nbsp;</td>
							<td style="text-align:right;">
								#TLFormat(get_rate_diff_inv_2.action_value)#
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58914.Alacak Kur Değerleme Dekontları Toplamı'></td>
							<td>&nbsp;</td>
							<td style="text-align:right;">
								#TLFormat(get_rate_diff_dekont_1.action_value)#
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58915.Borç Kur Değerleme Dekontları Toplamı'></td>
							<td>&nbsp;</td>
							<td style="text-align:right;">
								#TLFormat(get_rate_diff_dekont_2.action_value)#
							</td>
							<td>&nbsp;</td>
						</tr>
						<cfset total_diff_1 = get_rate_diff_inv_1.action_value + get_rate_diff_dekont_1.action_value><!--- alınan kur farkı toplam --->
						<cfset total_diff_2 = get_rate_diff_inv_2.action_value + get_rate_diff_dekont_2.action_value><!--- verilen kur farkı toplam --->
						<cfif total_kur_farki gt 0>
							<cfset new_diff = total_kur_farki - (total_diff_2-total_diff_1)>
						<cfelseif total_kur_farki lte 0>
							<cfset new_diff = total_kur_farki + (total_diff_1 - total_diff_2)>
						<cfelse>
							<cfset new_diff = 0>
						</cfif>
						<cfif new_diff gt 0>
							<tr>
								<td><cf_get_lang dictionary_id='57888.Kesilmesi Gereken Kur Farkı Fatura Tutarı'></td>
								<td>&nbsp;</td>
								<td style="text-align:right;">#TLFormat(new_diff)#</td>
								<cfoutput><cfset function_info1 = "add_bill_sale_#attributes.row_id#"></cfoutput>
								<cfsavecontent variable="button_name"><cf_get_lang dictionary_id='57282.Kur Farkı Faturası Kes'></cfsavecontent>
								<td><cfif new_diff neq 0><cf_workcube_buttons is_upd='0' insert_info='#button_name#' is_cancel='0' add_function='#function_info1#()'><cfelse>&nbsp;</cfif></td>
							</tr>
						<cfelseif new_diff lt 0>
							<tr>
								<td><cf_get_lang dictionary_id='57889.Alınması Gereken Kur Farkı Fatura Tutarı'></td>
								<td>&nbsp;</td>
								<td style="text-align:right;">#TLFormat(new_diff)#</td>
								<cfoutput><cfset function_info2 = "add_bill_purch_#attributes.row_id#"></cfoutput>
								<cfsavecontent variable="button_name"><cf_get_lang dictionary_id='57282.Kur Farkı Faturası Kes'></cfsavecontent>
								<td><cfif new_diff neq 0><cf_workcube_buttons is_upd='0' insert_info='#button_name#' is_cancel='0' add_function='#function_info2#()'><cfelse>&nbsp;</cfif></td>
							</tr>
						</cfif>
					</cfoutput>
				</table>
			</cfif>
		</cfif>
	</cfloop>
	<cfif not isdefined("attributes.is_ajax_popup") or (isdefined("attributes.is_ajax_popup") and isdefined("attributes.detail_type") and (len(attributes.detail_type) and attributes.detail_type eq 2) or not isdefined("attributes.detail_type") or (isdefined("attributes.detail_type") and not len(attributes.detail_type)))>
		<cfif not isdefined("is_from_collacted") and not isdefined("attributes.is_ajax_popup")>
			<cfsavecontent variable="head_">
				<cfif not (isdefined("is_pdf") or isDefined("is_excel") or isdefined("attributes.is_ajax_popup"))><a href="javascript:gizle_goster(open_invoice_1);">&raquo;</a></cfif><cfif isdefined ('attributes.company') and len(attributes.company)><cfoutput><strong>#attributes.company# #get_periods.period_year#</strong></cfoutput></cfif> <strong><cf_get_lang dictionary_id='57890.Açık İşlemler'></strong>
			</cfsavecontent>
			<cf_medium_list_search title='#head_#'>
				<cf_medium_list_search_area>
                	<div class="row">
                    	<div class="col col-12 form-inline">
                        	<div class="form-group">
                            	<label><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                                <div class="input-group x-11">
                                	<input type="text" name="ic_action_date_1" id="ic_action_date_1" value="<cfif isDefined('attributes.action_date_1') and isdate(attributes.action_date_1)><cfoutput>#dateformat(attributes.action_date_1,dateformat_style)#</cfoutput><cfelseif isDefined('attributes.date_control') and attributes.date_control eq 1 and isdefined('date1')><cfoutput>#date1#</cfoutput></cfif>" validate="#validate_style#" style="width:65px;">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ic_action_date_1"></span>
								</div>
                                <div class="input-group x-11">
                                	<input type="text" name="ic_action_date_2" id="ic_action_date_2" value="<cfif isDefined('attributes.action_date_2') and isdate(attributes.action_date_2)><cfoutput>#dateformat(attributes.action_date_2,dateformat_style)#</cfoutput><cfelseif isDefined('attributes.date_control') and attributes.date_control eq 1 and isdefined('date2')><cfoutput>#date2#</cfoutput></cfif>" validate="#validate_style#" style="width:65px;">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ic_action_date_2"></span>
                                </div>
                           	</div>
                           	<div class="form-group">
                            	<label><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
                                <div class="input-group x-11">
                                	<input type="text" name="ic_due_date_1" id="ic_due_date_1" value="<cfif isDefined('attributes.due_date_1') and isdate(attributes.due_date_1)><cfoutput>#dateformat(attributes.due_date_1,dateformat_style)#</cfoutput></cfif>" validate="#validate_style#" style="width:65px;">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ic_due_date_1"></span>
                                </div>
                                <div class="input-group x-11">
                                    <input type="text" name="ic_due_date_2" id="ic_due_date_2" value="<cfif isDefined('attributes.due_date_2') and isdate(attributes.due_date_2)><cfoutput>#dateformat(attributes.due_date_2,dateformat_style)#</cfoutput></cfif>" validate="#validate_style#" style="width:65px;">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ic_due_date_2"></span>
                                </div>
                            </div>
							<div class="form-group">
                            	<label><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                                <div class="input-group">
                                	<select name="ic_other_money_2" id="ic_other_money_2" style="width:65px;">
                                    	<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_money">
                                            <option value="#money#" <cfif isdefined("attributes.other_money_2") and attributes.other_money_2 eq money>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                            	<label>
                                	<input type="checkbox" name="is_ic_duedate_group" id="is_ic_duedate_group" value="" <cfif isdefined("attributes.is_duedate_group") and attributes.is_duedate_group eq 1>checked</cfif>>
									<cf_get_lang dictionary_id='58828.Ay Bazında Grupla'>
                                </label>
                            </div>
                            <div class="form-group">
                            	<span class="btn green-haze" value="" onclick="gonder_ic_form();"><cf_get_lang dictionary_id='57565.Ara'></span>
                            </div>
                        </div>
                    </div>
				</cf_medium_list_search_area>
			</cf_medium_list_search>
		</cfif>
		<table class="medium_list" align="center" id="open_invoice_1" style="width:99%;">
			<thead>
				<tr>
					<th style="width:80px;"><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th style="width:75px;"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
					<th style="width:75px;"><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
					<th nowrap><cf_get_lang dictionary_id='57692.İşlem'></th>
					<th align="center" style="width:150px;"><cf_get_lang dictionary_id='29689.Islem Tarihi Farkı Gün'></th>
					<th align="center" style="width:150px;"><cf_get_lang dictionary_id='29690.Vade Tarihi Farkı Gün'></th>
					<th style="text-align:right;width:110px;"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th style="text-align:right;width:110px;"><cf_get_lang dictionary_id='57882.İşlem Tutarı'></th>
				</tr>
			</thead>
			<tbody>
			<cfset acik_fat_toplam = 0>
			<cfset acik_fat_toplam2 = 0>
			<cfset acik_fat_toplam_agirlik= 0>
			<cfset islem_acik_fat_toplam_agirlik= 0>
			<cfoutput query="get_money_rate">
				<cfset 'acik_fat_toplam_#money#' = 0>
				<cfset 'ara_acik_fat_toplam_#money#' = 0>
			</cfoutput>
			<cfset ara_acik_fat_toplam = 0>
			<cfset ara_acik_fat_toplam_agirlik = 0>
			<cfset islem_ara_acik_fat_toplam_agirlik = 0>
			<cfif get_all_actions.recordcount>
				<cfoutput query="get_all_actions">
					<cfif len(get_all_actions.due_date)>
						<cfset gun_farki = DateDiff("d",due_date,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
						<cfif isDefined("attributes.is_finish_day") and is_finish_day>
							<cfset gun_farki = DateDiff("d",due_date,createodbcdatetime('#year(attributes.date2)#-#month(attributes.date2)#-#day(attributes.date2)#'))>
						</cfif>
					<cfelse>
						<cfset gun_farki = DateDiff("d",action_date,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
					</cfif>
					<cfif len(action_date)>
						<cfset islem_gun_farki = DateDiff("d",action_date,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
						<cfif isDefined("attributes.is_finish_day") and is_finish_day>
							<cfset islem_gun_farki = DateDiff("d",action_date,createodbcdatetime('#year(attributes.date2)#-#month(attributes.date2)#-#day(attributes.date2)#'))>
						</cfif>
					<cfelse>
						<cfset islem_gun_farki = DateDiff("d",action_date,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
					</cfif>
					<cfif gun_farki eq 0><cfset gun_farki=1></cfif>
					<cfif islem_gun_farki eq 0><cfset islem_gun_farki=1></cfif>
					<tr>
						<cfif kontrol eq 1>
							<td>#paper_no#&nbsp;</td>
							<td>#DateFormat(action_date,dateformat_style)#</td>
							<td><cfif DUE_DATE lt date_add('d',1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))><font color="red">#DateFormat(due_date,dateformat_style)#</font><cfelse>#DateFormat(due_date,dateformat_style)#</cfif></td>
							<td><cfif isdefined('attributes.is_process_cat')>
									<cfif listfind(process_cat_id_list,process_cat,',')>
										#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
									<cfelse>
										#get_process_name(action_type_id)#
									</cfif>
								<cfelse>
									#get_process_name(action_type_id)#
								</cfif>&nbsp;
							</td>
							<td align="center">#islem_gun_farki#</td>
							<td align="center">#gun_farki#</td>
							<td style="text-align:right;">#TLFormat(cr_action_value-total_closed_amount)# #session_base_money#</td>
							<td style="text-align:right;">#TLFormat(other_cash_act_value-other_closed_amount)# #other_money#</td>
							<cfif len(to_consumer_id) or len(to_cmp_id) or len(to_employee_id)>
								<cfset acik_fat_toplam = acik_fat_toplam - (cr_action_value - total_closed_amount)>
								<cfset 'acik_fat_toplam_#other_money#' = evaluate('acik_fat_toplam_#other_money#') + (other_cash_act_value - other_closed_amount)>
								<cfset 'ara_acik_fat_toplam_#other_money#' = evaluate('ara_acik_fat_toplam_#other_money#') + (other_cash_act_value - other_closed_amount)>
							<cfelse>
								<cfset acik_fat_toplam = acik_fat_toplam + cr_action_value - total_closed_amount>
								<cfset 'acik_fat_toplam_#other_money#' = evaluate('acik_fat_toplam_#other_money#') + other_cash_act_value - other_closed_amount>
								<cfset 'ara_acik_fat_toplam_#other_money#' = evaluate('ara_acik_fat_toplam_#other_money#') + other_cash_act_value - other_closed_amount>
							</cfif>
							<cfset ara_acik_fat_toplam_agirlik = ara_acik_fat_toplam_agirlik + ((cr_action_value-total_closed_amount)*gun_farki)>
							<cfset islem_ara_acik_fat_toplam_agirlik = islem_ara_acik_fat_toplam_agirlik + ((cr_action_value-total_closed_amount)*islem_gun_farki)>
							
							<cfset ara_acik_fat_toplam = ara_acik_fat_toplam + cr_action_value - total_closed_amount>
							<cfset acik_fat_toplam2 = acik_fat_toplam2 + cr_action_value - total_closed_amount>
							
							<cfset acik_fat_toplam_agirlik = acik_fat_toplam_agirlik + ((cr_action_value-total_closed_amount)*gun_farki)>
							<cfset islem_acik_fat_toplam_agirlik = islem_acik_fat_toplam_agirlik + ((cr_action_value-total_closed_amount)*islem_gun_farki)>
						<cfelse>
							<td>#paper_no#&nbsp;</td>
							<td>#DateFormat(action_date,dateformat_style)#</td>
							<td><cfif due_date lt date_add('d',1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))><font color="red">#DateFormat(DUE_DATE,dateformat_style)#</font><cfelse>#DateFormat(DUE_DATE,dateformat_style)#</cfif></td>
							<td>
							<cfif isdefined('attributes.is_process_cat')>
								<cfif listfind(process_cat_id_list,process_cat,',')>
									#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
								<cfelse>
									#get_process_name(action_type_id)#
								</cfif>
							<cfelse>
								#get_process_name(action_type_id)#
							</cfif>&nbsp;
							</td>
							<td align="center">#islem_gun_farki#</td>
							<td align="center">#gun_farki#</td>
							<td style="text-align:right;">#TLFormat(cr_action_value)# #session_base_money#</td>
							<td style="text-align:right;">#TLFormat(other_cash_act_value)# #other_money#</td>
							<cfif len(to_consumer_id) or len(to_cmp_id) or len(to_employee_id)>
								<cfset acik_fat_toplam = acik_fat_toplam - cr_action_value>
								<cfset 'acik_fat_toplam_#other_money#' = evaluate('acik_fat_toplam_#other_money#')  +  other_cash_act_value>
								<cfset 'ara_acik_fat_toplam_#other_money#' = evaluate('ara_acik_fat_toplam_#other_money#')  -  other_cash_act_value>
							<cfelse>
								<cfset acik_fat_toplam = acik_fat_toplam + cr_action_value>
								<cfset 'acik_fat_toplam_#other_money#' = evaluate('acik_fat_toplam_#other_money#') + other_cash_act_value>
								<cfset 'ara_acik_fat_toplam_#other_money#' = evaluate('ara_acik_fat_toplam_#other_money#') + other_cash_act_value>
							</cfif>
							<cfset acik_fat_toplam2 = acik_fat_toplam2 + cr_action_value>
							<cfset acik_fat_toplam_agirlik = acik_fat_toplam_agirlik + (cr_action_value*gun_farki)>
							<cfset islem_acik_fat_toplam_agirlik = islem_acik_fat_toplam_agirlik + (cr_action_value*islem_gun_farki)>
							
							<cfset ara_acik_fat_toplam = ara_acik_fat_toplam + cr_action_value>
							<cfset ara_acik_fat_toplam_agirlik = ara_acik_fat_toplam_agirlik + ((cr_action_value)*gun_farki)>
							<cfset islem_ara_acik_fat_toplam_agirlik = islem_ara_acik_fat_toplam_agirlik + ((cr_action_value)*islem_gun_farki)>
						</cfif>
					</tr>
					<cfif isdefined("attributes.is_duedate_group") and attributes.is_duedate_group eq 1 and ((len(get_all_actions.DUE_DATE[currentrow+1]) and month(get_all_actions.DUE_DATE) neq month(get_all_actions.DUE_DATE[currentrow+1])) or not len(get_all_actions.DUE_DATE[currentrow+1]))>
						<tr>
							<td class="txtboldblue" colspan="2" align="center"><cf_get_lang dictionary_id='57492.Toplam'></td>
							<td class="txtboldblue">
								<cfif ara_acik_fat_toplam neq 0><!--- acik_fat_toplam2 neq 0 division by zero hatasi alindigindan bu sekilde duzelttim sorun olursa bildirin fbs 20120214 --->
									<cfset due_day_ara = wrk_round((ara_acik_fat_toplam_agirlik/ara_acik_fat_toplam),2)>
									<cfset action_day_ara = wrk_round((islem_ara_acik_fat_toplam_agirlik/ara_acik_fat_toplam),2)>
									#dateformat(date_add('d',(-1*due_day_ara),now()),dateformat_style)#
								<cfelse>&nbsp;
									<cfset due_day_ara = 0>
									<cfset action_day_ara = 0>
								</cfif>
							</td>
							<td>&nbsp;</td>
							<td align="center" class="txtboldblue">
								#tlformat(action_day_ara,0)#
							</td>
							<td align="center" class="txtboldblue">
								#tlformat(due_day_ara,0)#
							</td>
							<td class="txtboldblue" style="text-align:right;">#tlformat(ara_acik_fat_toplam)#  #session_base_money#</td>
							<td nowrap class="txtboldblue" style="text-align:right;">
								<cfloop query="get_money_rate">
									<cfif evaluate('ara_acik_fat_toplam_#get_money_rate.money#') neq 0>
										#Tlformat(-1*evaluate('ara_acik_fat_toplam_#get_money_rate.money#'))# #get_money_rate.money#<br/>
									</cfif>
								</cfloop>
							</td>
							<cfset ara_acik_fat_toplam = 0>
							<cfset ara_acik_fat_toplam_agirlik = 0>
							<cfset islem_ara_acik_fat_toplam_agirlik = 0>
							<cfloop query="get_money_rate">
								<cfset 'ara_acik_fat_toplam_#get_money_rate.money#' = 0>
							</cfloop>
						</tr>
					</cfif>
				</cfoutput>
				<tr>
					<cfset acik_fat_toplam_agirlik = wrk_round(acik_fat_toplam_agirlik,2)>
					<cfset islem_acik_fat_toplam_agirlik = wrk_round(islem_acik_fat_toplam_agirlik,2)>
					<cfset acik_fat_toplam2 = wrk_round(acik_fat_toplam2,2)>
					<td colspan="4" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td align="center" class="txtbold" style="width:80px;"><cfoutput><cfif acik_fat_toplam2 neq 0><cfset action_day = wrk_round((islem_acik_fat_toplam_agirlik/acik_fat_toplam2),2)>#TLFormat(islem_acik_fat_toplam_agirlik/acik_fat_toplam2)# (#dateformat(date_add('d',(-1*action_day),now()),dateformat_style)#)<cfelse>&nbsp;</cfif></cfoutput></td>
					<td align="center" class="txtbold" style="width:80px;"><cfoutput><cfif acik_fat_toplam2 neq 0><cfset due_day = wrk_round((acik_fat_toplam_agirlik/acik_fat_toplam2),2)>#TLFormat(acik_fat_toplam_agirlik/acik_fat_toplam2)# (#dateformat(date_add('d',(-1*due_day),now()),dateformat_style)#)<cfelse>&nbsp;</cfif></cfoutput></td>
					<td class="txtbold" style="text-align:right;width:110px;"><cfif acik_fat_toplam2 lt 0><cfset acik_fat_toplam2 = -1*acik_fat_toplam2></cfif><cfoutput>#TLFormat(acik_fat_toplam2)# #session_base_money#</cfoutput></td>
					<td nowrap class="txtbold" style="text-align:right;">
						<cfoutput query="get_money_rate">
							<cfif evaluate('acik_fat_toplam_#money#') neq 0>
								<cfif evaluate('acik_fat_toplam_#money#') lt 0>#Tlformat(-1*evaluate('acik_fat_toplam_#money#'))#<cfelse>#Tlformat(evaluate('acik_fat_toplam_#money#'))#</cfif> #money#<br/>
							</cfif>
						</cfoutput>
					</td>
				</tr>
				<cfif not isdefined("attributes.is_view")>
					<cfsavecontent variable="button_name"><cf_get_lang dictionary_id ='58787.Belge Kapama'></cfsavecontent>
					<cfoutput><cfset function_info = "add_close_#attributes.row_id#"></cfoutput>
					<tr>
						<td colspan="8"><cfif not (isDefined("session.pp") or isDefined("session.ww")) and not (isdefined("is_pdf") or isDefined("is_excel"))><cf_workcube_buttons is_upd='0' insert_info='#button_name#' is_cancel='0' add_function='#function_info#()' type_format="1"><cfelse>&nbsp;</cfif></td>
					</tr>
				</cfif>
			<cfelse>
				<tr>
					<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</cfif>
			</tbody>
		</table>
	</cfif>
</cfif>
<div style="display:none"><cf_report_list></cf_report_list></div> 
<script type="text/javascript">
	function gonder_ic_form()
	{
		if( document.list_ekstre != undefined && document.list_ekstre.due_date_2.value != undefined)
		{
			document.list_ekstre.due_date_2.value = document.getElementById('ic_due_date_2').value;
			document.list_ekstre.due_date_1.value = document.getElementById('ic_due_date_1').value;
			document.list_ekstre.other_money_2.value = document.getElementById('ic_other_money_2').value;
			document.list_ekstre.action_date_1.value = document.getElementById('ic_action_date_1').value;
			document.list_ekstre.action_date_2.value = document.getElementById('ic_action_date_2').value;
			document.list_ekstre.date_control.value = '0';
			if(document.getElementById('is_ic_duedate_group').checked == true)
				document.all.is_duedate_group.value = 1;
			else
				document.all.is_duedate_group.value = 0;
			document.list_ekstre.submit();
		}
		else
		{
			document.cari.due_date_2.value = document.getElementById('ic_due_date_2').value;
			document.cari.due_date_1.value = document.getElementById('ic_due_date_1').value;
			document.cari.other_money_2.value = document.getElementById('ic_other_money_2').value;
			document.cari.action_date_1.value = document.getElementById('ic_action_date_1').value;
			document.cari.action_date_2.value = document.getElementById('ic_action_date_2').value;
			if(document.getElementById('is_ic_duedate_group').checked == true)
				document.cari.is_duedate_group.value = 1;
			else
				document.cari.is_duedate_group.value = 0;
			if(typeof(document.cari.date_control) == 'object')document.cari.date_control.value = '0';
			document.cari.submit();
		}
	}
	function add_close_<cfoutput>#attributes.row_id#</cfoutput>()
	{
		windowopen('','wide','add_inv<cfoutput>#attributes.row_id#</cfoutput>');
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.action='<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&money_type=#session_base_money#<cfif isDefined("attributes.company_id")>&member_id=#attributes.company_id#</cfif><cfif isDefined("attributes.consumer_id")>&consumer_id=#attributes.consumer_id#</cfif><cfif isDefined("attributes.employee_id")>&employee_id=#attributes.employee_id#</cfif></cfoutput>';
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.target='add_inv<cfoutput>#attributes.row_id#</cfoutput>';
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.submit();
	}	
	function add_bill_sale_<cfoutput>#attributes.row_id#</cfoutput>()
	{
		windowopen('','wide','add_inv<cfoutput>#attributes.row_id#</cfoutput>');
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.action='<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.form_add_bill';
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.target='add_inv<cfoutput>#attributes.row_id#</cfoutput>';
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.submit();
	}
	function add_bill_purch_<cfoutput>#attributes.row_id#</cfoutput>()
	{
		windowopen('','wide','add_inv<cfoutput>#attributes.row_id#</cfoutput>');
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.action='<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.form_add_bill_purchase';
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.target='add_inv<cfoutput>#attributes.row_id#</cfoutput>';
		dsp_make_age<cfoutput>#attributes.row_id#</cfoutput>.submit();
	}	
</script>
