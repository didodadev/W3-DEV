<cflock timeout="60">
	<cftransaction>
    	<cfif isdefined("attributes.new_dsn2")>
        	<cfset new_dsn2 = attributes.new_dsn2>
        <cfelse>
        	<cfset new_dsn2 = dsn2>
		</cfif>
        <!--- e-defter islem kontrolu FA --->
		<cfif session.ep.our_company_info.is_edefter eq 1>
        	<cfquery name="getCardControl" datasource="#new_dsn2#">
                SELECT ACTION_DATE FROM ACCOUNT_CARD WHERE CARD_ID IN (#attributes.CARD_ID#)
            </cfquery>
            <cfif getCardControl.recordcount>
            	<cfloop query="getCardControl">
                    <cfstoredproc procedure="GET_NETBOOK" datasource="#new_dsn2#">
                    	<cfprocparam cfsqltype="cf_sql_timestamp" value="#getCardControl.action_date#">
                        <cfprocparam cfsqltype="cf_sql_timestamp" value="#getCardControl.action_date#">
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
                 </cfloop>
            </cfif>
        </cfif>
        <!--- e-defter islem kontrolu FA --->
		<cfinclude template="../query/upd_del_card_process.cfm">

		<!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderiliyor İse Bu Blok Çalışır --->
		<cfset create_accounter_wex = createObject("component","WEX.accounter.components.WorkcubetoAccounter").init( sessions: session_base )>
		<cfset comp_info = create_accounter_wex.COMP_INFO()>
		<cfif isdefined("comp_info") and comp_info.IS_ACCOUNTER_INTEGRATED eq 1 and len( comp_info.ACCOUNTER_DOMAIN ) and len( comp_info.ACCOUNTER_KEY )>
			<cfset get_result = create_accounter_wex.WRK_TO_ACCOUNTER( card_id: attributes.card_id, event: 'del' )>
			<cfif get_result.STATUS >
				<script>
					alert("<cfoutput>#get_result.MESSAGE#</cfoutput>");
				</script>
			<cfelse>
				<script>
					alert("<cfoutput>#get_result.MESSAGE#</cfoutput>");
				</script>
			</cfif>
		</cfif>
		<!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderiliyor İse Bu Blok Çalışır --->

		<cfquery name="del_card" datasource="#new_dsn2#">
			DELETE FROM ACCOUNT_CARD WHERE CARD_ID IN(#attributes.CARD_ID#)
		</cfquery>
		<cfquery name="DEL_ACCOUNT_CARD" datasource="#new_dsn2#">
			DELETE FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID IN(#attributes.CARD_ID#)
		</cfquery>
		<cfquery name="del_card" datasource="#new_dsn2#">
			DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID IN(#attributes.CARD_ID#)
		</cfquery>
		<cfquery name="del_card" datasource="#new_dsn2#">
			DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID IN(#attributes.CARD_ID#)
		</cfquery>
		<cfset action_name_ = ''>
		<cfset paper_no=''>
		<cfif len(get_card.paper_no)>
			<cfset action_name_ = get_card.paper_no>
			<cfset paper_no=get_card.paper_no>
		<cfelse>
			<cfset action_name_ = 'YEVMİYE NO : ' & get_card.bill_no>
		</cfif>
		<cfif isdefined("attributes.is_puantaj")>
			<cfquery name="cari_sil" datasource="#new_dsn2#">
				DELETE FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID = 161
					AND ACTION_ID = #attributes.puantaj_id#
					AND ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
			</cfquery>
			<script type="text/javascript">
				window.opener.window.close();
				window.close();
			</script>
		<cfelseif isdefined('attributes.from_controller') and len(attributes.from_controller)>
			<script type="text/javascript">
				window.location.href='<cfoutput>#request.self#?fuseaction=account.list_cards</cfoutput>'
			</script>
		<cfelse>
			<script type="text/javascript">
				wrk_opener_reload();
				window.close();
			</script>
		</cfif>
		<cf_add_log log_type="-1" action_id="#listfirst(attributes.CARD_ID)#" action_name="#action_name_#" process_type="#get_card.card_type#" paper_no="#get_card.paper_no#" data_source="#new_dsn2#">
	</cftransaction>
</cflock>
