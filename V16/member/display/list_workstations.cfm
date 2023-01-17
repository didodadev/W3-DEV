<!---bu sayfanın bir kopyası üretim planlamada display/list_workstation.cfm yapılacak değişiklikleri o sayfada da yapın--->
<!--- Madem kopyasi, neden bu sayfa kullanilmiyor da kopyalaniyor peki ozaman ? FBS  --->
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="is_active" default="1">
<cfparam name="attributes.page" default=1>
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_workstations.cfm">
<cfelse>
	<cfset get_workstations.recordcount = 0>    
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_workstations.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = ''>
<cfset send_value = "member.popup_list_workstations">
<cfif len(send_value)>
	<cfset url_str = "#url_str#&send_value=#send_value#">
</cfif>
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
  <cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
  <cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.is_active)>
	<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
</cfif>
<cfif len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','İş İstasyonları','30632')#" uidrop="1" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="lst_workstation" action="#request.self#?fuseaction=#send_value#" method="post">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
			<cf_box_search more="0">
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group" id="item-branch_id">
					<select name="branch_id" id="branch_id">
						<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<cfoutput query="get_branch">
						<option value="#branch_id#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-is_active">
					<select name="is_active" id="is_active">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" maxlength="3">
				</div>		
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('lst_workstation' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cf_grid_list>
				<thead>
					<tr>
					  <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					  <th><cf_get_lang dictionary_id='58834.İstasyon'></th>
					  <th width="100"><cf_get_lang dictionary_id='57453.Şube'></th>
					  <th width="125"><cf_get_lang dictionary_id='30439.Dış Kaynak'></th>
					  <th><cf_get_lang dictionary_id='57578.Yetkili'></th>
					  <th align="center" width="15"><a target="_blank" href="<cfoutput>#request.self#?fuseaction=prod.list_workstation&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='30442.İstasyon Ekle'>"></i></a></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_workstations.recordcount>
					  <cfoutput query="get_workstations" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
						  <td>#currentrow#</td>
						  <td>#station_name#</td>
						  <td>#branch_name#</td>
						  <td width="175"><cfif len(outsource_partner)>#get_par_info(outsource_partner,0,-1,1)#</cfif></td>
						  <td> <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium','popup_emp_det');" class="tableyazi">#employee_name# #employee_surname#</a></td>
						  <td align="center">
							<cfif isdefined("attributes.field_id")>
							  <a target="_blank" href='#request.self#?fuseaction=prod.popup_list_workstation_orders&station_id=#station_id#'><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='30441.İstasyon Yükü'>"></i></a>
							  <cfelse>
							  <a target="_blank" href='#request.self#?fuseaction=prod.popup_list_workstation_orders&station_id=#station_id#'><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='30441.İstasyon Yükü'>"></i></a>
							</cfif>
						  </td>
						</tr>
					  </cfoutput>
					  <cfelse>
					  <tr>
						<td colspan="6"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					  </tr>
					</cfif>
				</tbody>
			</cf_grid_list>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<table width="99%" align="center">
				  <tr>
					<td>
					  <cfset url_str="">
					  <cfif len(attributes.is_submit)>
						  <cfset url_str='#url_str#&is_submit=#attributes.is_submit#'>
					  </cfif>
					  <cf_pages page="#attributes.page#"
						  maxrows="#attributes.maxrows#"
						  totalrecords="#attributes.totalrecords#"
						  startrow="#attributes.startrow#"
						  adres="#send#&branch_id=#attributes.branch_id#&keyword=#attributes.keyword#&cpid=#attributes.cpid#"> </td>
					<!-- sil --><td  style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:<cfoutput>#get_workstations.recordcount#</cfoutput> &nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:<cfoutput>#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
				  </tr>
				</table>
			  </cfif>
			  <cfif attributes.totalrecords gt attributes.maxrows>
				<table width="99%" align="center">
				  <tr>
					<td>
					  <cfset url_str="">
					  <cfif len(attributes.is_submit)>
						  <cfset url_str='#url_str#&is_submit=#attributes.is_submit#'>
					  </cfif>
					  <cf_pages page="#attributes.page#"
						  maxrows="#attributes.maxrows#"
						  totalrecords="#attributes.totalrecords#"
						  startrow="#attributes.startrow#"
						  adres="#send#&branch_id=#attributes.branch_id#&keyword=#attributes.keyword#&cpid=#attributes.cpid#"> </td>
					<!-- sil --><td  style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:<cfoutput>#get_workstations.recordcount#</cfoutput> &nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:<cfoutput>#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
				  </tr>
				</table>
			  </cfif>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function add_product(id,name,capacity)
{
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_name#</cfoutput>.value=name;
	</cfif>
	<cfif isdefined("attributes.field_capacity")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_capacity#</cfoutput>.value=capacity;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_id#</cfoutput>.value=id;
	</cfif>
	<cfif isdefined("attributes.c")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>add_production_order.route_name</cfoutput>.value="";
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>add_production_order.route_id</cfoutput>.value="";
	</cfif>
}
</script>

