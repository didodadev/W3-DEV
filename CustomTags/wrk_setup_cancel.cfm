<cfparam name="attributes.cancel_type" default="">
<cfparam name="attributes.cancel_id" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.width" default="100">
<cfparam name="attributes.message" default="">

<cfset setupCancel = CreateObject('V16.settings.cfc.setupCancel') /> 
<cfset setupCancel.dsn3 = caller.DSN3>
<cfset get_cancel_types = setupCancel.getCancelTypeFnc(cancel_type:attributes.cancel_type,is_active:attributes.is_active)>

<select name="cancel_type_id" id="cancel_type_id" data-msg="<cfoutput>#attributes.message#</cfoutput>" style="width:<cfoutput>#attributes.width#</cfoutput>px;">
	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
    <cfoutput query="get_cancel_types">
    	<option value="#cancel_id#" <cfif is_active neq 1>disabled="disabled"</cfif> <cfif len(attributes.cancel_id) and attributes.cancel_id eq cancel_id>selected</cfif>>#cancel_name#</option>
    </cfoutput>
</select>

