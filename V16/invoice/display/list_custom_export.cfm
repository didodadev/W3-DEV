<!---
File: list_custom_export.cfm
Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
Date: 2002/02/20
Controller: CustomExportController.cfm
Description: Dış Ticaret > İhracat İşlemleri list sayfası.
--->
<cfparam name="attributes.keyword" default="" />
<cfparam name="attributes.decleration_date" default="" />
<cfparam name="attributes.beyan" default="" />
<cfparam name="attributes.decleration_no" default="" />
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.iid" default="">
<cfparam name="attributes.customs_company_id" default="">
<cfparam name="attributes.customs_consumer_id" default="">
<cfparam name="attributes.customs_partner_id" default="">
<cfparam name="attributes.customs_comp_name" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif isdefined("attributes.decleration_date") and isdate(attributes.decleration_date)>
    <cf_date tarih = "attributes.decleration_date">
</cfif>
<cfif isdefined("attributes.form_varmi")>
    <cfscript>
        getComponent = createObject("component", "V16.invoice.cfc.custom_export");
        get_decleration_list = getComponent.GET_DECLERATION
            (
                decleration_no : '#IIf(IsDefined("attributes.decleration_no"),"attributes.decleration_no",DE(""))#',
                keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                decleration_date : '#IIf(IsDefined("attributes.decleration_date"),"attributes.decleration_date",DE(""))#',
                beyan : '#IIf(IsDefined("attributes.beyan"),"attributes.beyan",DE(""))#',
                startrow :'#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                maxrows :'#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
                custom_brokers_id ='#iif(isdefined("attributes.customs_partner_id"),"attributes.customs_partner_id",DE(""))#' 
            );
    </cfscript>
    <cfif get_decleration_list.recordcount>
		<cfparam name="attributes.totalrecords" default="#get_decleration_list.recordcount#">
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">
	</cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="47126.İhracat İşlemleri"></cfsavecontent>
    <cf_box id="list_health_expense_search" closable="0" collapsable="0">
        <cf_big_list_search_area>
            <cfform name="list_custom" method="post" action="#request.self#?fuseaction=invoice.list_bill_FTexport">
                <input name="form_varmi" id="form_varmi" value="1" type="hidden">
                <div class="row form-inline">
                    <div class="form-group large">
                        <div class="input-group">  
                            <input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>"  value="<cfoutput>#attributes.keyword#</cfoutput>" />
                        </div>
                    </div>
                    <div class="form-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='47991.Beyan'></cfsavecontent>
                        <cfinput type="text" name="beyan" value="#attributes.beyan#" placeholder="#message#">
                    </div>
                    <div class="form-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57487.No"></cfsavecontent>
                        <cfinput type="text" name="decleration_no" value="#attributes.decleration_no#" placeholder="#message#">
                    </div>
                    <div class="form-group">
                        <cfsavecontent variable="message_"><cf_get_lang dictionary_id='60345.Gümrük Musaviri'></cfsavecontent>
                        <div class="input-group">
                            <cfoutput>
                                <input type="hidden" name="customs_company_id" id="customs_company_id" <cfif len(attributes.customs_comp_name)> value="<cfoutput>#attributes.customs_company_id#</cfoutput>"</cfif>>
                                <input type="hidden" name="customs_partner_id" id="customs_partner_id" <cfif len(attributes.customs_comp_name)> value="<cfoutput>#attributes.customs_partner_id#</cfoutput>"</cfif>>
                                <input type="hidden" name="customs_consumer_id" id="customs_consumer_id" <cfif len(attributes.customs_comp_name)> value="<cfoutput>#attributes.customs_consumer_id#</cfoutput>"</cfif>>
                                <input type="text" name="customs_comp_name" id="customs_comp_name" placeholder="#message_#" <cfif len(attributes.customs_comp_name)> value="<cfoutput>#attributes.customs_comp_name#</cfoutput>"</cfif> onfocus="AutoComplete_Create('customs_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','customs_company_id,customs_comp_name,customs_partner_id,sup_partner_name','','3','170');">
                            </cfoutput>
                            <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_partner=list_custom.customs_partner_id&field_comp_name=list_custom.customs_comp_name&field_comp_id=list_custom.customs_company_id&field_consumer=list_custom.customs_consumer_id&select_list=2','list','popup_list_pars');"></span>
                        </div>
                    </div>
                    <div class="form-group">
                       <cfsavecontent variable="message_1"><cf_get_lang dictionary_id='60344.Beyan Tarihi'></cfsavecontent>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih giriniz'></cfsavecontent>
                                <cfinput type="text" name="decleration_date" value="#dateformat(attributes.decleration_date,dateformat_style)#" placeholder="#message_1#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="decleration_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group x-4_5">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </div>
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button>
                    </div>
                </div>
            </cfform>
        </cf_big_list_search_area>
    </cf_box>
    <cf_box id="list_health_expense_list" closable="0" collapsable="1" title="#title#" hide_table_column="1" uidrop="1"> 
        <cf_flat_list>
            <thead>
                <tr>
                    <th class="drag-enable" width="50"><cf_get_lang dictionary_id="58577.Sıra"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                    <th class="drag-enable" width="50"><cf_get_lang dictionary_id='60307.Beyanname No'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                    <th class="drag-enable" width="50"><cf_get_lang dictionary_id='58133.Fatura No'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                    <th><cf_get_lang dictionary_id='57519.cari hesap'></th>
                    <th class="drag-enable" width="50"><cf_get_lang dictionary_id='47991.Beyan'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                    <th class="drag-enable" width="50"><cf_get_lang dictionary_id='60344.Beyan Tarihi'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                </tr>
            </thead>
            <cfif isdefined("attributes.form_varmi") and get_decleration_list.recordcount>
                <tbody>
                    <cfoutput query="get_decleration_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>
                                <a href="index.cfm?fuseaction=invoice.list_bill_FTexport&event=det&export_id=#get_decleration_list.CUSTOM_DECLERATION_ID#&export_invoice_id=#get_decleration_list.invoice_id#" class="tableyazi">#DECLERATION_NO#</a>
                            </td>
                            <cfscript>
                                get_bill_action = createObject("component", "V16.invoice.cfc.get_bill");
                                get_bill_action.dsn2 = dsn2;
                                get_bill_action.dsn_alias = dsn_alias;
                                get_bill_action.dsn3_alias = dsn3_alias;
                                get_bill = get_bill_action.get_bill_fnc
                                    (
                                    listing_type : 2,
                                    invoice_id : '#get_decleration_list.invoice_id#',
                                    startrow:'#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                                    maxrows: '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
                                    );
                            </cfscript>
                            <td>
                                <a href="index.cfm?fuseaction=invoice.form_add_bill&iid=#get_decleration_list.invoice_id#&event=upd" class="tableyazi">#get_bill.invoice_number#</a>
                            </td>
                            <td width="200">
                                <cfif len(get_bill.company_id)>
                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_bill.company_id#','medium');">#get_bill.fullname#</a>
                                <cfelseif len(get_bill.con_id)>
                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_bill.con_id#','medium');">#get_bill.consumer_name# #get_bill.consumer_surname#</a>
                                <cfelse>
                                    #get_emp_info(get_bill.employee_id,0,1)#
                                </cfif>
                            </td>
                            <td>#DECLARATION#</td>
                            <td>#DECLERATION_DATE#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cfif>          
        </cf_flat_list>
        <cfif attributes.totalrecords gt attributes.maxrows>    
        <cfset adres="invoice.list_bill_FTexport">
        <cfif isdefined("attributes.form_varmi") and len(attributes.form_varmi)> 
			<cfset adres = "#adres#&form_varmi=1">
		</cfif>
        <cfif len(attributes.keyword)>
            <cfset adres = "#adres#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.decleration_no)>
            <cfset adres = "#adres#&decleration_no=#attributes.decleration_no#">
        </cfif>
        <cfif isDefined('attributes.beyan') and len(attributes.beyan)>
            <cfset adres = "#adres#&beyan=#attributes.beyan#">
        </cfif>
        <cfif isdate(attributes.decleration_date)>
            <cfset adres = "#adres#&decleration_date=#dateformat(attributes.decleration_date,dateformat_style)#">
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#">
</cfif>
    </cf_box>