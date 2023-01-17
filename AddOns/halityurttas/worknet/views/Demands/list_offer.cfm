<cfinclude template="../../config.cfm">
<cfquery name="get_demand_offer" datasource="#dsn#">
	SELECT 
		WO.*,
		(WO.OFFER_TOTAL * SM.RATE2 / SM.RATE1) AS TOTAL_OFFER 
	FROM 
		WORKNET_DEMAND_OFFER WO,
		SETUP_MONEY SM
	WHERE 
		WO.DEMAND_ID = #attributes.demand_id# AND
		SM.MONEY = WO.OFFER_MONEY
		<cfif isdefined("session.ep")>
			AND SM.PERIOD_ID = #session.ep.period_id#
		<cfelseif isdefined("session.pp")>
			AND SM.PERIOD_ID = #session.pp.period_id#
		<cfelseif isdefined("session.ww")>
			AND SM.PERIOD_ID = #session.ww.period_id#
		</cfif>
	ORDER BY
		WO.RECORD_DATE
</cfquery>
<table width="100%" cellpadding="2" cellspacing="1">
    <tr height="22" class="worknet-header">
        <td class="txtbold"><cf_get_lang_main no ='1983.Katılımcı'></td>
        <td class="txtbold"><cf_get_lang no ='83.Teklif Tarihi'></td>
        <td class="txtbold" align="right"><cf_get_lang no ='104.Teklif Bedeli'></td>
        <td width="100" align="center"></td>
    </tr>
    <cfif get_demand_offer.recordcount>
        <cfoutput query="get_demand_offer">
            <tr height="22">
                <td>
                    <cfif len(partner_id)>
                        <a href="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['company']##company_id#" class="tableyazi" title="<cf_get_lang no ='15.Firma Detay'>">#get_par_info(partner_id,0,0,0)#</a>
                    <cfelseif len(consumer_id)>
                        #get_cons_info(consumer_id,0,0)#
					<cfelseif len(employee_id)>
                        #get_cons_info(consumer_id,0,0)#
                    </cfif>
                </td>
                <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                <td align="right">#Tlformat(offer_total)#&nbsp;#offer_money#</td>
                <td align="center" width="100" class="txtbold">
                    <a href="javascript:" onClick="open_div_price(#currentrow#,#demand_offer_id#)">>><cf_get_lang no ='27.Detaylı Bilgi'></a>
                </td>
            </tr>
            <tr style="display:none;" id="my_row#currentrow#" class="worknet-row ">
                <td colspan="10">
                    <div id="detail_offer#currentrow#" style="background-color: #colorrow#; display:none; outset cccccc;"></div>
                </td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr class="worknet-row">
            <td colspan="6" height="20"><cf_get_lang_main no ='72.Kayıt Yok'> !</td>
        </tr>
    </cfif>
</table>
<cfoutput>
	<script type="text/javascript">
	function open_div_price(no,demand_offer_id)
	{
		show_hide('my_row' + no);
		show_hide('detail_offer' + no);
		AjaxPageLoad('#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['det-offer']['fuseaction']#' + demand_offer_id, 'detail_offer' + no);
	}
	</script>
</cfoutput>


