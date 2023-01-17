<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_PAYROLL_TYPE" datasource="#dsn2#">
	SELECT
		ACTION_ID,
		PAYROLL_TYPE,
		PROCESS_CAT,
        PAYROLL_NO
	FROM
		PAYROLL
	WHERE
		ACTION_ID=#attributes.ID#
</cfquery>
<cfset PAYROLL_TYPE=get_payroll_type.PAYROLL_TYPE>
<cfquery name="GET_PAYROLL_CHES" datasource="#dsn2#">
	SELECT
		CHEQUE_ID,
		STATUS
	FROM
		CHEQUE_HISTORY
	WHERE
		PAYROLL_ID=#attributes.ID#
</cfquery>
<cfset payroll_cheque_list=valuelist(GET_PAYROLL_CHES.CHEQUE_ID)>
<cfquery name="GET_EXPENSE_CONTROL" datasource="#dsn2#">
	SELECT ACTION_ID FROM ACCOUNT_CARD WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#"> AND ACTION_TYPE = 2501 
</cfquery>
<cfif PAYROLL_TYPE neq 94 and PAYROLL_TYPE neq 105>
	<cfloop query="GET_PAYROLL_CHES">
		<cfquery name="control_cheque" datasource="#dsn2#">
			SELECT
				CHEQUE_ID
			FROM
				CHEQUE_HISTORY CH
			WHERE
				CH.CHEQUE_ID=#GET_PAYROLL_CHES.CHEQUE_ID# AND
				CH.HISTORY_ID = (SELECT MAX(C_H.HISTORY_ID) FROM CHEQUE_HISTORY C_H WHERE CH.CHEQUE_ID =C_H.CHEQUE_ID) AND
				CH.PAYROLL_ID IS NULL
		</cfquery>
		<cfif control_cheque.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang no ='264.Bu Bordroya Ait Çeklerden Bu Çek İşlem Görmüş.Bordroyu Silemezsiniz'>.<cf_get_lang_main no='595.Çek'>ID:<cfoutput>#control_cheque.CHEQUE_ID#</cfoutput>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfloop>
