<cfquery name="GET_PC_NUMBER" datasource="#DSN#">
	SELECT UNIT_ID, UNIT_NAME FROM SETUP_PC_NUMBER ORDER BY UNIT_ID
</cfquery>
<cfquery name="GET_NET_CONNECTION" datasource="#DSN#">
	SELECT CONNECTION_ID, CONNECTION_NAME FROM SETUP_NET_CONNECTION ORDER BY CONNECTION_ID
</cfquery>
<cfquery name="GET_STOCKS" datasource="#DSN#">
	SELECT STOCK_ID, STOCK_NAME FROM SETUP_STOCK_AMOUNT ORDER BY STOCK_ID
</cfquery>
<cfquery name="GET_DUTY_PERIOD" datasource="#DSN#">
	SELECT PERIOD_ID, PERIOD_NAME FROM SETUP_DUTY_PERIOD ORDER BY PERIOD_ID
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY_ID, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_IT_CONCERN" datasource="#DSN#">
	SELECT CONCERN_ID, CONCERN_NAME FROM SETUP_IT_CONCERNED ORDER BY CONCERN_ID
</cfquery>
<cfquery name="GET_INFO" datasource="#DSN#">
	SELECT STOCK_AMOUNT, DUTY_PERIOD, ENDORSE_PERIOD, ENDORSE_PAYMENT, ENDORSE_CURRENCY FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY_PARTNER.IS_SMS
	FROM 
		COMPANY_PARTNER,
		COMPANY
	WHERE 
		COMPANY.COMPANY_ID = #attributes.cpid# AND
		COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
</cfquery>
<cfquery name="GET_PARTNER_SOCIETY" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER_SOCIETY.SOCIETY_ID,
		SETUP_SOCIAL_SOCIETY.SOCIETY
	FROM  
		COMPANY_PARTNER_SOCIETY, 
		SETUP_SOCIAL_SOCIETY
	WHERE 
		COMPANY_PARTNER_SOCIETY.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_PARTNER_SOCIETY.PARTNER_ID = #get_partner.partner_id# AND 
		COMPANY_PARTNER_SOCIETY.SOCIETY_ID = SETUP_SOCIAL_SOCIETY.SOCIETY_ID
</cfquery>
<cfquery name="GET_CUSTOMER_POSITION" datasource="#DSN#">
	SELECT 
		COMPANY_POSITION.POSITION_ID,
		SETUP_CUSTOMER_POSITION.POSITION_NAME 
	FROM 
		SETUP_CUSTOMER_POSITION, 
		COMPANY_POSITION
	WHERE 
		COMPANY_POSITION.POSITION_ID = SETUP_CUSTOMER_POSITION.POSITION_ID AND 
		COMPANY_POSITION.COMPANY_ID = #attributes.cpid#
	ORDER BY 
		SETUP_CUSTOMER_POSITION.POSITION_ID
</cfquery>
<cfquery name="GET_INSURANCE_COMP" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER_INSURANCE_COMP.INSURANCE_COMP_ID,
		SETUP_INSURANCE_COMPANY.COMPANY_NAME
	FROM 
		COMPANY_PARTNER_INSURANCE_COMP, 
		SETUP_INSURANCE_COMPANY
	WHERE 
		COMPANY_PARTNER_INSURANCE_COMP.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_PARTNER_INSURANCE_COMP.PARTNER_ID = #get_partner.partner_id# AND 
		COMPANY_PARTNER_INSURANCE_COMP.INSURANCE_COMP_ID = SETUP_INSURANCE_COMPANY.COMPANY_ID
</cfquery>
<cfquery name="GET_PARTNER_JOB_OTHER" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER_JOB_OTHER.JOB_ID,
		SETUP_SECTOR_CATS.SECTOR_CAT
	FROM 
		COMPANY_PARTNER_JOB_OTHER,
		SETUP_SECTOR_CATS
	WHERE 
		COMPANY_ID = #attributes.cpid# AND 
		PARTNER_ID = #get_partner.partner_id# AND 
		COMPANY_PARTNER_JOB_OTHER.JOB_ID = SETUP_SECTOR_CATS.SECTOR_CAT_ID
