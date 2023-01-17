<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_account_card" datasource="#dsn2#">
			SELECT
				CARD_ID,
                ACTION_DATE
			FROM
				ACCOUNT_CARD
			WHERE
				ACTION_ID = #ATTRIBUTES.BANK_ACTION_ID#
				AND ACTION_TYPE IN (2313)
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
		<cfquery name="get_process" datasource="#dsn2#">
			SELECT PAPER_NO,PROCESS_CAT FROM BANK_ACTIONS WHERE ACTION_ID=#ATTRIBUTES.BANK_ACTION_ID#
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
		<cfscript>
			butce_sil(action_id:attributes.bank_action_id, process_type:2313);
		</cfscript>
		<cfquery name="DEL_BANK_ACTION_MONEY" datasource="#DSN2#">
			DELETE FROM BANK_ACTION_MONEY WHERE ACTION_ID = #ATTRIBUTES.BANK_ACTION_ID#
		</cfquery>		
		<cfquery name="DEL_BANK_ACTIONS" datasource="#DSN2#"> <!--- banka hareketi silinir --->
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID IN (#ATTRIBUTES.BANK_ACTION_ID#)
		</cfquery>
		<cfquery name="DEL_BANK_ACTIONS" datasource="#DSN2#"> <!--- banka hareketi silinir --->
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID IN (#ATTRIBUTES.BANK_ACTION_ID+1#)
		</cfquery>
		<cfquery name="get_upd_interest_yield_row" datasource="#dsn2#">
			select TERM_BANK_TO_BANK from INTEREST_YIELD_PLAN_ROWS where BANK_ACTION_ID = #ATTRIBUTES.BANK_ACTION_ID#
		</cfquery>
		<cfif get_upd_interest_yield_row.TERM_BANK_TO_BANK eq 0>
			<cfquery name="DEL_BANK_ACTIONS" datasource="#DSN2#"> <!--- banka hareketi silinir --->
				DELETE FROM BANK_ACTIONS WHERE ACTION_ID IN (#ATTRIBUTES.BANK_ACTION_ID+2#)
			</cfquery>
			<cfquery name="DEL_BANK_ACTIONS" datasource="#DSN2#"> <!--- banka hareketi silinir --->
				DELETE FROM BANK_ACTIONS WHERE ACTION_ID IN (#ATTRIBUTES.BANK_ACTION_ID+3#)
			</cfquery>
		</cfif>
        <cfquery name="UPD_INTEREST_YIELD_ROW" datasource="#dsn2#"> <!--- TAHSİL EDİLDİĞİNE DAİR SATIRDA GERİ ALIYORUZ . --->
            UPDATE INTEREST_YIELD_PLAN_ROWS 
                SET IS_PAYMENT = 0, PAYMENT_PRINCIPAL = 0
            WHERE YIELD_ROWS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
        </cfquery>

	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.interest_revenue";
</script>
