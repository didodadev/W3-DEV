<!---Select ifadeleri düzenlendi.e.a 24082012--->
<cfset xml_page_control_list = 'is_segmentasyon'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1" fuseact="campaign.form_add_target_market">
<cfparam name="attributes.req_comp" default="">
<cfparam name="attributes.req_cons" default="">
<cfparam name="attributes.connect_member" default="">
<cfparam name="attributes.is_active" default="">
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT
		COUNTRY_ID,
		COUNTRY_NAME,
		COUNTRY_PHONE_CODE,
		IS_DEFAULT
	FROM
		SETUP_COUNTRY
	ORDER BY
		COUNTRY_NAME
</cfquery>
<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
	SELECT
    	COMP_ID,
       	NICK_NAME,
    	RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_DATE
    FROM
		OUR_COMPANY
</cfquery>
<cfquery name="ALL_DEPARTMENTS" datasource="#DSN#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM
		BRANCH
	ORDER BY
		BRANCH_NAME
</cfquery>
<cfquery name="get_firm_type" datasource="#dsn#">
    SELECT
        FIRM_TYPE,
        FIRM_TYPE_ID
    FROM
        SETUP_FIRM_TYPE
    ORDER BY
        FIRM_TYPE
</cfquery>
<cfinclude template="../query/get_consumer_cats.cfm">
<cfinclude template="../query/get_target_markets.cfm">
<cfinclude template="../query/get_company_cats.cfm">
<cfinclude template="../query/get_company_size_cats.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<cfinclude template="../query/get_sector_cats.cfm">
<cfif len(tmarket.comp_productcat_list)>
	<cfquery name="get_productCat" datasource="#dsn3#">
			SELECT
				HIERARCHY,
				PRODUCT_CAT,
				PRODUCT_CATID
			FROM
				PRODUCT_CAT
			WHERE
				PRODUCT_CATID IN (#tmarket.comp_productcat_list#)
	</cfquery>
</cfif>
<cfquery name="get_customer_value" datasource="#dsn#">
	SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="get_ims_code" datasource="#dsn#">
	SELECT IMS_CODE_ID,	IMS_CODE, IMS_CODE_NAME	FROM SETUP_IMS_CODE	WHERE IMS_CODE_ID IS NOT NULL ORDER BY IMS_CODE
</cfquery>
<cfquery name="get_hobby" datasource="#dsn#">
	SELECT HOBBY_ID,HOBBY_NAME FROM SETUP_HOBBY ORDER BY HOBBY_NAME
</cfquery>
<cfquery name="GET_SALES_ZONE" datasource="#DSN#">
   SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_EDU_LEVEL" datasource="#dsn#">
   SELECT EDU_LEVEL_ID, EDUCATION_NAME FROM	SETUP_EDUCATION_LEVEL
</cfquery>
<cfquery name="GET_SOCIETIES" datasource="#DSN#">
	SELECT SOCIETY_ID,SOCIETY FROM SETUP_SOCIAL_SOCIETY ORDER BY SOCIETY
</cfquery>
<cfquery name="GET_INCOME_LEVEL" datasource="#DSN#">
	SELECT INCOME_LEVEL_ID, INCOME_LEVEL FROM SETUP_INCOME_LEVEL ORDER BY INCOME_LEVEL
</cfquery>
<cfif len(tmarket.COMPANY_COUNTY_ID)>
	<cfquery name="get_company_county" datasource="#dsn#">
		SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#tmarket.COMPANY_COUNTY_ID#)
	</cfquery>
<cfelse>
	<cfset get_company_county.recordcount=0>
</cfif>
<cfif len(tmarket.company_city_id)>
	<cfquery name="get_company_city" datasource="#dsn#">
		SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#tmarket.company_city_id#)
	</cfquery>
<cfelse>
	<cfset get_company_city.recordcount=0>
</cfif>
<cfif len(tmarket.county_id)>
	<cfquery name="get_cons_county" datasource="#dsn#">
		SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#tmarket.county_id#)
	</cfquery>
<cfelse>
	<cfset get_cons_county.recordcount=0>
</cfif>
<cfif len(tmarket.city_id)>
	<cfquery name="get_cons_city" datasource="#dsn#">
		SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#tmarket.city_id#)
	</cfquery>
<cfelse>
	<cfset get_cons_city.recordcount=0>
</cfif>
<cfquery name="get_req" datasource="#DSN#">
	SELECT
    	REQ_ID,
        REQ_NAME,
        REQ_DETAIL,
        RECORD_DATE,
        RECORD_EMP,
        UPDATE_DATE,
        UPDATE_EMP
    FROM
    	SETUP_REQ_TYPE
</cfquery>
<cfquery name="get_commethod_types" datasource="#dsn#">
	SELECT
    	COMMETHOD_ID,
        COMMETHOD,
        RECORD_DATE,
        RECORD_EMP,
        UPDATE_DATE,
        UPDATE_EMP
    FROM
    	SETUP_COMMETHOD
    ORDER BY
    	COMMETHOD
</cfquery>
<cfquery name="get_paymethod" datasource="#dsn#">
	SELECT
    	SP.PAYMETHOD_ID,
        SP.PAYMETHOD,
        SP.RECORD_DATE,
        SP.RECORD_EMP,
        SP.UPDATE_DATE,
        SP.UPDATE_EMP
   FROM
    	SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
    WHERE
    	SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    ORDER BY
    	SP.PAYMETHOD
</cfquery>
<cfquery name="get_kk_paymethod" datasource="#dsn3#">
	SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE IS_ACTIVE = 1 ORDER BY CARD_NO
</cfquery>
<cfquery name="get_process_cats" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.add_consumer%">
</cfquery>
<cfquery name="get_process_cats_part" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
</cfquery>
<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">   
        <cf_box>
        <cfform name="upd_tmarket" id="upd_tmarket"  method="post" action="#request.self#?fuseaction=campaign.upd_target_market">
            <cfif isdefined('attributes.camp_id')><input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#attributes.camp_id#</cfoutput>"></cfif>
            <input type="hidden" name="tmarket_id" id="tmarket_id" value="<cfoutput>#tmarket_id#</cfoutput>">
        
                       <cf_box_elements>
                       
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                                <div class="form-group" id="item-aktif">
                                    <label class="col col-12">
                                        <span class="col col-4 col-xs-12"><cf_get_lang_main no='81. Aktif'></span>
                                        <span class="col col-8 col-xs-12"><input type="checkbox" name="is_active" id="is_active" value="1" <cfif tmarket.is_active eq 1>checked="checked"</cfif>></span>
                                    </label>
                                </div>
                                <div class="form-group" id="item-no">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='75. No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="tmarket_no" id="tmarket_no"  value="<cfoutput>#tmarket.tmarket_no#</cfoutput>" maxlength="20" readonly>
                                    </div>
                                </div>
                                <div class="form-group" id="item-tmarket_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='68.Başlık'>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık Girmelisiniz !'></cfsavecontent>
                                        <cfinput type="text" name="tmarket_name" id="tmarket_name"  maxlength="100" value="#tmarket.tmarket_name#" required="Yes" message="#message#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-process">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_workcube_process is_detail="1" process_cat_width="140" is_upd='0' select_value="#TMARKET.process_stage#">
                                    </div>
                                </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_maillist" id="is_maillist" value="1" <cfif TMARKET.is_maillist eq 1>checked="checked"</cfif>><cf_get_lang no='258.Mail List'>(<cf_get_lang no ='260.Üye Olmayıp Mail Listesine Mesaj Bırakanlar'>)</label>
                                    </div>
                            </div>
                        </cf_box_elements>
                        <!--- Kurumsal Üyeler --->
                            <cf_seperator id="kurumsal_uyeler" header="#getLang('campaign',108)#">
                                <cf_box_elements>
                                    <div class="row" type="row" id="kurumsal_uyeler" >
                                       
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12"type="column"  sort="true" index="2">
                                            <div class="form-group" id="item-is_company_search">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                                    <input type="checkbox" name="is_company_search" id="is_company_search" value="1" <cfif listfindnocase('0,1,3,4',TMARKET.TARGET_MARKET_TYPE)>checked</cfif>>
                                                    <cf_get_lang no='108.Kurumsal Üye Özellikleri'>
                                                </label>
                                            </div>
                                       
                                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column"  sort="true" index="3">
                                                <div class="form-group" id="item-comp_want_email">
                                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label><cf_get_lang_main no='1666.Mail'></label>
                                                    </div>
                                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                                        <select name="comp_want_email" id="comp_want_email" >
                                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                            <option value="2" <cfif tmarket.comp_want_email eq 2>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                                                            <option value="1" <cfif tmarket.comp_want_email eq 1>selected</cfif>><cf_get_lang no='389.İsteyen'></option>
                                                            <option value="0" <cfif tmarket.comp_want_email eq 0>selected</cfif>><cf_get_lang no='390.İstemeyen'></option>
                                                        </select>
                                                    </div>
                                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" >
                                                        <select name="connect_member" id="connect_mmeber" >
                                                            <option value=""><cf_get_lang_main no='296.Tümü'></option>
                                                            <option value="1" <cfif tmarket.comp_conmember eq 1>selected</cfif>><cf_get_lang no='31.Bağlı Üye'></option>
                                                            <option value="0" <cfif tmarket.comp_conmember eq 0>selected</cfif>><cf_get_lang no='32.Bağlı Üye Olmayan'></option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12" type="column" sort="true" index="4">
                                                <div class="form-group" id="item-comp_want-poy">
                                                    <div class="col col-2 col-xs-12">
                                                        <label><input type="checkbox" name="IS_POTANTIAL" id="IS_POTANTIAL" value="1" <cfloop list="#ListSort(tmarket.IS_POTANTIAL,'numeric')#" index="ISPOTANTIAL"><cfif 1 eq ISPOTANTIAL>checked</cfif></cfloop>> <cf_get_lang_main no='165.Potansiyel'></label>
                                                        </div>
                                                        <div class="col col-1 col-xs-12"> 
                                                            <label><input type="checkbox" name="IS_POTANTIAL" id="IS_POTANTIAL" value="0" <cfloop list="#ListSort(tmarket.IS_POTANTIAL,'numeric')#" index="ISPOTANTIAL"><cfif 0 eq ISPOTANTIAL>checked</cfif></cfloop>> <cf_get_lang_main no='649.cari'></label> 
                                                        </div>
                                                        <div class="col col-1 col-xs-12"> 
                                                            <label><input type="checkbox" name="PARTNER_STATUS" id="PARTNER_STATUS" value="1" <cfloop list="#ListSort(tmarket.PARTNER_STATUS,'numeric')#" index="PARTNERSTATUS"><cfif 1 eq PARTNERSTATUS>checked</cfif></cfloop>> <cf_get_lang_main no='81.Aktif'></label>
                                                        </div>
                                                        <div class="col col-1 col-xs-12"> 
                                                            <label><input type="checkbox" name="PARTNER_STATUS" id="PARTNER_STATUS" value="0" <cfloop list="#ListSort(tmarket.PARTNER_STATUS,'numeric')#" index="PARTNERSTATUS"><cfif 0 eq PARTNERSTATUS>checked</cfif></cfloop>> <cf_get_lang_main no='82.Pasif'></label>
                                                        </div>
                                                        <div class="col col-1 col-xs-12">           
                                                            <label><input type="checkbox" name="IS_BUYER" id="IS_BUYER" value="1" <cfif 1 eq tmarket.IS_BUYER>checked</cfif>><cf_get_lang_main no='1321.Alıcı'></label>
                                                        </div>
                                                        <div class="col col-1 col-xs-12"> 
                                                            <label><input type="checkbox" name="IS_SELLER" id="IS_SELLER" value="1" <cfif 1 eq tmarket.IS_SELLER>checked</cfif>><cf_get_lang_main no='1461.Satıcı'></label>
                                                        </div>
                                                        <div class="col col-1 col-xs-12">
                                                            <label><input type="checkbox" name="PARTNER_TMARKET_SEX" id="PARTNER_TMARKET_SEX" value="1" <cfif ListFind(tmarket.PARTNER_TMARKET_SEX, 1) neq 0>checked</cfif>><cf_get_lang no='90.Bay'></label>
                                                        </div>
                                                        <div class="col col-1 col-xs-12">           
                                                            <label><input type="checkbox" name="PARTNER_TMARKET_SEX" id="PARTNER_TMARKET_SEX" value="0,2" <cfif ListFind(tmarket.PARTNER_TMARKET_SEX, 0) neq 0>checked</cfif>><cf_get_lang no='91.Bayan'></label>
                                                        </div>
                                                        <div class="col col-3 col-xs-12">       
                                                            <label><input type="checkbox" name="ONLY_FIRM_MEMBERS" id="ONLY_FIRM_MEMBERS" value="1" <cfif tmarket.ONLY_FIRMMEMBER eq 1>checked</cfif>><cf_get_lang no='33.Yalnız Firma Yetkilisi'></label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="5">
                                        <div class="form-group" id="item-companycats">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1293.Kurumsal Üye Kategorisi'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="companycats" id="companycats" multiple >
                                                    <cfoutput query="get_companycats">
                                                        <option value="#companycat_id#" <cfif listfind(tmarket.companycats,companycat_id,',')>selected</cfif>>#companycat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-PARTNER_DEPARTMENT">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='160.Departman'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="PARTNER_DEPARTMENT" id="PARTNER_DEPARTMENT" multiple >
                                                    <cfoutput query="get_partner_departments">
                                                        <option value="#PARTNER_DEPARTMENT_ID#" <cfif listfind(tmarket.PARTNER_DEPARTMENT,PARTNER_DEPARTMENT_ID,',')>selected</cfif>>#PARTNER_DEPARTMENT#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                            <div class="form-group" id="item-product_category">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='155.Ürün Kategorileri'> *</label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <div class="input-group">
                                                        <select name="product_category" id="product_category"  multiple>
                                                            <cfif len(tmarket.comp_productcat_list)>
                                                                <cfoutput query="get_productCat">
                                                                    <cfset hierarchy_ = "">
                                                                    <cfset new_name = "">
                                                                    <cfloop list="#HIERARCHY#" delimiters="." index="hi">
                                                                        <cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
                                                                        <cfquery name="getCat" datasource="#dsn1#">
                                                                            SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE HIERARCHY = '#hierarchy_#'
                                                                        </cfquery>
                                                                        <cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
                                                                    </cfloop>
                                                                    <option value="#product_catid#">#new_name#</option>
                                                                </cfoutput>
                                                            </cfif>
                                                        </select>
                                                        <span class="input-group-addon btnPointer no-bg" title="<cf_get_lang_main no='170.Ekle'>" onClick="windowopen('<cfoutput>#request.self#?</cfoutput>fuseaction=worknet.popup_list_product_categories&field_name=document.upd_tmarket.product_category','medium');"></span>
                                                        <span class="input-group-addon btnPointer no-bg" title="<cf_get_lang_main no='51.Sil'>" onClick="remove_field('product_category');"></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-company_ims_code">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='238.Mikro Bölge'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <select name="company_ims_code" id="company_ims_code" multiple >
                                                        <cfoutput query="get_ims_code">
                                                            <option value="#IMS_CODE_ID#" <cfif listfind(tmarket.company_ims_code,IMS_CODE_ID,',')>selected</cfif>>#IMS_CODE_NAME#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-comp_agent_pos_code">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='496.Temsilci'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <div class="input-group">
                                                        <select name="comp_agent_pos_code" id="comp_agent_pos_code"  multiple>
                                                            <cfif len(tmarket.comp_agent_pos_code)>
                                                                <cfloop from="1" to="#ListLen(tmarket.comp_agent_pos_code,',')#" index="sayac2">
                                                                    <cfoutput><option value="#ListGetAt(tmarket.comp_agent_pos_code,sayac2,',')#">#get_emp_info(ListGetAt(tmarket.comp_agent_pos_code,sayac2,','),1,0)#</option></cfoutput>
                                                                </cfloop>
                                                            </cfif>
                                                        </select>
                                                        <span class="input-group-addon btnPointer no-bg" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_name=upd_tmarket.comp_agent_pos_code&select_list=1&is_upd=0&is_multiple=1','list');" title="<cf_get_lang_main no ='170.Ekle'>"><label class="fa fa-plus btnPointer"></label></span>
                                                        <span class="input-group-addon btnPointer no-bg" title="<cf_get_lang_main no='51.Sil'>" onclick="remove_field('comp_agent_pos_code');"><label class="fa fa-minus btnPointer"></label></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-rel_company_name">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='173. Kurumsal Üye'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="input-group">
                                                    <input type="text" name="rel_company_name" id="rel_company_name" value="" ><input type="hidden" name="rel_company_id" id="rel_company_id" value="">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2,6&field_comp_id=upd_tmarket.rel_company_id&field_comp_name=upd_tmarket.rel_company_name','list')"></span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group" id="item-company_resource">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='237.İlişki Tipi'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <cf_wrk_combo
                                                        name="company_resource"
                                                        option_name="RESOURCE"
                                                        option_value="RESOURCE_ID"
                                                        multiple="1"
                                                        is_option_text="0"
                                                        value="#tmarket.company_resource#"
                                                        query_name="GET_PARTNER_RESOURCE"
                                                        width="170"
                                                        height="80">
                                                </div>
                                            </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="6" sort="true" type="column">
                                            <div class="form-group" id="item-company_sales_zone">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='247.Satış Bölgesi'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <select name="company_sales_zone" id="company_sales_zone" multiple >
                                                        <cfoutput query="GET_SALES_ZONE">
                                                            <option value="#SZ_ID#" <cfif listfind(tmarket.company_sales_zone,SZ_ID,',')>selected</cfif>>#SZ_NAME#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div>
                                        <div class="form-group" id="item-partner_mission">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='161.Görev'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="PARTNER_MISSION" id="PARTNER_MISSION" multiple >
                                                    <cfoutput query="get_partner_positions">
                                                        <option value="#PARTNER_POSITION_ID#" <cfif listfind(tmarket.PARTNER_MISSION,PARTNER_POSITION_ID,',')>selected</cfif>>#PARTNER_POSITION#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-company_country_id">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='807.Ülke'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="company_country_id" id="company_country_id"   multiple="multiple">
                                                    <cfoutput query="get_country">
                                                        <option value="#country_id#" <cfif listfind(valuelist(tmarket.COMPANY_COUNTRY_ID),country_id,',')>selected</cfif>>#country_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-req_comp">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='495.Yetkinlik'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="req_comp" id="req_comp" multiple >
                                                    <cfoutput query="get_req">
                                                        <option  value="#get_req.req_id#"<cfif ListFind(tmarket.REQ_COMP,get_req.REQ_ID,',')>selected</cfif>>#get_req.req_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                            <div class="form-group" id="item-partner_relation">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='242.İlişkili Üyeler'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <cf_wrk_combo
                                                        name="rel_type_id"
                                                        query_name="GET_PARTNER_RELATION"
                                                        multiple="1"
                                                        value="#tmarket.COMPANY_REL_TYPE_ID#"
                                                        height="80"
                                                        width="170"
                                                        is_option_text="0"
                                                        option_name="PARTNER_RELATION"
                                                        option_value="PARTNER_RELATION_ID">
                                                </div>
                                            </div> 
                                            <div class="form-group" id="item-company_size_cats">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='106.Şirketteki Çalışan Sayısı'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="company_size_cats" id="company_size_cats" multiple >
                                                    <cfoutput query="get_company_size_cats">
                                                        <option value="#company_size_cat_id#" <cfif listfind(tmarket.company_size_cats,company_size_cat_id,',')>selected</cfif>>#company_size_cat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-firm_type">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='30.Firma Tipi'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="firm_type" id="firm_type" multiple >
                                                    <cfoutput query="get_firm_type">
                                                        <option value="#firm_type_id#"<cfif listfind(tmarket.comp_firm_list,firm_type_id,',')>selected</cfif>>#firm_type#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="7" sort="true" type="column">
                                        <div class="form-group" id="item-company_value">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1140.Müşteri Değeri'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="company_value" id="company_value" multiple >
                                                    <cfoutput query="get_customer_value">
                                                        <option value="#customer_value_id#" <cfif listfind(tmarket.company_value,customer_value_id,',')>selected</cfif>>#customer_value#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-sector_cats">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='167.Sektör'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="sector_cats" id="sector_cats" multiple >
                                                    <cfoutput query="get_sector_cats">
                                                        <option value="#sector_cat_id#" <cfif listfind(tmarket.sector_cats,sector_cat_id,',')>selected</cfif>>#sector_cat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-company_city">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='559.Şehir'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="input-group">
                                                    <select name="company_city_id" id="company_city_id" multiple >
                                                        <cfif get_company_city.recordcount>
                                                            <cfoutput query="get_company_city">
                                                                <option value="#get_company_city.city_id#">#get_company_city.city_name#</option>
                                                            </cfoutput>
                                                        </cfif>
                                                    </select>
                                                    <span class="input-group-addon btnPointer no-bg" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=upd_tmarket.company_city_id&field_name=upd_tmarket.company_city_id&coklu_secim=1','small');" title="<cf_get_lang_main no='170.Ekle'>"><label class="fa fa-plus btnPointer"></label></span>
                                                    <span class="input-group-addon btnPointer no-bg" onClick="remove_field('company_city_id');" title="<cf_get_lang_main no='51.Sil'>"><label class="fa fa-minus btnPointer"></label></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-comp_rel_comp">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='162.Şirket'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="comp_rel_comp" id="comp_rel_comp"  multiple="multiple">
                                                    <cfoutput query="GET_OUR_COMPANIES">
                                                        <option value="#comp_id#" <cfif ListFind(tmarket.comp_rel_comp,comp_id,',')>selected</cfif>>#NICK_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                            <div class="form-group" id="item-company_hobby">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='239. Hobiler'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <select name="company_hobby" id="company_hobby" multiple >
                                                        <cfoutput query="get_hobby">
                                                            <option value="#hobby_id#" <cfif listfind(tmarket.COMPANY_PARTNER_HOBBY,hobby_id,',')>selected</cfif>>#hobby_name#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div> 
                                        <div class="form-group" id="item-company_county_id">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1226.İlçe'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="input-group">
                                                    <select name="company_county_id" id="company_county_id" multiple >
                                                        <cfif get_company_county.recordcount>
                                                            <cfoutput query="get_company_county">
                                                                <option value="#get_company_county.county_id#">#get_company_county.county_name#</option>
                                                            </cfoutput>
                                                        </cfif>
                                                    </select>
                                                    <span class="input-group-addon btnPointer no-bg" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_tmarket.company_county_id&field_name=upd_tmarket.company_county_id&coklu_secim=1','small');" title="<cf_get_lang_main no='170.Ekle'>"><label class="fa fa-plus btnPointer"></label></span>
                                                    <span class="input-group-addon btnPointer no-bg" onClick="remove_field('company_county_id');" title="<cf_get_lang_main no='51.Sil'>"><label class="fa fa-minus btnPointer"></label></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-comp_rel_branch">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='41.Şube'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="comp_rel_branch" id="comp_rel_branch"  multiple="multiple">
                                                    <cfoutput query="all_departments">
                                                        <option value="#branch_id#"<cfif ListFind(tmarket.comp_rel_branch,branch_id,',')>selected</cfif>>#branch_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-company_ozel_kod">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='377.Özel Kod'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfoutput>
                                                        <label ><cfoutput>#getLang('main',377)# 1</cfoutput></label><input type="text" name="company_ozel_kod1" id="company_ozel_kod1" value="#tmarket.company_ozel_kod1#"  maxlength="75">
                                                        <span class="input-group-addon no-bg"></span>
                                                        <label ><cfoutput>#getLang('main',377)# 2</cfoutput></label><input type="text" name="company_ozel_kod2" id="company_ozel_kod2" value="#tmarket.company_ozel_kod2#"  maxlength="75">
                                                        <span class="input-group-addon no-bg"></span>
                                                        <label ><cfoutput>#getLang('main',377)# 3</cfoutput></label><input type="text" name="company_ozel_kod3" id="company_ozel_kod3" value="#tmarket.company_ozel_kod3#"  maxlength="75">
                                                    </cfoutput>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </cf_box_elements>
                        <!--- Bireysel Üyeler --->
                            <cf_seperator id="bireysel_uyeler_" header="#getLang('campaign',89)#">
                              <cf_box_elements>
                                <div class="row" type="row" id="bireysel_uyeler_" >
                                    <div class="col col-12" type="column" sort="true" index="9">
                                        <div class="form-group" id="item-is_consumer_search">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="is_consumer_search" id="is_consumer_search" value="1" <cfif listfindnocase('0,2,3,5',TMARKET.TARGET_MARKET_TYPE)>checked</cfif>><cf_get_lang no='89.Bireysel Üye Özellikleri'></label>
                                        </div>
                                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="9">
                                            <div class="form-group" id="item-cons_want_email">
                                                <label class="col col-4"><cf_get_lang_main no='1666.Mail'></label>
                                                    <div class="col col-8 col-xs-12">
                                                        <select name="cons_want_email" id="cons_want_email">
                                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                            <option value="2" <cfif tmarket.cons_want_email eq 2>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                                                            <option value="1" <cfif tmarket.cons_want_email eq 1>selected</cfif>><cf_get_lang no='389.İsteyen'></option>
                                                            <option value="0" <cfif tmarket.cons_want_email eq 0>selected</cfif>><cf_get_lang no='390.İstemeyen'></option>
                                                        </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col col-8 col-md-8 col-sm-6 col-xs-12" type="column" sort="true" index="10">
                                            <div class="form-group" id="item-cons-medeni">
                                                <div class="col col-2">
                                                    <label><input type="checkbox" name="CONS_IS_POTANTIAL" id="CONS_IS_POTANTIAL" value="1" <cfloop list="#ListSort(tmarket.CONS_IS_POTANTIAL,'numeric')#" index="CONSISPOTANTIAL"><cfif 1 eq CONSISPOTANTIAL>checked</cfif></cfloop>><cf_get_lang_main no='165.Potansiyel'></label>
                                                    </div>
                                                    <div class="col col-1">
                                                        <label><input type="checkbox" name="CONS_IS_POTANTIAL" id="CONS_IS_POTANTIAL" value="0" <cfloop list="#ListSort(tmarket.CONS_IS_POTANTIAL,'numeric')#" index="CONSISPOTANTIAL"><cfif 0 eq CONSISPOTANTIAL>checked</cfif></cfloop>><cf_get_lang_main no='649.cari '></label>
                                                        </div>
                                                        <div class="col col-1">
                                                            <label><input type="checkbox" name="cons_status" id="cons_status" value="1" <cfloop list="#ListSort(tmarket.CONS_STATUS,'numeric')#" index="CONSSTATUS"><cfif 1 eq CONSSTATUS>checked</cfif></cfloop>><cf_get_lang_main no='81.Aktif'></label>
                                                    
                                                            </div>
                                                            <div class="col col-1">            <label><input type="checkbox" name="cons_status" id="cons_status" value="0" <cfloop list="#ListSort(tmarket.CONS_STATUS,'numeric')#" index="CONSSTATUS"><cfif 0 eq CONSSTATUS>checked</cfif></cfloop>><cf_get_lang_main no='82.Pasif'></label>
                                                    
                                                            </div>
                                                            <div class="col col-1">            <label><input type="checkbox" name="tmarket_sex" id="tmarket_sex" value="1" <cfif ListFind(tmarket.tmarket_sex, 1) neq 0>checked</cfif>><cf_get_lang no='90.Bay'></label>
                                                   
                                                            </div>
                                                            <div class="col col-1">             <label><input type="checkbox" name="tmarket_sex" id="tmarket_sex" value="0" <cfif ListFind(tmarket.tmarket_sex, 0) neq 0>checked</cfif>><cf_get_lang no='91.Bayan'></label>
                                                    
                                                            </div>
                                                            <div class="col col-1">            <label><input type="checkbox" name="tmarket_marital_status" id="tmarket_marital_status" value="0" <cfif ListFind(tmarket.tmarket_marital_status, 0) neq 0>checked</cfif>><cf_get_lang no='99.Bekar'></label>
                                                    
                                                            </div>
                                                            <div class="col col-1">            <label><input type="checkbox" name="tmarket_marital_status" id="tmarket_marital_status" value="1" <cfif ListFind(tmarket.tmarket_marital_status, 1) neq 0>checked</cfif>><cf_get_lang no='100.Evli'></label>
                                                </div>
                                            </div>
                                        </div>
                                     </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="11">
                                        <div class="form-group" id="item-conscat_ids">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='74.Kategori'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="conscat_ids" id="conscat_ids" multiple >
                                                    <cfoutput query="consumer_cats">
                                                        <option value="#conscat_id#" <cfif listfind(tmarket.conscat_ids,conscat_id,',')>selected</cfif>>#conscat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-cons_income_level">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='245.Gelir Düzeyi'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="cons_income_level" id="cons_income_level" multiple >
                                                    <cfoutput query="GET_INCOME_LEVEL">
                                                        <option value="#INCOME_LEVEL_ID#" <cfif listfind(tmarket.cons_income_level,INCOME_LEVEL_ID,',')>selected</cfif>>#INCOME_LEVEL#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                            <div class="form-group" id="item-cons_ims_code">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='238.Mikro Bölge'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <select name="cons_ims_code" id="cons_ims_code" multiple >
                                                        <cfoutput query="get_ims_code">
                                                            <option value="#IMS_CODE_ID#" <cfif listfind(tmarket.consumer_ims_code,IMS_CODE_ID,',')>selected</cfif>>#IMS_CODE_NAME#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div>
                                        <div class="form-group" id="item-req_cons">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='495.Yetkinlik'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="req_cons" id="req_cons" multiple >
                                                    <cfoutput query="get_req">
                                                        <option  value="#get_req.REQ_ID#"<cfif ListFind(TMARKET.REQ_CONS,get_req.REQ_ID,',')>selected</cfif>>#get_req.REQ_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-cons_rel_branch">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='41.Şube'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="cons_rel_branch" id="cons_rel_branch"  multiple="multiple">
                                                    <cfoutput query="all_departments">
                                                        <option value="#branch_id#" <cfif ListFind(tmarket.cons_rel_branch,branch_id,',')> selected</cfif>>#branch_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                         <div class="form-group" id="item-cons_value">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1140.Müşteri Değeri'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="cons_value" id="cons_value" multiple >
                                                    <cfoutput query="get_customer_value">
                                                        <option value="#customer_value_id#" <cfif listfind(tmarket.consumer_value,customer_value_id,',')>selected</cfif>>#customer_value#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div> 
                                        <div class="form-group" id="item-cons_rel_comp">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='162.Şirket'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="cons_rel_comp" id="cons_rel_comp"  multiple="multiple">
                                                    <cfoutput query="GET_OUR_COMPANIES">
                                                        <option value="#comp_id#"<cfif ListFind(tmarket.cons_rel_comp,comp_id,',')>selected</cfif>>#NICK_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="12">
                                            <div class="form-group" id="item-cons_sales_zone">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='247.Satış Bölgesi'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <select name="cons_sales_zone" id="cons_sales_zone" multiple >
                                                        <cfoutput query="GET_SALES_ZONE">
                                                            <option value="#SZ_ID#" <cfif listfind(tmarket.consumer_sales_zone,SZ_ID,',')>selected</cfif>>#SZ_NAME#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div>
                                        <div class="form-group" id="item-cons_education">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='246.Eğitim Seviyesi'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="cons_education" id="cons_education" multiple >
                                                    <cfoutput query="get_edu_level">
                                                        <option value="#EDU_LEVEL_ID#" <cfif listfind(tmarket.cons_education,EDU_LEVEL_ID,',')>selected</cfif>>#EDUCATION_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-cons_society">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='248.Sosyal Güvenlik Kurumu'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="cons_society" id="cons_society" multiple >
                                                    <cfoutput query="GET_SOCIETIES">
                                                        <option value="#SOCIETY_ID#" <cfif listfind(tmarket.cons_society,SOCIETY_ID,',')>selected</cfif>>#SOCIETY#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-cons_city_id">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='559.Şehir'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="input-group">
                                                    <select name="cons_city_id" id="cons_city_id" multiple >
                                                        <cfif get_cons_city.recordcount>
                                                            <cfoutput query="get_cons_city">
                                                                <option value="#get_cons_city.city_id#">#get_cons_city.city_name#</option>
                                                            </cfoutput>
                                                        </cfif>
                                                    </select>
                                                    <span class="input-group-addon btnPointer no-bg" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=upd_tmarket.cons_city_id&field_name=upd_tmarket.cons_city_id&coklu_secim=1','small');" title="<cf_get_lang_main no ='170.Ekle'>"><label class="fa fa-plus btnPointer"></label></span>
                                                    <span class="input-group-addon btnPointer no-bg" onclick="remove_field('cons_city_id');" title="<cf_get_lang_main no ='51.Sil'>"><label class="fa fa-minus btnPointer"></label></span>
                                                </div>
                                            </div>
                                        </div>
                                            <div class="form-group" id="item-cons_agent_pos_code">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='496.Temsilci'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <div class="input-group">
                                                        <select name="cons_agent_pos_code" id="cons_agent_pos_code"  multiple>
                                                            <cfif len(tmarket.cons_agent_pos_code)>
                                                                <cfloop from="1" to="#ListLen(tmarket.cons_agent_pos_code,',')#" index="sayac2">
                                                                    <cfoutput><option value="#ListGetAt(tmarket.cons_agent_pos_code,sayac2,',')#">#get_emp_info(ListGetAt(tmarket.cons_agent_pos_code,sayac2,','),1,0)#</option></cfoutput>
                                                                </cfloop>
                                                            </cfif>
                                                        </select>
                                                        <span class="input-group-addon btnPointer no-bg" title="<cf_get_lang_main no ='170.Ekle'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_name=upd_tmarket.cons_agent_pos_code&select_list=1&is_upd=0&is_multiple=1','list');"><label class="fa fa-plus btnPointer"></label></span>
                                                        <span class="input-group-addon btnPointer no-bg" title="<cf_get_lang_main no ='51.Sil'>" onclick="remove_field('cons_agent_pos_code');"><label class="fa fa-minus btnPointer"></label></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-cons_hobby">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='239.Hobiler'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <select name="cons_hobby" id="cons_hobby" multiple >
                                                        <cfoutput query="get_hobby">
                                                            <option value="#hobby_id#" <cfif listfind(tmarket.consumer_hobby,hobby_id,',')>selected</cfif>>#hobby_name#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-cons_child">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='101.Çocuk Sayısı'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='101.Çocuk Sayısı  !'></cfsavecontent>
                                                    <cfinput type="text" name="child_lower" id="child_lower"  validate="integer" message="#message#" value="#tmarket.child_lower#">
                                                    <span class="input-group-addon no-bg"> - </span>
                                                    <cfinput type="text" name="child_upper" id="child_upper"  validate="integer" message="#message#" value="#tmarket.CHILD_upper#">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="13">
                                            <div class="form-group" id="item-cons_resource">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='237.İlişki Tipi'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <cf_wrk_combo
                                                        name="cons_resource"
                                                        option_name="RESOURCE"
                                                        option_value="RESOURCE_ID"
                                                        multiple="1"
                                                        is_option_text="0"
                                                        value="#tmarket.consumer_resource#"
                                                        query_name="GET_PARTNER_RESOURCE"
                                                        width="170"
                                                        height="80">
                                                </div>
                                            </div>
                                        <div class="form-group" id="item-cons_vocation_type">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='247.Meslek Tipi'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <cf_wrk_combo
                                                    name="cons_vocation_type"
                                                    query_name="GET_VOCATION_TYPE"
                                                    option_name="VOCATION_TYPE"
                                                    option_value="VOCATION_TYPE_ID"
                                                    multiple="1"
                                                    value="#tmarket.cons_vocation_type#"
                                                    width="170"
                                                    is_option_text="0"
                                                    height="80">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-cons_sector_cats">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='105.Şirket Sektörü'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="cons_sector_cats" id="cons_sector_cats" multiple >
                                                    <cfoutput query="get_sector_cats">
                                                        <option value="#sector_cat_id#" <cfif listfind(tmarket.cons_sector_cats,sector_cat_id,',')>selected</cfif>>#sector_cat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-cons_county_id">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1226.İlçe'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="input-group">
                                                    <select name="cons_county_id" id="cons_county_id" multiple >
                                                        <cfif get_cons_county.recordcount>
                                                            <cfoutput query="get_cons_county">
                                                                <option value="#get_cons_county.county_id#">#get_cons_county.county_name#</option>
                                                            </cfoutput>
                                                        </cfif>
                                                    </select>
                                                    <span class="input-group-addon btnPointer no-bg" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_tmarket.cons_county_id&field_name=upd_tmarket.cons_county_id&coklu_secim=1','small');" title="<cf_get_lang_main no='170.Ekle'>"><label class="fa fa-plus btnPointer"></label></span>
                                                    <span class="input-group-addon btnPointer no-bg" onclick="remove_field('cons_county_id');" title="<cf_get_lang_main no='51.Sil'>"><label class="fa fa-minus btnPointer"></label></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-cons_age">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='93.Yaş Aralığı'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='93.Yaş Aralığı !'></cfsavecontent>
                                                    <cfinput type="text" name="age_lower" id="age_lower"  validate="integer" message="#message#" value="#tmarket.age_lower#">
                                                    <span class="input-group-addon no-bg"> - </span>
                                                    <cfinput type="text" name="age_upper" id="age_upper"  validate="integer" message="#message#" value="#tmarket.age_upper#">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-cons_ozel_kod">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='377.Özel Kod'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <input type="text" name="cons_ozel_kod1" id="cons_ozel_kod1" value="<cfoutput>#tmarket.consumer_ozel_kod1#</cfoutput>"  maxlength="75">
                                            </div>
                                        </div>
                                            
                                        <div class="form-group" id="item-cons_size_cats">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='106.Şirketteki Çalışan Sayısı'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <select name="cons_size_cats" id="cons_size_cats" multiple >
                                                    <cfoutput query="get_company_size_cats">
                                                        <option value="#company_size_cat_id#" <cfif listfind(tmarket.cons_size_cats,company_size_cat_id,',')>selected</cfif>>#company_size_cat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                       
                                        
                                        <div class="form-group" id="item-cons_tmarket_membership_date">
                                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='215.Üyelik Tarihi Başlangıç'></label>
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='215.Üyelik Başlangıç Tarihi !'></cfsavecontent>
                                                    <cfinput type="text" name="tmarket_membership_startdate" id="tmarket_membership_startdate"  maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(tmarket.tmarket_membership_startdate,dateformat_style)#">
                                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="tmarket_membership_startdate"></span>
                                                    <span class="input-group-addon no-bg"></span>
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='13.Üyelik Bitiş Tarihi !'></cfsavecontent>
                                                    <cfinput type="text" name="tmarket_membership_finishdate" id="tmarket_membership_finishdate"  maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(tmarket.tmarket_membership_finishdate,dateformat_style)#">
                                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="tmarket_membership_finishdate"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </cf_box_elements>
                        <!--- Dinamik Segmentasyon --->
                        <cfif (isdefined("is_segmentasyon") and  is_segmentasyon eq 1) or not isdefined("is_segmentasyon")>
                            <cf_seperator id="dinamik_segmentasyon_" title="#getLang('campaign',298)#">
                                <cf_box_elements>
                                <div class="row" type="row" id="dinamik_segmentasyon_">
                                    <div class="col col-5 col-xs-12" type="column" sort="true" index="13">
                                        <div class="form-group" id="item-order_date" <cfif isdefined("is_segmentasyon") and  is_segmentasyon eq 1> style="display:"<cfelse> style="display:none"</cfif>>
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1278.Tarih Aralığı'></label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfif len(tmarket.order_start_date)>
                                                        <cfinput type="text" name="order_start_date" id="order_start_date"  validate="#validate_style#" value="#dateformat(tmarket.order_start_date,dateformat_style)#">
                                                    <cfelse>
                                                        <cfinput type="text" name="order_start_date" id="order_start_date"  validate="#validate_style#">
                                                    </cfif>
                                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="order_start_date"></span>
                                                    <span class="input-group-addon no-bg"></span>
                                                    <cfif len(tmarket.order_finish_date)>
                                                        <cfinput type="text" name="order_finish_date" id="order_finish_date"  validate="#validate_style#" value="#dateformat(tmarket.order_finish_date,dateformat_style)#">
                                                    <cfelse>
                                                        <cfinput type="text" name="order_finish_date" id="order_finish_date"  validate="#validate_style#">
                                                    </cfif>
                                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="order_finish_date"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-8 col-xs-12" type="column" sort="true" index="14">
                                        <div class="row">
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="form-group" id="item-baslik1" style="background-color: #E8E7E7">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><a href="javascript:gizle_goster(product);">&raquo;<cf_get_lang_main no ='245.Ürün'></a></label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" id="product">
                                            <div class="col col-6 col-xs-12">
                                                <div class="form-group" id="item-products">
                                                    <label class="hide"><cf_get_lang_main no='809.Ürün Adı'></label>
                                                    <div class="col col-8 col-xs-12">
                                                        <table class="workDevList">
                                                            <thead>
                                                                <tr>
                                                                    <input type="hidden" name="record_num1" id="record_num1" value="<cfoutput>#listlen(tmarket.order_product_id)#</cfoutput>">
                                                                    <th ><a style="cursor:pointer" onclick="add_row1();"><img src="images/plus_list.gif" border="0"></a></th>
                                                                    <th nowrap><cf_get_lang_main no='809.Ürün Adı'></th>
                                                                </tr>
                                                            </thead>
                                                            <cfif len(tmarket.order_product_id)>
                                                                <cfquery name="get_product" datasource="#dsn3#">
                                                                    SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN(#tmarket.order_product_id#)
                                                                </cfquery>
                                                            <cfelse>
                                                                <cfset get_product.recordcount = 0>
                                                            </cfif>
                                                            <tbody id="table1">
                                                            <cfif get_product.recordcount>
                                                                <cfoutput query="get_product">
                                                                    <tr id="frm_row1#currentrow#">
                                                                        <td><input type="hidden" name="row_kontrol1#currentrow#" id="row_kontrol1#currentrow#" value="1"><a style="cursor:pointer" onclick="sil1(#currentrow#);"><img  src="images/delete_list.gif" alt="Sil" border="0"></a></td>
                                                                        <td>
                                                                            <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                                                                            <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#product_name#">
                                                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=upd_tmarket.product_id#currentrow#&field_name=upd_tmarket.product_name#currentrow#','list');"><img src="/images/plus_thin.gif" border="0" alt="" align="absbottom"></a>
                                                                        </td>
                                                                    </tr>
                                                                </cfoutput>
                                                            </cfif>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="col col-4 col-xs-12">
                                                        <label class="col col-12">&nbsp;</label>
                                                        <label class="col col-12">&nbsp;</label>
                                                        <label class="col col-12"><input type="checkbox" name="is_product_and" id="is_product_and" value="1" onClick="check_product(1);" <cfif tmarket.order_product_status eq 1>checked</cfif>> <cf_get_lang_main no ='577.Ve'></label>
                                                        <label class="col col-12"><input type="checkbox" name="is_product_or" id="is_product_or" value="1" onClick="check_product(2);" <cfif tmarket.order_product_status eq 2>checked</cfif>><cf_get_lang_main no ='586.Veya'></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col col-6 col-xs-12">
                                                <div class="form-group" id="item-product_cats">
                                                    <label class="hide"><cf_get_lang_main no='1604.Ürün Kategorisi'></label>
                                                    <div class="col col-8 col-xs-12">
                                                        <table class="workDevList">
                                                            <thead>
                                                                <tr>
                                                                    <input type="hidden" name="record_num2" id="record_num2" value="<cfoutput>#listlen(tmarket.order_productcat_id)#</cfoutput>">
                                                                    <th ><a style="cursor:pointer" onclick="add_row2();"><img src="images/plus_list.gif" border="0"></a></th>
                                                                    <th nowrap><cf_get_lang_main no='1604.Ürün Kategorisi'></th>
                                                                </tr>
                                                            </thead>
                                                            <cfif len(tmarket.order_productcat_id)>
                                                                <cfquery name="get_product_cat" datasource="#dsn3#">
                                                                    SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID IN(#tmarket.order_productcat_id#)
                                                                </cfquery>
                                                            <cfelse>
                                                                <cfset get_product_cat.recordcount = 0>
                                                            </cfif>
                                                            <tbody id="table2">
                                                            <cfif get_product_cat.recordcount>
                                                                <cfoutput query="get_product_cat">
                                                                    <tr id="frm_row2#currentrow#">
                                                                        <td><input type="hidden" name="row_kontrol2#currentrow#" id="row_kontrol2#currentrow#" value="1"><a style="cursor:pointer" onclick="sil2(#currentrow#);"><img  src="images/delete_list.gif" alt="Sil" border="0"></a></td>
                                                                        <td><input type="hidden" name="productcat_id#currentrow#" id="productcat_id#currentrow#" value="#product_catid#">
                                                                            <input type="text" name="productcat_name#currentrow#" id="productcat_name#currentrow#" value="#product_cat#">
                                                                            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=upd_tmarket.productcat_id#currentrow#&field_name=upd_tmarket.productcat_name#currentrow#>');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
                                                                        </td>
                                                                    </tr>
                                                                </cfoutput>
                                                            </cfif>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="col col-4 col-xs-12">
                                                        <label class="col col-12">&nbsp;</label>
                                                        <label class="col col-12">&nbsp;</label>
                                                        <label class="col col-12"><input type="checkbox" name="is_productcat_and" id="is_productcat_and" value="1" onClick="check_productcat(1);" <cfif tmarket.order_productcat_status eq 1>checked</cfif>> <cf_get_lang_main no ='577.Ve'></label>
                                                        <label class="col col-12"><input type="checkbox" name="is_productcat_or" id="is_productcat_or" value="1" onClick="check_productcat(2);" <cfif tmarket.order_productcat_status eq 2>checked</cfif>> <cf_get_lang_main no ='586.Veya'></label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-8 col-xs-12" type="column" sort="true" index="15">
                                        <div class="row">
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="form-group" id="item-baslik2" style="background-color: #E8E7E7">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><a href="javascript:gizle_goster(promotion);">&raquo;<cf_get_lang no ='264.Promosyon'></a></label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" id="promotion">
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="form-group" id="item-promotions">
                                                    <label class="hide"><cf_get_lang no ='264.Promosyon'></label>
                                                    <div class="col col-8 col-xs-12">
                                                        <table class="workDevList">
                                                            <thead>
                                                                <tr>
                                                                    <input type="hidden" name="record_num3" id="record_num3" value="<cfoutput>#listlen(tmarket.promotion_id)#</cfoutput>">
                                                                    <th ><a style="cursor:pointer" onclick="add_row3();"><img src="images/plus_list.gif" alt="" border="0"></a></th>
                                                                    <th nowrap><cf_get_lang no ='264.Promosyon'></th>
                                                                </tr>
                                                            </thead>
                                                            <cfif len(tmarket.promotion_id)>
                                                                <cfquery name="get_prom" datasource="#dsn3#">
                                                                    SELECT PROM_ID,PROM_HEAD FROM PROMOTIONS WHERE PROM_ID IN(#tmarket.promotion_id#)
                                                                </cfquery>
                                                            <cfelse>
                                                                <cfset get_prom.recordcount = 0>
                                                            </cfif>
                                                            <tbody id="table3">
                                                            <cfif get_prom.recordcount>
                                                                <cfoutput query="get_prom">
                                                                    <tr id="frm_row3#currentrow#">
                                                                        <td><input type="hidden" name="row_kontrol3#currentrow#" id="row_kontrol3#currentrow#" value="1"><a style="cursor:pointer" onclick="sil3(#currentrow#);"><img  src="images/delete_list.gif" alt="Sil" border="0"></a></td>
                                                                        <td><input type="hidden" name="promotion_id#currentrow#" id="promotion_id#currentrow#" value="#prom_id#">
                                                                            <input type="text" name="promotion_name#currentrow#" id="promotion_name#currentrow#" value="#prom_head#">
                                                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_promotions&prom_id=upd_tmarket.promotion_id#currentrow#&prom_head=upd_tmarket.promotion_name#currentrow#','small');"><img src="/images/plus_thin.gif" alt="Sil" border="0" align="absbottom"></a>
                                                                        </td>
                                                                    </tr>
                                                                </cfoutput>
                                                            </cfif>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="col col-4 col-xs-12">
                                                        <label class="col col-12"><input type="checkbox" name="is_prom_and" id="is_prom_and" value="1" onClick="check_prom(1);" <cfif tmarket.promotion_status eq 1>checked</cfif>> <cf_get_lang_main no ='577.Ve'></label>
                                                        <label class="col col-12"><input type="checkbox" name="is_prom_or" id="is_prom_or" value="1" onClick="check_prom(2);" <cfif tmarket.promotion_status eq 2>checked</cfif>> <cf_get_lang_main no ='586.Veya'></label>
                                                        <div class="input-group x-15">
                                                            <input type="text" name="prom_count" id="prom_count" value="<cfif len(tmarket.promotion_count)><cfoutput>#tmarket.promotion_count#</cfoutput></cfif>" style="width:20px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
                                                            <span class="input-group-addon no-bg"><cf_get_lang no ='301.Promosyon Sayısı'></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-8 col-xs-12" type="column" sort="true" index="16">
                                        <div class="row">
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="form-group" id="item-baslik3" style="background-color: #E8E7E7">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><a href="javascript:gizle_goster(order);">&raquo;<cf_get_lang_main no ='199.Sipariş'></a></label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" id="order">
                                            <div class="col col-6 col-xs-12">
                                                <div class="form-group" id="item-order_date_opt">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='1601.Son'></label>
                                                    <div class="col col-9 col-xs-12">
                                                        <div class="input-group">
                                                            <input type="text" class="moneybox" name="order_date" id="order_date"  value="<cfif len(tmarket.last_day_count)><cfoutput>#tmarket.last_day_count#</cfoutput></cfif>" onKeyUp="return(FormatCurrency(this,event,0));">
                                                            <span class="input-group-addon">
                                                                <select name="order_date_opt" id="order_date_opt" >
                                                                    <option value="1" <cfif tmarket.last_day_type eq 1>selected</cfif>><cf_get_lang_main no ='78.Gün'></option>
                                                                    <option value="2" <cfif tmarket.last_day_type eq 2>selected</cfif>><cf_get_lang_main no ='1322.Hafta'></option>
                                                                    <option value="3" <cfif tmarket.last_day_type eq 3>selected</cfif>><cf_get_lang_main no ='1312.Ay'></option>
                                                                    <option value="4" <cfif tmarket.last_day_type eq 4>selected</cfif>><cf_get_lang_main no ='1043.Yıl'></option>
                                                                </select>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" id="item-order_amount">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang no ='306.Sipariş Tutarı'></label>
                                                    <div class="col col-9 col-xs-12">
                                                        <div class="input-group">
                                                            <input type="text" class="moneybox" name="order_amount" id="order_amount"  value="<cfif len(tmarket.order_amount)><cfoutput>#tlformat(tmarket.order_amount)#</cfoutput></cfif>" onKeyUp="return(FormatCurrency(this,event));">
                                                            <span class="input-group-addon">
                                                                <select name="sel_order_amount" id="sel_order_amount" >
                                                                    <option value="1" <cfif tmarket.order_amount_type eq 1>selected</cfif>><cf_get_lang no ='307.En Az'></option>
                                                                    <option value="2" <cfif tmarket.order_amount_type eq 2>selected</cfif>><cf_get_lang no ='308.En Çok'></option>
                                                                    <option value="3" <cfif tmarket.order_amount_type eq 3>selected</cfif>><cf_get_lang_main no ='80.Toplam'></option>
                                                                    <option value="4" <cfif tmarket.order_amount_type eq 4>selected</cfif>><cf_get_lang no ='309.Ortalama'></option>
                                                                </select>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" id="item-order_count">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang no ='311.Sipariş Adedi'></label>
                                                    <div class="col col-9 col-xs-12">
                                                        <div class="input-group">
                                                            <input type="text" class="moneybox" name="order_count" id="order_count"  value="<cfif len(tmarket.order_count)><cfoutput>#tmarket.order_count#</cfoutput></cfif>" onKeyUp="return(FormatCurrency(this,event,0));">
                                                            <span class="input-group-addon">
                                                                <select name="sel_order_count" id="sel_order_count" >
                                                                    <option value="1" <cfif tmarket.order_count_type eq 1>selected</cfif>><cf_get_lang no ='307.En Az'></option>
                                                                    <option value="2" <cfif tmarket.order_count_type eq 2>selected</cfif>><cf_get_lang no ='308.En Çok'></option>
                                                                    <option value="3" <cfif tmarket.order_count_type eq 3>selected</cfif>><cf_get_lang_main no ='80.Toplam'></option>
                                                                </select>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" id="item-order_commethod">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='678.İletişim Yöntemi'></label>
                                                    <div class="col col-9 col-xs-12">
                                                        <select name="order_commethod" id="order_commethod"  multiple>
                                                            <cfoutput query="get_commethod_types">
                                                                <option value="#commethod_id#" <cfif listfind(tmarket.order_commethod_id,commethod_id,',')>selected</cfif>>#commethod#</option>
                                                            </cfoutput>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col col-6 col-xs-12">
                                                <div class="form-group" id="item-is_order">
                                                    <label class="hide"><cf_get_lang no ='304.Sipariş Verenler'></label>
                                                    <label class="col col-3 col-xs-12">&nbsp;</label>
                                                    <label class="col col-9 col-xs-12"><input type="checkbox" name="is_order" id="is_order" value="1" onClick="check_order(1);" <cfif tmarket.is_given_order eq 1>checked</cfif>><cf_get_lang no ='304.Sipariş Verenler'></label>
                                                </div>
                                                <div class="form-group" id="item-is_not_order">
                                                    <label class="hide"><cf_get_lang no ='305.Sipariş Vermeyenler'></label>
                                                    <label class="col col-3 col-xs-12">&nbsp;</label>
                                                    <label class="col col-9 col-xs-12"><input type="checkbox" name="is_not_order" id="is_not_order" value="1" onClick="check_order(2);" <cfif tmarket.is_given_order eq 2>checked</cfif>><cf_get_lang no ='305.Sipariş Vermeyenler'></label>
                                                </div>
                                                <div class="form-group" id="item-product_amount">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang no ='310.Ürün Adedi'></label>
                                                    <div class="col col-9 col-xs-12">
                                                        <div class="input-group">
                                                            <input type="text" class="moneybox" name="product_amount" id="product_amount"  value="<cfif len(tmarket.product_count)><cfoutput>#tmarket.product_count#</cfoutput></cfif>" onKeyUp="return(FormatCurrency(this,event,0));">
                                                            <span class="input-group-addon">
                                                                <select name="sel_product_amount" id="sel_product_amount" >
                                                                    <option value="1" <cfif tmarket.product_count_type eq 1>selected</cfif>><cf_get_lang no ='307.En Az'></option>
                                                                    <option value="2" <cfif tmarket.product_count_type eq 2>selected</cfif>><cf_get_lang no ='308.En Çok'></option>
                                                                    <option value="3" <cfif tmarket.product_count_type eq 3>selected</cfif>><cf_get_lang_main no ='80.Toplam'></option>
                                                                    <option value="4" <cfif tmarket.product_count_type eq 4>selected</cfif>><cf_get_lang no ='309.Ortalama'></option>
                                                                </select>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" id="item-order_paymethod">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang_main no ='1104.Ödeme Yöntemi'></label>
                                                    <div class="col col-9 col-xs-12">
                                                        <select name="order_paymethod" id="order_paymethod"  multiple="multiple">
                                                            <optgroup label="<cf_get_lang no ='256.Ödeme Yöntemleri'>">
                                                                <cfoutput query="get_paymethod">
                                                                <option value="1-#paymethod_id#" <cfif listfind(tmarket.order_paymethod_id,paymethod_id,',')>selected</cfif>>&nbsp;&nbsp;#paymethod#</option>
                                                                </cfoutput>
                                                            </optgroup>
                                                            <optgroup label="<cf_get_lang no ='313.Kredi Kartı Ödeme Yöntemleri'>">
                                                                <cfoutput query="get_kk_paymethod">
                                                                <option value="2-#payment_type_id#" <cfif listfind(tmarket.order_cardpaymethod_id,payment_type_id,',')>selected</cfif>>&nbsp;&nbsp;#card_no#</option>
                                                                </cfoutput>
                                                            </optgroup>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-8 col-xs-12" type="column" sort="true" index="17">
                                        <div class="row">
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="form-group" id="item-baslik4" style="background-color: #E8E7E7">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><a href="javascript:gizle_goster(member);">&raquo;<cf_get_lang_main no ='246.Üye'></a></label>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row" id="member">
                                            <div class="col col-4 col-xs-12">
                                                <div class="form-group" id="item-member_stage">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang_main no ='174.Bireysel Üye'><cf_get_lang_main no ='70.Aşama'></label>
                                                    <div class="col col-9 col-xs-12">
                                                        <select name="member_stage" id="member_stage"  multiple>
                                                            <cfoutput query="get_process_cats">
                                                                <option value="#process_row_id#" <cfif listfind(tmarket.consumer_stage,process_row_id,',')>selected</cfif>>#stage#</option>
                                                            </cfoutput>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <div class="form-group" id="item-partmember_stage">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang_main no ='173.Kurumsal Üye'><cf_get_lang_main no ='70.Aşama'></label>
                                                    <div class="col col-9 col-xs-12">
                                                        <select name="partmember_stage" id="partmember_stage"  multiple>
                                                            <cfoutput query="get_process_cats_part">
                                                                <option value="#process_row_id#" <cfif listfind(tmarket.partner_stage,process_row_id,',')>selected</cfif>>#stage#</option>
                                                            </cfoutput>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <div class="form-group" id="item-birth_date">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='1315.Doğum Tarihi'></label>
                                                    <div class="col col-9 col-xs-12">
                                                        <div class="input-group">
                                                            <cfif len(tmarket.consumer_birthdate)>
                                                                <cfinput type="text" name="birth_date" id="birth_date"  validate="#validate_style#" value="#dateformat(tmarket.consumer_birthdate,dateformat_style)#">
                                                            <cfelse>
                                                                <cfinput type="text" name="birth_date" id="birth_date"  validate="#validate_style#">
                                                            </cfif>
                                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="birth_date"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" id="item-is_prom_select">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang no ='316.Promosyon Önerisi'></label>
                                                    <div class="col col-9 col-xs-12">
                                                        <select id="is_prom_select" name="is_prom_select" style="width:86px;">
                                                            <option value="1" <cfif tmarket.promotion_offer_status eq 1>selected</cfif>><cf_get_lang no ='317.Seçenler'></option>
                                                            <option value="2" <cfif tmarket.promotion_offer_status eq 2>selected</cfif>><cf_get_lang no ='318.Seçmeyenler'></option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col col-8 col-xs-12">
                                                <div class="form-group" id="item-checkboxes">
                                                    <label><input type="checkbox" name="is_cep_tel" id="is_cep_tel" value="1" <cfif tmarket.is_cons_ceptel eq 1>checked</cfif>>&nbsp;<cf_get_lang no ='319.Cep Telefonu olanlar'></label>
                                                    <label><input type="checkbox" name="is_email" id="is_email" value="1" <cfif tmarket.is_cons_email eq 1>checked</cfif>>&nbsp;<cf_get_lang no ='320.Email Adresi Olanlar'></label>
                                                    <label><input type="checkbox" name="is_tax" id="is_tax" value="1" <cfif tmarket.is_cons_tax eq 1>checked</cfif>>&nbsp;<cf_get_lang no ='321.Vergi Mükellefi Olanlar'></label>
                                                    <label><input type="checkbox" name="is_black_list" id="is_black_list" value="1" <cfif tmarket.is_cons_black_list eq 1>checked</cfif>>&nbsp;<cf_get_lang no ='325.Kara Listede Olanlar'></label>
                                                    <label><input type="checkbox" name="is_debt" id="is_debt" value="1" <cfif tmarket.is_cons_debt eq 1>checked</cfif>>&nbsp;<cf_get_lang no ='322.Vadesi Geçmiş Borcu Olanlar'></label>
                                                    <label><input type="checkbox" name="is_bloke" id="is_bloke" value="1" <cfif tmarket.is_cons_bloke eq 1>checked</cfif>>&nbsp;<cf_get_lang no ='323.Bloke Olanlar'></label>
                                                    <label><input type="checkbox" name="is_open_order" id="is_open_order" value="1" <cfif tmarket.is_cons_open_order eq 1>checked</cfif>>&nbsp;<cf_get_lang no ='324.Açık Sipariş Satırı Olanlar'></label>
                                                </div>
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <div class="form-group" id="item-password_day">
                                                    <label class="hide"><cf_get_lang no ='326.Şifresini'> ... <cf_get_lang no ='327.Gündür Değiştirmeyenler'></label>
                                                    <div class="input-group">
                                                        <span class="input-group-addon no-bg"><cf_get_lang no ='326.Şifresini'></span>
                                                        <input type="text" name="password_day" id="password_day" value="<cfif len(tmarket.cons_password_day)><cfoutput>#tmarket.cons_password_day#</cfoutput></cfif>" style="width:40px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
                                                        <span class="input-group-addon no-bg"><cf_get_lang no ='327.Gündür Değiştirmeyenler'></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-8 col-xs-12" type="column" sort="true" index="18">
                                        <div class="row">
                                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                <div class="form-group" id="item-baslik5" style="background-color: #E8E7E7">
                                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><a href="javascript:gizle_goster(other);">&raquo;<cf_get_lang_main no='744.Diğer'></a></label>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row" id="other">
                                            <div class="col col-6 col-xs-12">
                                                <div class="form-group" id="item-training">
                                                    <label class="hide"><cf_get_lang_main no ='7.Eğitim'></label>
                                                    <div class="col col-8 col-xs-12">
                                                        <table class="workDevList">
                                                            <thead>
                                                                <tr>
                                                                    <input type="hidden" name="record_num4" id="record_num4" value="<cfoutput>#listlen(tmarket.training_id)#</cfoutput>">
                                                                    <th ><a style="cursor:pointer" onclick="add_row4();"><img src="images/plus_list.gif" alt="Ekle" border="0"></a></th>
                                                                    <th nowrap><cf_get_lang_main no ='7.Eğitim'></th>
                                                                </tr>
                                                            </thead>
                                                            <cfif len(tmarket.training_id)>
                                                                <cfquery name="get_class" datasource="#dsn#">
                                                                    SELECT CLASS_ID,CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID IN(#tmarket.training_id#)
                                                                </cfquery>
                                                            <cfelse>
                                                                <cfset get_class.recordcount = 0>
                                                            </cfif>
                                                            <tbody id="table4">
                                                                <cfif get_class.recordcount>
                                                                    <cfoutput query="get_class">
                                                                        <tr id="frm_row4#currentrow#">
                                                                            <td><input type="hidden" name="row_kontrol4#currentrow#" id="row_kontrol4#currentrow#" value="1"><a style="cursor:pointer" onclick="sil4(#currentrow#);"><img  src="images/delete_list.gif" alt="Sil" border="0"></a></td>
                                                                            <td>
                                                                                <input type="hidden" name="training_id#currentrow#" id="training_id#currentrow#" value="#class_id#">
                                                                                <input type="text" name="training_name#currentrow#" id="training_name#currentrow#" value="#class_name#">
                                                                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_trainings&field_id=upd_tmarket.training_id#currentrow#&field_name=upd_tmarket.training_name#currentrow#','list');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
                                                                            </td>
                                                                        </tr>
                                                                    </cfoutput>
                                                                </cfif>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="col col-4 col-xs-12">
                                                        <label class="col col-12">&nbsp;</label>
                                                        <label class="col col-12">&nbsp;</label>
                                                        <label class="col col-12"><input type="checkbox" name="is_train_and" id="is_train_and" value="1" onClick="check_train(1);" <cfif tmarket.training_status eq 1>checked</cfif>> <cf_get_lang_main no ='577.Ve'></label>
                                                        <label class="col col-12"><input type="checkbox" name="is_train_or" id="is_train_or" value="1" onClick="check_train(2);" <cfif tmarket.training_status eq 2>checked</cfif>> <cf_get_lang_main no ='586.Veya'></label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                             </cf_box_elements>
                            </cfif>
                       <cf_box_footer>
                            <div class="col col-6 col-xs-12">
                                <cf_record_info query_name="tmarket">
                            </div>
                            <div class="col col-6 col-xs-12">
                                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=campaign.del_target_market&tmarket_id=#attributes.tmarket_id#&head=#tmarket.tmarket_no# #tmarket.tmarket_name#' add_function='limit_control()'>
                            </div>
                        </cf_box_footer>
                    
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	<cfif isdefined("is_segmentasyon")>
		var is_segmentasyon = '<cfoutput>#is_segmentasyon#</cfoutput>';
	</cfif>

	function remove_field(field_option_name)
	{
		field_option_name_value = eval('document.upd_tmarket.' + field_option_name);
		if(field_option_name_value != undefined)
			for (i=field_option_name_value.options.length-1;i>-1;i--)
			{
				if (field_option_name_value.options[i].selected==true)
				{
					field_option_name_value.options.remove(i);
				}
			}
	}
	function select_all(selected_field)
	{
		if(eval("document.upd_tmarket." + selected_field + "") != undefined)
		{
			var m = eval("document.upd_tmarket." + selected_field + ".length");
			for(i=0;i<m;i++)
			{
				eval("document.upd_tmarket."+selected_field+"["+i+"].selected=true")
			}
		}
	}
	function hepsini_sec()
	{
		select_all('product_category');
		select_all('cons_city_id');
		select_all('cons_county_id');
		select_all('company_city_id');
		select_all('company_county_id');
		select_all('comp_agent_pos_code');
		select_all('cons_agent_pos_code');

	}
	function limit_control()
	{

		if((document.getElementById("age_lower") != undefined) && (document.getElementById("age_lower").value != '') && (document.getElementById("age_upper").value != '') && (document.getElementById("age_lower").value > document.getElementById("age_upper").value))
		{

			alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='93.Yaş Aralığı !'>");
			return false;
		}

		if(document.getElementById('process_stage').value == "")
		{
			alert("Süreç Yetkiniz Yok!");
			return false;
		}

		if ((document.getElementById("tmarket_membership_startdate") != undefined) && (document.getElementById("tmarket_membership_startdate").value != '') && (document.getElementById("tmarket_membership_finishdate").value != '') && !date_check(document.getElementById("tmarket_membership_startdate"),document.getElementById("tmarket_membership_finishdate"),"<cf_get_lang no='167.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır !'>"))
				 return false;
		hepsini_sec();
		if(document.getElementById("order_amount") != undefined)
			document.getElementById("order_amount").value = filterNum(document.getElementById("order_amount").value);
		return true;
	}
	function check_order(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_order").checked == true)
				document.getElementById("is_not_order").checked = false;
		}
		else
		{
			if(document.getElementById("is_not_order").checked == true)
				document.getElementById("is_order").checked = false;
		}
	}
	function check_product(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_product_and").checked == true)
				document.getElementById("is_product_or").checked = false;
		}
		else
		{
			if(document.getElementById("is_product_or").checked == true)
				document.getElementById("is_product_and").checked = false;
		}
	}
	function check_productcat(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_productcat_and").checked == true)
				document.getElementById("is_productcat_or").checked = false;
		}
		else
		{
			if(document.getElementById("is_productcat_or").checked == true)
				document.getElementById("is_productcat_and").checked = false;
		}
	}
	function check_prom(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_prom_and").checked == true)
				document.getElementById("is_prom_or").checked = false;
		}
		else
		{
			if(document.getElementById("is_prom_or").checked == true)
				document.getElementById("is_prom_and").checked = false;
		}
	}
	function check_prom_sel(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_prom_select").checked == true)
				document.getElementById("is_notprom_select").checked = false;
		}
		else
		{
			if(document.getElementById("is_notprom_select").checked == true)
				document.getElementById("is_prom_select").checked = false;
		}
	}
	function check_train(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_train_and").checked == true)
				document.getElementById("is_train_or").checked = false;
		}
		else
		{
			if(document.getElementById("is_train_or").checked == true)
				document.getElementById("is_train_and").checked = false;
		}
	}
