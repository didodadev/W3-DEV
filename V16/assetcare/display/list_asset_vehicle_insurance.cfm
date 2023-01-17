<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
<cfquery name="ASSET_INSURANCE" datasource="#DSN#">
	SELECT
        INSURANCE_ID,
        ASSETP_ID,
        INSURANCE_NAME_ID,
        POLICY_NO,
        INSURANCE_COMPANY,
        INSURANCE_START_DATE,
        INSURANCE_FINISH_DATE,
        COMPANY.FULLNAME,
        ASSET_CARE_CAT.ASSET_CARE,
		INSURANCE_TOTAL
    FROM
    	ASSET_P_INSURANCE,
        ASSET_CARE_CAT,
        COMPANY
    WHERE
	    ASSET_CARE_CAT.ASSET_CARE_ID = ASSET_P_INSURANCE.INSURANCE_NAME_ID AND
   		COMPANY.COMPANY_ID = ASSET_P_INSURANCE.INSURANCE_COMPANY AND
    	ASSETP_ID = #attributes.assetp_id#
</cfquery>
<cf_date tarih='attributes.insurance_start_date'>
<cf_date tarih='attributes.insurance_finish_date'>
<cfset pageHead = "#getLang('assetcare',48)# : #getLang('main',1656)# : #get_assetp.assetp#">
<cf_catalystHeader>
<div id="insurance_div">
    <cf_box title="#getLang('assetcare',48)# : #getLang('main',1656)# : #get_assetp.assetp#">
    <cf_flat_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='47920.Sigorta Adı'></th>
                <th><cf_get_lang dictionary_id='47922.Poliçe Numarası'></th>
                <th><cf_get_lang dictionary_id='48380.Sigorta Şirketi'></th>
				<th><cf_get_lang dictionary_id='48039.Poliçe Prim Tutarı'></th>
                <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
                <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                <th><cf_get_lang dictionary_id='47924.Kalan Süre'>(<cf_get_lang dictionary_id='57490.Gün'>)</th>
                <!-- sil -->
                <th width="15" class="text-right">
                    <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=assetcare.popup_add_vehicle_ins&assetp_id=#attributes.assetp_id#</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang_main no='170.Ekle'>"></i></a>
                </th>
                <!-- sil -->
            </tr>
        </thead>
        <tbody>
            <cfif asset_insurance.recordcount>
                <cfoutput query="asset_insurance">
                <tr>
                    <td>#currentrow#</td>
                    <td>#asset_care#</td>
                    <td>#policy_no#</td>
                    <td>#fullname#</td>
					<td>#TLFormat(INSURANCE_TOTAL)#</td>
                    <td>#dateFormat(insurance_start_date,dateformat_style)#</td>
                    <td>#dateFormat(insurance_finish_date,dateformat_style)#</td>
                    <td><cfif #Datediff('d',now(),insurance_finish_date)# lte 0>0<cfelse>#Datediff('d',now(),insurance_finish_date)#</cfif><cf_get_lang dictionary_id='57490.Gün'></td>
					<!-- sil -->
                    <td>
                        <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_upd_vehicle_ins&insurance_id=#insurance_id#&assetp_id=#attributes.assetp_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                    </td>
	                <!-- sil -->
                </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="9"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
</cf_box>
</div>
