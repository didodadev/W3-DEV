<cfparam name="attributes.fullname" default="">
<cfparam name="attributes.tax_no" default="">
<cfparam name="attributes.company_partner_name" default="">
<cfparam name="attributes.company_partner_surname" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.is_submitted" default="">
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, PLATE_CODE FROM SETUP_CITY WHERE PLATE_CODE IS NOT NULL ORDER BY CITY_NAME
</cfquery>
<cf_box title="#getLang('','Müşteri Ara',51736)#-#getLang('','Şubem İle İlişkilendir',52114)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="search_company" method="post" action="#request.self#?fuseaction=crm.popup_dsp_search_company">		
            <cf_box_search>
                <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                    <div class="form-group medium">
                        <select name="country" id="country" onchange="LoadCity(this.value,'city','county_id',0);">
							<option value=""><cf_get_lang dictionary_id='58219.Ülke'></option>
							<cfquery name="get_country" datasource="#dsn#">
								SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY 
							</cfquery>
							<cfoutput query="get_country">
								<option value="#country_id#" <cfif attributes.country eq country_id>selected</cfif>>#country_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group medium">
                        <select name="city" id="city" onchange="LoadCounty(this.value,'county_id');">
							<option value=""><cf_get_lang dictionary_id='57971.Şehir'></option>
							<cfif isdefined('attributes.country') and len(attributes.country)>
								<cfquery name="get_city" datasource="#dsn#">
									SELECT CITY_ID,CITY_NAME,PLATE_CODE FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"> ORDER BY CITY_NAME 
								</cfquery>
								<cfoutput query="get_city">
									<option value="#city_id#" <cfif attributes.city eq city_id>selected</cfif>>#city_name#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
					<div class="form-group medium">
						<select name="county_id" id="county_id">
							<option value=""><cf_get_lang dictionary_id='58638.Ilçe'></option>
							<cfif isdefined('attributes.city') and len(attributes.city)>
								<cfquery name="get_county" datasource="#DSN#">
									SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#"> ORDER BY COUNTY_NAME
								</cfquery>
								<cfoutput query="get_county">
									<option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>                   
                    <div class="form-group">
                        <cfsavecontent variable="message2"><cf_get_lang dictionary_id='58134.Mikro Bolge Kodu'></cfsavecontent>
                        <div class="input-group">
                            <input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
                            <cfinput type="text" placeHolder="#message2#" name="ims_code_name" value="#attributes.ims_code_name#">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="il_secimi_kontrol();"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function='controlCompany() && #iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_company' , #attributes.modal_id#)"),DE(""))#'>
                    </div>
            </cf_box_search>  
            <cf_box_search_detail search_function='controlCompany() && #iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_company',#attributes.modal_id#)"),DE(""))#'>
                 <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">                       
                    <div class="form-group">
                        <cf_get_lang no='671.İş Yeri Adı'>
                        <input type="text" name="fullname" id="fullname" value="<cfoutput>#attributes.fullname#</cfoutput>">
                    </div>
                    <div class="form-group">
                        <cf_get_lang no='672.Eczacı Adı'>
                        <input type="text" name="company_partner_name" id="company_partner_name" value="<cfoutput>#attributes.company_partner_name#</cfoutput>">
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">          
                    <div class="form-group">
                        <cf_get_lang_main no='340.Vergi No'>
                        <input type="text" name="tax_no" id="tax_no" value="<cfoutput>#attributes.tax_no#</cfoutput>">
                    </div>
                    <div class="form-group">
                        <cf_get_lang no='673.Eczacı Soyadı'>
                        <input type="text" name="company_partner_surname" id="company_partner_surname" value="<cfoutput>#attributes.company_partner_surname#</cfoutput>">
                    </div>
                </div>             
            </cf_box_search_detail>     
        </cfform>
        <cf_grid_list>  
            <thead>
                <tr>
                    <th width="15"><a href="javascript://" onClick="special_record(1);"><i class="fa fa-plus"></i></a></th>
                    <th><cf_get_lang_main no='75.no'></th>
                    <th><cf_get_lang_main no='338.İşyeri Adı'></th>
                    <th><cf_get_lang_main no='158.Ad Soyad'></th>
                    <th><cf_get_lang_main no='722.Mikro Bolge Kodu'></th>
                    <th><cf_get_lang_main no='340.Vergi No'></th>
                    <th><cf_get_lang_main no='1226.İlçe'></th>
                    <th><cf_get_lang_main no='1196.İl'></th>
                    <th><cf_get_lang_main no='87.Telefon'></th>
                    <th><cf_get_lang_main no='41.Şube'></th>
                    <th><cf_get_lang_main no='482.Statü'></th>
                </tr>
            </thead>
            <tbody>
                <cfscript>
                    if (len(attributes.fullname))
                    {
                        fullname_1 = replacelist(attributes.fullname,"ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö","u,g,i,s,c,o,U,G,I,S,C,O");
                        fullname_2 = replacelist(attributes.fullname,"u,g,i,s,c,o,U,G,I,S,C,O","ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö");
                    }
                </cfscript>
                <cfquery name="GET_COMPANY" datasource="#dsn#">
                    SELECT
                        SETUP_CITY.CITY_NAME, 
                        SETUP_COUNTY.COUNTY_NAME, 
                        COMPANY.FULLNAME, 
                        COMPANY_PARTNER.PARTNER_ID, 
                        COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                        COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                        COMPANY.COMPANY_ID,
                        SETUP_IMS_CODE.IMS_CODE, 
                        SETUP_IMS_CODE.IMS_CODE_NAME, 
                        COMPANY.COMPANY_TELCODE,
                        COMPANY.COMPANY_TEL1, 
                        COMPANY.TAXNO,
                        COMPANY.ISPOTANTIAL,
                        COMPANY.COMPANY_ID
                    FROM 
                        COMPANY, 
                        COMPANY_PARTNER, 
                        SETUP_IMS_CODE,
                        SETUP_CITY,
                        SETUP_COUNTY
                    WHERE 
                    <cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>COMPANY.IMS_CODE_ID = #attributes.ims_code_id# AND</cfif>
                    <cfif len(attributes.city)>SETUP_CITY.CITY_ID = #attributes.city# AND</cfif>
                    <cfif len(attributes.tax_no)>COMPANY.TAXNO = '#attributes.tax_no#' AND</cfif>
                    <cfif len(attributes.company_partner_name)>COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '#attributes.company_partner_name#%' AND</cfif>
                    <cfif len(attributes.company_partner_surname)>COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '#attributes.company_partner_surname#%' AND</cfif>
                        COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND 
                        SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND 
                        COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
                        SETUP_CITY.CITY_ID = COMPANY.CITY AND
                        SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY
                        <cfif len(attributes.fullname)>AND ( COMPANY.FULLNAME LIKE '#attributes.fullname#%' OR COMPANY.FULLNAME LIKE '#fullname_1#%' OR COMPANY.FULLNAME LIKE '#fullname_2#%' )</cfif>
                    ORDER BY 
                        COMPANY.FULLNAME
                </cfquery>
                <cfquery name="GET_COMPANY_ACCOUNT" datasource="#dsn#">
                        SELECT
                            BRANCH.BRANCH_NAME,
                            COMPANY_BRANCH_RELATED.COMPANY_ID,
                            COMPANY_BRANCH_RELATED.CARIHESAPKOD,
                            COMPANY_BRANCH_RELATED.IS_SELECT,
                            SETUP_MEMBERSHIP_STAGES.TR_NAME AS TR_NAME
                        FROM
                            BRANCH,
                            COMPANY_BRANCH_RELATED,
                            OUR_COMPANY,
                            SETUP_MEMBERSHIP_STAGES
                        WHERE
                            COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
                            COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
                            SETUP_MEMBERSHIP_STAGES.TR_ID = COMPANY_BRANCH_RELATED.MUSTERIDURUM AND
                            OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
                    UNION ALL
                        SELECT
                            BRANCH.BRANCH_NAME,
                            COMPANY_BRANCH_RELATED.COMPANY_ID,
                            COMPANY_BRANCH_RELATED.CARIHESAPKOD,
                            COMPANY_BRANCH_RELATED.IS_SELECT,
                            '' AS TR_NAME
                        FROM
                            BRANCH,
                            COMPANY_BRANCH_RELATED,
                            OUR_COMPANY
                        WHERE
                            COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NULL AND
                            COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
                            OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
                </cfquery>
                <cfparam name='attributes.totalrecords' default='#get_company.recordcount#'>
                <cfparam name="attributes.page" default='1'>
                <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted) and get_company.recordcount>
                        <cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfquery name="GET_COMP_INFO" dbtype="query">
                                SELECT TR_NAME, BRANCH_NAME, CARIHESAPKOD, IS_SELECT FROM GET_COMPANY_ACCOUNT WHERE COMPANY_ID = #get_company.company_id#
                            </cfquery>
                            <tr>
                                <td><a href="javascript://" onClick="special_record(2,#company_id#);"><img src="/images/branch_plus.gif" border="0" align="absmiddle" title="Şubem İle İlişkilendir"></a></td>
                                <td>#currentrow#</td>
                                <td>#fullname#</td>
                                <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#');" class="tableyazi">#company_partner_name# #company_partner_surname#</a></td>
                                <td title="#ims_code_name#">#ims_code#</td>
                                <td>#taxno#</td>
                                <td>#county_name#</td>
                                <td>#get_company.city_name#</td>
                                <td>#company_telcode# #company_tel1#</td>
                                <td><cfloop query="get_comp_info">#get_comp_info.BRANCH_NAME# <cfif len(get_comp_info.carihesapkod)>/ #get_comp_info.carihesapkod#</cfif><cfif get_comp_info.is_select eq 0> - <cf_get_lang_main no='165.Potansiyel'></cfif><br/></cfloop></td>
                                <td><cfloop query="get_comp_info"><cfif len(get_comp_info.tr_name)>#get_comp_info.tr_name#</cfif><br/></cfloop></td>
                            </tr>
                        </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="30"><cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)><cf_get_lang_main no="72.Kayıt Yok">!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list> 
        <cfset url_str = "">
        <cfif len(attributes.fullname)>
            <cfset url_str = "#url_str#&fullname=#attributes.fullname#">
        </cfif>
        <cfif len(attributes.tax_no)>
            <cfset url_str = "#url_str#&tax_no=#attributes.tax_no#">
        </cfif>
        <cfif len(attributes.company_partner_name)>
            <cfset url_str = "#url_str#&company_partner_name=#attributes.company_partner_name#">
        </cfif>
        <cfif len(attributes.company_partner_surname)>
            <cfset url_str = "#url_str#&company_partner_surname=#attributes.company_partner_surname#">
        </cfif>
        <cfif len(attributes.ims_code_id)>
            <cfset url_str = "#url_str#&ims_code_id=#attributes.ims_code_id#">
        </cfif>
        <cfif len(attributes.ims_code_name)>
            <cfset url_str = "#url_str#&ims_code_name=#attributes.ims_code_name#">
        </cfif>
        <cfif len(attributes.county_id)>
            <cfset url_str = "#url_str#&county_id=#attributes.county_id#">
        </cfif>
        <cfif len(attributes.city)>
            <cfset url_str = "#url_str#&city=#attributes.city#">
        </cfif>
        <cfif len(attributes.is_submitted)>
            <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
        </cfif>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="crm.#fusebox.fuseaction##url_str#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
