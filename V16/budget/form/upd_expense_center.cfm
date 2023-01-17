<!---E.A 20072012 select ifadeleri düzenlendi.--->
<cfinclude template="../query/get_expense_detail.cfm">
<cfset getActivity = createobject("component","workdata.get_activity_types").getActivity()>
<cfparam name="attributes.department" default="">
<cfquery name="GET_HIER" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
	SELECT 
		EXPENSE_ID
	FROM 
		EXPENSE_CENTER 
	WHERE 
		EXPENSE_CODE LIKE '#expense.EXPENSE_CODE#.%'
</cfquery>
<!--- <cfsavecontent variable="img"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=budget.popup_add_expense_center"> <img src="/images/plus1.gif" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></cfsavecontent>
 --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang(86,'Masraf ve Gelir Merkezleri',47152)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="upd_expense" action="#request.self#?fuseaction=budget.emptypopup_upd_expense_center&expense_id=#url.expense_id#" method="post">
            <cfset obj=0>
            <cfif isdefined("url.obj")>
                <cfset obj=url.obj>
                <cfset url_string = "">
                <cfif isdefined("field_id")>
                    <cfset url_string = "#url_string#&field_id=#field_id#">
                </cfif>
                <cfif isdefined("field_name")>
                    <cfset url_string = "#url_string#&field_name=#field_name#">
                </cfif>
                <cfif isdefined("code")>
                    <cfset url_string = "#url_string#&code=#code#">
                </cfif>         
                <cf_box_elements>
                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12" type="column" index="1" sort="true">
                            <cfoutput>
                            <input type="hidden" name="expense_id" id="expense_id" value="#attributes.expense_id#">
                            <input type="hidden" name="field_id"  id="field_id" value="<cfif isdefined("field_id")>#attributes.field_id#</cfif>">
                            <input type="hidden" name="hierarchy"  id="hierarchy" value="#expense.hierarchy#">
                            <input type="hidden" name="old_expense" id="old_expense" value="#expense.expense_code#">
                        </cfoutput>
                        <div class="form-group" id="item-is_production">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"></label>
                        <div class="col col-2 col-md-2 col-sm-3 col-xs-12"><cfoutput>#getLang('main', 44)#</cfoutput><input type="checkbox" name="is_production" id="is_production" <cfif len(expense.is_production) and expense.is_production eq 1>checked</cfif>></div>
                        <div class="col col-2 col-md-2 col-sm-3 col-xs-12"><cfoutput>#getLang('main', 81)#</cfoutput><input type="Checkbox" name="active" id="active" value="1" <cfif len(expense.expense_active) and expense.expense_active eq 1>checked</cfif>></div>
                        <div class="col col-2 col-md-2 col-sm-3 col-xs-12"><cfoutput>#getLang('main', 2157)#</cfoutput><input type="checkbox" name="is_general" id="is_general" checked></div>

                        </div>


                        <div class="form-group" id="item-exp_cntr_code">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('budget', 56)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <cfset listuzun=listlen(expense.expense_code,".")>
                                <cfset cat_code=listgetat(expense.expense_code,listuzun,".")>
                                <cfset ust_cat_code=listdeleteat(expense.expense_code,listuzun,".")>
                                <input type="Hidden" name="product_cat_code_old" id="product_cat_code_old" value="<cfoutput>#cat_code#</cfoutput>">
                                <select name="exp_cntr_code" id="exp_cntr_code" onChange="document.upd_expense.head_exp_code.value=document.upd_expense.exp_cntr_code[document.upd_expense.exp_cntr_code.selectedIndex].value;" style="width:202px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfinclude template="../query/get_expense.cfm">
                                    <cfloop query="get_expense">
                                        <option value="<cfoutput>#expense_code#</cfoutput>"
                                        <cfif ' '&ust_cat_code eq ' '&expense_code>selected</cfif>><!--- integer karşılaştırma yapmaması için koşula alt+255 eklendi. --->
                                            <cfif listlen(expense_code,".") neq 1>
                                                <cfloop from="1" to="#listlen(expense_code,".")#" index="i">&nbsp;</cfloop>
                                            </cfif>
                                            <cfoutput>#expense#</cfoutput>
                                        </option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-head_exp_code">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('budget', 55)#</cfoutput>*</label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="head_exp_code" id="head_exp_code" style="width:50px;" value="<cfoutput>#ust_cat_code#</cfoutput>" readonly >
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="Text" name="exp_code" value="#cat_code#">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_name">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('budget', 54)#</cfoutput>*</label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="Text" name="expense_name" size="82" value="#expense.expense#" required="yes" maxlength="50">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="EXPENSE_CENTER" 
                                        column_name="EXPENSE" 
                                        column_id_value="#attributes.EXPENSE_ID#" 
                                        maxlength="500" 
                                        datasource="#dsn2#" 
                                        column_id="EXPENSE_ID" 
                                        control_type="0">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 41)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <cfquery name="GET_BRANCH" datasource="#dsn#">
                                    SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
                                </cfquery>
                                <select name="branch" id="branch" style="width:200px;" onChange="LoadDepartmen(this.value)">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <option value="-1" <cfif expense.expense_branch_id eq -1>selected</cfif>><cf_get_lang_main no ="1698.Tüm Şubeler"></option>
                                    <cfoutput query="get_branch">
                                        <option value="#branch_id#" <cfif expense.expense_branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-department">
                            <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
                                SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1
                                <cfif len(expense.expense_branch_id)>AND BRANCH_ID = #expense.expense_branch_id#</cfif>
                            </cfquery>
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 160)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <select name="department" id="department" style="width:200px;">
                                    <cfif expense.expense_branch_id neq -1><option value=""><cf_get_lang_main no='322.Seçiniz'></option></cfif>
                                    <option value="-1" <cfif expense.expense_branch_id eq -1>selected</cfif>><cf_get_lang dictionary_id="32934.Tüm departmanlar"></option>
                                    <cfoutput query="get_department">
                                        <option value="#department_id#" <cfif expense.expense_department_id eq department_id>selected</cfif>>#department_head#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-company_name">
                            <cfif len(expense.company_id)>
                                <cfquery name="GET_COMPANY_NAME" datasource="#dsn#">
                                    SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #expense.company_id#
                                </cfquery>
                            </cfif>
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 107)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <cfif len(expense.company_id)>
                                        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#expense.company_id#</cfoutput>">
                                        <input type="text" name="company_name" id="company_name" value="<cfoutput>#get_company_name.fullname#</cfoutput>">
                                    <cfelse>
                                        <input type="hidden" name="company_id" id="company_id">
                                        <input type="text" name="company_name" id="company_name">
                                    </cfif>	
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=upd_expense.company_name&field_comp_id=upd_expense.company_id&select_list=2','list');" title="<cfoutput>#getLang('budget', 46)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-activity_id">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('budget', 90)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <select name="activity_id" id="activity_id" style="width:200px;">
                                    <option value=""><cfoutput>#getLang('main', 322)#</cfoutput></option>
                                    <cfoutput  query="getActivity">
                                        <option value="#activity_id#" <cfif expense.activity_id eq getActivity.activity_id> selected </cfif> >#activity_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-workgroup_name">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 728)#</cfoutput></label>
                            <cfif len(expense.workgroup_id)>
                                <cfquery name="GET_WORKGROUP" datasource="#dsn#">
                                    SELECT WORKGROUP_NAME FROM WORK_GROUP WHERE WORKGROUP_ID = #expense.workgroup_id#
                                </cfquery>
                            </cfif>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <cfif len(expense.workgroup_id)>
                                        <input type="hidden" name="workgroup_id" id="workgroup_id" value="<cfoutput>#expense.workgroup_id#</cfoutput>">
                                        <input type="text" name="workgroup_name" id="workgroup_name" value="<cfoutput>#get_workgroup.workgroup_name#</cfoutput>">
                                    <cfelse>
                                        <input type="hidden" name="workgroup_id" id="workgroup_id">
                                        <input type="text" name="workgroup_name" id="workgroup_name">
                                    </cfif>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_workgroup&field_name=upd_expense.workgroup_name&field_id=upd_expense.workgroup_id&select_list=2','list');" title="<cfoutput>#getLang('main', 166)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-pos_code_text1">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 166)#</cfoutput> 1</label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="pos_code1" id="pos_code1" value="<cfoutput>#expense.RESPONSIBLE1#</cfoutput>">
                                    <cfif len(expense.RESPONSIBLE1)>
                                        <input type="text" name="pos_code_text1" id="pos_code_text1" style="width:200px;" value="<cfoutput>#get_emp_info(expense.RESPONSIBLE1,1,0)#</cfoutput>">
                                    <cfelse>
                                        <input type="text" name="pos_code_text1" id="pos_code_text1" style="width:200px;">
                                    </cfif>             
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_expense.pos_code1&field_name=upd_expense.pos_code_text1&select_list=1,9','list');return false" title="<cfoutput>#getLang('main', 166)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-pos_code_text2">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 166)#</cfoutput> 2</label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="pos_code2" id="pos_code2" value="<cfoutput>#expense.RESPONSIBLE2#</cfoutput>">
                                    <cfif len(expense.RESPONSIBLE2)>
                                        <input type="text" name="pos_code_text2" id="pos_code_text2" value="<cfoutput>#get_emp_info(expense.RESPONSIBLE2,1,0)#</cfoutput>">
                                    <cfelse>
                                        <input type="text" name="pos_code_text2" id="pos_code_text2">
                                    </cfif>  
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_expense.pos_code2&field_name=upd_expense.pos_code_text2&select_list=1,9','list');return false" title="<cfoutput>#getLang('main', 166)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-pos_code_text3">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 166)#</cfoutput> 3</label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="pos_code3" id="pos_code3" value="<cfoutput>#expense.RESPONSIBLE3#</cfoutput>">
                                    <cfif len(expense.responsible3)>
                                        <input type="text" name="pos_code_text3" id="pos_code_text3" value="<cfoutput>#get_emp_info(expense.RESPONSIBLE3,1,0)#</cfoutput>">
                                    <cfelse>
                                        <input type="text" name="pos_code_text3"  id="pos_code_text3">
                                    </cfif>  
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_expense.pos_code3&field_name=upd_expense.pos_code_text3&select_list=1,9','list');return false" title="<cfoutput>#getLang('main', 166)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_detail">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 217)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <textarea name="detail" id="detail"><cfoutput>#expense.detail#</cfoutput></textarea>
                            </div>
                        </div>
                        <cfif expense.hierarchy eq 1>
                            <label><cfoutput>#getLang('budget', 44)#</cfoutput></label>
                            <label><cfoutput>#getLang('budget', 43)#</cfoutput></label>    
                            </cfif>
                    </div>
                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12" type="column" index="2" sort="true">
                        <cfoutput>
                            <cfquery name="EXPENSE_ROW" datasource="#dsn2#">
                                SELECT 
                                    EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
                                    EXPENSE_CENTER_ROW.ACCOUNT_ID,
                                    EXPENSE_CENTER_ROW.ACCOUNT_CODE,
                                    EXPENSE_ITEMS.EXPENSE_ITEM_NAME
                                FROM 
                                    EXPENSE_CENTER_ROW
                                    LEFT JOIN EXPENSE_ITEMS ON EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID
                                WHERE 
                                    EXPENSE_CENTER_ROW.EXPENSE_ID = #attributes.expense_id#								
                            </cfquery>
                            <cfset is_muhasebe_butce = 1>
                            <cfif len(expense.IS_ACCOUNTING_BUDGET)>
                                <cfset is_muhasebe_butce = expense.IS_ACCOUNTING_BUDGET>
                            </cfif>
                            <div class="form-group" id="item-is_butce_">
                                <label><cf_get_lang dictionary_id="51379.Bütçe Kalemi İle İlişkilendir"><input onClick="change_type(0);" type="checkbox" name="is_butce_" id="is_butce_" <cfif isDefined('expense.IS_ACCOUNTING_BUDGET') and len(expense.IS_ACCOUNTING_BUDGET) and expense.IS_ACCOUNTING_BUDGET eq 0>checked</cfif>></label>
                            </div>
                            <div class="form-group" id="item-is_muhasebe_">
                                <label><cf_get_lang dictionary_id="51387.Muhasebe Kodu İle Eşleme Yapılsın"><input onClick="change_type(1);" type="checkbox" name="is_muhasebe_" id="is_muhasebe_" <cfif isDefined('expense.IS_ACCOUNTING_BUDGET') and len(expense.IS_ACCOUNTING_BUDGET) and expense.IS_ACCOUNTING_BUDGET eq 1>checked</cfif>></label>
                            </div>								
                            <!--- <div id="ccddee" style="z-index:150; overflow:auto;"> --->
                                <cf_grid_list>
                                    <thead>
                                        <input name="record_num" id="record_num" type="hidden" value="<cfif EXPENSE_ROW.recordcount>#EXPENSE_ROW.recordcount#<cfelse>0</cfif>">
                                        <input name="secim_tip" id="secim_tip" type="hidden" value="#is_muhasebe_butce#">
                                        <tr>
                                            <th width="20">
                                                <a href="javascript://" onClick="add_row();"><i class="fa fa-plus"></i></a>
                                            </th>
                                            <th id="butce_baslik" style="<cfif is_muhasebe_butce eq 1>display:none;</cfif>">#getLang('main', 822)# *</th>
                                            <th>#getLang('main', 1399)# *</th>
                                        </tr>
                                    </thead>							
                                    <tbody name="table1" id="table1">
                                        <cfif EXPENSE_ROW.recordcount>
                                            <cfloop query="EXPENSE_ROW">
                                                <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                                <tr id="frm_row#currentrow#" name="frm_row#currentrow#">
                                                    <td>
                                                        <a onclick="sil(#currentrow#);" ><img src="images/delete_list.gif" border="0"></a>
                                                    </td>
                                                    <td style="<cfif is_muhasebe_butce eq 1>display:none;</cfif>">	
                                                        <div class="form-group">														
                                                            <div class="input-group">
                                                                <input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
                                                                <input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#"value="#EXPENSE_ITEM_NAME#">
                                                                <span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="pencere_ac_item('#currentrow#');"></span>
                                                            </div>		
                                                        </div>													
                                                    </td>
                                                    <td>
                                                        <div class="form-group">
                                                            <div class="input-group">
                                                                <input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#account_id#">
                                                                <input type="text" name="account_code#currentrow#" id="account_code#currentrow#" onFocus="auto_acc_code(#currentrow#);" value="#account_code#" autocomplete="off"><span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onclick="pencere_ac_acc('#currentrow#');"></span>
                                                            </div>
                                                        </div>													
                                                    </td>    
                                                </tr>
                                            </cfloop>
                                        </cfif>
                                    </tbody>
                                </cf_grid_list>
                            <!--- </div> --->
                        </cfoutput>
                    </div>
                </cf_box_elements>
                <cf_box_footer>	
                    <div class="col col-6">
                        <cf_record_info query_name='expense'>
                        <cfquery name="GET_EXPENSE_ITEM_ROWS" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
                            SELECT EXPENSE_CENTER_ID FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_CENTER_ID = #attributes.EXPENSE_ID#
                        </cfquery>
                    </div>
                    <div class="col col-6">
                        <cfif get_expense_item_rows.recordcount or get_hier.recordcount>
                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=budget.list_expense_center&event=del&expense_id=#url.expense_id#' add_function='kontrol()'>
                        </cfif>
                    </div>
                </cf_box_footer>
            </cfif>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">

	function kontrol()
	{
		if(document.getElementById('exp_code').value == '')
		{
			alert("<cf_get_lang no='45.Masraf/Gelir Merkezi Kodu Girmelisiniz'>!");
			return false;
		}
		return true;
	}
	function LoadDepartmen(branch_id_)
	{
		var get_position_department_name = wrk_safe_query('bdg_get_position_department_name','dsn',0,branch_id_);
        document.upd_expense.department.options.length = 0;
        if (branch_id_ == -1)
        {
            document.upd_expense.department.options[0]=new Option('<cf_get_lang dictionary_id="32934.Tüm departmanlar">','-1')
        }
        else 
        {     
            document.upd_expense.department.options[0]=new Option('<cf_get_lang_main no="1424.Lutfen Departman Seçiniz">','0')
            if(get_position_department_name.recordcount != 0)
                for(var xx=0; xx < get_position_department_name.recordcount; xx++)
                    document.upd_expense.department.options[xx+1] = new Option(get_position_department_name.DEPARTMENT_HEAD[xx], get_position_department_name.DEPARTMENT_ID[xx]);
        }
    }
    function change_type(type)
	{
		var row_count = document.getElementById("record_num").value;
		var secim_tip_ = document.getElementById("secim_tip").value;
		var is_row_selected = 0;
		for(ii=0;ii<=row_count;ii++)
		{
			if(eval('document.upd_expense.row_kontrol'+ii) != undefined && eval('document.upd_expense.row_kontrol'+ii).value == 1)
			{
				is_row_selected = 1;
				break;
			}
		}
		if(is_row_selected == 1) 
		{
			alert("<cf_get_lang dictionary_id='51265.Önce Satırları Siliniz'> !");
			if(type == 0) 
				document.upd_expense.is_butce_.checked = false;
			if(type == 1) 
				document.upd_expense.is_muhasebe_.checked = false;
		}
		
		// Bütçe Kalemi İle Eşleme Yapılsın
		if(type == 0 && is_row_selected == 0) 
		{
			if(document.upd_expense.is_muhasebe_ != undefined)
				document.upd_expense.is_muhasebe_.checked = false;
			
			butce_baslik.style.display = '';
			document.getElementById("secim_tip").value = type;
		}
		
		// Muhasebe Kodu İle Eşleme Yapılsın
		if(type == 1 && is_row_selected == 0) 
		{
			if(document.upd_expense.is_butce_ != undefined)
				document.upd_expense.is_butce_.checked = false;
				
			butce_baslik.style.display='none';
			document.getElementById("secim_tip").value = type;
		}
		
    }
    function auto_acc_code(no)
	{
		AutoComplete_Create('account_code'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','CODE_NAME','account_code'+no,'','3','250');
	}
    var row_count = document.getElementById("record_num").value;
	function add_row()
	{
		var secim_tip_ = document.getElementById("secim_tip").value;
			
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);	
		document.upd_expense.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onclick="sil(' + row_count + ');"  ><i class="fa fa-minus"></i></a><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'">';
		
		if(secim_tip_ == 0)
		{
			newCell = newRow.insertCell(newRow.cells.length);		
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden"  name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'"><input type="text" name="expense_item_name' + row_count + '" id="expense_item_name' + row_count + '" onFocus="AutoComplete_Create(\'expense_item_name' + row_count +'\',\'EXPENSE_ITEM_NAME\',\'EXPENSE_ITEM_NAME\',\'get_expense_item\',\'<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>\',\'EXPENSE_ITEM_ID,ACCOUNT_CODE\',\'expense_item_id' + row_count +',account_code' + row_count +'\',\'upd_expense\',1);"  class="boxtext"><span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="pencere_ac_item(' + row_count + ');"></span></div></div>';
		}
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden"  name="account_id' + row_count +'" id="account_id' + row_count +'"><input type="text" name="account_code' + row_count + '" id="account_code' + row_count + '" onFocus="auto_acc_code(' + row_count + ');" class="boxtext"><span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onclick="pencere_ac_acc('+ row_count +');"></span></div></div>';
	}
	function pencere_ac_item(no,inc)
	{
		if(inc == 1) inc_ = "&is_income=1"; else inc_ = "";
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_exp_item&field_id=all.expense_item_id</cfoutput>' + no +'&field_account_no=all.account_code' + no +'&field_name=all.expense_item_name' + no + inc_,'list');
	}
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan_all&field_id=upd_expense.account_code</cfoutput>' + no +'','list');
	}
	function sil(sy)
	{
		var my_element=eval("upd_expense.row_kontrol"+sy);
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
</script>
