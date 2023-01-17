<!--- Tahakkuk Islemleri 20121002Esra--->
<cfparam name="attributes.budget_action_type" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.account_code" default="">
<cfparam name="attributes.income_exp" default="">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfif len(attributes.search_date1)>
	<cf_date tarih='attributes.search_date1'>
</cfif>
<cfif len(attributes.search_date2)>
	<cf_date tarih='attributes.search_date2'>
</cfif>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (160,161)
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_budget_plan" datasource="#dsn#">
		SELECT 
			BP.PAPER_NO,
			BP.PROCESS_CAT,
			BP.BUDGET_PLAN_ID,
			BP.OTHER_MONEY,
			BPR.PLAN_DATE DATE,
			BPR.DETAIL,
			BPR.EXP_INC_CENTER_ID,
			BPR.BUDGET_ITEM_ID,
			BPR.BUDGET_ACCOUNT_CODE,
			BPR.ROW_TOTAL_INCOME INCOME,
			BPR.ROW_TOTAL_EXPENSE EXPENSE,
			BPR.OTHER_ROW_TOTAL_INCOME OTHER_INCOME,
			BPR.OTHER_ROW_TOTAL_EXPENSE OTHER_EXPENSE,
			BPR.PROJECT_ID
		FROM
			BUDGET_PLAN BP,
			BUDGET_PLAN_ROW BPR
		WHERE
			BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID AND 
			BP.PROCESS_CAT IN (SELECT PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(160,161)) AND
        	BP.PERIOD_ID = #session.ep.period_id# AND
			BP.OUR_COMPANY_ID = #session.ep.company_id#    
			<cfif len(attributes.budget_action_type)>
				AND BP.PROCESS_CAT = #attributes.budget_action_type#
			</cfif>
			<cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
				AND BPR.EXP_INC_CENTER_ID = #attributes.expense_center_id#
			</cfif>
			<cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)>
				AND BPR.BUDGET_ITEM_ID = #attributes.expense_item_id#
			</cfif>
			<cfif len(attributes.account_code)>
				AND BPR.BUDGET_ACCOUNT_CODE = '#attributes.account_code#'
			</cfif>
			<cfif len(attributes.money_type)>
				AND BP.OTHER_MONEY = '#attributes.money_type#'
			</cfif>
			<cfif len(attributes.search_date1)>
				AND BPR.PLAN_DATE >= #attributes.search_date1#
			</cfif>
			<cfif len(attributes.search_date2)>
				AND BPR.PLAN_DATE <= #attributes.search_date2#
			</cfif>
			<cfif len(attributes.income_exp) and attributes.income_exp eq 1>
				AND BPR.ROW_TOTAL_INCOME <> 0
			<cfelseif len(attributes.income_exp) and attributes.income_exp eq 2>
				AND BPR.ROW_TOTAL_EXPENSE <> 0
			</cfif>
		ORDER BY 
			BP.PAPER_NO
	</cfquery>
<cfelse>
	<cfset get_budget_plan.recordcount = 0>
