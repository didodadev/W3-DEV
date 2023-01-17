<cf_xml_page_edit fuseact="ch.form_add_cari_rate_valuation">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.startdate2" default="">
<cfparam name="attributes.finishdate2" default="">
<cfparam name="attributes.action_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.valuation_date" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.duty_claim" default="">
<cfparam name="attributes.money_type_info" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.member_addoptions" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.sales_zones" default="">
<cf_date tarih='attributes.ACTION_DATE'>
<cfquery name="get_company_cat" datasource="#dsn#">
    SELECT DISTINCT	
        COMPANYCAT_ID,
        COMPANYCAT
    FROM
        GET_MY_COMPANYCAT
    WHERE
        EMPLOYEE_ID = #session.ep.userid# AND
        OUR_COMPANY_ID = #session.ep.company_id#
    ORDER BY
        COMPANYCAT
</cfquery>
<cfquery name="get_consumer_cat" datasource="#dsn#">
    SELECT DISTINCT	
        CONSCAT_ID,
        CONSCAT,
        HIERARCHY
    FROM
        GET_MY_CONSUMERCAT
    WHERE
        EMPLOYEE_ID = #session.ep.userid# AND
        OUR_COMPANY_ID = #session.ep.company_id#
    ORDER BY
        HIERARCHY		
</cfquery>
  <cfquery name="GET_MONEY_RATE" datasource="#dsn#"> <!--- SETUP_MONEY yerine MONEY_HISTORY'den alıyorum. excele alırken js çalışmadığından tarihi ne yollarsan yolla kurlar değişmediğinden bugüne göre getiriyordu Durgan20150515 --->
    SELECT MONEY,RATE1,RATE2,0 AS IS_SELECTED,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID=#session.ep.company_id# AND PERIOD_ID=#session.ep.period_id# AND VALIDATE_DATE = #attributes.action_date# GROUP BY MONEY)
</cfquery>
<cfif GET_MONEY_RATE.recordcount eq 0>
    <cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
        SELECT MONEY,RATE1,RATE2,RATE3,ISNULL(EFFECTIVE_SALE,0) AS EFFECTIVE_SALE,ISNULL(EFFECTIVE_PUR,0) AS EFFECTIVE_PUR FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#' ORDER BY MONEY_ID
    </cfquery>
</cfif> 
<cfquery name="get_member_add_options" datasource="#dsn#">
    SELECT MEMBER_ADD_OPTION_NAME,MEMBER_ADD_OPTION_ID FROM SETUP_MEMBER_ADD_OPTIONS
</cfquery>
<cfquery name="get_all_ch_type" datasource="#dsn#">
    SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_ID
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfoutput query="get_money_rate">
        <cfscript>
			if(isDefined("attributes.txt_rate2_1_"&get_money_rate.money[currentrow])) {
            	QuerySetCell(get_money_rate,"rate2",Replace(evaluate("attributes.txt_rate2_1_"&get_money_rate.money[currentrow]),',','.'),currentrow);
            	QuerySetCell(get_money_rate,"rate3",Replace(evaluate("attributes.txt_rate2_1_"&get_money_rate.money[currentrow]),',','.'),currentrow);
			}
        </cfscript>
    </cfoutput>
	<cfset from_rate_valuation = 1>
	<cfinclude template="../query/get_member.cfm">
<cfelse>
	<cfset get_member.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default = "#get_member.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfset pageHead = #getLang('ch',23)#>
