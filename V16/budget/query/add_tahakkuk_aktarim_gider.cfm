<br />
<br />
<cfif len(attributes.plan_id_list) and len(attributes.wrk_row_id_list) and attributes.islem_type eq 1>	
	<cfscript>
		is_cari = 1;
		is_account = 1;
		is_budget = 1;
		is_account_group = 0;
	</cfscript>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="getPlanRows" datasource="#dsn2#">
				SELECT
					BP.PAPER_NO,
					BP.RECORD_EMP,
					BP.PROCESS_CAT,
					BP.PROCESS_TYPE,
					BP.TAHAKKUK_PLAN_ID,
					BP.MEMBER_TYPE,
					BP.COMPANY_ID,
					BP.CONSUMER_ID,
					BP.PARTNER_ID,
					BP.EMPLOYEE_ID,
					BP.PROJECT_ID,
					BP.EXPENSE_CENTER_ID,
					BP.ACCOUNT_CODE,
					BPR.ROW_PLAN_DATE PLAN_DATE,
					BP.DETAIL,
					ISNULL(BPR.ROW_EXPENSE_CENTER_ID,BP.EXPENSE_CENTER_ID) EXP_INC_CENTER_ID_2,
					BPR.ROW_EXPENSE_ITEM_ID EXPENSE_ITEM_ID,
					BPR.ROW_TOTAL_EXPENSE ACTION_VALUE,
					BPR.ROW_OTHER_TOTAL_EXPENSE OTHER_MONEY_VALUE,
					--BPR.ROW_ACCOUNT_CODE,
					BP.MONTH_ACCOUNT_CODE ROW_ACCOUNT_CODE,
					BPR.ROW_OTHER_MONEY OTHER_MONEY,
					BPR.WRK_ROW_ID,
					BP.OTHER_MONEY OTHER_MONEY_,
					TPM.RATE2,
					TPM.RATE1,
					TPM.RATE2/TPM.RATE1 CURRENCY_MULTIPLIER,
					C.FULLNAME,
					CC.CONSUMER_NAME+' '+CC.CONSUMER_SURNAME CONSUMER_NAME
				FROM
					#DSN3_ALIAS#.TAHAKKUK_PLAN BP
					LEFT JOIN #DSN3_ALIAS#.TAHAKKUK_PLAN_MONEY TPM ON TPM.MONEY_TYPE = BP.OTHER_MONEY AND TPM.ACTION_ID = BP.TAHAKKUK_PLAN_ID
					LEFT JOIN #DSN_ALIAS#.COMPANY C ON C.COMPANY_ID = BP.COMPANY_ID
					LEFT JOIN #DSN_ALIAS#.CONSUMER CC ON CC.CONSUMER_ID = BP.CONSUMER_ID,
					#DSN3_ALIAS#.TAHAKKUK_PLAN_ROW BPR
				WHERE
					BP.TAHAKKUK_PLAN_ID = BPR.TAHAKKUK_PLAN_ID AND 
					BP.TAHAKKUK_PLAN_ID IN (#attributes.plan_id_list#) AND 
					(<cfloop list="#attributes.wrk_row_id_list#" delimiters="," index="wrk_row_id">
						BPR.WRK_ROW_ID = '#wrk_row_id#'
						<cfif wrk_row_id neq listlast(attributes.wrk_row_id_list,',') and listlen(attributes.wrk_row_id_list,',') gte 1>OR</cfif>
					</cfloop>)
			</cfquery>
			<cfquery name="getPlanRowsMoney" datasource="#dsn2#">
				SELECT
					ID,
					MONEY_TYPE,
					RATE1,
					RATE2,
					IS_SELECTED,
					ACTION_ID,
					RATE2/RATE1 CURRENCY_MULTIPLIER
				FROM
					#DSN3_ALIAS#.TAHAKKUK_PLAN_MONEY
				WHERE
					ACTION_ID IN (#attributes.plan_id_list#)
			</cfquery>
			<cfif getPlanRows.recordcount>
				<cfset islem_aciklama = "">
				<cfif len(getPlanRows.FULLNAME)>
					<cfset islem_aciklama = getPlanRows.PAPER_NO&' - '&getPlanRows.FULLNAME&' - '&getPlanRows.DETAIL>
				<cfelseif len(getPlanRows.CONSUMER_NAME)>
					<cfset islem_aciklama = getPlanRows.PAPER_NO&' - '&getPlanRows.CONSUMER_NAME&' - '&getPlanRows.DETAIL>
				</cfif>
				<cfquery name="getButceGrup" dbtype="query">
					SELECT
						SUM(ACTION_VALUE) ACTION_VALUE,
						SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
						OTHER_MONEY,
						CURRENCY_MULTIPLIER,
						PLAN_DATE,
						PROCESS_CAT,
						PROCESS_TYPE,
						MEMBER_TYPE,
						COMPANY_ID,
						CONSUMER_ID,
						EMPLOYEE_ID,
						PROJECT_ID,
						EXPENSE_CENTER_ID,	
						EXPENSE_ITEM_ID,
						ACCOUNT_CODE,
						ROW_ACCOUNT_CODE
					FROM
						getPlanRows
					GROUP BY
						OTHER_MONEY,
						CURRENCY_MULTIPLIER,
						PLAN_DATE,
						PROCESS_CAT,
						PROCESS_TYPE,
						MEMBER_TYPE,
						COMPANY_ID,
						CONSUMER_ID,
						EMPLOYEE_ID,
						PROJECT_ID,
						EXPENSE_CENTER_ID,	
						EXPENSE_ITEM_ID,
						ACCOUNT_CODE,
						ROW_ACCOUNT_CODE
				</cfquery>
				<cfif getButceGrup.recordcount>					
					<cfoutput query="getButceGrup">
						<cfset wrk_id = 'THK_BM_'&'#getButceGrup.currentrow#_'&dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
						<cfquery name="AddGroup" datasource="#dsn2#" result="MAX_ID_GR">
							INSERT INTO 
							#dsn3_alias#.TAHAKKUK_PLAN_ROW_RELATION
							(
								WRK_ROW_ID
							   ,PERIOD_ID
							   ,RECORD_EMP
							   ,RECORD_DATE
							)
							VALUES
							(
								'#wrk_id#'
								,#session.ep.period_id#
								,#session.ep.userid#
								,#now()#
							)
						</cfquery> 
						<cfset tahakkuk_relation_id = MAX_ID_GR.IDENTITYCOL>
						<cfscript>
							if(is_budget eq 1)
							{
								process_cat = getButceGrup.process_cat;
								process_type = getButceGrup.process_type;
								rd_money_value = getButceGrup.other_money;
								currency_multiplier = getButceGrup.currency_multiplier;
								currency_multiplier2 = getButceGrup.currency_multiplier;
								// branch_id_info = '';
								branch_id_info = ListGetAt(session.ep.user_location,2,"-");
								detail_info =  "TAHAKKUK GİDER PLANI";
								if(len(getButceGrup.project_id))
									project_id_info = getButceGrup.project_id;
								else
									project_id_info = '';
									
								act_name = UCase('TAHAKKUK GİDER PLANI');
								acc_department_id = '';
							
								if(len(getButceGrup.member_type))
								{
									if (getButceGrup.member_type is 'partner')
									{
										from_company_id_ = getButceGrup.company_id;
										from_consumer_id_ = '';
										from_employee_id_ = '';
									}	
									else if (getButceGrup.member_type is 'consumer')
									{
										from_consumer_id_ = getButceGrup.consumer_id;
										from_company_id_ = '';
										from_employee_id_ = '';
									}
									else if (getButceGrup.member_type is 'employee')
									{
										from_employee_id_ = getButceGrup.employee_id;	
										from_company_id_ = '';
										from_consumer_id_ = '';
									}
								}
								else
								{
									from_employee_id_ = '';	
									from_company_id_ = '';
									from_consumer_id_ = '';
								}
								
								if(getButceGrup.action_value gt 0 and len(getButceGrup.expense_item_id))
								{
									butceci(
										action_id : MAX_ID_GR.IDENTITYCOL,
										muhasebe_db : dsn2,
										is_income_expense : false,
										process_type : process_type,
										nettotal : getButceGrup.action_value,
										other_money_value : getButceGrup.other_money_value,
										action_currency : rd_money_value,
										currency_multiplier : currency_multiplier2,
										expense_date : createodbcdatetime(getButceGrup.plan_date),
										expense_center_id : getButceGrup.expense_center_id,
										expense_item_id : getButceGrup.expense_item_id,
										expense_account_code : getButceGrup.row_account_code,
										detail : detail_info,
										branch_id : branch_id_info,
										project_id : project_id_info,
										insert_type : 1, //banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
										company_id : from_company_id_,
										consumer_id : from_consumer_id_,
										employee_id : from_employee_id_,
										action_table : 'TAHAKKUK_PLAN_ROW_RELATION'
									);
								}							
							}
							str_alacak_tutar_list="";
							str_alacak_kod_list="";
							str_borc_tutar_list="";
							str_borc_kod_list="";
							satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar 
							//muhasebe fisi satır detaylarını tutar. satir_detay_list[1]'a  borc yazan satırların acıklamaları, satir_detay_list[2]'a alacak yazan satırların acıklamaları set edilir. 
							str_other_alacak_tutar_list = "";
							str_other_borc_tutar_list = "";
							str_other_borc_currency_list = "";
							str_other_alacak_currency_list = "";
							str_borclu_tutar = ArrayNew(1) ;
							str_alacakli_tutar = ArrayNew(1) ;
							acc_project_list_borc = '';
							acc_project_list_alacak = '';
							
							if(is_account eq 1)
							{
								str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,getButceGrup.action_value,",");
								str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,getButceGrup.other_money_value,",");
								str_alacak_kod_list = ListAppend(str_alacak_kod_list,getButceGrup.ROW_ACCOUNT_CODE,",");
								str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,rd_money_value,",");
								satir_detay_list[2][listlen(str_alacak_tutar_list)]= '#islem_aciklama#';
								
								// abort(str_other_alacak_tutar_list);
								
								str_borc_tutar_list = ListAppend(str_borc_tutar_list,getButceGrup.action_value,",");								
								str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,getButceGrup.other_money_value,",");
								str_borc_kod_list = ListAppend(str_borc_kod_list,getButceGrup.ACCOUNT_CODE,",");
								str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,rd_money_value,",");										
								satir_detay_list[1][listlen(str_borc_tutar_list)]='#islem_aciklama#';
								
								muhasebeci (
									wrk_id : wrk_id,
									action_id : MAX_ID_GR.IDENTITYCOL,
									action_table :'TAHAKKUK_PLAN_ROW_RELATION',
									acc_department_id : acc_department_id,
									workcube_process_type : process_type,
									workcube_process_cat : process_cat,
									account_card_type : 13,
									islem_tarihi : createodbcdatetime(getButceGrup.plan_date),
									company_id : from_company_id_,
									consumer_id : from_consumer_id_,
									employee_id : from_employee_id_,
									borc_hesaplar : str_borc_kod_list,
									borc_tutarlar : str_borc_tutar_list,
									alacak_hesaplar : str_alacak_kod_list,
									alacak_tutarlar : str_alacak_tutar_list,
									fis_satir_detay: satir_detay_list,
									fis_detay : act_name,
									from_branch_id : branch_id_info,
									to_branch_id : branch_id_info,
									other_amount_borc : str_other_borc_tutar_list,
									other_currency_borc : str_other_borc_currency_list,
									other_amount_alacak : str_other_alacak_tutar_list,
									other_currency_alacak : str_other_alacak_currency_list,
									is_account_group : is_account_group,
									currency_multiplier : currency_multiplier2,
									due_date: createodbcdatetime(getButceGrup.plan_date),
									acc_project_id : project_id_info
								);
							}
						</cfscript>
						<cfif getPlanRowsMoney.recordcount>
							<cfquery name="getPlanRowsMoneyID" dbtype="query">							
								SELECT * FROM getPlanRowsMoney WHERE CURRENCY_MULTIPLIER = #getButceGrup.currency_multiplier#
							</cfquery>
							<cfif getPlanRowsMoneyID.recordcount>
								<cfquery name="getPlanRowsMoneyInfo" dbtype="query">
									SELECT
										MONEY_TYPE,
										RATE1,
										RATE2,
										IS_SELECTED
									FROM
										getPlanRowsMoney
									WHERE
										ACTION_ID = #getPlanRowsMoneyID.ACTION_ID#
								</cfquery>
								<cfquery name="GET_CARD_ID" datasource="#dsn2#">
									 SELECT
										*
									 FROM
										ACCOUNT_CARD
									 WHERE
										ACTION_ID = #MAX_ID_GR.IDENTITYCOL#										
										AND ACTION_TABLE = 'TAHAKKUK_PLAN_ROW_RELATION'
										AND WRK_ID = '#wrk_id#'
								</cfquery>
								<!--- AND ACTION_TYPE = #getButceGrup.process_type# --->
								<cfif getPlanRowsMoneyInfo.recordcount and GET_CARD_ID.recordcount>									
									<cfloop query="getPlanRowsMoneyInfo">
										<cfquery name="AddMoney" datasource="#dsn2#">
											INSERT INTO 
												ACCOUNT_CARD_MONEY
											(
												ACTION_ID
											   ,MONEY_TYPE
											   ,RATE1
											   ,RATE2
											   ,IS_SELECTED
											)
											VALUES
											(
												#GET_CARD_ID.CARD_ID#
												,'#getPlanRowsMoneyInfo.MONEY_TYPE#'
												,#getPlanRowsMoneyInfo.RATE1#
												,#getPlanRowsMoneyInfo.RATE2#
												,#getPlanRowsMoneyInfo.IS_SELECTED#
											)
										</cfquery> 
									</cfloop>
								</cfif>
							</cfif>
						</cfif>
						<cfquery name="getRowControl" datasource="#dsn2#">
							SELECT EXP_ITEM_ROWS_ID,EXPENSE_ID,ACTION_ID,ACTION_TABLE,WRK_ROW_ID,EXPENSE_COST_TYPE FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #MAX_ID_GR.IDENTITYCOL# AND ACTION_TABLE = 'TAHAKKUK_PLAN_ROW_RELATION' AND EXPENSE_ID = 0 AND IS_INCOME = 0
						</cfquery>
						<cfif getRowControl.recordcount>
							<cfquery name="UpdExpenseRow" datasource="#dsn2#">
								UPDATE EXPENSE_ITEMS_ROWS SET WRK_ROW_ID = '#wrk_id#' WHERE ACTION_ID = #MAX_ID_GR.IDENTITYCOL# AND ACTION_TABLE = 'TAHAKKUK_PLAN_ROW_RELATION' AND EXPENSE_ID = 0 AND IS_INCOME = 0 AND EXP_ITEM_ROWS_ID = #getRowControl.EXP_ITEM_ROWS_ID#
							</cfquery>
						</cfif>
						<cfquery name="UpdThkRow" datasource="#dsn2#">
							UPDATE 
								#DSN3_ALIAS#.TAHAKKUK_PLAN_ROW 
							SET 
								TAHAKKUK_PLAN_ROW.IS_PROCESS = 1, 
								TAHAKKUK_PLAN_ROW.PROCESS_PERIOD_ID = #session.ep.period_id#,
								TAHAKKUK_PLAN_ROW.WRK_ROW_RELATION_ID = '#wrk_id#',
								TAHAKKUK_PLAN_ROW.PROCESS_ACTION_ID = #MAX_ID_GR.IDENTITYCOL#
							FROM
								#DSN3_ALIAS#.TAHAKKUK_PLAN 
								LEFT JOIN #DSN3_ALIAS#.TAHAKKUK_PLAN_MONEY ON TAHAKKUK_PLAN_MONEY.MONEY_TYPE = TAHAKKUK_PLAN.OTHER_MONEY AND TAHAKKUK_PLAN_MONEY.ACTION_ID = TAHAKKUK_PLAN.TAHAKKUK_PLAN_ID,
								#DSN3_ALIAS#.TAHAKKUK_PLAN_ROW 
							WHERE 
								ISNULL(TAHAKKUK_PLAN_ROW.IS_PROCESS,0) = 0
								AND TAHAKKUK_PLAN_ROW.ROW_OTHER_MONEY = '#getButceGrup.OTHER_MONEY#'
								AND TAHAKKUK_PLAN_MONEY.RATE2/TAHAKKUK_PLAN_MONEY.RATE1 = #getButceGrup.CURRENCY_MULTIPLIER#
								AND TAHAKKUK_PLAN_ROW.ROW_PLAN_DATE = '#getButceGrup.PLAN_DATE#'
								AND TAHAKKUK_PLAN.PROCESS_CAT = #getButceGrup.PROCESS_CAT#
								AND TAHAKKUK_PLAN.PROCESS_TYPE = #getButceGrup.PROCESS_TYPE#
								<cfif len(getButceGrup.MEMBER_TYPE)>AND TAHAKKUK_PLAN.MEMBER_TYPE = '#getButceGrup.MEMBER_TYPE#'</cfif>
								<cfif len(getButceGrup.COMPANY_ID)>AND TAHAKKUK_PLAN.COMPANY_ID = #getButceGrup.COMPANY_ID#</cfif>
								<cfif len(getButceGrup.CONSUMER_ID)>AND TAHAKKUK_PLAN.CONSUMER_ID = #getButceGrup.CONSUMER_ID#</cfif>
								<cfif len(getButceGrup.EMPLOYEE_ID)>AND TAHAKKUK_PLAN.EMPLOYEE_ID = #getButceGrup.EMPLOYEE_ID#</cfif>
								<cfif len(getButceGrup.PROJECT_ID)>AND TAHAKKUK_PLAN.PROJECT_ID = #getButceGrup.PROJECT_ID#</cfif>
								<cfif len(getButceGrup.EXPENSE_CENTER_ID)>AND TAHAKKUK_PLAN.EXPENSE_CENTER_ID = #getButceGrup.EXPENSE_CENTER_ID#</cfif>
								AND TAHAKKUK_PLAN_ROW.ROW_EXPENSE_ITEM_ID = #getButceGrup.EXPENSE_ITEM_ID#
								AND TAHAKKUK_PLAN.ACCOUNT_CODE = '#getButceGrup.ACCOUNT_CODE#'
								AND TAHAKKUK_PLAN.MONTH_ACCOUNT_CODE = '#getButceGrup.ROW_ACCOUNT_CODE#'								
						</cfquery>
						<!--- --AND TAHAKKUK_PLAN_ROW.ROW_ACCOUNT_CODE = '#getButceGrup.ROW_ACCOUNT_CODE#' --->
					</cfoutput>
				</cfif>
			</cfif>
		</cftransaction>
	</cflock>
