<cfset getPageContext().getCFOutput().clear()>
<cfobject name="eventfso" type="component" component="WDO.catalogs.builders.packagebuilder.fsobuilder">
<cfset eventfso.init()>
<cfset eventfso.generate(attributes.id)>

<cfoutput>Yayinlama basarili</cfoutput>
<cfabort>