<cfinclude template="../query/get_expense.cfm">
<cfset getActivity = createobject("component","workdata.get_activity_types").getActivity()>
<cf_box title="#getLang(86,'Masraf ve Gelir Merkezleri',47152)# : #getLang(86,'Yeni Kayıt',45697)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="add_expense" method="post" action="#request.self#?fuseaction=budget.emptypopup_add_expense_center">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_production">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"></label>
                            <div class="col col-2 col-md-2 col-sm-3 col-xs-12"><cfoutput>#getLang('main', 44)#</cfoutput><input type="checkbox" name="is_production" id="is_production"></div>
                            <div class="col col-2 col-md-2 col-sm-3 col-xs-12"><cfoutput>#getLang('main', 2157)#</cfoutput><input type="checkbox" name="is_general" id="is_general" checked></div>
                        </div>
                        <div class="form-group" id="item-exp_cntr_code">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('budget', 56)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <select name="exp_cntr_code" id="exp_cntr_code" onChange="document.add_expense.head_exp_code.value=document.add_expense.exp_cntr_code[document.add_expense.exp_cntr_code.selectedIndex].value;" style="width:200px;">
                                    <option value=""><cfoutput>#getLang('main', 322)#</cfoutput></option>
                                    <cfoutput  query="get_expense">
                                        <option value="#expense_code#">
                                            <cfif ListLen(expense_code,".") neq 1>
                                                <cfloop from="1" to="#ListLen(expense_code,".")#" index="i">&nbsp;</cfloop>
                                            </cfif>
                                            #expense#
                                        </option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-head_exp_code">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('budget', 55)#</cfoutput>*</label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="head_exp_code" id="head_exp_code" readonly>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="exp_code" required="yes">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_name">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('budget', 54)#</cfoutput>*</label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <cfinput type="Text" name="expense_name" required="Yes" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 41)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <cfquery name="GET_BRANCH" datasource="#DSN#">
                                    SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH  ORDER BY BRANCH_NAME 
                                </cfquery>
                                <select name="branch" id="branch" onChange="LoadDepartmen(this.value)">
                                    <option value=""><cfoutput>#getLang('main', 322)#</cfoutput></option>
                                    <cfoutput query="get_branch">
                                        <option value="-1"><cf_get_lang_main no ="1698.Tüm Şubeler"></option>
                                        <option value="#branch_id#">#branch_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-department">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 160)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <select name="department" id="department">
                                    <option value=""><cfoutput>#getLang('main', 322)#</cfoutput></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-company_name">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 107)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="company_id" id="company_id">
                                    <input name="company_name" type="text" id="company_name" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','250');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=add_expense.company_name&field_comp_id=add_expense.company_id&select_list=2','list');" title="<cfoutput>#getLang('budget', 46)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-activity_id">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('budget', 90)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <select name="activity_id" id="activity_id" style="width:200px;">
                                    <option value=""><cfoutput>#getLang('main', 322)#</cfoutput></option>
                                    <cfoutput  query="getActivity">
                                        <option value="#activity_id#">#activity_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-workgroup">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 728)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="workgroup_id" id="workgroup_id" value="">
                                    <input type="text" name="workgroup_name" id="workgroup_name">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_workgroup&field_name=add_expense.workgroup_name&field_id=add_expense.workgroup_id','wide');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-pos_code_text1">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 166)#</cfoutput> 1</label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="pos_code1" id="pos_code1" value="">
                                    <input type="text" name="pos_code_text1" id="pos_code_text1">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_expense.pos_code1&field_name=add_expense.pos_code_text1&select_list=1,9','list');" title="<cfoutput>#getLang('main', 166)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-pos_code_text2">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 166)#</cfoutput> 2</label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="pos_code2" id="pos_code2" value="">
                                    <input type="text" name="pos_code_text2" id="pos_code_text2">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_expense.pos_code2&field_name=add_expense.pos_code_text2&select_list=1,9','list');" title="<cfoutput>#getLang('main', 166)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-pos_code_text3">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 166)#</cfoutput> 3</label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="pos_code3" id="pos_code3" value="">
                                    <input type="text" name="pos_code_text3" id="pos_code_text3">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_expense.pos_code3&field_name=add_expense.pos_code_text3&select_list=1,9','list');" title="<cfoutput>#getLang('main', 166)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_detail">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cfoutput>#getLang('main', 217)#</cfoutput></label>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12">
                                <div class="input-group col-12">
                                    <textarea name="expense_detail" id="expense_detail"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                    <cf_box_footer>	
                    <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
                    <cf_box_footer>	
            </div>
        </div>
    </div>
</cfform>
</cf_box>
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
       document.add_expense.department.options.length = 0;
        if (branch_id_ == -1)
        {
            document.add_expense.department.options[0]=new Option('<cf_get_lang dictionary_id="32934.Tüm departmanlar">','-1')
        }
        else 
        {           
            document.add_expense.department.options[0]=new Option('<cf_get_lang_main no="1424.Lutfen Departman Seçiniz">','0')
            if(get_position_department_name.recordcount != 0)
                for(var xx=0;xx<get_position_department_name.recordcount;xx++)
                    document.add_expense.department.options[xx+1]=new Option(get_position_department_name.DEPARTMENT_HEAD[xx],get_position_department_name.DEPARTMENT_ID[xx]);
        }
	}
</script>
