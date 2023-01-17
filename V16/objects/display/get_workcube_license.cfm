<cfset workcube_license = createObject("V16.settings.cfc.workcube_license").get_license_information() />
<cf_box title = "#getLang('','Uygulamanız Hakkında','60940')#" closable = "1" collapsable = "0" resize = "0" settings = "0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cf_grid_list>
        <tbody>
            <cfoutput>
            <tr>
                <td>Workcube ID : </td>
                <td>#workcube_license.WORKCUBE_ID#</td>
            </tr>
            <tr>
                <td>Release No : </td>
                <td>#workcube_license.RELEASE_NO#</td>
            </tr>
            <tr>
                <td>Release Date : </td>
                <td>#dateformat(workcube_license.RELEASE_DATE,dateformat_style)# #timeformat(workcube_license.RELEASE_DATE,timeformat_style)#</td>
            </tr>
            <cfif len( workcube_license.PATCH_NO ) and len( workcube_license.PATCH_DATE )>
            <tr>
                <td>Patch No : </td>
                <td>#workcube_license.PATCH_NO#</td>
            </tr>
            <tr>
                <td>Patch Date : </td>
                <td>#dateformat(workcube_license.PATCH_DATE,dateformat_style)# #timeformat(workcube_license.PATCH_DATE,timeformat_style)#</td>
            </tr>
            </cfif>
            <tr>
                <td><cf_get_lang dictionary_id = '60970.Kullanıcı Şirket'>: </td>
                <td>#workcube_license.OWNER_COMPANY_TITLE#</td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id = '60972.Kurum İçi Destek'>: </td>
                <td>#workcube_license.IMPLEMENTATION_POWER_USER_EMPLOYEE_TITLE#</td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id = '60973.Kurum İçi Teknik Destek'>: </td>
                <td>#workcube_license.TECHNICAL_PERSON_EMPLOYEE_TITLE#</td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id = '60974.Kurum Dışı Destek Alınan Workcube İş Ortağı'>: </td>
                <td>#workcube_license.WORKCUBE_PARTNER_COMPANY_TITLE#</td>
            </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
    <cfif get_module_power_user(7)>
        <div class="row">
            <div class="col col-12 mt-3 mb-2 text-center">
                <a href="javascript:openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.widget_loader&widget_load=getLicenseAndTerms')"><cf_get_lang dictionary_id='64745.Lisans ve Kullanım Koşulları'></a>
            </div>
        </div>
    </cfif>
</cf_box>