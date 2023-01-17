<cf_xml_page_edit fuseact="objects.popup_list_campaigns">
<cfparam name="attributes.tarih_kontrol" default="#x_show_all_camp#">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.is_active" default='1'>
<cfparam name="attributes.camp_type" default=''>

<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_campaigns.cfm">
<cfelse>
	<cfset campaigns.recordcount = 0>
</cfif>
<cfquery name="GET_CAMP_TYPES" datasource="#dsn3#">
	SELECT CAMP_TYPE_ID,CAMP_TYPE FROM CAMPAIGN_TYPES ORDER BY CAMP_TYPE
</cfquery>

<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#campaigns.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<cfset url_string = "">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset url_string = "#url_string#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isDefined('attributes.field_name') and len(attributes.field_name)>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isDefined('attributes.field_start_date') and len(attributes.field_start_date)>
	<cfset url_string = "#url_string#&field_start_date=#attributes.field_start_date#">
</cfif>
<cfif isDefined('attributes.field_start_date1') and len(attributes.field_start_date1)>
	<cfset url_string = "#url_string#&field_start_date1=#attributes.field_start_date1#">
</cfif>
<cfif isDefined('attributes.field_finish_date') and len(attributes.field_finish_date)>
	<cfset url_string = "#url_string#&field_finish_date=#attributes.field_finish_date#">
</cfif>
<cfif isDefined('attributes.field_finish_date1') and len(attributes.field_finish_date1)>
	<cfset url_string = "#url_string#&field_finish_date1=#attributes.field_finish_date1#">
</cfif>
<cfif isDefined('attributes.is_next_day')>
	<cfset url_string = "#url_string#&is_next_day=#attributes.is_next_day#">
</cfif>
<cfif isDefined('attributes.subscription_id') and len(attributes.subscription_id)>
	<cfset url_string = "#url_string#&subscription_id=#attributes.subscription_id#">
</cfif>
<cfif isDefined('attributes.call_function') and len(attributes.call_function)>
	<cfset url_string = "#url_string#&call_function=#attributes.call_function#">
