<cf_get_lang_set module_name="myhome">
<!--- gündem-ben altındaki harcamalarım sayfası --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_date1" default='#dateformat(date_add("d", -1, now()),"dd/mm/yyyy")#'>
<cfparam name="attributes.search_date2" default='#dateformat(now(),"dd/mm/yyyy")#'>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.expense_employee" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.form_exist" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project" default="">
<cfif len(attributes.search_date1)>
  <cf_date tarih='attributes.search_date1'>
</cfif>
<cfif len(attributes.search_date2)>
  <cf_date tarih='attributes.search_date2'>
</cfif>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cfif  isdefined("attributes.form_exist")>
	<cfinclude template="../myhome/query/get_expense_rows.cfm">
	<cfparam name="attributes.totalrecords" default="#get_expense_item_row_all.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif len(attributes.form_exist)>
	<cfif  get_expense_item_row_all.recordcount>
		<cfscript>
			toplam1 = 0;
			toplam2 = 0;
			toplam3 = 0;
			toplam4 = 0;
			toplam5 = 0;
			toplam6 = 0;
		</cfscript>
		<cfoutput query="get_expense_item_row_all">
			<cfscript>
				toplam1 = toplam1 + amount;				
				toplam2 = toplam2 + amount_kdv;
				toplam3 = toplam3 + total_amount;
			</cfscript>
		</cfoutput>
		<cfoutput query="get_expense_item_row_all" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
			<cfscript>
				toplam4 = toplam4 + amount;				
				toplam5 = toplam5 + amount_kdv;
				toplam6 = toplam6 + amount + amount_kdv;
			</cfscript>
		</cfoutput>
	</cfif>
</cfif>
<cfscript>
		url_str = "" ;
	if ( len(attributes.keyword) )
		url_str = "#url_str#&keyword=attributes.keyword";
	if ( len(attributes.search_date1) )
		url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,'dd/mm/yyyy')#";
	if ( len(attributes.search_date2) )
		url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,'dd/mm/yyyy')#";
	if ( len(attributes.employee_id) )
		url_str = "#url_str#&employee_id=#attributes.employee_id#";
	if ( len(attributes.expense_employee) )
		url_str = "#url_str#&expense_employee=#attributes.expense_employee#";
	if ( len(attributes.expense_item_id) )
		url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#";
	if ( len(attributes.expense_center_id) )
		url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#";
	if ( len(attributes.activity_type) )
		url_str = "#url_str#&activity_type=#attributes.activity_type#";
	if ( len(attributes.form_exist) and isdefined("attributes.form_exist"))
		url_str = "#url_str#&form_exist=#attributes.form_exist#";
</cfscript>

<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('keyword').focus();
	});
</script>
<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
	{
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	}
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.my_expenses';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/my_expenses.cfm';
</cfscript>
