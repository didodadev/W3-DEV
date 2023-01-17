<cfset url_str = ''>
<cfset url_str = '&id='&attributes.id&'&alan='&attributes.alan&'&hierarchy='&attributes.hierarchy>
<cfparam name="attributes.contentcat_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfinclude template="../query/get_content_cat.cfm">
<cfquery name="GET_CONTENT" datasource="#DSN#">
	SELECT 
		CONTENTCAT_ID,
		CONTENTCAT 
	FROM 
		CONTENT_CAT 
	ORDER BY 
		CONTENTCAT
</cfquery>
<cfquery name="GET_CHAPTER" datasource="#DSN#">
	SELECT 
		CONTENT_CHAPTER_STATUS,
		CONTENTCAT_ID,
		CHAPTER_ID,
		HIERARCHY,
		CHAPTER,
		RECORD_DATE 
	FROM
		CONTENT_CHAPTER
</cfquery>
<cfif isdefined("is_submitted")>
	<cfquery name="GET_ALL" datasource="#DSN#">
		SELECT 
			CONTENT_CAT.CONTENTCAT AS CONTENTCAT, 
			CONTENT_CAT.CONTENTCAT_ID,
			CONTENT_CHAPTER.CONTENT_CHAPTER_STATUS, 
			CONTENT_CHAPTER.CHAPTER_ID, 
			CONTENT_CHAPTER.HIERARCHY, 
			CONTENT_CHAPTER.CHAPTER, 
			CONTENT_CHAPTER.RECORD_DATE, 
			CONTENT_CHAPTER.RECORD_MEMBER 
		FROM 
			CONTENT_CHAPTER, 
			CONTENT_CAT 
		WHERE 
			CONTENT_CHAPTER.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CHAPTER) AND 
			CONTENT_CHAPTER.CONTENTCAT_ID = CONTENT_CAT.CONTENTCAT_ID
		<cfif len(attributes.keyword)>
            AND 
            (
                CONTENT_CAT.CONTENTCAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
                CONTENT_CHAPTER.CHAPTER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
           	)
        </cfif>
		<cfif len(attributes.status)>
            AND CONTENT_CHAPTER.CONTENT_CHAPTER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
        </cfif>
		<cfif isDefined("attributes.contentcat_id") and len(attributes.contentcat_id)>
            AND CONTENT_CHAPTER.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contentcat_id#"> 
        </cfif>

	UNION
        
		SELECT 
			CONTENTCAT, 
			CONTENTCAT_ID, 
			-1 AS CONTENT_CHAPTER_STATUS, 
			-1 AS CHAPTER_ID, 
			'' AS HIERARCHY, 
			'' AS CHAPTER, 
			'' AS RECORD_DATE, 
			-1 AS RECORD_MEMBER 
		FROM 
			CONTENT_CAT 
		WHERE 
			CONTENT_CAT.CONTENTCAT_ID NOT IN (SELECT CONTENTCAT_ID FROM CONTENT_CHAPTER)
			<cfif len(attributes.keyword)>
				AND CONTENTCAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>
			<cfif isDefined("attributes.contentcat_id") and len(attributes.contentcat_id)>
				AND CONTENT_CAT.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contentcat_id#">
			</cfif>
		ORDER BY 
			CONTENTCAT
	</cfquery>
<cfelse>
	<cfset get_all.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_all.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id='50562.İçerik Bölümleri'></cfsavecontent>
<cf_box title="#head#" uidrop="1" hide_table_column="1">
	<cfform name="form" action="#request.self#?fuseaction=content.popup_list_hierarchy#url_str#" method="post">
		<cf_box_search more="0">
			<input type="hidden" name="is_submitted" id="is_submitted"  value="1"/>			
			<div class="form-group">
				<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#" style="width:100px;" value="#attributes.keyword#" maxlength="255">
			</div>
			<div class="form-group">
				<select name="contentcat_id" id="contentcat_id">
					<option VALUE="" <cfif isdefined("attributes.contentcat_id") and not len(attributes.contentcat_id)>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
					<cfoutput query="get_content_cat">
						<option value="#contentcat_id#" <cfif isdefined("attributes.contentcat_id") and attributes.contentcat_id eq contentcat_id>selected</cfif>>#contentcat#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<select name="status" id="status">
					<option value="1" <cfif isdefined("attributes.status") and attributes.status is 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
					<option value="0" <cfif isdefined("attributes.status") and attributes.status is 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
					<option value="" <cfif isdefined("attributes.status") and not len(attributes.status)>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
				</select>
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</div>
			<div class="form-group"><cf_wrk_search_button button_type="4"></div>			
		</cf_box_search>
	</cfform>	
	<cf_flat_list>
		<thead>
			<tr>
				<th style="width:150px;"><cf_get_lang_main no='74.Kategori'></td>
				<th><cf_get_lang_main no='583.Bölüm'></td>
				<th style="width:125px;"><cf_get_lang_main no='487.Kaydeden'></td>
				<th style="width:80px;"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
				<th style="width:40px;"><cf_get_lang_main no='344.Durum'></td>
			</tr>
		</thead>
		<tbody>
			<cfif get_all.recordcount and isdefined("attributes.is_submitted")>
				<cfoutput query="get_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td><a href="javascript://" onClick="yolla_kategori('#contentcat_id#','#contentcat#','#hierarchy#');" class="tableyazi">#contentcat#</a></td>
						<td><a href="javascript://" onClick="yolla_hierarchy('#contentcat_id#','#contentcat#','#hierarchy#');" class="tableyazi">#chapter# <cfif hierarchy neq "">- (#hierarchy#)</cfif></a></td>
						<td>#get_emp_info(get_all.record_member,0,1)#</td>
						<td><cfif len(record_date)>#dateformat(date_add('h',session.ep.time_zone,record_date),'dd/mm/yy')# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</cfif></td>
						<td><cfif content_chapter_status eq 1><cf_get_lang_main no='81.Aktif'><cfelseif content_chapter_status eq 0><cf_get_lang_main no='82.Pasif'></cfif></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="5"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no ='72.Kayıt Yok'><cfelse><cf_get_lang_main no ='289.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>  
		</tbody>
	</cf_flat_list>
	<cfif attributes.totalrecords gt attributes.maxrows>		
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="content.popup_list_hierarchy&is_submitted=1&keyword=#attributes.keyword#&contentcat_id=#attributes.contentcat_id#&status=#attributes.status##url_str#">		
	</cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	
	function yolla_kategori(id,alan,hierarchy)
	{
		window.opener.<cfoutput>#attributes.id#</cfoutput>.value  = id;
		window.opener.<cfoutput>#attributes.alan#</cfoutput>.value = alan;
		window.opener.<cfoutput>#attributes.hierarchy#</cfoutput>.value = '';
		self.close();
	}
	
	function yolla_hierarchy(id,alan,hierarchy)
	{
		window.opener.<cfoutput>#attributes.id#</cfoutput>.value  = id;
		window.opener.<cfoutput>#attributes.alan#</cfoutput>.value = alan;
		window.opener.<cfoutput>#attributes.hierarchy#</cfoutput>.value = hierarchy;
		self.close();
	}
</script>
