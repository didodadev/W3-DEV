<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="assetcare.form_add_punishment">

<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_punishment_type.cfm">

<cfquery name="GET_MAX_PUNISHMENT" datasource="#DSN#">
	SELECT MAX(PUNISHMENT_ID) MAX_PUNISHMENT_ID FROM ASSET_P_PUNISHMENT 
</cfquery>
<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
    <cfquery name="get_vehicles" datasource="#DSN#">
        SELECT 
            *
        FROM 
            ASSET_P
        WHERE	
            ASSET_P.ASSETP_ID = #attributes.assetp_id#
    </cfquery>
    <cfif len(get_vehicles.position_code)>
        <cfquery name="get_employee_id" datasource="#dsn#">
            SELECT POSITION_CODE,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_vehicles.position_code#
        </cfquery>
    </cfif>
    <cfif len(get_vehicles.department_id)>
        <cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
            SELECT
                DEPARTMENT.DEPARTMENT_HEAD,
                BRANCH.BRANCH_NAME
            FROM
                BRANCH,
                DEPARTMENT
            WHERE
                DEPARTMENT.DEPARTMENT_ID = #get_vehicles.department_id# AND
                BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
        </cfquery>
    </cfif>
</cfif>
<cfif len(get_max_punishment.max_punishment_id)>
	<cfset max_punishment_id = get_max_punishment.max_punishment_id>
	<cfset max_punishment_id = max_punishment_id + 1>
<cfelse>
	<cfset max_punishment_id = 1>
</cfif>
<!--- <cfquery name="GET_PAYMENT_DAY" datasource="#DSN#">
	SELECT PAYMENT_DAY FROM SETUP_PAYMENT_DAY
</cfquery> --->
<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
    <cfset list_href_ = '#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#attributes.assetp_id#'>
<cfelse>
    <cfset list_href_ = '#request.self#?fuseaction=assetcare.form_search_punishment'>
