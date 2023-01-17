<cfsavecontent variable="img_">
    <cf_workcube_file_action pdf='0' mail='1' doc='0' print='0'>
</cfsavecontent>
<cf_box title="#getLang('','',52150)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <div class="form-group">
        <label> Sayın Yönetici, Aşağıdaki listede bilgilerini onayladığım eczaneler depomuzun müşterileridir. Doğruluğunu taahhüt ederim.</label>  
    </div>   
    <div class="form-group"> 
        <label>Bilginize Sunarım ...</label>
    </div>
    <div class="form-group">
        <label><cfoutput>#session.ep.name# #session.ep.surname#</cfoutput></label>
    </div>    
    <cfquery name="GET_COMPANY" datasource="#dsn#">
        SELECT 
            COMPANY.COMPANY_ID, 
            COMPANY.TAXNO,
            COMPANY.FULLNAME, 
            COMPANY.IMS_CODE_ID,
            SETUP_IMS_CODE.IMS_CODE,
            SETUP_IMS_CODE.IMS_CODE_NAME,
            COMPANY_CAT.COMPANYCAT,
            COMPANY_PARTNER.COMPANY_PARTNER_NAME,
            COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
            COMPANY.ISPOTANTIAL,
            SETUP_COUNTY.COUNTY_NAME,
            SETUP_CITY.CITY_NAME
        FROM 
            COMPANY,
            SETUP_IMS_CODE,
            COMPANY_CAT,
            COMPANY_PARTNER,
            SETUP_COUNTY,
            SETUP_CITY
        WHERE 
        
            SETUP_CITY.CITY_ID = COMPANY.CITY AND
            SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY AND
            COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
            COMPANY.IMS_CODE_ID = SETUP_IMS_CODE.IMS_CODE_ID AND
            COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND 
            COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
            COMPANY.COMPANY_ID IN
            (
            SELECT
                CBR.COMPANY_ID
            FROM
                COMPANY_BRANCH_RELATED CBR,
                EMPLOYEE_POSITION_BRANCHES EPB
            WHERE
                CBR.MUSTERIDURUM IS NOT NULL AND
                CBR.IS_SELECT = 1 AND
                EPB.POSITION_CODE = #session.ep.position_code# AND
                EPB.BRANCH_ID = CBR.BRANCH_ID AND
                CBR.VALID_EMP = #session.ep.userid#
            )
         ORDER BY 
            COMPANY.FULLNAME
    </cfquery>
    <cf_grid_list>
        <thead>
            <tr>
                <th width="25"><cf_get_lang_main no='75.No'></th>
                <th width="180"><cf_get_lang_main no='45.Müşteri'></th>
                <th><cf_get_lang_main no='158.Ad Soyad'></th>
                <th width="65"><cf_get_lang_main no='722.Mikro Bolge Kodu'></th>
                <th width="65"><cf_get_lang_main no='1196.İl'></th>
                <th width="65"><cf_get_lang_main no='1226.İlçe'></th>
            </tr>
        </thead>
        <tbody>
             <cfif get_company.recordcount>
             <cfoutput query="get_company">
            <tr>
                <td>#currentrow#</td>
                <td>#fullname#</td>
                <td>#company_partner_name# #company_partner_surname#</td>
                <td>#ims_code# #ims_code_name#</td>
                <td>#city_name#</td>
                <td>#county_name#</td>
            </tr>
            </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="7" height="20"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
                </tr>
            </cfif>
         </tbody>
    </cf_grid_list> 
</cf_box>
