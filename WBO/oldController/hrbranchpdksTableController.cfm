<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfif month(now()) eq 1>
	<cfparam name="attributes.sal_mon" default="1">
<cfelse>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
</cfif>
<cfinclude template="../hr/ehesap/query/get_ssk_offices.cfm">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.ssk_office" default="0">

<script type="text/javascript">
function open_form_ajax()
{
	adres_ = '<cfoutput>#request.self#?fuseaction=hr.emptypopup_ajax_view_pdks</cfoutput>';
	sal_year_ = document.getElementById('sal_year').value;
	func_ = document.getElementById('func_id').value;
	sal_mon_ = document.getElementById('sal_mon').value;
	ssk_office_all_ = document.getElementById('ssk_office').value;
	ssk_office_ = list_getat(document.getElementById('ssk_office').value,1,'-');
	ssk_no_ = list_getat(document.getElementById('ssk_office').value,2,'-');
	adres_= adres_ + '&sal_mon=' + sal_mon_ + '&sal_year=' + sal_year_ + '&ssk_office=' + ssk_office_all_ + '&func_id=' + func_;
	AjaxPageLoad(adres_,'puantaj_list_layer','1',"Tablo Listeleniyor");
 }
 function send_adres_info()
 {
	adres = '<cfoutput>#request.self#?fuseaction=hr.popup_print_branch_pdks_table</cfoutput>';
	adres +='&ssk_office_all_='+encodeURIComponent(document.getElementById('ssk_office').value);
	adres +='&ssk_office_='+encodeURIComponent(list_getat(document.getElementById('ssk_office').value,1,'-'));
	adres +='&ssk_no_='+encodeURIComponent(list_getat(document.getElementById('ssk_office').value,2,'-'));
	adres +='&sal_mon_='+document.getElementById('sal_mon').value;
	windowopen(adres,'page');	
 }
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.branch_pdks_table';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/branch_pdks_table.cfm';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapHoursController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'OUR_COMPANY_HOURS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-OUR_COMPANY_ID']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.	
</cfscript>