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
				AND ACTION_TYPE=23
		</cfquery>
		<!--- e-defter islem kontrolu EsraNur --->
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
        <!--- e-defter islem kontrolu EsraNur --->
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
		<cfscript>
			butce_sil(action_id:listfirst(ATTRIBUTES.IDS,','),process_type:23);
		</cfscript>	
		<cfquery name="DEL_BANK_ACTION_MONEY" datasource="#DSN2#">
			DELETE FROM BANK_ACTION_MONEY WHERE ACTION_ID = #listfirst(ATTRIBUTES.IDS,",")#
		</cfquery>		
		<cfquery name="DEL_BANK_ACTIONS" datasource="#DSN2#">
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID IN (#ATTRIBUTES.IDS#)
		</cfquery>
		<cf_add_log log_type="-1" action_id="#listfirst(ATTRIBUTES.IDS,",")#" action_name="#attributes.head#" process_type="#attributes.old_process_type#"  paper_no="#get_process.paper_no#" data_source="#dsn2#">
		<!--- // eski kayıtlar silinir --->
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