</cfif>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
	<cfscript>
		muhasebe_sil(action_id:GET_PAYROLL_TYPE.ACTION_ID,action_table='PAYROLL',process_type:PAYROLL_TYPE,belge_no:GET_PAYROLL_TYPE.PAYROLL_NO);/*bordro bazındaki muhasebe hareketi siliniyor*/
		if( GET_EXPENSE_CONTROL.recordCount gt 0) { 
			muhasebe_sil(action_id:GET_PAYROLL_TYPE.ACTION_ID,action_table='PAYROLL',process_type:2501,belge_no:GET_PAYROLL_TYPE.PAYROLL_NO); /* banka masraf için fiş kesilmişse siliniyor */
		}
		butce_sil(action_id:GET_PAYROLL_TYPE.ACTION_ID,action_table='PAYROLL',process_type:PAYROLL_TYPE);/*bordro bazındaki muhasebe hareketi siliniyor*/
		cari_sil(action_id:GET_PAYROLL_TYPE.ACTION_ID,action_table:'PAYROLL',process_type:PAYROLL_TYPE);/*bordro bazındaki cari hareketi siliniyor*/
		for(tt=1; tt lte listlen(payroll_cheque_list); tt=tt+1)
			cari_sil(action_id:listgetat(payroll_cheque_list,tt,','),action_table:'CHEQUE',process_type:PAYROLL_TYPE,payroll_id :attributes.id);/*varsa bordrodaki ceklerin cari hareketleri siliniyor*/
	</cfscript>
	<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
		DELETE FROM CASH_ACTIONS WHERE PAYROLL_ID=#attributes.ID#
	</cfquery>
	<!--- bankaya ait masraf kaydi silinir 20130125 --->
	<cfquery name="DEL_BANK_ACTIONS" datasource="#dsn2#">
		DELETE FROM BANK_ACTIONS WHERE PAYROLL_ID=#attributes.ID#
	</cfquery>
	<cfquery name="DEL_HISTORY" datasource="#dsn2#">
		DELETE FROM CHEQUE_HISTORY WHERE PAYROLL_ID=#attributes.ID#
	</cfquery>
	<cfswitch expression="#PAYROLL_TYPE#">
		<cfcase value="90">
			<cfquery name="DEL_CHEQUE" datasource="#dsn2#">
				DELETE FROM CHEQUE_MONEY WHERE ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_PAYROLL_ID=#attributes.ID#)
			</cfquery>
			<cfquery name="DEL_CHEQUE" datasource="#dsn2#">
				DELETE FROM CHEQUE WHERE CHEQUE_PAYROLL_ID=#attributes.ID#
			</cfquery>
		</cfcase>
		<cfcase value="91,92,93,94,95,105,133,134,135">
			<!---çek tahsil durumundan çıkıp portföy durumuna geçecek--->
			<!---çekin en son portföyde olduğu bordro id si alınacak--->
			<cfoutput query="get_payroll_ches">
				<cfquery name="GET_PURSED_HIST" datasource="#dsn2#">
					SELECT MAX(HISTORY_ID) AS H_ID FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#CHEQUE_ID#
				</cfquery>
				<cfquery name="GET_ALL_HIST" datasource="#dsn2#">
					SELECT CHEQUE_ID FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#CHEQUE_ID#
				</cfquery>
				<cfif get_all_hist.recordcount eq 0 and PAYROLL_TYPE eq 91><!--- çek çıkıştn eklenen çeklerin silinmesi için.. --->
					<cfquery name="DEL_CHEQUE_MONEY" datasource="#dsn2#">
						DELETE FROM CHEQUE_MONEY WHERE ACTION_ID=#CHEQUE_ID#
					</cfquery>
					<cfquery name="DEL_CHEQUE" datasource="#dsn2#">
						DELETE FROM CHEQUE WHERE CHEQUE_ID=#CHEQUE_ID#
					</cfquery>
				<cfelse>
					<cfif len(get_pursed_hist.H_ID)>
						<cfquery name="GET_PURSE_PAYROLL" datasource="#dsn2#">
							SELECT	
								PAYROLL_ID,
								STATUS
							FROM
								CHEQUE_HISTORY
							WHERE
								HISTORY_ID=#get_pursed_hist.H_ID#
						</cfquery>
						<cfif payroll_type eq 135>
							<cfquery name="get_cash_id" datasource="#dsn2#">
								SELECT PAYROLL_CASH_ID FROM PAYROLL WHERE ACTION_ID = #GET_PURSE_PAYROLL.PAYROLL_ID#
							</cfquery>
						</cfif>
						<cfquery name="UPD_PAYROLL_CHEQUES" datasource="#dsn2#">
							UPDATE
								CHEQUE
							SET
								CHEQUE_STATUS_ID= #GET_PURSE_PAYROLL.STATUS#
								<cfif payroll_type eq 135>
									,CASH_ID = #get_cash_id.payroll_cash_id#
								</cfif>
							WHERE
								CHEQUE_ID=#CHEQUE_ID#	
						</cfquery>
					</cfif>
					<cfif STATUS eq 6>
						<cfquery name="get_payroll" datasource="#dsn2#">
							SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-2'
						</cfquery>
						<cfif not get_payroll.recordcount>
							<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#dsn2#">
								INSERT INTO
									PAYROLL
									(
										PAYROLL_NO,
										NUMBER_OF_CHEQUE,
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
										106,
										#session.ep.userid#,
										'#CGI.REMOTE_ADDR#',
										#NOW()#
									)
							</cfquery>
							<cfquery name="get_payroll" datasource="#dsn2#">
								SELECT MAX(ACTION_ID) AS ACTION_ID FROM PAYROLL WHERE PAYROLL_NO = '-2'
							</cfquery>
						</cfif>
						<cfquery name="UPD_PAYROLL_CHEQUES" datasource="#dsn2#">
							UPDATE
								CHEQUE
							SET
								CHEQUE_STATUS_ID=6,
								CHEQUE_PAYROLL_ID=#get_payroll.ACTION_ID#
							WHERE
								CHEQUE_ID=#CHEQUE_ID#	
						</cfquery>
					</cfif>
				</cfif>
			</cfoutput>
		</cfcase>
	</cfswitch>
	<cfquery name="DEL_PAYROLL_MONEY" datasource="#dsn2#">
		DELETE FROM PAYROLL_MONEY WHERE ACTION_ID=#attributes.ID#
	</cfquery>
	<cfquery name="DEL_PAYROLL" datasource="#dsn2#">
		DELETE FROM PAYROLL WHERE ACTION_ID=#attributes.ID#
	</cfquery>
	<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.head# Silindi" paper_no="#GET_PAYROLL_TYPE.PAYROLL_NO#" process_type="#payroll_type#" process_stage="#get_payroll_type.process_cat#" data_source="#dsn2#">
	</cftransaction>
</cflock> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cheque_actions</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