<cfif (isdefined("is_segmentasyon") and  is_segmentasyon eq 1) or not isdefined("is_segmentasyon")>
	var row_count1= <cfoutput>#listlen(tmarket.order_product_id)#</cfoutput>;
	var row_count2= <cfoutput>#listlen(tmarket.order_productcat_id)#</cfoutput>;
	var row_count3= <cfoutput>#listlen(tmarket.promotion_id)#</cfoutput>;
	var row_count4= <cfoutput>#listlen(tmarket.training_id)#</cfoutput>;
	function sil1(sy)
	{
		var my_element=document.getElementById("row_kontrol1"+sy);
		my_element.value=0;
		var my_element=eval("frm_row1"+sy);
		my_element.style.display="none";
	}
	function add_row1()
	{
		row_count1++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row1" + row_count1);
		newRow.setAttribute("id","frm_row1" + row_count1);
		document.getElementById("record_num1").value=row_count1;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol1'+row_count1+'" id="row_kontrol1'+row_count1+'" value="1"><a style="cursor:pointer" onclick="sil1(' + row_count1 + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="product_id' + row_count1 +'" id="product_id' + row_count1 +'"><input type="text" name="product_name' + row_count1 +'" id="product_name' + row_count1 +'" class="text" style="width:165px;" readonly>'
						+' '+'<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=upd_tmarket.product_id" + row_count1 + "&field_name=upd_tmarket.product_name" + row_count1 + "','list');"+'"></span></div>';
	}
	function sil2(sy)
	{
		var my_element=document.getElementById("row_kontrol2"+sy);
		my_element.value=0;
		var my_element=eval("frm_row2"+sy);
		my_element.style.display="none";
	}
	function add_row2()
	{
		row_count2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		newRow.setAttribute("name","frm_row2" + row_count2);
		newRow.setAttribute("id","frm_row2" + row_count2);
		document.getElementById("record_num2").value=row_count2;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol2'+row_count2+'" id="row_kontrol2'+row_count2+'" value="1"><a style="cursor:pointer" onclick="sil2(' + row_count2 + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="productcat_id' + row_count2 +'" id="productcat_id' + row_count2 +'"><input type="text" name="productcat_name' + row_count2 +'" id="productcat_name' + row_count2 +'" class="text" style="width:165px;" readonly>'
						+' '+'<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=upd_tmarket.productcat_id" + row_count2 + "&field_name=upd_tmarket.productcat_name" + row_count2 + "</cfoutput>');"+'"></span></div>';
	}
	function sil3(sy)
	{
		var my_element=document.getElementById("row_kontrol3"+sy);
		my_element.value=0;
		var my_element=eval("frm_row3"+sy);
		my_element.style.display="none";
	}
	function add_row3()
	{
		row_count3++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);
		newRow.setAttribute("name","frm_row3" + row_count3);
		newRow.setAttribute("id","frm_row3" + row_count3);
		document.getElementById("record_num3").value=row_count3;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol3'+row_count3+'" id="row_kontrol3'+row_count3+'" value="1"><a style="cursor:pointer" onclick="sil3(' + row_count3 + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="promotion_id' + row_count3 +'" id="promotion_id' + row_count3 +'"><input type="text" name="promotion_name' + row_count3 +'" id="promotion_name' + row_count3 +'" class="text" style="width:165px;" readonly>'
						+' '+'<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_promotions&prom_id=upd_tmarket.promotion_id" + row_count3 + "&prom_head=upd_tmarket.promotion_name" + row_count3 + "</cfoutput>','small');"+'"></span></div>';
	}
	function sil4(sy)
	{
		var my_element=document.getElementById("row_kontrol4"+sy);
		my_element.value=0;
		var my_element=eval("frm_row4"+sy);
		my_element.style.display="none";
	}
	function add_row4()
	{
		row_count4++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table4").insertRow(document.getElementById("table4").rows.length);
		newRow.setAttribute("name","frm_row4" + row_count4);
		newRow.setAttribute("id","frm_row4" + row_count4);
		document.getElementById("record_num4").value=row_count4;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol4'+row_count4+'" id="row_kontrol4'+row_count4+'" value="1"><a style="cursor:pointer" onclick="sil4(' + row_count4 + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="training_id' + row_count4 +'" id="training_id' + row_count4 +'"><input type="text" name="training_name' + row_count4 +'" id="training_name' + row_count4 +'" class="text" style="width:165px;" readonly>'
						+' '+'<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_trainings&field_id=upd_tmarket.training_id" + row_count4 + "&field_name=upd_tmarket.training_name" + row_count4 + "</cfoutput>','list');"+'"></span></div>';
	}
	if(row_count1 == 0)
		add_row1();
	if(row_count2 == 0)
		add_row2();
	if(row_count3 == 0)
		add_row3();
	if(row_count4 == 0)
		add_row4();
</cfif>
</script>