</cfquery>
<cfquery name="GET_RIVALS" datasource="#DSN#">
	SELECT
		COMPANY_PARTNER_RIVAL.RIVAL_ID,
		SETUP_RIVALS.RIVAL_NAME 
	FROM 
		COMPANY_PARTNER_RIVAL, 
		SETUP_RIVALS 
	WHERE 
		SETUP_RIVALS.R_ID = COMPANY_PARTNER_RIVAL.RIVAL_ID AND 
		COMPANY_PARTNER_RIVAL.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_PARTNER_RIVAL.PARTNER_ID = #get_partner.partner_id#
</cfquery>
<cfquery name="GET_STUFF" datasource="#DSN#">
	SELECT 
		COMPANY_OFFICE_SOFTWARES.SOFTWARE_ID,
		SETUP_OFFICE_STUFF.STUFF_NAME 
	FROM 
		SETUP_OFFICE_STUFF,
		COMPANY_OFFICE_SOFTWARES,
		COMPANY_SERVICE_INFO
	WHERE 
		SETUP_OFFICE_STUFF.STUFF_ID = COMPANY_OFFICE_SOFTWARES.SOFTWARE_ID AND 
		COMPANY_OFFICE_SOFTWARES.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_OFFICE_SOFTWARES.SERVICE_ID = COMPANY_SERVICE_INFO.SERVICE_ID AND
		COMPANY_SERVICE_INFO.COMPANY_ID = COMPANY_OFFICE_SOFTWARES.COMPANY_ID
	ORDER BY 
		SETUP_OFFICE_STUFF.STUFF_NAME
</cfquery>
<cfquery name="GET_COMPANY_SERVICE_INFO_DETAIL" datasource="#DSN#">
	SELECT
		PC_NUMBER,
		NET_CONNECTION,
		IT_CONCERNED,
		SERVICE_ID,
		RECORD_DATE,
		RECORD_EMP,
		UPDATE_DATE,
		UPDATE_EMP
	FROM 
		COMPANY_SERVICE_INFO
	WHERE
		COMPANY_ID = #attributes.cpid#
</cfquery>
<cfsavecontent variable="title"><cf_get_lang no='128.Çalışma Bilgileri'></cfsavecontent>
  
<cf_box title="#title#">
<cfform method="post" name="upd_company_special" action="#request.self#?fuseaction=crm.emptypopup_add_work_info">
<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_partner.partner_id#</cfoutput>">
<input type="hidden" name="service_id" id="service_id" value="<cfoutput>#get_company_service_info_detail.service_id#</cfoutput>">
<cf_box_elements>

