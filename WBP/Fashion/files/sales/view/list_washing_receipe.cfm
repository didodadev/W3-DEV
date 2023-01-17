<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.result_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finis_date" default="">
<cfparam name="attributes.employee_name" default="">

<cfobject name="receipe" component="WBP.Fashion.files.cfc.washing_recepie">
<cfif isdefined("attributes.is_filtre")>
    <cfset query_receipes = receipe.list_recepie_head(
        attributes.employee_id
        ,attributes.station_id
        ,attributes.start_date
        ,attributes.finis_date
        ,attributes.result_id
    )>
<cfelse>
    <cfset query_receipes.recordcount = 0>
</cfif>

<cfparam name="attributes.totalrecords" default="#query_receipes.recordcount#">
<cfset attributes.start_row = ((attributes.page-1) * attributes.maxrows) + 1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form_receipes" method="post">
            <cf_box_search more="0">
                <input type="hidden" name="is_filtre" id="is_filtre" value="1">
                <div class="form-group">
                    <div class="input-group">
                        <cfinput type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
                        <cfinput type="text" name="employee_name" id="employee_name" value="#attributes.employee_name#" placeholder="Gorevli">
                        <span class="input-group-addon icon-ellipsis" title="" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&amp;field_emp_id=form_receipes.employee_id&amp;field_name=form_receipes.employee_name&amp;select_list=1');"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Yıkama Reçete Listesi',62591)#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='36382.Reçete'></th>
                    <th><cf_get_lang dictionary_id="58834.İstasyon"></th>
                    <th><cf_get_lang dictionary_id="41580.Sonuç"></th>
                    <th><cf_get_lang dictionary_id="57416.Proje"></th>
                    <th width="20"></th>
                </tr>
            </thead>
            <tbody>
                <cfif query_receipes.recordcount>
                    <cfoutput query="query_receipes">
                        <tr>
                            <td>RN-#WASHING_RECEPIE_ID#</td>
                            <td>#STATION_NAME#</td>
                            <td>#RESULT_NO#</td>
                            <td>#PROJECT_HEAD#</td>
                            <td><a href="javascript:void(0)" onclick="windowopen('#request.self#?fuseaction=#attributes.fuseaction#&event=upd&rid=#WASHING_RECEPIE_ID#', 'wide')"><i class="fa fa-pencil"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelseif isDefined("attributes.is_filtre")>
                    <tr>
                        <td colspan="6">Kayıt bulunamadı!</td>
                    </tr>
                <cfelse>
                    <tr>
                        <td colspan="6">Kayıt bulunamadı!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>