<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
	<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
	<cfinclude template="../hr/ehesap/query/get_ssk_offices.cfm">
	<cfquery name="get_our_comp_and_branchs" datasource="#DSN#">
		SELECT
			NICK_NAME,
			COMP_ID
		FROM
			OUR_COMPANY
		ORDER BY
			NICK_NAME
	</cfquery>
	<cfquery name="ZONES" datasource="#DSN#">
		SELECT ZONE_NAME, ZONE_ID, ZONE_STATUS FROM ZONE ORDER BY ZONE_NAME
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function kontrol()
		{
			if(document.employee.keyword.value == '' && document.employee.zone_id.value == '' && document.employee.comp_id.value == '' && document.employee.SSK_OFFICE.value == '')
			{
				alert("<cf_get_lang dictionary_id='54636.En Az Bir Filtre Seçmelisiniz'>");
				return false;
			}
			return true;
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.popup_form_upd_personel';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/form/upd_personel.cfm';
</cfscript>
