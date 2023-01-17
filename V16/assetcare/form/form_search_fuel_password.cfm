<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.card_no" default="">
<cfparam name="url_str" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_submitted" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
		<cfinclude template="../query/get_fuel_password_search.cfm">
		<cfparam name="attributes.totalrecords" default='#get_fuel_password_search.recordcount#'>
	<cfelse>
		<cfset get_fuel_password_search.recordcount = 0>
		<cfparam name="attributes.totalrecords" default='0'>
	</cfif>
	
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cf_box>
	<cfform name="search_fuel_password" method="post" action="#request.self#?fuseaction=assetcare.form_search_full_password">
		<input type="hidden" name="is_submitted" id="is_submitted" value="1">
		<cf_box_search>
			<div class="form-group">
				<div class="input-group">
					<input type="hidden" name="branch_id" id="branch_id" value="">
					<cfinput type="text" name="branch" value=""  readonly placeholder="#getLang('','Şube','57453')#">
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_fuel_password.branch_id&field_branch_name=search_fuel_password.branch');"  alt="<cf_get_lang dictionary_id='57453.Şube'>"></span>
				</div>
			</div>						
			<div class="form-group">
				<div class="input-group">
					<input type="hidden" name="company_id" id="company_id">
					<cfinput type="text" name="company_name" value=""  readonly placeholder="#getLang('','Akaryakıt Şirketi','48341')#">
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_fuel_password.company_name&field_comp_id=search_fuel_password.company_id&select_list=2,3');"  alt="<cf_get_lang dictionary_id='48341.Akaryakıt Şirketi'>"></span>
				</div>
			</div>
			<div class="form-group">
				<select name="status" id="status">
					<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
					<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
				</select>
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4">
			</div>
		</cf_box_search>
		<cf_box_search_detail>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
					<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30631.Tarih'> !</cfsavecontent>
							<cfinput type="text" name="start_date" validate="#validate_style#" message="#message2#" maxlength="10" >
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
					<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30631.Tarih'> !</cfsavecontent>
							<cfinput type="text" name="finish_date" validate="#validate_style#" message="#message#" maxlength="10" >
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30233.Kart No'></label>
					<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="company_name" value=""  readonly placeholder="#getLang('','Kart No','30233')#">
						</div>
					</div>
				</div>
			</div>
		</cf_box_search_detail>
	</cfform>
</cf_box>
<cf_box title="#getlang('','Akaryakıt Şifreleri',47056)#" uidrop="1" hide_table_column="1">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th width="35"><cf_get_lang dictionary_id='30233.Kart No'></th>
				<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>	
				<th><cf_get_lang dictionary_id='48341.Akaryakıt Şirketi'></th>
				<th><cf_get_lang dictionary_id='57482.Aşama'></th>
				<th width="65"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
				<th width="65"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>						
				<th width="20" ></th>
			</tr>    
		</thead>
		<tbody>	
			<cfif get_fuel_password_search.recordcount>
				<cfoutput query="get_fuel_password_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>#card_no#</td>								
						<td>#zone_name# / #branch_name#</td>
						<td><a href="javascript://" class="tableyazi" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#')">#fullname#</a></td>
						<td><cfif status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
						<td>#dateformat(start_date,dateformat_style)#</td>
						<td>#dateformat(finish_date,dateformat_style)#</td>
						<td width="30"><a onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.fuel_password&event=upd&password_id=#password_id#')" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
					</tr>
				</cfoutput>
			</cfif>		
		</tbody>
	</cf_grid_list>
	<cfif get_fuel_password_search.recordcount eq 0>
		<div class="ui-info-bottom">
			<p><cfif attributes.is_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
		</div>
	</cfif>
	<cfif attributes.is_submitted eq 1>
		<cfset url_str = "">
		<cfif isdefined("attributes.branch_id")>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif isdefined("attributes.branch")>
			<cfset url_str = "#url_str#&branch=#attributes.branch#">
		</cfif>
		<cfif isdefined("attributes.is_submitted")>
			<cfset url_str = "#url_str#&is_submitted=1">
		</cfif>
		<cfif isdefined("attributes.company_name")>
		<cfset url_str = "#url_str#&company_name=#attributes.company_name#">
		</cfif>
		<cfif isdefined("attributes.company_id")>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.status")>
			<cfset url_str = "#url_str#&status=#attributes.status#">
		</cfif>
		<cfif isdefined("attributes.start_date")>
			<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date)#">	
		</cfif>
		<cfif isdefined("attributes.finish_date")>
			<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date)#">
		</cfif>	
	</cfif>
	<cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		card_no="#attributes.card_no#"
		adres="#attributes.fuseaction##url_str#">
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.search_fuel_password.maxrows.value>200)
		{
			alert("<cf_get_lang dictionary_id='48600.Maxrows Değerini Kontrol Ediniz'>");
			return false;
		}
		return true;
		if ( (document.search_fuel_password.start_date.value.length>0) && (document.search_fuel_password.finish_date.value.length>0) && (!date_check(document.search_fuel_password.start_date,document.search_fuel_password.finish_date,"<cf_get_lang_main no='394.Tarih Aralığını Kontrol Ediniz'>!")) )
		{
			return false;
		}
		return true;
	}
</script>