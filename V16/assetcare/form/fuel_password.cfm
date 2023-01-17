<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>	
	<cfquery name="GET_FUEL_PASSWORD" datasource="#dsn#">
		SELECT
			COMPANY.FULLNAME,
			ASSET_P_FUEL_PASSWORD.PASSWORD_ID,
			ASSET_P_FUEL_PASSWORD.BRANCH_ID,
			ASSET_P_FUEL_PASSWORD.COMPANY_ID,
			ASSET_P_FUEL_PASSWORD.STATUS,
			ASSET_P_FUEL_PASSWORD.USER_CODE,
			ASSET_P_FUEL_PASSWORD.PASSWORD1,
			ASSET_P_FUEL_PASSWORD.PASSWORD2,
			ASSET_P_FUEL_PASSWORD.START_DATE,
			ASSET_P_FUEL_PASSWORD.FINISH_DATE,
			ASSET_P_FUEL_PASSWORD.CARD_NO,
			ZONE.ZONE_NAME,
			BRANCH.BRANCH_NAME,
			ASSET_P_FUEL_PASSWORD.CARD_NO
		FROM
			ASSET_P_FUEL_PASSWORD,
			COMPANY,
			BRANCH,
			ZONE
		WHERE
			ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
		ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
			ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
		ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
			ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
		ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
			ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
		ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
			ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
		ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
			ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
		ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
			ASSET_P_FUEL_PASSWORD.COMPANY_ID = COMPANY.COMPANY_ID AND 
			ASSET_P_FUEL_PASSWORD.BRANCH_ID = BRANCH.BRANCH_ID AND
			<!--- Sadece yetkili olunan subeler gozuksun. --->
			ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
		ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
			ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
		ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
			ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
		ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
			ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
		ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
			ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
		ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
			ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
		ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
			ASSET_P_FUEL_PASSWORD.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND 
			BRANCH.ZONE_ID = ZONE.ZONE_ID
			<cfif isDefined('comp_id') and len(comp_id)>
				AND ASSET_P_FUEL_PASSWORD.COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_id#">
			</cfif>
			<cfif isDefined('attributes.card_no') and len(card_no) >
				AND ASSET_P_FUEL_PASSWORD.CARD_NO= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_no#">
			</cfif>
			<cfif isDefined('attributes.start_date_') and len(start_date_)>
				AND ASSET_P_FUEL_PASSWORD.START_DATE= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(attributes.start_date_,dateformat_style)#">
			</cfif>
			<cfif isDefined('attributes.finish_date_') and len(finish_date_)>
				AND ASSET_P_FUEL_PASSWORD.FINISH_DATE= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(attributes.finish_date_,dateformat_style)#">
			</cfif>
			<cfif isDefined('attributes.status') and len(status)>
				AND ASSET_P_FUEL_PASSWORD.STATUS= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
			</cfif>
		ORDER BY
			PASSWORD_ID DESC
	</cfquery>
	<cfparam name="attributes.totalrecords" default='#GET_FUEL_PASSWORD.recordcount#'>
