<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.user_group_id" default="">
<cfparam name="attributes.menu_status" default="1">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_main_menus.cfm">
<cfelse>
	<cfset main_menus.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#main_menus.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_USER_GROUPS" datasource="#DSN#">
	SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
</cfquery>
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id='29671.Siteler'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1" resize="0" collapsable="0">
		<cfform name="filter" action="#request.self#?fuseaction=settings.list_main_menu" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent  variable="filtre"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" maxlength="50" value="#attributes.keyword#" name="keyword" placeholder="#filtre#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="text" name="employee_name" id="employee_name" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_name)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>" maxlength="255" placeholder="<cf_get_lang dictionary_id='57576.Calisan'>">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=filter.employee_id&field_name=filter.employee_name&select_list=1','list');return false"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="position_cat_id" id="position_cat_id">
						<option value=""><cf_get_lang dictionary_id='59004.Pozisyon Tipi'>
						<cfoutput query="get_position_cats">
						<option value="#position_cat_id#" <cfif position_cat_id eq attributes.position_cat_id> selected </cfif>>#position_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="user_group_id" id="user_group_id">
						<option value=""><cf_get_lang dictionary_id='42510.Yetki Grubu'>
						<cfoutput query="get_user_groups">
						<option value="#user_group_id#" <cfif user_group_id eq attributes.user_group_id>selected</cfif>>#user_group_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="menu_status" id="menu_status">
						<option value=''><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value='1'<cfif attributes.menu_status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value='0'<cfif attributes.menu_status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='44670.Site'></th>
					<th><cf_get_lang dictionary_id='57892.Domain'> <cf_get_lang dictionary_id='57897.Adı'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th width="20" class="header_icn_none"><a href="javascript://"><i class="fa fa-sitemap"></i></a></th>
					<th width="20" class="header_icn_none"><a href="javascript://"><i class="fa fa-file-text-o"></i></a></th>
					<th width="20" class="header_icn_none"><cfoutput><a href="#request.self#?fuseaction=settings.list_main_menu&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfoutput></td>
					
				</tr>
			</thead>
			<tbody>
				<cfif main_menus.recordcount>
					<cfoutput query="main_menus" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=settings.list_main_menu&event=upd&menu_id=#menu_id#">#menu_name#</a></td>
							<td>#site_domain#</td>
							<td>#employee_name# #employee_surname#</td>
							<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_dsp_main_menu&menu_id=#menu_id#','page');"><i class="fa fa-sitemap" title="<cf_get_lang dictionary_id ='43993.Site Haritası'>" alt="<cf_get_lang dictionary_id ='43993.Site Haritası'>"></i></a></td>
							<td><a href="#request.self#?fuseaction=settings.list_site_layouts&menu_id=#menu_id#&is_submit=1"><i class="fa fa-file-text-o" title="<cf_get_lang dictionary_id ='57581.Sayfa'>" alt="<cf_get_lang dictionary_id ='57581.Sayfa'>"></i></a></td>
							<td><a href="#request.self#?fuseaction=settings.list_main_menu&event=upd&menu_id=#menu_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_string = "">
		<cfif len(attributes.keyword)>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)>
			<cfset url_string = "#url_string#&POSITION_CAT_ID=#attributes.POSITION_CAT_ID#">
		</cfif>
		<cfif isdefined("attributes.USER_GROUP_ID") and len(attributes.USER_GROUP_ID)>
			<cfset url_string = "#url_string#&USER_GROUP_ID=#attributes.USER_GROUP_ID#">
		</cfif>
		<cfif isdefined("attributes.menu_status") and len(attributes.menu_status)>
			<cfset url_string = "#url_string#&menu_status=#attributes.menu_status#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_string = "#url_string#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfset adres = "settings.list_main_menu">
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres##url_string#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
