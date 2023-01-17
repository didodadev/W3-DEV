
<!---
    File :          AddOns\Yazilimsa\Protein\reactor\CustomTags\send_woc.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          26.06.2021
    Description :   Protein sayfalarından woc a gider / woc: \AddOns\Yazilimsa\Protein\reactor\PMO\woc.cfm
    Notes :         frienly url ile ilişkili action type ve action id değerlerini woc'a iletir

	*required olanlar * ile belitilmiştir.
	Params:			template		: şablon id 
					*action_type	: output edilecek kayıt primary key | content_id 
					*action_id		: ilgili kayıt id si | #cntid#
--->
<cfparam name="attributes.fuseaction" default=''>
<cfparam name="attributes.event" default="">
<cfparam name="attributes.action_type" default="#(LEN(caller.GET_PAGE.ACTION_TYPE) NEQ 0 AND LEN(caller.GET_PAGE.ACTION_ID) NEQ 0) ? caller.GET_PAGE.ACTION_TYPE:''#">
<cfparam name="attributes.action_id" default='#(LEN(caller.GET_PAGE.ACTION_TYPE) NEQ 0 AND LEN(caller.GET_PAGE.ACTION_ID) NEQ 0) ? caller.GET_PAGE.ACTION_ID:''#'>
<cfparam name="attributes.related_wo" default='#(structKeyExists(caller.PAGE_DATA, 'RELATED_WO') AND LEN(caller.PAGE_DATA.RELATED_WO)) ? caller.PAGE_DATA.RELATED_WO:''#'>


<cfset woc = {
	ac:attributes.action_type,<!--- action typr --->
	ai:attributes.action_id,<!--- action id --->
	rw:attributes.related_wo <!--- related wo --->
}>
<cfset woc_token = #encrypt("#Replace(SerializeJSON(woc),'//','')#",'w3woc','CFMX_COMPAT','Hex')#>

<div class="btnPointer font-blue text-right" data-jop="send_woc">
	<cfoutput>
		<a class="color-darkCyan" href="/woc?woctoken=#woc_token#"><i class="fa fa-print"></i> WOC</a>
	</cfoutput>
</div>