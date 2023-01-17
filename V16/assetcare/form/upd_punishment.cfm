<cf_xml_page_edit fuseact="assetcare.form_add_punishment">
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_punishment_upd.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_punishment_type.cfm">
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME
	FROM 
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.DEPARTMENT_ID = #get_punishment_upd.department_id# AND
		D.BRANCH_ID = B.BRANCH_ID
</cfquery>
<div class="row">
<div class="col col-9 col-xs-12">
	<cf_box title="#getLang(dictionary_id : 48336)#" list_href="#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#attributes.assetp_id#">
        <form name="upd_punishment" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emptypopup_upd_punishment">  
                <input type="hidden" name="punishment_id" id="punishment_id" value="<cfoutput>#attributes.punishment_id#</cfoutput>">
                <input type="hidden" name="x_control" id="x_control" value="<cfoutput>#x_control#</cfoutput>">
                    <cf_box_elements>
                            <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                                <div class="form-group" id="item-fuel_num">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='75.No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="punishment_num" id="punishment_num" value="<cfoutput>#get_punishment_upd.punishment_id#</cfoutput>" readonly >
                                    </div>
                                </div>

                                <div class="form-group" id="item-accident_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='446.Kaza İlişkisi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="accident_id" id="accident_id" value="<cfoutput>#get_punishment_upd.accident_id#</cfoutput>"> 
                                            <cfif len(get_punishment_upd.accident_id)>
                                                <cfquery name="GET_ACCIDENT" datasource="#DSN#">
                                                    SELECT 
                                                        ASSET_P_ACCIDENT.ACCIDENT_DATE, 
                                                        ASSET_P.ASSETP 
                                                    FROM 
                                                        ASSET_P_ACCIDENT,ASSET_P 
                                                    WHERE 
                                                        ACCIDENT_ID = #get_punishment_upd.accident_id# AND 
                                                        ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID 
                                                </cfquery>
                                                <cfset x = get_accident.assetp &  " - " & dateformat(get_accident.accident_date,dateformat_style) & " tarihli kaza">
                                            <cfelse>
                                                <cfset x = "">
                                            </cfif>
                                            <input type="text" name="accident_name" id="accident_name" value="<cfoutput>#x#</cfoutput>" readonly>  
                                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_accident&field_accident_id=upd_punishment.accident_id&field_accident_name=upd_punishment.accident_name&field_assetp_id=upd_punishment.assetp_id&field_assetp_name=upd_punishment.assetp_name&field_employee_id=upd_punishment.employee_id&field_employee_name=upd_punishment.employee_name&field_dep_id=upd_punishment.department_id&field_dep_name=upd_punishment.department','list','popup_list_accident');">
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" id="item-assetp_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_punishment_upd.assetp_id#</cfoutput>"> 
                                            <input type="text" name="assetp_name" id="assetp_name" value="<cfoutput>#get_punishment_upd.assetp#</cfoutput>" readonly> 
                                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_punishment.assetp_id&field_name=upd_punishment.assetp_name&is_active=1&field_dep_id=upd_punishment.department_id&field_dep_name=upd_punishment.department&field_emp_id=upd_punishment.employee_id&field_emp_name=upd_punishment.employee_name','list','popup_list_ship_vehicles');">
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" id="item-employee_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_punishment_upd.employee_id#</cfoutput>"> 
                                            <input type="text" name="employee_name" id="employee_name" readonly  value="<cfoutput>#get_emp_info(get_punishment_upd.employee_id,0,0)#</cfoutput>">
                                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_punishment.employee_id&field_name=upd_punishment.employee_name&select_list=1&branch_related','list','popup_list_positions');"> 
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" id="item-department">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfif len(get_punishment_upd.department_id)>
                                                <cfset x = get_department.branch_name & "-" & get_department.department_head>
                                            <cfelse>
                                                <cfset x = "">
                                            </cfif>
                                            <td>
                                                <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_punishment_upd.department_id#</cfoutput>"> 
                                                <input type="text" name="department" id="department" value="<cfoutput>#x#</cfoutput>" readonly> 
                                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_punishment.department_id&field_name=upd_punishment.department','list','popup_list_departments');"> 
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-xs-12" type="column" index="2" sort="true">

                                <div class="form-group" id="item-receipt_num">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='415.Makbuz No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="receipt_num" id="receipt_num" value="<cfoutput>#get_punishment_upd.receipt_num#</cfoutput>">
                                    </div>
                                </div>

                                <div class="form-group" id="item-punishment_type_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='414.Ceza Tipi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="punishment_type_id" id="punishment_type_id">
                                        <option value=""></option>
                                        <cfoutput query="get_punishment_type"> 
                                            <option value="#punishment_type_id#" <cfif get_punishment_upd.punishment_type_id eq get_punishment_type.punishment_type_id> selected</cfif>>#punishment_type_name#</option>
                                        </cfoutput>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group" id="item-punishment_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='416.Ceza Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" name="punishment_date" id="punishment_date" value="<cfoutput>#dateformat(get_punishment_upd.punishment_date,dateformat_style)#</cfoutput>" maxlength="10" >
                                            <span class="input-group-addon"> <cf_wrk_date_image date_field="punishment_date"></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" id="item-last_payment_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='185.Son Ödeme Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" name="last_payment_date" id="last_payment_date" value="<cfoutput>#dateformat(get_punishment_upd.last_payment_date,dateformat_style)#</cfoutput>"> 
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="last_payment_date"></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" id="item-punishment_amount">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='417.Ceza Tutarı'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" name="punishment_amount" id="punishment_amount" value="<cfoutput>#tlformat(get_punishment_upd.punishment_amount)#</cfoutput>"  onKeyup="return(FormatCurrency(this,event));" class="moneybox">              
                                            <span class="input-group-addon width">
                                            <select name="punishment_amount_currency" id="punishment_amount_currency">
                                                <cfoutput query="get_money"> 
                                                    <option value="#money#" <cfif money eq get_punishment_upd.punishment_amount_currency> selected</cfif>>#money#</option>
                                                </cfoutput>
                                                </select>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-xs-12" type="column" index="3" sort="true">

                                <div class="form-group" id="item-paid_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='447.Ödeme Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                        <input type="text" name="paid_date" id="paid_date" value="<cfoutput>#dateformat(get_punishment_upd.paid_date,dateformat_style)#</cfoutput>" maxlength="10" >
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="paid_date"></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" id="item-paid_amount">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='418.Ödenen Tutar'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" name="paid_amount" id="paid_amount" value="<cfoutput>#tlformat(get_punishment_upd.paid_amount)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));"  class="moneybox">
                                            <span class="input-group-addon width"><select name="paid_amount_currency" id="paid_amount_currency">
                                                <cfoutput query="get_money"> 
                                                    <option value="#money#" <cfif money eq get_punishment_upd.paid_amount_currency> selected</cfif>>#money#</option>
                                                </cfoutput>
                                            </select></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" id="item-payer">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='424.Ödeme Yapan'></label>
                                    <div class="col col-4 col-xs-12">
                                        <input type="radio" name="payer" id="payer" value="1" <cfif get_punishment_upd.payer_id eq 1>checked</cfif>>
                                        <cf_get_lang_main no='162.Firma'>
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                        <input type="radio" name="payer" id="payer" value="2" <cfif get_punishment_upd.payer_id eq 2>checked</cfif>>
                                        <cf_get_lang_main no='2034.Kişi'>
                                    </div>
                                </div>

                                <div class="form-group" id="item-punished_license">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='425.Ceza Kayıtlı Belge'></label>
                                    <div class="col col-4 col-xs-12">
                                        <input type="radio" name="punished_license" id="punished_license" value="1" <cfif get_punishment_upd.punished_license eq 1>checked</cfif>><cf_get_lang no='432.Ruhsat'> 
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                        <input type="radio" name="punished_license" id="punished_license" value="2" <cfif get_punishment_upd.punished_license eq 2>checked</cfif>><cf_get_lang no='428.Ehliyet'>
                                    </div>
                                </div>

                                <div class="form-group" id="item-detail">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no="217.Açıklama"></label>
                                    <div class="col col-8 col-xs-12">
                                        <textarea name="detail" id="detail"><cfoutput>#get_punishment_upd.detail#</cfoutput></textarea>
                                    </div>
                                </div>

                            </div>
                        </cf_box_elements>
                <cf_basket_form_button>
                       <div class="float-left"> <cf_record_info query_name="GET_PUNISHMENT_UPD"></div>
                        <cf_workcube_buttons is_upd='1' is_delete='1' is_cancel='0' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_punishment&punishment_id=#attributes.punishment_id#&plaka=#get_punishment_upd.assetp#'>
                </cf_basket_form_button>
        </form>
    </cf_box>
