<!--- 
	IBAN numarası girdigimiz yerlerde kullanılmak uzere duzenlenmistir. BK 20100615
 --->
<cfparam name="attributes.fieldId" default=''>
<cfparam name="attributes.iban_code" default=''>
<cfparam name="attributes.width_info" default='165'>
<cfparam name="attributes.iban_maxlength" default='34'>
<cfparam name="attributes.iban_required" default='yes'>

<cfif isdefined("attributes.iban_maxlength") and not len(attributes.iban_maxlength)>
	<cfset attributes.iban_maxlength=34>
</cfif>

<cfoutput>
<cfif attributes.iban_required>
	<input type="text" name="#attributes.fieldId#" id="#attributes.fieldId#" style="width:#attributes.width_info#px" value="#attributes.iban_code#" onBlur="isIBAN(this);" maxlength="#attributes.iban_maxlength#" autocomplete="off">
<cfelse>
	<input type="text" name="#attributes.fieldId#" id="#attributes.fieldId#" style="width:#attributes.width_info#px" value="#attributes.iban_code#" maxlength="#attributes.iban_maxlength#" autocomplete="off">
</cfif>
</cfoutput>
