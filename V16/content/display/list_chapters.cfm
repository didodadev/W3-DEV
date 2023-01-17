<cfparam name="attributes.contentcat" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_CONTENT_CHAPTER" datasource="#DSN#">
		SELECT 
			HIERARCHY,
			RECORD_MEMBER,
			CONTENTCAT_ID,
			CHAPTER,
			RECORD_DATE,
			CONTENT_CHAPTER_STATUS,
			CHAPTER_ID
		FROM 
			CONTENT_CHAPTER
		WHERE 
			CHAPTER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		  	<cfif len(attributes.status)>
				AND CONTENT_CHAPTER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
		  	</cfif>
		  	<cfif len(attributes.contentcat)>
				AND CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contentcat#"> 
		  	</cfif>
		ORDER BY 
			HIERARCHY 
	</cfquery>
<cfelse>
	<cfset get_content_chapter.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_content_chapter.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" action="#request.self#?fuseaction=content.list_chapters" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" id="keyword" placeholder="  Filtre" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<cfinclude template="../query/get_content_cat.cfm">
					<select name="contentcat" id="contentcat">
						<option value="" selected><cf_get_lang_main no='74.Kategori'></option>
						<cfoutput query="get_content_cat">
							<option value="#contentcat_id#" <cfif attributes.contentcat eq contentcat_id>selected</cfif>>#contentcat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">	
					<select name="status" id="status">
						<option value="" <cfif not len(attributes.status)>selected</cfif>><cf_get_lang dictionary_id='30111.Durumu'></option>
						<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">			
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayı Hatası Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group"><cf_wrk_search_button button_type="4"></div>							
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id='50562.İçerik Bölümleri'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57761.Hiyerarşi'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57995.Bölüm'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=content.add_form_chapter"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_content_chapter.recordcount>
				<cfset record_member_list=''>
				<cfset contentcat_id_list=''>
					<cfoutput query="get_content_chapter" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(record_member) and not listfind(record_member_list,record_member)>
							<cfset record_member_list=listappend(record_member_list,record_member)>
						</cfif>
						<cfif len(contentcat_id) and not listfind(contentcat_id_list,contentcat_id)>
							<cfset contentcat_id_list=listappend(contentcat_id_list,contentcat_id)>
						</cfif>
					</cfoutput>
					<cfif len(record_member_list)>
					<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
						SELECT 
							EMPLOYEE_NAME,
							EMPLOYEE_SURNAME,
							EMPLOYEE_ID
						FROM 
							EMPLOYEES
						WHERE
							EMPLOYEE_ID IN (#record_member_list#)
						ORDER BY
							EMPLOYEE_ID
					</cfquery>
					<cfset record_member_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(contentcat_id_list)>
					<cfquery name="GET_CONTENTCAT" datasource="#DSN#">
						SELECT
							CONTENTCAT_ID,
							CONTENTCAT					
						FROM
							CONTENT_CAT
						WHERE
							CONTENTCAT_ID IN (#contentcat_id_list#)
						ORDER BY
							CONTENTCAT_ID
					</cfquery>
					<cfset contentcat_id_list = listsort(listdeleteduplicates(valuelist(get_contentcat.contentcat_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_content_chapter" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#hierarchy#</td>
							<td class="txtbold">#get_contentcat.contentcat[listfind(contentcat_id_list,contentcat_id,',')]# </td>
							<td><cfloop from="1" to="#listlen(hierarchy,',')#" index="i"></cfloop>#chapter#</td>
							<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_member#','medium');">#get_employee.employee_name[listfind(record_member_list,record_member,',')]#&nbsp;#get_employee.employee_surname[listfind(record_member_list,record_member,',')]#</a></td>
							<td><cfif len(get_content_chapter.record_date)>#dateformat(dateadd('h',session.ep.time_zone,get_content_chapter.record_date),dateformat_style)#</cfif></td>
							<td><cfif content_chapter_status eq 1><cf_get_lang_main no ='81.Aktif'><cfelse><cf_get_lang_main no ='82.Pasif'></cfif></td>
							<!-- sil -->
							<td style="text-align:center;"><a href="#request.self#?fuseaction=content.upd_chapter&chapter_id=#chapter_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>" alt="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>


		<cfset url_string = ''>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_string = "#url_string#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.contentcat") and len(attributes.contentcat)>
			<cfset url_string = "#url_string#&contentcat=#attributes.contentcat#">
		</cfif>
		<cfif isdefined("attributes.status") and len(attributes.status)>
			<cfset url_string = "#url_string#&status=#attributes.status#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="content.list_chapters#url_string#">
		<script type="text/javascript">
			document.getElementById('keyword').focus();
		</script>
	</cf_box>
</div>