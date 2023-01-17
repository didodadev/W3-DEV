<cf_get_lang_set module_name="invoice">
<!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="invoice.add_bill_retail">
<cfset member_ims_code_id = ''>
<cfscript>
session_basket_kur_ekle(process_type:0);
xml_all_depo = iif(isdefined("xml_location_auth"),xml_location_auth,DE('-1'));
</cfscript>
<cfinclude template="../query/control_bill_no.cfm">
<cfquery name="GET_CITY" datasource="#dsn#">
    SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY WHERE PHONE_CODE IS NOT NULL OR PHONE_CODE <> '' ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_CONSUMER_STAGE" datasource="#dsn#" maxrows="1">
    SELECT TOP 1
        PTR.STAGE,
        PTR.PROCESS_ROW_ID,
        PTR.LINE_NUMBER
    FROM
        PROCESS_TYPE_ROWS PTR,
        PROCESS_TYPE_OUR_COMPANY PTO,
        PROCESS_TYPE PT
    WHERE
        PT.IS_ACTIVE = 1 AND
        PT.PROCESS_ID = PTR.PROCESS_ID AND
        PT.PROCESS_ID = PTO.PROCESS_ID AND
        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_consumer%">
    ORDER BY
        PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_COMPANY_STAGE" datasource="#dsn#" maxrows="1">
    SELECT TOP 1
        PTR.STAGE,
        PTR.PROCESS_ROW_ID,
        PTR.LINE_NUMBER
    FROM
        PROCESS_TYPE_ROWS PTR,
        PROCESS_TYPE_OUR_COMPANY PTO,
        PROCESS_TYPE PT
    WHERE
        PT.IS_ACTIVE = 1 AND
        PT.PROCESS_ID = PTR.PROCESS_ID AND
        PT.PROCESS_ID = PTO.PROCESS_ID AND
        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
    ORDER BY
        PTR.LINE_NUMBER
