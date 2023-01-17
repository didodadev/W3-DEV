<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfquery name="GET_COMPANY2" datasource="#DSN#">
		SELECT 
			C.COMPANY_ID,
			C.PARTNER_ID,
			C.FULLNAME,
			C.COMPANY_EMAIL,
			C.COMPANY_TELCODE,
			C.COMPANY_TEL1,
			C.COMPANY_TEL2,
			C.COMPANY_FAX,
			C.COMPANY_ADDRESS,
			C.COUNTY,
			C.COUNTRY,
			C.CITY,
			C.ASSET_FILE_NAME1,
			C.ASSET_FILE_NAME1_SERVER_ID,
			C.ASSET_FILE_NAME2,
			C.ASSET_FILE_NAME2_SERVER_ID
		FROM
			COMPANY C,
			COMPANY_CAT CC,
			COMPANY_CAT_OUR_COMPANY CO,
			COMPANY_PERIOD CP
		WHERE
			CC.COMPANYCAT_ID = C.COMPANYCAT_ID AND
			CC.COMPANYCAT_ID = CO.COMPANYCAT_ID AND
			CP.COMPANY_ID = C.COMPANY_ID AND 
			<cfif isdefined("session.pp.userid")>
				CP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
				CO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
			<cfelse>
				CP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"> AND
				CO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
			</cfif>
			CC.IS_VIEW = 1 AND
			C.COMPANY_STATUS = 1
		  <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND (
				C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				C.COMPANY_ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
		  </cfif>
		  <cfif isdefined("attributes.category") and len(attributes.category)>
			AND CC.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.category#">
		  </cfif>
		  <cfif isdefined("attributes.county_id") and len(attributes.county_id)>
			AND C.COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
		  </cfif>
		  <cfif isdefined("attributes.city_id") and len(attributes.city_id)>
			AND C.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
		  </cfif>
	</cfquery>
<cfelse>
	<cfset get_company2.recordcount = 0>
</cfif>

<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_company2.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY ORDER BY CITY_ID
</cfquery>
<cfquery name="GET_COUNTY" datasource="#DSN#">
	SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY ORDER BY COUNTY_ID
</cfquery>
<cfquery name="COMPANYCATS" datasource="#DSN#">
	SELECT
		CC.COMPANYCAT_ID 
	FROM 
		COMPANY_CAT CC,
		COMPANY_CAT_OUR_COMPANY CO,
        CATEGORY_SITE_DOMAIN CSD
	WHERE 
		CC.COMPANYCAT_ID = CO.COMPANYCAT_ID AND
		CC.IS_VIEW = 1 AND
        CC.COMPANYCAT_ID = CSD.CATEGORY_ID AND
		CSD.MENU_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.menu_id#"> AND
		CSD.MEMBER_TYPE = 'COMPANY' AND
		CO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">
	ORDER BY 
		CC.COMPANYCAT
</cfquery>

<cfform name="seller" action="" method="post">
    <input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <div class="form-row">
		<div class="form-group col-md-2 mb-3">
            <input class="form-control" type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>">
        </div>
        <div class="form-group col-md-2 mb-3">
            <select class="form-control" name="category" id="category">
                <cfoutput query="companycats">
                    <option value="#companycat_id#" <cfif isdefined("attributes.category") and attributes.category eq companycat_id>selected</cfif>>#companycat#</option>
                </cfoutput>
            </select>
        </div>
        <div class="form-group mb-3 col-md-2">
            <select class="form-control" name="city_id" id="city_id" onChange="LoadCounty(this.value,'county_id')">
                <option value=""><cf_get_lang dictionary_id ='34345.İller'></option>
                <cfoutput query="get_city">
                    <option value="#city_id#" <cfif isdefined("attributes.city_id") and attributes.city_id eq city_id>selected</cfif>>#city_name#</option> 
                </cfoutput>
            </select>
        </div>
        <div class="form-group mb-3 col-md-2">
            <select class="form-control" name="county_id" id="county_id">
                <option value=""><cf_get_lang dictionary_id='58638.İlçe'></option>
                <cfif isdefined('attributes.city_id') and len(attributes.city_id)>
                    <cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
                        SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
                    </cfquery>
                    <cfoutput query="get_county_name">
                        <option value="#county_id#" <cfif isdefined("attributes.county_id") and attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
                    </cfoutput>
                </cfif>
            </select>
        </div>
        <div class="form-group col-md-1 mb-3">
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
            <cfinput class="form-control" type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
        </div>
        <div class="form-group col-md-2 mb-3">
            <cf_wrk_search_button>
        </div>
    </div>
</cfform>

<div class="table-responsive-lg">
	<table class="table">
        <thead class="main-bg-color">
			<tr>
                <td><cf_get_lang dictionary_id="58485.Şirket Adı"></td>
                <td><cf_get_lang dictionary_id='57578.Yetkili'></td>
                <td><cf_get_lang dictionary_id="57019.Şirket Logosu"></td>
                <td><cf_get_lang dictionary_id='58723.Adres'></td>
                <td><cf_get_lang dictionary_id='57971.Şehir'></td>
                <td><cf_get_lang dictionary_id='58638.İlçe'></td>
                <td><cf_get_lang dictionary_id='57499.Telefon'></td>
                <td><cf_get_lang dictionary_id='57488.Fax'></td>
                <td><cf_get_lang dictionary_id='57428.E-Mail'></td>
                <td><cf_get_lang dictionary_id='34357.Harita'>- <cf_get_lang dictionary_id='34358.Kroki'></td>
            </tr>
        </thead>
        <tbody>
            <cfif get_company2.recordcount>
                <cfset city_id_list=''>
                <cfoutput query="get_company2" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(city) and not listfind(city_id_list,city)>
                        <cfset city_id_list = Listappend(city_id_list,city)>
                    </cfif>
                </cfoutput>
                <cfif len(city_id_list)>
                    <cfset city_id_list = listsort(city_id_list,"numeric","ASC",",")>
                    <cfquery name="GET_CITY_" datasource="#DSN#">
                        SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_id_list#) ORDER BY CITY_ID
                    </cfquery>
                </cfif>
                <cfoutput query="get_company2" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#fullname#</td>
                        <td>
                            <cfquery name="GET_PARTNER" datasource="#DSN#">
                                SELECT 
                                    * 
                                FROM  
                                    COMPANY_PARTNER CP, 
                                    COMPANY C 
                                WHERE 
                                    <cfif len(get_company2.company_id)>
                                        CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company2.company_id#"> AND 
                                        CP.COMPANY_ID = C.COMPANY_ID AND
                                        CP.PARTNER_ID = C.MANAGER_PARTNER_ID
                                    <cfelse>
                                        CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company2.partner_id#"> AND
                                        CP.COMPANY_ID = C.COMPANY_ID
                                    </cfif>
                                ORDER BY 
                                    CP.COMPANY_PARTNER_NAME
                            </cfquery>
                            #get_partner.company_partner_name# #get_partner.company_partner_surname#
                        </td>
                        <cfif isdefined('attributes.is_partner_image') and attributes.is_partner_image eq 1>
                            <td>
                                <cfif len(get_company2.ASSET_FILE_NAME1)>
                                    <cf_get_server_file output_file="member/#ASSET_FILE_NAME1#" output_server="#ASSET_FILE_NAME1_SERVER_ID#" output_type="0" image_width="150" image_height="100" image_link="1" alt="#getLang('main',668)#" title="#getLang('main',668)#">
                                </cfif>
                            </td>
                        <cfelse>
                            <td></td>
                        </cfif>
                        <td>#company_address#</td>
                        <td><cfif len(city)>#get_city_.city_name[listfind(city_id_list,city,',')]#</cfif></td>
                        <td><cfif len(county)>#get_county.county_name[county]#</cfif></td>
                        <td>#company_telcode# #company_tel1#</td>
                        <td>#company_telcode# #company_fax#</td>
                        <td>#company_email#</td>
                        <td>
                            <cfif len(get_company2.asset_file_name2)>
                                <cf_get_server_file output_file="member/#asset_file_name2#" output_server="#asset_file_name2_server_id#" output_type="2" small_image="/images/branch_black.gif" image_link="1" alt="#getLang('main',668)#" title="#getLang('main',668)#">
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="10"><cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>  !</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </table>
</div>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.category") and len(attributes.category)>
	<cfset url_str = "#url_str#&category=#attributes.category#">
</cfif>
<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
	<cfset url_str = "#url_str#&city_id=#attributes.city_id#">
</cfif>

<cfif attributes.totalrecords gt attributes.maxrows>
  	<table cellpadding="0" cellspacing="0" align="center" style="width:98%; height:35px;">
    	<tr>
      		<td>
                <cf_pages page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="objects2.list_partner&form_submitted=1&#url_str#">
      		<td style="text-align:right;"><cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#get_company2.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td>
    	</tr>
  	</table>
</cfif>