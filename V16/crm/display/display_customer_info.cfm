<!--- Eczaci Bilgileri -Ortak- Include Sayfasi FBS 20100318 --->
<cfquery name="GET_RELATED" datasource="#DSN#">
	SELECT
		COMPANY.FULLNAME,
		COMPANY.TAXNO,
		COMPANY.SEMT,
		COMPANY.DISTRICT,
		COMPANY.MAIN_STREET,
		COMPANY.STREET,
		COMPANY.DUKKAN_NO,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1,
		COMPANY.COMPANY_FAX,
		COMPANY.COMPANY_FAX_CODE,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		SETUP_IMS_CODE.IMS_CODE,
		SETUP_IMS_CODE.IMS_CODE_NAME,
		SETUP_CITY.CITY_NAME,
		SETUP_COUNTY.COUNTY_NAME,
		COMPANY_CAT.COMPANYCAT
	FROM
		COMPANY,
		COMPANY_PARTNER,
		SETUP_IMS_CODE,
		SETUP_CITY,
		SETUP_COUNTY,
		COMPANY_CAT
	WHERE
		COMPANY.COMPANY_ID = #attributes.consumer_id# AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
		SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
		SETUP_CITY.CITY_ID = COMPANY.CITY AND
		SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID
</cfquery>
<cfquery name="GET_RELATED_BRANCHS" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		COMPANY_BRANCH_RELATED.MUSTERIDURUM
	FROM
		BRANCH,
		COMPANY_BRANCH_RELATED
	WHERE
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.consumer_id#
</cfquery>
<cfquery name="GET_CUSTOMER_POSITION" datasource="#DSN#">
	SELECT 
		COMPANY_POSITION.POSITION_ID,
		SETUP_CUSTOMER_POSITION.POSITION_NAME 
	FROM 
		SETUP_CUSTOMER_POSITION, 
		COMPANY_POSITION
	WHERE 
		COMPANY_POSITION.POSITION_ID = SETUP_CUSTOMER_POSITION.POSITION_ID AND 
		COMPANY_POSITION.COMPANY_ID = #attributes.consumer_id#
	ORDER BY 
		SETUP_CUSTOMER_POSITION.POSITION_ID
</cfquery>
<cfquery name="GET_COMPANY_RIVAL_INFO" datasource="#DSN#">
	SELECT
		SETUP_RIVALS.R_ID,
		SETUP_RIVALS.RIVAL_NAME
	FROM
		COMPANY,
		COMPANY_PARTNER_RIVAL,
		SETUP_RIVALS
	WHERE
		COMPANY.COMPANY_ID = COMPANY_PARTNER_RIVAL.COMPANY_ID AND
		COMPANY_PARTNER_RIVAL.RIVAL_ID = SETUP_RIVALS.R_ID AND
		COMPANY.COMPANY_ID = #attributes.consumer_id#
</cfquery>

<cf_box_elements>
    <div class="col col-4 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
        <cfoutput>
            <div class="form-group" id="item-company_partner_name">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52058.Eczacı Adı Soyadı'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> #get_related.company_partner_name# #get_related.company_partner_surname#</div>
            </div>
            <div class="form-group" id="item-taxno">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> #get_related.taxno#</div>
            </div>
            <div class="form-group" id="item-ims_code_name">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> #get_related.ims_code# #get_related.ims_code_name#</div>
            </div>
            <div class="form-group" id="item-city_name">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> #get_related.city_name#</div>
            </div>
            <div class="form-group" id="item-county_name">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> #get_related.county_name#</div>
            </div>
            <div class="form-group" id="item-semt">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> #get_related.semt#</div>
            </div>
            <div class="form-group" id="item-district">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='59266.Cadde'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> #get_related.district#</div>
            </div>
        </cfoutput>
        <div class="form-group" id="item-branch_name">
            <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52063.İlişkili Şubeler'><br/><cf_get_lang dictionary_id='57756.Durum'></label>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                <cfoutput query="get_related_branchs">  #branch_name#
                    <cfif len(musteridurum)>
                        <cfquery name="GET_STATUS" datasource="#DSN#">
                            SELECT TR_NAME FROM SETUP_MEMBERSHIP_STAGES WHERE TR_ID = #musteridurum#
                        </cfquery>
                        - #get_status.tr_name#
                    </cfif>
                    <br/>
                </cfoutput>
            </div>
        </div>
    </div>
    
    <div class="col col-4 col-md-6 col-sm-12 col-xs-12" type="column" index="2" sort="true">
        <cfoutput>
            <div class="form-group" id="item-companycat">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57292.Müşteri Tipi'></label>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        #get_related.companycat#
                    </div>
            </div>
            <div class="form-group" id="item-company_telcode">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52060.Tel No'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    #get_related.company_telcode# #get_related.company_tel1#
                </div>
            </div>
            <div class="form-group" id="item-company_fax_code">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    #get_related.company_fax_code# #get_related.company_fax#
                </div>
            </div>
            <div class="form-group" id="item-dukkan_no">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52061.İşyeri No'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    #get_related.dukkan_no#
                </div>
            </div>
            <div class="form-group" id="item-street">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='51493.Sokak'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    #get_related.street#
                </div>
            </div>
            <div class="form-group" id="item-main_street">
                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    #get_related.main_street#
                </div>
            </div>
        </cfoutput>
        <div class="form-group" id="item-position_name">
            <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52062.Eczane Konumu'></label>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                <cfoutput query="get_customer_position"> #position_name#<br/></cfoutput>
            </div>
        </div>
        <div class="form-group" id="item-get_options">
            <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52064.Çalıştığı Rakipler'><br/><cf_get_lang dictionary_id='52065.Tercih Nedenleri'></label>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                <cfoutput query="get_company_rival_info">
                    <cfquery name="GET_OPTIONS" datasource="#DSN#">
                        SELECT 
                            SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON
                        FROM 
                            COMPANY_RIVAL_OPTION_APPLY,
                            SETUP_RIVAL_PREFERENCE_REASONS
                        WHERE  
                            COMPANY_RIVAL_OPTION_APPLY.COMPANY_ID = #attributes.consumer_id# AND 
                            COMPANY_RIVAL_OPTION_APPLY.RIVAL_ID = #r_id# AND
                            SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON_ID = COMPANY_RIVAL_OPTION_APPLY.OPTION_ID
                    </cfquery> 
                        #rival_name# 
                    <cfif get_options.recordcount>- <cfloop query="get_options">#preference_reason#,</cfloop></cfif>
                    <br/>
                </cfoutput>
            </div>
        </div>
    </div>
</cf_box_elements>

