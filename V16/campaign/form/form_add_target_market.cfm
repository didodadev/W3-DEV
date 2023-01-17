<!---Select ifadeleri düzenlendi.24082012 e.a --->
<cfset xml_page_control_list = 'is_segmentasyon'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1" fuseact="campaign.form_add_target_market">
<cf_get_lang_set module_name="campaign">
<cfparam name="attributes.req_comp" default="">
<cfparam name="attributes.req_cons" default="">
<cfparam name="attributes.connect_member" default="">
<cfparam name="attributes.comp_want_eamil" default="2">
<cfparam name="attributes.cons_want_eamil" default="2">
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
<cfquery name="get_firm_type" datasource="#dsn#">
    SELECT 
        #dsn#.Get_Dynamic_Language(FIRM_TYPE_ID,'#session.ep.language#','SETUP_FIRM_TYPE','FIRM_TYPE',NULL,NULL,FIRM_TYPE) AS FIRM_TYPE,
        FIRM_TYPE_ID 
    FROM 
        SETUP_FIRM_TYPE 
    ORDER BY 
        FIRM_TYPE 
</cfquery>
<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
	SELECT 
    	COMP_ID,
        #dsn#.Get_Dynamic_Language(COMP_ID,'#session.ep.language#','OUR_COMPANY','NICK_NAME',NULL,NULL,NICK_NAME) AS NICK_NAME
    FROM 
    	OUR_COMPANY
</cfquery>
<cfquery name="ALL_DEPARTMENTS" datasource="#DSN#">
	SELECT 
        #dsn#.Get_Dynamic_Language(BRANCH_ID,'#session.ep.language#','BRANCH','BRANCH_NAME',NULL,NULL,BRANCH_NAME) AS BRANCH_NAME,
		BRANCH_ID 
	FROM 
		BRANCH
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfinclude template="../query/get_product_cats.cfm">
<cfinclude template="../query/get_consumer_cats.cfm">
<cfinclude template="../query/get_company_cats.cfm">
<cfinclude template="../query/get_company_size_cats.cfm">
<cfinclude template="../query/get_sector_cats.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<cfquery name="get_customer_value" datasource="#dsn#">
	SELECT CUSTOMER_VALUE_ID, #dsn#.Get_Dynamic_Language(CUSTOMER_VALUE_ID,'#session.ep.language#','SETUP_CUSTOMER_VALUE','CUSTOMER_VALUE',NULL,NULL,CUSTOMER_VALUE) AS CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="get_ims_code" datasource="#dsn#">
	SELECT IMS_CODE_ID,	IMS_CODE, #dsn#.Get_Dynamic_Language(IMS_CODE_ID,'#session.ep.language#','SETUP_IMS_CODE','IMS_CODE_NAME',NULL,NULL,IMS_CODE_NAME) AS IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID IS NOT NULL ORDER BY IMS_CODE
</cfquery>
<cfquery name="get_hobby" datasource="#dsn#">
	SELECT HOBBY_ID,#dsn#.Get_Dynamic_Language(HOBBY_ID,'#session.ep.language#','SETUP_HOBBY','HOBBY_NAME',NULL,NULL,HOBBY_NAME) AS HOBBY_NAME FROM SETUP_HOBBY
</cfquery>
<cfquery name="GET_SALES_ZONE" datasource="#dsn#">
	SELECT SZ_ID,#dsn#.Get_Dynamic_Language(SZ_ID,'#session.ep.language#','SALES_ZONES','SZ_NAME',NULL,NULL,SZ_NAME) AS SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_EDU_LEVEL" datasource="#dsn#">
	SELECT EDU_LEVEL_ID, #dsn#.Get_Dynamic_Language(EDU_LEVEL_ID,'#session.ep.language#','SETUP_EDUCATION_LEVEL','EDUCATION_NAME',NULL,NULL,EDUCATION_NAME) AS EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL
</cfquery>
<cfquery name="GET_SOCIETIES" datasource="#DSN#">
	SELECT SOCIETY_ID,#dsn#.Get_Dynamic_Language(SOCIETY_ID,'#session.ep.language#','SETUP_SOCIAL_SOCIETY','SOCIETY',NULL,NULL,SOCIETY) AS SOCIETY FROM SETUP_SOCIAL_SOCIETY ORDER BY SOCIETY
</cfquery>
<cfquery name="GET_INCOME_LEVEL" datasource="#DSN#">
	SELECT INCOME_LEVEL_ID, #dsn#.Get_Dynamic_Language(INCOME_LEVEL_ID,'#session.ep.language#','SETUP_INCOME_LEVEL','INCOME_LEVEL',NULL,NULL,INCOME_LEVEL) AS INCOME_LEVEL FROM SETUP_INCOME_LEVEL ORDER BY INCOME_LEVEL
</cfquery>
<cfquery name="get_req" datasource="#DSN#">
	SELECT 
    	REQ_ID,
        #dsn#.Get_Dynamic_Language(REQ_ID,'#session.ep.language#','SETUP_REQ_TYPE','REQ_NAME',NULL,NULL,REQ_NAME) AS REQ_NAME
	FROM 
    	SETUP_REQ_TYPE
</cfquery>
<cfquery name="get_commethod_types" datasource="#dsn#">
	SELECT
    	COMMETHOD_ID,
        COMMETHOD
	 FROM 
    	SETUP_COMMETHOD 
    ORDER BY 
    	COMMETHOD
