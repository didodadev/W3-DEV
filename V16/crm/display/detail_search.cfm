<cfquery name="GET_RELATED_DEPOTS" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) 
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="GET_CUSTS" datasource="#DSN#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_TYPE = 0 ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES
</cfquery>
<cfquery name="GET_FACULTY" datasource="#DSN#">
	SELECT UNIVERSITY_ID, UNIVERSITY_NAME FROM SETUP_UNIVERSITY ORDER BY UNIVERSITY_NAME
</cfquery>
<cfquery name="GET_IT_CONCERN" datasource="#DSN#">
	SELECT CONCERN_ID, CONCERN_NAME FROM SETUP_IT_CONCERNED ORDER BY CONCERN_NAME
</cfquery>
<cfquery name="GET_PARTNER_POSITION" datasource="#DSN#">	
	SELECT PARTNER_POSITION_ID, PARTNER_POSITION, IS_UNIVERSITY FROM SETUP_PARTNER_POSITION ORDER BY PARTNER_POSITION
</cfquery>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME,PHONE_CODE,COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="get_country" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="GET_STOCKS" datasource="#DSN#">
	SELECT STOCK_ID, STOCK_NAME FROM SETUP_STOCK_AMOUNT ORDER BY STOCK_NAME
</cfquery>
<cfquery name="GET_DUTY_PERIOD" datasource="#DSN#">
	SELECT PERIOD_ID, PERIOD_NAME FROM SETUP_DUTY_PERIOD ORDER BY PERIOD_NAME
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','',51629)#">
        <cfform name="detail_search_form" method="post"  action="#request.self#?fuseaction=crm.detail_search_report" >
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12">
                    <div class="col col-7 col-md-7 col-sm-12">
                        <div class="col col-12 col-md-12 col-sm-12 column" type="column" index="1" sort="true">
                            <cf_seperator title="#getLang('','','57980')#" id="genel_bilgiler_">
                            <div class="col col-12 col-md-12 col-sm-12 column" id="genel_bilgiler_">
                                <div class="form-group" id="item-selectall">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <input type="checkbox" id="genel_bilgiler_selectall" name="genel_bilgiler_selectall"><cf_get_lang dictionary_id='46850.Tümünü Göster'>
                                    </label>
                                </div>
                                <div class="form-group" id="item-COMPANYCAT">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57292.Müşteri Tipi'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <select name="COMPANYCAT" id="COMPANYCAT"  size="4" multiple>
                                            <cfoutput query="get_custs">
                                            <option value="#companycat_id#">#companycat#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><input type="checkbox" value="1" name="COMPANYCAT_VIEW" id="COMPANYCAT_VIEW"  onClick="gizle_goster(frm_row3);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group" id="item-HEDEFKODU">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='52115.Hedef Kodu'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="HEDEFKODU" id="HEDEFKODU" type="text" maxlength="6" onKeyUp="isNumber(this);" ></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><select name="HEDEFKODUE_CONDITION" id="HEDEFKODUE_CONDITION" >
                                        <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id='51699.Standart Göster'></label>
                                </div>
                                <div class="form-group" id="item-FULLNAME">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='52118.İş Yeri Adı'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="FULLNAME" id="FULLNAME" type="text" maxlength="75" ></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="FULLNAME_CONDITION" id="FULLNAME_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id='51699.Standart Göster'></label>
                                </div>
                                <div class="form-group"  id="item-TAXNUM_CONDITION">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='56085.Vergi Numarası'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="TAXNUM" id="TAXNUM" type="text" ></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="TAXNUM_CONDITION" id="TAXNUM_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="TAXNUM_NAME_VIEW"  id="TAXNUM_NAME_VIEW" value="1" onClick="gizle_goster(frm_row38);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-TAXOFFICE">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="TAXOFFICE" id="TAXOFFICE" type="text" ></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><select name="TAXOFFICE_CONDITION" id="TAXOFFICE_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox"  name="TAXOFFICE_NAME_VIEW" id="TAXOFFICE_NAME_VIEW" value="1" onClick="gizle_goster(frm_row39);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-TELEPHONE">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='63896.Telefon'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="TELEPHONE" id="TELEPHONE" type="text" ></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><select name="TELEPHONE_CONDITION" id="TELEPHONE_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox"  name="TELEPHONE_NAME_VIEW" id="TELEPHONE_NAME_VIEW" value="1" onClick="gizle_goster(frm_row40);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-EMAIL_CONDITION">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='39210.Email'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="EMAIL"  id="EMAIL" type="text" ></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="EMAIL_CONDITION" id="EMAIL_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox"  name="EMAIL_NAME_VIEW" id="EMAIL_NAME_VIEW" value="1" onClick="gizle_goster(frm_row41);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-COMPANY_PARTNER_AD">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51816.İlgili Adı'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="COMPANY_PARTNER_AD" id="COMPANY_PARTNER_AD" type="text" maxlength="100"></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="COMPANY_PARTNER_AD_CONDITION" id="COMPANY_PARTNER_AD_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id='51699.Standart Göster'></label>
                                </div>
                                <div class="form-group"  id="item-COMPANY_PARTNER_SOYAD">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51817.İlgili Soyadı'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="COMPANY_PARTNER_SOYAD" id="COMPANY_PARTNER_SOYAD" type="text" maxlength="100"></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="COMPANY_PARTNER_SOYAD_CONDITION" id="COMPANY_PARTNER_SOYAD_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id='51699.Standart Göster'></label>
                                </div>
                            
                                <div class="form-group"  id="item-IMS_CODE">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='49657.IMS Bölge Kodu'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <select name="IMS_CODE" id="IMS_CODE" style="width:485px; height:80px;" multiple></select>
                                            <span class="input-group-addon">                       
                                                <i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_codes&field_name=detail_search_form.IMS_CODE');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                                <i class="icon-minus btnPointer show" onClick="remove_field('IMS_CODE');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox"  name="IMS_CODE_VIEW" id="IMS_CODE_VIEW" value="1" onClick="gizle_goster(frm_row4);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                
                                </div>
                                <div class="form-group" id="item-country_id">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <select name="country_id" id="country_id" onChange="remove_adress('1');" >
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_country">
                                                <option value="#get_country.country_id#" <cfif get_country.is_default eq 1>selected</cfif>>#get_country.country_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-city">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="city_id" id="city_id" value="">          
                                            <input type="text" name="city_name" id="city_name" value="" readonly >
                                            <span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="pencere_ac_city();"></span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox"  name="CITY_NAME_VIEW" id="CITY_NAME_VIEW" value="1" onClick="gizle_goster(frm_row5);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>

                            
                                <div class="form-group" id="item-county_name"> 
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="county_id" id="county_id" value="">
                                            <input type="text" name="county_name" id="county_name" value="" >
                                            <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="pencere_ac();"></span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox"  name="COUNTY_NAME_VIEW" id="COUNTY_NAME_VIEW" value="1" onClick="gizle_goster(frm_row6);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-COMPANY_ADDRESS">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="COMPANY_ADDRESS" id="COMPANY_ADDRESS" maxlength="50"></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="COMPANY_ADDRESS_CONDITION" id="COMPANY_ADDRESS_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox"  name="COMPANY_ADDRESS_VIEW" id="COMPANY_ADDRESS_VIEW" value="1" onClick="gizle_goster(frm_row7);"><cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-SEMT">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="SEMT" id="SEMT" type="text" maxlength="50"></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="SEMT_CONDITION" id="SEMT_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox"  name="SEMT_VIEW" id="SEMT_VIEW" value="1" onClick="gizle_goster(frm_row8);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-CADDE_CONDITION">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='59266.Cadde'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="CADDE" id="CADDE" type="text" maxlength="50"></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="CADDE_CONDITION" id="CADDE_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="CADDE_VIEW" id="CADDE_VIEW" value="1" onClick="gizle_goster(frm_row66);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-SOKAK_CONDITION">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='59267.Sokak'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="SOKAK" id="SOKAK" type="text" maxlength="50"></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="SOKAK_CONDITION" id="SOKAK_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox"  name="SOKAK_VIEW" id="SOKAK_VIEW" value="1" onClick="gizle_goster(frm_row67);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-NO_CONDITION">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57487.No'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="NO" id="NO" type="text" maxlength="50"></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="NO_CONDITION" id="NO_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="LIKE"><cf_get_lang dictionary_id='51700.İçeren'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="NO_VIEW" id="NO_VIEW" value="1" onClick="gizle_goster(frm_row68);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>	
                            </div>														
                        </div>
                        <div class="col col-12 col-md-12 col-sm-12 column" type="column" index="2" sort="true">
                            <cf_seperator title="#getLang('','',49656)#"  id="calistigi_subeler_">
                            <div class="col col-12 col-md-12 col-sm-12 column" id="calistigi_subeler_">
                                <div class="form-group" id="item-selectall">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <input type="checkbox" id="calistigi_subeler_selectall" name="calistigi_subeler_selectall"><cf_get_lang dictionary_id='46850.Tümünü Göster'>
                                    </label>
                                </div>
                                <div class="form-group"  id="item-PLASIYER">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51548.Saha Satış Görevlisi'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="PLASIYER_ID" id="PLASIYER_ID" value="">
                                            <input type="text" name="PLASIYER" id="PLASIYER"  readonly="">
                                            <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=detail_search_form.PLASIYER_ID&field_name=detail_search_form.PLASIYER&employee_list=1&select_list=1</cfoutput>');"></span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="PLASIYER_ID_VIEW" id="PLASIYER_ID_VIEW" value="1" onClick="gizle_goster(frm_row52);"> <cf_get_lang dictionary_id='58596.Göster'></label>				
                                </div>
                                <div class="form-group"  id="item-">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="51549.Bölge Satış Müdürü"></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="BSM_ID" id="BSM_ID" value="">
                                            <input type="text" name="BSM" id="BSM"  readonly="">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=detail_search_form.BSM_ID&field_name=detail_search_form.BSM&employee_list=1&select_list=1</cfoutput>');"></span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="BSM_ID_VIEW" id="BSM_ID_VIEW" value="1" onClick="gizle_goster(frm_row53);"> <cf_get_lang dictionary_id='58596.Göster'></label>				
                                </div>
                                <div class="form-group"  id="item-TELEFON_ID">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="51877.Telefonla Satış Görevlisi"></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="TELEFON_ID" id="TELEFON_ID" value="">
                                            <input type="text" name="TELEFON" id="TELEFON"  readonly="">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=detail_search_form.TELEFON_ID&field_name=detail_search_form.TELEFON&employee_list=1&select_list=1</cfoutput>');"></span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="TELEFON_ID_VIEW" id="TELEFON_ID_VIEW" value="1" onClick="gizle_goster(frm_row55);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-TAHSILAT_ID">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="51652.Tahsilat Görevlisi"></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="TAHSILAT_ID" id="TAHSILAT_ID" value="">
                                            <input type="text" name="TAHSILAT" id="TAHSILAT"  readonly="">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=detail_search_form.TAHSILAT_ID&field_name=detail_search_form.TAHSILAT&employee_list=1&select_list=1</cfoutput>');"></span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="TAHSILAT_ID_VIEW" id="TAHSILAT_ID_VIEW" value="1" onClick="gizle_goster(frm_row56);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-ITRIYAT">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="52045.Itriyat Görevlisi"></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="ITRIYAT_ID" id="ITRIYAT_ID" value="">
                                            <input type="text" name="ITRIYAT" id="ITRIYAT"  readonly="">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=detail_search_form.ITRIYAT_ID&field_name=detail_search_form.ITRIYAT&employee_list=1&select_list=1</cfoutput>');"></span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="ITRIYAT_ID_VIEW" id="ITRIYAT_ID_VIEW" value="1" onClick="gizle_goster(frm_row57);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-BOLGE_KODU">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="51897.Bölge Kodu"></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <input type="text" tabindex="37" name="BOLGE_KODU" id="BOLGE_KODU">
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="BOLGE_KODU_VIEW" id="BOLGE_KODU_VIEW" value="1" onClick="gizle_goster(frm_row60);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-RISK_LIMIT_MAX">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="49667.Risk Limiti"></label>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <input type="text" name="RISK_LIMIT_MAX" id="RISK_LIMIT_MAX" validate="float" message="#message#" onKeyup='return(FormatCurrency(this,event));' value="" style="width:65px;" class="moneybox">
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" name="RISK_LIMIT_MIN" id="RISK_LIMIT_MIN" validate="float" message="#message#" onKeyup='return(FormatCurrency(this,event));' value="" style="width:63px;" class="moneybox">
                                            <span class="input-group-addon width">
                                                <select name="money_type" id="money_type" tabindex="44">
                                                    <cfoutput query="get_money">
                                                        <option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                                    </cfoutput>
                                                </select>
                                            </span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="RISK_LIMIT_VIEW" id="RISK_LIMIT_VIEW" value="1" onClick="gizle_goster(frm_row61);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-ODEME_SEKLI">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><input type="text" tabindex="37" name="ODEME_SEKLI" id="ODEME_SEKLI"></div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="ODEME_SEKLI_VIEW" id="ODEME_SEKLI_VIEW" value="1" onClick="gizle_goster(frm_row62);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-CEP_SIRA">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="52046.Cep Sıra"></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <input type="text" tabindex="37" name="CEP_SIRA" id="CEP_SIRA">
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="CEP_SIRA_VIEW" id="CEP_SIRA_VIEW" value="1" onClick="gizle_goster(frm_row63);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-TR_STATUS">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="52047.Müşteri Durum"></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <select name="TR_STATUS" id="TR_STATUS" style="width:200px;height:85px" multiple>
                                            <cfoutput query="get_status">
                                                <option value="#tr_id#">#tr_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="TR_STATUS_VIEW" id="TR_STATUS_VIEW" value="1" onClick="gizle_goster(frm_row51);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-NICK_NAME">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51696.Çalışılan Şubeler'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <select name="NICK_NAME" id="NICK_NAME" style="width:200px;height:85px" multiple>
                                            <cfoutput query="get_related_depots">
                                                <option value="#branch_id#">#branch_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="NICK_NAME_VIEW" id="NICK_NAME_VIEW" value="1" onClick="gizle_goster(frm_row9);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-PARTNER_RELATION_VIEW">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='52200.Şube İle İlişkisi'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><cf_wrk_combo
                                                name="PARTNER_RELATION"
                                                query_name="GET_PARTNER_RELATION"
                                                option_name="partner_relation"
                                                option_value="partner_relation_id"
                                                is_option_text="0"
                                                width="200"
                                                height="85"
                                                multiple="1">
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="PARTNER_RELATION_VIEW" id="PARTNER_RELATION_VIEW" value="1" onClick="gizle_goster(frm_row10);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-RESOURCE_VIEW">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='52201.İlişki Başlangıcı'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><cf_wrk_combo
                                                name="RESOURCE"
                                                query_name="GET_PARTNER_RESOURCE"
                                                option_name="resource"
                                                option_value="resource_id"
                                                is_option_text="0"
                                                width="200"
                                                height="85"
                                                multiple="1">
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="RESOURCE_VIEW" id="RESOURCE_VIEW" value="1" onClick="gizle_goster(frm_row11);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-CARIHESAPKOD_VIEW">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="51673.Cari Hesap Kodu"></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><input type="text" tabindex="37" name="CARIHESAPKOD" id="CARIHESAPKOD" maxlength="10"></div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="CARIHESAPKOD_VIEW" id="CARIHESAPKOD_VIEW" value="1" onClick="gizle_goster(frm_row65);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-ISCUSTOMERCONTRACT">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="51451.Anlaşma Müşteri Statü"></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <select name="ISCUSTOMERCONTRACT" id="ISCUSTOMERCONTRACT" size="1">
                                                <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                <option value="1"><cf_get_lang dictionary_id="56064.A Olanlar"></option>
                                                <option value="0"><cf_get_lang dictionary_id="56082.A Olmayanlar"></option>
                                            </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="ISCUSTOMERCONTRACT_VIEW" id="ISCUSTOMERCONTRACT_VIEW" value="1" onClick="gizle_goster(frm_row69);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-md-12 col-sm-12 column" type="column" index="3"  sort="true">
                            <cf_seperator title="#getLang('','',55126)#"  id="kisisel_bilgiler_">
                            <div class="col col-12 col-md-12 col-sm-12 column" id="kisisel_bilgiler_">
                                <div class="form-group" id="item-selectall">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <input type="checkbox" id="kisisel_bilgiler_selectall" name="kisisel_bilgiler_selectall"><cf_get_lang dictionary_id='46850.Tümünü Göster'>
                                    </label>
                                </div>
                                <div class="form-group"  id="item-Tip">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="59030.Tip"></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <select name="is_type" id="is_type">
                                            <option value="1" selected><cf_get_lang dictionary_id='52048.Eczacı'></option>
                                            <option value="2"><<cf_get_lang dictionary_id='52049.Yardımcı'></option>
                                            <option value="" ><cf_get_lang dictionary_id='57708.Tümü'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="IS_TYPE_VIEW" id="IS_TYPE_VIEW" value="1" onClick="gizle_goster(frm_row50);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-ASSISTANCE_STATUS">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <select name="ASSISTANCE_STATUS" id="ASSISTANCE_STATUS" size="4" multiple>
                                            <cfoutput query="get_partner_position">
                                                <option value="#partner_position_id#">#partner_position#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="ASSISTANCE_STATUS_VIEW" id="ASSISTANCE_STATUS_VIEW" value="1" onClick="gizle_goster(frm_row12);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-BIRTHPLACE">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><input type="text" tabindex="37" name="BIRTHPLACE" id="BIRTHPLACE"></div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="BIRTHPLACE_VIEW" id="BIRTHPLACE_VIEW" value="1" onClick="gizle_goster(frm_row13);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group" id="item-BIRTHDATE1">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                                    <div class="col col-5 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="BIRTHDATE1" id="BIRTHDATE1"   autocomplete="off" value="" >
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="BIRTHDATE1"></span>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                        <select name="BIRTHDATE_CONDITION" id="BIRTHDATE_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="<="><cf_get_lang dictionary_id='51819.Küçük Eşit'></option>
                                            <option value="<"><cf_get_lang dictionary_id='57927.Küçük'> </option>
                                            <option value=">="><cf_get_lang dictionary_id='51821.Büyük Eşit'> </option>
                                            <option value=">"><cf_get_lang dictionary_id='57929.Büyük'> </option>
                                            <option value="<>"><cf_get_lang dictionary_id='51823.Eşit Değil'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="BIRTHDATE_VIEW" id="BIRTHDATE_VIEW" value="1" onClick="gizle_goster(frm_row14);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51522.Evlenme Tarihi'></label>
                                    <div class="col col-5 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="MARRIED_DATE1" id="MARRIED_DATE1"   autocomplete="off" value="" >
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="MARRIED_DATE1"></span>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                        <select name="MARRIED_DATE_CONDITION" id="MARRIED_DATE_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="<="><cf_get_lang dictionary_id='51819.Küçük Eşit'></option>
                                            <option value="<"><cf_get_lang dictionary_id='57927.Küçük'></option>
                                            <option value=">="><cf_get_lang dictionary_id='51821.Büyük Eşit'> </option>
                                            <option value=">"><cf_get_lang dictionary_id='57929.Büyük'> </option>
                                            <option value="<>"><cf_get_lang dictionary_id='51823.Eşit Değil'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="MARRIED_DATE_VIEW" id="MARRIED_DATE_VIEW" value="1" onClick="gizle_goster(frm_row15);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                
                                <div class="form-group"  id="item-">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='56525.Medeni Hali'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <select name="MARITAL_STATUS_NAME" id="MARITAL_STATUS_NAME" size="3" multiple>
                                            <option value="1"><cf_get_lang dictionary_id='55744.Bekar'></option>
                                            <option value="2"><cf_get_lang dictionary_id='55743.Evli'></option>
                                            <option value="3"><cf_get_lang dictionary_id='51555.Dul'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="MARITAL_STATUS_NAME_VIEW" id="MARITAL_STATUS_NAME_VIEW" value="1" onClick="gizle_goster(frm_row16);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='46569.Mezun Olduğu Okul'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><select name="UNIVERSITY_NAME" id="UNIVERSITY_NAME" size="4" multiple>
                                            <cfoutput query="get_faculty">
                                                <option value="#university_id#">#university_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="UNIVERSITY_NAME_VIEW" id="UNIVERSITY_NAME_VIEW" value="1" onClick="gizle_goster(frm_row17);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='46569.Mezuniyet yılı'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><select name="GRADUATE_YEAR" id="GRADUATE_YEAR">
                                            <option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
                                            <cfoutput>
                                            <cfloop from="1920" to="#year(now())#" index="i">
                                                <option value="#i#">#i#</option>
                                            </cfloop>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><select name="GRADUATE_YEAR_CONDITION" id="GRADUATE_YEAR_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="<="><cf_get_lang dictionary_id='51819.Küçük Eşit'></option>
                                            <option value="<"><cf_get_lang dictionary_id='57927.Küçük'> </option>
                                            <option value=">="><cf_get_lang dictionary_id='51821.Büyük Eşit'> </option>
                                            <option value=">"><cf_get_lang dictionary_id='57929.Büyük'> </option>
                                            <option value="<>"><cf_get_lang dictionary_id='51823.Eşit Değil'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="GRADUATE_YEAR_VIEW" id="GRADUATE_YEAR_VIEW" value="1" onClick="gizle_goster(frm_row18);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><select name="SEX_NAME" id="SEX_NAME" size="3" multiple>
                                            <option value="1"><cf_get_lang dictionary_id='51610.Bay'></option>
                                            <option value="2"><cf_get_lang dictionary_id='55621.Bayan'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="SEX_NAME_VIEW" id="SEX_NAME_VIEW" value="1" onClick="gizle_goster(frm_row19);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-HOBBY_NAME">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='56599.Hobiler'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <select name="HOBBY_NAME" id="HOBBY_NAME" style="width:485px; height:80px;" multiple></select>
                                            <span class="input-group-addon">  
                                                <i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_hobby_detail&field_name=detail_search_form.HOBBY_NAME&field_id=detail_search_form.HOBBY_NAME');"  title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                                <i class="icon-minus btnPointer show" onClick="remove_field('HOBBY_NAME');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="HOBBY_NAME_VIEW" id="HOBBY_NAME_VIEW" value="1" onClick="gizle_goster(frm_row20);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51710.Cep Tel Kodu'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="MOBIL_CODE" id="MOBIL_CODE" type="text" style="width:75;" maxlength="3"></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="MOBIL_CODE_CONDITION" id="MOBIL_CODE_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="<="><cf_get_lang dictionary_id='51819.Küçük Eşit'></option>
                                            <option value="<"><cf_get_lang dictionary_id='57927.Küçük'> </option>
                                            <option value=">="><cf_get_lang dictionary_id='51821.Büyük Eşit'> </option>
                                            <option value=">"><cf_get_lang dictionary_id='57929.Büyük'> </option>
                                            <option value="<>"><cf_get_lang dictionary_id='51823.Eşit Değil'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="MOBIL_CODE_VIEW" id="MOBIL_CODE_VIEW" value="1" onClick="gizle_goster(frm_row21);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="58025.TC Kimlik No"></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="text" name="TC_IDENTITY" id="TC_IDENTITY" onkeyup="isNumber(this);" onblur='isNumber(this);' maxlength="11" style="width:75px;"></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="TC_IDENTITY_CONDITION" id="TC_IDENTITY_CONDITION" >
                                            <option value="1"><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="2"><cf_get_lang dictionary_id='52113.Boş Kayıt'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="TC_IDENTITY_VIEW" id="TC_IDENTITY_VIEW" value="1" onClick="gizle_goster(frm_row64);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>					  
                            </div>
                        </div>
                        <div class="col col-12 col-md-12 col-sm-12 column" type="column" index="3"  sort="true">
                            <cf_seperator title="#getLang('','',51575)#"  id="calisma_bilgileri_">
                            <div class="col col-12 col-md-12 col-sm-12 column" id="calisma_bilgileri_">
                                <div class="form-group" id="item-selectall">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <input type="checkbox" id="calisma_bilgileri_selectall" name="calisma_bilgileri_selectall"><cf_get_lang dictionary_id='46850.Tümünü Göster'>
                                    </label>
                                </div>
                                    <div class="form-group"  id="item-SOCIETY">
                                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42846.Sosyal Güvenlik Kurumları'></label>
                                        <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                            <div class="input-group">
                                                <select name="SOCIETY" id="SOCIETY" style="width:485px; height:80px;" multiple></select>
                                                <span class="input-group-addon">  
                                                    <i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_society_detail&field_name=detail_search_form.SOCIETY');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                                    <i class="icon-minus btnPointer show" onClick="remove_field('SOCIETY');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                                </span>
                                            </div>
                                        </div>
                                        <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="SOCIETY_VIEW" id="SOCIETY_VIEW" value="1" onClick="gizle_goster(frm_row22);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                    </div>
                                <div class="form-group"  id="item-GENEL_KONUM">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51567.Müşterinin Genel Konumu'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <select name="GENEL_KONUM" id="GENEL_KONUM" style="width:485px; height:80px;" multiple></select>
                                                <span class="input-group-addon">  
                                                    <i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_position_detail&field_name=detail_search_form.GENEL_KONUM');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                                    <i class="icon-minus btnPointer show" onClick="remove_field('GENEL_KONUM');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                                </span>
                                            </select>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="GENEL_KONUM_VIEW" id="GENEL_KONUM_VIEW" value="1" onClick="gizle_goster(frm_row23);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-SECTOR_CAT">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51594.Uğraştığı Diğer İşler'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <select name="SECTOR_CAT" id="SECTOR_CAT"style="width:485px; height:80px;" multiple></select>
                                                <span class="input-group-addon">  
                                                    <i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_other_works_detail&field_name=detail_search_form.SECTOR_CAT');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                                    <i class="icon-minus btnPointer show" onClick="remove_field('SECTOR_CAT');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                                </span>
                                            </select>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="SECTOR_CAT_VIEW" id="SECTOR_CAT_VIEW" value="1" onClick="gizle_goster(frm_row24);"><cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-PERIOD_NAME">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51570.Müşteri Nöbet Durumu'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <select name="PERIOD_NAME" id="PERIOD_NAME"  size="4" multiple>
                                            <cfoutput query="get_duty_period">
                                                <option value="#period_id#">#period_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="NOBET_DURUMU_VIEW" id="NOBET_DURUMU_VIEW" value="1" onClick="gizle_goster(frm_row25);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-BURO_YAZILIMLARI">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51595.Büro Yazılımları'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <select name="BURO_YAZILIMLARI" id="BURO_YAZILIMLARI"style="width:485px; height:80px;" multiple></select>
                                            <span class="input-group-addon">  
                                                <i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_office_stuff_detail&field_name=detail_search_form.BURO_YAZILIMLARI');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                                <i class="icon-minus btnPointer show" onClick="remove_field('BURO_YAZILIMLARI');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="BURO_YAZILIMLARI_VIEW" id="BURO_YAZILIMLARI_VIEW" value="1" onClick="gizle_goster(frm_row26);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-SETUP_STOCK_AMOUNT">
                                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42040.Stok ve Raf Durumu'></label>
                                        <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                            <select name="SETUP_STOCK_AMOUNT" id="SETUP_STOCK_AMOUNT">
                                                <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                <cfoutput query="get_stocks">
                                                    <option value="#stock_id#">#stock_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="SETUP_STOCK_AMOUNT_VIEW" id="SETUP_STOCK_AMOUNT_VIEW" value="1" onClick="gizle_goster(frm_row27);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-CONNECTION_NAME">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51569.İnternet Bağlantısı'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><cfsavecontent variable="text"><cf_get_lang dictionary_id='57708.Tümü'></cfsavecontent>
                                        <cf_wrk_combo
                                            name="CONNECTION_NAME"
                                            query_name="GET_SETUP_NET_CONNECTION"
                                            option_name="connection_name"
                                            option_value="connection_id"
                                            width="200"
                                            option_text="#text#">
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="CONNECTION_NAME_VIEW" id="CONNECTION_NAME_VIEW" value="1" onClick="gizle_goster(frm_row28);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-PC_NUMBER">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51597.Bilgisayar Sayısı'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><cfsavecontent variable="text"><cf_get_lang dictionary_id='57708.Tümü'></cfsavecontent>
                                        <cf_wrk_combo
                                            name="PC_NUMBER"
                                            query_name="GET_SETUP_PC_NUMBER"
                                            option_name="unit_name"
                                            option_value="unit_id"
                                            width="200"
                                            option_text="#text#">
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="PC_NUMBER_VIEW" id="PC_NUMBER_VIEW" value="1" onClick="gizle_goster(frm_row29);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-CONCERN_NAME">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51568.IT Teknolojilerine Yakınlığı'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <select name="CONCERN_NAME" id="CONCERN_NAME" >
                                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                            <cfoutput query="get_it_concern">
                                                <option value="#concern_id#">#concern_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="CONCERN_NAME_VIEW" id="CONCERN_NAME_VIEW" value="1" onClick="gizle_goster(frm_row30);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-ISSMS">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51571.SMS İstiyor mu'>?</label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <select name="ISSMS" id="ISSMS" size="1">
                                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                            <option value="1"><cf_get_lang dictionary_id='57495.Evet'></option>
                                            <option value="0"><cf_get_lang dictionary_id='57496.Hayır'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="ISSMS_VIEW" id="ISSMS_VIEW" value="1" onClick="gizle_goster(frm_row31);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 col-md-12 col-sm-12 column" type="column" index="4"  sort="true">
                            <cf_seperator title="#getLang('','',51623)#" id="rakip_bilgileri_">
                            <div class="col col-12 col-md-12 col-sm-12 column" id="rakip_bilgileri_">
                                <div class="form-group" id="item-selectall">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <input type="checkbox" id="rakip_bilgileri_selectall" name="rakip_bilgileri_selectall"><cf_get_lang dictionary_id='46850.Tümünü Göster'>
                                    </label>
                                </div>
                                <div class="form-group"  id="item-RIVAL_NAME">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51709.Rakip Depolar'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <select name="RIVAL_NAME" id="RIVAL_NAME" style="width:485px; height:80px;" multiple></select>
                                            <span class="input-group-addon">
                                                <i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_rival_detail&field_name=detail_search_form.RIVAL_NAME');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                                <i class="icon-minus btnPointer show" onClick="remove_field('RIVAL_NAME');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="RIVAL_NAME_VIEW" id="RIVAL_NAME_VIEW" value="1" onClick="gizle_goster(frm_row32);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                
                                <div class="form-group"  id="item-SUNULAN_OPSIYON">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51724.Tercih Nedeni'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <select name="SUNULAN_OPSIYON" id="SUNULAN_OPSIYON"style="width:485px; height:80px;" multiple></select>
                                            <span class="input-group-addon">
                                                <i class="icon-pluss btnPointer show" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_option_applied_detail&field_name=detail_search_form.SUNULAN_OPSIYON');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                                <i class="icon-minus btnPointer show" onClick="remove_field('SUNULAN_OPSIYON');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="SUNULAN_OPSIYON_VIEW" id="SUNULAN_OPSIYON_VIEW" value="1" onClick="gizle_goster(frm_row33);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-YAPILAN_ETKINLIKLER">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51723.Yapılan Etkinlikler'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                        <div class="input-group">
                                            <select name="YAPILAN_ETKINLIKLER" id="YAPILAN_ETKINLIKLER"style="width:485px; height:80px;" multiple></select>
                                            <span class="input-group-addon">
                                                <i class="icon-pluss btnPointer show"onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_rivals_activity&field_name=detail_search_form.YAPILAN_ETKINLIKLER');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                                <i class="icon-minus btnPointer show" onClick="remove_field('YAPILAN_ETKINLIKLER');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="YAPILAN_ETKINLIKLER_VIEW" id="YAPILAN_ETKINLIKLER_VIEW" value="1" onClick="gizle_goster(frm_row34);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-SERVIS_SAYISI">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51722.Servis Sayısı'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <select name="SERVIS_SAYISI" id="SERVIS_SAYISI" >
                                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                            <cfoutput>
                                            <cfloop from="1" to="15" index="i">
                                                <option value="#i#">#i#</option>
                                            </cfloop>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="SERVIS_SAYISI_CONDITION" id="SERVIS_SAYISI_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                            <option value="<="><cf_get_lang dictionary_id='51819.Küçük Eşit'></option>
                                            <option value="<"><cf_get_lang dictionary_id='57927.Küçük'></option>
                                            <option value=">="><cf_get_lang dictionary_id='51821.Büyük Eşit'> </option>
                                            <option value=">"><cf_get_lang dictionary_id='57929.Büyük'> </option>
                                            <option value="<>"><cf_get_lang dictionary_id='51823.Eşit Değil'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="SERVIS_SAYISI_VIEW" id="SERVIS_SAYISI_VIEW" value="1" onClick="gizle_goster(frm_row35);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-ILISKI_DUZEYI">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51738.İlişki Düzeyi'></label>
                                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><cfsavecontent variable="text"><cf_get_lang dictionary_id='57708.Tümü'></cfsavecontent>
                                        <cf_wrk_combo
                                                name="ILISKI_DUZEYI"
                                                query_name="GET_PARTNER_RELATION"
                                                option_name="partner_relation"
                                                option_value="partner_relation_id"
                                                option_text="#text#"
                                                width="200">
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="ILISKI_DUZEYI_VIEW" id="ILISKI_DUZEYI_VIEW" value="1" onClick="gizle_goster(frm_row36);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                                <div class="form-group"  id="item-">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51737.Özel Bilgiler'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><textarea name="OZEL_BILGILER" id="OZEL_BILGILER" style="width:200px;height:60px;"></textarea></div>
                                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                        <select name="OZEL_BILGILER_CONDITION" id="OZEL_BILGILER_CONDITION" >
                                            <option value="="><cf_get_lang dictionary_id='51818.Eşit'></option>
                                        </select>
                                    </div>
                                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><input type="checkbox" name="OZEL_BILGILER_VIEW" id="OZEL_BILGILER_VIEW" value="1" onClick="gizle_goster(frm_row37);"> <cf_get_lang dictionary_id='58596.Göster'></label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-5 col-md-5 col-sm-12 column" type="column" index="5" sort="true">
                        <cf_seperator title="#getLang('','',51766)#"  id="secili_alanlar_">
                        <div class="col col-12 col-md-12 col-sm-12 column" id="secili_alanlar_">
                            <div class="form-group"  id="item-">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='52115.Hedef Kodu'>"></i> <cf_get_lang dictionary_id='52115.Hedef Kodu'></label>
                            </div>
                            <div class="form-group"  id="item-">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='52118.İş Yeri Adı'>"></i> <cf_get_lang dictionary_id='52118.İş Yeri Adı'></label>
                            </div>
                            <div class="form-group"  id="item-">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51816.İlgili Adı'>"></i><cf_get_lang dictionary_id='51816.İlgili Adı'></label>
                            </div>
                            <div class="form-group"  id="item-">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51817.İlgili Soyadı'>"></i><cf_get_lang dictionary_id='51817.İlgili Soyadı'></label>
                            </div>
                            <div id="frm_row38" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="Vergi Numarası"></i><cf_get_lang dictionary_id="56085.Vergi Numarası"></label>
                            </div>
                            <div id="frm_row39" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='58762.Vergi Dairesi'>"></i><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
                            </div>
                            <div id="frm_row40" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="Telefon"></i><cf_get_lang dictionary_id="57499.Telefon"></label>
                            </div>
                            <div id="frm_row41" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="Email"></i><cf_get_lang dictionary_id="33152.Email"></label>
                            </div>
                            <div id="frm_row3" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57292.Müşteri Tipi'>"></i><cf_get_lang dictionary_id='57292.Müşteri Tipi'></label>
                            </div>
                            <div id="frm_row4" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='49657.IMS Bölge Kodu'>"></i> <cf_get_lang dictionary_id='49657.IMS Bölge Kodu'></label>
                            </div>
                            <div id="frm_row5" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='58608.İl'>"></i> <cf_get_lang dictionary_id='58608.İl'></label>
                            </div>
                            <div id="frm_row6" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='63898.İlçe'>"></i> <cf_get_lang dictionary_id='63898.İlçe'></label>
                            </div>
                            <div id="frm_row7" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='58735.Mahalle'>"></i> <cf_get_lang dictionary_id='58735.Mahalle'></label>
                            </div>
                            <div id="frm_row8" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='58132.Semt'>"></i> <cf_get_lang dictionary_id='58132.Semt'></label>
                            </div>
                            
                            <div id="frm_row66" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='59266.Cadde'>"></i> <cf_get_lang dictionary_id='59266.Cadde'></label>
                            </div>
                            <div id="frm_row67" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='59267.Sokak'>"></i> <cf_get_lang dictionary_id='59267.Sokak'></label>
                            </div>
                            <div id="frm_row68" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57487.No'>"></i> <cf_get_lang dictionary_id='57487.No'></label>
                            </div>
                                
                            <div id="frm_row9" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51696.Çalışılan Şubeler'>"></i> <cf_get_lang dictionary_id='51696.Çalışılan Şubeler'></label>
                            </div>
                            <div id="frm_row52" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51548.Saha Satış Görevlisi'>"></i><cf_get_lang dictionary_id="51548.<cf_get_lang dictionary_id='51548.Saha Satış Görevlisi'>"></label>
                            </div>
                            <div id="frm_row53" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="51549.Bölge Satış Müdürü">"></i><cf_get_lang dictionary_id="51549.Bölge Satış Müdürü"></label>
                            </div>
                            <div id="frm_row55" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="51877.Telefonla Satış Görevlisi">"></i><cf_get_lang dictionary_id="51877.Telefonla Satış Görevlisi"></label>
                            </div>
                            <div id="frm_row56" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="51652.Tahsilat Görevlisi">"></i><cf_get_lang dictionary_id="51652.Tahsilat Görevlisi"></label>
                            </div>
                            <div id="frm_row57" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="52045.Itriyat Görevlisi">"></i><cf_get_lang dictionary_id="52045.Itriyat Görevlisi"></label>
                            </div>
                            <div id="frm_row51" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="52047.Müşteri Durum">"></i><cf_get_lang dictionary_id="52047.Müşteri Durum"></label>
                            </div>
                            <div id="frm_row10" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='52200.Şube İle İlişkisi'>"></i> <cf_get_lang dictionary_id='52200.Şube İle İlişkisi'></label>
                            </div>
                            <div id="frm_row60" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="51897.Bölge Kodu">"></i><cf_get_lang dictionary_id="51897.Bölge Kodu"></label>
                            </div>
                            <div id="frm_row61" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="49667.Risk Limiti">"></i><cf_get_lang dictionary_id="49667.Risk Limiti"></label>
                            </div>
                            <div id="frm_row62" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="30057.Ödeme Şekli">"></i><cf_get_lang dictionary_id="30057.Ödeme Şekli"></label>
                            </div>
                            <div id="frm_row63" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="52046.Cep Sıra">"></i><cf_get_lang dictionary_id="52046.Cep Sıra"></label>
                            </div>
                            <div id="frm_row11" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='52201.İlişki Başlangıcı'>"></i> <cf_get_lang dictionary_id='52201.İlişki Başlangıcı'></label>
                            </div>
                            <div id="frm_row65" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="51673.Cari Hesap Kodu">"></i><cf_get_lang dictionary_id="51673.Cari Hesap Kodu"></label>
                                </div>		
                            <div id="frm_row69" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="51451.Anlaşma Müşteri Statü">"></i><cf_get_lang dictionary_id="51451.Anlaşma Müşteri Statü"></label>
                            </div>		
                            <div id="frm_row50" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="59030.Tip">"></i><cf_get_lang dictionary_id="59030.Tip"></label>
                            </div>
                            <div id="frm_row12" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='58497.Pozisyon'>"></i> <cf_get_lang dictionary_id='58497.Pozisyon'></label>
                            </div>
                            <div id="frm_row13" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57790.Doğum Yeri'>"></i><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                            </div>
                            <div id="frm_row14" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='58727.Doğum Tarihi'>"></i> <cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                            </div>
                            <div id="frm_row15" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51522.Evlenme Tarihi'>"></i> <cf_get_lang dictionary_id='51522.Evlenme Tarihi'></label>
                            </div>
                            <div id="frm_row16" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='56525.Medeni Hali'>"></i> <cf_get_lang dictionary_id='56525.Medeni Hali'></label>
                            </div>
                            <div id="frm_row17" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='46569.Mezun Olduğu Okul'>"></i> <cf_get_lang dictionary_id='46569.Mezun Olduğu Okul'></label>
                            </div>
                            <div id="frm_row18" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='46569.Mezuniyet yılı'>"></i> <cf_get_lang dictionary_id='46569.Mezuniyet yılı'></label>
                            </div>
                            <div id="frm_row19" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57764.Cinsiyet'>"></i> <cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                            </div>
                            <div id="frm_row20" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='56599.Hobiler'>"></i> <cf_get_lang dictionary_id='56599.Hobiler'></label>
                            </div>
                            <div id="frm_row21" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51710.Cep Tel Kodu'>"></i> <cf_get_lang dictionary_id='51710.Cep Tel Kodu'></label>
                            </div>
                            <div id="frm_row64" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id="58025.TC Kimlik No">"></i><cf_get_lang dictionary_id="58025.TC Kimlik No"></label>
                            </div>
                            <div id="frm_row22" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title=" <cf_get_lang dictionary_id='42846.Sosyal Güvenlik Kurumları'>"></i> <cf_get_lang dictionary_id='42846.Sosyal Güvenlik Kurumları'></label>
                            </div>
                            <div id="frm_row23" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51567.Müşterinin Genel Konumu'>"></i> <cf_get_lang dictionary_id='51567.Müşterinin Genel Konumu'></label>
                            </div>
                            <div id="frm_row24" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51594.Uğraştığı Diğer İşler'>"></i> <cf_get_lang dictionary_id='51594.Uğraştığı Diğer İşler'></label>
                            </div>
                            <div id="frm_row25" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51570.Müşteri Nöbet Durumu'>"></i> <cf_get_lang dictionary_id='51570.Müşteri Nöbet Durumu'></label>
                            </div>
                            <div id="frm_row26" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51595.Büro Yazılımları'>"></i> <cf_get_lang dictionary_id='51595.Büro Yazılımları'></label>
                            </div>
                            <div id="frm_row27" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='42040.Stok ve Raf Durumu'>"></i> <cf_get_lang dictionary_id='42040.Stok ve Raf Durumu'></label>
                            </div>
                            <div id="frm_row28" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51569.İnternet Bağlantısı'>"></i> <cf_get_lang dictionary_id='51569.İnternet Bağlantısı'></label>
                            </div>
                            <div id="frm_row29" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51597.Bilgisayar Sayısı'>"></i> <cf_get_lang dictionary_id='51597.Bilgisayar Sayısı'></label>
                            </div>
                            <div id="frm_row30" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51568.IT Teknolojilerine Yakınlığı'>"></i> <cf_get_lang dictionary_id='51568.IT Teknolojilerine Yakınlığı'></label>
                            </div>
                            <div id="frm_row31" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51571.SMS İstiyor mu'>"></i> <cf_get_lang dictionary_id='51571.SMS İstiyor mu'> ?</label>
                            </div>
                            <div id="frm_row32" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51709.Rakip Depolar'>"></i> <cf_get_lang dictionary_id='51709.Rakip Depolar'></label>
                            </div>
                            <div id="frm_row33" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51724.Tercih Nedeni'>"></i> <cf_get_lang dictionary_id='51724.Tercih Nedeni'></label>
                            </div>
                            <div id="frm_row34" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51723.Yapılan Etkinlikler'>"></i> <cf_get_lang dictionary_id='51723.Yapılan Etkinlikler'></label>
                            </div>
                            <div id="frm_row35" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51722.Servis Sayısı'>"></i> <cf_get_lang dictionary_id='51722.Servis Sayısı'></label>
                            </div>
                            <div id="frm_row36" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51738.İlişki Düzeyi'>"></i> <cf_get_lang dictionary_id='51738.İlişki Düzeyi'></label>
                            </div>
                            <div id="frm_row37" style="display:none;">
                                <label class="col col-8 col-xs-12"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='51737.Özel Bilgiler'>"></i><cf_get_lang dictionary_id='51737.Özel Bilgiler'></label>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <button type="button"   onClick="check_form()" class=" ui-wrk-btn ui-wrk-btn-success" ><cf_get_lang dictionary_id='58596.Göster'></button>
            </cf_box_footer>
        </cfform>
   
    </cf_box>
