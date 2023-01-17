<cfquery name="get_setup_salary" datasource="#dsn#">
	SELECT * FROM SALARY_UPDATE WHERE UPDATE_ID = #UPDATE_ID#
</cfquery>
<cfquery name="get_setup_salary_yearS" datasource="#dsn#">
	SELECT * FROM SALARY_UPDATE_YEARS WHERE	UPDATE_ID = #UPDATE_ID#
</cfquery>
<cfquery name="get_setup_salary_COMPANIES" datasource="#dsn#">
	SELECT * FROM SALARY_UPDATE_COMPANIES WHERE	UPDATE_ID = #UPDATE_ID#
</cfquery>
<cfquery name="get_setup_salary_position_cats" datasource="#dsn#">
	SELECT * FROM SALARY_UPDATE_POSITION_CATS WHERE	UPDATE_ID = #UPDATE_ID#
</cfquery>
<cfset COMPANY_LIST = VALUELIST(get_setup_salary_COMPANIES.OUR_COMPANY_ID,",")>
<cfset POSITION_CAT_LIST = VALUELIST(get_setup_salary_position_cats.POSITION_CAT_ID,",")>
<cf_catalystHeader>
	<cfform name="upd_salary" action="#request.self#?fuseaction=ehesap.emptypopup_upd_setup_salary" method="post">
    	<input type="hidden" name="update_id" id="update_id" value="<cfoutput>#attributes.update_id#</cfoutput>"/>
        <div class="row">
            <div class="col col-12 uniqueRow">
                <div class="row formContent"> 
                    <div class="row" type="row">
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-salary_type">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53556.Maaş Türü"></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="salary_type" id="salary_type" style="width:175px;">
                                        <option value="0" <cfif GET_SETUP_SALARY.salary_type eq 0>selected</cfif>><cf_get_lang dictionary_id="53560.Planlanan Maaş"></option>
                                        <option value="1" <cfif GET_SETUP_SALARY.salary_type eq 1>selected</cfif>><cf_get_lang dictionary_id="53562.Gerçek Maaş"></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-method_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53508.Zam Metodu'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="method_id" id="method_id" style="width:175px;">
                                        <option value="0" <cfif GET_SETUP_SALARY.METHOD_TYPE eq 0>selected</cfif>><cf_get_lang dictionary_id='53509.Önceki Ay Maaşını Baz Al'></option>
                                        <option value="1" <cfif GET_SETUP_SALARY.METHOD_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='53510.Ay Maaşını Baz Al'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-sal_mon">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53346.Takvim'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <select name="sal_mon" id="sal_mon">
                                            <cfloop from="1" to="12" index="i">
                                            <cfoutput>
                                                <option value="#i#"<cfif GET_SETUP_SALARY.sal_mon eq i> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                            </cfoutput>
                                            </cfloop>
                                        </select>
                                        <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53350.ve sonrasında'>%</span>
                                        <span class="input-group-addon no-bg"></span>
                                        <span><cfsavecontent variable="message"><cf_get_lang dictionary_id='53443.yüzde giriniz'></cfsavecontent>
										<cfinput type="text" name="percent" id="percent"  style="width:50px;" validate="float" maxlength="5" message="#message#" value="#tlformat(GET_SETUP_SALARY.update_percent-100,1)#"></span>
                                        <span class="input-group-addon no-bg">
                                            <select name="status" id="status">
                                                <option value="1"<cfif sgn(GET_SETUP_SALARY.update_percent) eq 1> selected</cfif>><cf_get_lang dictionary_id='57582.Ekle'></option>
                                                <option value="-1"<cfif sgn(GET_SETUP_SALARY.update_percent) eq -1> selected</cfif>><cf_get_lang dictionary_id='53354.Çıkar'></option>
                                            </select>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-work_start_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53348.İşe giriş tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="alert"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='53348.İşe Giriş Tarihi'></cfsavecontent>
										<cfinput validate="#validate_style#" type="text" name="work_start_date" id="work_start_date" value="#dateformat(GET_SETUP_SALARY.work_start_date,dateformat_style)#" style="width:150px;" maxlength="10" message="#alert#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="work_start_date"></span> <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53352.den önce olanlar'></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-work_finish_date">
                                <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='53348.İşe giriş tarihi'></span></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='54165.İşe Giriş Tarihi Aralık Sonu'></cfsavecontent>
										<cfinput validate="#validate_style#" type="text" name="work_finish_date" id="work_finish_date" value="#dateformat(GET_SETUP_SALARY.work_finish_date,dateformat_style)#" style="width:150px;" maxlength="10" message="#alert#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="work_finish_date"></span> <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53353.den sonra olanlar'></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-control_finishdate">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53569.Çıkış Kontrol"></label>
                                <label class="col col-8 col-xs-12">
                                    <input type="checkbox" value="1" name="control_finishdate" id="control_finishdate"<cfif GET_SETUP_SALARY.control_finishdate eq 1> checked</cfif>>
                                    <cf_get_lang dictionary_id="53574.Çıkış Tarihi Olmayan Çalışanlar">
                                </label>
                            </div>
                            <div class="form-group" id="item-change_all">
                                <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id="53569.Çıkış Kontrol"></span></label>
                                <label class="col col-8 col-xs-12">
                                    <input type="checkbox" value="1" name="change_all" id="change_all"<cfif GET_SETUP_SALARY.change_all eq 1> checked</cfif>>
                                    <cf_get_lang dictionary_id='53351.Sadece Etkilensin Olanlar'>
                                </label>
                            </div>
                            <cfset YEAR_LIST = "#YEAR(NOW())#,#YEAR(NOW())+1#,#YEAR(NOW())+2#,#VALUELIST(get_setup_salary_yearS.SAL_YEAR)#">
							<cfset YEAR_LIST = ListDeleteDuplicates(ListSort(year_list,"Numeric","Asc"))>
                            <div class="form-group" id="item-sal_year">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53482.Yıllar'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfloop from="#year(now())#" to="#year(now())+2#" index="i">
                                        <cfoutput>
                                        <label><input type="checkbox" name="sal_year" id="sal_year" value="#i#"<cfif LISTCONTAINSNOCASE(valuelist(get_setup_salary_yearS.SAL_YEAR),i,",")> checked</cfif>>#i#</label>
                                        </cfoutput>
                                    </cfloop>
                                </div>
                            </div>
                            <div class="form-group" id="item-our_company_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_multiselect_check
                                    name="our_company_id"
                                    option_name="NICK_NAME"
                                    option_value="COMP_ID"
                                    width="175"
                                    value="#COMPANY_LIST#"
                                    table_name="OUR_COMPANY">
                                </div>
                            </div>
                            <div class="form-group" id="item-POSITION_CAT_ID">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_multiselect_check
                                        name="POSITION_CAT_ID"
                                        option_name="POSITION_CAT"
                                        option_value="POSITION_CAT_ID"
                                        value="#POSITION_CAT_LIST#"
                                        table_name="SETUP_POSITION_CAT"
                                        width="175"
                                        >
                                </div>
                            </div>
                            <cfif GET_SETUP_SALARY.VALID EQ 1>
                                <div class="form-group" id="item-valid">
                                    <cfset attributes.employee_id = GET_SETUP_SALARY.valid_emp>
                                    <cfinclude template="../query/get_employee.cfm">
                                   <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
                                   <div class="col col-8 col-xs-12">
                                       <cf_get_lang dictionary_id='58699.Onaylandı'> - <cfoutput>#get_employee.employee_name# #get_employee.employee_surname# - #dateformat(GET_SETUP_SALARY.valid_date,dateformat_style)#</cfoutput>
                                   </div>
                                </div>
                           <cfelseif GET_SETUP_SALARY.VALID EQ 0>
                           		<div class="form-group" id="item-valid">
									<cfset attributes.employee_id = GET_SETUP_SALARY.valid_emp>
                                    <cfinclude template="../query/get_employee.cfm">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_get_lang dictionary_id='57617.Reddedildi'> - <cfoutput>#get_employee.employee_name# #get_employee.employee_surname# - #dateformat(GET_SETUP_SALARY.valid_date,dateformat_style)#</cfoutput>
                                    </div>
                                </div>
                            <cfelse>
                                <div class="form-group" id="item-position_code">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfset attributes.position_code = GET_SETUP_SALARY.validator_position>
                                            <cfinclude template="../query/get_position.cfm">
                                            <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#GET_SETUP_SALARY.validator_position#</cfoutput>">
                                            <input type="text" name="employee" id="employee" value="<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>" style="width:175px;" readonly>
                                            <span class="input-group-addon icon-ellipsis btnPointer" onClick=" windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_code=upd_salary.position_code&field_emp_name=upd_salary.employee</cfoutput>','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-valid">
                                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='57500.Onay'></span></label>
                                    <label class="col col-8 col-xs-12"><cfif session.ep.ehesap or (len(GET_SETUP_SALARY.validator_position) and GET_SETUP_SALARY.validator_position eq session.ep.position_code)>
                                        <input type="hidden" name="valid" id="valid" value="">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='53999.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz'></cfsavecontent>
                                        <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id ='58475.Onayla'>" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {form_chk();upd_salary.valid.value='1'} else {return false}" border="0">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54000.Reddetmekte Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Reddetmek istediğinizden emin misiniz'></cfsavecontent>
                                        <input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id='58461.Reddet'>" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {form_chk();upd_salary.valid.value='0'} else {return false}" border="0">
                                    </cfif></label>
                                    <label></label>
                                </div>
                            </cfif>
                        </div>    
                    </div>
                    <div class="row formContentFooter">
                        <div class="col col-6">
                            <cf_record_info query_name="GET_SETUP_SALARY">
                        </div>
                        <div class="col col-6">
                            <cfif Not Len(GET_SETUP_SALARY.VALID)>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54094.Toplu Maaş Ayarlaması Yapıyorsunuz Emin misiniz?'></cfsavecontent>
                                <cfsavecontent variable="message2"><cf_get_lang dictionary_id ='54095.Toplu Maaş Ayarlaması Siliyorsunuz! Emin misiniz?'></cfsavecontent>
                                <cf_workcube_buttons is_upd='1' add_function="confirm('#message#') && form_chk()" delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_setup_salary&update_id=#update_id#&is_delete=1' delete_alert='#message2#'>
                            <cfelse>
                                <cfif session.ep.admin eq 1 or session.ep.ehesap eq 1>
                                <cf_workcube_buttons is_upd='1' is_insert='0' delete_info='İşlemi Geri Al' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_setup_salary&update_id=#update_id#&call_back=1' delete_alert='Hareketleri Geri Alıyorsunuz. Emin misiniz?'>
                                </cfif>
                            </cfif>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</cfform>
<script type="text/javascript">
	function form_chk()
	{
		/*ŞİRKET SEÇİLMELİ*/
		if(document.getElementById('our_company_id').value=='')
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='57574.Şirket'>");
			return false;
		}
		/*YIL SEÇİLMELİ*/
		flag = 0;
		for (i=0;i < document.getElementsByName('sal_year').length;i++)
			if (upd_salary.sal_year[i].checked)
				flag = 1;
		if (!flag)
		{
			alert("<cf_get_lang dictionary_id ='54035.En az bir yıl seçmelisiniz'> !");
			return false;
		}
		
		document.getElementById('percent').value = filterNum(document.getElementById('percent').value,1);
		return true;
	}
</script>
