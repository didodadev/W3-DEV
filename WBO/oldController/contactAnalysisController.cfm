<cf_get_lang_set module_name="member">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_status" default="1">
<cfparam name="attributes.search_type" default="1">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.start_dates" default="">
<cfparam name="attributes.finish_dates" default="">
<cfif len(attributes.start_dates) and isdate(attributes.start_dates)>
	<cf_date tarih = "attributes.start_dates">
</cfif>
<cfif len(attributes.finish_dates) and isdate(attributes.finish_dates)>
	<cf_date tarih = "attributes.finish_dates">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../member/query/get_member_analysiss.cfm">
<cfelse>
	<cfset get_member_analysis.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_member_analysis.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfinclude template="../member/query/get_language.cfm">
<cfinclude template="../member/query/get_partners.cfm">
<cfset attributes.is_active_consumer_cat = 1>
<cfinclude template="../member/query/get_consumer_cat.cfm">
<cfquery name="GET_SITE_MENU" datasource="#DSN#">
	SELECT 
    	MENU_ID,
        SITE_DOMAIN,
        OUR_COMPANY_ID 
    FROM 
    	MAIN_MENU_SETTINGS 
    WHERE 
    	IS_ACTIVE = 1 AND 
        SITE_DOMAIN IS NOT NULL
</cfquery>

<cfif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfinclude template="../member/query/get_language.cfm">
    <cfinclude template="../member/query/get_consumer_cat.cfm">
    <cfinclude template="../member/query/get_partners.cfm">
    <cfinclude template="../member/query/get_analysis.cfm">
    
    <cfquery name="GET_SITE_DOMAIN" datasource="#DSN#">
        SELECT 
            MENU_ID 
        FROM 
            ANALYSIS_SITE_DOMAIN 
        WHERE 
            ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#"> AND
            MENU_ID IS NOT NULL
    </cfquery>
    <cfquery name="GET_RESULT_CONTROL" datasource="#DSN#">
        SELECT TOP 1 RESULT_ID FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#analysis_id#">
    </cfquery>
</cfif>

<script type="text/javascript">
	document.getElementById('keyword').focus();
	function control2()
	{
		if( !date_check(document.getElementById('start_dates'),document.getElementById('finish_dates'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;
	}
	
	function hepsi()
	{
		if (document.analysisForm.all.checked)
		{
			for(i=0;i<document.analysisForm.analysis_partners.length;i++) document.analysisForm.analysis_partners[i].checked = true;
			for(i=0;i<document.analysisForm.analysis_consumers.length;i++) document.analysisForm.analysis_consumers[i].checked = true;
			<cfif isdefined("attributes.event") and attributes.event is 'upd'>
				for(i=0;i<document.analysisForm.analysis_rivals.length;i++) document.analysisForm.analysis_rivals[i].checked = true;
			</cfif>
		}
		else
		{
			for(i=0;i<document.analysisForm.analysis_partners.length;i++) document.analysisForm.analysis_partners[i].checked = false;
			for(i=0;i<document.analysisForm.analysis_consumers.length;i++) document.analysisForm.analysis_consumers[i].checked = false;
			<cfif isdefined("attributes.event") and attributes.event is 'upd'>
				for(i=0;i<document.analysisForm.analysis_rivals.length;i++) document.analysisForm.analysis_rivals[i].checked = false;
			</cfif>
		}
	}
	function form_check()
	{
	
		if ((document.getElementById('total_points').value == "") && (document.analysisForm.grade_style[1].checked))
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1573.Toplam Puan !'>");
			return false;
		}
	
		if(document.getElementById('analysis_average').value == "")
		{
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1977.Uygunluk Sınırı'>!");
			return false;
		}
	
		flag = 0;
		for(i=0;i<document.analysisForm.analysis_partners.length;i++) if (document.analysisForm.analysis_partners[i].checked) flag = 1;
		for(i=0;i<document.analysisForm.analysis_consumers.length;i++) if (document.analysisForm.analysis_consumers[i].checked) flag = 1;
	
		if (flag == 0)
		{
			alert ("<cf_get_lang no='192.Testi En Az Bir Kullanıcı Grubuna Kaydedin'>!");
			return false;
		}
		return process_cat_control();
	}

</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'member.popup_form_add_analysis';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'member/form/add_analysis.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'member/query/add_analysis.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'member.list_analysis&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'member.popup_form_upd_analysis';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'member/form/upd_analysis.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'member/query/upd_analysis.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'member.list_analysis&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'analysis_id=##attributes.analysis_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.analysis_id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'member.list_analysis';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'member/display/list_analysis.cfm';
	
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=member.list_analysis&event=add";
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
	tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

</cfscript>