</div>
<script type="text/javascript">


/* $('#genel_bilgiler_selectall').click(function(event) {  
 
    if(this.checked) {
        // Iterate each checkbox
        $('checkbox.bilgiler').each(function() {
            this.checked = true;   
           
           
                            
        });
    } else {
        $(':checkbox').each(function() {
            this.checked = false;                       
        });
    }
});  */

    $('#genel_bilgiler_selectall').click(function(event) {  //on click
        if(this.checked) { // check select status
            $('#genel_bilgiler_ :checkbox').prop('checked', true);
            $('#genel_bilgiler_ :checkbox').trigger('onclick');
          
        }else{
            $('#genel_bilgiler_ :checkbox').prop('checked', false);
            $('#genel_bilgiler_ :checkbox').trigger('onclick');
        }
    });
    $('#calistigi_subeler_selectall').click(function(event) {  //on click
        if(this.checked) { // check select status
            $('#calistigi_subeler_ :checkbox').prop('checked', true);
            $('#calistigi_subeler_ :checkbox').trigger('onclick');
          
        }else{
            $('#calistigi_subeler_ :checkbox').prop('checked', false);
            $('#calistigi_subeler_ :checkbox').trigger('onclick');
        }
    });
    $('#kisisel_bilgiler_selectall').click(function(event) {  //on click
        if(this.checked) { // check select status
            $('#kisisel_bilgiler_ :checkbox').prop('checked', true);
            $('#kisisel_bilgiler_ :checkbox').trigger('onclick');
          
        }else{
            $('#kisisel_bilgiler_ :checkbox').prop('checked', false);
            $('#kisisel_bilgiler_ :checkbox').trigger('onclick');
        }
    });
    $('#calisma_bilgileri_selectall').click(function(event) {  //on click
        if(this.checked) { // check select status
            $('#calisma_bilgileri_ :checkbox').prop('checked', true);
            $('#calisma_bilgileri_ :checkbox').trigger('onclick');
          
        }else{
            $('#calisma_bilgileri_ :checkbox').prop('checked', false);
            $('#calisma_bilgileri_ :checkbox').trigger('onclick');
        }
    });
    $('#rakip_bilgileri_selectall').click(function(event) {  //on click
        if(this.checked) { // check select status
            $('#rakip_bilgileri_ :checkbox').prop('checked', true);
            $('#rakip_bilgileri_ :checkbox').trigger('onclick');
          
        }else{
            $('#rakip_bilgileri_ :checkbox').prop('checked', false);
            $('#rakip_bilgileri_ :checkbox').trigger('onclick');
        }
    });
   


	function remove_field(field_option_name)
		{
			field_option_name_value = document.getElementById(field_option_name);
			for (i=field_option_name_value.options.length-1;i>-1;i--)
			{
				if (field_option_name_value.options[i].selected==true)
				{
					field_option_name_value.options.remove(i);
				}	
			}
		}


