 <cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfquery name="get_pos_cats" datasource="#dsn#">
	SELECT
		POSITION_CAT_ID,
		POSITION_CAT
	FROM
		SETUP_POSITION_CAT
	ORDER BY 
		POSITION_CAT
</cfquery>
<cfquery name="get_modules" datasource="#dsn#">
SELECT MODULE_ID,MODULE_SHORT_NAME FROM MODULES  WHERE MODULE_SHORT_NAME IS NOT NULL ORDER BY MODULE_SHORT_NAME
</cfquery>
<cfquery name="get_faction" datasource="#dsn#">
    SELECT 
		EPD.POSITION_CODE,
		EP.POSITION_CAT_ID,
        M.MODULE_SHORT_NAME,
		EPD.FUSEACTION_ID,
		EPD.MODULE_ID,
		D.DEPARTMENT_HEAD,
		SPC.POSITION_CAT,
		EP.EMPLOYEE_ID,
		EP.POSITION_NAME,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEE_POSITIONS_DENIED EPD,
		EMPLOYEE_POSITIONS EP,
        MODULES M,
		DEPARTMENT D,
		SETUP_POSITION_CAT SPC
	WHERE
	    EPD.POSITION_CODE = EP.POSITION_CODE AND
		D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
        EPD.MODULE_ID = M.MODULE_ID AND
		SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID AND
		EPD.POSITION_CODE IS NOT NULL AND
		EPD.DENIED_PAGE_ID IS NULL
	<cfif isdefined("attributes.position_cat") and len(attributes.position_cat)>
		AND	EP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat#">
	</cfif>
    <cfif isdefined("attributes.module_") and len(attributes.module_)>
    	AND EPD.MODULE_ID = #attributes.module_#
    </cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			EP.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
			OR 
			EP.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
		)
	</cfif>
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_catalystHeader>
	<cf_box>
		<cfform name="form1" method="post" action="#request.self#?fuseaction=settings.emp_denied_pages">
			<cf_box_search more="0">
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group">
					<input type="text" name="keyword" id="keyword" maxlength="50" placeholder="<cfoutput>#getLang('','Filtre','57460')#</cfoutput>" value="<cfif isdefined("attributes.keyword") and len(attributes.keyword)><cfoutput>#attributes.keyword#</cfoutput></cfif>">
				</div>
				<div class="form-group">
					<select name="position_cat" id="position_cat">
						<option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></option>
						<cfoutput query="get_pos_cats">
							<option value="#POSITION_CAT_ID#" <cfif isdefined("attributes.position_cat") and attributes.position_cat eq POSITION_CAT_ID>selected</cfif>>#POSITION_CAT#</option>	
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="module_" id="module_">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_modules">
							<option value="#MODULE_ID#" <cfif isdefined("attributes.module_") and attributes.module_ eq MODULE_ID>Selected</cfif>>#MODULE_SHORT_NAME#</option>
						</cfoutput>
						<option value="0" <cfif isdefined("attributes.module_") and  attributes.module_ eq 0>selected</cfif>>My Home</option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayı Hatası','43966')#" maxlength="3">
				</div>
				<div class="form-group">
                    <cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#?fuseaction=settings.emp_denied_pages&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Kısıtlı Sayfalar','42112')#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='30368.Çalışan'></th>
					<th><cf_get_lang dictionary_id='63573.Pozisyon Kategorisi'></th>
					<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='35449.Departman'></th>
					<th><cf_get_lang dictionary_id='34970.Modül'></th>
					<th class="header_icn_none">
						<cfif not listfindnocase(denied_pages,'settings.user_denied_emp')>
							<a href="<cfoutput>#request.self#?fuseaction=settings.emp_denied_pages&event=add</cfoutput>" class="tableyazi"></a>
							<a href="<cfoutput>#request.self#?fuseaction=settings.emp_denied_pages&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a>
						</cfif>
					</th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_faction.recordcount and form_varmi eq 1>
					<cfset attributes.totalrecords = get_faction.recordcount>
					<cfoutput query="get_faction" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td> 
							<td>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
							</td> 
							<td>#POSITION_CAT#</td>
							<td>#POSITION_NAME#</td>
							<td>#DEPARTMENT_HEAD#</td>
							<td>#MODULE_SHORT_NAME#</td>
							<!-- sil -->
							<cfif #fuseaction_id# neq 'NULL'>
								<td width="30"><a href="#request.self#?fuseaction=settings.emp_denied_pages&event=upd&faction_id=#fuseaction_id#&module_id=#module_id#&pos_code=#position_code#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
							<cfelse>	
								<td width="30"><a href="#request.self#?fuseaction=settings.emp_denied_pages&event=upd&module_id=#module_id#&pos_code=#position_code#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							</cfif>
						<!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="8"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "settings.emp_denied_pages">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = url_str&'&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isdefined("attributes.position_cat") and len(attributes.position_cat)>
			<cfset url_str = url_str&'&position_cat=#attributes.position_cat#'>
		</cfif>
		<cfif isdefined("attributes.module_") and len(attributes.module_)>
			<cfset url_str = url_str&'&module_=#attributes.module_#'>
		</cfif>
		<cfif isdefined ("attributes.is_form_submitted") and len (attributes.is_form_submitted)>
		<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