<cfelseif len(attributes.plan_id_list) and len(attributes.wrk_row_id_list) and attributes.islem_type eq 2>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="ButceSil" datasource="#dsn2#">
				DELETE FROM EXPENSE_ITEMS_ROWS 
				WHERE 
					ACTION_TABLE = 'TAHAKKUK_PLAN_ROW_RELATION' 
					AND EXPENSE_ID = 0 
					AND IS_INCOME = 0
					AND ACTION_ID IN (#attributes.plan_id_list#) 
					AND (<cfloop list="#attributes.wrk_row_id_list#" delimiters="," index="wrk_row_id">
						WRK_ROW_ID = '#wrk_row_id#'
						<cfif wrk_row_id neq listlast(attributes.wrk_row_id_list,',') and listlen(attributes.wrk_row_id_list,',') gte 1>OR</cfif>
					</cfloop>)
			</cfquery>
			<!--- EXP_ITEM_ROWS_ID,EXPENSE_ID,ACTION_ID,ACTION_TABLE,WRK_ROW_ID,EXPENSE_COST_TYPE --->
			<cfquery name="GetMuhasebe" datasource="#dsn2#">
				SELECT * 
				FROM ACCOUNT_CARD 
				WHERE ACTION_TABLE = 'TAHAKKUK_PLAN_ROW_RELATION' AND ACTION_ID IN (#attributes.plan_id_list#)  
					AND (<cfloop list="#attributes.wrk_row_id_list#" delimiters="," index="wrk_row_id">
						WRK_ID = '#wrk_row_id#'
						<cfif wrk_row_id neq listlast(attributes.wrk_row_id_list,',') and listlen(attributes.wrk_row_id_list,',') gte 1>OR</cfif>
					</cfloop>)
			</cfquery>
			<cfif GetMuhasebe.recordcount>
				<cfoutput query="GetMuhasebe">
					<cfquery name="SilMuhasebeSatir" datasource="#dsn2#">
						DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = #GetMuhasebe.CARD_ID#
					</cfquery>
					<cfquery name="SilMuhasebeSatir" datasource="#dsn2#">
						DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID = #GetMuhasebe.CARD_ID#
					</cfquery>
					<cfquery name="SilMuhasebeMoney" datasource="#dsn2#">
						DELETE FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID = #GetMuhasebe.CARD_ID#
					</cfquery>
				</cfoutput>
				<cfquery name="SilMuhasebe" datasource="#dsn2#">
					DELETE
					FROM ACCOUNT_CARD 
					WHERE ACTION_TABLE = 'TAHAKKUK_PLAN_ROW_RELATION' AND ACTION_ID IN (#attributes.plan_id_list#)  
						AND (<cfloop list="#attributes.wrk_row_id_list#" delimiters="," index="wrk_row_id">
							WRK_ID = '#wrk_row_id#'
							<cfif wrk_row_id neq listlast(attributes.wrk_row_id_list,',') and listlen(attributes.wrk_row_id_list,',') gte 1>OR</cfif>
						</cfloop>)
				</cfquery>
			</cfif>
			<cfquery name="RelationDel" datasource="#dsn2#">
				DELETE FROM #DSN3_ALIAS#.TAHAKKUK_PLAN_ROW_RELATION 
				WHERE 
					TAHAKKUK_PLAN_RELATION_ID IN (#attributes.plan_id_list#) 
					AND (<cfloop list="#attributes.wrk_row_id_list#" delimiters="," index="wrk_row_id">
						WRK_ROW_ID = '#wrk_row_id#'
						<cfif wrk_row_id neq listlast(attributes.wrk_row_id_list,',') and listlen(attributes.wrk_row_id_list,',') gte 1>OR</cfif>
					</cfloop>)
			</cfquery>
			<cfquery name="UpdThkRow" datasource="#dsn2#">
				UPDATE 
					#DSN3_ALIAS#.TAHAKKUK_PLAN_ROW 
				SET 
					TAHAKKUK_PLAN_ROW.IS_PROCESS = 0, 
					TAHAKKUK_PLAN_ROW.PROCESS_PERIOD_ID = null,
					TAHAKKUK_PLAN_ROW.WRK_ROW_RELATION_ID = null,
					TAHAKKUK_PLAN_ROW.PROCESS_ACTION_ID = null
				WHERE 
					TAHAKKUK_PLAN_ROW.PROCESS_ACTION_ID IN (#attributes.plan_id_list#)  
					AND (<cfloop list="#attributes.wrk_row_id_list#" delimiters="," index="wrk_row_id">
						TAHAKKUK_PLAN_ROW.WRK_ROW_RELATION_ID = '#wrk_row_id#'
						<cfif wrk_row_id neq listlast(attributes.wrk_row_id_list,',') and listlen(attributes.wrk_row_id_list,',') gte 1>OR</cfif>
					</cfloop>)
			</cfquery>			
		</cftransaction>
	</cflock>
</cfif> 
<!--- Sevim Çelik : Tahakkuk işlemleri muhasebeye akarım sorgu sayfası --->
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>