</cfquery>
<cfquery name="get_paymethod" datasource="#dsn#">
	SELECT 
    	SP.PAYMETHOD_ID,
        SP.PAYMETHOD
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
<cf_papers paper_type="TARGET_MARKET">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">   
    <cf_box>
        <cfform name="add_tmarket" id="add_tmarket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_target_market">
            <cfinput name="is_active" value="1" type="hidden">
            <cfif isdefined('camp_id')><input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#camp_id#</cfoutput>"></cfif>
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-tmarket_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='68.Başlık'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.Başlık !'></cfsavecontent>
                            <cfinput type="text" name="tmarket_name" id="tmarket_name" style="width:250px;" maxlength="100" required="Yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_detail="0" process_cat_width="140" is_upd='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-before_process">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('objects2',179)#	#getLang('campaign',43)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfquery name="get_records" datasource="#dsn3#">
                                    SELECT #dsn#.Get_Dynamic_Language(TMARKET_ID,'#session.ep.language#','TARGET_MARKETS','TMARKET_NAME',NULL,NULL,TMARKET_NAME) AS T_MARKET_NAME,* FROM TARGET_MARKETS ORDER BY TMARKET_NAME
                            </cfquery>
                            <select name="before_process" id="before_process" style="width:60px;"  onchange="beforeProcess()">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_records">
                                    <option value="#TMARKET_ID#">#t_market_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                        <div class="form-group">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_maillist" id="is_maillist" value="1"><cf_get_lang no='258.Mail Listesi'>(<cf_get_lang no ='260.Üye Olmayıp Mail Listesine Mesaj Bırakanlar'>)</label>
                        </div>
                </div>
            </cf_box_elements>       
            <!--- Kurumsal Üyeler --->
                <cf_seperator id="kurumsal_uyeler" header="#getLang('campaign',108)#">
                <cf_box_elements>   
                    <div class="row" type="row" id="kurumsal_uyeler">
                        <div class="col col-12" type="column" sort="true" index="2">
                            <div class="form-group" id="item-is_company_search">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="checkbox" name="is_company_search" id="is_company_search" value="1"  checked="checked">
                                    <cf_get_lang no='108.Kurumsal Üye Özellikleri'> 
                                </label>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="3" sort="true" type="column">
                                <div class="form-group" id="item-comp_want_email">
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                        <label><cf_get_lang_main no='1666.Mail'></label>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                        <select name="comp_want_email" id="comp_want_email" >
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <option value="2"><cf_get_lang_main no='296.Tümü'></option>
                                            <option value="1"><cf_get_lang no='389.İsteyen'></option>
                                            <option value="0"><cf_get_lang no='390.İstemeyen'></option>
                                        </select>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" >
                                        <select name="connect_member" id="connect_member" >
                                            <option value=""><cf_get_lang_main no='296.Tümü'></option>
                                            <option value="1"><cf_get_lang no='31.Bağlı Üye'></option>
                                            <option value="0"><cf_get_lang no='32.Bağlı Üye Olmayan'></option>
                                        </select> 
                                    </div>
                                </div>
                            </div>
                            <div class="col col-8 col-md-8 col-sm-6 col-xs-12" index="4" sort="true" type="column">
                                <div class="form-group" id="item-comp_want_tip">
                                    <div class="col col-2 col-xs-12">
                                        <label><input type="checkbox" name="IS_POTANTIAL" id="IS_POTANTIAL" value="1"> <cf_get_lang_main no='165.Potansiyel'></label>
                                    </div>
                                    <div class="col col-1 col-xs-12">
                                        <label><input type="checkbox" name="IS_POTANTIAL_CURRENT" id="IS_POTANTIAL_CURRENT" value="0"> <cf_get_lang_main no='649.cari'></label> 
                                    </div>
                                    <div class="col col-1 col-xs-12">
                                        <label><input type="checkbox" name="PARTNER_STATUS" id="PARTNER_STATUS" value="1"> <cf_get_lang_main no='81.Aktif'></label>
                                    </div>
                                    <div class="col col-1 col-xs-12">
                                        <label><input type="checkbox" name="PARTNER_STATUS_PASSIVE" id="PARTNER_STATUS_PASSIVE" value="0"> <cf_get_lang_main no='82.Pasif'></label>
                                    </div>
                                    <div class="col col-1 col-xs-12">
                                        <label><input type="checkbox" name="IS_BUYER" id="IS_BUYER" value="1"><cf_get_lang_main no='1321.Alıcı'></label>
                                    </div>
                                    <div class="col col-1 col-xs-12">      
                                        <label><input type="checkbox" name="IS_SELLER" id="IS_SELLER" value="1"><cf_get_lang_main no='1461.Satıcı'></label>
                                    </div>
                                    <div class="col col-1 col-xs-12">
                                        <label><input type="checkbox" name="PARTNER_TMARKET_SEX" id="PARTNER_TMARKET_SEX" value="1"><cf_get_lang no='90.Bay'></label>
                                    </div>
                                    <div class="col col-1 col-xs-12">
                                        <label><input type="checkbox" name="PARTNER_TMARKET_SEX_WOMAN" id="PARTNER_TMARKET_SEX_WOMAN" value="0,2"><cf_get_lang no='91.Bayan'></label>
                                    </div>
                                    <div class="col col-3 col-xs-12">        
                                        <label><input type="checkbox" name="ONLY_FIRM_MEMBERS" id="ONLY_FIRM_MEMBERS" value="1"><cf_get_lang no='33.Yalnız Firma Yetkilisi'></label>
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
                                            <option value="#companycat_id#">#companycat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-PARTNER_DEPARTMENT">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='160.Departman'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="PARTNER_DEPARTMENT" id="PARTNER_DEPARTMENT" multiple >
                                        <cfoutput query="get_partner_departments">
                                            <option value="#PARTNER_DEPARTMENT_ID#">#PARTNER_DEPARTMENT#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-product_category">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='155.Ürün Kategorileri'> *</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                       <div class="input-group">
                                        <select name="product_category" id="product_category" multiple="multiple" style="width:170px; height:80px;"></select>
                                        <span class="input-group-addon btnPointer no-bg" title="<cf_get_lang_main no='170.Ekle'>" onclick="windowopen('<cfoutput>#request.self#?</cfoutput>fuseaction=worknet.popup_list_product_categories&field_name=add_tmarket.product_category','medium');"><label class="fa fa-plus btnPointer"></label></span>
                                        <span class="input-group-addon btnPointer no-bg" title="<cf_get_lang_main no='51.Ekle'>" onclick="remove_field('product_category');"><label class="fa fa-minus btnPointer"></label></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-company_ims_code">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='238.Mikro Bölge'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="company_ims_code" id="company_ims_code" multiple >
                                        <cfoutput query="get_ims_code">
                                            <option value="#IMS_CODE_ID#">#IMS_CODE_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-comp_agent_pos_code">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='496.Temsilci'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <select name="comp_agent_pos_code" id="comp_agent_pos_code"  multiple style="width:170px;height:80px"></select>
                                        <span class="input-group-addon btnPointer no-bg" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_name=add_tmarket.comp_agent_pos_code&select_list=1&is_upd=0&is_multiple=1','list');" title="<cf_get_lang_main no ='170.Ekle'>"><label class="fa fa-plus btnPointer"></label></span>
                                        <span class="input-group-addon btnPointer no-bg" title="<cf_get_lang_main no='51.Sil'>" onclick="remove_field('comp_agent_pos_code');"><label class="fa fa-minus btnPointer"></label></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-rel_company_name">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='173. Kurumsal Üye'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="text" name="rel_company_name" id="rel_company_name" value="" style="width:160px;"><input type="hidden" name="rel_company_id" id="rel_company_id" value="">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_period_kontrol=0&select_list=2,6&field_comp_id=add_tmarket.rel_company_id&field_comp_name=add_tmarket.rel_company_name','list')"></span>
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
                                                <option value="#SZ_ID#">#SZ_NAME#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            <div class="form-group" id="item-partner_mission">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='161.Görev'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="PARTNER_MISSION" id="PARTNER_MISSION" multiple >
                                        <cfoutput query="get_partner_positions">
                                            <option value="#PARTNER_POSITION_ID#">#PARTNER_POSITION#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-company_country_id">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='807.Ülke'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="company_country_id" id="company_country_id"   multiple="multiple">
                                        <cfoutput query="get_country">
                                            <option value="#country_id#">#country_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-req_comp">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='495.Yetkinlik'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="req_comp" id="req_comp" multiple >
                                        <cfoutput query="get_req">
                                            <option  value="#get_req.REQ_ID#">#get_req.REQ_NAME#</option>
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
                                    <select name="company_size_cats" id="company_size_cats"multiple >
                                        <cfoutput query="get_company_size_cats">
                                            <option value="#company_size_cat_id#">#company_size_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-firm_type">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='30.Firma Tipi'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="firm_type" id="firm_type" multiple >
                                        <cfoutput query="get_firm_type">
                                            <option value="#firm_type_id#">#firm_type#</option>
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
                                            <option value="#customer_value_id#">#customer_value#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-sector_cats">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='167.Sektör'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="sector_cats" id="sector_cats" multiple >
                                        <cfoutput query="get_sector_cats">
                                            <option value="#sector_cat_id#">#sector_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-company_city">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='559.Şehir'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <select name="company_city_id" id="company_city_id" multiple >
                                        </select>
                                        <span class="input-group-addon btnPointer no-bg" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_tmarket.company_city_id&field_name=add_tmarket.company_city_id&coklu_secim=1','small');" title="<cf_get_lang_main no='170.Ekle'>"><label class="fa fa-plus btnPointer"></label></span>
                                        <span class="input-group-addon btnPointer no-bg" onClick="remove_field('company_city_id');" title="<cf_get_lang_main no='51.Sil'>"><label class="fa fa-minus btnPointer"></label></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-comp_rel_comp">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='162.Şirket'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="comp_rel_comp" id="comp_rel_comp"  multiple="multiple">
                                        <cfoutput query="GET_OUR_COMPANIES">
                                            <option value="#comp_id#">#NICK_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-company_hobby">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='239. Hobiler'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="company_hobby" id="company_hobby" multiple >
                                        <cfoutput query="get_hobby">
                                            <option value="#HOBBY_ID#">#HOBBY_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                      
                        
                            <div class="form-group" id="item-company_county_id">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1226.İlçe'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <select name="company_county_id" id="company_county_id" multiple ></select>
                                        <span class="input-group-addon btnPointer no-bg" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_tmarket.company_county_id&field_name=add_tmarket.company_county_id&coklu_secim=1','small');" title="<cf_get_lang_main no='170.Ekle'>"><label class="fa fa-plus btnPointer"></label></span>
                                        <span class="input-group-addon btnPointer no-bg" onClick="remove_field('company_county_id');" title="<cf_get_lang_main no='51.Sil'>"><label class="fa fa-minus btnPointer"></label></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-comp_rel_branch">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='41.Şube'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="comp_rel_branch" id="comp_rel_branch"  multiple="multiple">
                                        <cfoutput query="all_departments">
                                            <option value="#branch_id#">#branch_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-company_ozel_kod">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='377.Özel Kod'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <cfoutput>
                                            <label class=""><cfoutput>#getLang('main',377)# 1</cfoutput></label><input type="text" name="company_ozel_kod1" id="company_ozel_kod1" value=""  maxlength="75">
                                            <span class="input-group-addon no-bg"></span>
                                            <label class=""><cfoutput>#getLang('main',377)# 2</cfoutput></label><input type="text" name="company_ozel_kod2" id="company_ozel_kod2" value="" maxlength="75">
                                            <span class="input-group-addon no-bg"></span>
                                            <label class=""><cfoutput>#getLang('main',377)# 3</cfoutput></label><input type="text" name="company_ozel_kod3" id="company_ozel_kod3" value=""  maxlength="75">
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
                        <div class="col col-12" type="column" sort="true" index="8">
                            <div class="form-group" id="item-is_consumer_search">
                                <label><input type="checkbox" name="is_consumer_search" id="is_consumer_search" value="1" checked="checked"><cf_get_lang no='89.Bireysel Üye Özellikleri'></label>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="9">
                                <div class="form-group" id="item-cons_want_email">
                                    <label class="col col-4"><cf_get_lang_main no='1666.Mail'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="cons_want_email" id="cons_want_email">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <option value="2"><cf_get_lang_main no='296.Tümü'></option>
                                            <option value="1"><cf_get_lang no='389.İsteyen'></option>
                                            <option value="0"><cf_get_lang no='390.İstemeyen'></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" sort="true" index="10">
                            <div class="form-group" id="item-cons-medeni">
                                 <div class="col col-2">
                                    <label><input type="checkbox" name="CONS_IS_POTANTIAL" id="CONS_IS_POTANTIAL" value="1"><cf_get_lang_main no='165.Potansiyel'></label>
                                </div>
                                <div class="col col-1">
                                    <label><input type="checkbox" name="CONS_IS_CURRENT" id="CONS_IS_CURRENT" value="0"><cf_get_lang_main no='649.cari '></label>
                                </div>
                                <div class="col col-1">
                                    <label><input type="checkbox" name="cons_status" id="cons_status" value="1"><cf_get_lang_main no='81.Aktif'></label>
                                </div>
                                <div class="col col-1">
                                    <label><input type="checkbox" name="cons_status_passive" id="cons_status_passive" value="0"><cf_get_lang_main no='82.Pasif'></label>
                                </div>
                                <div class="col col-1">
                                        <label><input type="checkbox" name="tmarket_sex" id="tmarket_sex" value="1"><cf_get_lang no='90.Bay'></label>
                                </div>
                                <div class="col col-1">
                                    <label><input type="checkbox" name="tmarket_sex_woman" id="tmarket_sex_woman" value="0"><cf_get_lang no='91.Bayan'></label>
                                </div>
                                <div class="col col-1">
                                    <label><input type="checkbox" name="tmarket_marital_status" id="tmarket_marital_status" value="0"><cf_get_lang no='99.Bekar'></label>
                                </div>
                                <div class="col col-1">
                                    <label><input type="checkbox" name="tmarket_marital_status_married" id="tmarket_marital_status_married" value="1"><cf_get_lang no='100.Evli'></label>
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
                                        <option value="#conscat_id#">#conscat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-cons_income_level">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='245.Gelir Düzeyi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="cons_income_level" id="cons_income_level" multiple >
                                    <cfoutput query="GET_INCOME_LEVEL">
                                        <option value="#INCOME_LEVEL_ID#">#INCOME_LEVEL#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                            <div class="form-group" id="item-cons_ims_code">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='238.Mikro Bölge'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="cons_ims_code" id="cons_ims_code" multiple >
                                        <cfoutput query="get_ims_code">
                                            <option value="#IMS_CODE_ID#">#IMS_CODE_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        <div class="form-group" id="item-req_cons">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='495.Yetkinlik'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="req_cons" id="req_cons" multiple >
                                    <cfoutput query="get_req">
                                        <option value="#get_req.REQ_ID#">#get_req.REQ_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-cons_rel_branch">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='41.Şube'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="cons_rel_branch" id="cons_rel_branch"  multiple="multiple">
                                    <cfoutput query="all_departments">
                                        <option value="#branch_id#">#branch_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                         <div class="form-group " id="item-cons_value">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1140.Müşteri Değeri'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="cons_value" id="cons_value" multiple >
                                    <cfoutput query="get_customer_value">
                                        <option value="#customer_value_id#">#customer_value#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-cons_rel_comp">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='162.Şirket'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="cons_rel_comp" id="cons_rel_comp"  multiple="multiple">
                                    <cfoutput query="GET_OUR_COMPANIES">
                                        <option value="#comp_id#">#NICK_NAME#</option>
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
                                            <option value="#SZ_ID#">#SZ_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        <div class="form-group" id="item-cons_education">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='246.Eğitim Seviyesi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="cons_education" id="cons_education" multiple >
                                    <cfoutput query="get_edu_level">
                                        <option value="#EDU_LEVEL_ID#">#EDUCATION_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-cons_society">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='248.Sosyal Güvenlik Kurumu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="cons_society" id="cons_society" multiple >
                                    <cfoutput query="GET_SOCIETIES">
                                        <option value="#SOCIETY_ID#">#SOCIETY#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-cons_city_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='559.Şehir'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <select name="cons_city_id" id="cons_city_id" multiple ></select>
                                    <span class="input-group-addon btnPointer no-bg" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_tmarket.cons_city_id&field_name=add_tmarket.cons_city_id&coklu_secim=1','small');" title="<cf_get_lang_main no ='170.Ekle'>"><label class="fa fa-plus btnPointer"></label></span>
                                    <span class="input-group-addon btnPointer no-bg" onclick="remove_field('cons_city_id');" title="<cf_get_lang_main no ='51.Sil'>"><label class="fa fa-minus btnPointer"></label></span>
                                </div>
                            </div>
                        </div>
                            <div class="form-group" id="item-cons_agent_pos_code">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='244.İlişkili'><cf_get_lang_main no='496.Temsilci'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <div class="input-group">
                                        <select name="cons_agent_pos_code" id="cons_agent_pos_code" style="width:170px;height:80px" multiple></select>
                                        <span class="input-group-addon btnPointer no-bg" title="<cf_get_lang_main no ='170.Ekle'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_name=add_tmarket.cons_agent_pos_code&select_list=1&is_upd=0&is_multiple=1','list');"><label class="fa fa-plus btnPointer"></label></span>
                                        <span class="input-group-addon btnPointer no-bg" title="<cf_get_lang_main no ='51.Sil'>" onclick="remove_field('cons_agent_pos_code');"><label class="fa fa-minus btnPointer"></label></span>
                                    </div>
                                </div>
                                
                            </div> 
                            <div class="form-group" id="item-cons_hobby">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='239.Hobiler'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="cons_hobby" id="cons_hobby" multiple >
                                        <cfoutput query="get_hobby">
                                            <option value="#HOBBY_ID#">#HOBBY_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-cons_child">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='101.Çocuk Sayısı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='101.Çocuk Sayısı  !'></cfsavecontent>
                                    <cfinput type="text" name="child_lower" id="child_lower" style="width:79px;" validate="integer" message="#message#">
                                    <span class="input-group-addon no-bg"> - </span>
                                    <cfinput type="text" name="child_upper" id="child_upper" style="width:79px;" validate="integer" message="#message#">
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
                                        <option value="#sector_cat_id#">#sector_cat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-cons_county_id">
                            <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no='1226.İlçe'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        
                                        <select name="cons_county_id" id="cons_county_id" multiple ></select>
                                        <span class="input-group-addon btnPointer no-bg" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_tmarket.cons_county_id&field_name=add_tmarket.cons_county_id&coklu_secim=1','small');" title="<cf_get_lang_main no='170.Ekle'>"><label class="fa fa-plus btnPointer"></label></span>
                                        <span class="input-group-addon btnPointer no-bg" onclick="remove_field('cons_county_id');" title="<cf_get_lang_main no='51.Sil'>"><label class="fa fa-minus btnPointer"></label></span>
                                        </div>
                                 </div>
                        </div>
                        <div class="form-group" id="item-cons_age">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='93.Yaş Aralığı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='93.Yaş Aralığı !'></cfsavecontent>
                                    <cfinput type="text" name="age_lower" id="age_lower" style="width:79px;" validate="integer" message="#message#">
                                    <span class="input-group-addon no-bg">-</span>
                                    <cfinput type="text" name="age_upper" id="age_upper" style="width:79px;" validate="integer" message="#message#">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-cons_ozel_kod">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang_main no='377.Özel Kod'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="cons_ozel_kod1" id="cons_ozel_kod1"  value=""  maxlength="75">
                            </div>
                        </div>
                        <div class="form-group" id="item-cons_size_cats">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='106.Şirketteki Çalışan Sayısı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="cons_size_cats" id="cons_size_cats" multiple >
                                    <cfoutput query="get_company_size_cats">
                                        <option value="#company_size_cat_id#">#company_size_cat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-cons_tmarket_membership_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='215.Üyelik Tarihi Başlangıç'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='215.Üyelik Başlangıç Tarihi !'></cfsavecontent>
                                    <cfinput type="text" name="tmarket_membership_startdate" id="tmarket_membership_startdate" style="width:65px;" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="tmarket_membership_startdate"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='13.Üyelik Bitiş Tarihi !'></cfsavecontent>
                                    <cfinput type="text" name="tmarket_membership_finishdate" id="tmarket_membership_finishdate" style="width:65px;" validate="#validate_style#" message="#message#">
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
                                <div class="form-group"  id="item-order_date" <cfif isdefined("is_segmentasyon") and  is_segmentasyon eq 1> style="display:"<cfelse> style="display:none"</cfif>>
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1278.Tarih Aralığı'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <div class="input-group">            
                                                <cfinput type="text" name="order_start_date" id="order_start_date" style="width:65px;" validate="#validate_style#">
                                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="order_start_date"></span>
                                                <span class="input-group-addon no-bg"></span>
                                                <cfinput type="text" name="order_finish_date" id="order_finish_date" style="width:65px;" validate="#validate_style#">
                                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="order_finish_date"></span>
                                            </div>
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
                                                            <input type="hidden" name="record_num1" id="record_num1" value="0">
                                                            <th style="width:10px;"><a style="cursor:pointer" onclick="add_row1();"><img src="images/plus_list.gif" alt="" border="0"></a></th>
                                                            <th style="width:170px;" nowrap><cf_get_lang_main no='809.Ürün Adı'></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="table1"></tbody>
                                                </table>
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <label class="col col-12">&nbsp;</label>
                                                <label class="col col-12">&nbsp;</label>
                                                <label class="col col-12"><input type="checkbox" name="is_product_and" id="is_product_and" value="1" onClick="check_product(1);"> <cf_get_lang_main no ='577.Ve'></label>
                                                <label class="col col-12"><input type="checkbox" name="is_product_or" id="is_product_or" value="1" onClick="check_product(2);"><cf_get_lang_main no ='586.Veya'></label>
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
                                                            <input type="hidden" name="record_num2" id="record_num2" value="0">
                                                            <th style="width:10px;"><a style="cursor:pointer" onclick="add_row2();"><img src="images/plus_list.gif" alt="Ekle" border="0"></a></th>
                                                            <th style="width:170px;" nowrap><cf_get_lang_main no='1604.Ürün Kategorisi'></th>
                                                        </tr>
                                                    </thead>
                                                        <tbody id="table2">
                                                        </tbody>
                                                </table>
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <label class="col col-12">&nbsp;</label>
                                                <label class="col col-12">&nbsp;</label>
                                                <label class="col col-12"><input type="checkbox" name="is_productcat_and" id="is_productcat_and" value="1" onClick="check_productcat(1);"> <cf_get_lang_main no ='577.Ve'></label>
                                                <label class="col col-12"><input type="checkbox" name="is_productcat_or" id="is_productcat_or" value="1" onClick="check_productcat(2);"> <cf_get_lang_main no ='586.Veya'></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-8 col-xs-12" type="column" sort="true" index="15">
                                <div class="row">
                                    <div class="col col-12" id="item-baslik2">
                                        <div class="form-group" style="background-color: #E8E7E7">
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
                                                            <input type="hidden" name="record_num3" id="record_num3" value="0">
                                                            <th style="width:10px;"><a style="cursor:pointer" onclick="add_row3();"><img src="images/plus_list.gif" alt="Ekle" border="0"></a></th>
                                                            <th style="width:170px;" nowrap><cf_get_lang no ='264.Promosyon'></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="table3">
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <label class="col col-12"><input type="checkbox" name="is_prom_and" id="is_prom_and" value="1" onClick="check_prom(1);"> <cf_get_lang_main no ='577.Ve'></label>
                                                <label class="col col-12"><input type="checkbox" name="is_prom_or" id="is_prom_or" value="1" onClick="check_prom(2);"> <cf_get_lang_main no ='586.Veya'></label>
                                                <div class="input-group x-15">
                                                    <input type="text" name="promotion_count" id="promotion_count" value=""  style="width:20px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
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
                                                <input type="text" name="order_date" id="order_date" style="width:78px;" value="" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
                                                    <span class="input-group-addon">
                                                        <select name="order_date_opt" id="order_date_opt" style="width:100px;">
                                                            <option value="1"><cf_get_lang_main no ='78.Gün'></option>
                                                            <option value="2"><cf_get_lang_main no='1322.Hafta'></option>
                                                            <option value="3"><cf_get_lang_main no ='1312.Ay'></option>
                                                            <option value="4"><cf_get_lang_main no ='1043.Yıl'></option>
                                                        </select>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-order_amount">
                                            <label class="col col-3 col-xs-12"><cf_get_lang no ='306.Sipariş Tutarı'></label>
                                            <div class="col col-9 col-xs-12">
                                                <div class="input-group">
                                                    <input type="text" class="moneybox" name="order_amount" id="order_amount" style="width:78px;" value="" onKeyUp="return(FormatCurrency(this,event));">
                                                    <span class="input-group-addon">
                                                        <select name="sel_order_amount" id="sel_order_amount" style="width:100px;">
                                                            <option value="1"><cf_get_lang no ='307.En Az'></option>
                                                            <option value="2"><cf_get_lang no ='308.En Çok'></option>
                                                            <option value="3"><cf_get_lang_main no ='80.Toplam'></option>
                                                            <option value="4"><cf_get_lang no ='309.Ortalama'></option>
                                                        </select>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-order_count">
                                            <label class="col col-3 col-xs-12"><cf_get_lang no ='311.Sipariş Adedi'></label>
                                            <div class="col col-9 col-xs-12">
                                                <div class="input-group">
                                                    <input type="text" name="order_count" id="order_count" style="width:78px;" value=""class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
                                                    <span class="input-group-addon">
                                                        <select name="sel_order_count" id="sel_order_count" style="width:100px;">
                                                            <option value="1"><cf_get_lang no ='307.En Az'></option>
                                                            <option value="2"><cf_get_lang no ='308.En Çok'></option>
                                                            <option value="3"><cf_get_lang_main no ='80.Toplam'></option>
                                                        </select>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-order_commethod">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='678.İletişim Yöntemi'></label>
                                            <div class="col col-9 col-xs-12">
                                                <select name="order_commethod" id="order_commethod" style="width:180px;height:90px;" multiple>
                                                    <cfoutput query="get_commethod_types">
                                                        <option value="#commethod_id#">#commethod#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-6 col-xs-12">
                                        <div class="form-group" id="item-is_order">
                                            <label class="hide"><cf_get_lang no ='304.Sipariş Verenler'></label>
                                            <label class="col col-3 col-xs-12">&nbsp;</label>
                                            <label class="col col-9 col-xs-12"><input type="checkbox" name="is_order" id="is_order" value="1" onClick="check_order(1); "><cf_get_lang no ='304.Sipariş Verenler'></label>
                                        </div>
                                        <div class="form-group" id="item-is_not_order">
                                            <label class="hide"><cf_get_lang no ='305.Sipariş Vermeyenler'></label>
                                            <label class="col col-3 col-xs-12">&nbsp;</label>
                                            <label class="col col-9 col-xs-12"><input type="checkbox" name="is_not_order" id="is_not_order" value="1" onClick="check_order(2);" ><cf_get_lang no ='305.Sipariş Vermeyenler'></label>
                                        </div>
                                        <div class="form-group" id="item-product_amount">
                                            <label class="col col-3 col-xs-12"><cf_get_lang no ='310.Ürün Adedi'></label>
                                            <div class="col col-9 col-xs-12">
                                                <div class="input-group">
                                                    <input type="text" class="moneybox" name="product_amount" id="product_amount" style="width:78px;" value="" onKeyUp="return(FormatCurrency(this,event,0));">
                                                    <span class="input-group-addon">
                                                        <select name="sel_product_amount" id="sel_product_amount" style="width:100px;">
                                                            <option value="1"><cf_get_lang no ='307.En Az'></option>
                                                            <option value="2"><cf_get_lang no ='308.En Çok'></option>
                                                            <option value="3"><cf_get_lang_main no ='80.Toplam'></option>
                                                            <option value="4"><cf_get_lang no ='309.Ortalama'></option>
                                                        </select>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-order_paymethod">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no ='1104.Ödeme Yöntemi'></label>
                                            <div class="col col-9 col-xs-12">
                                                <select name="order_paymethod" id="order_paymethod" style="width:180px; height:90px;" multiple="multiple">
                                                    <optgroup label="<cf_get_lang no ='256.Ödeme Yöntemleri'>">
                                                        <cfoutput query="get_paymethod">
                                                        <option value="1-#paymethod_id#">&nbsp;&nbsp;#paymethod#</option>
                                                        </cfoutput>
                                                    </optgroup>
                                                    <optgroup label="<cf_get_lang no ='323.Kredi Kartı Ödeme Yöntemleri'>">
                                                        <cfoutput query="get_kk_paymethod">
                                                        <option value="2-#payment_type_id#">&nbsp;&nbsp;#card_no#</option>
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
                                                <select name="member_stage" id="member_stage" style="width:180px;height:70px;" multiple>
                                                    <cfoutput query="get_process_cats">
                                                        <option value="#process_row_id#">#stage#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                        <div class="form-group" id="item-partmember_stage">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no ='173.Kurumsal Üye'><cf_get_lang_main no ='70.Aşama'></label>
                                            <div class="col col-9 col-xs-12">
                                                <select name="partmember_stage" id="partmember_stage" style="width:180px;height:70px;" multiple>
                                                    <cfoutput query="get_process_cats_part">
                                                        <option value="#process_row_id#">#stage#</option>
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
                                                    <cfinput type="text" name="birth_date" id="birth_date" style="width:65px;" validate="#validate_style#">
                                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="birth_date"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-is_prom_select">
                                            <label class="col col-3 col-xs-12"><cf_get_lang no ='316.Promosyon Önerisi'></label>
                                            <div class="col col-9 col-xs-12">
                                                <select id="is_prom_select" name="is_prom_select">
                                                    <option value="1"><cf_get_lang no ='317.Seçenler'></option>
                                                    <option value="2"><cf_get_lang no ='318.Seçmeyenler'></option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-8 col-xs-12">
                                        <div class="form-group" id="item-checkboxes">
                                            <label><input type="checkbox" name="is_cep_tel" id="is_cep_tel" value="1">&nbsp;<cf_get_lang no ='319.Cep Telefonu olanlar'></label>
                                            <label><input type="checkbox" name="is_email" id="is_email" value="1">&nbsp;<cf_get_lang no ='320.Email Adresi Olanlar'></label>
                                            <label><input type="checkbox" name="is_tax" id="is_tax" value="1">&nbsp;<cf_get_lang no ='321.Vergi Mükellefi Olanlar'></label>
                                            <label><input type="checkbox" name="is_black_list" id="is_black_list" value="1">&nbsp;<cf_get_lang no ='325.Kara Listede Olanlar'></label>
                                            <label><input type="checkbox" name="is_debt" id="is_debt" value="1">&nbsp;<cf_get_lang no ='322.Vadesi Geçmiş Borcu Olanlar'></label>
                                            <label><input type="checkbox" name="is_bloke" id="is_bloke" value="1">&nbsp;<cf_get_lang no ='323.Bloke Olanlar'></label>
                                            <label><input type="checkbox" name="is_open_order" id="is_open_order" value="1">&nbsp;<cf_get_lang no ='324.Açık Sipariş Satırı Olanlar'></label>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                        <div class="form-group" id="item-password_day">
                                            <label class="hide"><cf_get_lang no ='326.Şifresini'> ... <cf_get_lang no ='327.Gündür Değiştirmeyenler'></label>
                                            <div class="input-group">
                                                <span class="input-group-addon no-bg"><cf_get_lang no ='326.Şifresini'></span>
                                                <input type="text" name="cons_password_day" id="cons_password_day" value="" style="width:40px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" style="width:40px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
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
                                    <label class="hide"><cf_get_lang_main no ='7.Eğitim'></label>
                                    <div class="col col-6 col-xs-12">
                                        <div class="form-group" id="item-training">
                                            <div class="col col-8 col-xs-12">
                                                <table class="workDevList">
                                                    <thead>
                                                        <tr>
                                                            <input type="hidden" name="record_num4" id="record_num4" value="0">
                                                            <th style="width:10px;"><a style="cursor:pointer" onclick="add_row4();"><img src="images/plus_list.gif" alt="Ekle" border="0"></a></th>
                                                            <th style="width:170px;" nowrap><cf_get_lang_main no ='7.Eğitim'></th>
                                                        </tr>
                                                    </thead>                                                         
                                                    <tbody id="table4">
                                                        
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <label class="col col-12">&nbsp;</label>
                                                <label class="col col-12">&nbsp;</label>
                                                <label class="col col-12"><input type="checkbox" name="is_train_and" id="is_train_and" value="1" onClick="check_train(1);"> <cf_get_lang_main no ='577.Ve'></label>
                                                <label class="col col-12"><input type="checkbox" name="is_train_or" id="is_train_or" value="1" onClick="check_train(2);"> <cf_get_lang_main no ='586.Veya'></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>      
                </cfif>
               <cf_box_footer>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cf_workcube_buttons is_upd='0' add_function='limit_control()'>
                    </div>
                </cf_box_footer>
                
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	<cfif isdefined("is_segmentasyon")>
		var is_segmentasyon = '<cfoutput>#is_segmentasyon#</cfoutput>';
    </cfif>
    $(document).ready(function(){

    row_count1= 0;
         row_count2= 0;
         row_count3= 0;
         row_count4= 0;
        add_row1();
        add_row2();
        add_row3();
        add_row4();
    });
     


	function remove_field(field_option_name)
	{
		field_option_name_value = document.getElementById(field_option_name);
		if(field_option_name_value != undefined)
			for (i=field_option_name_value.options.length-1;i>-1;i--)
			{
				if (field_option_name_value.options[i].selected==true)
				{
					field_option_name_value.options.remove(i);
				}	
			}
	}
    function beforeProcess()
    {

        
        if ($(':checkbox').is(':checked')){
                $(':checkbox').prop('checked', false).attr('checked', 'checked');
            }
        $('input[type=text]').each(function() {
            if($(this).attr('id') !="tmarket_name"){
                $(this).val('');
            } 
        });
        $('#add_tmarket').find('select').each(function() {
                if($(this).attr('id') !="before_process"){
                var value = "#"+$(this).attr('id')+" option"
                $(value).removeAttr("selected");
                }
        });
        var tmarket_id = document.getElementById("before_process").value;
        sql_str = "SELECT * FROM TARGET_MARKETS WHERE TMARKET_ID ="+tmarket_id;   
        my_query = wrk_query(sql_str,'dsn3');
        if(my_query.AGE_LOWER != "")
        {
        document.getElementById("age_lower").value = my_query.AGE_LOWER;
        }
        if(my_query.AGE_UPPER != "")
        {
        document.getElementById("age_upper").value = my_query.AGE_UPPER;
        }
        if(my_query.CHILD_LOWER != "")
        {
        document.getElementById("child_lower").value = my_query.CHILD_LOWER;
        }
        if(my_query.CHILD_UPPER != "")
        {
        document.getElementById("child_upper").value = my_query.CHILD_UPPER;
        }
        if(my_query.COMPANY_OZEL_KOD1 != "")
        {
        document.getElementById("company_ozel_kod1").value = my_query.COMPANY_OZEL_KOD1;
        }
        if(my_query.COMPANY_OZEL_KOD2 != "")
        {
        document.getElementById("company_ozel_kod2").value = my_query.COMPANY_OZEL_KOD2;
        }
        if(my_query.COMPANY_OZEL_KOD3 != "")
        {
        document.getElementById("company_ozel_kod3").value = my_query.COMPANY_OZEL_KOD3;
        }
        if(my_query.CONSUMER_OZEL_KOD1 != "")
        {
        document.getElementById("cons_ozel_kod1").value = my_query.CONSUMER_OZEL_KOD1;
        }
        if(my_query.TMARKET_MEMBERSHIP_STARTDATE != "")
        {
            document.getElementById("tmarket_membership_startdate").value =date_format(my_query.TMARKET_MEMBERSHIP_STARTDATE,dateformat_style);
        }
        if(my_query.TMARKET_MEMBERSHIP_FINISHDATE != "")
        {
           document.getElementById("tmarket_membership_finishdate").value = date_format(my_query.TMARKET_MEMBERSHIP_FINISHDATE,dateformat_style);
        }
        if(my_query.ORDER_START_DATE!= "")
        {
            document.getElementById("order_start_date").value = date_format(my_query.ORDER_START_DATE,dateformat_style);
        }
        if(my_query.ORDER_FINISH_DATE!= "")
        {
            document.getElementById("order_finish_date").value = date_format(my_query.ORDER_FINISH_DATE,dateformat_style);
        }
        if(my_query.CONSUMER_BIRTHDATE!= "")
        {
            document.getElementById("birth_date").value = date_format(my_query.CONSUMER_BIRTHDATE,dateformat_style);
        }
        if(my_query.PROMOTION_COUNT != "")
        {
            document.getElementById("promotion_count").value = my_query.PROMOTION_COUNT;
        }
        if(my_query.LAST_DAY_COUNT != "")
        {
            document.getElementById("order_date").value = my_query.LAST_DAY_COUNT;
        }
        if(my_query.ORDER_AMOUNT != "")
        {
            document.getElementById("order_amount").value = my_query.ORDER_AMOUNT;
        }
        if(my_query.ORDER_COUNT != "")
        {
            document.getElementById("order_count").value = my_query.ORDER_COUNT;
        }
        if(my_query.PRODUCT_COUNT != "")
        {
            document.getElementById("product_amount").value = my_query.PRODUCT_COUNT;
        }
        if(my_query.CONS_PASSWORD_DAY != "")
        {
            document.getElementById("cons_password_day").value = my_query.CONS_PASSWORD_DAY;
        }
        if(my_query.COMPANY_REL_ID != "")
        {
            document.getElementById("rel_company_name").value = my_query.COMPANY_REL_ID;
        }      
        if(my_query.companycats!=''){
            var company_cats = document.getElementById("companycats");
            company_cats_len = list_len(my_query.COMPANYCATS);
            for(j=0;j<company_cats.length;j++)
            {
                for(i=1;i<=company_cats_len;i++){                  
                    if(company_cats.options[j].value == list_getat(my_query.COMPANYCATS,i))
                    {
                        company_cats.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.PARTNER_DEPARTMENT!=''){
            var PARTNER_DEPARTMENT_ = document.getElementById("PARTNER_DEPARTMENT");
            PARTNER_DEPARTMENT_LEN = list_len(my_query.PARTNER_DEPARTMENT);
            for(j=0;j<PARTNER_DEPARTMENT_.length;j++)
            {
                for(i=1;i<=PARTNER_DEPARTMENT_LEN;i++){                  
                    if(PARTNER_DEPARTMENT_.options[j].value == list_getat(my_query.PARTNER_DEPARTMENT,i))
                    {
                        PARTNER_DEPARTMENT_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMPANY_IMS_CODE!=''){
            var company_ims_code_ = document.getElementById("company_ims_code");
            company_ims_code_len = list_len(my_query.COMPANY_IMS_CODE);
           
            for(j=0;j<company_ims_code_.length;j++)
            {
                for(i=1;i<=company_ims_code_len;i++){                  
                    if(company_ims_code_.options[j].value == list_getat(my_query.COMPANY_IMS_CODE,i))
                    {
                        company_ims_code_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMPANY_SALES_ZONE!=''){
            var company_sales_zone_ = document.getElementById("company_sales_zone");
            company_sales_zone_len = list_len(my_query.COMPANY_SALES_ZONE);
            for(j=0;j<company_sales_zone_.length;j++)
            {
                for(i=1;i<=company_sales_zone_len;i++){                  
                    if(company_sales_zone_.options[j].value == list_getat(my_query.COMPANY_SALES_ZONE,i))
                    {
                        company_sales_zone_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.PARTNER_MISSION!=''){
            var PARTNER_MISSION_ = document.getElementById("PARTNER_MISSION");
            PARTNER_MISSION_LEN = list_len(my_query.PARTNER_MISSION);
            for(j=0;j<PARTNER_MISSION_.length;j++)
            {
                for(i=1;i<=PARTNER_MISSION_LEN;i++){                  
                    if(PARTNER_MISSION_.options[j].value == list_getat(my_query.PARTNER_MISSION,i))
                    {
                        PARTNER_MISSION_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.PARTNER_MISSION!=''){
            var PARTNER_MISSION_ = document.getElementById("PARTNER_MISSION");
            PARTNER_MISSION_LEN = list_len(my_query.PARTNER_MISSION);
            for(j=0;j<PARTNER_MISSION_.length;j++)
            {
                for(i=1;i<=PARTNER_MISSION_LEN;i++){                  
                    if(PARTNER_MISSION_.options[j].value == list_getat(my_query.PARTNER_MISSION,i))
                    {
                        PARTNER_MISSION_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMPANY_COUNTRY_ID!=''){
            var company_country_id_ = document.getElementById("company_country_id");
            company_country_id_len = list_len(my_query.COMPANY_COUNTRY_ID);
            for(j=0;j<company_country_id_.length;j++)
            {
                for(i=1;i<=company_country_id_len;i++){                  
                    if(company_country_id_.options[j].value == list_getat(my_query.COMPANY_COUNTRY_ID,i))
                    {
                        company_country_id_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.REQ_COMP!=''){
            var req_comp_ = document.getElementById("req_comp");
            req_comp_len = list_len(my_query.REQ_COMP);
            for(j=0;j<req_comp_.length;j++)
            {
                for(i=1;i<=req_comp_len;i++){                  
                    if(req_comp_.options[j].value == list_getat(my_query.REQ_COMP,i))
                    {
                        req_comp_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMPANY_VALUE!=''){
            var company_value_ = document.getElementById("company_value");
            company_value_len = list_len(my_query.COMPANY_VALUE);
            for(j=0;j<company_value_.length;j++)
            {
                for(i=1;i<=company_value_len;i++){                  
                    if(company_value_.options[j].value == list_getat(my_query.COMPANY_VALUE,i))
                    {
                        company_value_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.SECTOR_CATS!=''){
            var sector_cats_ = document.getElementById("sector_cats");
            sector_cats_len = list_len(my_query.SECTOR_CATS);
            for(j=0;j<sector_cats_.length;j++)
            {
                for(i=1;i<=sector_cats_len;i++){                  
                    if(sector_cats_.options[j].value == list_getat(my_query.SECTOR_CATS,i))
                    {
                        sector_cats_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMP_REL_COMP!=''){
            var comp_rel_comp_ = document.getElementById("comp_rel_comp");
            comp_rel_comp_len = list_len(my_query.COMP_REL_COMP);
            for(j=0;j<comp_rel_comp_.length;j++)
            {
                for(i=1;i<=comp_rel_comp_len;i++){                  
                    if(comp_rel_comp_.options[j].value == list_getat(my_query.COMP_REL_COMP,i))
                    {
                        comp_rel_comp_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMPANY_SIZE_CATS!=''){
            var company_size_cats_ = document.getElementById("company_size_cats");
            company_size_cats_len = list_len(my_query.COMPANY_SIZE_CATS);
            for(j=0;j<company_size_cats_.length;j++)
            {
                for(i=1;i<=company_size_cats_len;i++){                  
                    if(company_size_cats_.options[j].value == list_getat(my_query.COMPANY_SIZE_CATS,i))
                    {
                        company_size_cats_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMP_REL_BRANCH!=''){
            var comp_rel_branch_ = document.getElementById("comp_rel_branch");
            comp_rel_branch_len = list_len(my_query.COMP_REL_BRANCH);
            for(j=0;j<comp_rel_branch_.length;j++)
            {
                for(i=1;i<=comp_rel_branch_len;i++){                  
                    if(comp_rel_branch_.options[j].value == list_getat(my_query.COMP_REL_BRANCH,i))
                    {
                        comp_rel_branch_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMP_FIRM_LIST!=''){
            var firm_type_ = document.getElementById("firm_type");       
            firm_type_len = list_len(my_query.COMP_FIRM_LIST);
            for(j=0;j<firm_type_.length;j++)
            {
                for(i=1;i<=firm_type_len;i++){                  
                    if(firm_type_.options[j].value == list_getat(my_query.COMP_FIRM_LIST,i))
                    {
                        firm_type_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMPANY_PARTNER_HOBBY!=''){
            var company_hobby_ = document.getElementById("company_hobby");
            company_hobby_len = list_len(my_query.COMPANY_PARTNER_HOBBY);
            for(j=0;j<company_hobby_.length;j++)
            {
                for(i=1;i<=company_hobby_len;i++){                  
                    if(company_hobby_.options[j].value == list_getat(my_query.COMPANY_PARTNER_HOBBY,i))
                    {
                        company_hobby_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMPANY_REL_TYPE_ID!=''){
            var rel_type_id_ = document.getElementById("rel_type_id");
            rel_type_id_len = list_len(my_query.COMPANY_REL_TYPE_ID);
            for(j=0;j<rel_type_id_.length;j++)
            {
                for(i=1;i<=rel_type_id_len;i++){                  
                    if(rel_type_id_.options[j].value == list_getat(my_query.COMPANY_REL_TYPE_ID,i))
                    {
                        rel_type_id_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMPANY_RESOURCE!=''){
            var company_resource_ = document.getElementById("company_resource");
            company_resource_len = list_len(my_query.COMPANY_RESOURCE);
            for(j=0;j<company_resource_.length;j++)
            {
                for(i=1;i<=company_resource_len;i++){                  
                    if(company_resource_.options[j].value == list_getat(my_query.COMPANY_RESOURCE,i))
                    {
                        company_resource_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMP_WANT_EMAIL!=''){
            var comp_want_email_ = document.getElementById("comp_want_email");
            comp_want_email_len = list_len(my_query.COMP_WANT_EMAIL);
            for(j=0;j<comp_want_email_.length;j++)
            {
                for(i=1;i<=comp_want_email_len;i++){                  
                    if(comp_want_email_.options[j].value == list_getat(my_query.COMP_WANT_EMAIL,i))
                    {
                        comp_want_email_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.COMP_CONMEMBER!=''){
            var connect_member_ = document.getElementById("connect_member");
            connect_member_len = list_len(my_query.COMP_CONMEMBER);
            for(j=0;j<connect_member_.length;j++)
            {
                for(i=1;i<=connect_member_len;i++){                  
                    if(connect_member_.options[j].value == list_getat(my_query.COMP_CONMEMBER,i))
                    {
                        connect_member_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONS_WANT_EMAIL!=''){
            var cons_want_email_ = document.getElementById("cons_want_email");
            cons_want_email_len = list_len(my_query.CONS_WANT_EMAIL);
            for(j=0;j<cons_want_email_.length;j++)
            {
                for(i=1;i<=cons_want_email_len;i++){                  
                    if(cons_want_email_.options[j].value == list_getat(my_query.CONS_WANT_EMAIL,i))
                    {
                        cons_want_email_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONSUMER_RESOURCE!=''){ 
            var cons_resource_ = document.getElementById("cons_resource");
            cons_resource_len = list_len(my_query.CONSUMER_RESOURCE);
            for(j=0;j<cons_resource_.length;j++)
            {
                for(i=1;i<=cons_resource_len;i++){                  
                    if(cons_resource_.options[j].value == list_getat(my_query.CONSUMER_RESOURCE,i))
                    {
                        cons_resource_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONS_VOCATION_TYPE!=''){ 
            var cons_vocation_type_ = document.getElementById("cons_vocation_type");
            cons_vocation_type_len = list_len(my_query.CONS_VOCATION_TYPE);
            for(j=0;j<cons_vocation_type_.length;j++)
            {
                for(i=1;i<=cons_vocation_type_len;i++){                  
                    if(cons_vocation_type_.options[j].value == list_getat(my_query.CONS_VOCATION_TYPE,i))
                    {
                        cons_vocation_type_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONS_SECTOR_CATS!=''){ 
            var cons_sector_cats_ = document.getElementById("cons_sector_cats");
            cons_sector_cats_len = list_len(my_query.CONS_SECTOR_CATS);
            for(j=0;j<cons_sector_cats_.length;j++)
            {
                for(i=1;i<=cons_sector_cats_len;i++){                  
                    if(cons_sector_cats_.options[j].value == list_getat(my_query.CONS_SECTOR_CATS,i))
                    {
                        cons_sector_cats_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONSUMER_VALUE!=''){ 
            var cons_value_ = document.getElementById("cons_value");
            cons_value_len = list_len(my_query.CONSUMER_VALUE);
            for(j=0;j<cons_value_.length;j++)
            {
                for(i=1;i<=cons_value_len;i++){                  
                    if(cons_value_.options[j].value == list_getat(my_query.CONSUMER_VALUE,i))
                    {
                        cons_value_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONSUMER_HOBBY!=''){ 
            var cons_hobby_ = document.getElementById("cons_hobby");
            cons_hobby_len = list_len(my_query.CONSUMER_HOBBY);
            for(j=0;j<cons_hobby_.length;j++) 
            {
                for(i=1;i<=cons_hobby_len;i++){                  
                    if(cons_hobby_.options[j].value == list_getat(my_query.CONSUMER_HOBBY,i))
                    {
                        cons_hobby_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONS_SIZE_CATS!=''){ 
            var cons_size_cats_ = document.getElementById("cons_size_cats");
            cons_size_cats_len = list_len(my_query.CONS_SIZE_CATS);
            for(j=0;j<cons_size_cats_.length;j++) 
            {
                for(i=1;i<=cons_size_cats_len;i++){                  
                    if(cons_size_cats_.options[j].value == list_getat(my_query.CONS_SIZE_CATS,i))
                    {
                        cons_size_cats_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONS_INCOME_LEVEL!=''){ 
            var cons_income_level_ = document.getElementById("cons_income_level");
            cons_income_level_len = list_len(my_query.CONS_INCOME_LEVEL);
            for(j=0;j<cons_income_level_.length;j++) 
            {
                for(i=1;i<=cons_income_level_len;i++){                  
                    if(cons_income_level_.options[j].value == list_getat(my_query.CONS_INCOME_LEVEL,i))
                    {
                        cons_income_level_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONSUMER_IMS_CODE!=''){ 
            var cons_ims_code_ = document.getElementById("cons_ims_code");
            cons_ims_code_len = list_len(my_query.CONSUMER_IMS_CODE);
            for(j=0;j<cons_ims_code_.length;j++) 
            {
                for(i=1;i<=cons_ims_code_len;i++){                  
                    if(cons_ims_code_.options[j].value == list_getat(my_query.CONSUMER_IMS_CODE,i))
                    {
                        cons_ims_code_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.REQ_CONS!=''){ 
            var req_cons_ = document.getElementById("req_cons");
            req_cons_len = list_len(my_query.REQ_CONS);
            for(j=0;j<req_cons_.length;j++) 
            {
                for(i=1;i<=req_cons_len;i++){                  
                    if(req_cons_.options[j].value == list_getat(my_query.REQ_CONS,i))
                    {
                        req_cons_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONS_REL_BRANCH!=''){ 
            var cons_rel_branch_ = document.getElementById("cons_rel_branch");
            cons_rel_branch_len = list_len(my_query.CONS_REL_BRANCH);
            for(j=0;j<cons_rel_branch_.length;j++) 
            {
                for(i=1;i<=cons_rel_branch_len;i++){                  
                    if(cons_rel_branch_.options[j].value == list_getat(my_query.CONS_REL_BRANCH,i))
                    {
                        cons_rel_branch_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONSUMER_SALES_ZONE!=''){ 
            var cons_sales_zone_ = document.getElementById("cons_sales_zone");
            cons_sales_zone_len = list_len(my_query.CONSUMER_SALES_ZONE);
            for(j=0;j<cons_sales_zone_.length;j++) 
            {
                for(i=1;i<=cons_sales_zone_len;i++){                  
                    if(cons_sales_zone_.options[j].value == list_getat(my_query.CONSUMER_SALES_ZONE,i))
                    {
                        cons_sales_zone_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONS_EDUCATION!=''){ 
            var cons_education_ = document.getElementById("cons_education");
            cons_education_len = list_len(my_query.CONS_EDUCATION);
            for(j=0;j<cons_education_.length;j++) 
            {
                for(i=1;i<=cons_education_len;i++){                  
                    if(cons_education_.options[j].value == list_getat(my_query.CONS_EDUCATION,i))
                    {
                        cons_education_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONS_SOCIETY!=''){ 
            var cons_society_ = document.getElementById("cons_society");
            cons_society_len = list_len(my_query.CONS_SOCIETY);
            for(j=0;j<cons_society_.length;j++) 
            {
                for(i=1;i<=cons_society_len;i++){                  
                    if(cons_society_.options[j].value == list_getat(my_query.CONS_SOCIETY,i))
                    {
                        cons_society_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.ORDER_COMMETHOD_ID!=''){ 
            var order_commethod_ = document.getElementById("order_commethod");
            order_commethod_len = list_len(my_query.ORDER_COMMETHOD_ID);
            for(j=0;j<order_commethod_.length;j++) 
            {
                for(i=1;i<=order_commethod_len;i++){                  
                    if(order_commethod_.options[j].value == list_getat(my_query.ORDER_COMMETHOD_ID,i))
                    {
                        order_commethod_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.ORDER_PAYMETHOD_ID!=''){ 
            var order_paymethod_ = document.getElementById("order_paymethod");
            order_paymethod_len = list_len(my_query.ORDER_PAYMETHOD_ID);
            for(j=0;j<order_paymethod_.length;j++) 
            {
                for(i=1;i<=order_paymethod_len;i++){       
                    var order_paymethod_one = "1-"+ list_getat(my_query.ORDER_PAYMETHOD_ID,i);
                    if(order_paymethod_.options[j].value == order_paymethod_one)
                    {
                        order_paymethod_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.ORDER_CARDPAYMETHOD_ID!=''){ 
            var order_paymethod_ = document.getElementById("order_paymethod");
            order_paymethod_len = list_len(my_query.ORDER_CARDPAYMETHOD_ID);
            for(j=0;j<order_paymethod_.length;j++) 
            {
                for(i=1;i<=order_paymethod_len;i++){       
                    var order_paymethod_one = "2-"+ list_getat(my_query.ORDER_CARDPAYMETHOD_ID,i);
                    if(order_paymethod_.options[j].value == order_paymethod_one)
                    {
                        order_paymethod_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONSUMER_STAGE!=''){ 
            var member_stage_ = document.getElementById("member_stage");
            member_stage_len = list_len(my_query.CONSUMER_STAGE);
            for(j=0;j<member_stage_.length;j++) 
            {
                for(i=1;i<=member_stage_len;i++){       
                    if(member_stage_.options[j].value == list_getat(my_query.CONSUMER_STAGE,i))
                    {
                        member_stage_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.PARTNER_STAGE!=''){ 
            var partmember_stage_ = document.getElementById("partmember_stage");
            partmember_stage_len = list_len(my_query.PARTNER_STAGE);
            for(j=0;j<partmember_stage_.length;j++) 
            {
                for(i=1;i<=partmember_stage_len;i++){       
                    if(partmember_stage_.options[j].value == list_getat(my_query.PARTNER_STAGE,i))
                    {
                        partmember_stage_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.PROMOTION_OFFER_STATUS!=''){ 
            var is_prom_select_ = document.getElementById("is_prom_select");
            is_prom_select_len = list_len(my_query.PROMOTION_OFFER_STATUS);
            for(j=0;j<is_prom_select_.length;j++) 
            {
                for(i=1;i<=is_prom_select_len;i++){       
                    if(is_prom_select_.options[j].value == list_getat(my_query.PROMOTION_OFFER_STATUS,i))
                    {
                        is_prom_select_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONSCAT_IDS!=''){ 
            var conscat_ids_ = document.getElementById("conscat_ids");
            conscat_ids_len = list_len(my_query.CONSCAT_IDS);
            for(j=0;j<conscat_ids_.length;j++) 
            {
                for(i=1;i<=conscat_ids_len;i++){       
                    if(conscat_ids_.options[j].value == list_getat(my_query.CONSCAT_IDS,i))
                    {
                        conscat_ids_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.CONS_REL_COMP!=''){ 
            var cons_rel_comp_ = document.getElementById("cons_rel_comp");
            cons_rel_comp_len = list_len(my_query.CONS_REL_COMP);
            for(j=0;j<cons_rel_comp_.length;j++) 
            {
                for(i=1;i<=cons_rel_comp_len;i++){       
                    if(cons_rel_comp_.options[j].value == list_getat(my_query.CONS_REL_COMP,i))
                    {
                        cons_rel_comp_.options[j].selected = true;
                    }
                }
            }
        }
        if(my_query.IS_BUYER == 1)
        {
            document.getElementById("IS_BUYER").checked = true;
        }
        if(list_find('0,1,3,4',my_query.TARGET_MARKET_TYPE))
        {
            document.getElementById("is_company_search").checked = true;
        }
        if(list_find('0,2,3,5',my_query.TARGET_MARKET_TYPE))
        {
            document.getElementById("is_consumer_search").checked = true;
        }
        if(my_query.IS_SELLER == 1)
        {
            document.getElementById("IS_SELLER").checked = true;
        }
        if(my_query.ONLY_FIRMMEMBER== 1)
        {
            document.getElementById("ONLY_FIRM_MEMBERS").checked = true;
        }
        if(my_query.IS_MAILLIST== 1)
        {
            document.getElementById("is_maillist").checked = true;
        }
        if(my_query.ORDER_PRODUCT_STATUS== 1)
        {
            document.getElementById("is_product_and").checked = true;
        }
        if(my_query.ORDER_PRODUCT_STATUS== 2)
        {
            document.getElementById("is_product_or").checked = true;
        }
        if(my_query.ORDER_PRODUCTCAT_STATUS== 1)
        {
            document.getElementById("is_productcat_and").checked = true;
        }
        if(my_query.ORDER_PRODUCTCAT_STATUS== 2)
        {
            document.getElementById("is_productcat_and").checked = true;
        }
        if(my_query.PROMOTION_STATUS== 1)
        {
            document.getElementById("is_prom_and").checked = true;
        }
        if(my_query.PROMOTION_STATUS== 2)
        {
            document.getElementById("is_prom_or").checked = true;
        }
        if(my_query.IS_GIVEN_ORDER== 1)
        {
            document.getElementById("is_order").checked = true;
        }
        if(my_query.IS_GIVEN_ORDER== 2)
        {
            document.getElementById("is_not_order").checked = true;
        }   
        if(my_query.IS_CONS_CEPTEL== 1)
        {
            document.getElementById("is_cep_tel").checked = true;
        }
        if(my_query.IS_CONS_EMAIL == 1)
        {
            document.getElementById("is_email").checked = true;
        }
        if(my_query.IS_CONS_TAX == 1)
        {
            document.getElementById("is_tax").checked = true;
        }
        if(my_query.IS_CONS_BLACK_LIST == 1)
        {
            document.getElementById("is_black_list").checked = true;
        }
        if(my_query.IS_CONS_DEBT == 1)
        {
            document.getElementById("is_debt").checked = true;
        }
        if(my_query.IS_CONS_BLOKE == 1)
        {
            document.getElementById("is_bloke").checked = true;
        }
        if(my_query.IS_CONS_OPEN_ORDER == 1)
        {
            document.getElementById("is_open_order").checked = true;
        }
        if(my_query.TRAINING_STATUS == 1)
        {
            document.getElementById("is_train_and").checked = true;
        }
        if(my_query.TRAINING_STATUS == 2)
        {
            document.getElementById("is_train_or").checked = true;
        }
        if(my_query.IS_POTANTIAL!=''){  
            is_potantial_len = list_len(my_query.IS_POTANTIAL); 
            for(i=1;i<=is_potantial_len;i++)
            {                     
                if(list_getat(my_query.IS_POTANTIAL,i) == 1)
                {
                    document.getElementById("IS_POTANTIAL").checked = true;
                }
                else if(list_getat(my_query.IS_POTANTIAL,i) == 0)
                {
                    document.getElementById("IS_POTANTIAL_CURRENT").checked = true;
                }              
            }         
        }
        if(my_query.PARTNER_STATUS!='')
        { 
            is_partner_status_len = list_len(my_query.PARTNER_STATUS); 
            for(i=1;i<=is_partner_status_len;i++)
            {   
                if(list_getat(my_query.PARTNER_STATUS,i) == 1)
                {
                    document.getElementById("PARTNER_STATUS").checked = true;
                }
                else if(list_getat(my_query.PARTNER_STATUS,i) == 0)
                {
                    document.getElementById("PARTNER_STATUS_PASSIVE").checked = true;
                }               
            }           
        }
        if(my_query.PARTNER_TMARKET_SEX!='')
        { 
            len = list_len(my_query.PARTNER_TMARKET_SEX); 
            for(i=1;i<=len;i++)
            {   
                if(list_getat(my_query.PARTNER_TMARKET_SEX,i) == 1)
                {
                    document.getElementById("PARTNER_TMARKET_SEX").checked = true;
                }
                else if(list_getat(my_query.PARTNER_TMARKET_SEX,i) == 0 && list_getat(my_query.PARTNER_TMARKET_SEX,i+1) == 2)
                {
                    document.getElementById("PARTNER_TMARKET_SEX_WOMAN").checked = true;
                }
                
            }
            
        }
        if(my_query.CONS_IS_POTANTIAL!='')
        { 
            len = list_len(my_query.CONS_IS_POTANTIAL); 
            for(i=1;i<=len;i++)
            {   
                if(list_getat(my_query.CONS_IS_POTANTIAL,i) == 1)
                {
                    document.getElementById("CONS_IS_POTANTIAL").checked = true;
                }
                else if(list_getat(my_query.CONS_IS_POTANTIAL,i) == 0 )
                {
                    document.getElementById("CONS_IS_CURRENT").checked = true;
                }      
            }
        }
        if(my_query.CONS_STATUS!='')
        { 
            len = list_len(my_query.CONS_STATUS); 
            for(i=1;i<=len;i++)
            {   
                if(list_getat(my_query.CONS_STATUS,i) == 1)
                {
                    document.getElementById("cons_status").checked = true;
                }
                else if(list_getat(my_query.CONS_STATUS,i) == 0 )
                {
                    document.getElementById("cons_status_passive").checked = true;
                }
                
            }
            
        }
        if(my_query.TMARKET_SEX!='')
        { 
            len = list_len(my_query.TMARKET_SEX); 
            for(i=1;i<=len;i++)
            {   
                if(list_getat(my_query.TMARKET_SEX,i) == 1)
                {
                    document.getElementById("tmarket_sex").checked = true;
                }
                else if(list_getat(my_query.TMARKET_SEX,i) == 0 )
                {
                    document.getElementById("tmarket_sex_woman").checked = true;
                }
                
            }
            
        }
        if(my_query.TMARKET_MARITAL_STATUS!='')
        { 
            len = list_len(my_query.TMARKET_MARITAL_STATUS); 
            for(i=1;i<=len;i++)
            {   
                if(list_getat(my_query.TMARKET_MARITAL_STATUS,i) == 1)
                {
                    document.getElementById("tmarket_marital_status_married").checked = true;
                }
                else if(list_getat(my_query.TMARKET_MARITAL_STATUS,i) == 0 )
                {
                    document.getElementById("tmarket_marital_status").checked = true;
                }
                
            }
            
        }
        if(my_query.COMPANY_CITY_ID != '')
        {
            var comp_id = my_query.COMPANY_CITY_ID;      
            comp_sql = "SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN ("+comp_id+")";   
            comp_query = wrk_query(comp_sql,'dsn');

            var company_city_id = document.getElementById("company_city_id");
            len = list_len(comp_query.CITY_ID);
            for(i = 0; i<len ; i++)
            {
                company_city_id.length = parseInt(i+1);
                company_city_id.options[i].value = comp_query.CITY_ID;
                company_city_id.options[i].text = comp_query.CITY_NAME;
                company_city_id.options[i].selected = true;
                
            }
        }
        if(my_query.COMPANY_COUNTY_ID != '')
        {
            var comp_county_id = my_query.COMPANY_COUNTY_ID;      
            comp_sql = "SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN ("+comp_county_id+")";   
            comp_query = wrk_query(comp_sql,'dsn');

            var company_county_id = document.getElementById("company_county_id");
            len = list_len(comp_query.COUNTY_ID);
            for(i = 0; i<len ; i++)
            {
                company_county_id.length = parseInt(i+1);
                company_county_id.options[i].value = comp_query.COUNTY_ID;
                company_county_id.options[i].text = comp_query.COUNTY_NAME;
                company_county_id.options[i].selected = true;
               
            }
        }
         if(my_query.COUNTY_ID != '')
        {
            var county_id = my_query.COUNTY_ID;      
            comp_sql = "SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN ("+county_id+")";   
            comp_query = wrk_query(comp_sql,'dsn');

            var cons_county_id = document.getElementById("cons_county_id");
            len = list_len(comp_query.COUNTY_ID);
            for(i = 0; i<len ; i++)
            {
                cons_county_id.length = parseInt(i+1);
                cons_county_id.options[i].value = comp_query.COUNTY_ID;
                cons_county_id.options[i].text = comp_query.COUNTY_NAME;
                cons_county_id.options[i].selected = true;
            }
        }
        if(my_query.CITY_ID != '')
        {
            var city_id = my_query.CITY_ID;      
            comp_sql = "SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN ("+city_id+")";   
            comp_query = wrk_query(comp_sql,'dsn');

            var cons_city_id = document.getElementById("cons_city_id");
            len = list_len(comp_query.CITY_ID);
            for(i = 0; i<len ; i++)
            {
                cons_city_id.length = parseInt(i+1);
                cons_city_id.options[i].value = comp_query.CITY_ID;
                cons_city_id.options[i].text = comp_query.CITY_NAME;
                cons_city_id.options[i].selected = true;
                
            }
        }
        if(my_query.COMP_AGENT_POS_CODE)
        {
            var comp_agent = my_query.COMP_AGENT_POS_CODE ;
            comp_sql = "SELECT POSITION_CODE,EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN ("+comp_agent+")";
            comp_query = wrk_query(comp_sql,'dsn');
            len  = list_len(my_query.COMP_AGENT_POS_CODE);
            var comp_agent_pos_code = document.getElementById("comp_agent_pos_code");
            for(j=0;j<len;j++) 
            { 
                comp_agent_pos_code.length = parseInt(j+1);
                comp_agent_pos_code.options[j].value = comp_query.POSITION_CODE;
                comp_agent_pos_code.options[j].text =comp_query.EMPLOYEE_NAME+" "+comp_query.EMPLOYEE_SURNAME;
                comp_agent_pos_code.options[j].selected = true;
            }
        }
        if(my_query.CONS_AGENT_POS_CODE)
        {
            var cons_agent = my_query.CONS_AGENT_POS_CODE ;
            comp_sql = "SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN ("+cons_agent+")";
            comp_query = wrk_query(comp_sql,'dsn');

            len  = list_len(my_query.CONS_AGENT_POS_CODE);
            var cons_agent_pos_code = document.getElementById("cons_agent_pos_code");
            for(j=0;j<len;j++) 
            { 
                cons_agent_pos_code.length = parseInt(j+1);
                cons_agent_pos_code.options[j].value = comp_query.EMPLOYEE_ID;
                cons_agent_pos_code.options[j].text =comp_query.EMPLOYEE_NAME+" "+comp_query.EMPLOYEE_SURNAME;
                cons_agent_pos_code.options[j].selected = true;
            }
        }
        if(my_query.ORDER_PRODUCT_ID)
        {
            var order_product_id = my_query.ORDER_PRODUCT_ID ;
            comp_sql = "SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN ("+order_product_id+")";
            comp_query = wrk_query(comp_sql,'dsn3');
            len = comp_query.recordcount;
          
            for(j=1;j<=len;j++) 
            {  
                if(j!=1)
                add_row1();
                document.getElementById('product_id'+j).value = comp_query.PRODUCT_ID[j-1];
                document.getElementById('product_name'+j).value = comp_query.PRODUCT_NAME[j-1];
            }
        }
        if(my_query.ORDER_PRODUCTCAT_ID)
        {
            var order_product_catid = my_query.ORDER_PRODUCTCAT_ID;
            comp_sql = "SELECT PRODUCT_CATID, PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID IN ("+order_product_catid+")";
            comp_query = wrk_query(comp_sql,'dsn3');
            len = comp_query.recordcount;
          
            for(j=1;j<=len;j++) 
            {  
                if(j!=1)
                add_row2();
                document.getElementById('productcat_id'+j).value = comp_query.PRODUCT_CATID[j-1];
                document.getElementById('productcat_name'+j).value = comp_query.PRODUCT_CAT[j-1];
            }
        }
        if(my_query.PROMOTION_ID)
        {
            var promotion_id = my_query.PROMOTION_ID;
            comp_sql = "SELECT PROM_ID,PROM_HEAD FROM PROMOTIONS WHERE PROM_ID IN ("+promotion_id+")";
            comp_query = wrk_query(comp_sql,'dsn3');
            len = comp_query.recordcount;
          
            for(j=1;j<=len;j++) 
            {  
                if(j!=1)
                add_row3();
                document.getElementById('promotion_id'+j).value = comp_query.PROM_ID[j-1];
                document.getElementById('promotion_name'+j).value = comp_query.PROM_HEAD[j-1];
            }
        }
        if(my_query.TRAINING_ID)
        {
            var training_id = my_query.TRAINING_ID;
            comp_sql = "SELECT CLASS_ID,CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID IN ("+training_id+")";
            comp_query = wrk_query(comp_sql,'dsn');
            len = comp_query.recordcount;
          
            for(j=1;j<=len;j++) 
            {  
                if(j!=1)
                add_row4();
                document.getElementById('training_id'+j).value = comp_query.CLASS_ID[j-1];
                document.getElementById('training_name'+j).value = comp_query.CLASS_NAME[j-1];
            }
        }
        if(my_query.COMP_PRODUCTCAT_LIST)
        {
            var product_cat = my_query.COMP_PRODUCTCAT_LIST;
          
            comp_sql = "SELECT HIERARCHY, PRODUCT_CAT, PRODUCT_CATID FROM PRODUCT_CAT WHERE PRODUCT_CATID IN ("+product_cat+")";
            comp_query = wrk_query(comp_sql,'dsn3');
            var product_category = document.getElementById("product_category");
            len = list_len(my_query.COMP_PRODUCTCAT_LIST);
            for(i = 0; i<len ; i++)
            {
                product_category.length = parseInt(i+1);
                product_category.options[i].value = comp_query.PRODUCT_CATID;
                product_category.options[i].text = comp_query.PRODUCT_CAT;
                product_category.options[i].selected = true;
               
            }
        }
        
       
    }
	function select_all(selected_field)
	{
		if(eval("document.add_tmarket." + selected_field + "") != undefined)
		{
			var m = eval("document.add_tmarket." + selected_field + ".length");
			for(i=0;i<m;i++)
			{
				eval("document.add_tmarket."+selected_field+"["+i+"].selected=true")
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
		
		if(document.getElementById('tmarket_membership_startdate') != undefined && document.getElementById('tmarket_membership_startdate').value!= '' &&document.getElementById('tmarket_membership_finishdate') != undefined && document.getElementById('tmarket_membership_finishdate').value != '' )
		{
			return date_check(add_tmarket.tmarket_membership_startdate,add_tmarket.tmarket_membership_finishdate,"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> !");
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
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="row_kontrol1'+row_count1+'" id="row_kontrol1'+row_count1+'" value="1"><a style="cursor:pointer" onclick="sil1(' + row_count1 + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="product_id' + row_count1 +'" id="product_id' + row_count1 +'"><input type="text" name="product_name' + row_count1 +'" id="product_name' + row_count1 +'" class="text" style="width:165px;" readonly>'
						+' '+'<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_tmarket.product_id" + row_count1 + "&field_name=add_tmarket.product_name" + row_count1 + "','list');"+'"></span></div>';
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
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="row_kontrol2'+row_count2+'" id="row_kontrol2'+row_count2+'" value="1"><a style="cursor:pointer" onclick="sil2(' + row_count2 + ');"><img  src="images/delete_list.gif" alt="" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="productcat_id' + row_count2 +'"  id="productcat_id' + row_count2 +'"><input type="text" name="productcat_name' + row_count2 +'" id="productcat_name' + row_count2 +'" class="text" style="width:178px;" readonly>'
						+' '+'<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=add_tmarket.productcat_id" + row_count2 + "&field_name=add_tmarket.productcat_name" + row_count2 + "</cfoutput>');"+'"></span></div>';
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
						+' '+'<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_promotions&prom_id=add_tmarket.promotion_id" + row_count3 + "&prom_head=add_tmarket.promotion_name" + row_count3 + "</cfoutput>','small');"+'"></span></div>';
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
		newCell.innerHTML = '<input type="hidden" name="row_kontrol4'+row_count4+'" id="row_kontrol4'+row_count4+'" value="1"><a style="cursor:pointer" onclick="sil4(' + row_count4 + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="training_id' + row_count4 +'" id="training_id' + row_count4 +'"><input type="text" name="training_name' + row_count4 +'" id="training_name' + row_count4 +'" class="text" style="width:165px;" readonly>'
						+' '+'<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_trainings&field_id=add_tmarket.training_id" + row_count4 + "&field_name=add_tmarket.training_name" + row_count4 + "</cfoutput>','list');"+'"></span></div>';
	}

</cfif>
</script>
<cf_get_lang_set module_name="campaign">
