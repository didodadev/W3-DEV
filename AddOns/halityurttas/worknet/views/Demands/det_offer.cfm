<cfsetting showdebugoutput="no">
<cfquery name="get_detail_offer" datasource="#dsn#">
	SELECT 
		WDO.*,
		WD.DEMAND_HEAD 
	FROM 
		WORKNET_DEMAND_OFFER WDO
		RIGHT JOIN WORKNET_DEMAND WD ON WDO.DEMAND_ID = WD.DEMAND_ID
	WHERE 
		DEMAND_OFFER_ID = #attributes.demand_offer_id#
</cfquery>
<cfquery name="updOfferStatus" datasource="#dsn#">
	UPDATE WORKNET_DEMAND_OFFER SET OFFER_STATUS = 0 WHERE DEMAND_OFFER_ID = #attributes.demand_offer_id#
</cfquery>
<table border="0" width="100%">
	<tr valign="top">
        <td>
            <table width="100%">

            <cfoutput query="get_detail_offer">
                <tr>
                    <th width="120"><cf_get_lang_main no ='217.Açıklama'></span></th>
                    <td colspan="5">#detail#</td>
                </tr>
                <tr>
                    <th width="120"><cf_get_lang no ='106.Toplam Bedel'></th>
                    <td width="25%"><cfif len(get_detail_offer.offer_total)>#Tlformat(get_detail_offer.offer_total)#&nbsp;#get_detail_offer.offer_money#</cfif></td>
                    <th width="120"><cf_get_lang_main no='1703.Sevk Yöntemi'></th>
                    <td width="25%">#ship_method#</td>
                    <th width="120"><cf_get_lang_main no='233.Teslim Tarihi'></th>
                    <td width="25%">#dateformat(deliver_date,'dd/mm/yyyy')#</td>
                </tr>
                <tr>
                    <th width="120"><cf_get_lang_main no='1037.Teslim Yeri'></th>
                    <td width="25%">#deliver_addres#</td>
                    <th width="120"><cf_get_lang_main no ='1104.Ödeme Yöntemi'></th>
                    <td width="25%">#paymethod#</td>
                    <cfif len(get_detail_offer.offer_file)>
                    <th width="120"><cf_get_lang_main no ='56.Belge'></th>
                    <td width="25%"><cf_get_server_file output_file="worknet/#get_detail_offer.offer_file#" output_server="#get_detail_offer.offer_file_server_id#" output_type="2" image_link="1" small_image="/images/asset.gif" image_width="17" image_height="19"></td>
                    </cfif>
                    <cfif (isdefined("session.ep") and (get_detail_offer.employee_id eq session.ep.userid)) or (isdefined("session.pp.company_id") and (get_detail_offer.company_id eq session.pp.company_id) and (get_detail_offer.partner_id eq session.pp.userid)) or (isdefined("session.ww.userid") and (get_detail_offer.consumer_id eq session.ww.userid))>
                    <td width="25%"><a href="javascript:" onClick="windowopen('#request.self#?fuseaction=worknet.popup_upd_demand_offer&demand_offer_id=#get_detail_offer.demand_offer_id#','medium')"><img src="/images/pod_edit.gif" title="<cf_get_lang_main no ='1306.Düzenle'>" border="0" align="absmiddle"><cf_get_lang no ='110.Güncellemek İçin Tıklayınız'> </a></td>
                    </cfif>
                    <cfif isdefined("session.pp") and isdefined('attributes.offer_type') and attributes.offer_type eq 1>
                    <td width="25%"><img src="/images/pod_edit.gif" title="<cf_get_lang_main no='1744.Cevapla'>" border="0" align="absmiddle">
                        <a href="#request.self#?fuseaction=worknet.sent_message&member_id=#attributes.partner_id#&subject=#get_detail_offer.demand_head#"><cf_get_lang_main no='1744.Cevapla'></a></td>
                    </cfif>
                </tr>
            </cfoutput>
                
        </table>
		</td>
	</tr>
</table>