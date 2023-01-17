<cfquery name="GET_PAYMETHODS" datasource="#DSN3#">
	SELECT
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO,
		CPT.POS_TYPE,
		CPT.NUMBER_OF_INSTALMENT, 
		CP.SERVICE_COMM_MULTIPLIER COMMISSION_MULTIPLIER,
		C.IS_BEFORE_PAYMENT
	FROM
		CREDITCARD_PAYMENT_TYPE CPT,
		CAMPAIGN_PAYMETHODS CP,
		CAMPAIGNS C
	WHERE
		C.CAMP_ID = CP.CAMPAIGN_ID AND
		CP.PAYMETHOD_ID = CPT.PAYMENT_TYPE_ID AND
		CP.COMMISSION_RATE IS NOT NULL AND
		CP.CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
		CP.USED_IN_CAMPAIGN = 1 AND
		CPT.IS_ACTIVE = 1 AND
		CPT.POS_TYPE IS NOT NULL
	ORDER BY
		CPT.CARD_NO
</cfquery>
<cfif get_paymethods.recordcount>		
    <table style="width:100%;">
        <cfoutput query="get_paymethods">
            <tr>
                <td><li>#card_no#</li></td>                 		
            </tr>
        </cfoutput>
        <cfif isdefined("session.pp.userid") and get_paymethods.is_before_payment eq 1>
            <tr>
                <td><a href="javascript://" onclick="windowopen('<cfoutput><cfif use_https>#https_domain#</cfif>#request.self#?fuseaction=objects2.popup_add_online_pos&campaign_id=#attributes.camp_id#</cfoutput>','medium');" class="tableyazi"><cf_get_lang no='271.Kampanyadan Borcumu Ödemek İstiyorum'></a></td>
            </tr>
        </cfif>
    </table>
</cfif>
