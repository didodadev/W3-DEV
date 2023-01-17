<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_PAYROLL_TYPE" datasource="#dsn2#">
	SELECT
		PAYROLL_TYPE,
		PROCESS_CAT,
        PAYROLL_NO
	FROM
		VOUCHER_PAYROLL
	WHERE
		ACTION_ID=#attributes.ID#
</cfquery>
<cfset PAYROLL_TYPE=get_payroll_type.PAYROLL_TYPE>
<cfquery name="GET_PAYROLL_CHES" datasource="#dsn2#">
	SELECT
		VOUCHER_ID,
		STATUS
	FROM
		VOUCHER_HISTORY
	WHERE
		PAYROLL_ID=#attributes.ID#
</cfquery>
<cfset payroll_voucher_list=valuelist(GET_PAYROLL_CHES.VOUCHER_ID)>
<cfif PAYROLL_TYPE neq 101 and PAYROLL_TYPE neq 109>
	<cfloop query="GET_PAYROLL_CHES">
		<cfquery name="control_cheque" datasource="#dsn2#">
			SELECT
				VOUCHER_ID
			FROM
				VOUCHER_HISTORY
			WHERE
				VOUCHER_ID=#GET_PAYROLL_CHES.VOUCHER_ID# AND
				PAYROLL_ID IS NULL
		</cfquery>
		<cfif control_cheque.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang no ='266.Bu Bordroya Ait Senetlerden Bu Senet İşlem Görmüş.Bordroyu Silemezsiniz'>.<cf_get_lang_main no ='596.Senet'>ID :<cfoutput>#control_cheque.VOUCHER_ID#</cfoutput>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfloop>