</div>
<div class="col col-3 col-xs-12">
    <cf_get_workcube_asset asset_cat_id="-23" module_id='40' action_section='PUNISHMENT_ID' action_id='#attributes.punishment_id#'>
</div>
</div>
<script type="text/javascript">
function unformat_fields()
{
	document.upd_punishment.punishment_amount.value = filterNum(document.upd_punishment.punishment_amount.value);
	document.upd_punishment.paid_amount.value = filterNum(document.upd_punishment.paid_amount.value);
}
function kontrol()
{	
	if(document.upd_punishment.receipt_num.value == "")
	{
		alert("Makbuz No. Girmelisiniz!");
		return false;
	}
	if($('#detail').val().length > 1000)
	{
		alert('Açıklama Alanı 1000 Karakterden Fazla Olamaz !');
		return false;
	}
	x = document.upd_punishment.punishment_type_id.selectedIndex;
	if (document.upd_punishment.punishment_type_id[x].value == "")
	{ 
		alert ("Lütfen Ceza Tipi Seçiniz!");
		return false;
	}
	if(document.upd_punishment.punishment_date.value == "")
	{
		alert("Ceza Tarihi Girmelisiniz!");
		return false;
	}
	
	if(document.upd_punishment.punishment_amount.value == "")
	{
		alert("Ceza Tutarı Girmelisiniz!");
		return false;
	}		
	
	if(!CheckEurodate(document.upd_punishment.punishment_date.value,'Ceza Tarihi'))
	{
		return false;
	}
	
	if(!CheckEurodate(document.upd_punishment.paid_date.value,'Ödenen Tarih'))
	{
		return false;
	}
	
	if(!CheckEurodate(document.upd_punishment.last_payment_date.value,'Son Ödeme Tarihi'))
	{
		return false;
	}

	if(document.upd_punishment.last_payment_date.value != "")
	{
		if(!date_check_hiddens(document.upd_punishment.punishment_date,document.upd_punishment.last_payment_date,"Tarih Aralığını Kontrol Ediniz!"))
		{
			return false;
		}
	}
	if((document.upd_punishment.punishment_date.value.length) && (document.upd_punishment.paid_date.value.length))
	{
		if(!date_check_hiddens(document.upd_punishment.punishment_date,document.upd_punishment.paid_date,"Ödeme Tarihi Ceza Tarihinden Küçük Olamaz!"))
		{
			return false;
		}
	}
	unformat_fields();
	return true;
}
</script>
