<!---
    File :          AddOns\Yazilimsa\Protein\reactor\PMO\woc_preview.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          29.06.2021
    Description :   workcube output center önizleme yazdırma yapar
    Notes :         
--->

<cfparam  name="attributes.woctoken" default="">
<cfset send_woc = deserializeJSON(decrypt(attributes.woctoken,'w3woc','CFMX_COMPAT','Hex'))>
<cfparam  name="attributes.preview" default="">
<cfparam  name="attributes.action_type" default="#send_woc.AC#">
<cfparam  name="attributes.action_id" default="#send_woc.AI#">
<cfset WOC = createObject('component','CFC.SYSTEM.WOC')>
<cfset GET_TEMPLATES = WOC.GET_TEMPLATES(RELATED_WO:send_woc.RW, TEMPLATE:attributes.preview)>


<cfif len(attributes.preview)>
    <cfdocument  format="PDF" margintop="0" marginbottom="0" marginleft="0" marginright="0"> 
        <cfinclude  template="/catalyst/#GET_TEMPLATES.OUTPUT_TEMPLATE_PATH#">
    </cfdocument>    
<cfelse>
    Şablon Seçiniz
</cfif>
<cfabort>
