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

<cf_ajax_list>
    <tbody>
        <cfif Get_Customer_Cards.RecordCount>
            <cfoutput query="Get_Customer_Cards">
            <tr>
                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=member.popup_detail_customer_cards&card_id=#card_id#','small','popup_detail_customer_cards');" <cfif Get_Customer_Cards.Card_Status eq 0>style="color:999999;"<cfelse>class="tableyazi"</cfif>>#card_no#</a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
