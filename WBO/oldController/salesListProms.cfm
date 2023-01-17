<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<!--- bu sayfa ve iliskili sayfalardaki tum degisiklikler tum domainlerde calisacak sekilde yapilmalidir  --->
    <cfif fusebox.circuit is 'store'>
        <cfset attributes.branch_id = listgetat(session.ep.user_location,2,'-')>
    </cfif>
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfif isdefined("attributes.is_submitted")>
        <cfset arama_yapilmali = 0>
    <cfinclude template="../objects/query/get_proms.cfm">
    <cfelse>
        <cfset arama_yapilmali = 1>
        <cfset proms.recordcount = 0>
    </cfif>
    <cfparam name="attributes.keyword" default=''>
    <cfparam name="attributes.price_catid" default="-2">
    <cfparam name="attributes.page" default=1>
    <cfif isDefined("session.ep.maxrows")>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfelse>
        <cfparam name="attributes.maxrows" default='#session.pp.maxrows#'><!--- partner dan da cagriliyor --->
    </cfif>
    <cfparam name="attributes.totalrecords" default="#proms.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <cfif isdate(attributes.start_date)>
        <cfset attributes.start_date = dateformat(attributes.start_date, "dd/mm/yyyy")>
    </cfif>
    <cfif isdate(attributes.finish_date)>
        <cfset attributes.finish_date = dateformat(attributes.finish_date, "dd/mm/yyyy")>
    </cfif>
    <cfinclude template="../objects/query/get_price_cats2.cfm">
    <!--- <cfinclude template="../query/get_discount_types.cfm"> --->
<cfelseif (isdefined("attributes.event") and attributes.event is 'det')>
	<cfinclude template="../objects/query/get_det_promotion.cfm">
		<cfif len(get_det_promotion.price_catid)>
            <cfquery name="PRICE_CATS" datasource="#dsn3#">
                SELECT
                    PRICE_CAT
                FROM
                    PRICE_CAT
                WHERE
                    PRICE_CATID = #get_det_promotion.price_catid#
                ORDER BY
                    PRICE_CAT
            </cfquery>
        </cfif>
</cfif>

<script type="text/javascript">
	//Event : list
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		document.getElementById('keyword').focus();
	</cfif>	
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';

	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'sales.list_proms';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'objects/display/popup_detail_promotion.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'prom_id=##attributes.prom_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.prom_id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_proms';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'objects/display/list_proms.cfm';
	// Upd //
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>