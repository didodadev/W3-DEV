<cfquery name="GET_BRANCH_DEP_COUNT" datasource="#dsn#">
	SELECT 
		BRANCH_ID, 
		COUNT(DEPARTMENT_ID) AS TOTAL
	FROM 
		DEPARTMENT
	WHERE 
		BRANCH_ID=#attributes.ID#
	GROUP BY
		BRANCH_ID
</cfquery>
<cfquery name="OUR_COMPANY" datasource="#dsn#">
	SELECT 
		COMP_ID,
		COMPANY_NAME ,
		TAX_OFFICE,
		TAX_NO
	FROM 
		OUR_COMPANY
	ORDER BY 
		COMPANY_NAME
</cfquery>
<cfquery name="CATEGORY" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		BRANCH 
	WHERE 
		BRANCH_ID=#URL.ID#
</cfquery>
<cfquery name="ZONES" datasource="#DSN#">
	 SELECT 
		ZONE_NAME,
		ZONE_ID
	 FROM 
		ZONE
</cfquery>
<cfsavecontent variable="img_">

</cfsavecontent>
<cf_box title="#getLang('','Şube',57453)# : #category.branch_name#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cf_box_elements>
        <cfoutput><input type="Hidden" name="branch_ID" id="branch_ID" value="#URL.ID#"></cfoutput>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
            <div class="form-group" id="item-assetp_cat_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'> :</label>
              <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                 <cfif category.branch_status><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif>
              </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32407.Tel Kod'>1</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>#category.branch_telcode#-#category.branch_tel1#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57574.Sirket'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfif OUR_COMPANY.recordcount>
                        <cfoutput query="OUR_COMPANY">
                          <cfif CATEGORY.COMPANY_ID EQ OUR_COMPANY.COMP_ID>#COMPANY_NAME#</cfif>
                        </cfoutput>
                    </cfif>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 2</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>#category.branch_tel2#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57992.Bölge'> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfif category.recordcount GTE 1>
                        <cfoutput query="zones">
                           <cfif category.zone_ID EQ zones.zone_ID>#zone_name#</cfif> 
                        </cfoutput>
                    </cfif>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 3</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>#category.branch_tel3#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32790.Yneticiler'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                   
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>#category.branch_fax# </cfoutput> 
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29511.Ynetici'> 1</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfif len(category.admin1_position_code)>
                        <cfset attributes.employee_id = "">
                        <cfset attributes.position_code = category.admin1_position_code>
                        <cfinclude template="../query/get_position.cfm">
                        <cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>
                    </cfif>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>#category.branch_email#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29511.Ynetici'> 2</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfif len(category.admin2_position_code)>
                        <cfset attributes.employee_id = "">
                        <cfset attributes.position_code = category.admin2_position_code>
                        <cfinclude template="../query/get_position.cfm">
                        <cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>
                    </cfif>
                </div>
            </div>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>#category.branch_address#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32796.Görünüm'> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>#category.branch_postcode#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32792.Dis Grnm'> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfif len(CATEGORY.asset_file_name1)>
                        <a href="javascript://" onclick="windowopen('<cfoutput>settings/#CATEGORY.asset_file_name1#</cfoutput>','medium');"><img src="/images/branch_plus.gif" title="<cf_get_lang dictionary_id='32940.Şube Dış Görünümü'>" border="0" align="absmiddle"></a>
                      </cfif>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58638.Ile'> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>
                        #category.branch_county#
                    </cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32794.Kroki'> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfif len(CATEGORY.asset_file_name2)>
                        <a href="javascript://" onclick="windowopen('<cfoutput>settings/#CATEGORY.asset_file_name2#</cfoutput>','medium');"><img src="/images/branch_black.gif" title="<cf_get_lang dictionary_id='32939.Sube Krokisi'>" border="0" align="absmiddle"></a>
                    </cfif>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32795.Sehir-ülke'> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>
                        #category.branch_city#/#category.branch_country#
                    </cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="33083.SSK Şubesi"> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>#CATEGORY.SSK_OFFICE#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="33084.SSK No"> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput query="CATEGORY">
                        #ssk_m# #ssk_job# #ssk_branch# #ssk_no# #ssk_city# #ssk_country#
                    </cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58762.Vergi Dairesi"> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>#our_company.tax_office#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-assetp_cat_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57752.Vergi No"> :</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfoutput>#our_company.tax_no#</cfoutput>
                </div>
            </div>
        </div>
    </cf_box_elements>
</cf_box>