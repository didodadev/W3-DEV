<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../report/query/get_special_report_categories.cfm">
<cfelse>
	<cfset get_special_report_categories.recordcount=0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfset url_string = "">
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_special_report_categories.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>



<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
<cfquery name="get_special_report_cats" datasource="#dsn#">
	SELECT 
    	REPORT_CAT_ID, 
        REPORT_CAT, 
        HIERARCHY 
    FROM 
    	SETUP_REPORT_CAT
    ORDER BY
    	HIERARCHY 
</cfquery>
<cfquery name="get_my_special_report_cat" datasource="#dsn#">
	SELECT * FROM SETUP_REPORT_CAT WHERE REPORT_CAT_ID = #attributes.report_cat_id#
</cfquery>

<script language="javascript">
	function kontrol()
	{
		if(document.upd_special_report_category.report_cat.value == '')
		{
			alert('Lütfen Kategori Giriniz!');
			return false;
		}
		return true;
	}
</script>


<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
<cfquery name="get_special_report_cats" datasource="#dsn#" >
    SELECT
        REPORT_CAT_ID,
        REPORT_CAT,
        UPPER_CAT_ID,
        HIERARCHY
    FROM
        SETUP_REPORT_CAT
    ORDER BY
    	HIERARCHY
</cfquery>

<script language="javascript">
	function kontrol()
	{
		if(document.add_special_report_category.report_cat.value == '')
		{
			alert('Lütfen Kategori Seçiniz!');
			return false;
		}
		return true;
	}
</script>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'report.list_special_report_categories';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'report/display/list_special_report_categories.cfm';
	
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'report.upd_special_report_category';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'report/form/upd_special_report_category.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'report/query/upd_special_report_category.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'report.list_special_report_categories&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'REPORT_CAT_ID=##attributes.REPORT_CAT_ID##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.REPORT_CAT_ID##';	
	

	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'report.del_special_report_category';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'report/query/del_special_report_category.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'report/query/del_special_report_category.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'report.list_special_report_categories&event=list';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'REPORT_CAT_ID=##attributes.REPORT_CAT_ID##';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.REPORT_CAT_ID##';
		
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'report.add_special_report_category';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'report/form/add_special_report_category.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'report/query/add_special_report_category.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'report.list_special_report_categories&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['parameters'] ='REPORT_CAT_ID=##attributes.REPORT_CAT_ID##';
	WOStruct['#attributes.fuseaction#']['add']['Identity'] = '##attributes.REPORT_CAT_ID##';
	

</cfscript>




	