function select_all(selected_field,isview)
{
	var m = eval("document.detail_search_form."+selected_field+".length");
	var select_all_control = 1;
	if(m==0)
	{
		eval("document.detail_search_form."+selected_field+".options.length=1");
		m=1;
	}
	if(isview==0)
	{
		for(i=0;i<m;i++)
		{
			eval("document.detail_search_form."+selected_field+"["+i+"].selected=true");
		}
	}
	else
	{
		for(i=0;i<m;i++)
		{
			if(eval("document.detail_search_form."+selected_field+"["+i+"].selected==true"))
			{
				select_all_control = 0;
			}
		}
		if(select_all_control==1)
		{
			for(i=0;i<m;i++)
			{
				eval("document.detail_search_form."+selected_field+"["+i+"].selected=true");
			}
		}
	}	
}


 function get_phone_code()
{	 /* phone_code_list = new Array(<cfoutput>#valuelist(get_city.phone_code)#</cfoutput>); */
	/* if(document.detail_search_form.CITY_NAME.selectedIndex>0)
	{
		document.detail_search_form.COMPANY_TELCODE.value = phone_code_list[document.detail_search_form.CITY_NAME.selectedIndex-1];
		document.detail_search_form.COMPANY_FAX_CODE.value = phone_code_list[document.detail_search_form.CITY_NAME.selectedIndex-1];
	}
	else
	{
		document.detail_search_form.telcod.value = '';
		document.detail_search_form.faxcode.value = '';
	} */
} 
function pencere_ac(no)
{
	x = document.getElementById("country_id").selectedIndex;
	if (document.getElementById("country_id").value == "")
	{
		alert("<cf_get_lang dictionary_id='57425.Uyarı'>:<cf_get_lang dictionary_id='57485.Öncelik'>-<cf_get_lang dictionary_id='58219.Ülke'>");
	}	
	else if(document.getElementById("city_id").value == "")
	{
		alert("<cf_get_lang dictionary_id='57425.Uyarı'>:<cf_get_lang dictionary_id='57485.Öncelik'>-<cf_get_lang dictionary_id='58608.İl'> !");
	}
	else
	{
     
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=detail_search_form.county_id&field_name=detail_search_form.county_name&city_id='+ document.getElementById("city_id").value);
        return remove_adress();
    }
}

