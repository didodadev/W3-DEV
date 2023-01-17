<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="ehesap">
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
	<cfparam name="attributes.ssk_statute" default="1">
	<cfparam name="attributes.puantaj_type" default="-1">
	<cfparam name="attributes.kanun" default="0000">
	<cfparam name="attributes.sal_year" default="#year(now())#">
	<cfif not isDefined("attributes.printme")>
		<cfinclude template="../hr/ehesap/query/get_ssk_offices.cfm">
	</cfif>
	
	<cfif isdefined("attributes.ssk_office")>
		<cfinclude template="../hr/ehesap/query/get_aylik.cfm">
		<cfinclude template="../hr/ehesap/query/get_ssk_monthly_premium.cfm">
		<cfif not get_insurance_ratio.recordcount>
			<script type="text/javascript">
				alert("#dateformat(last_month_1,'dd/mm/yyyy')# - #dateformat(last_month_30,'dd/mm/yyyy')# <cf_get_lang no ='873.aralığında geçerli SSK Çarpanları Tanımlı Değil'> !");
				history.back();
			</script>
			<cfexit method="exittemplate">
		</cfif>
		<cfset page_ = 1>
		<cfif get_puantaj_rows.recordcount lte 7>
			<cfset to_count = 1>
		<cfelse>
			<cfset to_count = ceiling((get_puantaj_rows.recordcount-7)/25)+1>
		</cfif>
		<cfset gun_1_last_page = 0>
		<cfset gun_2_last_page = 0>
		<cfset pek_1_last_page = 0>
		<cfset pek_2_last_page = 0>
		<cfset odenek1_last_page = 0>
		<cfset odenek2_last_page = 0>
		<cfset uigun_1_last_page = 0>
		<cfset uigun_2_last_page = 0>
		<cfset izin_ucret_1_last_page = 0>
		<cfset izin_ucret_2_last_page = 0>
		<cfset ssk_1_last_page = 0>
		<cfset ssk_2_last_page = 0>
	</cfif>
</cfif>

<cfif isdefined("attributes.printme")>
	<script type="text/javascript">
		function waitfor(){
		window.close();
		}	
		setTimeout("waitfor()",3000);
		window.print();
	</script>
</cfif>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.popup_ssk_month_premium';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/ssk_month_premium.cfm';
</cfscript>
