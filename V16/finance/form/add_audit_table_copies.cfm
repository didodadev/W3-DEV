<cfsavecontent variable="header"><cf_get_lang dictionary_id="60129.Audit Copy"></cfsavecontent>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id="58194.Zorunlu alan"> <cf_get_lang dictionary_id='36201.Tablo Adı'></cfsavecontent>
<cfsavecontent  variable="message2"><cf_get_lang dictionary_id="58194.Zorunlu alan"> <cf_get_lang dictionary_id='30368.ÇAlışan'></cfsavecontent>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.startrow" default='1'>
<cfparam name="attributes.maxrows" default=''>
<cfparam name="attributes.totalrecords" default=''>
<cfset adres='finance.audit_table_copies'>
<cfparam name="attributes.table_code_type" default="0">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.part_id" default="">
<cfscript>
    if(isdefined("attributes.rec_id") and len(attributes.rec_id)){
        get_record = createObject("component", "V16.account.cfc.get_financial_audits");
        get_record.dsn2 = dsn2;
        get_record.dsn_alias = dsn_alias;
        get_record = get_record.get_table_copies_fnc(table_id:attributes.rec_id);
    }
    else{
        get_record.recordcount = 0;
    }
    if(get_record.recordcount){
        name = get_record.table_name;
        table_code_type = get_record.is_ifrs;
        process_stage = get_record.process_stage;
        copy_date = get_record.arrangement_date;
        attributes.emp_id = get_record.ARRANGEMENT_EMP
    }
    else{
        name = "";
        table_code_type = "";
        process_stage = "";
        copy_date = "";
        attributes.emp_id = "";
    }
</cfscript>
<cf_catalystheader>
<cfform name="add_table_copies">
<div class="col col-12">
    <cf_box>
            <div class="row ui-add_table_copies-list ui-form-block" type="row">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                    <div class="form-group" id="item-copy_name">
                        <label><cf_get_lang dictionary_id="60130.Audit Copy Name"></label>
                        <cfinput type="text" name="copy_name" id="copy_name" value="#name#">
                        <cfif isdefined("attributes.rec_id") and len(attributes.rec_id)>
                            <cfinput type="hidden" name="rec_id" id="rec_id" value="#attributes.rec_id#">
                        </cfif>
                    </div>
                    <div class="form-group" item="item-table_code_type">
                        <label><cf_get_lang dictionary_id="35792.kaynak"></label>
                        <select name="table_code_type" id="table_code_type">
                            <option value="0" <cfif table_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='58793.Tek Düzen'></option>
                            <option value="1" <cfif table_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='58308.IFRS'></option>
                        </select>
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <cfif get_record.recordcount>
                            <cf_workcube_process is_upd="0" is_detail='1' select_value='#process_stage#'>
                        <cfelse>
                            <cf_workcube_process is_upd="0" is_detail="0">
                        </cfif>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                    <div class="form-group" id="item-copy_date">
                        <label><cf_get_lang dictionary_id="60131.Kopyalama Tarihi"></label>
                            <div class="input-group">
                                <cfsavecontent variable="message_"><cf_get_lang dictionary_id="57471.Eksik Veri"><cf_get_lang dictionary_id="60131.Kopyalama Tarihi"></cfsavecontent>
                                <cfinput type="text" name="copy_date" value="#dateformat(copy_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#message_#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="copy_date"></span>
                            </div>
                    </div>
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id="60132.Kopyalayan"></label>
                        <div class="input-group" id="item-emp_id">
                            <input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
                            <input type="text" name="EMP_PARTNER_NAMEO" id="EMP_PARTNER_NAMEO" value="<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)><cfoutput>#get_emp_info(attributes.emp_id,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('EMP_PARTNER_NAMEO','MEMBER_NAME','MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID','emp_id','','3','250');">
                            <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=add_table_copies.EMP_PARTNER_NAMEO&field_EMP_id=add_table_copies.emp_id</cfoutput>','list')"></span>
                        </div>
                    </div>
                </div>
            </div>
            <cf_box_footer>
                <div class="col col-6">
                    <cfif get_record.recordcount>
                    <cf_record_info query_name="get_record">
                    </cfif>
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons add_function="control()">
                </div>
            </cf_box_footer>
    </cf_box>
</div>
</cfform>
<script>
    function control(){
        if($("#copy_name").val() == ''){
             alert('<cfoutput>#message#</cfoutput>');
             return false;
        }
        if($("#emp_id").val()== '' && $("#EMP_PARTNER_NAMEO").val()== ''){
             alert('<cfoutput>#message2#</cfoutput>');
             return false;
        }
        return true;
    }
</script>