</cfif>
<cfif isDefined('attributes.call_function_param') and len(attributes.call_function_param)>
	<cfset url_string = "#url_string#&call_function_param=#attributes.call_function_param#">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Kampanya',57446)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="search_campaign" action="#request.self#?fuseaction=objects.popup_list_campaigns#url_string#" method="post">
            <cfinput type="hidden" name="is_form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group" id="camp_type">
                    <select name="camp_type" id="camp_type" style="width:170px;">
                        <option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
                        <cfoutput query="get_camp_types">
                            <option value="#camp_type_id#" <cfif attributes.camp_type eq camp_type_id>selected</cfif>>#camp_type#</option>
                            <cfquery name="GET_CAMPAIGN_CATS" datasource="#DSN3#">
                                SELECT CAMP_CAT_ID,CAMP_CAT_NAME FROM CAMPAIGN_CATS WHERE  CAMP_TYPE = #get_camp_types.camp_type_id#  ORDER BY CAMP_CAT_NAME
                            </cfquery>
                            <cfloop query="get_campaign_cats">
                                <option value="#get_camp_types.camp_type_id#_#camp_cat_id#" <cfif listlen(attributes.camp_type,'_') eq 2 and listgetat(attributes.camp_type,2,'_') eq camp_cat_id>selected</cfif>>&nbsp;&nbsp;#camp_cat_name#</option> 
                            </cfloop>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" id="is_active">
                    <select name="is_active" id="is_active">
                        <option value="2" <cfif isdefined("attributes.is_active") and (attributes.is_active eq 2)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif isdefined("attributes.is_active") and (attributes.is_active eq 1)>selected</cfif>><cf_get_lang dictionary_id="57493.Aktif"></option>
                        <option value="0" <cfif isdefined("attributes.is_active") and (attributes.is_active eq 0)>selected</cfif>><cf_get_lang dictionary_id="57494.Pasif"></option>
                    </select>
                </div>                
                <div class="form-group" id="tarih_kontrol">
                    <select name="tarih_kontrol" id="tarih_kontrol">
                        <option value="0" <cfif isdefined("attributes.tarih_kontrol") and (attributes.tarih_kontrol eq 0)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif isdefined("attributes.tarih_kontrol") and (attributes.tarih_kontrol eq 1)>selected</cfif>><cf_get_lang dictionary_id='33108.Bugünden Sonrası'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_campaign' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="40"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57480.Başlık'></th>
                    <th><cf_get_lang dictionary_id='57501.Başlama'></th>
                    <th><cf_get_lang dictionary_id='57502.Bitiş'></th>
                    <th><cf_get_lang dictionary_id='32800.Lider'></th>
                    <th><cf_get_lang dictionary_id='57416.Proje'></th>
                </tr> 
            </thead>
            <tbody>
                <cfif campaigns.recordcount>
                    <cfoutput query="campaigns" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <cfset camp_start_date = date_add("H", session.ep.time_zone, camp_startdate)>
                            <cfset camp_finish_date = date_add("H", session.ep.time_zone, camp_finishdate)>
                            <cfset camp_start_hour = datepart("H", camp_start_date)>
                            <cfset camp_start_minute = datepart("N", camp_start_date)>
                            <cfset camp_finish_hour = datepart("H", camp_finish_date)>
                            <cfset camp_finish_minute = datepart("N", camp_finish_date)>
                            <td><a href="javascript://" 
                                onclick="don('#camp_id#','#camp_head#','#dateformat(camp_start_date,dateformat_style)#','#dateformat(camp_finish_date,dateformat_style)#','#camp_start_hour#','#camp_start_minute#','#camp_finish_hour#','#camp_finish_minute#');" 
                                class="tableyazi">
                                    #camp_no#
                                </a>
                            </td>
                            <td><a href="javascript://" 
                                onclick="don('#camp_id#','#camp_head#','#dateformat(camp_start_date,dateformat_style)#','#dateformat(camp_finish_date,dateformat_style)#','#camp_start_hour#','#camp_start_minute#','#camp_finish_hour#','#camp_finish_minute#');" 
                                class="tableyazi">
                                    #camp_head#
                                </a>
                            </td>
                            <td>#dateformat(camp_start_date, dateformat_style)#</td>
                            <td>#dateformat(camp_finish_date, dateformat_style)#</td>
                            <td><cfif len(leader_employee_id)>#get_emp_info(leader_employee_id, 0, 1)#</cfif></td>
                            <td>
                                <cfif len(project_id)>
                                    <cfset attributes.project_id = project_id>
                                    <cfinclude template="../query/get_project_head.cfm">
                                    #get_project_head.project_head#
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="6"><cfif not isdefined("is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.maxrows lt attributes.totalrecords>
            <cfset url_string2=attributes.fuseaction>
            <cfif len(attributes.keyword)>
                <cfset url_string2 = "#url_string2#&keyword=#attributes.keyword#">
            </cfif>
            <cfif isdefined("attributes.is_form_submitted")>
                <cfset url_string2 = "#url_string2#&is_form_submitted=#attributes.is_form_submitted#">
            </cfif>
            <cfif isdefined("attributes.tarih_kontrol") and len(attributes.tarih_kontrol)>
                <cfset url_string2 = "#url_string2#&tarih_kontrol=#attributes.tarih_kontrol#">
            </cfif>
            <cfif isdefined('attributes.camp_type') and len(attributes.camp_type)>
                <cfset url_string2 = "#url_string2#&camp_type=#attributes.camp_type#">
            </cfif>
            <cfif isdefined('attributes.is_active') and len(attributes.is_active)>
                <cfset url_string2 = "#url_string2#&is_active=#attributes.is_active#">
            </cfif>
            <cfif len(url_string)>
                <cfset url_string2 = "#url_string2##url_string#">
            </cfif>
            <cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
			</cfif>
            <cf_paging 
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_string2#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">	
$(document).ready(function(){
  $( "form[name=search_campaign] #keyword" ).focus();
});
	function don(id,name,startdate,finishdate,start_hour,start_minute,finish_hour,finish_minute)
	{
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
		</cfif>
		<cfif isdefined("attributes.field_start_date")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_start_date#</cfoutput>.value = startdate;
		</cfif>
		<cfif isdefined("attributes.field_start_date1")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_start_date1#</cfoutput>.value = startdate;
		</cfif>
		<cfif isdefined("attributes.field_finish_date")>
			<cfif isdefined("attributes.is_next_day")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_finish_date#</cfoutput>.value = date_add("d",1,finishdate);
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_finish_date#</cfoutput>.value = finishdate;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_finish_date1")>
			<cfif isdefined("attributes.is_next_day")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_finish_date1#</cfoutput>.value = date_add("d",1,finishdate);
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_finish_date1#</cfoutput>.value = finishdate;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.call_function") and attributes.call_function is 'add_camp_date'>
			<cfoutput><cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#call_function#(start_hour,start_minute,finish_hour,finish_minute);</cfoutput>
		<cfelseif isdefined('attributes.call_function') and isdefined('attributes.call_function_param')>
			<cfoutput><cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.call_function#('#attributes.call_function_param#');</cfoutput>
		<cfelseif isdefined("attributes.call_function")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#call_function#</cfoutput>();
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