</cfif>
<cf_box title="#getLang(dictionary_id : 48021)#" list_href="#list_href_#">
    <cfform name="add_punishment" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_punishment">
        <input type="hidden" name="accident_date" id="accident_date" value="">
        <input type="hidden" name="x_control" id="x_control" value="<cfoutput>#x_control#</cfoutput>"><!--- query icin kullaniliyor kaldirmayin --->
        <cf_box_elements>
            <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-fuel_num">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='75.No'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="fuel_num" id="fuel_num" value="<cfoutput>#max_punishment_id#</cfoutput>" readonly>
                    </div>
                </div>
                <div class="form-group" id="item-accident_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='446.Kaza İlişkisi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="accident_id" id="accident_id"> <input type="text" name="accident_name" id="accident_name" value="" readonly >  
                            <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_accident&field_accident_id=add_punishment.accident_id&field_accident_name=add_punishment.accident_name&field_assetp_id=add_punishment.assetp_id&field_assetp_name=add_punishment.assetp_name&field_employee_id=add_punishment.employee_id&field_employee_name=add_punishment.employee_name&field_dep_id=add_punishment.department_id&field_dep_name=add_punishment.department&field_date=add_punishment.accident_date');"> 
                            </span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="item-assetp_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="assetp_id" id="assetp_id" value="<cfif isdefined("get_vehicles.assetp_id") and len(get_vehicles.assetp_id)><cfoutput>#get_vehicles.assetp_id#</cfoutput></cfif>"> 
                            <input type="text" name="assetp_name" id="assetp_name"  value="<cfif isdefined("get_vehicles.assetp") and len(get_vehicles.assetp)><cfoutput>#get_vehicles.assetp#</cfoutput></cfif>" readonly> 
                            <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_punishment.assetp_id&field_name=add_punishment.assetp_name&field_emp_id=add_punishment.employee_id&field_emp_name=add_punishment.employee_name&field_dep_name=add_punishment.department&field_dep_id=add_punishment.department_id&list_select=2&is_active=1');">
                            </span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="item-assetp_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="employee_id"  id="employee_id" value="<cfif isdefined("get_employee_id.employee_id") and len(get_employee_id.employee_id)><cfoutput>#get_employee_id.employee_id#</cfoutput></cfif>"> 
                            <input type="text" name="employee_name" id="employee_name"  value="<cfif isdefined("get_employee_id.employee_id") and len(get_employee_id.employee_id)><cfoutput>#get_emp_info(get_employee_id.employee_id,0,0)#</cfoutput><cfelseif isdefined("get_vehicles.company_partner_id") and len(get_vehicles.company_partner_id)><cfoutput>#get_par_info(get_vehicles.company_partner_id,0,0,0)#</cfoutput></cfif>" readonly> 
                            <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id2=add_punishment.employee_id&field_name=add_punishment.employee_name</cfoutput>&select_list=1&branch_related');"><!--- field_emp_id2 ---> 
                            </span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="item-assetp_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("get_vehicles.department_id") and len(get_vehicles.department_id)><cfoutput>#get_vehicles.department_id#</cfoutput></cfif>">
                            <input type="text" name="department" id="department" value="<cfif isdefined("get_vehicles.department_id") and len(get_vehicles.department_id)><cfoutput>#get_branchs_deps.branch_name# - #get_branchs_deps.department_head#</cfoutput></cfif>" readonly> 
                            <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_punishment.department_id&field_name=add_punishment.department');"> 
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12" type="column" index="2" sort="true">

                <div class="form-group" id="item-receipt_num">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='415.Makbuz No'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="receipt_num" id="receipt_num" required="yes" value="" maxlength="100" >
                    </div>
                </div>

                <div class="form-group" id="item-punishment_type_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='414.Ceza Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="punishment_type_id" id="punishment_type_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_punishment_type"> 
                                <option value="#punishment_type_id#">#punishment_type_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>

                <div class="form-group" id="item-punishment_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='416.Ceza Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="punishment_date" id="punishment_date" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="punishment_date"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="item-assetp_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='185.Son Ödeme Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="last_payment_date" id="last_payment_date" maxlength="10"> 
                            <span class="input-group-addon"><cf_wrk_date_image date_field="last_payment_date"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="item-assetp_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='417.Ceza Tutarı'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="punishment_amount" id="punishment_amount" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" >              
                            <span class="input-group-addon width">
                                <select name="punishment_amount_currency" id="punishment_amount_currency">
                                <cfoutput query="get_money"> 
                                    <option value="#money#"<cfif money eq session.ep.money> selected</cfif>>#money#</option>
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
                            <input type="text" name="paid_date" id="paid_date" maxlength="10"> 
                            <span class="input-group-addon"><cf_wrk_date_image date_field="paid_date"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="item-paid_amount">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='418.Ödenen Tutar'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="paid_amount" id="paid_amount" class="moneybox" onKeyup="return(FormatCurrency(this,event));"> 
                            <span class="input-group-addon width"><select name="paid_amount_currency" id="paid_amount_currency" >
                            <cfoutput query="get_money"> 
                                <option value="#money#"<cfif money eq session.ep.money> selected</cfif>>#money#</option>
                            </cfoutput>
                            </select></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="item-payer">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='424.Ödeme Yapan'></label>
                    <div class="col col-4 col-xs-12">
                        <input type="radio" name="payer" id="payer" value="1" checked><cf_get_lang_main no='162.Firma'>
                    </div>
                    <div class="col col-4 col-xs-12">
                        <input type="radio" name="payer" id="payer" value="2"><cf_get_lang_main no='2034.Kişi'>
                    </div>
                </div>

                <div class="form-group" id="item-punished_license">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='425.Ceza Kayıtlı Belge'></label>
                    <div class="col col-4 col-xs-12">
                        <input type="radio" name="punished_license" id="punished_license" value="1" checked><cf_get_lang no='432.Ruhsat'>
                    </div>
                    <div class="col col-4 col-xs-12">
                        <input type="radio" name="punished_license" id="punished_license" value="2"><cf_get_lang no='428.Ehliyet'>
                    </div>
                </div>
                <div class="form-group" id="item-detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no="217.Açıklama"></label>
                    <div class="col col-8 col-xs-12">
                        <textarea name="detail" id="detail"></textarea>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' is_reset='1' is_cancel='0' add_function='kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function unformat_fields()
	{
		document.add_punishment.punishment_amount.value = filterNum(document.add_punishment.punishment_amount.value);
		document.add_punishment.paid_amount.value = filterNum(document.add_punishment.paid_amount.value);
	}
	
	function kontrol()
	{
		if(document.add_punishment.assetp_name.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'>!");
			return false;
		}
		
		if(document.add_punishment.employee_name.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu'>!");
			return false;
		}
		
		if(document.add_punishment.department.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1735.Şube Adı'>!");
			return false;
		}
				
		if(document.add_punishment.receipt_num.value  == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='415.Makbuz No'>!");
			return false;
		}
		
		x = document.add_punishment.punishment_type_id.selectedIndex;
		if (document.add_punishment.punishment_type_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='414.Ceza Tipi'>!");
			return false;
		}
	
		if(document.add_punishment.punishment_date.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='416.Ceza Tarihi'>!");
			return false;
		}
	
		if(document.add_punishment.punishment_amount.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='417.Ceza Tutarı'>!");
			return false;
		}		
		
		if(!CheckEurodate(document.add_punishment.punishment_date.value,"<cf_get_lang no='416.Ceza Tarihi'>"))
		{
			return false;
		}
		
		if(!CheckEurodate(document.add_punishment.paid_date.value,"<cf_get_lang no='423.Ödenen Tarih'>"))
		{
			return false;
		}
		// Hidden alanlar için date_check_hiddens kullanıyoruz.
		if(!date_check_hiddens(document.add_punishment.accident_date,document.add_punishment.punishment_date,"<cf_get_lang no='629.Ceza Tarihini Kontrol Ediniz'>!"))
		{ 
			return false; 
		}
		
		if(document.add_punishment.last_payment_date.value != "")
		{
			if(!CheckEurodate(document.add_punishment.last_payment_date.value,"<cf_get_lang no='185.Son Ödeme Tarihi'>"))
			{
				return false;
			}
			
			//  Hidden alanlar için date_check_hiddens kullanıyoruz.
			if(!date_check(document.add_punishment.punishment_date,document.add_punishment.last_payment_date,"<cf_get_lang_main no='394.Tarih Aralığını Kontrol Ediniz'>!"))
			{
				return false;
			}
		}
	
		if((document.add_punishment.punishment_date.value.length) && (document.add_punishment.paid_date.value.length))
		{
			if(!date_check(document.add_punishment.punishment_date,document.add_punishment.paid_date,"<cf_get_lang no='630.Ödeme Tarihi Ceza Tarihinden Küçük Olamaz'>!"))
			{
				return false;
			}
		}
		unformat_fields();
		return true;
	}	
</script>
