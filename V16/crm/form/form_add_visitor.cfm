<cf_catalystHeader>

<cfparam name="attributes.VISIT_ID"  default=""/>
<cfparam name="attributes.EMP_ID"  default=""/>

<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset get_branches = cmp_branch.get_branch(branch_status:1,comp_id : session.ep.company_id)>
<cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
<cfset cmp_department.dsn = dsn>
<cfset get_department = cmp_department.get_department()>

                    
<div class= "col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="visitorbook" method="post" action=""> 
            <cfinput type="hidden" id="dept_id" name="dept_id" value="">
            <cfinput type="hidden" id="visit_id" name="visit_id" value="">        
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">

                    <div class="form-group" id="item-VISIT_NAME">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12" for="VISIT_NAME"><cf_get_lang dictionary_id='57897.Adı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input name="VISIT_NAME"type="text" class="form-control" id="VISIT_NAME">
                        </div>
                    </div>
                            
                    <div class="form-group" id="item-VISIT_SURNAME">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12" for="VISIT_SURNAME"> <cf_get_lang dictionary_id='58550.Soyadı'> </label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input name="VISIT_SURNAME" type="text" class="form-control" id="VISIT_SURNAME">
                        </div>
                    </div>

                    <div class="form-group" id="item-CARD_NO">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12" for="CARD_NO"> <cf_get_lang dictionary_id='30364.Kart Numarası'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input name="CARD_NO" type="text" class="form-control" id="CARD_NO">
                        </div>
                    </div>

                    <div class="form-group" id="item-VISIT_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52370.Ziyaret Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
                                <cfinput name="VISIT_DATE" id="VISIT_DATE" validate="#validate_style#" maxlength="10" type="text" required="yes">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="VISIT_DATE" ></span>
                            </div>        
                        </div>
                    </div>

                    <div class="form-group" id="item-START_TIME">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61007.Giriş Saati'></label>
                        <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cf_wrkTimeFormat name="START_TIME" value="0">
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <select name="START_MINUTE" id="START_MINUTE">
                                    <option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
                                    <cfloop from="1" to="59" index="i">
                                        <cfoutput>
                                            <option value="#i#">#i#</option>
                                        </cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" id="item-END_TIME">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61008.Çıkış Saati'></label>
                        <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cf_wrkTimeFormat name="END_TIME" value="0">
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <select name="FINISH_MINUTE" id="FINISH_MINUTE">
                                    <option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
                                    <cfloop from="1" to="59" index="i">
                                        <cfoutput>
                                            <option value="#i#">#i#</option>
                                        </cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </div>                                      
                    
                    <div class="form-group" id="item-REASON_VISIT">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12" for="REASON_VISIT"> <cf_get_lang dictionary_id='39774.Ziyaret Nedeni'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <textarea name="REASON_VISIT" type="text" class="form-control" id="REASON_VISIT" rows="10" cols="5"></textarea>
                        </div>
                    </div>

                    <div class="form-group" id="item-expense_employee">
                        <label class="col col-4 col-xs-12" for="EMP_ID"><cf_get_lang dictionary_id="57576.Çalışan" >*</label>
                        <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="EMP_ID" id="EMP_ID" value="<cfoutput>#attributes.EMP_ID#</cfoutput>">
                            <input type="text" name="expense_employee" id="expense_employee" value="<cfoutput>#get_emp_info(attributes.EMP_ID,0,0)#</cfoutput>" onfocus="AutoComplete_Create('expense_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','EMP_ID','','3','125');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=visitorbook.EMP_ID&field_name=visitorbook.expense_employee&field_type=visitorbook.EMP_ID&field_dep_id=visitorbook.DEPARTMENT_ID&field_branch_id=visitorbook.branch_id&call_function=change_dept()&select_list=1,9','list');"></span>
                        </div>
                        </div>
                    </div>

                    <div class="form-group" id="item-branch">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                        <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" >
                            <cfoutput query="get_branches" group="NICK_NAME">
                            <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                            <cfoutput>
                                <option value="#get_branches.BRANCH_ID#">#get_branches.BRANCH_NAME#</option>
                            </cfoutput>
                            </cfoutput>
                        </select>
                        </div>
                    </div>
                    
                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-8 col-xs-12" id="department_div">
                        <select name="DEPARTMENT_ID" id="DEPARTMENT_ID"  onChange="showDepartment(this.value)">  
                            <option value=""><cf_get_lang_main no='160.Departman'></option>
                            <cfoutput query="get_department">
                                <option value="#get_department.DEPARTMENT_ID#" >#get_department.DEPARTMENT_HEAD#</option>
                            </cfoutput>        
                        </select>
                        </div>
                    </div>
                </div> 
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons add_function="kontrol()">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>


<script>
    function showDepartment(branch_id)	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
		}
    } 
    function change_dept(){
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
            var delayInMilliseconds = 1000; //1 second
            setTimeout(function() {
                document.getElementById('DEPARTMENT_ID').value = document.getElementById('DEPARTMENT_ID').value;
            }, delayInMilliseconds);
		}
	}
    function kontrol(){
        if (!$('#EMP_ID').val()){
            alert("<cf_get_lang dictionary_id='52097.Boş alan bırakmayın'>");
            $('#expense_employee').focus();
            return false;
        }
        if (!$('#VISIT_DATE').val()){
            alert("<cf_get_lang dictionary_id='52097.Boş alan bırakmayın'>");
            $('#VISIT_DATE').focus();
            return false;
        }
        return true;
    }
</script>