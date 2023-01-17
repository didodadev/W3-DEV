<cf_get_lang_set module_name="ch">
<cf_papers paper_type="cari_to_cari">
<cf_xml_page_edit fuseact="ch.form_collacted_cari_virman">
<cfparam name="attributes.money_type_control" default="">
<cfparam name="attributes.currency_id_info" default="">
<cfset to_branch_id = ''>
<cfset select_input = 'action_currency_id'>
<cfset row_count = 0>
<cfif isDefined("attributes.upd_id")>
    <cfquery name="GET_MONEY" datasource="#DSN2#">
        SELECT
            MONEY_TYPE MONEY,
            RATE2,
            RATE1,
            ISNULL(IS_SELECTED,0) AS IS_SELECTED
        FROM
            CARI_ACTION_MULTI_MONEY
        WHERE
        	ACTION_ID = #attributes.upd_id#
        ORDER BY 
            MONEY_TYPE
    </cfquery>
    <cfquery name="get_action_detail" datasource="#dsn2#">
        SELECT * FROM CARI_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #attributes.upd_id# AND ACTION_TYPE_ID = 430
    </cfquery>
<cfelse>
    <cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT
            MONEY,
            RATE2,
            RATE1,
            0 AS IS_SELECTED
        FROM
            SETUP_MONEY
        WHERE
            PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
            MONEY_STATUS = 1
            <cfif isDefined('attributes.money') and len(attributes.money)>
                AND MONEY_ID = #attributes.money#
            </cfif>
        ORDER BY 
            MONEY_ID
    </cfquery>
