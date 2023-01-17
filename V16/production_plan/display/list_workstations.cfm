<!---*******************
bu sayfanın bir kopyası da member/display/list_workstation.cfm 
yaptığınız değişiklikleri ondada yapın
--->
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="is_active" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_workstation_all.cfm">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_workstation_all.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = ''>
<cfif fuseaction contains "popup">
  <cfset send_value = "prod.popup_list_workstation">
<cfelse>
  <cfset send_value = "prod.list_workstation">
</cfif>
<cfif isdefined("attributes.field_code") and len(attributes.field_code)>
  <cfset url_str = "#url_str#&field_code=#attributes.field_code#">
</cfif>
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
  <cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
  <cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
  <cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
</cfif>
<cfif isdefined("attributes.field_comp_id") and len(attributes.field_comp_id)>
  <cfset url_str = "#url_str#&field_comp_id=#attributes.field_comp_id#">
</cfif>

<cf_box title="#getLang('','İş İstasyonları',36326)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form" action="#request.self#?fuseaction=#send_value##url_str#" method="post">
		<cf_box_search more="0">
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<div class="form-group" id="item-keyword">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group" id="item-branch_id">
				<select name="branch_id" id="branch_id">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_branch">
						<option value="#branch_id#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group" id="item-branch_id">
				<select name="is_active" id="is_active">
					<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
					<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
				</select>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>			
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form' , #attributes.modal_id#)"),DE(""))#">
				<!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='36669.İstasyon Adı'></th>
				<th width="100"><cf_get_lang dictionary_id='57453.Şube'></th>
				<th width="125"><cf_get_lang dictionary_id='36409.Dış Kaynak'></th>
				<th width="125"><cf_get_lang dictionary_id='57578.Yetkili'></th>
				<th width="15"></th>
				<cfif not isdefined("attributes.field_id")>
					<a href="javascript://" Onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_workstation</cfoutput>','list');"> <img src="/images/plus_square.gif" title="<cf_get_lang dictionary_id='36670.İstasyon Ekle'>"> </a> </td>
				</cfif>
			</tr>
		</thead>
		<tbody>
			<cfif get_workstation_all.recordcount>
				<cfset emp_position_list = '' >
				<cfoutput query="get_workstation_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(EMP_ID) and not listfind(emp_position_list,EMP_ID)>
						<cfset emp_position_list = ListAppend(emp_position_list,EMP_ID)>
					</cfif>
				</cfoutput>
				<cfif len(emp_position_list)>
					<cfset emp_position_list = listsort(emp_position_list,"numeric","ASC",",")>
					<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
						SELECT
							EMPLOYEE_NAME,
							EMPLOYEE_SURNAME,
							EMPLOYEE_ID,
							POSITION_CODE
						FROM
							EMPLOYEE_POSITIONS
						WHERE
							EMPLOYEE_ID IN (#emp_position_list#)
						ORDER BY
							EMPLOYEE_ID
					</cfquery>
					<cfset emp_position_list = listsort(listdeleteduplicates(valuelist(GET_EMPLOYEES.EMPLOYEE_ID,',')),'numeric','ASC',',')>               
				</cfif>
				<cfset crrnt_rw = 0>
				<cfset up_crrnt = 0>
				<cfoutput query="get_workstation_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<cfif not len(up_station)>
							<cfset crrnt_rw = crrnt_rw + 1>
							<cfset up_crrnt = 0>
						</cfif>
						<cfif len(up_station)>
							<cfset up_crrnt = up_crrnt + 1>
						</cfif>
						<td>#crrnt_rw#<cfif len(up_station)> - #up_crrnt#</cfif></td>
						<td><cfif len(up_station)>&nbsp;&nbsp;</cfif>
							<cfset emp_name_ = GET_EMPLOYEES.EMPLOYEE_NAME[listfind(emp_position_list,get_workstation_all.EMP_ID,',')]>
							<cfset emp_surname_= GET_EMPLOYEES.EMPLOYEE_SURNAME[listfind(emp_position_list,get_workstation_all.EMP_ID,',')]>
							<cfset emp_id_ = GET_EMPLOYEES.EMPLOYEE_ID[listfind(emp_position_list,get_workstation_all.EMP_ID,',')]>
							<cfif isdefined('attributes.field_id')>
							<cfset position_code_ = GET_EMPLOYEES.POSITION_CODE[listfind(emp_position_list,get_workstation_all.EMP_ID,',')]>
								<a href="javascript://"  onClick="add_product('#STATION_ID#','#STATION_NAME#','#CAPACITY#','#emp_id_#','#emp_name_# #emp_surname_#','#position_code_#')">#STATION_NAME#</a>
							<cfelse>
								<a href="#request.self#?fuseaction=prod.upd_workstation&station_id=#STATION_ID#">#STATION_NAME#</a>
							</cfif>
						</td>
						<td>#BRANCH_NAME#</td>
						<td width="175">
						<cfif len(OUTSOURCE_PARTNER)>
							<cfset COMPANY_ID = OUTSOURCE_PARTNER>
							#get_par_info(COMPANY_ID,0,-1,1)#
						</cfif>
						</td>
						<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id_#','medium');">#emp_name_#&nbsp;#emp_surname_#</a></td>
						<td align="center" width="15">
							<cfif isdefined("attributes.field_id")>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=prod.popup_list_workstation_orders&station_id=#STATION_ID#')"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='36671.İstasyon Yükü'>"></i></a>
							<cfelse>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=prod.popup_list_workstation_orders&station_id=#STATION_ID#')"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='36671.İstasyon Yükü'>"></i></a>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.is_active)>
			<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
		</cfif>
		<cfif len(attributes.branch_id)>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfset url_str = "#url_str#&is_form_submitted=1">
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#get_workstation_all.recordcount#" 
			startrow="#attributes.startrow#" 
			adres="#send_value##url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>

<script type="text/javascript">
	$(document).ready(function(){
			$( "form[name=form] #keyword" ).focus();
		});
function add_product(id,name,capacity,emp_id,emp_name,field_code)
{
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfset _field_name_ = ListGetAt(attributes.field_name,2,'.')><!--- Formu olmayan Sayfalara Değer Taşımak İçin Konuldu M.ER 01052008 --->
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_field_name_#'</cfoutput>) != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_field_name_#'</cfoutput>).value = name;
		else	
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_capacity")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_capacity#</cfoutput>.value = capacity;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<cfset _field_id_ = ListGetAt(attributes.field_id,2,'.')><!--- Formu olmayan Sayfalara Değer Taşımak İçin Konuldu M.ER 01052008 --->
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_field_id_#'</cfoutput>) != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_field_id_#'</cfoutput>).value = id;
		else	
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_employee_id")>
		<cfset _field_employee_id_ = ListGetAt(attributes.field_employee_id,2,'.')>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_field_employee_id_#'</cfoutput>) != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_field_employee_id_#'</cfoutput>).value = emp_id;
		else	
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#_field_employee_id_#</cfoutput>.value = emp_id;
	</cfif>
	<cfif isdefined("attributes.emp_name")>
		<cfset _field_emp_name_ = ListGetAt(attributes.emp_name,2,'.')>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_field_emp_name_#'</cfoutput>) != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_field_emp_name_#'</cfoutput>).value = emp_id;
		else	
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.emp_name#</cfoutput>.value = emp_id;
	</cfif>
	<cfif isdefined("attributes.field_comp_id")>
		<cfset _field_comp_id_ = ListGetAt(attributes.field_comp_id,2,'.')>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_field_comp_id_#'</cfoutput>) != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById(<cfoutput>'#_field_comp_id_#'</cfoutput>).value = "<cfoutput>#session.ep.company_id#</cfoutput>";
		else	
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_comp_id#</cfoutput>.value = "<cfoutput>#session.ep.company_id#</cfoutput>";
	</cfif>
	<cfif isdefined("attributes.field_code")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_code#</cfoutput>.value = field_code;//position_code
	</cfif>
	<!--- Üretim emrinden istasyon seçerken bitiş zamanını otomatik olarak hesaplayan fonksiyonu çalıştırıyor 'f_time_calc'--->
	<cfif isdefined('attributes.function_name')>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.function_name#</cfoutput>();
	</cfif>
}
</script>
