
<!---
    File :          C:\Project\devcatalyst\CustomTags\publishing_settings.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          01.05.2021
    Description :   Protein Object | PO - yayın ayarları widgetını açan buton
    Notes :         frienly url alan module objelerinin protein pageleri ile ilişkisini organize eder
					AddOns\Yazilimsa\Protein\view\po\publishing_settings.cfm i openBoxDraggable ile açar
	Params:			ÖR: content.list_content&event=det&cntid=59 için
					fuseaction	: fuseaction | content.list_conten
					event		: sayfa eventi | det
					action_type	: det sayfası için kaydı getiren attr | cntid 
					action_id	: action_id ilgili kayıt id si | #cntid#
--->
<cfparam name="attributes.fuseaction" default=''>
<cfparam name="attributes.event" default="">
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.action_id" default=''>
<cfparam name="attributes.icon" default="false">
<cfif isDefined("attributes.icon") and attributes.icon eq 'true'>
	<div class="text-center" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.widget_loader&widget_load=publishing_settings&faction=#attributes.fuseaction#&event=#attributes.event#&action_type=#attributes.action_type#&action_id=#attributes.action_id#');</cfoutput>">
		<i class="icon-link"></i>
	</div>
<cfelse>
	<div class="additionalinformation btnPointer font-blue text-center" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.widget_loader&widget_load=publishing_settings&faction=#attributes.fuseaction#&event=#attributes.event#&action_type=#attributes.action_type#&action_id=#attributes.action_id#');</cfoutput>">
		<i class="icon-link"></i> Protein Friendly Url
	</div>
</cfif>