</cfif>
<cfform name="form_" action="#request.self#?fuseaction=budget.list_accrual_operations">
	<cf_box>
    <input type="hidden" name="form_submitted" id="form_submitted" value="1">
  			<cf_box_elements>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-budget_action_type">
                            	<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',388)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="budget_action_type" id="budget_action_type" style="width:150px;">
                                        <option value=""><cfoutput>#getLang('main',322)#</cfoutput></option>
                                        <cfoutput query="get_process_cat">
                                            <option value="#process_cat_id#" <cfif attributes.budget_action_type eq process_cat_id>selected</cfif>>#process_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-account_code">
                            	<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1399)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                    	<cfinput type="text" name="account_code" value="#attributes.account_code#" onFocus="AutoComplete_Create('account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_.account_code','list');" title="<cfoutput>#getLang('main',1399)#</cfoutput>"></span>	
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-currency">
                            	<label class="col col-12"><cfoutput>#getLang('main',709)#</cfoutput><input type="checkbox" name="currency" id="currency" <cfif isdefined('attributes.currency')>checked</cfif>></label>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        	<div class="form-group" id="item-expense_center_name">
                            	<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',823)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    	<cf_wrkExpenseCenter width_info="150" fieldId="expense_center_id" fieldName="expense_center_name" form_name="form_" expense_center_id="#attributes.expense_center_id#" expense_center_name="#attributes.expense_center_name#" img_info="plus_thin">
                                </div>
                            </div>
                            <div class="form-group" id="item-expense_item_name">
                            	<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',822)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    	<cf_wrkExpenseItem width_info="150" fieldId="expense_item_id" fieldName="expense_item_name" form_name="form_" expense_item_id="#attributes.expense_item_id#" expense_item_name="#attributes.expense_item_name#" acc_code="account_code" img_info="plus_thin">	
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        	<div class="form-group" id="item-search_date">
                            	<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',467)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                    	<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
                                        <span class="input-group-addon no-bg"></span>
                                        <cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
                    				</div>
                                </div>
                            </div>
                            <div class="form-group" id="item-money_type">
                            	<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',77)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                    	<select name="money_type" id="money_type">
											<cfoutput query="get_money">
                                            	<option value="#money#" <cfif isdefined("attributes.money_type") and len(attributes.money_type) and money eq attributes.money_type>selected</cfif>>#money#</option>
                                        	</cfoutput>
                                    	</select>
                                        <span class="no-bg input-group-addon"></span>
                                        <select name="income_exp" id="income_exp" style="width:65px;">						
                                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                            <option value="1" <cfif attributes.income_exp eq 1>selected</cfif>><cf_get_lang dictionary_id='58677.Gelir'></option>
                                            <option value="2" <cfif attributes.income_exp eq 2>selected</cfif>><cf_get_lang dictionary_id='58678.Gider'></option>
                                        </select>
									</div>
                                </div>
                            </div>
                        </div>
					</cf_box_elements>
                    <cf_box_footer>
						<div class="pull-right">
                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57650.Dök'></cfsavecontent>
                        <cf_wrk_search_button search_function="page_control()" button_type="2" button_name="#message#" float="right">
						</div>
					</cf_box_footer>
