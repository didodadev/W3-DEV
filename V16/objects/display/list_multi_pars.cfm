<cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfinclude template="../query/get_positions2.cfm">
<cfelse>
	<cfset get_positions.recordcount = 0>
</cfif>
<cfif "#attributes.field_name#" eq "add_visit.visit_emps">  <!--- detaylı ziyaret raporundan geliyorsa --->
    <cfquery name="GET_BRANCHES" datasource="#dsn#">
        SELECT 
            BRANCH.BRANCH_NAME,
            BRANCH.BRANCH_ID	
        FROM 
            BRANCH
        WHERE
            BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
            <cfif isDefined("attributes.our_cid")>
                AND BRANCH.COMPANY_ID = #session.ep.company_id# 
            </cfif>
        ORDER BY
            BRANCH_NAME
    </cfquery>
<cfelse>
    <cfquery name="GET_BRANCHES" datasource="#dsn#">
        SELECT 
            BRANCH.BRANCH_NAME,
            BRANCH.BRANCH_ID	
        FROM 
            BRANCH
            <cfif isDefined("attributes.our_cid")>WHERE  BRANCH.COMPANY_ID = #session.ep.company_id# </cfif>
        ORDER BY
            BRANCH_NAME
    </cfquery>
</cfif>

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default='#get_positions.recordcount#'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="select_list" default="1">
<cfscript>
	url_string = '';
	if (isdefined('attributes.field_id')) url_string = '#url_string#&field_id=#attributes.field_id#';
	if (isdefined('attributes.field_name')) url_string = '#url_string#&field_name=#attributes.field_name#';
	if (isdefined('attributes.is_multiple')) url_string = '#url_string#&is_multiple=#attributes.is_multiple#';
	if (isdefined('attributes.select_list')) url_string = '#url_string#&select_list=#attributes.select_list#';
	if (isdefined('attributes.is_upd')) url_string = '#url_string#&is_upd=#attributes.is_upd#';
</cfscript>
<cfsavecontent variable="head_">
	<div class="ui-form-list flex-list">
		<div class="form-group">
			<cfoutput>
                <select name="categories" id="categories" onChange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>">
                    <cfif listcontainsnocase(select_list,1)>
                        <option value="#request.self#?fuseaction=objects.popup_list_multi_pars#url_string#" selected><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
                    </cfif>
                </select>
			</cfoutput>
		</div>
	</div>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Çalışanlar',58875)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <cfform action="#request.self#?fuseaction=objects.popup_list_multi_pars#url_string#" method="post" name="search_form">
            <cf_box_search more="0">
                <input type="hidden" name="is_upd" id="is_upd" value="0">
                <input type="hidden" name="click_count"  id="click_count" value="<cfoutput>#attributes.is_upd#</cfoutput>">
                <div class="form-group" id="keyword">
                    <cfinput type="text" name="keyword"  placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
                    <input name="is_form_submitted"  id="is_form_submitted" type="hidden" value="1">
                </div>
                <div class="form-group" id="branch_id">
                    <select name="branch_id" id="branch_id" style="width:200px;">
                        <option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
                        <cfoutput query="GET_BRANCHES">
                            <option value="#branch_id#"<cfif branch_id eq attributes.branch_id> selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_form' , #attributes.modal_id#)"),DE(""))#"> 
                </div>
            </cf_box_search>
        </cfform>
        <tbody><cfoutput>#head_#</cfoutput></tbody>
        <cf_grid_list>
            <cfif len(attributes.keyword)>
                <cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
            </cfif> 
            <thead>
                <tr>
                    <th width="30"></th>
                    <th width="120"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th width="120"><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th width="80"><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th width="15"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_positions.recordcount>
                <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td align="center"><cf_online id="#employee_id#" zone="ep"></td>
                    <td><cfif isdefined("attributes.is_multiple")>
                        <a href="javascript://" class="tableyazi" onClick="gonder(#position_code#,'#employee_name# #employee_surname#','#currentrow#')">#employee_name# #employee_surname#</a>
                    <cfelse>
                        <a href="javascript:add_pos('#position_code#','#employee_name# #employee_surname#');" class="tableyazi">#employee_name# #employee_surname#</a>
                    </cfif></td>
                    <td>#position_name#</td>
                    <td>#branch_name#</td>
                    <td>#department_head#</td>
                    <td>
                    <cfif not isdefined("attributes.show_empty_pos")>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&department_id=#DEPARTMENT_ID#&emp_id=#EMPLOYEE_ID#&pos_id=#POSITION_CODE##url_string#','medium');"><i class="fa fa-bar-chart" alt="<cf_get_lang dictionary_id='57771.Detay'>" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a>
                    </cfif>
                    </td>
                </tr>
                </cfoutput>
                <cfelse>
                <tr> 
                    <td colspan="6"><cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
            <cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
        </cfif>
        <cfif isDefined("attributes.draggable") and len(attributes.draggable)>
            <cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
        </cfif>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="objects.popup_list_multi_pars#url_string#&is_form_submitted=1"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
$(document).ready(function(){

    $( "#keyword" ).focus();

});
<cfif isdefined("attributes.is_multiple")>
	function gonder(society_id,society,id)
	{
		var kontrol =0;
		uzunluk = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
		for(i=0;i<uzunluk;i++)
		{
			if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==society_id)
			{
				kontrol=1;
			}
		}
		if(kontrol==0)
		{
			<cfif isDefined("attributes.field_name")>
				x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
                <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
                <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>. <cfoutput>#attributes.field_name#</cfoutput>.options[x].value = society_id;
                <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = society;
			</cfif>
		}
	}
<cfelse>
	function add_pos(id,name)
	{
		var x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value;
		var y = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value;
		if (search_form.click_count.value==0)
		{	
			x = "";
			y = "";
			search_form.click_count.value = 1;
			if (<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value.indexOf(id) == -1)
			{
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
                <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
			}
		}
		else
		{	
			if (<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value.indexOf(id) == -1)
			{
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = x + ',' + id;
                <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = y + ',' + name;
			}
		}
	}
</cfif>
function is_field_name_focus()
{
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_name#</cfoutput>.focus();
	</cfif>
}
</script>