</cfif>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT * FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID=#session.ep.company_id#
</cfquery>
<div id="collacted_virman" style="margin-left:1000px; margin-top:15px; position:absolute;display:none;z-index:9999;"></div>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_process">
			<cf_basket_form id="collacted_virman">
				<input type="hidden" name="upd_id" id="upd_id" value="<cfif isDefined('attributes.upd_id')><cfoutput>#attributes.upd_id#</cfoutput></cfif>">
				<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
				<input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>">
				<input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delMulti" />
				<select name="action_currency_id" id="action_currency_id" style="display:none">
					<option value="1;<cfoutput>#session.ep.money#</cfoutput>" selected></option>
				</select>
				<cf_box_elements>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-action_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="action_date" value="#dateformat(now(),dateformat_style)#" maxlength="10" validate="#validate_style#" required="Yes" message="#message#" onBlur="change_money_info('add_process','action_date');">
									<span class="input-group-addon">
											<cf_wrk_date_image date_field="action_date" call_function="change_money_info">
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined('get_action_detail')>
									<cf_workcube_process_cat process_cat="#get_action_detail.process_cat#">
								<cfelse>
									<cf_workcube_process_cat>
								</cfif>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-12 text-right">
						<cfif isDefined('attributes.upd_id')>
							<cf_record_info query_name="get_action_detail">
							<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=ch.form_add_cari_to_cari&event=delMulti&del_id=#attributes.upd_id#&active_period=#session.ep.period_id#'>
						<cfelse>
							<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
						</cfif>
					</div>
				</cf_box_footer>
			</cf_basket_form>
			<cf_basket id="collacted_virman_sepet">
				<cf_grid_list>
					<thead>
						<tr>
							<th width="20"><a href="javascript://" onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57880.Belge No'></th>
							<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='50160.Borçlu Hesap'> *</th>
							<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='34115.Alacaklı Hesap'> *</th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'>*</th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='58864.Para Br.'></th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id ="57587.Borç"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id="57588.Alacak"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57629.Açıklama'></th>
							<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='58180.Borçlu'> <cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
							<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='50129.Alacaklı'> <cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
							<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='58180.Borçlu'> <cf_get_lang dictionary_id ='29502.Abone No'></th>
							<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='50129.Alacaklı'> <cf_get_lang dictionary_id ='29502.Abone No'></th>
							<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='58180.Borçlu'> <cf_get_lang dictionary_id='57416.Proje'></th>
							<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='50129.Alacaklı'> <cf_get_lang dictionary_id='57416.Proje'></th>
							<cfif isDefined('x_show_branch') and x_show_branch eq 1>
								<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='58180.Borçlu'> <cf_get_lang dictionary_id='57453.Şube'></th>
								<th nowrap="nowrap" width="150"><cf_get_lang dictionary_id='50129.Alacaklı'> <cf_get_lang dictionary_id='57453.Şube'></th>
							</cfif>
						</tr>
					</thead>
					<tbody id="table1" name="table1">
					<cfif (isDefined('attributes.upd_id') and len(attributes.upd_id)) or (isDefined('attributes._copy_id') and len(attributes._copy_id))>
						<cfif isDefined('attributes.upd_id')>
							<cfset multi_id = attributes.upd_id>
						<cfelseif isDefined('attributes._copy_id')>
							<cfset multi_id = attributes._copy_id>
						</cfif>
						<cfquery name="get_multi" datasource="#dsn2#">
							SELECT * FROM CARI_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #multi_id#
						</cfquery>
						<cfquery name="get_rows" datasource="#dsn2#">
							SELECT
								CA.ACTION_ID,
								CA.ACTION_VALUE,
								CA.ACTION_CURRENCY_ID,
								CA.OTHER_CASH_ACT_VALUE,
								CA.OTHER_MONEY,
								CA.ACTION_DATE,
								CA.DUE_DATE,
								CA.FROM_DUE_DATE,
								CA.ACTION_DETAIL,
								CA.PAPER_NO,
								CASE 
									WHEN C.FULLNAME IS NOT NULL THEN C.FULLNAME
									WHEN CNS.CONSUMER_NAME + ' ' + CNS.CONSUMER_SURNAME IS NOT NULL THEN CNS.CONSUMER_NAME + ' ' + CNS.CONSUMER_SURNAME
									WHEN EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME + ' - ' + TO_SAT.ACC_TYPE_NAME IS NOT NULL THEN EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME + ' - ' + TO_SAT.ACC_TYPE_NAME
									WHEN EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME IS NOT NULL THEN EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME
								END AS TO_COMP_NAME,
								CASE
									WHEN C2.FULLNAME IS NOT NULL THEN C2.FULLNAME
									WHEN CNS2.CONSUMER_NAME + ' ' + CNS2.CONSUMER_SURNAME IS NOT NULL THEN CNS2.CONSUMER_NAME + ' ' + CNS2.CONSUMER_SURNAME
									WHEN EMP2.EMPLOYEE_NAME + ' ' + EMP2.EMPLOYEE_SURNAME + ' - ' +FROM_SAT.ACC_TYPE_NAME IS NOT NULL THEN EMP2.EMPLOYEE_NAME + ' ' + EMP2.EMPLOYEE_SURNAME + ' - ' +FROM_SAT.ACC_TYPE_NAME
									WHEN EMP2.EMPLOYEE_NAME + ' ' + EMP2.EMPLOYEE_SURNAME IS NOT NULL THEN EMP2.EMPLOYEE_NAME + ' ' + EMP2.EMPLOYEE_SURNAME
								END AS FROM_COMP_NAME,
								CA.FROM_BRANCH_ID,
								CA.TO_BRANCH_ID,
								FROM_AP.ASSETP FROM_ASSET_NAME,
								TO_AP.ASSETP TO_ASSET_NAME,
								FROM_PR.PROJECT_HEAD FROM_PROJECT_HEAD,
								TO_PR.PROJECT_HEAD TO_PROJECT_HEAD,
								CA.SUBSCRIPTION_ID,
								(SELECT SUBSCRIPTION_NO FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID =CA.SUBSCRIPTION_ID ) AS SUBSCRIPTION_NO,
								CA.TO_SUBSCRIPTION_ID,
								(SELECT SUBSCRIPTION_NO FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID =CA.TO_SUBSCRIPTION_ID ) AS TO_SUBSCRIPTION_NO,
								CA.TO_CMP_ID,
								CA.FROM_CMP_ID,
								CA.TO_CONSUMER_ID,
								CA.FROM_CONSUMER_ID,
								CA.TO_EMPLOYEE_ID,
								CA.FROM_EMPLOYEE_ID,
								CA.ACC_TYPE_ID,
								CA.FROM_ACC_TYPE_ID,
								CA.ASSETP_ID,
								CA.ASSETP_ID_2,
								CA.PROJECT_ID FROM_PROJECT_ID,
								CA.PROJECT_ID_2 TO_PROJECT_ID
							FROM
								CARI_ACTIONS CA
								LEFT JOIN #dsn_alias#.COMPANY C ON CA.TO_CMP_ID = C.COMPANY_ID
								LEFT JOIN #dsn_alias#.COMPANY C2 ON CA.FROM_CMP_ID = C2.COMPANY_ID
								LEFT JOIN #dsn_alias#.CONSUMER CNS ON CA.TO_CONSUMER_ID = CNS.CONSUMER_ID
								LEFT JOIN #dsn_alias#.CONSUMER CNS2 ON CA.FROM_CONSUMER_ID = CNS2.CONSUMER_ID
								LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON CA.TO_EMPLOYEE_ID = EMP.EMPLOYEE_ID
								LEFT JOIN #dsn_alias#.EMPLOYEES EMP2 ON CA.FROM_EMPLOYEE_ID = EMP2.EMPLOYEE_ID
								LEFT JOIN #dsn_alias#.ASSET_P FROM_AP ON CA.ASSETP_ID = FROM_AP.ASSETP_ID
								LEFT JOIN #dsn_alias#.ASSET_P TO_AP ON CA.ASSETP_ID_2 = TO_AP.ASSETP_ID
								LEFT JOIN #dsn_alias#.PRO_PROJECTS FROM_PR ON CA.PROJECT_ID = FROM_PR.PROJECT_ID
								LEFT JOIN #dsn_alias#.PRO_PROJECTS TO_PR ON CA.PROJECT_ID_2 = TO_PR.PROJECT_ID
								LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE FROM_SAT ON CA.FROM_ACC_TYPE_ID = FROM_SAT.ACC_TYPE_ID
								LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE TO_SAT ON CA.ACC_TYPE_ID = TO_SAT.ACC_TYPE_ID
							WHERE
								MULTI_ACTION_ID = #multi_id# AND ACTION_TYPE_ID = 43
						</cfquery>
						<cfset row_count = get_rows.recordcount>
						<cfif get_multi.recordcount eq 0>
							<script language="javascript">
								alert("<cf_get_lang dictionary_id ='58943.Böyle Bir Kayıt Bulunmamaktadır'>");
								window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=ch.form_add_cari_to_cari&event=addMulti";
							</script>
						</cfif>
						<script type="text/javascript">
							document.getElementById('action_date').value = '<cfoutput>#dateformat(get_multi.ACTION_DATE,dateformat_style)#</cfoutput>';
							document.getElementById('process_cat').value = '<cfoutput>#get_multi.PROCESS_CAT#</cfoutput>';		
							//add_row(paper_number,from_member_type,from_company_id,from_consumer_id,from_employee_id,to_member_type,to_company_id,to_consumer_id,to_employee_id,system_value,action_value,action_value2,currency_id,action_date,action_detail,to_asset_id,from_asset_id,to_project_id,from_project_id,to_branch_id,from_branch_id);
						</script>
						<cfoutput query="get_rows">
							<cfif len(acc_type_id) and len(to_employee_id)>
								<cfset to_employee = to_employee_id & "_" & acc_type_id>
							<cfelse>
								<cfset to_employee = to_employee_id>
							</cfif>
							<cfif len(from_acc_type_id) and len(from_employee_id)>
								<cfset from_employee = from_employee_id & "_" & from_acc_type_id>
							<cfelse>
								<cfset from_employee = from_employee_id>
							</cfif>
							<cfif len(acc_type_id) and len(to_cmp_id)>
								<cfset to_cmp = to_cmp_id & "_" & acc_type_id>
							<cfelse>
								<cfset to_cmp = to_cmp_id>
							</cfif>
							<cfif len(from_acc_type_id) and len(from_cmp_id)>
								<cfset from_cmp = from_cmp_id & "_" & from_acc_type_id>
							<cfelse>
								<cfset from_cmp = from_cmp_id>
							</cfif>
							<cfif len(acc_type_id) and len(to_consumer_id)>
								<cfset to_consumer = to_consumer_id & "_" & acc_type_id>
							<cfelse>
								<cfset to_consumer = to_consumer_id>
							</cfif>
							<cfif len(from_acc_type_id) and len(from_consumer_id)>
								<cfset from_consumer = from_consumer_id & "_" & from_acc_type_id>
							<cfelse>
								<cfset from_consumer = from_consumer_id>
							</cfif>
							<script type="text/javascript">
								<cfif isDefined("attributes._copy_id")>
									paper_number = '';
								<cfelse>
									paper_number = '#get_rows.PAPER_NO#';
								</cfif>
								//add_row(paper_number,from_company_id,from_consumer_id,from_employee_id,to_company_id,to_consumer_id,to_employee_id,action_value,action_value2,currency_id,action_date,action_detail,to_asset_id,from_asset_id,to_project_id,from_project_id,to_branch_id,from_branch_id);
							</script>
					
							<tr id="frm_row#currentrow#">
								<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"  value="1" />
								<input type="hidden" name="row_id#currentrow#" id="row_id#currentrow#" value="#action_id#" />
								<td nowrap="nowrap"  style="text-align:right; width:35px;">
									<ul class="ui-icon-list">
										<li><a href="javascript://" onclick="sil('#currentrow#');"><i class="fa fa-minus"></i></a></li>
										<li><a style="cursor:pointer" onclick="copy_row('#currentrow#');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li>
									</ul>
								</td>
								<td nowrap="nowrap" >
									<cfif isdefined("attributes._copy_id")>
										<input type="text" name="paper_number#currentrow#" id="paper_number#currentrow#" value="#paper_code#-#paper_number+currentrow-1#" class="boxtext" style="width:120px;"/>
									<cfelse>
										<input type="text" name="paper_number#currentrow#" id="paper_number#currentrow#" value="#paper_no#" class="boxtext" style="width:120px;"/>
									</cfif>
								</td>
								<td nowrap="nowrap" >
									<input type="hidden" name="to_company_id#currentrow#" id="to_company_id#currentrow#"  value="#to_cmp#">
									<input type="hidden" name="to_consumer_id#currentrow#" id="to_consumer_id#currentrow#"  value="#to_consumer#">
									<input type="hidden" name="to_employee_id#currentrow#" id="to_employee_id#currentrow#"  value="#to_employee#">
									<input type="text" name="to_comp_name#currentrow#" id="to_comp_name#currentrow#" value="#to_comp_name#" style="width:162px;"  class="boxtext" onFocus="AutoComplete_Create('comp_name#currentrow#','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','','ACCOUNT_CODE,MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','member_code#currentrow#,member_type#currentrow#,action_company_id#currentrow#,action_consumer_id#currentrow#,action_employee_id#currentrow#','','3','250','emp_comp_and_account#currentrow#');">
									<a href="javascript://" onClick="pencere_ac_to_company(#currentrow#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>
								</td>
								<td nowrap="nowrap">
									<input type="hidden" name="from_company_id#currentrow#" id="from_company_id#currentrow#"  value="#from_cmp#">
									<input type="hidden" name="from_consumer_id#currentrow#" id="from_consumer_id#currentrow#"  value="#from_consumer#">
									<input type="hidden" name="from_employee_id#currentrow#" id="from_employee_id#currentrow#"  value="#from_employee#">
									<input type="text" name="from_comp_name#currentrow#" id="from_comp_name#currentrow#" value="#from_comp_name#" style="width:162px;"  class="boxtext" onFocus="AutoComplete_Create('comp_name#currentrow#','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','','ACCOUNT_CODE,MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','member_code#currentrow#,member_type#currentrow#,action_company_id#currentrow#,action_consumer_id#currentrow#,action_employee_id#currentrow#','','3','250','emp_comp_and_account#currentrow#');">
									<a href="javascript://" onClick="pencere_ac_from_company(#currentrow#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>
								</td>
								<td nowrap="nowrap">
									<input type="text" name="action_value_#currentrow#" id="action_value_#currentrow#" value="#tlFormat(action_value)#" onkeyup="return(FormatCurrency(this,event));" onBlur="kur_ekle_f_hesapla('#action_currency_id#',false,#currentrow#);" float:"right;" class="box">
								</td>
								<td nowrap="nowrap">
									<div class="form-group">
										<select name="money_id#currentrow#" id="money_id#currentrow#" style="width:100%;" class="boxtext" onChange="kur_ekle_f_hesapla('#action_currency_id#',false,#currentrow#);">
											<cfloop query="get_money">
													<option value="#get_money.money#;#get_money.rate1#;#filterNum(tlformat(get_money.rate2,rate_round_num_info),rate_round_num_info)#" <cfif get_money.money eq get_rows.ACTION_CURRENCY_ID> selected</cfif>>#get_money.money#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<td nowrap="nowrap">
									<input type="text" name="action_value2_#currentrow#" id="action_value2_#currentrow#" value="#TlFormat(OTHER_CASH_ACT_VALUE)#" onkeyup="return(FormatCurrency(this,event));" class="box" onBlur="kur_ekle_f_hesapla('#action_currency_id#',true,#currentrow#);">
								</td>
								<td id="due_date#currentrow#_td" nowrap="nowrap">
									<input type="text" id="due_date#currentrow#" name="due_date#currentrow#" class="text" maxlength="10" style="width:65px;" value="#dateFormat(due_date,dateformat_style)#"> 
									<cf_wrk_date_image date_field="due_date#currentrow#">
								</td>
								<td id="from_due_date#currentrow#_td" nowrap="nowrap">
									<input type="text" id="from_due_date#currentrow#" name="from_due_date#currentrow#" class="text" maxlength="10" style="width:65px;" value="#dateFormat(from_due_date,dateformat_style)#"> 
									<cf_wrk_date_image date_field="from_due_date#currentrow#">
								</td>
								<td nowrap="nowrap">
									<input type="text" name="action_detail#currentrow#" id="action_detail#currentrow#" value="#action_detail#" style="width:130px;" class="boxtext">
								</td>
								<td nowrap="nowrap">
									<input type="hidden" id="to_asset_id#currentrow#" name="to_asset_id#currentrow#" value="#ASSETP_ID_2#"><input type="text" id="to_asset_name#currentrow#" name="to_asset_name#currentrow#" value="#to_asset_name#" style="width:150px;" class="boxtext" onFocus="autocomp_to_asset(#currentrow#);"><a href="javascript://" onClick="pencere_ac_to_asset(#currentrow#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
								</td>
								<td nowrap="nowrap">
									<input type="hidden" id="from_asset_id#currentrow#" name="from_asset_id#currentrow#" value="#ASSETP_ID#"><input type="text" id="from_asset_name#currentrow#" name="from_asset_name#currentrow#" value="#from_asset_name#" style="width:150px;" class="boxtext" onFocus="autocomp_from_asset(#currentrow#);"><a href="javascript://" onClick="pencere_ac_from_asset(#currentrow#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
								</td>
								<td nowrap>
									<input type="hidden" name="subscription_id#currentrow#" value="#subscription_id#" id="subscription_id#currentrow#" />
									<input type="text" name="subscription_no#currentrow#" value="#subscription_no#" id="subscription_no#currentrow#" style="width:143px;" /><a href="javascript://" onClick="open_subscription('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>	
								</td>
								<td nowrap>
									<input type="hidden" name="subscription_id2#currentrow#" value="#to_subscription_id#" id="subscription_id2#currentrow#" />
									<input type="text" name="subscription_no2#currentrow#" value="#to_subscription_no#" id="subscription_no2#currentrow#" style="width:143px;" /><a href="javascript://" onClick="open_subscription2('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>	
								</td>
								<td nowrap="nowrap">
									<input type="hidden" name="to_project_id#currentrow#" id="to_project_id#currentrow#" value="#to_project_id#"><input type="text" style="width:143px;" name="to_project_head#currentrow#" id="to_project_head#currentrow#" onFocus="autocomp_to_project(#currentrow#);" value="#( to_project_id eq -1 ) ? '#getLang('main','Projesiz',58459)#' : to_project_head#" class="boxtext"><a href="javascript://" onClick="pencere_ac_to_project(#currentrow#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>
								</td>
								<td nowrap="nowrap">
									<input type="hidden" name="from_project_id#currentrow#" id="from_project_id#currentrow#" value="#from_project_id#"><input type="text" style="width:143px;" name="from_project_head#currentrow#" id="from_project_head#currentrow#" onFocus="autocomp_from_project(#currentrow#);" value="#( from_project_id eq -1 ) ? '#getLang('main','Projesiz',58459)#' : from_project_head#" class="boxtext"><a href="javascript://" onClick="pencere_ac_from_project(#currentrow#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>
								</td>
								<cfif isDefined('x_show_branch') and x_show_branch eq 1>
									<td nowrap="nowrap">
										<select name="to_branch_id#currentrow#" id="to_branch_id#currentrow#" style="width:100%;" class="boxtext">
											<option value="">Seçiniz</option>
											<cfloop query="get_branches">
													<option value="#get_branches.branch_id#" <cfif get_branches.branch_id eq get_rows.to_branch_id> selected</cfif>>#branch_name#</option>
											</cfloop>
										</select>
									</td>
									<td nowrap="nowrap">
										<select name="from_branch_id#currentrow#" id="from_branch_id#currentrow#" style="width:100%;" class="boxtext">
											<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
											<cfloop query="get_branches">
													<option value="#get_branches.branch_id#" <cfif get_branches.branch_id eq get_rows.from_branch_id>selected</cfif>>#branch_name#</option>
											</cfloop>
										</select>  
									</td>
								<cfelse>
									<input type="hidden" name="to_branch_id#currentrow#" id="to_branch_id#currentrow#" value="">
									<input type="hidden" name="from_branch_id#currentrow#" id="from_branch_id#currentrow#" value="">
								</cfif>
							</tr>
						</cfoutput>
					</cfif>
					</tbody>
				</cf_grid_list>
				<cf_basket_footer height="100">
					<input name="record_num" id="record_num" type="hidden" value="0">
					<div class="ui-row">
                        <div id="sepetim_total" class="padding-0">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='57677.Dövizler'></span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
                                        <table cellspacing="0">
											<tbody>
												<cfoutput>
													<input id="kur_say" type="hidden" name="kur_say" value="#get_money.recordcount#">
													<cfloop query="get_money">                
														<cfif is_selected eq 1><cfset str_money_bskt_main = money></cfif>
														<tr>
															<td>
																<cfif session.ep.rate_valid eq 1>
																	<cfset readonly_info = "yes">
																<cfelse>
																	<cfset readonly_info = "no">
																</cfif>
																<input type="hidden" name="hidden_rd_money_#currentrow#" value="#money#" id="hidden_rd_money_#currentrow#">
																<input type="hidden" name="txt_rate1_#currentrow#" value="#rate1#" id="txt_rate1_#currentrow#">
																<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onchange="kur_ekle_f_hesapla('#money#',false);" onClick="toplam_hesapla();" <cfif is_selected eq 1 or (not isdefined("upd_id") and money eq session.ep.money)>checked</cfif>>#money#
															</td>
															<td valign="bottom">#TLFormat(rate1,0)#/<input type="text" class="box" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,rate_round_num_info)#" style="width:50px;" onKeyUp="return(FormatCurrency(this,event,'#rate_round_num_info#'));" onBlur="if(filterNum(this.value,rate_round_num_info) <=0) this.value=commaSplit(1);"></td>
														</tr>
													</cfloop>
												</cfoutput>     
											</tbody>
										</table>
                                    </div>
                                </div>
                            </div>
							<div class="col col-2 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table cellspacing="0">
											<tbody>
												<tr>
													<td style="text-align:right;">
														<input type="text" name="total_amount" class="box" readonly value="0" id="total_amount">&nbsp;
														<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="readonly" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:40px;">
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</cf_basket_footer>
			</cf_basket>
		</cfform>
	</cf_box>
