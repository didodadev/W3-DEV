
<!---
Author :        Melek Kocabey<melekkocabey@workcube.com>
Date :          16.07.2020
Description :   Satınalma İç Talep sayfasının det eventi.
--->
<cf_catalystHeader>
<div class="col col-9 col-xs-12">
    <cf_box>
    <cfset attributes.internaldemand_id = attributes.id>
    <cfinclude template="../../objects/display/list_internaldemand_relation.cfm">
    <!--- İç Talep Karşılaştırma Raporu ---></cf_box>
</div>
<div class="col col-3 col-xs-12">
    <cfinclude template="../../correspondence/form/dsp_internaldemand_asset.cfm">
</div>