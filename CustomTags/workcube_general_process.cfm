<!--- 
    aut : Uğur Hamurpet
    name : workcube_general_process
    desc : This customtag changes the process stage of all documents
    date : 29/01/2020
    using : "
        <cf_workcube_general_process
            mode = "" values : form - query
            general_paper_no = ""
            action_list_id = ""
            process_stage = ""
            general_paper_notice = ""
            responsible_employee_id = ""
            action_table = ''
            action_column = ''
            action_page = ''
        >
    "
--->

<cfparam name="attributes.mode" default="form" type="string"><!--- values : form - query --->
<!--- general_paper --->
<cfparam name="attributes.total_values" default="#structNew()#" type="struct">
<cfparam name="attributes.general_paper_parent_id" default="0" type="numeric">
<cfparam name="attributes.general_paper_id" default="0" type="numeric">
<cfparam name="attributes.general_paper_no" default="" type="string">
<cfparam name="attributes.general_paper_date" default="" type="string">
<cfparam name="attributes.responsible_employee_id" default="0" type="numeric">
<cfparam name="attributes.responsible_employee_pos" default="0" type="numeric">
<cfparam name="attributes.fuseact" default="#caller.attributes.fuseaction#" type="string">
<cfparam name="attributes.action_list_id" default="" type="string">
<cfparam name="attributes.process_stage" default="0" type="numeric">
<cfparam name="attributes.general_paper_notice" default="" type="string">
<cfparam name="attributes.print_type" default="490" type="numeric">
<cfparam name="attributes.termin_date" default="" type="string">
<cfparam name="attributes.is_termin_date" default="1" type="numeric">
<cfparam name="attributes.is_detail" default="1" type="numeric">
<cfparam name="attributes.detail_type" default="1" type="numeric">
<cfparam name="attributes.is_template_payroll" default="0" type="numeric">
<!--- general_paper --->

<!--- design ---->
<cfparam name="attributes.layout_type" default="V" type="string"><!--- values : V (Vertical) - H (Horizontal) --->
<cfparam name="attributes.is_template_view" default="true" type="boolean">
<!--- design ---->

<!--- workcube_process --->
<cfparam name="attributes.old_process_line" default="0" type="numeric">
<cfparam name="attributes.old_process_stage" default="0" type="numeric">
<cfparam name="attributes.record_member" default="#session.ep.userid#" type="numeric">
<cfparam name="attributes.record_date" default="#now()#" type="string">
<cfparam name="attributes.action_table" default="" type="string">
<cfparam name="attributes.action_column" default="" type="string">
<cfparam name="attributes.action_page" default="" type="string">
<cfparam name="attributes.select_value" default="">
<cfparam name="attributes.mandate_position_code" type="numeric" default="0"><!--- Vekaleten yapılan işlemlerde vekalet edilen kişinin position_code değeri gönderilir --->
<cfparam name="attributes.warning_access_code" default="" type="string">
<cfparam name="attributes.warning_password" type="string" default="">
<!--- workcube_process --->

<cfset dsn = caller.dsn>
<cfset dsn3 = caller.dsn3>

<cf_papers paper_type="system_paper">