<div class="col col-4 colmd-4 col-sm-6 col-xs-12">  
   <div class="form-group">
        <label class="col col-4"><cf_get_lang no='127.Sosyal Güvenlik Kurumu'></label>        
        <div class="col col-8">
            <select name="society" id="society" style="width:150px;height:75px" multiple>
                <cfoutput query="get_partner_society">
                    <option value="#society_id#">#society#</option>
                </cfoutput>
            </select>
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_society_detail&field_name=upd_company_special.society','small');"><img src="/images/plus_list.gif" alt="" border="0" align="top"></a>
            <a href="javascript://" onClick="remove_field('society');"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang_main no='51.Sil'>" title="<cf_get_lang_main no='51.Sil'>" style="cursor=hand" align="top"></a>              
        </div>
    </div>
    <div class="form-group">
        <label class="col col-4"><cf_get_lang no='120.Müşterinin Genel Konumu'></label>
        <div class="col col-8">
            <select name="customer_position" id="customer_position" style="width:150px;height=75px;" multiple>
                <cfoutput query="get_customer_position">
                    <option value="#position_id#">#position_name#</option>
                </cfoutput>
            </select>        
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_position_detail&field_name=upd_company_special.customer_position','small');"><img src="/images/plus_list.gif" alt="" border="0" align="top"></a>
            <a href="javascript://" onClick="remove_field('customer_position');"><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0" title="<cf_get_lang_main no='51.Sil'>" style="cursor=hand" align="top"></a>
        </div>
    </div>
    <div class="form-group">
        <label class="col col-4"><cf_get_lang no='126.Özel Sigorta Şirketleri'></label>        
        <div class="col col-8">
            <select name="insurance_company" id="insurance_company" style="width:150px;height:75px" multiple>
            <cfoutput query="get_insurance_comp">
                <option value="#insurance_comp_id#">#company_name#</option>
            </cfoutput>
            </select>
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_insurance_company_detail&field_name=upd_company_special.insurance_company','small');"><img src="/images/plus_list.gif" alt="" border="0" align="top"></a><br/>
            <a href="javascript://" onClick="remove_field('insurance_company');"><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0" title="<cf_get_lang_main no='51.Sil'>" style="cursor=hand" align="top"></a>
        </div>
    </div>
    <div class="form-group">
        <label class="col col-4"><cf_get_lang no='147.Uğraştığı Diğer İşler'></label>      

        <div class="col col-8">
            <select name="other_works" id="other_works" style="width:150px;height:75px" multiple>
            <cfoutput query="get_partner_job_other">
                <option value="#job_id#">#sector_cat#</option>
            </cfoutput>
            </select>
        
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_other_works_detail&field_name=upd_company_special.other_works','small');"><img src="/images/plus_list.gif" alt="" border="0" align="top"></a><br/>
            <a href="javascript://" onClick="remove_field('other_works');"><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0" title="<cf_get_lang_main no='51.Sil'>" style="cursor=hand" align="top"></a>
        
        </div>

    </div>
 
   <div class="form-group">
        <label class="col col-4"><cf_get_lang no='125.Çalıştığı Rakip Depolar'></label>      
        <div class="col col-8">
            <select name="competitor_depot" id="competitor_depot" style="width:150px;height:75px" multiple>
                <cfoutput query="get_rivals">
                    <option value="#rival_id#">#rival_name#</option>
                </cfoutput>
            </select>               
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_rival_detail&field_name=upd_company_special.competitor_depot','small');"><img src="/images/plus_list.gif" alt="" border="0" align="top"></a><br/>
            <a href="javascript://" onClick="remove_field('competitor_depot');"><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0" title="<cf_get_lang_main no='51.Sil'>" style="cursor=hand" align="top"></a>
        </div>
    </div>
    <div class="form-group">
        <label class="col col-4"><cf_get_lang no='148.Büro Yazılımları'></label>
        <div class="col col-8">
            <select name="softwares" id="softwares" style="width:150px;height:75px" multiple>
                <cfoutput query="get_stuff">
                    <option value="#software_id#">#stuff_name#</option>
                </cfoutput>
            </select>               
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_office_stuff_detail&field_name=upd_company_special.softwares','small');"><img src="/images/plus_list.gif" border="0" align="top"></a><br/>
            <a href="javascript://" onClick="remove_field('softwares');"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no='51.Sil'>" style="cursor=hand" align="top"></a>
        </div>
        
    </div>