<cfelse>
	<cfset GET_FUEL_PASSWORD.recordcount = 0>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cf_box>
	<cfparam name="attributes.status" default="">
	<cfparam name="attributes.branch" default="">
	<cfparam name="attributes.modal_id" default="">
	<cfparam name="attributes.comp_id" default="">
	<cfparam name="attributes.comp_name" default="">
	<cfparam name="attributes.start_date_" default="">
	<cfparam name="attributes.finish_date_" default="">
	<cfparam name="attributes.card_no" default="">
	<cfparam name="url_str" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.is_submitted" default="">

	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	
		

	<cfform name="fpassword" method="post" action="#request.self#?fuseaction=assetcare.fuel_password#url_str#">
		<cf_box_search>
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<div class="form-group">
				<div class="input-group">
					<input type="hidden" name="branch_id" id="branch_id" value="">
					<cfinput type="text" name="branch" value="#attributes.branch#"  readonly placeholder="#getLang('','Şube','57453')#">
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=fpassword.branch_id&field_branch_name=fpassword.branch');"  alt="<cf_get_lang dictionary_id='57453.Şube'>"></span>
				</div>
			</div>						
			<div class="form-group">
				<div class="input-group">
					<input type="hidden" name="comp_id" id="comp_id">
					<cfinput type="text" name="comp_name" id="comp_name" value="#attributes.comp_name#"  readonly placeholder="#getLang('','Akaryakıt Şirketi','48341')#">
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=fpassword.comp_name&field_comp_id=fpassword.comp_id&select_list=2,3');"  alt="<cf_get_lang dictionary_id='48341.Akaryakıt Şirketi'>"></span>
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
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('fpassword' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
		<cf_box_search_detail>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
					<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30631.Tarih'> !</cfsavecontent>
							<cfinput type="text" name="start_date_" validate="#validate_style#" message="#message2#" maxlength="10" value="#attributes.start_date_#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date_"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
					<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30631.Tarih'> !</cfsavecontent>
							<cfinput type="text" name="finish_date_" validate="#validate_style#" message="#message#" maxlength="10" value="#attributes.finish_date_#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30233.Kart No'></label>
					<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="card_no" id="card_no" value="#attributes.card_no#"  placeholder="#getLang('','Kart No','30233')#">
						</div>
					</div>
				</div>
			</div>
		</cf_box_search_detail>
	</cfform>
</cf_box>
<cf_box  title="#getlang('','Akaryakıt Şifre Kayıt',48340)#" uidrop="1">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
				<th width="35"><cf_get_lang dictionary_id='30233.Kart No'></th>
				<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
				<th><cf_get_lang dictionary_id='48341.Akaryakıt Şirketi'></th>
				<th><cf_get_lang dictionary_id='57482.Aşama'></th>
				<th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
				<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
				<th width="15"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.fuel_password&event=add')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_fuel_password.recordcount>
				<cfoutput query="get_fuel_password" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>#card_no#</td>								
						<td>#zone_name# / #branch_name#</td>
						<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#');">#fullname#</a></td>
						<td><cfif status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
						<td>#dateformat(start_date,dateformat_style)#</td>
						<td>#dateformat(finish_date,dateformat_style)#</td>
						<cfif isDefined('attributes.iframe') and  attributes.iframe eq 1>
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.fuel_password&event=upd&password_id=#password_id#')"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						<cfelse>
							<td width="30"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.fuel_password&event=upd&password_id=#password_id#')"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</cfif>
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
	</cf_grid_list>	
	<cfif get_fuel_password.recordcount eq 0>
		<div class="ui-info-bottom">
			<p><cfif attributes.is_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
		</div>
	</cfif>
	<cfif attributes.is_submitted eq 1>
		<cfif isdefined("attributes.branch_id")>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif isdefined("attributes.branch")>
			<cfset url_str = "#url_str#&branch=#attributes.branch#">
		</cfif>
		<cfif isdefined("attributes.is_submitted")>
			<cfset url_str = "#url_str#&is_submitted=1">
		</cfif>
		<cfif isdefined("attributes.comp_name")>
			<cfset url_str = "#url_str#&comp_name=#attributes.comp_name#">
		</cfif>
		<cfif isdefined("attributes.comp_id")>
			<cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
		</cfif>
		<cfif isdefined("attributes.status")>
			<cfset url_str = "#url_str#&status=#attributes.status#">
		</cfif>
		<cfif isdefined("attributes.start_date_")>
			<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date_)#">
		</cfif>
		<cfif isdefined("attributes.finish_date_")>
			<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date_)#">
		</cfif>
		<cfif isdefined("attributes.card_no")>
			<cfset url_str = "#url_str#&card_no=#dateformat(attributes.card_no)#">
		</cfif>
	</cfif>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="assetcare.fuel_password#url_str#">
		</cfif>
</cf_box>


	