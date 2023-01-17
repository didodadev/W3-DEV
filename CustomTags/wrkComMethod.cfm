<!--- Iletisim Yontemleri FBS --->
<cfparam name="attributes.compenent_name" default="getComMethod"><!--- Compenent- cfc/query sayfasi --->
<cfparam name="attributes.isDefault" default="0"><!--- Selextboxta Kullanilacak Default Deger Gelsin Mi 1-0 --->
<cfparam name="attributes.FieldName" default="ComMethod"><!--- Selextboxta Kullanilacak Name --->
<cfparam name="attributes.FieldId" default="ComMethod_Id"><!--- Selextboxta Kullanilacak Id --->
<cfparam name="attributes.Width" default="120"><!--- Formdaki Inputun Genisligi --->
<cfparam name="attributes.Lang_Main" default="322.Seçiniz"><!--- Inputta Name Main --->
<cfparam name="attributes.Lang" default=""><!--- Inputta Name --->
<cfif ListLen(attributes.Lang,'.')>
	<cfset LangValue = Evaluate("caller.lang_array.item[#Listfirst(attributes.Lang,'.')#]")>
<cfelseif ListLen(attributes.Lang_Main,'.')>
	<cfset LangValue = Evaluate("caller.getLang('main',#Listfirst(attributes.Lang_Main,'.')#)")>
<cfelse>
	<cfset LangValue = "">
</cfif>
<cfscript>
	CreateCompenent = CreateObject("component","/../workdata/#attributes.compenent_name#");
	QComp = CreateCompenent.getCompenentFunction(); //isDefault:attributes.isDefault
</cfscript>
<cfoutput>
<select name="#attributes.fieldId#" id="#attributes.fieldId#" style="width:#attributes.width#px;">
    <option value="">#LangValue#</option>
	<cfloop query="QComp">
        <option value="#Evaluate('#attributes.FieldId#')#" <cfif (isdefined("attributes.#attributes.FieldId#") and Len(Evaluate("attributes.#attributes.FieldId#")) and Evaluate("attributes.#attributes.FieldId#") eq Evaluate('#attributes.FieldId#')) or ((not isdefined("attributes.#attributes.FieldId#") or not Len(Evaluate("attributes.#attributes.FieldId#"))) and isdefined("attributes.isDefault") and attributes.isDefault eq 1 and QComp.Is_Default eq 1)>selected</cfif>>#Evaluate('#attributes.fieldName#')#</option>
    </cfloop>
</select>
</cfoutput>
