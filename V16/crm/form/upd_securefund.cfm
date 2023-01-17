<cfquery name="GET_COMPANY_SECUREFUND" datasource="#DSN#">
	SELECT * FROM COMPANY_SECUREFUND WHERE SECUREFUND_ID = #attributes.securefund_id#
</cfquery>
<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		COMPANY_BRANCH_RELATED.RELATED_ID, 
		BRANCH.BRANCH_ID, 
		BRANCH.BRANCH_NAME,
		BRANCH.COMPANY_ID
	FROM 
		BRANCH, 
		COMPANY_BRANCH_RELATED
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND 
		COMPANY_BRANCH_RELATED.COMPANY_ID = #get_company_securefund.company_id# AND 
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
		COMPANY_BRANCH_RELATED.RELATED_ID = #get_company_securefund.branch_id#
</cfquery>
<cfquery name="SETUP_SECUREFUND" datasource="#DSN#">
	SELECT SECUREFUND_CAT_ID, SECUREFUND_CAT FROM SETUP_SECUREFUND
</cfquery>
<cfif attributes.fuseaction eq 'crm.list_company_securefund'>
	<cf_catalystHeader>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<div class="col col-9 col-md-9 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Teminat Yönetimi','51999')#">
			<cfform name="add_secure" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=crm.emptypopup_upd_securefund">
				<input type="hidden" name="securefund_id" id="securefund_id" value="<cfoutput>#attributes.securefund_id#</cfoutput>">
				<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#get_company_securefund.company_id#</cfoutput>">
				<cf_box_elements>	
					<cfif isdefined("attributes.is_normal_form")><input type="hidden" name="is_normal_form" id="is_normal_form" value="<cfoutput>#attributes.is_normal_form#</cfoutput>"></cfif>
					<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-is_active">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12">&nbsp</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<label><input type="checkbox" value="1" name="securefund_status" id="securefund_status" <cfif get_company_securefund.securefund_status eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
							</div>
						</div>
						<div class="form-group" id="item-branch_id">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="hidden" name="our_company_id" id="our_company_id" value="<cfoutput>#get_branch.company_id#,#get_branch.related_id#,#get_branch.branch_id#</cfoutput>">
								<cfinput type="text" name="memb_n" readonly value="#get_branch.branch_name#">
							</div>
						</div>
						<div class="form-group" id="item-member">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_company_securefund.company_id#</cfoutput>">
								<input type="hidden" name="member_type" id="member_type" value="<cfif len(get_company_securefund.consumer_id)>consumer<cfelseif len(get_company_securefund.company_id)>partner</cfif>">
								<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_company_securefund.consumer_id#</cfoutput>">
								<cfquery name="GET_COMPANY" datasource="#DSN#">
									SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_company_securefund.company_id# 
								</cfquery>	
								<input type="hidden" name="member" id="member" value="<cfoutput>#get_company.fullname#</cfoutput>">
								<cfinput type="text" name="memb_n" readonly value="#get_company.fullname#">
							</div>
						</div>
						<div class="form-group" id="item-securefund_cat">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="securefund_cat_id" id="securefund_cat_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option> 
									<cfoutput query="setup_securefund">
										<option value="#securefund_cat_id#" <cfif securefund_cat_id eq get_company_securefund.securefund_cat_id>selected</cfif>>#securefund_cat#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-bank_branch">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58933.Banka Şubesi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput name="bank_branch" type="text" value="#get_company_securefund.bank_branch#" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-money_type">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="securefund_total" id="securefund_total" value="#tlformat(get_company_securefund.securefund_total)#" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
									<span class="input-group-addon width">
										<select name="money_type" id="money_type">
											<cfoutput query="get_money_rate">
												<option value="#money#" <cfif money is '#get_company_securefund.money_cat#'> selected</cfif>>#money#</option>
											</cfoutput>
										</select>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-start_date">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'>!</cfsavecontent>
									<cfinput value="#dateformat(get_company_securefund.start_date,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="start_date"> 
									<span class="input-group-addon">
										<cf_wrk_date_image date_field="start_date">
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-warning_date">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='38414.Uyarı Tarihi'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='52068.Uyarı Tarihi Girmelisiniz'>!</cfsavecontent>
									<cfinput value="#dateformat(get_company_securefund.warning_date,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="warning_date"> 
									<span class="input-group-addon">
										<cf_wrk_date_image date_field="warning_date">
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-mortgage_total">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52070.İpotek Beyan Bedeli'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="mortgage_total" id="mortgage_total" value="#tlformat(get_company_securefund.mortgage_total)#" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
									<span class="input-group-addon width">
										<select name="mortgage_money_type" id="mortgage_money_type">
											<cfoutput query="GET_MONEY_RATE">
												<option value="#money#" <cfif get_company_securefund.mortgage_money_currency eq money>selected</cfif>>#money#</option>
											</cfoutput>
										</select>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-mortgage_rate">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52074.İpotek Derecesi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="mortgage_rate" id="mortgage_rate">
									<option value="1" <cfif get_company_securefund.mortgage_rate eq 1>selected</cfif>>1</option>
									<option value="2" <cfif get_company_securefund.mortgage_rate eq 2>selected</cfif>>2</option>
									<option value="3" <cfif get_company_securefund.mortgage_rate eq 3>selected</cfif>>3</option>
									<option value="4" <cfif get_company_securefund.mortgage_rate eq 4>selected</cfif>>4</option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-mortgage_bank">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52516.İpotek Bankası'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="mortgage_bank" id="mortgage_bank" value="#get_company_securefund.mortgage_bank#" maxlength="25">
							</div>
						</div>
						<div class="form-group" id="item-mortgage_type">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52515.Nevi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="mortgage_type" id="mortgage_type">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option> 
									<option value="1" <cfif get_company_securefund.mortgage_type eq 1> selected</cfif>><cf_get_lang dictionary_id='58480.Araç'></option>
									<option value="2" <cfif get_company_securefund.mortgage_type eq 2> selected</cfif>><cf_get_lang dictionary_id='52520.Arsa'></option>
									<option value="3" <cfif get_company_securefund.mortgage_type eq 3> selected</cfif>><cf_get_lang dictionary_id='52518.Bağ'></option>
									<option value="4" <cfif get_company_securefund.mortgage_type eq 4> selected</cfif>><cf_get_lang dictionary_id='52521.Bina'></option>
									<option value="5" <cfif get_company_securefund.mortgage_type eq 5> selected</cfif>><cf_get_lang dictionary_id='52522.Dükkan'></option>
									<option value="6" <cfif get_company_securefund.mortgage_type eq 6> selected</cfif>><cf_get_lang dictionary_id='52523.Mesken'></option>
									<option value="7" <cfif get_company_securefund.mortgage_type eq 7> selected</cfif>><cf_get_lang dictionary_id='52524.Tarla'></option>
								</select>
							</div>
						</div>
					</div>

					<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-b"></div>
						<div class="form-group" id="item-file">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57468.Belge'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="file" name="securefund_file">
									<cfinput  type="hidden" name="oldsecurefund_file" id="oldsecurefund_file" value="#get_company_securefund.securefund_file#">
									<cfinput  type="hidden" name="oldsecurefund_file_server_id" id="oldsecurefund_file_server_id" value="#get_company_securefund.securefund_file_server_id#">
									<cfif len(get_company_securefund.securefund_file)>
										<cfoutput>
											<span class="input-group-addon fa fa-file" href="javascript://" onclick="windowopen('#file_web_path#member/#get_company_securefund.securefund_file#','list')">#get_company_securefund.securefund_file#</span>
										</cfoutput>
									</cfif>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-_process">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cf_workcube_process is_upd='0' select_value = '#get_company_securefund.process_cat#' process_cat_width='150' is_detail='1'>
							</div>
						</div>
						<div class="form-group" id="item-give_take">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="give_take" id="give_take">
									<option value="0" <cfif get_company_securefund.give_take eq 0> selected</cfif>><cf_get_lang dictionary_id='58488.Alınan'></option>
									<option value="1" <cfif get_company_securefund.give_take eq 1> selected</cfif>><cf_get_lang dictionary_id='58490.Verilen'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-bank">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57521.Banka'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput name="bank" type="text" value="#get_company_securefund.bank#" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-money">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58930.Masraf'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="expense_total" id="expense_total" value="#tlformat(get_company_securefund.expense_total)#" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
									<span class="input-group-addon width">
										<select name="money_cat_expense" id="money_cat_expense">
											<cfoutput query="get_money_rate">
												<option value="#money#"<cfif money is '#get_company_securefund.money_cat_expense#'> selected</cfif>>#money#</option>
											</cfoutput>
										</select>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-finish_date">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
									<cfinput name="finish_date" type="text" value="#dateformat(get_company_securefund.finish_date,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#"> 
									<span class="input-group-addon">
										<cf_wrk_date_image date_field="finish_date">
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-mortgage_owner">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52069.İpotek Sahibi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="mortgage_owner" id="mortgage_owner" maxlength="100" value="#get_company_securefund.mortgage_owner#">
							</div>
						</div>
						<div class="form-group" id="item-expert_money_type">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52072.Expertiz Değeri'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="expert_total" id="expert_total" value="#tlformat(get_company_securefund.expert_total)#" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
									<span class="input-group-addon width">
										<select name="expert_money_type" id="expert_money_type">
											<cfoutput query="get_money_rate">
												<option value="#money#"  <cfif get_company_securefund.expert_money_currency eq money>selected</cfif>>#money#</option>
											</cfoutput>
										</select>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-mortgage_bank_dept">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52514.Banka Borcu'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="mortgage_bank_dept" id="mortgage_bank_dept" value="#tlformat(get_company_securefund.mortgage_bank_dept)#" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
									<span class="input-group-addon width">
										<select name="bank_money_type" id="bank_money_type">
											<cfoutput query="get_money_rate">
												<option value="#money#" <cfif session.ep.money is '#money#'>selected</cfif>>#money#</option>
											</cfoutput>
										</select>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-mortgage_total2">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52517.İpotek Tutarı'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="mortgage_total2" id="mortgage_total2" value="#tlformat(get_company_securefund.mortgage_total2)#" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
									<span class="input-group-addon width">
										<select name="mortgage_money_type2" id="mortgage_money_type2">
											<cfoutput query="get_money_rate">
												<option value="#money#" <cfif session.ep.money is '#money#'>selected</cfif>>#money#</option>
											</cfoutput>
										</select>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-realestate_detail">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="realestate_detail" id="realestate_detail" maxlength="500" onKeyUp="return ismaxlength(this);" onBlur="return ismaxlength(this);" message="<cf_get_lang dictionary_id='56882.500 Karakterden Fazla Yazmayınız!!'>" style="width:430px;height:80px;"></textarea>
							</div>
						</div>
					</div>
				</cf_box_elements>	
						<div class="col col-12">
						<cfset form_branch_id = get_company_securefund.branch_id>
						<cfset form_company_id = get_company_securefund.company_id>
						<cfinclude template="../display/dsp_member_branch_risk_info.cfm"></div>
					
				<cfquery name="GET_RESULT" datasource="#DSN#">
					SELECT 
						PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
						PROCESS_TYPE_ROWS.LINE_NUMBER LINE_NUMBER
					FROM
						PROCESS_TYPE PROCESS_TYPE,
						PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
						PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS,
						PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID,
						EMPLOYEE_POSITIONS EMPLOYEE_POSITIONS
					WHERE
						PROCESS_TYPE.IS_ACTIVE = 1 AND
						PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
						PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
						PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
						<cfif database_type is 'MSSQL'>
							CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE '%crm.popup_upd_securefund,%' AND
						<cfelseif database_type is 'DB2'>
							CAST(PROCESS_TYPE.FACTION AS VARGRAPHIC(2500))||',' LIKE '%crm.popup_upd_securefund,%' AND
						</cfif>									
						EMPLOYEE_POSITIONS.POSITION_CODE = #session.ep.position_code# AND 
						PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
						EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID
					UNION
					SELECT DISTINCT
						PROCESS_TYPE_ROWS.PROCESS_ROW_ID ,
						PROCESS_TYPE_ROWS.LINE_NUMBER LINE_NUMBER
					FROM 	
						PROCESS_TYPE  AS PROCESS_TYPE,
						PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
						PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS,
						PROCESS_TYPE_ROWS_WORKGRUOP AS PROCESS_TYPE_ROWS_WORKGRUOP,
						PROCESS_TYPE_ROWS_POSID AS PROCESS_TYPE_ROWS_POSID
					WHERE
						PROCESS_TYPE.IS_ACTIVE = 1 AND
						PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND
						PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
						PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
						<cfif database_type is 'MSSQL'>
							CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE '%crm.popup_upd_securefund,%' AND
						<cfelseif database_type is 'DB2'>
							CAST(PROCESS_TYPE.FACTION AS VARGRAPHIC(2500))||',' LIKE '%crm.popup_upd_securefund,%' AND
						</cfif>											 
							PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID  AND 
							PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND 
							PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID AND 
							PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID IN (#session.ep.position_code#)
					ORDER BY 
						LINE_NUMBER
				</cfquery>
				<div class="col col-12">
					<cf_box_footer>
						<cfif len(get_company_securefund.is_submit) and get_company_securefund.is_submit eq 1>
							<cfif (listfind(valuelist(get_result.process_row_id,','),389,',') gt 0) or (listfind(valuelist(get_result.process_row_id,','),391,',') gt 0)>
								<cf_workcube_buttons is_upd='1' delete_page_url = '#request.self#?fuseaction=crm.emptypopup_del_securefund&oldsecurefund_file=#get_company_securefund.securefund_file#&securefund_id=#attributes.securefund_id#' del_function_for_submit="kontrol_del()" add_function="kontrol()">
							</cfif>
						<cfelse>
							<cf_workcube_buttons is_upd='1' delete_page_url = '#request.self#?fuseaction=crm.emptypopup_del_securefund&oldsecurefund_file=#get_company_securefund.securefund_file#&securefund_id=#attributes.securefund_id#' del_function_for_submit="kontrol_del()" add_function="kontrol()">
						</cfif>
					</cf_box_footer>
				</div>
			</cfform>				
		</cf_box>
	</div>
	<div class="col col-3 col-md-3 col-sm-12 col-xs-12">
		<!--- Notlar --->
		<cf_get_workcube_note action_section='SECUREFUND_ID' action_id='#attributes.securefund_id#'>
		<!--- Varliklar --->
		<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-7" module_id='52' action_section='SECUREFUND_ID' action_id='#attributes.securefund_id#'>
		<cf_box id="member_frame" title="#getLang('','Genel Bilgiler','57980')#" box_page="#request.self#?fuseaction=crm.popup_dsp_teminat_info&cpid=#get_company_securefund.company_id#&iframe=1&branch_id=#get_company_securefund.branch_id#"></cf_box>
	</div>
</div>
	
<script type="text/javascript">
function kontrol()
{
	x = document.add_secure.securefund_cat_id.selectedIndex;
	if (document.add_secure.securefund_cat_id[x].value == "")
	{ 
		alert ("<cf_get_lang no='629.Teminat Kategorisi Seçiniz'> !");
		return false;
	}
	if(document.add_secure.securefund_total.value == "")
	{
		alert("<cf_get_lang_main no='1738.Lutfen Tutar Giriniz'>");
		return false;
	}
	if (document.add_secure.securefund_cat_id.value == 2) // Ep: 2  / Hedef: 21
	{
		if (document.add_secure.mortgage_type.value == "")
		{
			alert("<cf_get_lang dictionary_id='31853.Lütfen Nevi Değerini Seçiniz'>");
			return false;
		}
		if(document.add_secure.mortgage_rate.value >= 2)
		{
			if (document.add_secure.mortgage_bank_dept.value == "")
			{
				alert("<cf_get_lang dictionary_id='31851.Lütfen Banka Borcunu Giriniz'>!");
				return false;
			}
			if(document.add_secure.mortgage_total2.value == "")
			{
				alert("<cf_get_lang dictionary_id='31850.Lütfen İpotek Tutarını Giriniz'>!");
				return false;
			}
			if(document.add_secure.mortgage_bank.value == "")
			{
				alert("<cf_get_lang dictionary_id='31842.Lütfen İpotek Bankasını Giriniz'>!");
				return false;
			}	
		}
	}			
	if(document.add_secure.realestate_detail.value == "")
	{
		alert("<cf_get_lang no='619.Lütfen Açıklama Giriniz'> !");
		return false;
	}
	return unformat_fields();
}
function kontrol_del()
{
	return process_cat_control();
}
function unformat_fields()
{
	document.add_secure.securefund_total.value = filterNum(document.add_secure.securefund_total.value);
	document.add_secure.expense_total.value = filterNum(document.add_secure.expense_total.value);
	document.add_secure.mortgage_total.value = filterNum(document.add_secure.mortgage_total.value);
	document.add_secure.expert_total.value = filterNum(document.add_secure.expert_total.value);
	document.add_secure.mortgage_bank_dept.value = filterNum(document.add_secure.mortgage_bank_dept.value);
	document.add_secure.mortgage_total2.value = filterNum(document.add_secure.mortgage_total2.value);
	return process_cat_control();
}	
</script>
