<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
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
			CHAPTER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
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

<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>



<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
<cfquery name="GET_CHAPTER" datasource="#DSN#">
	SELECT 
		CONTENTCAT_ID,
		CHAPTER,
		CHAPTER_ID,
		CONTENT_CHAPTER_STATUS,
		HIERARCHY,
		CHAPTER_IMAGE1,
		SERVER_ID1,
		CHAPTER_IMAGE2,
		SERVER_ID2,
		RECORD_DATE,
		RECORD_MEMBER,
        UPDATE_EMP,
        UPDATE_DATE
	FROM 
		CONTENT_CHAPTER 
	WHERE 
		CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chapter_id#">
</cfquery>
<cfset attributes.contentcat_id = get_chapter.contentcat_id>
<cfquery name="CHAPTER_LIST" datasource="#DSN#">
	SELECT 
		CONTENTCAT_ID,
		HIERARCHY,
		CHAPTER
	FROM 
		CONTENT_CHAPTER 
	WHERE 
		CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_chapter.contentcat_id#">
	ORDER BY 
		HIERARCHY 
</cfquery>
<cfinclude template="../content/query/get_content_cat_name.cfm">
<cfsavecontent variable="right_">
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=content.list_chapters&event=add"><img src="/images/plus1.gif" alt="<cf_get_lang_main no ='170.Ekle'>" align="absmiddle" title="<cf_get_lang_main no ='170.Ekle'>" border="0"></a>
</cfsavecontent>



<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
<cfinclude template="../content/query/old_chapter_list.cfm">
<cfinclude template="../content/query/get_content_cat.cfm">

</cfif>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'content.list_chapters';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'content/display/list_chapters.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'content.upd_chapter';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'content/form/form_upd_chapter.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'content/query/update_chapter.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'content.list_chapters&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'chapter_id=##attributes.chapter_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.chapter_id##';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'content.emptypopup_del_chapter';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'content/query/del_chapter.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'content/query/del_chapter.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'content.list_chapters&event=list';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'chapter_id=##attributes.chapter_id##';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.chapter_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'content.add_form_chapter';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'content/form/form_add_chapter.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'content/query/add_chapter.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'content.list_chapters&event=list';
	WOStruct['#attributes.fuseaction#']['add']['parameters'] ='chapter_id=##attributes.chapter_id##';
	WOStruct['#attributes.fuseaction#']['add']['Identity'] = '##attributes.chapter_id##';
	

</cfscript>
