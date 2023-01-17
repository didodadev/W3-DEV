<cfparam name="attributes.compenent_name" default="get_paymethod_autocomplete"><!--- component id --->
<cfparam name="attributes.payMethodTip" default="1,2" type="string"><!--- 1 ise klasik,2 ise kredi kartı sistemi --->
<cfparam name="attributes.fieldName" default="payment_type"><!--- Autocomplete teki arama yapılacak input--->
<cfparam name="attributes.fieldId" default="payment_type_id"><!--- Autocomplete ten dönen klasik ödeme tipinin id sinin inputu. Veritabanında kullanılacak veri --->
<cfparam name="attributes.creditCardFieldId" default="payment_type_creditcard_id"><!--- Autocomplete ten dönen kredi kartı ödeme tipinin id sinin inputu. Veritabanında kullanılacak veri --->
<cfparam name="attributes.width" default="120"><!--- imput width --->
<cfparam name="attributes.subscription_id" default=""><!--- Update sayfasına gidecekse gönderilecek parametre --->
<cfparam name="attributes.formName" default="form_basket"><!--- popup pencerede seçilen bir kaydın hangi forma akarılacağı --->
<cfparam name="attributes.window" default="0" type="integer"><!--- Açılacak popup pencerenin açılıp açılmayacağının kontrolü --->

<cfquery name="GET_SUBSCRIPTION" datasource="#caller.DSN3#">
	SELECT PAYMENT_TYPE_ID,PAYMENT_TYPE_CREDITCARD_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
</cfquery>

<cfif not GET_SUBSCRIPTION.PAYMENT_TYPE_ID is "">
	<cfquery name="get_payment_type" datasource="#caller.DSN#">
		SELECT 
			PAYMETHOD_ID,PAYMETHOD 
		FROM 
			SETUP_PAYMETHOD 
		WHERE 
			PAYMETHOD_ID = #GET_SUBSCRIPTION.PAYMENT_TYPE_ID#
	</cfquery>
<cfelse>
	<cfset get_payment_type.recordcount = 0>
</cfif>

<cfif not GET_SUBSCRIPTION.PAYMENT_TYPE_CREDITCARD_ID is "">
	<cfquery name="card_payment_type" datasource="#caller.DSN3#">
		SELECT  
			PAYMENT_TYPE_ID, 
			CARD_NO
		FROM  
			CREDITCARD_PAYMENT_TYPE 
		WHERE 
			PAYMENT_TYPE_ID =  #GET_SUBSCRIPTION.PAYMENT_TYPE_CREDITCARD_ID#
	</cfquery>
<cfelse>
	<cfset card_payment_type.recordcount = 0>
</cfif>

<cfoutput>
	<div class="input-group">
	<input type="hidden" name="#attributes.fieldId#"  id="#attributes.fieldId#" value="<cfif get_payment_type.recordcount>#get_payment_type.paymethod_id#</cfif>">
	<input type="hidden" name="#attributes.creditCardFieldId#" id="#attributes.creditCardFieldId#" value="<cfif card_payment_type.recordcount and not get_payment_type.recordcount>#card_payment_type.payment_type_id#</cfif>">
	<input type="text" name="#attributes.fieldName#" id="#attributes.fieldName#" value="<cfif get_payment_type.recordcount>#get_payment_type.paymethod#<cfelseif card_payment_type.recordcount>#ReReplaceNoCase('#card_payment_type.CARD_NO#','<[^>]*>','','ALL')#</cfif>" onFocus = "AutoComplete_Create('#attributes.fieldName#','PAYMETHOD','PAYMETHOD','get_paymethod_autocomplete','\'#attributes.payMethodTip#\'','PAYMETHOD_ID,PAYMENT_TYPE_ID','#attributes.fieldId#,#attributes.creditCardFieldId#')">
	<cfif attributes.window>
		<cfif ListFind(attributes.payMethodTip,1,',') and ListFind(attributes.payMethodTip,2,',')>
			<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&payMethodTip=1,2&field_id=#attributes.formName#.#attributes.fieldId#&field_name=#attributes.formName#.#attributes.fieldName#&field_card_payment_name=#attributes.formName#.#attributes.fieldName#&field_card_payment_id=#attributes.formName#.#attributes.creditCardFieldId#','list','popup_paymethods');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></span>
		<cfelseif ListFind(attributes.payMethodTip,1,',')>
			<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&payMethodTip=1&field_id=#attributes.formName#.#attributes.fieldId#&field_name=#attributes.formName#.#attributes.fieldName#','list','popup_paymethods');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></span>
		<cfelseif ListFind(attributes.payMethodTip,2,',')>
			<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&payMethodTip=2&field_card_payment_name=#attributes.formName#.#attributes.fieldName#&field_card_payment_id=#attributes.formName#.#attributes.creditCardFieldId#','list','popup_paymethods');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></span>
		</cfif>
	</cfif>
    </div>
</cfoutput>