</cf_box>
<script type="text/javascript">   
    function il_secimi_kontrol()
    {
        if(document.search_company.city.selectedIndex == '')
        {
            alert("<cf_get_lang dictionary_id='33180.İlk Olarak İl Seçiniz'>");
        }
        else
        {
            plate_code_list=new Array('<cfoutput>#valuelist(GET_CITY.PLATE_CODE)#</cfoutput>');
            city_plate_code= plate_code_list[document.search_company.city.selectedIndex-1];
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=search_company.ims_code_name&field_id=search_company.ims_code_id&plate_code='+city_plate_code);
        }
    }
    function controlCompany()
    {
        if((search_company.fullname.value == "") && (search_company.tax_no.value == "") && (search_company.company_partner_name.value == "") && (search_company.company_partner_surname.value == "") && (search_company.ims_code_name.value == "") && (search_company.county_id.value == "") && (search_company.city.value == ""))
        {
            alert("<cf_get_lang dictionary_id='40299.Lütfen Arama Kriterlerinden En Az Birini Giriniz'>");
            return false;
        }
        else
         return true;
    }
    function special_record(id,value)
    {
        if(id ==1)
        {	
            openBoxDraggable("<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_form_add_company_valid");
        }
        else
        {
            openBoxDraggable("<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_add_company_valid&cpid="+value);
        }
    }
</script>
