<tr class="color-row"> 
    <td height="25" width="95%">
        <a href="#request.self#?fuseaction=assetcare.#assetp_link#&assetp_id=#asset_id#" class="tableyazi">#assetp#</a>-
        <a href="#request.self#?fuseaction=assetcare.form_upd_care_period&care_id=#care_id#&assetp_id=#asset_id#" class="tableyazi">#get_asset_cares_all.asset_care#</a>
        <cfif len(get_asset_cares_all.official_emp_id)>- #get_asset_cares_all.employee_name#</cfif> - 
        <a href="#request.self#?fuseaction=assetcare.form_add_asset_care&asset_id=#asset_id#&care_state_id=#care_state_id#&care_id=#care_id#"><font color="##990000"><cf_get_lang no='238.Bakım Sonucu Ekle'></font></a>
    </td>
</tr>
