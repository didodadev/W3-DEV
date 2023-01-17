<cfquery name="get_poscat_positions" datasource="#dsn#">
    SELECT
        E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,E.EMPLOYEE_NO,E.EMPLOYEE_ID,EIO.IN_OUT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
    FROM
        EMPLOYEES_IN_OUT EIO
        INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID=EIO.EMPLOYEE_ID
        LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EIO.EMPLOYEE_ID
        LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID=EIO.DEPARTMENT_ID
        LEFT JOIN BRANCH B ON D.BRANCH_ID=B.BRANCH_ID
    WHERE
        1=1
        
    ORDER BY
        EMPLOYEE_NAME
</cfquery>	
<cf_xml_page_edit>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','BES','63079')#-#getLang('','Bireysel Emeklilik','63080')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_ext_salary" action="#request.self#?fuseaction=ehesap.emptypopup_form_add_bes_single" method="post">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="3" type="column" sort="true">
                    <div class="form-group" id="item-emp_no">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58487.Çalışan No'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="empno" id="empno" value="" readonly placeholder="<cf_get_lang dictionary_id='46197.Lütfen Çalışan Seçiniz'>">
                        </div>
                    </div>
                    <div class="form-group" id="item-emp_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_in_out_id" id="employee_in_out_id" value="">
                                <input type="text" name="employee_name" id="employee_name"  value="">
                                <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=add_ext_salary.employee_in_out_id&field_emp_name=add_ext_salary.employee_name&field_emp_id=add_ext_salary.employee_id&field_emp_no=add_ext_salary.empno&field_branch_and_dep=add_ext_salary.department' ,'list');"></span>
                                <input type="hidden" value="" name="employee_id" id="employee_id">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="department" id="department" value="" readonly>
                        </div>
                    </div>
                    <div class="form-group" id="item-bes_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59665.BES Türü'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="input-group">
							    
							    <input type="text" name="comment_pay0" id="comment_pay0" value="">
                                <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('index.cfm?fuseaction=ehesap.popup_list_bes&add_single=1&comment_pay=add_ext_salary.comment_pay0&start_sal_mon=add_ext_salary.start_sal_mon0&end_sal_mon=add_ext_salary.end_sal_mon0&amount_pay=add_ext_salary.amount_pay0&odkes_id=add_ext_salary.odkes_id0','medium');"></span>
                                <input type="hidden" name="odkes_id0" id="odkes_id0" value="">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-period">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <select name="term0" id="term0">
                                <cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="i">
                                <cfoutput>
                                    <option value="#i#"<cfif session.ep.period_year eq i> selected</cfif>>#i#</option>
                                </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-start_sal_mon">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <select name="start_sal_mon0" id="start_sal_mon0">
                                <cfloop from="1" to="12" index="j">
                                    <cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="4" type="column" sort="true">
                    <div class="form-group" id="item-end_sal_mon">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <select name="end_sal_mon0" id="end_sal_mon0">
                                <cfloop from="1" to="12" index="j">
                                <cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-amount_pay">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45126.BES Oranı'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="amount_pay0" id="amount_pay0" class="moneybox" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-society_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62968.Sigorta Kurumu'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <cfquery name="GET_SOCIETIES" datasource="#DSN#">
                                SELECT SOCIETY_ID,SOCIETY FROM SETUP_SOCIAL_SOCIETY ORDER BY SOCIETY
                            </cfquery>
                            <select name="society_type" id="society_type">
                                <option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
                                <cfoutput query="GET_SOCIETIES">
                                    <option value="#SOCIETY_ID#">#SOCIETY#</option>
                                </cfoutput>
                            </select>,
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
    function kontrol()
{
   
	if(document.getElementById('employee_name').value == 0)
    {
        alert("<cf_get_lang dictionary_id='46197.Lütfen Çalışan Seçiniz'>!")
        return false;
    }

    if(document.getElementById('comment_pay0').value == 0)
    {
        alert("<cf_get_lang dictionary_id='59665.BES Türü'><cf_get_lang dictionary_id='57734.Seçiniz'>!")
        return false;
    }

    var employee_id = $('#employee_id').val();
    var new_sql = "SELECT DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) AS YAS,* FROM EMPLOYEES_IDENTY WHERE EMPLOYEE_ID ="+employee_id;
	var get_age = wrk_query(new_sql,'dsn');
    var xml_bes_age = <cfoutput>#xml_bes_definition_age#</cfoutput>;
	var emp_age_ = get_age.YAS[0];
	if (emp_age_ > xml_bes_age)
    {
        alert('<cf_get_lang dictionary_id="40114.Çalışan Yaşı">' + xml_bes_age + ' <cf_get_lang dictionary_id="64067.yaşından büyük olduğu için Bes sistemine dahil edilemez.">');
        return false;
    }
    <cfif isdefined("attributes.draggable")>
        loadPopupBox('add_ext_salary' , <cfoutput>#attributes.modal_id#</cfoutput>);
        return false;
    </cfif>
}
</script>
