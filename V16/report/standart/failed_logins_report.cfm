<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.start_date" default="">


<cfsavecontent variable = "title_box">
    <cf_get_lang dictionary_id='63744.Hatalı Girişler'>
</cfsavecontent>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = ''>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = ''>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfif isdefined("attributes.delete_username") and len(attributes.delete_username)>
    	<cfquery name="DELETE_USERNAME" datasource="#dsn#">
        	UPDATE 
            	FAILED_LOGINS 
            SET 
            	IS_ACTIVE=0,
                OPEN_BAN_DATE = #dateAdd('h',2,now())#,
                OPEN_BAN_USER_EMP = #session.ep.userid#
            WHERE 
            	USER_NAME = '#attributes.delete_username#'
                AND IS_ACTIVE=1
        </cfquery>
    </cfif>
</cfif>
<cfif isdefined("attributes.form_submit")>
    <cfset get_cmp = createObject("component","V16.report.standart.cfc.ban") />
    <cfset GET_FAILED_LOGINS = get_cmp.GET_FAILED_LOGINS(
        status: attributes.status,
        start_date : attributes.start_date,
        finish_date : attributes.finish_date,
        keyword : attributes.keyword
    )>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="list_health_expense_search" closable="0" collapsable="0">
        <cfform name="failed_logins" action="#request.self#?fuseaction=report.failed_logins_report" method="post">
            <cfinput type="hidden" name="form_submit" value="" />
            <cf_box_search more="0">
                <div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlama girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#"  style="width:65px;" validate="#validate_style#" required="no" maxlength="10" message="#message#" placeholder="#title#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="title"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" required="no" message="#message#" placeholder="#title#">			
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="status" id="status">
                        <option value="1" <cfif isdefined("attributes.status") and attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif isdefined("attributes.status") and attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                        <option value="" <cfif isdefined("attributes.status") and not len(attributes.status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                    </select>
                </div>
                <div class="form-group"><cf_wrk_search_button button_type="4"></div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <!-- sil -->
    <cf_box id="list_worknet_list" closable="0" collapsable="1" title="#title_box#" hide_table_column="1" uidrop="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="2%"><cf_get_lang dictionary_id='57487.No'></th>
                    <th width="80%"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></th>
                    <th width="10%" style="text-align: center" ><cf_get_lang dictionary_id='60652.Ban Aç'></th>
                    <th><i class="icn-md fa fa-history"/></th>
                </tr>
            </thead>
            <cfif isdefined("attributes.form_submit")>
                <cfform name="show_list" action="#request.self#?fuseaction=report.failed_logins_report" method="post">
                    <tbody>
                        <cfinput type="hidden" name="keyword" value="#attributes.keyword#">
                        <cfinput type="hidden" name="status" value="#attributes.status#">
                        <cfinput type="hidden" name="form_submit" value="0">
                        <cfinput type="hidden" name="is_form_submitted" value="0">
                        <cfinput type="hidden" name="delete_username" value="">
                        <cfset colspan_ = 4>
                        <cfif isdefined("attributes.status") and (attributes.status eq 0 or not len(attributes.status))>
                            <cfset colspan_ = colspan_ + 2>
                        </cfif>
                        <cfif GET_FAILED_LOGINS.recordcount>
                            <cfset satir_sayisi = 1>
                            <cfoutput query="GET_FAILED_LOGINS" group="USER_NAME">
                                <tr>
                                    <td width="2%">#satir_sayisi#</td>
                                    <td ><a href="javascript://" onclick="goster_tr('#USER_NAME#')" class="tableyazi">#USER_NAME#</a></td>
                                    <td align="center" class="padding-bottom-10 padding-top-10"><cfif IS_ACTIVE eq 1><a href="javascript://" onclick="delete_bans('#USER_NAME#')" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-right"><i class="fa fa-lock"></i> <cf_get_lang dictionary_id='60652.Ban Aç'></a></cfif></td>
                                    <td align="center"><i class="icn-md fa fa-history" href="javascript://"  onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=banHistory&user_name=#USER_NAME#&status=#attributes.status#')"/></td>
                                </tr>
                                <cfset satir_sayisi = satir_sayisi + 1>
                            </cfoutput>
                        <cfelse>
                            <tr><td colspan="<cfoutput>#colspan_+1#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
                        </cfif>
                    </tbody>
                </cfform>
            <cfelse>
                <tbody>
                    <tr>
                        <td colspan="5"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
                    </tr>
                </tbody>
            </cfif>
        </cf_grid_list>
    </cf_box>
</div>

<script type="text/javascript">
function goster_tr(tr_id)
{
	if(document.getElementById(tr_id).style.display == 'none')
		document.getElementById(tr_id).style.display = '';
	else
		document.getElementById(tr_id).style.display = 'none';
}
function delete_bans(user_name)
{
	document.getElementById('delete_username').value = user_name;
	document.show_list.submit();
}
</script>
