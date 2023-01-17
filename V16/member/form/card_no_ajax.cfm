<!--- Kart Numaralari; Bireysel Uye ve Kurumsal Uye Calisani Ekranlarinda Kullanilmaktadir FBS 20110222 --->
<cfsetting showdebugoutput="no">
<cfif isDefined("attributes.cid") and Len(attributes.cid)>
	<cfparam name="attributes.action_type" default="CONSUMER_ID">
	<cfparam name="attributes.action_id" default="#attributes.cid#">
<cfelseif isDefined("attributes.pid") and Len(attributes.pid)>
	<cfparam name="attributes.action_type" default="COMPANY_ID">
	<cfparam name="attributes.action_id" default="#attributes.pid#">
<cfelse>
	<cfparam name="attributes.action_type" default="PARTNER_ID">
	<cfparam name="attributes.action_id" default="#attributes.pid#">
</cfif>
<cfquery name="Get_Customer_Cards" datasource="#dsn#">
	SELECT
		CARD_ID,
		CARD_NO,
		CARD_STATUS,
		CARD_STARTDATE
	FROM
		CUSTOMER_CARDS
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
		ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">
</cfquery>
<table class="ajax_list">
    <cfif Get_Customer_Cards.RecordCount>
        <cfoutput query="Get_Customer_Cards">
            <tr>
                <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=member.popup_detail_customer_cards&card_id=#card_id#');">#card_no#</td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>