<cfif isdefined("attributes.general_paper_date") and len(attributes.general_paper_date)> <cf_date tarih="attributes.general_paper_date"> </cfif>
<cfif isdefined("attributes.termin_date") and len(attributes.termin_date)> <cf_date tarih="attributes.termin_date"> </cfif>
<cfset workcubeGeneralProcess = createObject("component","CustomTags.cfc.workcube_general_process")>
<cfif attributes.mode eq 'form'>

    <cfset getGeneralPaper = workcubeGeneralProcess.select( gp_id : (attributes.general_paper_id neq 0) ? attributes.general_paper_id : -1 )>
    
    <cfif attributes.is_template_view>
        <cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
        <cfset getTemplate = getPrintTemplate.GET( print_type : attributes.print_type )>
    </cfif>

    <cfif attributes.layout_type eq 'V'>
        <div class="form-group" id="item-general_paper_stage">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
            <div class="col col-8 col-xs-12">
                <cf_workcube_process is_upd='0' process_cat_width='120' is_detail='1' caller='#caller#' select_value='#(len(getGeneralPaper.STAGE_ID)) ? getGeneralPaper.STAGE_ID : (len(attributes.select_value) ? attributes.select_value : "" )#'>
            </div>
        </div>
        <div class="form-group" id="item-general_paper_no">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57880.Belge No"></label>
            <div class="col col-8 col-xs-12">
                <cfinput type="text" name="general_paper_no" id="general_paper_no" value="#(len(getGeneralPaper.GENERAL_PAPER_NO)) ? getGeneralPaper.GENERAL_PAPER_NO : paper_full#">
            </div>
        </div>
        <div class="form-group" id="item-general_paper_date">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33203.Belge Tarihi"></label>
            <div class="col col-8 col-xs-12">
                <div class="input-group"> 
                    <cfinput type="text" name="general_paper_date" id="general_paper_date" value="#dateformat((getGeneralPaper.recordcount) ? getGeneralPaper.GENERAL_PAPER_DATE : now(),caller.dateformat_style)#" validate="#caller.validate_style#" required="yes" readonly maxlength="10" style="width:120px;">
                    <span class="input-group-addon btnPointer">
                        <cf_wrk_date_image date_field="general_paper_date">
                    </span>
                </div>
            </div>
        </div>
        <cfif attributes.is_termin_date eq 1>
            <div class="form-group" id="item-termin_date">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60609.Termin Tarihi'></label>
                <div class="col col-8 col-xs-12">        
                    <div class="input-group">
                        <cfinput name="termin_date" id="termin_date" validate="#caller.validate_style#" maxlength="10" type="text" value="#dateformat((getGeneralPaper.recordcount) ? getGeneralPaper.TERMINATE_DATE : now(),caller.dateformat_style)#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="termin_date"></span>                           
                    </div> 
                </div>
            </div>
        </cfif>
        <div class="form-group" id="item-responsible_employee_id">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57578.Yetkili"></label>
            <div class="col col-8 col-xs-12">
                <div class="input-group">
                    <cfinput type="hidden" name="responsible_employee_pos" id="responsible_employee_pos" value="#len(getGeneralPaper.RESPONSIBLE_EMP_POS) ? getGeneralPaper.RESPONSIBLE_EMP_POS : session.ep.POSITION_CODE#">
                    <cfinput type="hidden" name="responsible_employee_id" id="responsible_employee_id" value="#len(getGeneralPaper.RESPONSIBLE_EMP) ? getGeneralPaper.RESPONSIBLE_EMP : session.ep.USERID#"/>
                    <cfinput type="text" name="responsible_employee" id="responsible_employee" value="#(len(getGeneralPaper.RESPONSIBLE_EMP_NAME) ? getGeneralPaper.RESPONSIBLE_EMP_NAME : "#session.ep.name# #session.ep.surname#")#" onFocus="AutoComplete_Create('responsible_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,POSITION_CODE','responsible_employee_id,responsible_employee_pos','','3','135');" />
                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&field_emp_id=responsible_employee_id&field_name=responsible_employee&field_code=responsible_employee_pos&select_list=1,9');"></span>
                </div>
            </div>
        </div>
        <cfif attributes.is_template_view>
            <div class="form-group" id="item-general_paper_tempate">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58640.Şablon" ></label>
                <div class="col col-8 col-xs-12">
                    <select name="general_paper_tempate" id="general_paper_tempate">
                        <option value=""><cf_get_lang dictionary_id='34185.Şablon Seçiniz'></option>
                        <cfif getTemplate.recordcount>
                            <cfoutput query="getTemplate">
                                <option <cfif IS_XML eq 1>style="color:0000FF"</cfif> value="#form_id#" <cfif IS_DEFAULT eq 1>selected</cfif> >#print_name#</option> 
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
            </div>
        </cfif>
        <cfif attributes.is_detail eq 1>
        <cfsavecontent variable="header"><cf_get_lang dictionary_id='55330.Ek Açıklamalar'></cfsavecontent>
            <cf_seperator id="more_detail" header="#header#">
            <div class="form-group" id="item-general_paper_notice">
                <div class="col col-12" id="more_detail">
                    <textarea name="general_paper_notice" id="general_paper_notice"><cfoutput>#getGeneralPaper.GENERAL_PAPER_NOTICE#</cfoutput></textarea>
                </div>
            </div>
        </cfif>
    <cfelse>
        <div class="">
            <div class="form-group col col-2 margin-right-0">
                <label class="col col-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                <div class="col col-12">
                    <cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0' caller='#caller#' select_value='#(len(getGeneralPaper.STAGE_ID)) ? getGeneralPaper.STAGE_ID : ""#'>
                </div>
            </div>
            <div class="form-group col <cfif attributes.is_template_view>col-2<cfelse>col-3</cfif> margin-right-0" id="item-general_paper_no">
                <label class="col col-12"><cf_get_lang dictionary_id="57880.Belge No"></label>
                <div class="col col-12">
                    <cfinput type="text" name="general_paper_no" id="general_paper_no" value="#(len(getGeneralPaper.GENERAL_PAPER_NO)) ? getGeneralPaper.GENERAL_PAPER_NO : paper_full#">
                </div>
            </div>
            <div class="form-group col <cfif attributes.is_template_view>col-2<cfelse>col-3</cfif> margin-right-0" id="item-general_paper_date">
                <label class="col col-12"><cf_get_lang dictionary_id="33203.Belge Tarihi"></label>
                <div class="col col-12">
                    <div class="input-group">
                        <cfinput type="text" name="general_paper_date" id="general_paper_date" value="#dateformat((getGeneralPaper.recordcount) ? getGeneralPaper.GENERAL_PAPER_DATE : now(),caller.dateformat_style)#" validate="#caller.validate_style#" required="yes" readonly maxlength="10" style="width:120px;">
                        <span class="input-group-addon btnPointer">
                            <cf_wrk_date_image date_field="general_paper_date">
                        </span>
                    </div>
                </div>
            </div>
            <cfif attributes.is_termin_date eq 1>
                <div class="form-group col <cfif attributes.is_template_view>col-2<cfelse>col-3</cfif> margin-right-0" id="item-termin_date">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60609.Termin Tarihi'></label>
                    <div class="col col-12 col-xs-12">        
                        <div class="input-group">
                            <cfinput name="termin_date" id="termin_date" validate="#caller.validate_style#" maxlength="10" type="text" value="#dateformat((getGeneralPaper.recordcount) ? getGeneralPaper.TERMINATE_DATE : now(),caller.dateformat_style)#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="termin_date"></span>                           
                        </div> 
                    </div>
                </div>
            </cfif>
            <div class="form-group col <cfif attributes.is_template_view>col-2<cfelse>col-3</cfif> margin-right-0" id="item-responsible_employee_id">
                <label class="col col-12"><cf_get_lang dictionary_id="57578.Yetkili"></label>
                <div class="col col-12">
                    <div class="input-group">
                        <cfinput type="hidden" name="responsible_employee_pos" id="responsible_employee_pos" value="#getGeneralPaper.RESPONSIBLE_EMP_POS#">
                        <cfinput type="hidden" name="responsible_employee_id" id="responsible_employee_id" value="#getGeneralPaper.RESPONSIBLE_EMP#"/>
                        <cfinput type="text" name="responsible_employee" id="responsible_employee" value="#getGeneralPaper.RESPONSIBLE_EMP_NAME#" onFocus="AutoComplete_Create('responsible_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,POSITION_CODE','responsible_employee_id,responsible_employee_pos','','3','135');" />
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&field_emp_id=responsible_employee_id&field_name=responsible_employee&field_code=responsible_employee_pos&select_list=1,9');"></span>
                    </div>
                </div>
            </div>
            <cfif attributes.is_template_view and attributes.is_template_payroll neq 1>
                <div class="form-group col col-2 margin-right-0" id="item-general_paper_tempate">
                    <label class="col col-12"><cf_get_lang dictionary_id="58640.Şablon"></label>
                    <div class="col col-12">
                        <select name="general_paper_tempate" id="general_paper_tempate">
                            <option value=""><cf_get_lang dictionary_id='34185.Şablon Seçiniz'></option>
                            <cfif getTemplate.recordcount>
                                <cfoutput query="getTemplate">
                                    <option <cfif IS_XML eq 1>style="color:0000FF"</cfif> value="#form_id#" <cfif IS_DEFAULT eq 1>selected</cfif> >#print_name#</option> 
                                </cfoutput>
                            </cfif>
                        </select>
                    </div>
                </div>
            </cfif>
            <cfif attributes.is_detail eq 1 and attributes.detail_type eq 1>
                <div class="form-group col col-12" id="item-general_paper_notice">
                    <cfsavecontent variable="header"><cf_get_lang dictionary_id='55330.Ek Açıklamalar'></cfsavecontent>
                    <cf_seperator id="more_detail" header="#header#">
                    <div id="more_detail">
                        <div class="col col-12 col-xs-12">
                            <textarea name="general_paper_notice" id="general_paper_notice"><cfoutput>#getGeneralPaper.GENERAL_PAPER_NOTICE#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
            <cfelseif attributes.is_detail eq 1 and attributes.detail_type eq 2>
                <div class="form-group col col-2" id="item-general_paper_notice">
                    <label class="col col-12"><cf_get_lang dictionary_id='55330.Ek Açıklamalar'></label>
                    <div class="col col-12 col-xs-12">
                        <textarea name="general_paper_notice" id="general_paper_notice"><cfoutput>#getGeneralPaper.GENERAL_PAPER_NOTICE#</cfoutput></textarea>
                    </div>
                </div>
            </cfif>
        </div>
    </cfif>

    <cfif getGeneralPaper.recordcount and attributes.general_paper_id neq 0 and len( getGeneralPaper.TOTAL_VALUES )>

        <cfinput type="hidden" name="general_paper_parent_id" id="general_paper_parent_id" value="#(len(getGeneralPaper.GENERAL_PAPER_PARENT_ID)) ? getGeneralPaper.GENERAL_PAPER_PARENT_ID : attributes.general_paper_id#">

        <script>
            var totalValues = <cfoutput>#getGeneralPaper.TOTAL_VALUES#</cfoutput>;
            var totalValueArray = [];
            for(var i in totalValues) totalValueArray.push([i, totalValues[i]]);
            totalValueArray.forEach(element => {$("#"+ element[0].toLowerCase() +"").val(element[1]);});
        </script>
        
    </cfif>

