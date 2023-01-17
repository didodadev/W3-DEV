<cfparam name="attributes.date1" default="01/01/#year(now())#">
<cfparam name="attributes.date2" default="31/12/#year(now())#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="cari" action="#request.self#?fuseaction=ehesap.personel_extre" method="post">
            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57576.Çalışan"></cfsavecontent>
                        <input type="text"  name="employee_name" id="employee_name" value="<cfif isDefined("attributes.employee_name") and len(attributes.employee_id) and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" placeholder="<cfoutput>#message#</cfoutput>" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'0\'','EMPLOYEE_ID','employee_id','','3','225');"style="width:150px;">
                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=cari.employee_id&field_name=cari.employee_name&select_list=1,9','list');return false"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç girmelisiniz'></cfsavecontent>
                        <cfinput value="#attributes.date1#" required="Yes" message="#message#" type="text" name="date1" style="width:65px;" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
                        <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!</cfsavecontent>
                        <cfinput value="#attributes.date2#" required="Yes" message="#message#" type="text" name="date2" style="width:65px;" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="date_check(cari.date1,cari.date2,'#message_date#')">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="52974.Çalışan Ekstresi"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cfif isdefined("attributes.is_submitted") and len(attributes.employee_id) and len(attributes.employee_name)>
            <cfinclude template="personel_extre_list.cfm">
        </cfif>
    </cf_box>
</div>
