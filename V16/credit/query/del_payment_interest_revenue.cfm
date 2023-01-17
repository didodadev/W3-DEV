<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_account_card" datasource="#dsn2#">
			SELECT
				CARD_ID,
                ACTION_DATE
			FROM
				ACCOUNT_CARD
			WHERE
				ACTION_ID = #ATTRIBUTES.row_id#
				AND ACTION_TYPE IN (2931)
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
            butce_sil(action_id:attributes.row_id, process_type:2931);
            muhasebe_sil(action_id:attributes.row_id, process_type:2931);
		</cfscript>
		<cfif len(attributes.BANK_ACTION_ID)>
		<cfquery name="DEL_BANK_ACTION_MONEY" datasource="#DSN2#">
			DELETE FROM BANK_ACTION_MONEY WHERE ACTION_ID = #ATTRIBUTES.BANK_ACTION_ID#
		</cfquery>		
		<cfquery name="DEL_BANK_ACTIONS" datasource="#DSN2#"> <!--- banka hareketi silinir --->
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID = (#ATTRIBUTES.BANK_ACTION_ID#)
		</cfquery>
		</cfif>
        <cfquery name="UPD_INTEREST_YIELD_ROW" datasource="#dsn2#"> <!--- TAHSİL EDİLDİĞİNE DAİR SATIRDA GERİ ALIYORUZ . --->
            UPDATE #dsn3_alias#.STOCKBONDS_YIELD_PLAN_ROWS 
                SET IS_PAYMENT = 0,
                    PAPER_NO = NULL,
                    ACTION_DATE_ROW = NULL,
                    YIELD_TO_BANK = 0,
					STOPAJ_ID = NULL,
                    STOPAJ_RATE = 0,
                    STOPAJ_TOTAL = 0,
                    NET_TOTAL = 0,
					BANK_ACTION_ID = NULL,
					COMMISION_RATE = NULL,
					COMMISION_AMOUNT = NULL,
					COMMISION_EXP_CENTER_ID = NULL,
					COMMISION_EXP_ITEM_ID = NULL
            WHERE YIELD_PLAN_ROWS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
        </cfquery>

	</cftransaction>
</cflock>
<script type="text/javascript">
		window.close();
		window.opener.location.reload();
</script>