<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
    <cf_catalystHeader>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="add_rate_valuation" method="post" action="#request.self#?fuseaction=ch.form_add_cari_rate_valuation">
        <cfoutput query="get_money_rate">
            <cfif xml_money_type eq 0>
                <cfset currency_rate_ = RATE2>
            <cfelseif xml_money_type eq 1>
                <cfset currency_rate_ = RATE3>
            <cfelseif xml_money_type eq 2>
                <cfset currency_rate_ = RATE2>
            <cfelseif xml_money_type eq 3>
                <cfset currency_rate_ = EFFECTIVE_PUR>
            <cfelseif xml_money_type eq 4>
                <cfset currency_rate_ = EFFECTIVE_SALE>
            </cfif>
            <cfset "rate_#money#" = currency_rate_>
        </cfoutput>
        <cfoutput query="get_money_rate">
            <input type="hidden" class="box" name="excel_rate2_#money#" id="excel_rate2_#money#" value="#tlformat(evaluate('rate_#money#'),session.ep.our_company_info.rate_round_num)#">
        </cfoutput>
        <cf_box>
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <input type="hidden" name="member_cat_value" id="member_cat_value" value="">
            <input type="hidden" name="money_info" id="money_info" value="2">
            <input type="hidden" name="order_type" id="order_type" value="1">
            <input type="hidden" name="startrow" id="startrow" value="<cfoutput>#attributes.startrow#</cfoutput>">
            <cf_box_elements id="rate_valuation" vertical="1">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-member_cat_type">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
                        <div class="col col-12 col-xs-12">
                            <select name="member_cat_type" id="member_cat_type" multiple >
                                <option value="1_0" <cfif listfind(attributes.member_cat_type,'1_0',',')>selected</cfif>><cf_get_lang dictionary_id='42123.Kurumsal Üye Kategorileri'></option>
                                <cfoutput query="get_company_cat">
                                    <option value="1_#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'1_#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option></cfoutput>
                                    <option value="2_0" <cfif listfind(attributes.member_cat_type,'2_0',',')>selected</cfif>><cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'></option>
                                <cfoutput query="get_consumer_cat">
                                    <option value="2_#CONSCAT_ID#" <cfif listfind(attributes.member_cat_type,'2_#CONSCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
                                </cfoutput>
                                <option value="5_0" <cfif listfind(attributes.member_cat_type,'5_0',',')>selected</cfif>><cf_get_lang dictionary_id='30370.Çalışanlar'></option>
                                <cfoutput query="get_all_ch_type">
                                    <option value="5_#acc_type_id#" <cfif listfind(attributes.member_cat_type,'5_#acc_type_id#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#acc_type_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-member_addoptions">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='30200.Üye Özel Tanımı'></label>
                        <div class="col col-12 col-xs-12">
                            <select name="member_addoptions" id="member_addoptions">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_member_add_options">
                                    <option value="#member_add_option_id#" <cfif get_member_add_options.member_add_option_id eq attributes.member_addoptions>selected</cfif>>#member_add_option_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>    
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                    <div class="form-group" id="item-money_type">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                        <div class="col col-12 col-xs-12">
                            <select name="money_type_info" id="money_type_info">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_money_rate">
                                    <option value="#MONEY#" <cfif get_money_rate.money eq attributes.money_type_info>selected</cfif>>#MONEY#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-duty_claim">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57866.Borç /Alacak Durumu'></label>
                        <div class="col col-12 col-xs-12">
                            <select name="duty_claim" id="duty_claim">
                                <option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
                                <option value="1" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 1>selected</cfif>><cf_get_lang dictionary_id='40026.Borçlu Üyeler'></option>
                                <option value="2" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 2>selected</cfif>><cf_get_lang dictionary_id='40027.Alacaklı Üyeler'></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                    <div class="form-group" id="item-company_id">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company_id)>value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.consumer_id)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                                <input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.employee_id)>value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
                                <input type="hidden" name="member_type" id="member_type" <cfif len(attributes.member_type)>value="<cfoutput>#attributes.member_type#</cfoutput>"</cfif>>
                                <input name="member_name" type="text" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','225');" <cfif len(attributes.member_name)>value="<cfoutput>#attributes.member_name#</cfoutput>"</cfif> autocomplete="off">
                                <cfset str_linke_ait="field_consumer=add_rate_valuation.consumer_id&field_comp_id=add_rate_valuation.company_id&field_comp_name=add_rate_valuation.member_name&field_name=add_rate_valuation.member_name&field_emp_id=add_rate_valuation.employee_id&field_type=add_rate_valuation.member_type">
                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&<cfoutput>#str_linke_ait#</cfoutput>&select_list=2,3,1,9','list','popup_list_pars');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-date">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id='50060.Başlangıç Tarihini Doğru Giriniz'></cfsavecontent>
                                <cfinput type="text" name="startdate2" value="#dateformat(attributes.startdate2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#" style="width:65px;">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate2"></span>
                               
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id='50059.Bitiş Tarihini Doğru Giriniz'></cfsavecontent>
                                <cfinput type="text" name="finishdate2" value="#dateformat(attributes.finishdate2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#" style="width:65px;">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate2"></span>
                                
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
                    <div class="form-group" id="item-sales_zone">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
                        <div class="col col-12 col-xs-12">
                            <cfsavecontent variable="text"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
                            <cf_wrk_saleszone 
                                width="120"
                                name="sales_zones"
                                option_text="#text#"
                                value="#attributes.sales_zones#">
                        </div>
                    </div>
                    <div class="form-group" id="item-valuation_date">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="valuation_date" value="#dateformat(attributes.valuation_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;" title="Son Değerleme Tarihi">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="valuation_date"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
				<div class="col col-12 text-right">
                    <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                    <cfelse>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                    </cfif>
                    <cf_wrk_search_button button_type='1' is_excel='0' search_function='kontrol()' no_show_process='1'>
                </div>
            </cf_box_footer>
        </cf_box>
    </cfform>
        <cfif isdefined("attributes.form_submitted") and get_member.recordcount>
            <cfform name="add_rate_valuation_2" method="post">
                <cf_box title="#getLang('','',49996)#" uidrop="1" hide_table_column="1">          
                    <cf_grid_list class="detail_basket_list" id="excel_div">
                        <thead>
                            <tr>
                                <th width="35" rowspan="2" class="text-center"><cf_get_lang dictionary_id='57487.No'></th>
                                <th width="50" rowspan="2" ><cf_get_lang dictionary_id='57558.Üye No'></th>	  
                                <th width="250" rowspan="2"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                                <th colspan="3" class="text-center"><cf_get_lang dictionary_id='58905.Sistem Dövizi'></th>
                                <th colspan="4" class="text-center"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
                                <th class="text-center" colspan="3"><cf_get_lang dictionary_id='48777.Değerleme'></th>
                            </tr>
                            <tr>
                                <th width="90"><cf_get_lang dictionary_id='57587.Borç'></th>
                                <th width="90"><cf_get_lang dictionary_id='57588.Alacak'></th>
                                <th width="90"><cf_get_lang dictionary_id='57589.Bakiye'></th>
                                <th width="90"><cf_get_lang dictionary_id='57587.Borç'></th>
                                <th width="90"><cf_get_lang dictionary_id='57588.Alacak'></th>
                                <th width="90"><cf_get_lang dictionary_id='57589.Bakiye'></th>
                                <th width="70"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
                                <th width="90"><cfoutput>#session.ep.money#</cfoutput><cf_get_lang dictionary_id='48778.Karşılık'> </th>
                                <th width="90"><cf_get_lang dictionary_id='57884.Kur Farkı'></th>
                                <cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                    <th width="35"  class="text-center"></th>
                                </cfif>
                            </tr>
                        </thead>
                        <tbody>
                            <cfif isdefined("attributes.form_submitted") and get_member.recordcount>                                
                                <cfset count_row = 0>
                                <cfset comp_id_list = ''>
                                <cfset cons_id_list = ''>
                                <cfset emp_id_list = ''>
                                <cfset acc_type_id_list = ''>
                                <cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                    <cfif not listfind(comp_id_list,member_id) and kontrol eq 0>
                                        <cfset comp_id_list = listappend(comp_id_list,member_id)>
                                    </cfif>	
                                    <cfif not listfind(cons_id_list,member_id) and kontrol eq 1>
                                        <cfset cons_id_list = listappend(cons_id_list,member_id)>
                                    </cfif>		
                                    <cfif not listfind(emp_id_list,member_id) and kontrol eq 2>
                                        <cfset emp_id_list = listappend(emp_id_list,member_id)>
                                    </cfif>	
                                    <cfif not listfind(acc_type_id_list,acc_type_id) and acc_type_id neq 0>
                                        <cfset acc_type_id_list = listappend(acc_type_id_list,acc_type_id)>
                                    </cfif>		
                                </cfoutput>
                                <cfif len(comp_id_list)>
                                    <cfset comp_id_list=listsort(comp_id_list,"numeric","ASC",",")>
                                    <cfquery name="get_period_comp" datasource="#dsn#">
                                        SELECT
                                            ACCOUNT_CODE,
                                            COMPANY_ID
                                        FROM
                                            COMPANY_PERIOD
                                        WHERE
                                            COMPANY_ID IN (#comp_id_list#)
                                            AND	PERIOD_ID = #session.ep.period_id#
                                        ORDER BY 
                                            COMPANY_ID
                                    </cfquery>
                                    <cfset comp_id_list = listsort(listdeleteduplicates(valuelist(get_period_comp.company_id,',')),'numeric','ASC',',')>
                                </cfif> 
                                <cfif len(cons_id_list)>
                                    <cfset cons_id_list=listsort(cons_id_list,"numeric","ASC",",")>
                                    <cfquery name="get_period_cons" datasource="#dsn#">
                                        SELECT
                                            ACCOUNT_CODE,
                                            CONSUMER_ID
                                        FROM
                                            CONSUMER_PERIOD
                                        WHERE
                                            CONSUMER_ID IN (#cons_id_list#)
                                            AND	PERIOD_ID = #session.ep.period_id#
                                        ORDER BY 
                                            CONSUMER_ID
                                    </cfquery>
                                    <cfset cons_id_list = listsort(listdeleteduplicates(valuelist(get_period_cons.consumer_id,',')),'numeric','ASC',',')>
                                </cfif> 
                                <cfif len(acc_type_id_list)>
                                    <cfset acc_type_id_list=listsort(acc_type_id_list,"numeric","ASC",",")>
                                    <cfquery name="get_ch_type" datasource="#dsn#">
                                        SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID IN (#acc_type_id_list#) ORDER BY ACC_TYPE_ID
                                    </cfquery>
                                    <cfset acc_type_id_list = listsort(listdeleteduplicates(valuelist(get_ch_type.ACC_TYPE_ID,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfquery name="get_emp_account_code" datasource="#dsn3#">
                                    SELECT
                                        PERSONAL_ADVANCE_ACCOUNT AS ACCOUNT_CODE
                                    FROM
                                        SETUP_SALARY_PAYROLL_ACCOUNTS
                                </cfquery>
                                <cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                    <cfset count_row = count_row + 1>
                                    <cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                        <input type="hidden" name="bakiye_#currentrow#" id="bakiye_#currentrow#" value="#wrk_round(bakiye)#">
                                        <input type="hidden" name="bakiye3_#currentrow#" id="bakiye3_#currentrow#" value="#abs(wrk_round(bakiye3))#">
                                        <input type="hidden" name="bakiye3_1_#currentrow#" id="bakiye3_1_#currentrow#" value="#wrk_round(bakiye3)#">
                                        <input type="hidden" name="other_money_#currentrow#" id="other_money_#currentrow#" value="#other_money#">
                                        <cfif kontrol eq 0>
                                            <input type="hidden" name="company_id_#currentrow#" id="company_id_#currentrow#" value="#member_id#">
                                            <input type="hidden" name="consumer_id_#currentrow#" id="consumer_id_#currentrow#" value="">
                                            <input type="hidden" name="employee_id_#currentrow#" id="employee_id_#currentrow#" value="">
                                            <input type="hidden" name="member_type_#currentrow#" id="member_type_#currentrow#" value="partner">
                                            <input type="hidden" name="member_code_#currentrow#" id="member_code_#currentrow#" value="#get_period_comp.account_code[listfind(comp_id_list,member_id,',')]#">
                                            <input type="hidden" name="acc_type_id_#currentrow#" id="acc_type_id_#currentrow#" value="">
                                        <cfelseif kontrol eq 1>
                                            <input type="hidden" name="company_id_#currentrow#" id="company_id_#currentrow#" value="">
                                            <input type="hidden" name="consumer_id_#currentrow#" id="consumer_id_#currentrow#" value="#member_id#">
                                            <input type="hidden" name="employee_id_#currentrow#" id="employee_id_#currentrow#" value="">
                                            <input type="hidden" name="member_type_#currentrow#" id="member_type_#currentrow#" value="consumer">
                                            <input type="hidden" name="member_code_#currentrow#" id="member_code_#currentrow#" value="#get_period_cons.account_code[listfind(cons_id_list,member_id,',')]#">
                                            <input type="hidden" name="acc_type_id_#currentrow#" id="acc_type_id_#currentrow#" value="">
                                        <cfelseif kontrol eq 2>
                                            <input type="hidden" name="company_id_#currentrow#" id="company_id_#currentrow#" value="">
                                            <input type="hidden" name="consumer_id_#currentrow#" id="consumer_id_#currentrow#" value="">
                                            <input type="hidden" name="employee_id_#currentrow#" id="employee_id_#currentrow#" value="#member_id#">
                                            <input type="hidden" name="member_type_#currentrow#" id="member_type_#currentrow#" value="employee">
                                            <input type="hidden" name="member_code_#currentrow#" id="member_code_#currentrow#" value="<cfif len(EMP_ACCOUNT_CODE)>#EMP_ACCOUNT_CODE#<cfelse>#get_emp_account_code.account_code#</cfif>">
                                            <input type="hidden" name="acc_type_id_#currentrow#" id="acc_type_id_#currentrow#" value="<cfif len(acc_type_id) and acc_type_id neq 0>#acc_type_id#</cfif>">
                                        </cfif>
                                    </cfif>
                                    <cfif len(acc_type_id) and acc_type_id neq 0>
                                        <cfset fullname_ = '#fullname# - #get_ch_type.acc_type_name[listfind(acc_type_id_list,acc_type_id,',')]#'>
                                    <cfelse>
                                        <cfset fullname_ = fullname>
                                    </cfif>
                                    <input type="hidden" name="comp_name_#currentrow#" id="comp_name_#currentrow#" value="#fullname_#">
                                    <tr>
                                        <td class="text-center">#currentrow#</td>
                                        <td>#member_code#</td>
                                        <td>
                                            <cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                                <cfif kontrol eq 0>
                                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#member_id#','list','popup_com_det');">#fullname#</a>
                                                <cfelseif kontrol eq 1>
                                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#member_id#','list','popup_con_det');">#fullname#</a>
                                                <cfelseif kontrol eq 2>
                                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','list','popup_emp_det');">#fullname#</a>
                                                </cfif>
                                            <cfelse>
                                                #fullname#
                                            </cfif>
                                            <cfif len(acc_type_id) and acc_type_id neq 0> - #get_ch_type.acc_type_name[listfind(acc_type_id_list,acc_type_id,',')]#</cfif>
                                        </td>
                                        <td class="text-right">#TLFormat(abs(borc))#</td>
                                        <td class="text-right">#TLFormat(abs(alacak))#</td>
                                        <td class="text-right">#TLFormat(abs(bakiye))# <cfif bakiye gt 0>(B)<cfelse>(A)</cfif></td>
                                        <td class="text-right">#TLFormat(abs(borc3))#</td>
                                        <td class="text-right">#TLFormat(abs(alacak3))#</td>
                                        <td class="text-right">#TLFormat(abs(bakiye3))# <cfif bakiye3 gt 0>(B)<cfelse>(A)</cfif></td>
                                        <td nowrap>#other_money#</td>                                                                               
                                        <td class="text-right">
                                            <cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                                <input type="text" name="control_amount_#currentrow#" id="control_amount_#currentrow#" value="#tlformat(evaluate('rate_#other_money#')*abs(bakiye3))#" class="box" readonly style="width:70px;">
                                            <cfelse>
                                                #tlformat(filterNum(evaluate('excel_rate2_#other_money#'),4)*abs(bakiye3))#
                                            </cfif>
                                        </td>
                                        <td class="text-right">
                                            <cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                                <input type="text" name="control_amount_2_#currentrow#" id="control_amount_2_#currentrow#" value="#tlformat((evaluate('rate_#other_money#')*wrk_round(bakiye3))-wrk_round(bakiye))#" class="box" readonly style="width:70px;">
                                            <cfelse>
                                                #tlformat((filterNum(evaluate('excel_rate2_#other_money#'),4)*wrk_round(bakiye3))-wrk_round(bakiye))#
                                            </cfif>
                                        </td>
                                        <cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                            <td align="center">                                            
                                                <input type="checkbox" name="is_pay_#currentrow#" id="is_pay_#currentrow#" value="#member_id#" onClick="check_kontrol(this);" <cfif isdefined("is_pay_#currentrow#")>checked</cfif><cfif wrk_round(((evaluate('rate_#other_money#')*bakiye3)-bakiye),2) eq 0>disabled</cfif>>                                            
                                            </td>
                                        </cfif>			
                                    </tr>
                                </cfoutput>
                            <cfelse>
                                <tr> 
                                    <td colspan="20" ><cfif not  isdefined("attributes.form_submitted") ><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelseif get_member.recordcount eq 0><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
                                </tr>
                            </cfif>
                        </tbody>
                    </cf_grid_list>
                </cf_box> 
                <!-- sil -->       
                <cf_box>
                    <input type="hidden" name="count_row" id="count_row" value="<cfoutput>#count_row#</cfoutput>">                    
                    <cfinclude template="add_cari_rate_valuation_1.cfm">                    
                </cf_box>
                <!-- sil -->
            </cfform>
        </cfif>
	<!-- sil -->
	<cfif isdefined("attributes.form_submitted") and get_member.recordcount and attributes.totalrecords gt attributes.maxrows and get_member.recordcount>
		<cf_box>
            <cfset adres="ch.form_add_cari_rate_valuation&finishdate2=#dateformat(attributes.finishdate2,dateformat_style)#&startdate2=#dateformat(attributes.startdate2,dateformat_style)#">
            <cfif isdefined('attributes.member_cat_value')>
                <cfset adres=adres&'&member_cat_value=#attributes.member_cat_value#'>
            </cfif>
            <cfif isdefined('attributes.money_info')>
                <cfset adres=adres&'&money_info=#attributes.money_info#'>
            </cfif>
            <cfif isdefined("attributes.duty_claim")>
                <cfset adres=adres&'&duty_claim=#attributes.duty_claim#'>
            </cfif>
            <cfif len(attributes.form_submitted)>
                <cfset adres = adres&'&form_submitted=#attributes.form_submitted#'>
            </cfif>
            <cfif len(attributes.money_type_info)>
                <cfset adres = adres&'&money_type_info=#attributes.money_type_info#'>
            </cfif>
            <cfif len(attributes.member_addoptions)>
                <cfset adres = adres&'&member_addoptions=#attributes.member_addoptions#'>
            </cfif>
            <cfif isdefined('attributes.sales_zones')>
                <cfset adres=adres&'&sales_zones=#attributes.sales_zones#'>
            </cfif>
            <cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
                <cfset adres=adres&'&valuation_date=#dateformat(attributes.valuation_date,dateformat_style)#'>
            </cfif>
            <cfset adres = adres&'&member_cat_type=#attributes.member_cat_type#&from_rate_valuation=1&order_type=1'>
            <cf_paging
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#" 
                adres="#adres#">
        </cf_box>
	</cfif>
	<!-- sil -->        
</div>
<script type="text/javascript">
    <cfif attributes.is_excel eq 1>
		$(function(){
            TableToExcel.convert(document.getElementById('excel_div'));           
        });
	</cfif>
	var control_checked = 0;
	start_row = <cfoutput>#attributes.startrow#</cfoutput>;
	all_records = <cfoutput>#attributes.startrow+attributes.maxrows#</cfoutput>;
	function hepsi_view()
	{
		for(j=start_row;j<=all_records;j++)
		{
			if(eval("document.add_rate_valuation_2.other_money_"+j) != undefined)
			{
				eval('add_rate_valuation_2.is_pay_'+j).checked = false;
				control_checked--;
			}
		}
	}
	function check_kontrol(nesne)
	{
		if(nesne.checked)
			control_checked++;
		else
			control_checked--;
	}
	function toplam_hesapla()
	{
        
		for(s=1;s<=document.all.kur_say.value;s++)
		{
			money_deger = eval("document.add_rate_valuation_2.hidden_rd_money_"+s).value;

			eval("document.add_rate_valuation_2.txt_rate2_1_"+money_deger).value = eval("document.add_rate_valuation_2.txt_rate2_"+s).value;

            document.getElementById("excel_rate2_"+money_deger).value = document.getElementById("txt_rate2_"+s).value;
		}
		for(j=start_row;j<=all_records;j++)
		{
			if(eval("document.add_rate_valuation_2.other_money_"+j) != undefined)
			{
				row_money = eval("document.add_rate_valuation_2.other_money_"+j).value;
				eval('document.add_rate_valuation_2.control_amount_'+j).value = commaSplit(eval("document.add_rate_valuation_2.bakiye3_"+j).value*filterNum(eval("document.add_rate_valuation_2.txt_rate2_1_"+row_money).value,4),2);
				eval('document.add_rate_valuation_2.control_amount_2_'+j).value =  commaSplit((eval("document.add_rate_valuation_2.bakiye3_1_"+j).value*filterNum(eval("document.add_rate_valuation_2.txt_rate2_1_"+row_money).value,4))-eval("document.add_rate_valuation_2.bakiye_"+j).value)
				//alert(eval("document.add_rate_valuation_2.txt_rate2_1_"+row_money).value,4);
				if(filterNum(eval('document.add_rate_valuation_2.control_amount_2_'+j).value) == 0)
				{
					eval('document.add_rate_valuation_2.is_pay_'+j).disabled = true;
				}
				else
				{
					eval('document.add_rate_valuation_2.is_pay_'+j).disabled = false;
				}	
			}
		}
	}
	function open_dekont()
	{
		<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
		var action_account_code = document.getElementById("action_account_code").value;
		if(action_account_code != "")
		{ 
			if(WrkAccountControl(action_account_code,'Muhasebe Hesabı Hesap Planında Tanımlı Değildir!') == 0)
			return false;
		}
		member_id_list_1='';
		member_id_list_2='';
		for(j=start_row;j<=all_records;j++)
		{
			if(eval("document.add_rate_valuation_2.other_money_"+j) != undefined && eval("document.add_rate_valuation_2.is_pay_"+j) != undefined && eval("document.add_rate_valuation_2.is_pay_"+j).disabled == false && eval("document.add_rate_valuation_2.is_pay_"+j).checked == true)
			{
				if(eval('document.add_rate_valuation_2.control_amount_2_'+j) != undefined && filterNum(eval('document.add_rate_valuation_2.control_amount_2_'+j).value) > 0)
					member_id_list_1+=eval('document.add_rate_valuation_2.control_amount_2_'+j).value;
				else if(eval('document.add_rate_valuation_2.control_amount_2_'+j) != undefined && filterNum(eval('document.add_rate_valuation_2.control_amount_2_'+j).value) < 0)
					member_id_list_2+=eval('document.add_rate_valuation_2.control_amount_2_'+j).value;
			}
		}
        if(member_id_list_1 != '' && member_id_list_2 != '')
		{
			alert("<cf_get_lang dictionary_id='49990.Borç ve Alacak Karakterli İşlemleri Bir arada Seçemezsiniz'> !");
			return false;
		}
		if(member_id_list_1 == '' && member_id_list_2 == '')
		{
			alert("<cf_get_lang dictionary_id='45799.En Az Bir İşlem Seçmelisiniz'> !");
			return false;
		}
		else
		{
			if(member_id_list_1 != '')debt_claim=1;else debt_claim=0;
			windowopen('<cfoutput>#request.self#?fuseaction=ch.form_add_debit_claim_note&event=addMulti&from_rate_valuation&maxrows=#attributes.maxrows#&debt_claim='+debt_claim+'</cfoutput>','wide');
			return false;
		}
	}
	function kontrol()
	{
		if(document.add_rate_valuation.member_name.value != "")
		{
			if (document.add_rate_valuation.company_id.value != '' && document.add_rate_valuation.member_type.value == 'partner')
			{
				document.add_rate_valuation.member_cat_value.value=1;
			}
			if (document.add_rate_valuation.consumer_id.value != '' && document.add_rate_valuation.member_type.value == 'consumer')
			{
				document.add_rate_valuation.member_cat_value.value=2;
			}	
			if (document.add_rate_valuation.employee_id.value != '' && document.add_rate_valuation.member_type.value == 'employee')
			{
				document.add_rate_valuation.member_cat_value.value = 5;
			}		
		}
        

		
	}
	function check_currency(type)
	{
		if(type == 1 && document.getElementById('is_minus_currency').checked == true)
		{
			document.getElementById('is_plus_currency').checked=false;
			for(j=start_row;j<=all_records;j++)
			{
				if(document.getElementById('other_money_'+j) != undefined)
				{
					if(parseFloat(filterNum(document.getElementById('control_amount_2_'+j).value)) <0)
						document.getElementById('is_pay_'+j).checked = true;
					else
						document.getElementById('is_pay_'+j).checked = false;
					
				}
			}
		}
		else if(type == 2 && document.getElementById('is_plus_currency').checked == true)
		{
			document.getElementById('is_minus_currency').checked=false;			
			for(j=start_row;j<=all_records;j++)
			{
				if(document.getElementById('other_money_'+j) != undefined)
				{
					if(parseFloat(filterNum(document.getElementById('control_amount_2_'+j).value)) >0)
					{
						eval('document.add_rate_valuation_2.is_pay_'+j).checked = true;
					}
					else
						eval('document.add_rate_valuation_2.is_pay_'+j).checked = false;
				}
			}
		}
		else
			hepsi_view();
	}
</script>
