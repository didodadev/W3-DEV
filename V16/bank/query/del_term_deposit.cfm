<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_account_card" datasource="#dsn2#">
			SELECT
				CARD_ID,
                ACTION_DATE
			FROM
				ACCOUNT_CARD
			WHERE
				ACTION_ID = #listfirst(ATTRIBUTES.IDS,",")#
				AND ACTION_TYPE IN (2311)
		</cfquery>
        <cfif get_account_card.recordcount and session.ep.our_company_info.is_edefter eq 1>
            <cfstoredproc procedure="GET_NETBOOK" datasource="#dsn2#">
            	<cfprocparam cfsqltype="cf_sql_timestamp" value="#get_account_card.ACTION_DATE#">
                <cfprocparam cfsqltype="cf_sql_timestamp" value="#get_account_card.ACTION_DATE#">
                <cfprocparam cfsqltype="cf_sql_varchar" value="">
                <cfprocresult name="getNetbook">
            </cfstoredproc>
            <cfif getNetbook.recordcount>
                <script language="javascript">
                    alert('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
                    window.close();
                </script>
                <cfabort>
            </cfif>
		</cfif>
		<cfscript>
			butce_sil(action_id:listfirst(ATTRIBUTES.IDS,','),process_type:2311);
		</cfscript>
		<cfquery name="get_process" datasource="#dsn2#">
			SELECT PAPER_NO,PROCESS_CAT FROM BANK_ACTIONS WHERE ACTION_ID=#listfirst(ATTRIBUTES.IDS,",")#
		</cfquery>
		<cfif get_account_card.recordcount>
			<cfquery name="DEL_ACCOUNT_CARD" datasource="#DSN2#">
				DELETE FROM ACCOUNT_CARD WHERE CARD_ID IN (#VALUELIST(get_account_card.CARD_ID)#)
			</cfquery>
			<cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#DSN2#">
				DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID IN (#VALUELIST(get_account_card.CARD_ID)#)
			</cfquery>
			<cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#DSN2#">
				DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID IN (#VALUELIST(get_account_card.CARD_ID)#)
			</cfquery>
		</cfif>
		<cfquery name="DEL_BANK_ACTION_MONEY" datasource="#DSN2#">
			DELETE FROM BANK_ACTION_MONEY WHERE ACTION_ID = #listfirst(ATTRIBUTES.IDS,",")#
		</cfquery>		
		<cfquery name="DEL_BANK_ACTIONS" datasource="#DSN2#"> <!--- banka hareketi silinir --->
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID IN (#ATTRIBUTES.IDS#)
		</cfquery>
		<cfquery name="GET_INTEREST_YIELD_PLAN" datasource="#dsn2#">
			SELECT YIELD_ID FROM INTEREST_YIELD_PLAN WHERE BANK_ACTION_ID = #listfirst(attributes.IDS,",")#
		</cfquery>
		<cfquery name="GET_INTEREST_YIELD_PLAN_BDGT" datasource="#dsn2#">
			SELECT BUDGET_PLAN_ID FROM INTEREST_YIELD_PLAN WHERE BANK_ACTION_ID = #listfirst(attributes.IDS,",")# AND BUDGET_PLAN_ID IS NOT NULL
		</cfquery>
		<cfif GET_INTEREST_YIELD_PLAN_BDGT.recordCount gt 0>
			<cfquery name="DEL_BUDGET_ACTION_MONEY" datasource="#dsn2#"> 
				DELETE FROM #dsn_alias#.BUDGET_PLAN_MONEY WHERE ACTION_ID = #GET_INTEREST_YIELD_PLAN_BDGT.BUDGET_PLAN_ID#
			</cfquery>
			<cfquery name="DEL_BUDGET_PLAN" datasource="#dsn2#"> <!--- planlama fişi belge silinir --->
				DELETE FROM #dsn_alias#.BUDGET_PLAN WHERE BUDGET_PLAN_ID = #GET_INTEREST_YIELD_PLAN_BDGT.BUDGET_PLAN_ID#
			</cfquery>
			<cfquery name="DEL_BUDGET_PLAN_ROW" datasource="#dsn2#"> <!--- planlama fişi satır silinir --->
				DELETE FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID = #GET_INTEREST_YIELD_PLAN_BDGT.BUDGET_PLAN_ID#
			</cfquery>
		</cfif>
		<cfif GET_INTEREST_YIELD_PLAN.recordCount>
			<cfquery name="GET_INTEREST_ROWS" datasource="#dsn2#">
				SELECT YIELD_ROWS_ID FROM INTEREST_YIELD_PLAN_ROWS WHERE YIELD_ID = #GET_INTEREST_YIELD_PLAN.YIELD_ID#
			</cfquery>
			<cfquery name="GET_INTEREST_VALUATION_ROWS" datasource="#dsn2#">
				SELECT YIELD_ROWS_ID FROM INTEREST_YIELD_VALUATION WHERE YIELD_ROWS_ID IN (#valueList(GET_INTEREST_ROWS.YIELD_ROWS_ID)#)
			</cfquery>
			<cfquery name="DEL_INTEREST_YIELD_PLAN" datasource="#dsn2#"> <!--- vadeli mevduat belge silinir--->
				DELETE FROM INTEREST_YIELD_PLAN WHERE YIELD_ID = #GET_INTEREST_YIELD_PLAN.YIELD_ID#
			</cfquery>
			<cfquery name="DEL_INTEREST_YIELD_PLAN_ROW" datasource="#dsn2#"> <!--- vadeli mevduat satırları silinir --->
				DELETE FROM INTEREST_YIELD_PLAN_ROWS WHERE YIELD_ID IN (#valuelist(GET_INTEREST_YIELD_PLAN.YIELD_ID)#)
			</cfquery>
			<cfif GET_INTEREST_VALUATION_ROWS.recordCount>
				<cfquery name="DEL_INTEREST_VALUATION" datasource="#dsn2#">
					DELETE FROM INTEREST_YIELD_VALUATION WHERE YIELD_ROWS_ID IN (#valueList(GET_INTEREST_VALUATION_ROWS.YIELD_ROWS_ID)#)
				</cfquery>
			</cfif>
		</cfif>
		<cf_add_log log_type="-1" action_id="#listfirst(ATTRIBUTES.IDS,",")#" action_name="#attributes.head#" process_type="#attributes.old_process_type#"  paper_no="#get_process.paper_no#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
		wrk_opener_reload();
		window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
	</cfif>
</script>
