<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
    <cfparam name="attributes.sal_year" default="#session.ep.period_year#">
    <cfif month(now()) eq 1>
        <cfparam name="attributes.sal_mon" default="1">
    <cfelse>
        <cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
    </cfif>
    <cfinclude template="../hr/ehesap/query/get_ssk_offices.cfm">
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.ssk_office" default="0">
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
	function run_form_ajax()
	{
		adres_ = '<cfoutput>#request.self#?fuseaction=hr.emptypopup_ajax_run_shift</cfoutput>';
		sal_year_ = document.getElementById('sal_year').value;
		sal_mon_ = document.getElementById('sal_mon').value;
		ssk_office_ = document.getElementById('ssk_office').value;
		adres_= adres_ + '&sal_mon=' + sal_mon_ + '&sal_year=' + sal_year_ + '&ssk_office=' + ssk_office_;
		AjaxPageLoad(adres_,'menu_puantaj_1','1',"Hesaplanıyor");
	}
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.shift_hesapla';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/shift_hesapla.cfm';
</cfscript>