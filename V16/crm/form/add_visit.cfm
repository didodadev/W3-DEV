<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfif fusebox.use_period eq true>
    <cfset dsn_2 = dsn2>
<cfelse>
    <cfset dsn_2 = dsn>
</cfif>
<cfquery name="GET_EXPENSE" datasource="#dsn_2#">
	SELECT EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
</cfquery>		
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cf_box title="#getlang('crm',198)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_visit" method="post" action="#request.self#?fuseaction=crm.popup_add_visit_row#iif(isdefined('attributes.draggable'),DE('&draggable=1'),DE(''))#">
        <input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
        <input type="hidden" name="kontrol_date_value" id="kontrol_date_value" value="<cfoutput>#dateformat(date_add('d',-7,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')),dateformat_style)#</cfoutput>">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang no='207.Ziyaret Edilecek '> *</label>
                    <div class="col col-8">
                        <cfif isdefined("attributes.company_id")>
                            <cfquery name="GET_MANAGER_ID" datasource="#DSN#">
                                SELECT 
                                    COMPANY_PARTNER.PARTNER_ID
                                FROM
                                    COMPANY,
                                    COMPANY_PARTNER
                                WHERE
                                    COMPANY.COMPANY_ID = #attributes.company_id# AND
                                    COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
                                    COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID 
                            </cfquery>
                            <div class="col col-6"> 
                                <input name="company_id" id="company_id" type="hidden" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                <cfsavecontent variable="message"><cf_get_lang no='405.Ziyaret Edilecek Giriniz !'></cfsavecontent>
                                <cfinput name="company_name" type="text" readonly="yes" required="yes" message="#message#" value="#get_par_info(attributes.company_id,1,0,0)#">
                            </div>
                            <div class="col col-6"> 
                                <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_manager_id.partner_id#</cfoutput>">
                                <cfsavecontent variable="message"><cf_get_lang no='457.Partner Giriniz '> !</cfsavecontent>
                                <cfinput type="text" name="partner_name" readonly="yes" value="#get_par_info(get_manager_id.partner_id,0,-1,0)#" required="yes" message="#message#">
                            </div>
                        <cfelse>
                            <div class="col col-6">                            
                                <input name="company_id" id="company_id" type="hidden" value="">
                                <cfinput name="company_name" type="text" readonly="yes" required="yes" message="Ziyaret Edilecek Giriniz !" value="">                            
                                <input type="hidden" name="partner_id" id="partner_id">
                                <cfsavecontent variable="message"><cf_get_lang no='457.partner Giriniz !'></cfsavecontent>
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfinput type="text" name="partner_name" readonly="yes" required="yes" message="#message#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&field_comp_id=add_visit.company_id&field_comp_name=add_visit.company_name&field_id=add_visit.partner_id&field_name=add_visit.partner_name&is_single=1','wide');"></span>
                                </div>
                            </div>
                        </cfif>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang no='107.Yetkili Şubeler'> *</label>
                    <div class="col col-8">
                        <select name="sales_zones" id="sales_zones">
                            <option value=""><cf_get_lang_main no='41.Şube'></option>
                            <cfoutput query="get_branch">
                                <option value="#branch_id#" <cfif listgetat(session.ep.user_location,2,'-') eq branch_id>selected</cfif>>#branch_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang no='270.Ziyaret Nedeni'> *</label>
                    <div class="col col-8">
                        <cf_wrk_combo
                        name="visit_type"
                        query_name="GET_VISIT_TYPES"
                        option_name="visit_type"
                        option_value="visit_type_id"
                        width="195">
                    </div>
                </div> 
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang no='271.Gerçekleşme Tarihi'>*</label>
                    <cfsavecontent variable="message">Gerçekleşme Tarihi Giriniz !</cfsavecontent>
                    <div class="col col-8">
                        <div class="col col-12 pr-0 padding-bottom-5">
                            <div class="input-group">
                                <cfinput type="text" name="execute_startdate" validate="#validate_style#" message="#message#" value="" required="yes">
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="execute_startdate">
                                </span>
                            </div>
                        </div>
                        <div class="col col-3">
                            <select name="execute_start_clock" id="execute_start_clock">
                                <option value="0" selected><cf_get_lang_main no='79.Saat'></option>
                                <cfloop from="7" to="30" index="i">
                                    <cfset saat=i mod 24>
                                    <cfoutput><option value="#saat#" <cfif saat eq 9>selected</cfif>>#saat#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                        <div class="col col-3">
                            <select name="execute_start_minute" id="execute_start_minute">
                                <cfloop from="0" to="55" index="a" step="5">
                                    <cfoutput><option value="#Numberformat(a,00)#" <cfif a eq 30>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                </cfloop>			  
                            </select>	
                        </div>
                        <div class="col col-3">
                            <select name="execute_finish_clock" id="execute_finish_clock">
                                <option value="0" selected><cf_get_lang_main no='79.Saat'></option>
                                <cfloop from="7" to="30" index="i">
                                    <cfset saat=i mod 24>
                                    <cfoutput><option value="#saat#" <cfif saat eq 17>selected</cfif>>#saat#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                        <div class="col col-3">
                            <select name="execute_finish_minute" id="execute_finish_minute">
                                <cfloop from="0" to="55" index="a" step="5">
                                    <cfoutput><option value="#Numberformat(a,00)#" <cfif a eq 0>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                   
                </div>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang_main no='217.Açıklama'></label>
                    <div class="col col-8">
                        <textarea name="detail" id="detail"></textarea>
                    </div>
                </div> 
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang_main no='272.Sonuç'> *</label>
                    <div class="col col-8">
                        <cf_wrk_combo
                        name="visit_stage"
                        query_name="GET_VISIT_STAGES"
                        option_name="visit_stage"
                        option_value="visit_stage_id"
                        width="195">
                    </div>
                </div> 
            
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang no='85.Harcama'></label>
                    <div class="col col-8">
                        <div class="col col-6">
                            <cfsavecontent variable="message"><cf_get_lang no='407.harcamaya sayısal deger Giriniz !'></cfsavecontent>
                            <cfinput type="text" name="visit_expense" validate="float" message="#message#" onKeyup="'return(FormatCurrency(this,event));'" value="0"  class="moneybox">
                        </div>
                        <div class="col col-6 pr-0">
                            <select name="money" id="money">
                                <cfoutput query="get_money">
                                    <option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                </cfoutput>
                            </select>	
                        </div>		
                        <div class="col col-12 padding-top-5">
                            <select name="expense_item" id="expense_item">
                                <option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option>
                                <cfoutput query="get_expense">
                                    <option value="#expense_item_id#">#expense_item_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang no='384.Ziyaret Edecekler'></label>
                    <div class="col col-8">
                        <div class="input-group">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.position_code#,</cfoutput>">
                            <input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(session.ep.position_code,1,0)#</cfoutput>" readonly>
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="temizlerim('');pencere_ac_pos('');"></span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	x = document.add_visit.visit_type.selectedIndex;
	if (document.add_visit.visit_type[x].value == "")
	{ 
		alert ("<cf_get_lang no='408.Lütfen Ziyaret Nedeni Giriniz'> !");
		return false;
	}
	x = document.add_visit.visit_stage.selectedIndex;
	if (document.add_visit.visit_stage[x].value == "")
	{ 
		alert ("<cf_get_lang no='409.Sonuç Girmelisiniz'> !");
		return false;
	}
	x = document.add_visit.sales_zones.selectedIndex;
	if (document.add_visit.sales_zones[x].value == "")
	{ 
		alert ("<cf_get_lang no='234.Şube Seçiniz'> !");
		return false;
	}
	
	if(!date_check_hiddens(document.add_visit.kontrol_date_value,document.add_visit.execute_startdate, "<cf_get_lang dictionary_id='52368.Gerçekleşme Tarihi Bugunden 7 Gun Oncesi Olabilir'>!"))
	{
		return false;
	}
	
	tarih1_1 = add_visit.execute_startdate.value.substr(6,4) + add_visit.execute_startdate.value.substr(3,2) + add_visit.execute_startdate.value.substr(0,2);
	tarih2_2 = add_visit.today_value_.value.substr(6,4) + add_visit.today_value_.value.substr(3,2) + add_visit.today_value_.value.substr(0,2);
	if((add_visit.execute_startdate.value != "") && (tarih1_1 > tarih2_2))
	{
		alert('<cf_get_lang no='410.Lütfen Gerçekleşme Tarihini Bugünden Önce Giriniz'> !');
		return false;
	}
	if ((add_visit.execute_startdate.value != ""))
	{
		tarih1_ = add_visit.execute_startdate.value.substr(6,4) + add_visit.execute_startdate.value.substr(3,2) + add_visit.execute_startdate.value.substr(0,2);
		tarih2_ = add_visit.execute_startdate.value.substr(6,4) + add_visit.execute_startdate.value.substr(3,2) + add_visit.execute_startdate.value.substr(0,2);
		if (add_visit.execute_start_clock.value.length < 2) saat1_ = '0' + add_visit.execute_start_clock.value; else saat1_ = add_visit.execute_start_clock.value;
		if (add_visit.execute_start_minute.value.length < 2) dakika1_ = '0' + add_visit.execute_start_minute.value; else dakika1_ = add_visit.execute_start_minute.value;
		if (add_visit.execute_finish_clock.value.length < 2) saat2_ = '0' + add_visit.execute_finish_clock.value; else saat2_ = add_visit.execute_finish_clock.value;
		if (add_visit.execute_finish_minute.value.length < 2) dakika2_ = '0' + add_visit.execute_finish_minute.value; else dakika2_ = add_visit.execute_finish_minute.value;
		tarih1_ = tarih1_ + saat1_ + dakika1_;
		tarih2_ = tarih2_ + saat2_ + dakika2_;	
		if (tarih1_ >= tarih2_) 
		{
			alert("<cf_get_lang no='411.Gerçekleşme Tarihi Başlama Saati Bitiş Saatinden Önce Olmalıdır'> !");
			return false;
		}
	}	
	add_visit.visit_expense.value = filterNum(add_visit.visit_expense.value);
}
function temizlerim(no)
{
	var my_element=eval("add_visit.employee_id"+no);
	var my_element2=eval("add_visit.employee_name"+no);
	my_element.value='';
	my_element2.value='';
}
function pencere_ac_pos(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_id=add_visit.employee_id&field_name=add_visit.employee_name&select_list=1&is_upd=0','list');
}
</script>
