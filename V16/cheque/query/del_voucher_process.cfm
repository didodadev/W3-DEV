<cfquery name="GET_VOUCHER_STATUS" datasource="#dsn2#">
	SELECT 
		VOUCHER_STATUS_ID
	FROM
		VOUCHER
	WHERE
		VOUCHER_ID=#url.c_id#
</cfquery>
<cfquery name="GET_HIS_ID" datasource="#dsn2#">
	SELECT 
		MAX(HISTORY_ID) AS HISTORY_ID
	FROM
		VOUCHER_HISTORY
	WHERE
		VOUCHER_ID=#url.c_id# AND
		STATUS <> 1
</cfquery>

<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="del_voucher_history" datasource="#dsn2#">
			DELETE FROM VOUCHER_HISTORY WHERE HISTORY_ID=#get_his_id.HISTORY_ID# 
		</cfquery>
		<cfquery name="GET_HIS_ID_" datasource="#dsn2#">
			SELECT 
				MAX(HISTORY_ID) AS HISTORY
			FROM
				VOUCHER_HISTORY
			WHERE
				VOUCHER_ID=#url.c_id#
		</cfquery>
		<cfquery name="GET_HIS_STATUS_" datasource="#dsn2#">
			SELECT 
				STATUS,
				PAYROLL_ID
			FROM
				VOUCHER_HISTORY
			WHERE
				HISTORY_ID=#GET_HIS_ID_.HISTORY#
		</cfquery>
		<cfquery name="UPD_STATUS" datasource="#DSN2#">
			UPDATE
				VOUCHER
			SET
				VOUCHER_STATUS_ID=#GET_HIS_STATUS_.STATUS#
			WHERE
				VOUCHER_ID=#url.C_ID#
		</cfquery>
		<!--- Tahsilat değeri ekstreyi günceller seçeneğinin geri alınması işlemi. İlk bordrodaki kurları bulup cari row u güncellliyor. --->
		<cfquery name="GET_VOUCHER_HISTORY_PORT" datasource="#dsn2#" maxrows="1">
			SELECT PAYROLL_ID FROM VOUCHER_HISTORY WHERE VOUCHER_ID = #url.C_ID# AND (STATUS = 1 OR STATUS = 2) ORDER BY HISTORY_ID
		</cfquery>
		<cfif get_VOUCHER_history_port.recordcount>
			<cfquery name="GET_PAYROLL_PORT" datasource="#dsn2#">
				SELECT PROCESS_CAT,PAYROLL_TYPE,ACTION_ID FROM VOUCHER_PAYROLL WHERE ACTION_ID = #GET_VOUCHER_HISTORY_PORT.PAYROLL_ID#
			</cfquery>
			<cfquery name="GET_PAYROLL_MONEY" datasource="#dsn2#">
				SELECT 
        	        MONEY_TYPE, 
                    ACTION_ID, 
                    RATE2, 
                    RATE1, 
                    IS_SELECTED, 
                    ACTION_MONEY_ID 
                FROM 
    	            VOUCHER_PAYROLL_MONEY 
                WHERE 
	                ACTION_ID = #GET_PAYROLL_PORT.ACTION_ID# AND IS_SELECTED = 1
			</cfquery>
			<cfif len(session.ep.money2)>
				<cfquery name="GET_PAYROLL_MONEY2" datasource="#dsn2#">
					SELECT 
                        MONEY_TYPE, 
                        ACTION_ID, 
                        RATE2, 
                        RATE1, 
                        IS_SELECTED, 
                        ACTION_MONEY_ID 
                    FROM 
                    	VOUCHER_PAYROLL_MONEY 
                    WHERE 
                    	ACTION_ID = #GET_PAYROLL_PORT.ACTION_ID# AND MONEY_TYPE = '#session.ep.money2#'
				</cfquery>
			</cfif>
			<cfquery name="get_hist_values" datasource="#dsn2#">
				SELECT OTHER_MONEY_VALUE,OTHER_MONEY FROM VOUCHER_HISTORY WHERE VOUCHER_ID = #url.C_ID# AND PAYROLL_ID = #GET_PAYROLL_PORT.ACTION_ID# 
			</cfquery>
			<cfif len(get_payroll_port.process_cat) or len(get_payroll_port.payroll_type)>
				<cfquery name="get_process_type1" datasource="#dsn2#">
					SELECT 
						IS_CHEQUE_BASED_ACTION,
						IS_UPD_CARI_ROW
					 FROM 
						#dsn3_alias#.SETUP_PROCESS_CAT 
					WHERE 
					<cfif len(get_payroll_port.process_cat)>
						PROCESS_CAT_ID = #get_payroll_port.process_cat#
					<cfelse><!--- devirden oluşan bordrolarn process_cat ı olmadığı için,type dan bakıyorz --->
						PROCESS_TYPE = #get_payroll_port.payroll_type#
					</cfif>
				</cfquery>
				<cfif get_process_type1.IS_CHEQUE_BASED_ACTION eq 1 and get_process_type1.IS_UPD_CARI_ROW eq 1>
					<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
						UPDATE
							CARI_ROWS
						SET
							OTHER_MONEY = <cfif len(get_payroll_money.money_type)>'#get_payroll_money.money_type#',<cfelse>'#get_hist_values.other_money#',</cfif>
							OTHER_CASH_ACT_VALUE = <cfif len(get_payroll_money.rate2)>#wrk_round(get_hist_values.other_money_value/get_payroll_money.rate2)#,<cfelse>#get_hist_values.other_money_value#,</cfif>
							<cfif len(session.ep.money2)>ACTION_CURRENCY_2 = '#session.ep.money2#',</cfif>
							<cfif len(session.ep.money2) and len(get_payroll_money2.rate2)>ACTION_VALUE_2 = #wrk_round(get_hist_values.other_money_value/get_payroll_money2.rate2)#,</cfif>					
							ACTION_ID = #url.C_ID#,
							UPDATE_DATE = #now()#
						WHERE
							ACTION_ID = #url.C_ID# AND
							ACTION_TYPE_ID IN (97,107) AND
							ACTION_TABLE = 'VOUCHER'
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<cfif listfind('3',GET_VOUCHER_STATUS.VOUCHER_STATUS_ID,',')>
			<cfquery name="GET_BANK_ACT_ID" datasource="#dsn2#">
				SELECT 
					ACTION_ID
				FROM
					BANK_ACTIONS
				 WHERE
					VOUCHER_ID=#url.c_id# AND
				<cfif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 7>
					ACTION_TYPE_ID=1054
				<cfelseif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 3>
					ACTION_TYPE_ID=1053
				</cfif>
			</cfquery>
			<cfif GET_BANK_ACT_ID.recordcount eq 1>
				<cfquery name="DEL_BANK_ACT" datasource="#dsn2#">
					 DELETE FROM BANK_ACTIONS WHERE ACTION_ID=#GET_BANK_ACT_ID.ACTION_ID#
				</cfquery>		
			</cfif>
			<!--- ödendi değeri ekstreyi günceller seçeneğinin geri alınması işlemi. İlk bordrodaki kurları bulup cari row u güncellliyor. --->
			<cfquery name="GET_VOUCHER_HISTORY_PORT" datasource="#dsn2#" maxrows="1">
				SELECT PAYROLL_ID FROM VOUCHER_HISTORY WHERE VOUCHER_ID = #url.C_ID# AND STATUS=6 ORDER BY HISTORY_ID
			</cfquery>
			<cfif get_VOUCHER_history_port.recordcount>
				<cfquery name="GET_PAYROLL_PORT" datasource="#dsn2#">
					SELECT PROCESS_CAT,PAYROLL_TYPE,ACTION_ID FROM VOUCHER_PAYROLL WHERE ACTION_ID = #GET_VOUCHER_HISTORY_PORT.PAYROLL_ID#
				</cfquery>
				<cfquery name="GET_PAYROLL_MONEY" datasource="#dsn2#">
					SELECT 
                        MONEY_TYPE, 
                        ACTION_ID, 
                        RATE2, 
                        RATE1, 
                        IS_SELECTED, 
                        ACTION_MONEY_ID 
                    FROM 
                    	VOUCHER_PAYROLL_MONEY 
                    WHERE 
                    	ACTION_ID = #GET_PAYROLL_PORT.ACTION_ID# AND IS_SELECTED = 1
				</cfquery>
				<cfif len(session.ep.money2)>
					<cfquery name="GET_PAYROLL_MONEY2" datasource="#dsn2#">
						SELECT 
                            MONEY_TYPE, 
                            ACTION_ID, 
                            RATE2, 
                            RATE1, 
                            IS_SELECTED, 
                            ACTION_MONEY_ID 
                        FROM 
                        	VOUCHER_PAYROLL_MONEY 
                        WHERE 
                        	ACTION_ID = #GET_PAYROLL_PORT.ACTION_ID# AND MONEY_TYPE = '#session.ep.money2#'
					</cfquery>
				</cfif>
				<cfquery name="get_hist_values" datasource="#dsn2#">
					SELECT OTHER_MONEY_VALUE,OTHER_MONEY FROM VOUCHER_HISTORY WHERE VOUCHER_ID = #url.C_ID# AND PAYROLL_ID = #GET_PAYROLL_PORT.ACTION_ID# 
				</cfquery>
				<cfif len(get_payroll_port.process_cat) or len(get_payroll_port.payroll_type)>
					<cfquery name="get_process_type1" datasource="#dsn2#">
						SELECT 
							IS_CHEQUE_BASED_ACTION,
							IS_UPD_CARI_ROW
						 FROM 
							#dsn3_alias#.SETUP_PROCESS_CAT 
						WHERE 
						<cfif len(get_payroll_port.process_cat)>
							PROCESS_CAT_ID = #get_payroll_port.process_cat#
						<cfelse><!--- devirden oluşan bordrolarn process_cat ı olmadığı için,type dan bakıyorz --->
							PROCESS_TYPE = #get_payroll_port.payroll_type#
						</cfif>
					</cfquery>
					<cfif get_process_type1.IS_CHEQUE_BASED_ACTION eq 1 and get_process_type1.IS_UPD_CARI_ROW eq 1>
						<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
							UPDATE
								CARI_ROWS
							SET
								OTHER_MONEY = <cfif len(get_payroll_money.money_type)>'#get_payroll_money.money_type#',<cfelse>'#get_hist_values.other_money#',</cfif>
								OTHER_CASH_ACT_VALUE = <cfif len(get_payroll_money.rate2)>#wrk_round(get_hist_values.other_money_value/get_payroll_money.rate2)#,<cfelse>#get_hist_values.other_money_value#,</cfif>
								<cfif len(session.ep.money2)>ACTION_CURRENCY_2 = '#session.ep.money2#',</cfif>
								<cfif len(session.ep.money2) and len(get_payroll_money2.rate2)>ACTION_VALUE_2 = #wrk_round(get_hist_values.other_money_value/get_payroll_money2.rate2)#,</cfif>					
								ACTION_ID = #url.C_ID#,
								UPDATE_DATE = #now()#
							WHERE
								ACTION_ID = #url.C_ID# AND
								ACTION_TYPE_ID IN (98,107) AND
								ACTION_TABLE = 'VOUCHER'
						</cfquery>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		<cfif listfind('7',GET_VOUCHER_STATUS.VOUCHER_STATUS_ID,',')>
			<cfquery name="GET_CASH_ACT_ID" datasource="#dsn2#">
				SELECT 
					ACTION_ID
				FROM
					CASH_ACTIONS
				 WHERE
					VOUCHER_ID=#url.c_id# AND
				<cfif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 7>
					ACTION_TYPE_ID=1054
				<cfelseif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 3>
					ACTION_TYPE_ID=1053
				</cfif>
			</cfquery>
			<cfif GET_CASH_ACT_ID.recordcount eq 1>
				<cfquery name="DEL_BANK_ACT" datasource="#dsn2#">
					 DELETE FROM CASH_ACTIONS WHERE ACTION_ID=#GET_CASH_ACT_ID.ACTION_ID#
				</cfquery>		
			</cfif>
			<cfquery name="GET_BANK_ACT_ID" datasource="#dsn2#">
				SELECT 
					ACTION_ID
				FROM
					BANK_ACTIONS
				 WHERE
					VOUCHER_ID=#url.c_id# AND
				<cfif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 7>
					ACTION_TYPE_ID=1051
				<cfelseif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 3>
					ACTION_TYPE_ID=1053
				</cfif>
			</cfquery>
			<cfif GET_BANK_ACT_ID.recordcount eq 1>
				<cfquery name="DEL_BANK_ACT" datasource="#dsn2#">
					 DELETE FROM BANK_ACTIONS WHERE ACTION_ID=#GET_BANK_ACT_ID.ACTION_ID#
				</cfquery>		
			</cfif>
		</cfif>
		<cfquery name="GET_CARD_ID" datasource="#dsn2#">
			 SELECT
				CARD_ID,
                ACTION_DATE
			 FROM
				ACCOUNT_CARD
			 WHERE
				CARD_TYPE=13
			<cfif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 5>
				AND ACTION_ID=#url.c_id#
				AND ACTION_TYPE=1056
			<cfelseif (GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 7) and (GET_CASH_ACT_ID.recordcount eq 1)>
				AND ACTION_ID=#GET_CASH_ACT_ID.ACTION_ID#
				AND ACTION_TYPE IN(1054)
			<cfelseif (GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 7) and (GET_BANK_ACT_ID.recordcount eq 1)>
				AND ACTION_ID=#GET_BANK_ACT_ID.ACTION_ID#
				AND ACTION_TYPE IN(1051)
			<cfelseif (GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 3) and (GET_BANK_ACT_ID.recordcount eq 1)>
				AND ACTION_ID=#GET_BANK_ACT_ID.ACTION_ID# 
				AND ACTION_TYPE=1053
			<cfelse>
				AND CARD_ID IS NULL			
			</cfif>
		</cfquery>
        <!--- e-defter islem kontrolu EsraNur --->
		<cfif GET_CARD_ID.recordcount and session.ep.our_company_info.is_edefter eq 1>
            <cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
                <cfprocparam cfsqltype="cf_sql_timestamp" value="#GET_CARD_ID.ACTION_DATE#">
                <cfprocparam cfsqltype="cf_sql_timestamp" value="#GET_CARD_ID.ACTION_DATE#">
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
		<cfif GET_CARD_ID.RECORDCOUNT eq 1>
			<cfquery name="DEL_ACCOUNT_CARD" datasource="#dsn2#">
				DELETE FROM ACCOUNT_CARD WHERE CARD_ID=#GET_CARD_ID.CARD_ID#
			</cfquery>
			<cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#dsn2#">
				DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID=#GET_CARD_ID.CARD_ID#
			</cfquery>
			<cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#dsn2#">
				DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID=#GET_CARD_ID.CARD_ID#
			</cfquery>
		</cfif>	
		<cfif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 3 and get_bank_act_id.recordcount>
			<cfquery name="GET_EXPENSE_ID" datasource="#dsn2#">
				 SELECT
					EXP_ITEM_ROWS_ID
				 FROM
					EXPENSE_ITEMS_ROWS
				 WHERE
					ACTION_ID = #GET_BANK_ACT_ID.ACTION_ID# 
					AND EXPENSE_COST_TYPE = 1053
			</cfquery>
			<cfif GET_EXPENSE_ID.RECORDCOUNT>
				<cfquery name="DEL_EXPENSE" datasource="#dsn2#">
					DELETE FROM EXPENSE_ITEMS_ROWS WHERE EXP_ITEM_ROWS_ID = #GET_EXPENSE_ID.EXP_ITEM_ROWS_ID#
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>
</cflock> 

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