</cfquery>
<cfparam name="attributes.member_type" default="2">
<cfparam name="attributes.comp_member_cat" default="">
<cfparam name="attributes.cons_member_cat" default="">
<cfparam name="attributes.field_vocation" default="">
<cfquery name="get_vocation_type" datasource="#dsn#">
    SELECT VOCATION_TYPE_ID, VOCATION_TYPE FROM SETUP_VOCATION_TYPE ORDER BY VOCATION_TYPE
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
<div id="basket_main_div">
  <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill_retail">
    <cf_basket_form id="add_bill_retail">
      <input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill_retail</cfoutput>">
      <input type="hidden" name="xml_kontrol_tcnumber" id="xml_kontrol_tcnumber" value="<cfoutput>#xml_kontrol_tcnumber#</cfoutput>">
      <input type="hidden" name="country" id="country">
      <cf_papers paper_type="invoice" form_name="form_basket" form_field="invoice_number">
      <cfoutput>
        <input type="hidden" name="paper" id="paper" value="<cfif isDefined('paper_number')>#paper_number#</cfif>">
        <input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')>#paper_printer_code#</cfif>">
        <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
        <input type="hidden" name="consumer_stage" id="consumer_stage" value="<cfif GET_CONSUMER_STAGE.recordcount>#GET_CONSUMER_STAGE.PROCESS_ROW_ID#</cfif>">
        <input type="hidden" name="company_stage" id="company_stage" value="<cfif GET_COMPANY_STAGE.recordcount>#GET_COMPANY_STAGE.PROCESS_ROW_ID#</cfif>">
      </cfoutput>
      <cfquery name="get_consumer_cat" datasource="#dsn#">
          SELECT CONSCAT_ID FROM CONSUMER_CAT WHERE IS_DEFAULT = 1
      </cfquery>
      <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
      <input type="hidden" name="member_account_code" id="member_account_code" value="">
      <input type="hidden" name="cash" id="cash" value="0">
      <input type="hidden" name="is_pos" id="is_pos" value="">
      <input type="hidden" name="consumer_cat_id" id="consumer_cat_id" value="<cfif get_consumer_cat.recordcount><cfoutput>#get_consumer_cat.conscat_id#</cfoutput><cfelse>1</cfif>">
      <input type="hidden" name="company_cat_id" id="company_cat_id" value="1">
      <input type="hidden" name="company_id" id="company_id" value="">
      <input type="hidden" name="partner_id" id="partner_id" value="">
      <input type="hidden" name="consumer_id" id="consumer_id" value="">
      <input type="hidden" name="ship_address_id" id="ship_address_id">
      <cf_box_elements>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
              <div class="form-group" id="item-member_name">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57570.Ad Soyad'>
                </label>
                <div class="col col-4 col-xs-12">
                  <input type="text" name="member_name" id="member_name" value="" tabindex="1" maxlength="50">
                </div>
                <div class="col col-4 col-xs-12">
                  <input type="text" name="member_surname" id="member_surname" value="" tabindex="2" onblur="cons_pre_records();" maxlength="50">
                </div>
              </div>
              <div class="form-group" id="item-address">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='58723.Adres'>
                </label>
                <div class="col col-8 col-xs-12">
                  <textarea name="address" id="address" tabindex="4"></textarea>
                </div>
              </div>
              <div class="form-group" id="item-county">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='58608.İl'> - <cf_get_lang dictionary_id='58638.İlçe'>
                </label>
                <div class="col col-4 col-xs-12">
                  <select id="city"  name="city" onchange="LoadCounty(this.value,'county_id','tel_code')" tabindex="5">
                    <option value="">
                      <cf_get_lang dictionary_id='57734.seçiniz'>
                    </option>
                  </select>
                </div>
                <div class="col col-4 col-xs-12">
                    <select id="county_id" name="county_id" tabindex="5">
                      <option value="">
                        <cf_get_lang dictionary_id='57734.seçiniz'>
                      </option>
                    </select>
                </div>
              </div>
              <div class="form-group" id="item-tax_office">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='58762.Vergi Dairesi'>
                </label>
                <div class="col col-8 col-xs-12">
                  <cfinput type="text" id="tex_office" name="tax_office"  maxlength="30" tabindex="7">
                </div>
              </div>
              <div class="form-group" id="item-tax_num">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57752.Vergi No'>
                </label>
                <div class="col col-8 col-xs-12">
                  <cfsavecontent variable="message">
                    <cf_get_lang dictionary_id='57752.Vergi No'>
                  </cfsavecontent>
                  <cfinput type="text" id="tax_num" name="tax_num" tabindex="8" maxlength="10" onKeyUp="isNumber(this);" validate="integer" message="#message#" onblur="tax_num_pre_records();" >
                </div>
              </div>
              <div class="form-group" id="item-tc_num">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id ='58025.TC Kimlik No'>
                </label>
                <div class="col col-8 col-xs-12">
                  <cfsavecontent variable="message">
                    <cf_get_lang dictionary_id ='58025.TC Kimlik No'>
                  </cfsavecontent>
                  <cfinput type="text" id="tc_num" name="tc_num" tabindex="20"  maxlength="11" onKeyUp="isNumber(this);" validate="integer" message="#message#">
                </div>
              </div>
              <div class="form-group" id="item-ims_code_id">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'>
                </label>
                <div class="col col-8 col-xs-12">
                  <div class="input-group">
                    <input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfif len(member_ims_code_id)><cfoutput>#member_ims_code_id#</cfoutput></cfif>">
                    <input type="text" name="ims_code_name" id="ims_code_name" value="<cfif len(member_ims_code_id)><cfoutput>#get_ims.ims_code_name#</cfoutput></cfif>" readonly="yes" tabindex="44">
                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_ims_code&field_name=form_basket.ims_code_name&field_id=form_basket.ims_code_id&select_list=1</cfoutput>','list','popup_list_ims_code');return false"></span> 
                  </div>
                </div>
              </div>
            </div>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
              <div class="form-group" id="item-comp_name">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='58607.Firma'>
                </label>
                <div class="col col-8 col-xs-12">
                  <input type="text" name="comp_name" id="comp_name" value="" onblur="comp_pre_records();" maxlength="60">
                  <input name="basket_due_value" id="basket_due_value" type="hidden" value="">
                </div>
              </div>
              <div class="form-group" id="item-tel_code">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57220.Telefon Numarası'>
                </label>
                <div class="col col-3 col-xs-12">
                  <cfsavecontent variable="message">
                    <cf_get_lang dictionary_id='57252.Telefon Kodu '>
                    !
                  </cfsavecontent>
                  <cfinput type="text" id="tel_code" name="tel_code" maxlength="5" passthrough="readonly=yes" validate="integer" message="#message#">
                </div>
                <div class="col col-5 col-xs-12">
                  <cfsavecontent variable="message">
                    <cf_get_lang dictionary_id='57220.Telefon Numarası'>
                    !
                  </cfsavecontent>
                  <cfinput type="text" tabindex="9" name="tel_number" maxlength="7" validate="integer" message="#message#">
                </div>
              </div>
              <div class="form-group" id="item-faxcode">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57488.Faks'>
                </label>
                <div class="col col-3 col-xs-12">
                  <cfsavecontent variable="message">
                    <cf_get_lang dictionary_id='57221.Faks Kodu '>
                  </cfsavecontent>
                  <cfinput type="text" id="faxcode" name="faxcode" passthrough="readonly=yes" maxlength="5" message="#message#">
                </div>
                <div class="col col-5 col-xs-12">
                  <cfsavecontent variable="message">
                    <cf_get_lang dictionary_id='57222.Faks Numarası'>
                  </cfsavecontent>
                  <cfinput name="fax_number" tabindex="10" maxlength="7" type="text" validate="integer" message="#message#">
                </div>
              </div>
              <div class="form-group" id="item-mobil_code">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58473.Mobil'></label>
                <div class="col col-3 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57406.Mobil Telefon'>!</cfsavecontent>
                    <cfinput name="mobil_code" value="" id="mobil_code" tabindex="12" maxlength="7" type="text"  validate="integer"  message="#message#">
                </div>
                <div class="col col-5 col-xs-12">
                  <cfinput name="mobil_tel" id="mobil_tel" tabindex="12" maxlength="10" type="text"  validate="integer"  message="#message#">
                </div>
              </div>
              <div class="form-group" id="item-email">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57428.E-Mail'>
                </label>
                <div class="col col-8 col-xs-12">
                  <input type="text" name="email" id="email" tabindex="13"  maxlength="50">
                </div>
              </div>
              <cfif session.ep.our_company_info.asset_followup eq 1>
                <div class="form-group" id="item-ASSET_ID">
                  <label class="col col-4 col-xs-12">
                    <cf_get_lang dictionary_id ='58833.Fiziki Varlık'>
                  </label>
                  <div class="col col-8 col-xs-12">
                    <cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
                      <cf_wrkassetp fieldid='asset_id' fieldname='asset_name'  form_name='form_basket' asset_id='#attributes.assetp_id#'>
                      <cfelse>
                      <cf_wrkassetp fieldid='asset_id' fieldname='asset_name'  form_name='form_basket'>
                    </cfif>
                  </div>
                </div>
              </cfif> 
              <div class="form-group" id="item-comp_member_cat">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='58609.Üye Kategorisi'>
                </label>
                <div class="col col-8 col-xs-12">
                  <div id="is_company" <cfif attributes.member_type neq 1> style="display:none;"</cfif>>
                    <cfquery name="GET_COMPANYCAT" datasource="#DSN#">
                        SELECT DISTINCT
                            COMPANYCAT_ID,
                            COMPANYCAT
                        FROM
                            GET_MY_COMPANYCAT
                        WHERE
                            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                        ORDER BY
                            COMPANYCAT
                    </cfquery>
                      <select name="comp_member_cat" id="comp_member_cat">
                        <option value="" selected>
                          <cf_get_lang dictionary_id='57734.Seçiniz'>
                        </option>
                        <cfoutput query="get_companycat">
                          <option value="#COMPANYCAT_ID#" <cfif attributes.comp_member_cat is '#COMPANYCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option>
                        </cfoutput>
                      </select>
                  </div>
                  <div id="is_consumer" <cfif attributes.member_type neq 2> style="display:none;"</cfif>>
                    <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
                        SELECT DISTINCT
                            CONSCAT_ID,
                            CONSCAT,
                            HIERARCHY
                        FROM
                            GET_MY_CONSUMERCAT
                        WHERE
                            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                            AND IS_ACTIVE = 1
                        ORDER BY
                            CONSCAT
                    </cfquery>
                    <select name="cons_member_cat" id="cons_member_cat">
                      <option value="" selected>
                        <cf_get_lang dictionary_id='57734.Seçiniz'>
                      </option>
                      <cfoutput query="get_consumer_cat">
                        <option value="#CONSCAT_ID#" <cfif attributes.cons_member_cat is '#CONSCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
                      </cfoutput>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
              <div class="form-group" id="item-member_code">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57558.Üye No'>
                </label>
                <div class="col col-8 col-xs-12">
                  <input name="member_code" id="member_code" type="text" size="10">
                </div>
              </div>
              <div class="form-group" id="item-islem_tipi">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57800.işlem tipi'>
                </label>
                <div id="islem_tipi" class="col col-8 col-xs-12">
                  <cf_workcube_process_cat>
                  <cfif isdefined("attributes.invoice_id")>
                    <input type="hidden" name="bool_from_control_bill" id="bool_from_control_bill" value="<cfoutput>#attributes.invoice_id#</cfoutput>">
                  </cfif>
                </div>
              </div>
              <div class="form-group" id="item-invoice_number">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='58133.Fatura No'>
                </label>
                <div class="col col-8 col-xs-12">
                  <cfif isDefined('paper_full')>
                    <cfinput id="invoice_number" type="text" maxlength="50" tabindex="14" name="invoice_number" value="#paper_full#" required="Yes" message="#message#" onBlur="paper_control(this,'INVOICE');">
                    <cfelse>
                    <cfinput type="text" maxlength="50" tabindex="14" name="invoice_number" value="" required="Yes" message="#message#" onBlur="paper_control(this,'INVOICE');">
                  </cfif>
                </div>
              </div>
              <div class="form-group" id="item-invoice_date">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='58759.Fatura Tarihi'>
                </label>
                <div class="col col-8 col-xs-12">
                  <div class="input-group">
                    <cfsavecontent variable="message">
                      <cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'>
                    </cfsavecontent>
                    <cfinput type="text" name="invoice_date" id="invoice_date" required="Yes" message="#message#" value="#dateformat(now(), dateformat_style)#" validate="#validate_style#" maxlength="10" passthrough="onBlur=""change_money_info('form_basket','invoice_date');""">
                    <span class="input-group-addon btn_Pointer">
                      <cf_wrk_date_image date_field="invoice_date" call_function="change_money_info">
                    </span>
                  </div>
                </div>
              </div>
              <div class="form-group" id="item-depo">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='58763.Depo'>
                </label>
                <div id="depo" class="col col-8 col-xs-12">
                  <cfset user_dep_id = listgetat(session.ep.user_location,1,'-')>
                  <cfquery name="GET_DEPARTMENT_NAME" datasource="#DSN#">
                      SELECT
                          DEPARTMENT.DEPARTMENT_HEAD,
                          DEPARTMENT.BRANCH_ID,
                          STOCKS_LOCATION.LOCATION_ID,
                          STOCKS_LOCATION.COMMENT
                      FROM
                          DEPARTMENT,
                          STOCKS_LOCATION
                      WHERE
                          DEPARTMENT.DEPARTMENT_ID = STOCKS_LOCATION.DEPARTMENT_ID AND
                          DEPARTMENT.DEPARTMENT_ID = #user_dep_id# AND
                          DEPARTMENT.IS_STORE <> 2 AND
                          STOCKS_LOCATION.PRIORITY = 1
                  </cfquery>
                  <cfif GET_DEPARTMENT_NAME.recordcount>
                    <cfset dept_name=GET_DEPARTMENT_NAME.DEPARTMENT_HEAD & '-' & GET_DEPARTMENT_NAME.COMMENT>
                    <cfelse>
                    <cfset dept_name="">
                  </cfif>
                  <cfif GET_DEPARTMENT_NAME.recordcount>
                    <cf_wrkdepartmentlocation
                      returninputvalue="location_id,department_name,department_id,branch_id"
                      returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                      fieldname="department_name"
                      fieldid="location_id"
                      department_fldid="department_id"
                      branch_fldid="branch_id"
                      xml_all_depo = "#xml_all_depo#"
                      branch_id="#GET_DEPARTMENT_NAME.BRANCH_ID#"
                      department_id="#user_dep_id#"
                      location_id="#GET_DEPARTMENT_NAME.LOCATION_ID#"
                      location_name="#dept_name#"
                      user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                      width="120">
                    <cfelse>
                    <cf_wrkdepartmentlocation
                      returninputvalue="location_id,department_name,department_id,branch_id"
                      returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                      fieldname="department_name"
                      fieldid="location_id"
                      xml_all_depo = "#xml_all_depo#"
                      department_fldid="department_id"
                      branch_fldid="branch_id"
                      location_name="#dept_name#"
                      user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                      width="120">
                  </cfif>
                </div>
              </div>
              <div class="form-group" id="item-project_id">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id ='57416.Proje'>
                </label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                      <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')>#attributes.project_id#</cfif>">
                      <input name="project_head" type="text" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#GET_PROJECT_NAME(attributes.project_id)#<cfelseif isdefined('get_project_info.project_head') and len(get_project_info.project_head)>#get_project_info.project_head#</cfif>" onfocus="if(check_project_changes()){AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')}" autocomplete="off">
                      <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head</cfoutput>');"></span> <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="if(document.getElementById('project_id').value!='')windowopen('<cfoutput>#request.self#?fuseaction=project.popup_list_project_actions&from_paper=INVOICE&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang dictionary_id='58797.Proje Seçiniz'></cfoutput>');"></span> 
                    </div>
                </div>
              </div>
            </div>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
              <div class="form-group" id="item-EMPO_ID">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57021.Satışı Yapan'>
                </label>
                <div class="col col-8 col-xs-12">
                  <div class="input-group">
                    <input type="hidden" name="EMPO_ID" id="EMPO_ID" value="<cfoutput>#session.ep.userid#</cfoutput>">
                    <input type="hidden" name="PARTO_ID" id="PARTO_ID">
                    <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly>
                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID&is_store_module=1&select_list=1</cfoutput>','list','popup_list_positions');"></span>
                  </div>
                </div>
              </div> 
              <div class="form-group" id="item-deliver_get_id">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57775.Teslim Alan'>
                </label>
                <div class="col col-8 col-xs-12">
                  <div class="input-group">
                    <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="">
                    <input type="hidden" name="deliver_get_id_consumer" id="deliver_get_id_consumer" value="">
                    <input type="text" name="deliver_get" id="deliver_get">
                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=form_basket.deliver_get&field_partner=form_basket.deliver_get_id&field_consumer=form_basket.deliver_get_id_consumer&come=stock&is_store_module=1&select_list=2,3,4,5,6</cfoutput>','list','popup_list_pars');"></span> 
                  </div>
                </div>
              </div>
              <div class="form-group" id="item-note">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57629.Açıklama'>
                </label>
                <div class="col col-8 col-xs-12">
                  <textarea name="note" id="note"></textarea>
                </div>
              </div>
              <div class="form-group" id="item-vocation-type">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id ='57329.Meslek Tipi'>
                </label>
                <div class="col col-8 col-xs-12">
                  <select class="vocation_type" name="vocation_type" tabindex="13">
                    <option value="">
                      <cf_get_lang dictionary_id='57734.Seçiniz'>
                    </option>
                    <cfoutput query="get_vocation_type">
                      <option value="#vocation_type_id#" <cfif vocation_type_id eq attributes.field_vocation>selected</cfif>>#vocation_type#</option>
                    </cfoutput>
                  </select>
                </div>
              </div>
              <div class="form-group" id="item-member_type">
                <label class="col col-4 col-xs-12">
                  <cf_get_lang dictionary_id='57254.Müşteri Kaydet'>
                </label>
                <div class="col col-8 col-xs-12">
                    <label>
                      <input name="member_type" id="member_type" type="radio" value="1" <cfif attributes.member_type eq 1>checked</cfif> onclick="kontrol_member_cat(1);">
                      <cf_get_lang dictionary_id='57255.Kurumsal'>
                    </label>
                    <label>
                      <input name="member_type" id="member_type" type="radio" value="2" <cfif attributes.member_type eq 2>checked</cfif> onclick="kontrol_member_cat(2);">
                      <cf_get_lang dictionary_id='57256.Bireysel'>
                    </label>
                    <label>
                      <input name="is_person" id="is_person" type="checkbox" value="1">
                      <cf_get_lang dictionary_id='53964.Şahıs'> 
                    </label>
                </div>
              </div>
            </div>
      </cf_box_elements> 
      <cf_box_footer>
        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
      </cf_box_footer>
    </cf_basket_form>
    <cfset attributes.basket_id = 18>
    <cfset attributes.form_add = 1>
    <cfset attributes.is_retail=1>
    <cfinclude template="../../objects/display/basket.cfm">
  </cfform>
