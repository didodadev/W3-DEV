<cfquery name="get_fire_detail" datasource="#dsn#">
	SELECT
		EMPLOYEES_IN_OUT.*,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		EMPLOYEES_IN_OUT,
		EMPLOYEES
	WHERE
		EMPLOYEES_IN_OUT.IN_OUT_ID = #attributes.in_out_id#
		AND EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
</cfquery>
<cfif len(get_fire_detail.FINISH_DATE)>
	<cfquery name="get_puantaj_id" datasource="#dsn#">
		SELECT
			*
		FROM
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_PUANTAJ_ROWS
		WHERE
			EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
			AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #get_fire_detail.employee_id#
			AND EMPLOYEES_PUANTAJ.SAL_YEAR = #YEAR(get_fire_detail.FINISH_DATE)#
			AND EMPLOYEES_PUANTAJ.SAL_MON = #MONTH(get_fire_detail.FINISH_DATE)#
	</cfquery>
</cfif>
<cfif get_fire_detail.recordcount>
<cfset attributes.employee_id = get_fire_detail.employee_id>
<!---<cfsavecontent variable="img"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_add_position_in"><img src="/images/plus1.gif" title="<cf_get_lang no ='1030.İşe Giriş İşlemi Yap'>"></a></cfsavecontent>--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','İşe Giriş Çıkışlar','52965')#" scroll="1" collapsable="1" resize="1"
    popup_box="#iif(isdefined("attributes.draggable"),1,0)#"
    print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#url.in_out_id#&print_type=179&iid=#attributes.employee_id#">
        <cfform name="upd_fire2" action="#request.self#?fuseaction=ehesap.emptypopup_upd_unfired" method="post">
            <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_fire_detail.employee_id#</cfoutput>">
            <input type="hidden" name="counter" id="counter" value="">
            <cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#"> 
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-employee">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <label class="col col-9 col-xs-12"><cfoutput>#get_fire_detail.employee_name# #get_fire_detail.employee_surname#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-9 col-xs-12">
                            <cfif not session.ep.ehesap>
                            <cfinclude template="../query/get_emp_branches.cfm">
                        </cfif>
                        <cfif session.ep.ehesap or ListFindNoCase(emp_branch_list, get_fire_detail.branch_id, ',')>
                            <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_fire_detail.branch_id#</cfoutput>">
                            <cfset attributes.branch_id = get_fire_detail.branch_id>
                            <cfinclude template="../query/get_branch_ssk.cfm">		
                            <cfif not get_branch_ssk.recordcount>
                                <script type="text/javascript">
                                    alert("<cf_get_lang dictionary_id='53619.Şube SSK Bilgileri Eksik'> !");
                                    window.close();
                                </script>
                                <cfabort>
                            </cfif>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57453.Şube'>!</cfsavecontent>
                            <cfinput type="text" name="branch_name" id="branch_name" value="#get_branch_ssk.branch_name#" required="yes" message="#message#" readonly="yes" style="width:200px;">
                        <cfelse>
                            <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_fire_detail.branch_id#</cfoutput>">
                            <cfset attributes.branch_id = get_fire_detail.branch_id>
                            <cfinclude template="../query/get_branch_ssk.cfm">
                            : <cfoutput>#get_branch_ssk.BRANCH_NAME#-#get_branch_ssk.SSK_OFFICE#-#get_branch_ssk.SSK_NO#</cfoutput>
                        </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-department_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-9 col-xs-12">
                            <cfif len(get_fire_detail.department_id)>
                                <cfquery name="DEPARTMENT" datasource="#DSN#">
                                    SELECT DEPARTMENT_HEAD FROM  DEPARTMENT  WHERE DEPARTMENT_ID = #get_fire_detail.DEPARTMENT_ID#
                                </cfquery>
                                <cfset department_name = DEPARTMENT.DEPARTMENT_HEAD>
                            <cfelse>
                                <cfset department_name = "">
                            </cfif>
                            <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_fire_detail.department_id#</cfoutput>">
                        <cfif session.ep.ehesap or ListFindNoCase(emp_branch_list, get_fire_detail.branch_id, ',')>				  
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57572.Departman'>!</cfsavecontent>
                            <cfinput type="text" name="department_name" id="department_name" value="#department_name#" required="yes" message="#message#" readonly="yes" style="width:200px;">
                            <!---  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=upd_fire2.department_id&field_name=upd_fire2.department_name&field_branch_id=upd_fire2.branch_id&field_branch_name=upd_fire2.branch_name</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> --->
                        <cfelse>
                            <cfoutput>#department_name#</cfoutput>
                        </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-start_date">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinclude template="../query/get_emp_branches.cfm">
                            <cfif session.ep.ehesap or ListFindNoCase(emp_branch_list, get_fire_detail.branch_id, ',')>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi">!</cfsavecontent>
                                <cfinput type="text" name="start_date" id="start_date" validate="#validate_style#" value="#dateformat(get_fire_detail.start_date,dateformat_style)#" message="#message#" maxlength="10" required="yes" style="width:65px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                <cfelse>
                                : <cfoutput>#dateformat(get_fire_detail.start_date,dateformat_style)#</cfoutput>
                            </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_5084">
                        <label class="col col-3 col-xs-12">5084 (5615)</label>
                        <cfif session.ep.ehesap or ListFindNoCase(emp_branch_list,get_fire_detail.branch_id, ',')>
                            <div class="col col-9 col-xs-12">
                                <input type="checkbox" name="is_5084" id="is_5084" value="1"<cfif get_fire_detail.is_5084 is "1"> checked</cfif>>
                                <label><cf_get_lang dictionary_id ='53986.Teşvik Yasası'></label>
                            </div>
                        <cfelse>
                            <div class="col col-9 col-xs-12">
                                <label><cf_get_lang dictionary_id='36988.Dahil'> <cfif get_fire_detail.is_5084 neq "1"> <cf_get_lang dictionary_id='53620.Değil'> </cfif>&nbsp <b><cf_get_lang dictionary_id ='53986.Teşvik Yasası'></b></label>
                            </div>
                        </cfif>
                    </div>
                    <div class="form-group" id="item-is_5510">
                        <label class="col col-3 col-xs-12">5763</label>
                        <cfif session.ep.ehesap or ListFindNoCase(emp_branch_list,get_fire_detail.branch_id, ',')>
                            <div class="col col-9 col-xs-12">
                                <input type="checkbox" name="is_5510" id="is_5510" value="1"<cfif get_fire_detail.is_5510 is "1"> checked</cfif>>
                                <label><cf_get_lang dictionary_id ='59510.İstihdam Yasası'></label>
                            </div>
                        <cfelse>
                            <div class="col col-9 col-xs-12">
                                <label><cf_get_lang dictionary_id='36988.Dahil'> <cfif get_fire_detail.is_5510 neq "1"> <cf_get_lang dictionary_id='53620.Değil'> </cfif>&nbsp <b><cf_get_lang dictionary_id ='59510.İstihdam Yasası'></b></label>
                            </div>
                        </cfif>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_fire_detail">
                <cfif session.ep.ehesap or ListFindNoCase(emp_branch_list, get_fire_detail.branch_id, ',')>
                    <cf_workcube_buttons is_upd='1' is_del='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_fire&in_out_id=#attributes.in_out_id#&head=#get_fire_detail.employee_name# #get_fire_detail.employee_surname#' add_function='kontrol()'>
                </cfif>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('is_5084').checked==true && document.getElementById('is_5510').checked==true)
			{
			alert("<cf_get_lang dictionary_id ='53987.İki Kanundan Aynı Anda Yararlanamazsınız'>!");
			return false;
			}
	}
</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='53622.Böyle bir giriş çıkış kaydı bulunamadı'>!");
		window.close();
	</script>
</cfif>
<script type="text/javascript">
	function employment_control(value)
	{
		if(value==1)
			document.getElementById('is_5510').checked=false;
		else if(value==2)
			document.getElementById('is_5084').checked=false;
	}
</script>