</div>
<cfscript>
	CreateComponent = CreateObject("component","/../workdata/getAccounts");
	queryResult = CreateComponent.getCompenentFunction(is_system_money:0,money_type_control:attributes.money_type_control,is_branch_control:0,control_status:1,is_open_accounts:0,currency_id_info:attributes.currency_id_info);	
</cfscript>
<script type="text/javascript">
	<cfoutput>
		<cfif not (len(paper_code) and len(paper_number))>
			var auto_paper_code = "";
			var auto_paper_number = "";
		<cfelse>
			var auto_paper_code = "#paper_code#-";
			<cfif isdefined("attributes._copy_id")>
				var auto_paper_number = "#paper_number+row_count#";
			<cfelse>
				var auto_paper_number = "#paper_number#";
			</cfif>
		</cfif>
		row_count = #row_count#;
		document.getElementById('record_num').value=row_count;
	</cfoutput>
	record_exist=0;

	function sil(sy)
	{
		var my_element=document.getElementById('row_kontrol'+sy);	
		my_element.value=0;		
		var my_element=eval("frm_row"+sy);	
		my_element.style.display="none";
		toplam_hesapla();		
	}

	function open_subscription(sira_no){
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=add_process.subscription_id'+ sira_no +'&field_no=add_process.subscription_no'+ sira_no);
	}
	function open_subscription2(sira_no){
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=add_process.subscription_id2'+ sira_no +'&field_no=add_process.subscription_no2'+ sira_no);
	}

	function add_row(paper_number,from_company_id,from_consumer_id,from_employee_id,to_company_id,to_consumer_id,to_employee_id,action_value,action_value2,currency_id,due_date,from_due_date,action_detail,to_asset_id,from_asset_id,to_project_id,from_project_id,to_branch_id,from_branch_id,subscription_id,subscription_id2)
	{
		if(paper_number == undefined) paper_number = '';
		
		if(from_company_id == undefined) from_company_id = '';
		if(from_consumer_id == undefined) from_consumer_id = '';
		if(from_employee_id == undefined) from_employee_id = '';
		
		from_comp_name = '';
		if(from_company_id != ''){
			get_comp_name = wrk_safe_query('cst_get_company','dsn',0,from_company_id);
			from_comp_name = get_comp_name.FULLNAME;
		}
		else if(from_consumer_id != ''){
			get_cons_name = wrk_safe_query('obj_get_cons_name','dsn',0,from_consumer_id);
			from_comp_name = get_cons_name.CONSUMER_NAME + ' ' + get_cons_name.CONSUMER_SURNAME;
		}
		else if(from_employee_id != ''){
			get_emp_name = wrk_safe_query('hr_get_emp_name','dsn',0,from_employee_id);
			from_comp_name = get_emp_name.NAME;
		}
		
		to_comp_name = '';
		if(to_company_id == undefined) to_company_id = '';
		if(to_consumer_id == undefined) to_consumer_id = '';
		if(to_employee_id == undefined) to_employee_id = '';

		if(to_company_id != ''){
			get_comp_name = wrk_safe_query('cst_get_company','dsn',0,to_company_id);
			to_comp_name = get_comp_name.FULLNAME;
		}
		else if(to_consumer_id != ''){
			get_cons_name = wrk_safe_query('obj_get_cons_name','dsn',0,to_consumer_id);
			to_comp_name = get_cons_name.CONSUMER_NAME + ' ' + get_cons_name.CONSUMER_SURNAME;
		}
		else if(to_employee_id != ''){
			get_emp_name = wrk_safe_query('hr_get_emp_name','dsn',0,to_employee_id);
			to_comp_name = get_emp_name.NAME;
		}

		if(action_value == undefined) action_value = 0;
		if(action_value2 == undefined) action_value2 = 0;
		if(currency_id == undefined) currency_id = '';

		if(due_date == undefined) due_date = <cfoutput>"#dateformat(now(),dateformat_style)#"</cfoutput>;

		if(from_due_date == undefined) from_due_date = '';
		
		if(action_detail == undefined) action_detail = '';

		if(to_asset_id == undefined) to_asset_id = ''; to_asset_name = '';
		to_asset_name = '';
		if(to_asset_id != '')
		{
			get_asset_name = wrk_safe_query('obj_get_pro_name_2','dsn',0,to_asset_id);
			to_asset_name = get_asset_name.ASSETP;
		}
		if(from_asset_id == undefined) from_asset_id = ''; from_asset_name = '';
		from_asset_name = '';
		if(from_asset_id != '')
		{
			get_asset_name = wrk_safe_query('obj_get_pro_name_2','dsn',0,from_asset_id);
			from_asset_name = get_asset_name.ASSETP;
		}
		
		if(to_project_id == undefined || to_project_id==''){
			to_project_id = '';
			to_project_head = '';
		}else if( to_project_id == -1 ){
			to_project_head = "<cfoutput>#getLang('main','Projesiz',58459)#</cfoutput>";
		}
		else if(to_project_id != '')
		{
			get_project_head = wrk_safe_query('obj_get_pro_name','dsn',0,to_project_id);
			to_project_head = get_project_head.PROJECT_HEAD;
		}
		
		if(from_project_id == undefined || from_project_id==''){
			from_project_id = '';
			from_project_head = '';
		} 
		else if(from_project_id == -1){
			from_project_head = "<cfoutput>#getLang('main','Projesiz',58459)#</cfoutput>";
		}
		else if(from_project_id != ''){
			get_project_head = wrk_safe_query('obj_get_pro_name','dsn',0,from_project_id);
			from_project_head = get_project_head.PROJECT_HEAD;
		}
		
		if(to_branch_id == undefined) to_branch_id = ''; to_branch_head = '';
		if(from_branch_id == undefined) from_branch_id = ''; from_branch_head = '';

		if(subscription_id == undefined) subscription_id = ''; subscription_no = '';
		if(subscription_id2== undefined) subscription_id2 = ''; subscription_no2 = '';

		row_count++;
		var newRow;
		var newCell;	
		document.getElementById('record_num').value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.className = 'color-row';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<cfif not isDefined('x_show_branch') or (isDefined('x_show_branch') and x_show_branch eq 0)><input type="hidden" name="to_branch_id' + row_count +'" id="to_branch_id' + row_count + '" value=""><input type="hidden" name="from_branch_id' + row_count +'" id="from_branch_id' + row_count + '" value=""></cfif><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" name="row_id' + row_count +'" id="row_id' + row_count +'"  value="0"><ul class="ui-icon-list"><li><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a></li><li><a style="cursor:pointer" onclick="copy_row('+row_count+');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li></ul>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		if(!paper_number)
			paper_number = auto_paper_code + auto_paper_number;
		newCell.innerHTML = '<input type="text" name="paper_number' + row_count +'" id="paper_number' + row_count +'" value="'+paper_number+'" class="boxtext">';
		if(auto_paper_number != '')
			auto_paper_number++;
		// borçlu hesap
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML += '<input type="hidden" name="to_company_id' + row_count +'" id="to_company_id' + row_count +'"  value="'+to_company_id+'"><input type="hidden" name="to_consumer_id' + row_count +'" id="to_consumer_id' + row_count +'"  value="'+to_consumer_id+'"><input type="hidden" name="to_employee_id' + row_count +'" id="to_employee_id' + row_count +'"  value="'+to_employee_id+'"><input type="text" name="to_comp_name' + row_count +'" id="to_comp_name' + row_count +'" onFocus="autocomp_to_comp('+row_count+');" value="'+to_comp_name+'" style="width:162px;"  class="boxtext"><a href="javascript://" onClick="pencere_ac_to_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
		// alacaklı hesap	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML += '<input type="hidden" name="from_company_id' + row_count +'" id="from_company_id' + row_count +'"  value="'+from_company_id+'"><input type="hidden" name="from_consumer_id' + row_count +'" id="from_consumer_id' + row_count +'"  value="'+from_consumer_id+'"><input type="hidden" name="from_employee_id' + row_count +'" id="from_employee_id' + row_count +'"  value="'+from_employee_id+'"><input type="text" name="from_comp_name' + row_count +'" id="from_comp_name' + row_count +'" onFocus="autocomp_from_comp('+row_count+');" value="'+from_comp_name+'" style="width:162px;"  class="boxtext"><a href="javascript://" onClick="pencere_ac_from_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
        
		//tutar
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="action_value_' + row_count +'" id="action_value_' + row_count + '" value="'+commaSplit(action_value)+'" onkeyup="return(FormatCurrency(this,event));" onBlur="kur_ekle_f_hesapla(\'action_currency_id\',false,'+row_count+');" float:right;" class="box">';
		// para br
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<div class="form-group"><select name="money_id' + row_count  +'" id="money_id' + row_count + '" style="width:100%;" class="boxtext" onChange="kur_ekle_f_hesapla(\'action_currency_id\',false,'+row_count+');">';
		<cfoutput query="get_money">
			if('#money#' == currency_id || (!currency_id.length && '#money#' == '#session.ep.money#'))
				a += '<option value="#money#;#rate1#;#filterNum(tlformat(rate2,"#rate_round_num_info#"),"#rate_round_num_info#")#" selected>#money#</option>';
			else
				a += '<option value="#money#;#rate1#;#filterNum(tlformat(rate2,"#rate_round_num_info#"),"#rate_round_num_info#")#">#money#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select></div>';
		// dövizli tutar
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="action_value2_' + row_count +'" id="action_value2_' + row_count + '" value="'+commaSplit(action_value2)+'" onkeyup="return(FormatCurrency(this,event));" class="box" onBlur="kur_ekle_f_hesapla(\'action_currency_id\',true,'+row_count+');">';
		// borç ödeme tarihi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.setAttribute("id","due_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" id="due_date' + row_count +'" name="due_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="' + due_date +'"> ';
		wrk_date_image('due_date' + row_count);

		// alacak ödeme tarihi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.setAttribute("id","from_due_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" id="from_due_date' + row_count +'" name="from_due_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="' + from_due_date +'"> ';
		wrk_date_image('from_due_date' + row_count);
		// açıklama
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="action_detail' + row_count +'" id="action_detail' + row_count + '" value="'+action_detail+'" style="width:130px;" class="boxtext">';
		
		//borçlu fiziki varlık
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="to_asset_id'+ row_count +'" name="to_asset_id'+ row_count +'" value="'+to_asset_id+'"><input type="text" id="to_asset_name'+ row_count +'" name="to_asset_name'+ row_count +'" value="'+to_asset_name+'" style="width:150px;" class="boxtext" onFocus="autocomp_to_asset('+row_count+');"><a href="javascript://" onClick="pencere_ac_to_asset('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		
		//alacaklı fiziki varlık
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="from_asset_id'+ row_count +'" name="from_asset_id'+ row_count +'" value="'+from_asset_id+'"><input type="text" id="from_asset_name'+ row_count +'" name="from_asset_name'+ row_count +'" value="'+from_asset_name+'" style="width:150px;" class="boxtext" onFocus="autocomp_from_asset('+row_count+');"><a href="javascript://" onClick="pencere_ac_from_asset('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';

		//abone
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value="'+subscription_id+'" /><input type="text" name="subscription_no'+ row_count +'" id="subscription_no'+ row_count +'" value="'+subscription_no+'" class="boxtext" style="width:150px;" /><a href="javascript://" onClick="open_subscription('+ row_count +')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="subscription_id2'+ row_count +'" id="subscription_id2'+ row_count +'" value="'+subscription_id2+'" /><input type="text" name="subscription_no2'+ row_count +'" id="subscription_no2'+ row_count +'" value="'+subscription_no2+'" class="boxtext" style="width:150px;" /><a href="javascript://" onClick="open_subscription2('+ row_count +')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';

		//borçlu proje
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="to_project_id'+ row_count +'" id="to_project_id'+ row_count +'" value="'+to_project_id+'"><input type="text" style="width:143px;" name="to_project_head'+ row_count +'" id="to_project_head'+ row_count +'" onFocus="autocomp_to_project('+row_count+');" value="'+to_project_head+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_to_project('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
		//alacaklı proje
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="from_project_id'+ row_count +'" id="from_project_id'+ row_count +'" value="'+from_project_id+'"><input type="text" style="width:143px;" name="from_project_head'+ row_count +'" id="from_project_head'+ row_count +'" onFocus="autocomp_from_project('+row_count+');" value="'+from_project_head+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_from_project('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
		 <cfif isDefined('x_show_branch') and x_show_branch eq 1>
			//borçlu şube
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			a = '<select name="to_branch_id' + row_count  +'" id="to_branch_id' + row_count + '" style="width:100%;" class="boxtext">';
			a += '<option value="">Seçiniz</option>';
			<cfoutput query="get_branches">
				if('#branch_id#' == to_branch_id)
					a += '<option value="#branch_id#" selected>#branch_name#</option>';
				else
					a += '<option value="#branch_id#">#branch_name#</option>';
			</cfoutput>			
			newCell.innerHTML =a+ '</select>';
			//alacaklı şube
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			a = '<select name="from_branch_id' + row_count  +'" id="from_branch_id' + row_count + '" style="width:100%;" class="boxtext">';
			a += '<option value="">Seçiniz</option>';
			<cfoutput query="get_branches">
				if('#branch_id#' == from_branch_id)
					a += '<option value="#branch_id#" selected>#branch_name#</option>';
				else
					a += '<option value="#branch_id#">#branch_name#</option>';
			</cfoutput>
			newCell.innerHTML =a+ '</select>';
		</cfif>
		kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',true,row_count);
		toplam_hesapla();
	}
	function copy_row(no_info)
	{	
		if (document.getElementById("from_company_id" + no_info) == undefined) from_company_id =""; else from_company_id = document.getElementById("from_company_id" + no_info).value;
		if (document.getElementById("from_consumer_id" + no_info) == undefined) from_consumer_id =""; else from_consumer_id = document.getElementById("from_consumer_id" + no_info).value;
		if (document.getElementById("from_employee_id" + no_info) == undefined) from_employee_id =""; else from_employee_id = document.getElementById("from_employee_id" + no_info).value;
		if (document.getElementById("to_company_id" + no_info) == undefined) to_company_id =""; else to_company_id = document.getElementById("to_company_id" + no_info).value;
		if (document.getElementById("to_consumer_id" + no_info) == undefined) to_consumer_id =""; else to_consumer_id = document.getElementById("to_consumer_id" + no_info).value;
		if (document.getElementById("to_employee_id" + no_info) == undefined) to_employee_id =""; else to_employee_id = document.getElementById("to_employee_id" + no_info).value;
		if (document.getElementById("action_value_" + no_info) == undefined) action_value =""; else action_value = document.getElementById("action_value_" + no_info).value.replace('.','');
		if (document.getElementById("action_value2_" + no_info) == undefined) action_value2 =""; else action_value2 = document.getElementById("action_value2_" + no_info).value.replace('.','');
		if (document.getElementById("money_id" + no_info) == undefined) currency_id =""; else currency_id = document.getElementById("money_id" + no_info).value.split(';')[0];
		if (document.getElementById("due_date" + no_info) == undefined) due_date_ =""; else due_date_ = document.getElementById("due_date" + no_info).value;
		if (document.getElementById("from_due_date" + no_info) == undefined) form_due_date_ =""; else form_due_date_ = document.getElementById("from_due_date" + no_info).value;
		if (document.getElementById("action_detail" + no_info) == undefined) action_detail =""; else action_detail = document.getElementById("action_detail" + no_info).value;
		if (document.getElementById("to_asset_id" + no_info) == undefined) to_asset_id =""; else to_asset_id = document.getElementById("to_asset_id" + no_info).value;
		if (document.getElementById("from_asset_id" + no_info) == undefined) from_asset_id =""; else from_asset_id = document.getElementById("from_asset_id" + no_info).value;
		if (document.getElementById("to_project_id" + no_info) == undefined) to_project_id =""; else to_project_id = document.getElementById("to_project_id" + no_info).value;
		if (document.getElementById("from_project_id" + no_info) == undefined) from_project_id =""; else from_project_id = document.getElementById("from_project_id" + no_info).value;
		if (document.getElementById("to_branch_id" + no_info) == undefined) to_branch_id =""; else to_branch_id = document.getElementById("to_branch_id" + no_info).value;
		if (document.getElementById("from_branch_id" + no_info) == undefined) from_branch_id =""; else from_branch_id = document.getElementById("from_branch_id" + no_info).value;
		if (document.getElementById("subscription_id" + no_info) == undefined) subscription_id =""; else subscription_id = document.getElementById("subscription_id" + no_info).value;
		if (document.getElementById("subscription_id2" + no_info) == undefined) subscription_id2 =""; else subscription_id2 = document.getElementById("subscription_id2" + no_info).value;
		
		add_row('',from_company_id,from_consumer_id,from_employee_id,to_company_id,to_consumer_id,to_employee_id,action_value,action_value2,currency_id,due_date_,form_due_date_,action_detail,to_asset_id,from_asset_id,to_project_id,from_project_id,to_branch_id,from_branch_id,subscription_id,subscription_id2);
		kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',false,row_count);	
	}
	function autocomp_from_comp(no)
	{
		AutoComplete_Create("from_comp_name"+no,"MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","get_member_autocomplete","\"1,2,3\",\"\",\"\",\"\",\"\",\"\",\"\",\"1\"","COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID","from_company_id"+no+",from_consumer_id"+no+",from_employee_id"+no+"","",3,250,"emp_comp_and_account("+ no +")");
	}
	function autocomp_to_comp(no)
	{
		AutoComplete_Create("to_comp_name"+no,"MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","get_member_autocomplete","\"1,2,3\",\"\",\"\",\"\",\"\",\"\",\"\",\"1\"","COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID","to_company_id"+no+",to_consumer_id"+no+",to_employee_id"+no+"","",3,250,"emp_comp_and_account("+ no +")");
	}
	
	function pencere_ac_from_company(sira_no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_multi_act=1&is_cari_action=1&row_no='+ sira_no +'<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3,9&field_comp_id=add_process.from_company_id'+ sira_no +'&field_name=add_process.from_comp_name' + sira_no +'&field_emp_id=add_process.from_employee_id'+ sira_no +'&field_consumer=add_process.from_consumer_id'+ sira_no);
	}
	function pencere_ac_to_company(sira_no)
	{
		
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_multi_act=1&is_cari_action=1&row_no='+ sira_no +'<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3,9&field_comp_id=add_process.to_company_id'+ sira_no +'&field_name=add_process.to_comp_name' + sira_no +'&field_emp_id=add_process.to_employee_id'+ sira_no +'&field_consumer=add_process.to_consumer_id'+ sira_no);
	}
	
	function autocomp_to_asset(no)
	{
		AutoComplete_Create("to_asset_name"+no,"ASSETP","ASSETP","get_assetp_autocomplete","","ASSETP_ID","to_asset_id"+no,"",3,200);
	}
	function autocomp_from_asset(no)
	{
		AutoComplete_Create("from_asset_name"+no,"ASSETP","ASSETP","get_assetp_autocomplete","","ASSETP_ID","from_asset_id"+no,"",3,200);
	}
	function pencere_ac_to_asset(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_process.to_asset_id' + no +'&field_name=add_process.to_asset_name' + no +'&event_id=0&motorized_vehicle=0');
	}
	function pencere_ac_from_asset(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_process.from_asset_id' + no +'&field_name=add_process.from_asset_name' + no +'&event_id=0&motorized_vehicle=0','list');
	}
	
    function autocomp_to_project(no)
    {
        AutoComplete_Create("to_project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","to_project_id"+no,"",3,200);
    }
    function autocomp_from_project(no)
    {
        AutoComplete_Create("from_project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","from_project_id"+no,"",3,200);
    }
    function pencere_ac_to_project(no)
    {
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_process.to_project_id' + no +'&project_head=add_process.to_project_head' + no +'');
    }
    function pencere_ac_from_project(no)
    {
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_process.from_project_id' + no +'&project_head=add_process.from_project_head' + no +'');
    }
	
	function toplam_hesapla()
	{
		var total_amount = 0;
		for(j=1; j<=document.getElementById('record_num').value; j++)
		{
			if(document.getElementById('row_kontrol'+j).value==1)
			{
				total_amount += parseFloat(filterNum(document.getElementById('action_value2_'+j).value));
			}
		}
		document.getElementById('total_amount').value = commaSplit(total_amount);
		document.getElementById('tl_value1').value = list_first($('input[name="rd_money"]:checked').val(),',');
	}
	
	function kontrol()
	{
		var dsn = '<cfoutput>#dsn2#</cfoutput>';
		<cfif isDefined("attributes.upd_id")>
			if(!paper_no_control(document.getElementById('record_num').value,dsn,'CARI_ACTIONS','ACTION_TYPE_ID*43','PAPER_NO','CARI_TO_CARI','row_kontrol','paper_number','ACTION_ID-row_id')) return false;
		<cfelse>
			if(!paper_no_control(document.getElementById('record_num').value,dsn,'CARI_ACTIONS','ACTION_TYPE_ID*43','PAPER_NO','CARI_TO_CARI','row_kontrol','paper_number')) return false;
		</cfif>
		if(!chk_process_cat('add_process')) return false;
		if(!check_display_files('add_process')) return false;
		if(!chk_period(add_process.action_date,'İşlem')) return false;
				
		var p_type_ = "VIRMAN";
		var table_name_ = "CARI_ACTIONS";
		var alert_name_ = "Aynı Belge No İle Kayıtlı Virman İşlemi Var";
		paper_num_list = '';

		for(j=1; j<=document.getElementById('record_num').value; j++)
		{
			if(document.getElementById('row_kontrol'+j).value==1)
			{
				record_exist=1;
				//satirda hesaplarin kontrolu
				if (document.getElementById('from_company_id'+j).value == '' && document.getElementById('from_consumer_id'+j).value == '' && document.getElementById('from_employee_id'+j).value == '')
				{ 
					alert (document.getElementById('paper_number'+j).value+" : Lütfen Borçlu Hesap Seçiniz!");
					return false;
				}
				if (document.getElementById('to_company_id'+j).value == '' && document.getElementById('to_consumer_id'+j).value == '' && document.getElementById('to_employee_id'+j).value == '')
				{ 
					alert (document.getElementById('paper_number'+j).value+" : Lütfen Alacaklı Hesap Seçiniz!");
					return false;
				}
				if (document.getElementById('action_value_'+j).value == '0,00')
				{ 
					alert (document.getElementById('paper_number'+j).value+" : Lütfen Tutar Giriniz!");
					return false;
				}
				<cfif x_imperative_proje eq 1>
					if (document.getElementById('to_project_id'+j).value == '' || document.getElementById('from_project_id'+j).value == '')
					{ 
						alert ("<cf_get_lang dictionary_id='62734.Borçlu ve Alacaklı proje zorunludur'>!");
						return false;
					}
				</cfif>
				//satirda hesapların farkliligi kontrolu
			/*	if((document.getElementById('from_company_id'+j).value != '' && document.getElementById('to_company_id'+j).value != '' && document.getElementById('from_company_id'+j).value == document.getElementById('to_company_id'+j).value) ||
					(document.getElementById('from_consumer_id'+j).value != '' && document.getElementById('to_consumer_id'+j).value != '' && document.getElementById('from_consumer_id'+j).value == document.getElementById('to_consumer_id'+j).value) ||
					(document.getElementById('from_employee_id'+j).value != '' && document.getElementById('to_employee_id'+j).value != '' && document.getElementById('from_employee_id'+j).value == document.getElementById('to_employee_id'+j).value))				
				{
					alert(document.getElementById('paper_number'+j).value+" : Seçtiğiniz Hesaplar Aynı!");		
					return false; 
				}*/
			}
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang dictionary_id='33822.Lütfen Satır Ekleyiniz'>");
			return false;
		}
		return true;
	}
	
	function open_file()
	{

		openBoxDraggable('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popup_add_collacted_virman_file<cfif isdefined("attributes.multi_id")>&multi_id=#attributes.multi_id#</cfif></cfoutput>');
		return false;
	}
	
	function kur_ekle_f_hesapla(select_input,doviz_tutar,satir)
	{
		if(satir != undefined)
		{
			for(var kk=1;kk<=add_process.record_num.value;kk++)
			{
				if(!doviz_tutar) doviz_tutar=false;
				var currency_type = document.getElementById('action_currency_id').value;
				currency_type = list_getat(currency_type,2,';');
				
				row_currency = list_getat(eval("document.add_process.money_id"+kk).value,1,';');
				var other_money_value_eleman=eval("document.add_process.action_value2_"+kk);
				var rate1_eleman,rate2_eleman;
				if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
				{
					other_money_value_eleman.value = '';
					return false;
				}
				
				rate1_eleman = filterNum(eval('add_process.txt_rate1_' + list_getat(add_process.rd_money.value,2,',')).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
				rate2_eleman = filterNum(eval('add_process.txt_rate2_' + list_getat(add_process.rd_money.value,2,',')).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
				fRate = rate2_eleman/rate1_eleman;
				rate1_satir = list_getat(document.getElementById('money_id'+kk).value,2,';');
				rate2_satir = list_getat(document.getElementById('money_id'+kk).value,3,';');
				RowRate = rate2_satir/rate1_satir;
				
				if(!doviz_tutar && eval("document.add_process.action_value_"+satir) != "" && currency_type != "")
					other_money_value_eleman.value = commaSplit(filterNum(eval("document.add_process.action_value_"+kk).value)*RowRate/fRate);
				else if(doviz_tutar)
					eval("document.add_process.action_value_"+kk).value = commaSplit(filterNum(eval("document.add_process.action_value2_"+kk).value)*fRate/RowRate);
			}
		}
		else
		{
			for(var kk=1;kk<=add_process.record_num.value;kk++)
			{
				if(!doviz_tutar) doviz_tutar=false;
				var currency_type = document.getElementById('action_currency_id').value;
				currency_type = list_getat(currency_type,2,';');
				document.getElementById('tl_value1').value = currency_type;
				
				row_currency = list_getat(eval("document.add_process.money_id"+kk).value,1,';');
				var other_money_value_eleman=eval("document.add_process.action_value2_"+kk);
				var rate1_eleman,rate2_eleman;			
							
				if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
				{
					other_money_value_eleman.value = '';
					return false;
				}
				if(currency_type != "")
				{
					rate1_eleman = filterNum(eval('add_process.txt_rate1_' + list_getat(add_process.rd_money.value,2,',')).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					rate2_eleman = filterNum(eval('add_process.txt_rate2_' + list_getat(add_process.rd_money.value,2,',')).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					fRate = rate2_eleman/rate1_eleman;
					rate1_satir = list_getat(document.getElementById('money_id'+kk).value,2,';');
					rate2_satir = list_getat(document.getElementById('money_id'+kk).value,3,';');
					RowRate = rate2_satir/rate1_satir;
					if(!doviz_tutar && eval("document.add_process.action_value_"+kk) != "" && currency_type != "")
						other_money_value_eleman.value = commaSplit(filterNum(eval("document.add_process.action_value_"+kk).value,'<cfoutput>#rate_round_num_info#</cfoutput>')*RowRate/fRate);

					else if(doviz_tutar)
						eval("document.add_process.action_value_"+kk).value = commaSplit(filterNum(eval("document.add_process.action_value2_"+kk).value)*fRate/RowRate);
				}
			}
		}	
		toplam_hesapla();
		return true;
	}
	window.onload = function()
	{ 
		if(document.getElementById('<cfoutput>#select_input#</cfoutput>').value != '')
			kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',false);
	}
</script>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

