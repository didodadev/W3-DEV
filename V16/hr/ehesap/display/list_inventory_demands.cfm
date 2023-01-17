<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="ehesap">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.startdate" default="#dateformat(date_add('m',-1,CreateDate(year(now()),month(now()),1)),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#dateformat(CreateDate(year(now()),month(now()),DaysInMonth(now())),dateformat_style)#"> 
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str = "">
<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
<cfif isdefined('attributes.form_submit')>
	<cfset url_str = "#url_str#&form_submit=#attributes.form_submit#">
</cfif>
<cfif isdefined('attributes.comp_id')>
	<cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
</cfif>
<cfif isdefined('attributes.branch_id')>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined('attributes.department')>
	<cfset url_str = "#url_str#&department=#attributes.department#">
</cfif>
<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
	<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
</cfif>
<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
	<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
</cfif>
<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
	<cfset url_str = "#url_str#&finishdate=#attributes.finishdate#">
</cfif>
<cfif isdefined('attributes.form_submit')>
	<cfif attributes.branch_id eq "all">
    	<cfset attributes.branch_id = "">
    </cfif>
	<cfif attributes.company_id eq "all">
    	<cfset attributes.company_id = "">
    </cfif>
	<cfif attributes.department eq "all">
    	<cfset attributes.department = "">
    </cfif>
    <cf_date tarih="attributes.startdate">
    <cf_date tarih="attributes.finishdate">
	<cfscript>
        get_demands = createObject("component","V16.myhome.cfc.get_inventory_demands");
        get_demands.dsn = dsn;
        get_inventory_demand = get_demands.inventory_demands
                        (
                         	keyword : attributes.keyword,
							company_id : attributes.company_id,
							branch_id : attributes.branch_id,
							department_id : attributes.department,
							process_stage : attributes.process_stage,
							startdate : attributes.startdate,
							finishdate : attributes.finishdate
                        );
    </cfscript>	
<cfelse>
	<cfset get_inventory_demand.recordcount = 0>
</cfif>
<cfscript>
	get_comp_ = createObject("component","V16.hr.cfc.get_our_company");
	get_comp_.dsn = dsn;
	get_our_company = get_comp_.get_company();
	
	get_process = createObject("component","V16.hr.cfc.get_process_rows");
	get_process.dsn = dsn;
	get_process_row = get_process.get_process_type_rows(
		faction : 'myhome.popup_form_add_inventory_demand'
	);
</cfscript>
<cfform action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_inventory_demands" name="myform" method="post">
<input type="hidden" name="form_submit" id="form_submit" value="1">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="31266.Envanter Talepleri"></cfsavecontent>
<cf_big_list_search title="#message#" >
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang dictionary_id='57460.Filtre'></td>
				<td>
					<cfinput name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</td>
                <td>
                    <select name="company_id" id="company_id" style="width:150px;" onChange="showBranch(this.value)">
                        <option value="all"><cf_get_lang dictionary_id='29531.Şirketler'></option>
                        <cfoutput query="get_our_company">
                            <option value="#comp_id#"<cfif attributes.company_id eq comp_id>selected</cfif>>#company_name#</option>
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <div width="125" id="BRANCH_PLACE">
                    <select name="branch_id" id="branch_id" style="width:150px;" onChange="showDepartment(this.value)">
                        <option value="all"><cf_get_lang dictionary_id='57453.Şube'></option>
                        <cfif isdefined("attributes.company_id") and len(attributes.company_id) and attributes.company_id is not "all">
                            <cfscript>
                                branch_ = createObject("component","V16.hr.cfc.get_branches");
                                branch_.dsn = dsn;
                                get_branch = branch_.get_branch(
                                                                    company_id:attributes.company_id
                                                                );
                            </cfscript>	
                            <cfoutput query="get_branch">
                                <option value="#branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                    </div>
                </td>
                <td width="125" nowrap="nowrap">
                    <div width="125" id="DEPARTMENT_PLACE">
                        <select name="department" id="department" style="width:150px;">
                            <option value="all"><cf_get_lang dictionary_id='57572.Departman'></option>
                            <cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
                                <cfscript>
                                    department = createObject("component","V16.hr.cfc.get_departments");
                                    department.dsn = dsn;
                                    get_department = department.get_department(
                                                                        branch_id:attributes.branch_id
                                                                        );
                                </cfscript>	
                                <cfoutput query="get_department">
                                    <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option></cfoutput>
                            </cfif>
                        </select>
                    </div>
                </td>
               	<td>
                    <label><input type="checkbox" name="show_entity" id="show_entity" value="1"<cfif isdefined('attributes.show_entity') and attributes.show_entity eq 1>checked</cfif>><cf_get_lang dictionary_id="45468.Varlıkları Göster"></label>
                </td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			</tr>
		</table>
	</cf_big_list_search_area>
	<cf_big_list_search_detail_area>
    	<table>
        	<tr>
            	<td>
                	<select name="process_stage" id="process_stage" style="width:120px;">
                    	<option value=""><cf_get_lang dictionary_id="57482.Aşama"></option>
                        <cfoutput query="get_process_row">
                    		<option value="#PROCESS_ROW_ID#" <cfif isdefined('attributes.process_stage') and attributes.process_stage eq PROCESS_ROW_ID>selected</cfif>>#stage#</option>
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi">!</cfsavecontent>
                    <cfinput type="text" name="startdate" style="width:65px;" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
                    <cf_wrk_date_image date_field="startdate"> 
                </td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57700.Bitiş Tarihi">!</cfsavecontent>
                    <cfinput type="text" name="finishdate" style="width:65px;" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="" maxlength="10" required="yes">
                    <cf_wrk_date_image date_field="finishdate">
                </td>
                
            </tr>
        </table>
	</cf_big_list_search_detail_area> 
