<cf_xml_page_edit fuseact="assetcare.vehicle_detail">
<cfif not isnumeric(attributes.assetp_id)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
<cfquery name="GET_ASSETP" datasource="#dsn#">
	SELECT 
		ASSET_P.ASSETP,
		ASSET_P.PROPERTY,
		ASSET_P_CAT.MOTORIZED_VEHICLE,
		ASSET_P_CAT.ASSETP_RESERVE,
        ASSET_P.ASSETP_CATID
	FROM
		ASSET_P,
		ASSET_P_CAT
	WHERE
		ASSET_P.ASSETP_ID = #attributes.assetp_id# AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
</cfquery>
<cfif not get_assetp.recordcount or not(get_assetp.motorized_vehicle)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>

<cf_form_box >
 <cfform name="upd_vehicle" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_info" onsubmit="return unformat_fields();">
	<cf_area width="140">
    	 <cfoutput>
            <table>
                <tr><!--- Genel Bilgiler --->
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td width="180"><a href="#request.self#?fuseaction=assetcare.upd_vehicle_info&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang_main no='568.Genel Bilgiler'></a></td>
                </tr>
                <cfif get_assetp.property eq 2>
                <tr>
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td><a href="#request.self#?fuseaction=assetcare.upd_vehicle_rent&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang no='332.Kiralama Bilgisi'></a></td>
                </tr>
                </cfif>
                <cfif get_assetp.property eq 4>
                <tr>
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td><a href="#request.self#?fuseaction=assetcare.upd_vehicle_contract&assetp_id=#attributes.assetp_id#"  class="tableyazi"><cf_get_lang no='491.Sözleşme Bilgisi'></a></td>
                </tr>
                </cfif>
                <tr>
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td width="180"><a href="#request.self#?fuseaction=assetcare.upd_vehicle_license&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang no='525.Ruhsat Bilgisi'></a></td>
                </tr>
                <tr>
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td><a href="#request.self#?fuseaction=assetcare.list_vehicle_history&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang_main no='61.Tarihçe'></a></td>
                </tr>
                <tr>
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td><a href="#request.self#?fuseaction=assetcare.list_vehicle_km_control&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang no='132.KM Kontrol'></a></td>
                </tr>
				<tr>
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td><a href="#request.self#?fuseaction=assetcare.list_vehicle_fuel&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang no='468.Yakıt Kontrol'></a></td>
                </tr>
                <tr>
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td><a href="#request.self#?fuseaction=assetcare.list_vehicle_accident&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang no='456.Kaza Kontrol'></a></td>
                </tr>
                <tr>
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td><a href="#request.self#?fuseaction=assetcare.list_vehicle_punishment&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang no='455.Ceza Kontrol'></a></td>
                </tr>
                <tr>
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td><a href="#request.self#?fuseaction=assetcare.list_vehicle_care&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang no='34.Bakım Sonucu'></a></td>
                </tr>
                <tr>
                    <td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
                    <td width="180"><a href="#request.self#?fuseaction=assetcare.upd_vehicle_rent_contract&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang_main no='25.Anlaşmalar'></a></td>
                </tr>
                <cfif x_assetp_insurance eq 1>
					<tr>
						<td style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
						<td width="180"><a href="#request.self#?fuseaction=assetcare.asset_vehicle_insurance&assetp_id=#attributes.assetp_id#" class="tableyazi"><cf_get_lang no='48.Sigortalar'></a></td>
					</tr>
                </cfif>
            </table>
        </cfoutput>
    </cf_area>
    <cf_area>   
    <cfinclude template="upd_vehicle_info_frame.cfm">
		<!---<cfoutput>
			<iframe scrolling="yes" width="100%" height="600" frameborder="0" name="vehicle_frame" id="vehicle_frame" src="#request.self#?fuseaction=assetcare.upd_vehicle_info&assetp_catid=#GET_ASSETP.ASSETP_CATID#&assetp_id=#attributes.assetp_id#"></iframe>
		</cfoutput> --->
    </cf_area>
  </cfform>
</cf_form_box>
</cfif>
