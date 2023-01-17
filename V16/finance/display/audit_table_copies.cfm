<cfsavecontent variable="header"><cf_get_lang dictionary_id="60129.Audit Copy"></cfsavecontent>
<cfparam name="attributes.table_code_type" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.copy_name" default="">
<cfparam name="attributes.process_stage" default="">
<cfif isdefined("attributes.copy_date") and isdate(attributes.copy_date)>
	<cf_date tarih = "attributes.copy_date">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	get_defs = createObject("component", "V16.account.cfc.get_financial_audits");
	get_defs.dsn2 = dsn2;
	get_defs.dsn_alias = dsn_alias;
	get_list = get_defs.get_table_copies_list_fnc(
        keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
        copy_name : '#iif(isdefined("attributes.copy_name"),"attributes.copy_name",DE(""))#',
        table_code_type : '#iif(isdefined("attributes.table_code_type"),"attributes.table_code_type",DE(""))#',
        copy_date : '#iif(isdefined("attributes.copy_date"),"attributes.copy_date",DE(""))#',
        emp_id : '#iif(isdefined("attributes.emp_id"),"attributes.emp_id",DE(""))#',
        PROCESS_STAGE : '#iif(isdefined("attributes.PROCESS_STAGE"),"attributes.PROCESS_STAGE",DE(""))#',
        startrow : '#IIf(len(attributes.startrow) and len("attributes.startrow"),"attributes.startrow",DE(""))#',
        maxrows :  '#IIf(len(attributes.maxrows) and len("attributes.maxrows"),"attributes.maxrows",DE(""))#'
	);
</cfscript>
<cfif get_list.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_list.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<div class="col col-12">
    <cf_box title="#header#">
        <cfform name="form_search" method="post" action="#request.self#?fuseaction=finance.audit_table_copies">
            <input name="is_submitted" id="is_submitted" type="hidden" value="1">
            <div class="row ui-form-list flex-list" type="row">
                <div class="form-group">
                    <input type="text" name="copy_name" id="copy_name" value="<cfoutput>#attributes.copy_name#</cfoutput>" placeholder="<cf_get_lang dictionary_id='60130.Audit Copy Name'>">
                </div>
                <div class="form-group">
                    <select name="table_code_type" id="table_code_type">
                        <option value=""><cf_get_lang dictionary_id="35792.kaynak"></option>
                        <option value="0" <cfif attributes.table_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='58793.Tek Düzen'></option>
                        <option value="1" <cfif attributes.table_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='58308.IFRS'></option>
                    </select>
                </div>
                <div class="form-group">
                    <cf_workcube_process is_upd='0' select_value='#attributes.process_stage#' is_select_text='1' process_cat_width='150' is_detail='0'>
                </div>
                <div class="form-group">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"><cf_get_lang dictionary_id="60131.Kopyalama Tarihi"></cfsavecontent>
                            <input value="" type="text" name="copy_date" id="copy_date" placeholder="<cf_get_lang dictionary_id='60131.Kopyalama Tarihi'>">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="copy_date"></span>
                        </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
                        <input type="text" name="EMP_PARTNER_NAMEO" id="EMP_PARTNER_NAMEO" value="<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)><cfoutput>#get_emp_info(attributes.emp_id,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('EMP_PARTNER_NAMEO','MEMBER_NAME','MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID','emp_id','','3','250');"placeholder="<cf_get_lang dictionary_id='60132.Kopyalayan'>">
                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form.EMP_PARTNER_NAMEO&field_partner=form.part_id&field_EMP_id=form.emp_id</cfoutput>','list')"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#">
                </div> 
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.audit_table_copies&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                </div>
            </div>
        </cfform>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id="60130.Audit Copy Name"></th>
                        <th><cf_get_lang dictionary_id="35792.kaynak"></th>
                        <th><cf_get_lang dictionary_id="58859.Süreç"></th>
                        <th><cf_get_lang dictionary_id="60131.Kopyalama Tarihi"></th>
                        <th><cf_get_lang dictionary_id="60132.Kopyalayan"></th>
                        <th></th>
                    </tr>
                </thead>
                <cfif get_list.recordcount>
                    <tbody>
                        <cfoutput query="get_list">
                        <tr>
                            <td>#table_name#</td>
                            <td><cfif is_ifrs eq 1><cf_get_lang dictionary_id ='58308.IFRS'><cfelse><cf_get_lang dictionary_id ='58793.Tek Düzen'></cfif></td>
                            <td>#STAGE#</td>
                            <td>#dateformat(arrangement_date,dateformat_style)#</td>
                            <td>#get_emp_info(arrangement_emp,0,0)#</td>
                            <td><a href="#request.self#?fuseaction=finance.audit_table_copies&event=upd&rec_id=#financial_table_id#"><i class="fa fa-pencil"></i></a></td>
                        </tr> 
                    </cfoutput>
                    </tbody>
                </cfif>
            <cfset adres='finance.audit_table_copies'>
            <cfif isDefined('attributes.emp_id') and len(attributes.emp_id) and isdefined("attributes.EMP_PARTNER_NAMEO") and len(attributes.EMP_PARTNER_NAMEO)>
                <cfset adres = "#adres#&emp_id=#attributes.emp_id#">
            </cfif>
            <cfif isDefined('attributes.copy_name') and len(attributes.copy_name)>
                <cfset adres = "#adres#&copy_name=#attributes.copy_name#">
            </cfif>
            <cfif isDefined('attributes.PROCESS_STAGE') and len(attributes.PROCESS_STAGE)>
                <cfset adres = "#adres#&PROCESS_STAGE=#attributes.PROCESS_STAGE#">
            </cfif>
            <cfif isDefined('attributes.table_code_type') and len(attributes.table_code_type)>
                <cfset adres = "#adres#&table_code_type=#attributes.table_code_type#">
            </cfif>
            <cfif isDefined('attributes.copy_date') and len(attributes.copy_date)>
                <cfset adres = "#adres#&copy_date=#dateformat(attributes.copy_date,dateformat_style)#">
            </cfif>
            </cf_grid_list>
             <cf_paging 
                    page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#">
    </cf_box>
</div>