</div>
<div class="col col-4">
   <div class="form-group">
        <label class="col col-4 col-xs-12"><cf_get_lang no='124.SMS İstiyor mu'> ?</label>
        <div class="col col-8"><input type="checkbox" name="is_sms" id="is_sms" <cfif get_partner.is_sms eq 1>checked</cfif>></div>
    </div>
    <div class="form-group">
        <label class="col col-4 col-xs-12"><cf_get_lang no='149.Stok ve Raf Durumu'></label>
        <div class="col col-8">
            <select name="stock_amount" id="stock_amount" style="width:150;">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                <cfoutput query="get_stocks">
                    <option value="#stock_id#" <cfif stock_id eq get_info.stock_amount> selected</cfif>>#stock_name#</option>
                </cfoutput>
            </select>
        </div>
    </div>
   <div class="form-group">
        <label class="col col-4 col-xs-12"><cf_get_lang no='123.Müşteri Nöbet Durumu'></label>
        <div class="col col-8">
            <select name="duty_period" id="duty_period" style="width:150px;">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                <cfoutput query="get_duty_period">
                    <option value="#period_id#" <cfif get_info.duty_period eq period_id> selected</cfif>>#period_name#</option>
                </cfoutput>
            </select>
        </div>
    </div>
    <div class="form-group">
        <label class="col col-4 col-xs-12"><cf_get_lang no='150.Bilgisayar Sayısı'></label>
        <div class="col col-8">
            <select name="pc_number" id="pc_number" style="width:150px;">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                <cfoutput query="get_pc_number">
                    <option value="#unit_id#" <cfif get_company_service_info_detail.pc_number eq unit_id> selected</cfif>>#unit_name#</option>
                </cfoutput>
            </select>
        </div>
    </div>
   <div class="form-group">
        <label class="col col-4 col-xs-12"><cf_get_lang no='122.İnternet Bağlantısı'></label>
        <div class="col col-8">
            <select name="net_connection" id="net_connection" style="width:150px;">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                <cfoutput query="get_net_connection">
                    <option value="#connection_id#" <cfif get_company_service_info_detail.net_connection eq connection_id> selected</cfif>>#connection_name#</option>
                </cfoutput>
            </select>
        </div>
    </div>
    <div class="form-group">
        <label class="col col-4 col-xs-12"><cf_get_lang no='151.Tahmini Ciro'></label>
        <div class="col col-2">
            <select name="endorse_total" id="endorse_total" style="width:50px;">
                <option value=""><cf_get_lang no='1.Ciro'></option>
                <option value="1" <cfif get_info.endorse_period eq 1> selected</cfif>><cf_get_lang_main no='1520.Aylık'></option>
                <option value="2" <cfif get_info.endorse_period eq 2> selected</cfif>>2 <cf_get_lang_main no='1520.Aylık'></option>
                <option value="3" <cfif get_info.endorse_period eq 3> selected</cfif>>3 <cf_get_lang_main no='1520.Aylık'></option>
                <option value="4" <cfif get_info.endorse_period eq 4> selected</cfif>>4 <cf_get_lang_main no='1520.Aylık'></option>
                <option value="5" <cfif get_info.endorse_period eq 5> selected</cfif>>6 <cf_get_lang_main no='1520.Aylık'></option>
                <option value="6" <cfif get_info.endorse_period eq 6> selected</cfif>><cf_get_lang_main no='1603.Yıllık'></option>
            </select>
        </div>
        <div class="col col-5">
            <div class="input-group">
                <cfinput type="text" name="endorse_payment" style="width:97px;" value="#tlformat(get_info.endorse_payment)#" maxlength="100" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                <span class="input-group-addon width">
                    <select name="money_curr" id="money_curr" style="width:50px;">
                        <cfoutput query="get_money">
                            <option value="#money#" <cfif money eq get_info.endorse_currency> selected</cfif>>#money#</option>
                        </cfoutput>
                    </select>
                </span>
            </div>
        </div>
    </div>
   <div class="form-group">
        <label class="col col-4 col-xs-12"><cf_get_lang no='495.IT Teknolojilerine Yatkınlığı'></label>
        <div class="col col-8">
            <select name="it_concerned" id="it_concerned" style="width:150px;">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                <cfoutput query="get_it_concern">
                    <option value="#concern_id#" <cfif get_company_service_info_detail.it_concerned eq concern_id> selected</cfif>>#concern_name#</option>
                </cfoutput>
            </select>
        </div>
    </div>
</div>
    </cf_box_elements>
    <cf_box_footer>
        <div class="col col-6">
            <cf_record_info query_name="get_company_service_info_detail">
        </div>
        <div class="col col-6">
            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='hepsini_sec()'>
        </div>
    </cf_box_footer>
</cfform>
</cf_box>

<script type="text/javascript">
function remove_field(field_option_name)
{
	field_option_name_value = eval('document.upd_company_special.' + field_option_name);
	for (i=field_option_name_value.options.length-1;i>-1;i--)
	{
		if (field_option_name_value.options[i].selected==true)
		{
			field_option_name_value.options.remove(i);
		}	
	}
}

function select_all(selected_field)
{
	var m = eval("document.upd_company_special."+selected_field+".length");
	for(i=0;i<m;i++)
	{
		eval("document.upd_company_special."+selected_field+"["+i+"].selected=true")
	}
}

function hepsini_sec()
{
	select_all('society');
	select_all('customer_position');
	select_all('insurance_company');
	select_all('other_works');
	select_all('competitor_depot');
	select_all('softwares');
	upd_company_special.endorse_payment.value = filterNum(upd_company_special.endorse_payment.value);
}
</script>