</cfif>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
	<cfscript>
		muhasebe_sil(action_id:attributes.ID,action_table='VOUCHER_PAYROLL',process_type:PAYROLL_TYPE);/*bordro bazındaki muhasebe hareketi siliniyor*/
		butce_sil(action_id:attributes.ID,action_table='PAYROLL',process_type:PAYROLL_TYPE);/*bordro bazındaki muhasebe hareketi siliniyor*/
		cari_sil(action_id:attributes.ID,action_table:'VOUCHER_PAYROLL',process_type:PAYROLL_TYPE);/*bordro bazındaki cari hareketi siliniyor*/
		for(tt=1; tt lte listlen(payroll_voucher_list); tt=tt+1)
			cari_sil(action_id:listgetat(payroll_voucher_list,tt,','),action_table:'VOUCHER',process_type:PAYROLL_TYPE,payroll_id :attributes.id);/*varsa bordrodaki ceklerin cari hareketleri siliniyor*/
	</cfscript>
		<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE PAYROLL_ID = #attributes.ID#
		</cfquery>
		<!---bank action'a senet ile payroll_id kaydi atiliyor mu?--->
		<cfquery name="DEL_BANK_ACTIONS" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE PAYROLL_ID = #attributes.ID#
		</cfquery>
		<!--- bankaya ait masraf kaydi silinir 20130125 --->
		<cfquery name="DEL_BANK_ACTION" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE VOUCHER_PAYROLL_ID = #attributes.ID#
		</cfquery>
		<cfquery name="DEL_HISTORY" datasource="#dsn2#">
			DELETE FROM VOUCHER_HISTORY WHERE PAYROLL_ID=#attributes.ID#
		</cfquery>	
		<cfswitch expression="#PAYROLL_TYPE#">
			<cfcase value="97"><!--- Senet Giriş Bord --->
				<cfquery name="DEL_VOUCHER_MONEY" datasource="#dsn2#">
					DELETE FROM VOUCHER_MONEY WHERE ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_PAYROLL_ID=#attributes.ID#)
				</cfquery>
				<cfquery name="DEL_VOUCHER" datasource="#dsn2#">
					DELETE FROM VOUCHER WHERE VOUCHER_PAYROLL_ID=#attributes.ID#
				</cfquery>
				<cfoutput query="get_payroll_ches">
					<!--- Senetin kefil satırları siliniyor --->
					<cfquery name="del_voucher_guarantors" datasource="#dsn2#">
						DELETE FROM VOUCHER_GUARANTORS WHERE VOUCHER_ID = #VOUCHER_ID#	 
					</cfquery>
				</cfoutput>
			</cfcase>
			<cfcase value="98,99,100,101,104,108,109,136,137">
				<cfif PAYROLL_TYPE eq 104>
					<cfquery name="del_closed" datasource="#dsn2#">
						DELETE FROM VOUCHER_CLOSED WHERE PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
					</cfquery>
				</cfif>
				<cfoutput query="get_payroll_ches">
					<cfquery name="GET_PURSED_HIST" datasource="#dsn2#">
						SELECT MAX(HISTORY_ID) AS H_ID FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#VOUCHER_ID#
					</cfquery>
					<cfquery name="GET_ALL_HIST" datasource="#dsn2#">
						SELECT VOUCHER_ID FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#VOUCHER_ID#
					</cfquery>
					<cfif get_all_hist.recordcount eq 0 and PAYROLL_TYPE eq 98><!--- senet çıkıştn eklenen senetlerin silinmesi için.. --->
						<cfquery name="DEL_VOUCHER_MONEY" datasource="#dsn2#">
							DELETE FROM VOUCHER_MONEY WHERE ACTION_ID=#VOUCHER_ID#
						</cfquery>
						<cfquery name="DEL_VOUCHER" datasource="#dsn2#">
							DELETE FROM VOUCHER WHERE VOUCHER_ID=#VOUCHER_ID#
						</cfquery>
					<cfelse>
						<cfif len(GET_PURSED_HIST.H_ID)>
							<cfquery name="GET_PURSE_PAYROLL" datasource="#dsn2#">
								SELECT	
									PAYROLL_ID,
									STATUS
								FROM
									VOUCHER_HISTORY
								WHERE
									HISTORY_ID=#GET_PURSED_HIST.H_ID#
							</cfquery>
							<cfif payroll_type eq 137>
								<cfquery name="get_cash_id" datasource="#dsn2#">
									SELECT PAYROLL_CASH_ID FROM VOUCHER_PAYROLL WHERE ACTION_ID = #GET_PURSE_PAYROLL.PAYROLL_ID#
								</cfquery>
							</cfif>
							<cfquery name="UPD_PAYROLL_VOUCHERS" datasource="#dsn2#">
								UPDATE
									VOUCHER
								SET
									VOUCHER_STATUS_ID=#GET_PURSE_PAYROLL.STATUS#
									<cfif payroll_type eq 137>
										,CASH_ID = #get_cash_id.payroll_cash_id#
									</cfif>
								WHERE
									VOUCHER_ID=#VOUCHER_ID#	
							</cfquery>
							<!--- Senetin kefil satırları siliniyor --->
							<cfquery name="del_voucher_guarantors" datasource="#dsn2#">
								DELETE FROM VOUCHER_GUARANTORS WHERE VOUCHER_ID = #VOUCHER_ID#	 
							</cfquery>
						</cfif>
						<cfif STATUS eq 6><!--- ödenmedi statusu--->
							<cfquery name="get_payroll" datasource="#dsn2#">
								SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-2'
							</cfquery>
							<cfif not get_payroll.recordcount>
							<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#dsn2#">
								INSERT INTO
									VOUCHER_PAYROLL
									(
										PAYROLL_NO,
										NUMBER_OF_VOUCHER,
										CURRENCY_ID,
										PAYROLL_TYPE,
										RECORD_EMP,
										RECORD_IP,
										RECORD_DATE
									)
									VALUES(
										'-2',
										1,
										'#session.ep.money#',
										107,
										#session.ep.userid#,
										'#CGI.REMOTE_ADDR#',
										#NOW()#
									)
							</cfquery>
							<cfquery name="get_payroll" datasource="#dsn2#">
								SELECT MAX(ACTION_ID) AS ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_NO = '-2'
							</cfquery>
							</cfif>
							<cfquery name="UPD_PAYROLL_CHEQUES" datasource="#dsn2#">
								UPDATE
									VOUCHER
								SET
									VOUCHER_STATUS_ID=6,
									VOUCHER_PAYROLL_ID=#get_payroll.ACTION_ID#
								WHERE
									VOUCHER_ID=#VOUCHER_ID#	
							</cfquery>
						</cfif>
					</cfif>
				</cfoutput>
			</cfcase>
		</cfswitch>
		<cfquery name="DEL_PAYROLL_MONEY" datasource="#dsn2#">
			DELETE FROM VOUCHER_PAYROLL_MONEY WHERE ACTION_ID=#attributes.ID#
		</cfquery>
		<cfquery name="DEL_PAYROLL" datasource="#dsn2#">
			DELETE FROM VOUCHER_PAYROLL WHERE ACTION_ID=#attributes.ID#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.id#" action_name="#attributes.head#" paper_no="#GET_PAYROLL_TYPE.PAYROLL_NO#"  process_type="#payroll_type#" process_stage="#get_payroll_type.process_cat#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfscript>structdelete(session, "voucher");</cfscript>
<cfif isdefined("attributes.from_invoice")>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script> 
<cfelse>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#nextEvent#</cfoutput>";
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