</cf_big_list_search>
</cfform>
<script>
$(function(e){
	var _window = window;
	var _div = $('div#tableParentEl');
	<cfif listgetat(attributes.fuseaction,1,'.') eq 'extra'>
		var _width = $(_window).width();
	<cfelse>
		var _width = $(_window).width()-200 ;
	</cfif>
	var style = {
		'max-width' : _width ,
		'min-width' : _width  ,
		'overflow':	 'auto',
		
		}// style;
		_div.css(style);
});//ready
</script>
<div id="tableParentEl">
    <cf_big_list>
        <thead>
            <tr> 
                <th rowspan="2" height="22"><cf_get_lang dictionary_id='57487.No'></th>
                <th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                <th rowspan="2"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                <th rowspan="2"><cf_get_lang dictionary_id='57572.Departman'></th>
                <th rowspan="2"><cf_get_lang dictionary_id='57453.Şube'></th>
                <th rowspan="2"><cf_get_lang dictionary_id='57574.Şirket'></th>
                <th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='53704.Gruba Giriş'></th>
                <th rowspan="2" nowrap="nowrap">1.<cf_get_lang dictionary_id='29511.Yönetici'></th>
                <th rowspan="2"><cf_get_lang dictionary_id='59264.Form Tipi'></th>
                <th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='59265.Kayıt/Güncelleme Tarihi'></th>
                <th rowspan="2"><cf_get_lang dictionary_id='57756.Durum'></th>
                <cfif isdefined('attributes.show_entity') and attributes.show_entity eq 1>
                    <cfquery name="get_inventory_cat" datasource="#dsn#">
                        SELECT INVENTORY_CAT FROM SETUP_INVENTORY_CAT ORDER BY PRIORITY
                    </cfquery>
                    <cfset colspan = get_inventory_cat.recordcount>
                        <th colspan="<cfoutput>#colspan#</cfoutput>" style="text-align:center;" ><cf_get_lang dictionary_id='57420.Varlıklar'></th>
                        <th rowspan="2" class="header_icn_none" nowrap="nowrap">
                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=<cfoutput>#listfirst(attributes.fuseaction,'.')#</cfoutput>.popup_form_add_inventory_demand&employee_id=<cfoutput>#session.ep.userid#</cfoutput>','medium');">
                                <img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='45465.Envanter Talebi Ekle'>">
                            </a>
                		</th>
                    </tr>
                    <tr>
						<cfif get_inventory_cat.recordcount>
                            <cfloop query="get_inventory_cat">
                                <cfoutput>	
                                    <th nowrap="nowrap">#INVENTORY_CAT#</th>
                                </cfoutput>
                            </cfloop>
                        </cfif>
              	<cfelse>
                	<th></th>
               	</cfif>
          	</tr>
        </thead>
            <cfparam name="attributes.totalrecords" default="#get_inventory_demand.recordcount#">
            <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
            <cfif get_inventory_demand.recordcount>
                <cfoutput query="get_inventory_demand" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td width="25">#currentrow#</td>
                    <td>#EMPLOYEE_NAME#</td>
                    <td>#POSITION_NAME#</td>
                    <td>#department_head#</td>
                    <td>#branch_name#</td>
                    <td>#COMPANY_NAME#</td>
                    <td>#dateformat(STARTDATE,dateformat_style)#</td>
                    <td>#MANAGER_NAME_SURNAME#</td>
                    <td>
                    	<cfif FORM_TYPE eq 1>
                            <cf_get_lang dictionary_id='53702.İşe Giriş'>
                        <cfelseif FORM_TYPE eq 2>
                            <cf_get_lang dictionary_id='57703.Güncelleme'>
                        <cfelseif FORM_TYPE eq 3>
                            <cf_get_lang dictionary_id='29832.İşten Çıkış'>
                        </cfif>
                    </td>
                    <td>
                        <cfif isdefined("get_inventory_demand.UPDATE_DATE") and len(get_inventory_demand.UPDATE_DATE)>
                            #dateformat(UPDATE_DATE,dateformat_style)#
                        <cfelse>
                            #dateformat(RECORD_DATE,dateformat_style)#
                        </cfif>
                    </td>
                    <td>#stage#</td>
                    <cfif isdefined('attributes.show_entity') and attributes.show_entity eq 1>
                        <cfquery name="get_inventory_cat" datasource="#dsn#">
                            SELECT INVENTORY_CAT,INVENTORY_CAT_ID FROM SETUP_INVENTORY_CAT ORDER BY PRIORITY
                        </cfquery>
                        <cfloop query="get_inventory_cat">
                                <td style="text-align:center">
                                    <cfif ListFind(get_inventory_demand.INVENTORY_CAT_ID_LIST,get_inventory_cat.INVENTORY_CAT_ID,',')> + <cfelse> - </cfif>
                                </td>
                        </cfloop>
                    </cfif>
                    <td align="center" nowrap="nowrap">
                    <cfif FORM_TYPE eq 3>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.popup_form_upd_inventory_demand&INVENTORY_DEMAND_ID=#INVENTORY_DEMAND_ID#&form_type=3&employee_id=#EMPLOYEE_ID#','medium');">
                            <img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncelle'>">
                        </a>
                    <cfelse>
                    	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.popup_form_upd_inventory_demand&INVENTORY_DEMAND_ID=#INVENTORY_DEMAND_ID#&employee_id=#EMPLOYEE_ID#','medium');">
                            <img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncelle'>">
                        </a>
                    </cfif>
                    <cfif len(FINISH_DATE) and listgetat(attributes.fuseaction,1,'.') eq 'ehesap'>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_add_inventory_demand&employee_id=#EMPLOYEE_ID#&form_type=3','medium');">
                            <img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id='29832.İşten Çıkış'>">
                        </a>
                    </cfif>
                    </td>
                </tr>
                </cfoutput>
            <cfelse>	
                <tr>
                	<cfif isdefined('attributes.show_entity') and attributes.show_entity eq 1>
                    	<cfset colspan = colspan + 11>
                    	<td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    <cfelse>
                    	<td colspan="12"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </cfif>
                </tr>
            </tbody>
            </cfif>
    </cf_big_list>
</div>
<!-- sil -->
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#listfirst(attributes.fuseaction,'.')#.list_inventory_demands&#url_str#">
<!-- sil -->    
<script type="text/javascript">
	document.getElementById('keyword').focus();
function showDepartment(branch_id)	
{
	var branch_id = document.myform.branch_id.value;
	if (branch_id != "")
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	else
	{
		var myList = document.getElementById("department");
		myList.options.length = 0;
		var txtFld = document.createElement("option");
		txtFld.value='';
		txtFld.appendChild(document.createTextNode('<cf_get_lang dictionary_id="57572.Departman">'));
		myList.appendChild(txtFld);
	}
}
function showBranch(comp_id)	
{
	var comp_id = document.myform.company_id.value;
	if (comp_id != "")
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang dictionary_id="55769.İlişkili Şubeler">');
	}
	else {document.myform.branch_id.value = "";document.myform.department.value ="";}
	//departman bilgileri sıfırla
	var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
	AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang dictionary_id="55770.İlişkili Departmanlar">');
}	
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