</div> 
</cf_box>
</div>
<script type="text/javascript">
  $(document).ready(function(){
    phone_code_list = new Array(<cfoutput>#listdeleteduplicates(valuelist(get_city.phone_code))#</cfoutput>);
    str_cons_link="&field_member_code=form_basket.member_code&field_comp_name=form_basket.comp_name&field_address=form_basket.address&field_mobil_code=form_basket.mobil_code&field_mobil_tel=form_basket.mobil_tel&field_tel_code=form_basket.tel_code&field_tel_number=form_basket.tel_number&field_email=form_basket.email&field_vocation=form_basket.vocation_type&field_ims_code_id=form_basket.ims_code_id&field_ims_code_name=form_basket.ims_code_name";
    str_cons_link=str_cons_link+"&field_tax_office=form_basket.tax_office&field_tax_num=form_basket.tax_num&field_county=form_basket.county&field_county_id=form_basket.county_id&field_city=form_basket.city&field_country=form_basket.country&field_faxcode=form_basket.faxcode&field_fax_number=form_basket.fax_number&field_tc_no=form_basket.tc_num";
    str_cons_link=str_cons_link+"&field_member_name=form_basket.member_name&field_member_surname=form_basket.member_surname";
    str_cons_link=str_cons_link+"&field_company_id=form_basket.company_id&field_partner_id=form_basket.partner_id&field_consumer_id=form_basket.consumer_id";
    str_cons_link=str_cons_link+"&field_tc_num=form_basket.tc_num&field_ship_id=form_basket.ship_address_id";
  });
  LoadCity(225,'city','county_id',0);
  function pencere_ac(no)
  {
    if (document.form_basket.city[document.form_basket.city.selectedIndex].value == "")
    alert("<cf_get_lang dictionary_id='57257.İlk Olarak İl Seçiniz'>!");
    else
    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_basket.county_id&field_name=form_basket.county&city_id=' + document.form_basket.city.value,'small');
  }
  function kontrol_member_cat(type)
  {
    if (type == 1)
    {
      is_company.style.display = '';
      is_consumer.style.display = 'none';
      is_person_.style.display = '';
      document.getElementById('cons_member_cat').value = '';
    }
    if (type == 2)
    {
      is_company.style.display = 'none';
      is_consumer.style.display = '';
      is_person_.style.display = 'none';
      document.getElementById('comp_member_cat').value = '';
    }
  }
  function kontrol()
  {
      var get_is_no_sale=wrk_query("SELECT NO_SALE FROM STOCKS_LOCATION WHERE DEPARTMENT_ID ="+document.getElementById('department_id').value+" AND LOCATION_ID ="+document.getElementById('location_id').value,"dsn");
      if(get_is_no_sale.recordcount)
      {
          var is_sale_=get_is_no_sale.NO_SALE;
      if(is_sale_==1)
      {
      alert("<cf_get_lang dictionary_id='45400.Bu lokasyondan satış yapılamaz'>!");
          return false;
      }
    }
    if(!paper_control(form_basket.invoice_number,'INVOICE')) return false;
    if(!chk_process_cat('form_basket')) return false;
    if(!check_display_files('form_basket')) return false;
    if(!chk_period(form_basket.invoice_date,"İşlem")) return false;
    if(!check_product_accounts()) return false;
    if(form_basket.member_type[0].checked)
    {
    if((form_basket.comp_name.value=="" || form_basket.tax_office.value=="" || form_basket.tax_num.value=="" || form_basket.address.value=="") && form_basket.is_person.checked != true)
    {
      alert("<cf_get_lang dictionary_id ='57339.Kurumsal Müşteri İçin Firma, Vergi Dairesi, Vergi Numarası ve Adres Bilgilerini Giriniz'>!");
      return false;
    }
    if(form_basket.company_stage.value=="" && form_basket.company_id.value == "")
    {
    alert("<cf_get_lang dictionary_id ='57340.Kurumsal Üye Süreçlerinizi Kontrol Ediniz'>!");
      return false;
    }
    }
    else if(form_basket.member_type[1].checked)
    {
    if(form_basket.member_name.value=="" || form_basket.member_surname.value=="" || form_basket.address.value=="")
    {
    alert("<cf_get_lang dictionary_id='57258.Bireysel Müşteri İçin Ad Soyad ve Adres Bilgilerini Giriniz'>!");
      return false;
    }
    if(form_basket.consumer_stage.value=="" && form_basket.consumer_id.value == "")
    {
    alert("<cf_get_lang dictionary_id ='57341.Bireysel Üye Süreçlerinizi Kontrol Ediniz'>!");
      return false;
    }
    }
  if(form_basket.department_id.value=="")
  {
  alert("<cf_get_lang dictionary_id='57284.Depo Seçiniz'>!");
    return false;
  }
    var kalan_risk_ = 0;
    if(form_basket.member_type[0].checked)//kurumsal
    {
      var risk_info = wrk_safe_query('inv_risk_info','dsn2',0,document.getElementById('company_id').value);
    }
    else if(form_basket.member_type[1].checked)//bireysel
    {
      var risk_info = wrk_safe_query('inv_risk_info2','dsn2',0,document.getElementById('consumer_id').value);
    }
    if(risk_info != undefined && risk_info.recordcount)
    {
      risk_tutar_ = parseFloat(risk_info.TOTAL_RISK_LIMIT) - parseFloat(risk_info.BAKIYE) - (parseFloat(risk_info.CEK_ODENMEDI) + parseFloat(risk_info.SENET_ODENMEDI) + parseFloat(risk_info.CEK_KARSILIKSIZ) + parseFloat(risk_info.SENET_KARSILIKSIZ));
      kalan_risk_ = ( window.basketManager !== undefined ) ? parseFloat(risk_tutar_ - wrk_round( basketManagerObject.basketFooter.basket_net_total() )) : parseFloat(risk_tutar_ - wrk_round(form_basket.basket_net_total.value));
    }
    else
      kalan_risk_ = -1;
  
  <cfif is_control_risk eq 1>
    if (kalan_risk_ < 0){
      if( window.basketManager !== undefined ){ 
        if( wrk_round( basketManagerObject.basketFooter.total_cash_amount() ) > wrk_round( basketManagerObject.basketFooter.basket_net_total() )){
          alert("<cf_get_lang dictionary_id='57259.Tahsilat Fatura Toplamından Fazla'>");
          return false;
        }
        if(wrk_round( basketManagerObject.basketFooter.total_cash_amount() ) < wrk_round( basketManagerObject.basketFooter.basket_net_total() )){
          alert("<cf_get_lang dictionary_id ='57342.Tahsilat Fatura Toplamından Az'>!");
          return false;
        }
      }else{
        if(filterNum(form_basket.total_cash_amount.value) > wrk_round(form_basket.basket_net_total.value)){
          alert("<cf_get_lang dictionary_id='57259.Tahsilat Fatura Toplamından Fazla'>");
          return false;
        }
        if(filterNum(form_basket.total_cash_amount.value) < wrk_round(form_basket.basket_net_total.value)){
          alert("<cf_get_lang dictionary_id ='57342.Tahsilat Fatura Toplamından Az'>!");
          return false;
        }
      }
    }
  <cfelseif is_control_risk eq 2>
    if( window.basketManager !== undefined ){ 
      if(wrk_round( basketManagerObject.basketFooter.total_cash_amount() ) > wrk_round( basketManagerObject.basketFooter.basket_net_total() )){
        alert("<cf_get_lang dictionary_id='57259.Tahsilat Fatura Toplamından Fazla'>");
        return false;
        }
      if(wrk_round( basketManagerObject.basketFooter.total_cash_amount() ) < wrk_round( basketManagerObject.basketFooter.basket_net_total() )){
        alert("<cf_get_lang dictionary_id ='57342.Tahsilat Fatura Toplamından Az'>!");
        return false;
      }
    }else{ 
      if(filterNum(form_basket.total_cash_amount.value) > wrk_round(form_basket.basket_net_total.value)){
        alert("<cf_get_lang dictionary_id='57259.Tahsilat Fatura Toplamından Fazla'>");
        return false;
        }
      if(filterNum(form_basket.total_cash_amount.value) < wrk_round(form_basket.basket_net_total.value)){
        alert("<cf_get_lang dictionary_id ='57342.Tahsilat Fatura Toplamından Az'>!");
        return false;
      }
    }
  </cfif>
  if(check_stock_action('form_basket')) //islem kategorisi stock hareketi yapıyorsa
  {
    var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
      if(basket_zero_stock_status.IS_SELECTED != 1)
      {
        var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
        var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
        if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,temp_process_type.value)) return false;
      }
    }
      return (check_cash_pos() && saveForm());
      return false;
  }
  
  function check_cash_pos()
  { //kasa ve pos tutarları formatlanıyor
    //secili kasaLar
      <cfoutput query="get_money_bskt">
        if(eval(form_basket.kasa#get_money_bskt.currentrow#)!= undefined && eval(form_basket.cash_amount#get_money_bskt.currentrow#)!= undefined && eval(form_basket.cash_amount#get_money_bskt.currentrow#).value!="")
        {
      
            form_basket.cash.value=1;
          }
      </cfoutput>
    //pos tahsilatlari
    for(var a=1; a<=5; a++)
    {
      if(eval('form_basket.pos_amount_'+a)!= undefined && eval('form_basket.pos_amount_'+a).value!="")
      {
        eval('form_basket.pos_amount_'+a).value=filterNum((eval('form_basket.pos_amount_'+a).value));
        form_basket.is_pos.value=1;
      }
    }
    return true;
  }
  
  function cons_pre_records()
  {
    if(form_basket.member_name.value!="" && form_basket.member_surname.value!="")
    openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&invoice_retail=1<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&consumer_name=' + encodeURIComponent(form_basket.member_name.value) + '&consumer_surname=' + encodeURIComponent(form_basket.member_surname.value)+ '&vocation_type_id=' + form_basket.vocation_type.value  + '&tax_no=' + form_basket.tax_num.value +str_cons_link,'project');
  }
  
  function comp_pre_records()
  {
    if(form_basket.comp_name.value!="")
    openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&invoice_retail=1<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&tax_num='+ encodeURIComponent(form_basket.tax_num.value) +'&fullname='+ encodeURIComponent(form_basket.comp_name.value) +'&nickname=' + encodeURIComponent(form_basket.comp_name.value) +'&name='+''+'&surname='+''+'&tel_code='+''+'&telefon='+''+str_cons_link);
    }
    function tax_num_pre_records()
    {
    if(form_basket.tax_num.value!="")
    openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&is_from_sale=1<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&tax_num='+ encodeURIComponent(form_basket.tax_num.value) +'&fullname='+ encodeURIComponent(form_basket.comp_name.value) +'&nickname=' + encodeURIComponent(form_basket.comp_name.value) +'&name='+''+'&surname='+''+'&tel_code='+''+'&telefon='+''+str_cons_link);
  }
  $('.collapse').click(function(){
    $(this).parent().parent().find('.totalBoxBody').slideToggle();
      if($(this).find("span").hasClass("icon-minus")){
        $(this).find("span").removeClass("icon-minus").addClass("icon-pluss");
      }
      else{
        $(this).find("span").removeClass("icon-pluss").addClass("icon-minus");
      }
  });
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<!--- sayfanin en ustunde acilisi var ---> 