function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.getElementById("city_id").value = '';
		document.getElementById("city").value = '';
		document.getElementById("county_id").value = '';
		document.getElementById("county").value = '';
	}
	else if(parametre==2)
	{
		document.getElementById("county_id").value = '';
		document.getElementById("county").value = '';
	}	
}


function pencere_ac_city()
{
	if (document.getElementById("country_id").value == "")
	{
		alert("<cf_get_lang dictionary_id='57425.Uyarı'>:<cf_get_lang dictionary_id='57485.Öncelik'>-<cf_get_lang dictionary_id='58219.Ülke'>");
	}	
	else
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=detail_search_form.city_id&field_name=detail_search_form.city_name&country_id=' + document.getElementById("country_id").value);
		return remove_adress('2');
	}
}
function check_form()
{
	if(document.detail_search_form.TC_IDENTITY.value != "")
	{
		if(document.detail_search_form.TC_IDENTITY.value.length != 11)
		{
			alert("<cf_get_lang dictionary_id='52469.TC Kimlik Numarası 11 Hane Olmalıdır'>!");
			return false;
		}
	}

	if(document.detail_search_form.CARIHESAPKOD.value != "")
	{
		if(document.detail_search_form.CARIHESAPKOD.value.length != 10)
		{
			alert("<cf_get_lang dictionary_id='52036.Cari Hesap Kodu 10 Hane Olmalıdır'>!");
			return false;
		}
	}
	
	detail_search_form.RISK_LIMIT_MAX.value = filterNum(detail_search_form.RISK_LIMIT_MAX.value);
	detail_search_form.RISK_LIMIT_MIN.value = filterNum(detail_search_form.RISK_LIMIT_MIN.value);
	select_all('IMS_CODE',0);
	select_all('HOBBY_NAME',0);
	select_all('SOCIETY',0);
	select_all('GENEL_KONUM',0);
	select_all('SECTOR_CAT',0);
	select_all('BURO_YAZILIMLARI',0);
	select_all('RIVAL_NAME',0);
	select_all('SUNULAN_OPSIYON',0);
	select_all('YAPILAN_ETKINLIKLER',0);
	document.getElementById("detail_search_form").submit();
}
</script>
