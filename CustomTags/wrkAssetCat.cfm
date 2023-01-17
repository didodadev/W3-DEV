<!--- Varlik Kategorileri BK --->
<cfparam name="attributes.compenent_name" default="getAssetCat2"><!--- Compenent- cfc/query sayfasi --->
<cfparam name="attributes.FieldName" default="assetp_cat"><!--- Selextboxta Kullanilacak Name --->
<cfparam name="attributes.FieldId" default="assetp_catid"><!--- Selextboxta Kullanilacak Id --->
<cfparam name="attributes.Width" default="120"><!--- Formdaki Inputun Genisligi --->
<cfparam name="attributes.Lang_main" default=""><!--- Inputta Gorunecek Default Main Deger --->
<cfparam name="attributes.Lang" default=""><!--- Inputta Gorunecek Default Deger --->
<cfparam name="attributes.onchange_action" default=""><!--- deger secildiginde calisicak fonksiyon --->
<cfparam name="attributes.it_asset" default="0"><!--- It varlık ise 1 gönderilsin--->
<cfparam name="attributes.is_motorized" default="0"><!--- motorlu taşıt ise 1 gönderilsin--->
<cfif Len(attributes.Lang_main)>
	<cfset LangValue = Evaluate("caller.getLang('main',#Listfirst(attributes.Lang_main,'.')#)")>
<cfelseif  Len(attributes.Lang)>
	<cfset LangValue = Evaluate("caller.getLang('#attributes.moduleName#',#Listfirst(attributes.lang,'.')#)")>
<cfelse>
	<cfset LangValue = ''>
</cfif>
<cfscript>
	CreateCompenent = CreateObject("component","/../workdata/#attributes.compenent_name#");
	queryComponent = CreateCompenent.getCompenentFunction(it_asset : attributes.it_asset, is_motorized : attributes.is_motorized);
</cfscript>
<cfoutput>
<select name="#attributes.fieldId#" id="#attributes.fieldId#" style="width:#attributes.width#px;" <cfif len(attributes.onchange_action)>onchange="#attributes.onchange_action#"</cfif>>
	<option value="">#LangValue#</option>
	<cfloop query="queryComponent">
        <option value="#Evaluate('#attributes.fieldId#')#" <cfif isdefined("attributes.#attributes.fieldId#") and Len(Evaluate("attributes.#attributes.fieldId#")) and Evaluate("attributes.#attributes.fieldId#") eq Evaluate('#attributes.fieldId#')>selected</cfif>>#Evaluate('#attributes.fieldName#')#</option>
    </cfloop>
</select>
</cfoutput>
