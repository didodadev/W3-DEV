<cfquery name="get_group" datasource="#dsn#">
    SELECT
        *
    FROM
        TRAINING_CLASS_GROUPS TCG
    WHERE
        TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
</cfquery>
<cfset getEmp = CreateObject("component","V16.hr.cfc.get_employee")>
<cfset empInformations = getEmp.get_employee(emp_id:get_group.record_emp)>

<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.modal_id" default="">
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'training_management.list_training_groups')>
<cfif isdefined("attributes.paper_submit") and len(attributes.paper_submit) and attributes.paper_submit eq 1>
    <cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0>
		<cfset totalValues = structNew()>
		<cfset totalValues = {
				total_offtime : 0
			}>
        <cfif IsDefined('attributes.comp_id') and len(attributes.comp_id)>
            <cfset url_str="#url_str#&comp_id=#attributes.comp_id#">
        </cfif>
		<cfset action_list_id = replace(attributes.action_list_id,";",",","all")>
		<cf_workcube_general_process
			mode = "query"
			general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
			general_paper_no = "#attributes.general_paper_no#"
			general_paper_date = "#attributes.general_paper_date#"
			action_list_id = "#action_list_id#"
			process_stage = "#attributes.process_stage#"
			general_paper_notice = "#attributes.general_paper_notice#"
			responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
			responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
			action_table = 'TRAINING_GROUP_ATTENDERS'
			action_column = 'TRAINING_GROUP_ATTENDERS_ID'
			action_page = '#request.self#?fuseaction=training_management.popup_del_att_from_class'
			total_values = '#totalValues#'
		>
		<cfset attributes.approve_submit = 0>
	</cfif>
</cfif>
<cfsavecontent variable="message">
    <cfif attributes.reqType eq 3>
        <cfoutput>#getLang('','Sınıftan Çıkar',62452)#:&nbsp;#get_group.group_head#</cfoutput>
    <cfelseif attributes.reqType eq 2>
        <cf_get_lang dictionary_id='65249.Bekleme Listesine Al'>
    <cfelseif attributes.reqType eq 1>
        <cf_get_lang dictionary_id='41402.Kesin Kayıt'>
    </cfif>
</cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="del_att" id="del_att" method="post" onsubmit="return false">
        <cfinput type="hidden" name="train_group_id" id="train_group_id" value="#attributes.train_group_id#">
        <cfinput type="hidden" name="attenders_emp_id" id="attenders_emp_id" value="#attributes.attenders_emp_id#">
        <cfinput type="hidden" name="attenders_par_id" id="attenders_par_id" value="#attributes.attenders_par_id#">
        <cfinput type="hidden" name="attenders_con_id" id="attenders_con_id" value="#attributes.attenders_con_id#">
        <cfinput type="hidden" name="training_group_attenders_id" id="training_group_attenders_id" value="#attributes.training_group_attenders_id#">
        <cf_box_elements>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='30937.Gerekçe'>*</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfinput type="text" name="reason" id="reason">
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='58586.İşlem Yapan'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="input-group">
                        <cfinput type="hidden" name="deleted_by_emp_id" id="deleted_by_emp_id"  value="#session.ep.userid#">
                        <cfinput type="text" name="deleted_by_emp_name" id="deleted_by_emp_name" value="#session.ep.name# #session.ep.surname#" style="width:110px;" readonly>
                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=del_att.deleted_by_emp_id&field_name=del_att.deleted_by_emp_name&select_list=1','list','popup_list_positions');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='58859.Süreç'>/<cf_get_lang dictionary_id='57482.Aşama'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cf_workcube_process is_upd='0' is_detail='0' select_value="#get_group.process_stage#">
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='30631.Tarih'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" name="deleted_date" id="deleted_date" value="#dateformat(now(),'dd/mm/yyyy')#">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='57475.Mail Gönder'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <input type="checkbox" name="send_mail" id="send_mail" value="1">
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfinput type="text" name="record_emp_name" id="record_emp_name" value="#empInformations.employee_name# #empInformations.employee_surname#" readonly>
                </div>
            </div>
        </cf_box_elements>
        <cf_workcube_buttons is_upd="0" add_function="kontrol(#attributes.reqType#)">
    </cfform>
</cf_box>
<script>
    function kontrol(reqType){
        var attenderEmpList = "<cfoutput>#attributes.attenders_emp_id#</cfoutput>".split(",");
        var attenderparList = "<cfoutput>#attributes.attenders_par_id#</cfoutput>".split(",");
        var attenderConList = "<cfoutput>#attributes.attenders_con_id#</cfoutput>".split(",");
        
        if(document.getElementById("reason").value == ''){
            alert("<cfoutput>#getLang('','Boş alan bırakmayın',52097)#: #getLang('','Gerekçe',30937)#</cfoutput>");
            return false;
        }

        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.emptypopup_del_att_from_class&reqType='+reqType+'&attenders_emp_id=<cfoutput>#attributes.attenders_emp_id#</cfoutput>&attenders_par_id=<cfoutput>#attributes.attenders_par_id#</cfoutput>&attenders_con_id=<cfoutput>#attributes.attenders_con_id#</cfoutput>&train_group_id=<cfoutput>#attributes.train_group_id#</cfoutput>&training_group_attenders_id=<cfoutput>#attributes.training_group_attenders_id#</cfoutput>&reason='+document.del_att.reason.value+'&deleted_by_emp_id='+document.del_att.deleted_by_emp_id.value+'&deleted_date='+document.del_att.deleted_date.value);

        /* Gerekçe mail gönderiliyor. mail_for=3 -> Listeden çıkarıldınız maili. */
        if( $( '#send_mail' ).is( ':checked' ) ){
            if( attenderEmpList.length )
            {
                attenderEmpList.forEach( function(e){
                    $.ajax({
                        url: "/V16/training_management/cfc/training_groups.cfc?method=send_mail_for_requests&user_id="+e+"&reason="+document.getElementById('reason').value+"&group_head=<cfoutput>#get_group.group_head#</cfoutput>&mail_for="+reqType
                    });
                });
            }
            if( attenderparList.length )
            {
                attenderparList.forEach( function(e){
                    $.ajax({
                        url: "/V16/training_management/cfc/training_groups.cfc?method=send_mail_for_requests&user_id="+e+"&reason="+document.getElementById('reason').value+"&group_head=<cfoutput>#get_group.group_head#</cfoutput>&mail_for="+reqType
                    });
                });
            }
            if( attenderConList.length )
            {
                attenderConList.forEach( function(e){
                    $.ajax({
                        url: "/V16/training_management/cfc/training_groups.cfc?method=send_mail_for_requests&user_id="+e+"&reason="+document.getElementById('reason').value+"&group_head=<cfoutput>#get_group.group_head#</cfoutput>&mail_for="+reqType
                    });
                });
            }
        };

        <cfif not isdefined("attributes.draggable")>
            window.opener.$( '#attenders .catalyst-refresh' ).click();
            window.close();
        <cfelseif isdefined("attributes.draggable")>
            $( '#attenders .catalyst-refresh' ).click();
            closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
        </cfif>
    }

    function setWaitListForAttender(){

    }
</script>