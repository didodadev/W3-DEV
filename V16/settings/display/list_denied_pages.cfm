<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.fuseaction_" default="">
<cfquery name="get_modules" datasource="#dsn#">
	SELECT MODULE_ID,MODULE_SHORT_NAME FROM MODULES  WHERE MODULE_SHORT_NAME IS NOT NULL ORDER BY MODULE_SHORT_NAME
</cfquery>
<cfquery name="get_faction_all" datasource="#dsn#">
	SELECT DISTINCT
		MODULE_ID, 
		DENIED_TYPE,
		DENIED_PAGE
	FROM 
		EMPLOYEE_POSITIONS_DENIED
	WHERE
		1=1 
	<cfif len(attributes.fuseaction_)>
		AND DENIED_PAGE LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.fuseaction_#%">
	</cfif>
    <cfif isdefined("attributes.module_") and len(attributes.module_)>
    	AND MODULE_ID = #attributes.module_#
    </cfif>
</cfquery>
<cfquery name="get_faction_all_" datasource="#dsn#">
	SELECT
		DENIED_PAGE,
		DENIED_TYPE,
		IS_VIEW,
		IS_INSERT,
		IS_DELETE
	FROM 
		EMPLOYEE_POSITIONS_DENIED
	WHERE
		1=1 
	<cfif len(attributes.fuseaction_)>
		AND DENIED_PAGE LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.fuseaction_#%">
	</cfif>
    <cfif isdefined("attributes.module_") and len(attributes.module_)>
    	AND MODULE_ID = #attributes.module_#
    </cfif>
	GROUP BY DENIED_PAGE,DENIED_PAGE_ID,DENIED_TYPE,IS_VIEW,IS_INSERT,IS_DELETE
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_faction_all.recordcount#">
<cfset attributes.startrow = (( attributes.page - 1 ) * attributes.maxrows ) + 1>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form1" method="post" action="#request.self#?fuseaction=settings.denied_pages">
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<input type="text" name="fuseaction_" id="fuseaction_" maxlength="50" placeholder="<cfoutput>#getLang('','WO Keyword','63563')#</cfoutput>" value="<cfif isdefined("attributes.fuseaction_") and len(attributes.fuseaction_)><cfoutput>#attributes.fuseaction_#</cfoutput></cfif>">
				</div>  		
				<div class="form-group">
					<div class="input-group">     
						<select name="module_" placeholder="<cfoutput>#getLang('','Module İsmini Seçiniz','43436')#</cfoutput>" id="module_">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_modules">
								<option value="#MODULE_ID#" <cfif isdefined("attributes.module_") and attributes.module_ eq MODULE_ID>Selected</cfif>>#MODULE_SHORT_NAME#</option>
							</cfoutput>
							<option value="0" <cfif isdefined("attributes.module_") and  attributes.module_ eq 0>selected</cfif>>My Home</option>
						</select>
					</div>
				 </div>  
				 <div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı','43958')#" maxlength="3">
				</div>  
				<div class="form-group">
                    <cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#?fuseaction=settings.denied_pages&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a>
                </div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Çalışan Sayfa Kısıtı','63499')#" uidrop="1" hide_table_column="1"> 
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30" class="text-center"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57581.Sayfa'></th>
					<th><cf_get_lang dictionary_id='63486.Kısıt Tanımı'></th>
					<th><cf_get_lang dictionary_id='43959.Kısıt Tipi'></th>
					<!-- sil --><th width="30"><a href="<cfoutput>#request.self#?fuseaction=settings.denied_pages&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th><!-- sil -->		
				</tr>
			</thead>
			<tbody>
				<cfif get_faction_all.recordcount and form_varmi eq 1>
					<cfoutput query="get_faction_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="30" class="text-center">#currentrow#</td>
							<td>
								<a href="#request.self#?fuseaction=settings.denied_pages&event=upd&faction=#DENIED_PAGE#" class="tableyazi">#DENIED_PAGE#</a>
							</td> 
							<td>
								<cfquery name="GET_1" dbtype="query" maxrows="1">
								SELECT * FROM get_faction_all_ WHERE  DENIED_PAGE = '#DENIED_PAGE#' AND IS_VIEW = 1 
								</cfquery>
								<cfif GET_1.recordcount><cf_get_lang dictionary_id='42134.Göremez'>,
								</cfif>
								<cfquery name="GET_1" dbtype="query" maxrows="1">
								SELECT * FROM get_faction_all_ WHERE  DENIED_PAGE = '#DENIED_PAGE#' AND IS_INSERT = 1 
								</cfquery>
								<cfif GET_1.recordcount><cf_get_lang dictionary_id='42135.Ekleyemez-Değiştiremez'>,</cfif>			  
								<cfquery name="GET_1" dbtype="query" maxrows="1">
								SELECT * FROM get_faction_all_ WHERE  DENIED_PAGE = '#DENIED_PAGE#' AND IS_DELETE = 1 
								</cfquery>
								<cfif GET_1.recordcount><cf_get_lang dictionary_id='42136.Silemez'></cfif>
							</td>
							<td><cfif DENIED_TYPE eq 0><cf_get_lang dictionary_id='43963.Yasak'><cfelseif DENIED_TYPE eq 1><cf_get_lang dictionary_id='58575.İzin'></cfif></td>
							<!-- sil --><td width="30"><a href="#request.self#?fuseaction=settings.denied_pages&event=upd&faction=#DENIED_PAGE#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
		   </tbody>
		</cf_grid_list>
		<cfif isdefined("attributes.is_form_submitted")>
			<cfset url_str = "settings.denied_pages">
			<cfif isdefined("attributes.module_") and len(attributes.module_)>
				<cfset url_str = "#url_str#&module_=#attributes.module_#">
			</cfif>
			<cfif isdefined("attributes.fuseaction_") and len(attributes.fuseaction_)>
				<cfset url_str = "#url_str#&fuseaction_=#attributes.fuseaction_#">
			</cfif>
			<cfif isdefined("attributes.is_form_submitted") and len (attributes.is_form_submitted)>
				<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
			</cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#url_str#">
		</cfif>
		<script type="text/javascript">
			document.getElementById('fuseaction_').focus();
		</script>
		<cfsetting showdebugoutput="yes">
	</cf_box>
</div>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset url_str = "settings.denied_pages">
	<cfif isdefined("attributes.module_") and len(attributes.module_)>
		<cfset url_str = "#url_str#&module_=#attributes.module_#">
	</cfif>
	<cfif isdefined("attributes.fuseaction_") and len(attributes.fuseaction_)>
		<cfset url_str = "#url_str#&fuseaction_=#attributes.fuseaction_#">
	</cfif>
	<cfif isdefined("attributes.is_form_submitted") and len (attributes.is_form_submitted)>
		<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
	</cfif>
	<cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="#url_str#">
</cfif>
<script type="text/javascript">
	document.getElementById('fuseaction_').focus();
</script>
<cfsetting showdebugoutput="yes">