<cfelse>

    <cfset getWorkcubeProcess = createObject("component","Customtags.cfc.get_workcube_process")>
    <cfset getActionInfo = createObject("component","cfc.getActionInfo")>

    <cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0>

        <!--- insert general paper --->
        <cfset generalPaperResult = workcubeGeneralProcess.insert(
            generalPaperParentId : "#attributes.general_paper_parent_id#",
            generalPaperNo : "#attributes.general_paper_no#",
            generalPaperDate : "#attributes.general_paper_date#",
            fuseaction : "#attributes.fuseact#",
            actionListId : "#attributes.action_list_id#",
            process_stage : "#attributes.process_stage#",
            generalPaperNotice : "#attributes.general_paper_notice#",
            totalValues : attributes.total_values,
            responsibleEmp : attributes.responsible_employee_id,
            responsibleEmpPos : attributes.responsible_employee_pos,
            termindate : "#attributes.termin_date#"
        )>
        <!--- insert general paper --->
        <cfif generalPaperResult.status>

            <!--- changes process stage of document ---->
            <cfset actionInfo = getActionInfo.get(action_table:attributes.action_table)>
            
            <cfloop index="item" list="#attributes.action_list_id#">

                <cfset getWorkcubeProcess.changeAction(
                    process_db: "#actionInfo.action_db#.",
                    data_source: dsn,
                    actionTable: UCase(attributes.action_table),
                    actionStageColumn: UCase(actionInfo.action_stage_column),
                    actionStageColumn1: isdefined("actionInfo.action_stage_column1") ? UCase(actionInfo.action_stage_column1) : "",
                    actionIdColumn: UCase(attributes.action_column),
                    actionId: item,
                    process_stage: attributes.process_stage,
                    termin_date : '#attributes.termin_date#'
                )/>
            
            </cfloop>
            <!--- changes process stage of document ---->

            <cf_workcube_process
                is_upd='1' 
                data_source='#actionInfo.action_db#'
                old_process_line='#attributes.old_process_line#'
                old_process_stage='#attributes.old_process_stage#'
                process_stage='#attributes.process_stage#'
                record_member='#attributes.record_member#'
                record_date='#attributes.record_date#'
                action_table='#attributes.action_table#'
                action_column='#attributes.action_column#'
                action_page='#attributes.action_page#'
                warning_description='#attributes.general_paper_notice#'
                general_paper_id='#generalPaperResult.result.IDENTITYCOL#'
                caller='#caller#'
                position_code='#( attributes.responsible_employee_pos neq 0 ) ? attributes.responsible_employee_pos : 0#'
                mandate_position_code='#attributes.mandate_position_code#'
                warning_access_code='#attributes.warning_access_code#'
                warning_password='#attributes.warning_password#'
            >

        </cfif>

    </cfif>

</cfif>