</cf_box>
	<cfif isdefined("attributes.form_submitted") and get_budget_plan.recordcount>
		<cf_box title="#getlang('','Tahakkuk İşlemleri','49189')#">
			<cf_grid_list class="detail_basket_list">
				<thead>
					<tr>
						<th rowspan="2"><cf_get_lang dictionary_id='57487.No'></th>
						<th rowspan="2"><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
						<th rowspan="2"><cf_get_lang dictionary_id='57880.Belge No'></th>
						<th rowspan="2"><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th rowspan="2"><cf_get_lang dictionary_id='57629.Aciklama'></th>
						<th rowspan="2"><cf_get_lang dictionary_id='57416.Proje'></th>
						<th rowspan="2"><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></th>
						<th rowspan="2"><cf_get_lang dictionary_id='58234.Butce Kalemi'></th>
						<th rowspan="2">
							<cf_get_lang dictionary_id='58811.Muhasebe Kodu'><br/><br/>
							<div class="input-group">
							<cfinput type="text" name="acc_code" value="" style="width:75px;"  onFocus="AutoComplete_Create('acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225','apply_row(1)');">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>"  onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_.acc_code&function_name=apply_row(1)','list');" ></span>
							</div>
						</th>
						<th rowspan="2">
							<cf_get_lang dictionary_id="64587.Tahakkuk Hesabı"><br/><br/>
								<div class="input-group">
							<cfinput type="text" name="main_acc_code" value="" style="width:75px;"  onFocus="AutoComplete_Create('main_acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225','apply_row(2)');">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_.main_acc_code&function_name=apply_row(2)','list');" ></span>
							</div>
						</th>
						<th colspan="3" style="text-align:center;"><cf_get_lang dictionary_id='58905.Sistem Dövizi'></th>
						<cfif isdefined('attributes.currency')>
							<th colspan="3" style="text-align:center;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
						</cfif>
						<th width="1%" rowspan="2"><input type="checkbox" name="all_check" id="all_check" value="1" onClick="check_all();"></th>
					</tr>
					<tr>
						<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='58677.Gelir'></th>
						<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='58678.Gider'></th>
						<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
						<cfif isdefined('attributes.currency')>
							<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='58677.Gelir'><cf_get_lang dictionary_id='57677.Doviz'></th>
							<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='58678.Gider'><cf_get_lang dictionary_id='57677.Doviz'></th>
							<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
						</cfif>
					</tr>
				</thead>
				<tbody>
					<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_budget_plan.recordcount#</cfoutput>">
					<input type="hidden" name="total_record" id="total_record" value="">
					<cfset process_cat_list = "">
					<cfset budget_item_id_list = "">
					<cfset exp_inc_center_id_list = "">
					<cfoutput query="get_budget_plan">
						<cfif len(process_cat) and not listfind(process_cat_list,process_cat)>
							<cfset process_cat_list=listappend(process_cat_list,process_cat)>
						</cfif>
						<cfif len(exp_inc_center_id) and not listfind(exp_inc_center_id_list,exp_inc_center_id)>
							<cfset exp_inc_center_id_list=listappend(exp_inc_center_id_list,exp_inc_center_id)>
						</cfif>
						<cfif len(budget_item_id) and not listfind(budget_item_id_list,budget_item_id)>
							<cfset budget_item_id_list=listappend(budget_item_id_list,budget_item_id)>
						</cfif>
					</cfoutput>
					<!--- islem tipleri --->
					<cfif len(process_cat_list)>
						<cfset process_cat_list=listsort(process_cat_list,"numeric","ASC",",")>
						<cfquery name="get_process" datasource="#dsn3#">
							SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_list#) ORDER BY PROCESS_CAT_ID
						</cfquery>
						<cfset process_cat_list = listsort(listdeleteduplicates(valuelist(get_process.process_cat_id,',')),'numeric','ASC',',')>
					</cfif>
					<!--- masraf/gelir merkezleri --->
					<cfif len(exp_inc_center_id_list)>
						<cfset exp_inc_center_id_list=listsort(exp_inc_center_id_list,"numeric","ASC",",")>
						<cfquery name="get_exp_inc_center_name" datasource="#dsn2#">
							SELECT EXPENSE, EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#exp_inc_center_id_list#) ORDER BY EXPENSE_ID
						</cfquery>
						<cfset exp_inc_center_id_list = listsort(listdeleteduplicates(valuelist(get_exp_inc_center_name.expense_id,',')),'numeric','ASC',',')>
					</cfif>
					<!--- butce kalemleri --->
					<cfif len(budget_item_id_list)>
						<cfset budget_item_id_list=listsort(budget_item_id_list,"numeric","ASC",",")>
						<cfquery name="get_exp_detail" datasource="#dsn2#">
							SELECT EXPENSE_ITEM_NAME, EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#budget_item_id_list#) ORDER BY EXPENSE_ITEM_ID
						</cfquery>
						<cfset budget_item_id_list = listsort(listdeleteduplicates(valuelist(get_exp_detail.expense_item_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_budget_plan">	
						<cfif (income gt 0 and expense gt 0) or (income eq 0 and expense eq 0)>
							<input type="hidden" name="record_error#currentrow#" id="record_error#currentrow#" value="1">
							<cfset renk = "FF0000">
						<cfelse>
							<cfset renk = "">
						</cfif>
						<tr>
							<td><font color="#renk#">#currentrow#</font></td>
							<td><a href="#request.self#?fuseaction=budget.list_accrual_operations&event=upd&budget_plan_id=#budget_plan_id#" class="tableyazi"><font color="#renk#"><cfif isdefined("get_process")>#get_process.process_cat[listfind(process_cat_list,process_cat,',')]#</cfif></font></a></td>
							<td><a href="#request.self#?fuseaction=budget.list_accrual_operations&event=upd&budget_plan_id=#budget_plan_id#" class="tableyazi"><font color="#renk#">#paper_no#</font></a></td>
							<td><font color="#renk#">#dateFormat(date,dateformat_style)#</font></td>
							<td><font color="#renk#">#detail#</font></td>
							<td><font color="#renk#"><cfif len(project_id)>#get_project_name(project_id)#</cfif></font></td>
							<td><font color="#renk#"><cfif isdefined("get_exp_inc_center_name")>#get_exp_inc_center_name.expense[listfind(exp_inc_center_id_list,exp_inc_center_id,',')]#</cfif></font></td>
							<td><font color="#renk#"><cfif isdefined("get_exp_detail")>#get_exp_detail.expense_item_name[listfind(budget_item_id_list,budget_item_id,',')]#</cfif></font></td>
							<td><font color="#renk#">
								<div class="input-group">
									<cfinput type="text" name="account_code#currentrow#" value="#budget_account_code#" style="width:75px;" onFocus="AutoComplete_Create('account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
									<span title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>" class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=form_.account_code'+#currentrow#,'list');" ></span>
									</div>
								</font>
							</td>
							<td nowrap="nowrap">
								<cfif len(budget_item_id)>
									<cfquery name="get_acc_code" datasource="#dsn2#">
										SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #budget_item_id#
									</cfquery>
								</cfif>
								<cfif len(budget_item_id)>
									<cfset tahakkuk_acc_code = get_acc_code.account_code>
								<cfelse>
									<cfset tahakkuk_acc_code = ''>
								</cfif>
								<div class="input-group">
								<cfinput type="text" name="tahakkuk_acc_code#currentrow#" value="#tahakkuk_acc_code#" style="width:75px;" onFocus="AutoComplete_Create('tahakkuk_acc_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
								<span  title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>" class="input-group-addon btnPointer icon-ellipsis"  onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=form_.tahakkuk_acc_code'+#currentrow#,'list');" ></span>
								</div>
							</td>
							<td style="text-align:right;"><font color="#renk#">#TLFormat(INCOME)#</font></td>
							<td style="text-align:right;"><font color="#renk#">#TLFormat(EXPENSE)#</font></td>
							<td><font color="#renk#">#session.ep.money#</font></td>
							<cfif isdefined('attributes.currency')>
								<td style="text-align:right;"><font color="#renk#">#TLFormat(OTHER_INCOME)#</font></td>
								<td style="text-align:right;"><font color="#renk#">#TLFormat(OTHER_EXPENSE)#</font></td>
								<td><font color="#renk#">#other_money#</font></td>
							</cfif>
							<td align="center">
								<input type="checkbox" name="row_check#currentrow#" id="row_check#currentrow#" value="1">
							</td>
						</tr>
						<input type="hidden" name="detail#currentrow#" id="detail#currentrow#" value="#detail#"><!--- aciklama --->
						<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#exp_inc_center_id#"><!--- masraf merkezi --->
						<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#budget_item_id#"><!--- butce kalemi --->
						<input type="hidden" name="income_total#currentrow#" id="income_total#currentrow#" value="#income#"><!--- gelir --->
						<input type="hidden" name="expense_total#currentrow#" id="expense_total#currentrow#" value="#expense#"><!--- gider --->
						<input type="hidden" name="other_income_total#currentrow#" id="other_income_total#currentrow#" value="#other_income#"><!--- gelir doviz --->
						<input type="hidden" name="other_expense_total#currentrow#" id="other_expense_total#currentrow#" value="#other_expense#"><!--- gider doviz --->
						<input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#project_id#"><!--- proje --->
					</cfoutput>
				</tbody>
			</cf_grid_list>
			<cf_box_footer>
				<cf_workcube_buttons is_upd="0" is_cancel="0" add_function="save_tahakkuk()" insert_alert=""> 
			</cf_box_footer>
	</cf_box>
	</cfif>
</cfform>
<script type="text/javascript">
	<cfif isdefined("attributes.form_submitted") and get_budget_plan.recordcount>
		document.getElementById('all_check').checked = true;
		check_all();
	</cfif>
	function check_all()
	{
		<cfif isdefined("get_budget_plan") and get_budget_plan.recordcount>
			if(document.getElementById('all_check').checked)
			{
				for (var i=1; i <= <cfoutput>#get_budget_plan.recordcount#</cfoutput>; i++)
				{
					if(document.getElementById('record_error'+i) == undefined)
					{
						var form_field = document.getElementById('row_check' + i);
						form_field.checked = true;
					}
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_budget_plan.recordcount#</cfoutput>; i++)
				{
					form_field = document.getElementById('row_check' + i);
					form_field.checked = false;
				}				
			}
		</cfif>
	}
	function apply_row(no)
	{
		toplam = document.getElementById('record_num').value;
		for(var zz=1; zz<=toplam; zz++)
		{
			if(document.getElementById('row_check'+zz) != undefined && document.getElementById('row_check'+zz).checked == true)
			{
				if(no==2)
				{
					if(document.getElementById('main_acc_code').value != '')
						document.getElementById('tahakkuk_acc_code'+zz).value = document.getElementById('main_acc_code').value;
				}
				else if (no==1)
				{
					if(document.getElementById('acc_code').value != '')
						document.getElementById('account_code'+zz).value = document.getElementById('acc_code').value;
				}
			}
		}
	}
	function save_tahakkuk()
	{
		var total_record = 0;
		<cfif isdefined("get_budget_plan")>
			for (var i=1; i <= <cfoutput>#get_budget_plan.recordcount#</cfoutput>; i++)
			{		
				if(document.getElementById('row_check' +i).checked)	
					total_record += 1;
			}
			document.getElementById('total_record').value = total_record;
		</cfif>
		
		if(confirm('<cf_get_lang dictionary_id="59041.Seçilen Kayıtlar Kaydedilecek. Emin misiniz?">'))
		{
			document.getElementById('form_').target = "blank";
			document.getElementById('form_').action = "<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_accrual_operations&event=add&from_plan_list&is_rapor=1";
		}
		else 
			return false;
	}
	function page_control()
	{
		document.getElementById('form_').target = "";
		document.getElementById('form_').action = "<cfoutput>#request.self#?fuseaction=budget.list_accrual_operations</cfoutput>";
	}
</script>

