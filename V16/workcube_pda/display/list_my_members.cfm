<!--- üyelerimi veya tüm kurumsal üyeleri getirir is_my_members değiskeni 1 olursa üyeye ait bireysel veya kurumsal üyeleri beraber getirir --->
<cfparam name="attributes.city" default="">
<cfparam name="attributes.sector_cat_id" default="">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.member_id" default="">
<!---<cfparam name="attributes.member_calisan" default=""> --->
<cfparam name="attributes.tc_identity_no" default="">
<cfinclude template="../query/get_company_sector.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		1 AS MEMBER_TYPE,
		'' AS MEMBER_CALISAN,
		C.COMPANY_ID AS MEMBER_ID,
		C.MANAGER_PARTNER_ID,
		C.FULLNAME AS MEMBER_NAME,
        '' AS TC_IDENTITY_NO,
		C.COMPANY_EMAIL AS EMAIL,
		C.COMPANY_TELCODE AS TELCOD,
		C.COMPANY_TEL1 AS TEL1,
		C.COMPANY_FAX AS FAX,
		C.COUNTY,
		C.CITY,
		CC.COMPANYCAT AS MEMBER_CAT
	FROM
		COMPANY C,
		COMPANY_CAT CC
	WHERE
    	C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
		<cfif isdefined('attributes.is_my_members') and attributes.is_my_members eq 1>
			(
            	C.HIERARCHY_ID = <cfif isdefined("session.ww.our_company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"></cfif> 
				<cfif isdefined('session.pp.userid') >
					OR C.COMPANY_ID IN (SELECT WEP.COMPANY_ID FROM WORKGROUP_EMP_PAR WEP WHERE WEP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">)
				</cfif>
			) 
            AND
		</cfif>
		<cfif isdefined('session.pp.userid') >
			C.COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
		</cfif>
        C.COMPANY_ID IS NOT NULL AND
        <cfif isDefined('attributes.membercat_id') and len(attributes.membercat_id)>
        	C.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.membercat_id#"> AND
		</cfif>
		<!---CC.IS_VIEW = 1 AND--->
		C.COMPANY_STATUS = 1
		<cfif len(attributes.keyword)>
			AND 
				(
					FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					COMPANYCAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					C.COMPANY_ID IN
					(
						SELECT 
							CP.COMPANY_ID 
						FROM 
							COMPANY_PARTNER CP 
						WHERE 
							CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					)
				)
		</cfif>
        <cfif len(attributes.member_id)>
			AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		</cfif>
        <cfif len(attributes.tc_identity_no)>
			AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE TC_IDENTITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.tc_identity_no#%">)
		</cfif>
        <cfif len(attributes.city)>
			AND C.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
        </cfif>
        <cfif len(attributes.sector_cat_id)>
			AND C.SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">
        </cfif>
		<cfif isdefined("attributes.is_my_members_period") and attributes.is_my_members_period eq 1>
        AND C.COMPANY_ID IN 
			(
			SELECT 
				CP.COMPANY_ID
			FROM
				COMPANY_PERIOD CP
			WHERE
				CP.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">)
				AND
				C.COMPANY_ID = CP.COMPANY_ID
			)
        </cfif>
	   <cfif isdefined('attributes.is_my_members') and attributes.is_my_members eq 1>
			UNION ALL
			SELECT 
				2 AS MEMBER_TYPE,
				C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME AS MEMBER_CALISAN,
				C.CONSUMER_ID AS MEMBER_ID,
				'' AS MANAGER_PARTNER_ID,
				C.COMPANY AS MEMBER_NAME,
				C.TC_IDENTY_NO AS TC_IDENTITY_NO,
				C.CONSUMER_EMAIL AS EMAIL,
				C.CONSUMER_WORKTELCODE AS TELCOD,
				C.CONSUMER_WORKTEL AS TEL1,
				C.CONSUMER_FAX AS FAX,
				C.WORK_COUNTY_ID AS COUNTY,
				C.WORK_CITY_ID AS CITY,
				CC.CONSCAT AS MEMBER_CAT
			FROM
				CONSUMER C,
				CONSUMER_CAT CC
			WHERE
				C.HIERARCHY_ID = <cfif isdefined("session.ww.our_company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"></cfif> AND
				CC.CONSCAT_ID = C.CONSUMER_CAT_ID AND
				CC.IS_INTERNET = 1 AND
				<cfif len(attributes.member_id)>
					C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"> AND
				</cfif>
				<cfif len(attributes.tc_identity_no)>
					C.TC_IDENTY_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.tc_identity_no#%"> AND 
				</cfif>
				<cfif len(attributes.city)>
					C.WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#"> AND
				</cfif>
				<cfif len(attributes.sector_cat_id)>
					C.SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#"> AND
				</cfif>
				C.CONSUMER_STATUS = 1 AND
				(
					CONSUMER_NAME + ' ' + CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					COMPANY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					CONSCAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				) 
		 </cfif> 
    ORDER BY 
    	MEMBER_ID
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pda.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_company.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset adres = "#attributes.fuseaction#">
<cfif fusebox.fuseaction is 'user_friendly'>
	<cfset adres = adres & "&user_friendly_url=#attributes.user_friendly_url#">
</cfif>
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%">
    <tr style="height:35px;">
        <td class="headbold">Üyeler</td>
    </tr>
</table>
<cfform name="seller" action="#request.self#?fuseaction=#adres#" method="post">
 <table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<tr>
		<!-- sil -->
        <td class="color-row">
            <table align="right">
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'> : </td>
                    <td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="255" style="width:100px;"></td>
                    <td><cf_get_lang_main no='146.Üye No'> : </td>
                    <td><cfinput type="text" name="member_id" id="member_id" value="#attributes.member_id#" validate="integer" style="width:80px;"></td>
                    <td><cfif isdefined('attributes.is_my_members_tc') and attributes.is_my_members_tc eq 1><cf_get_lang_main no='1215.Kimlik No'> : </td>
                    <td><cfinput type="text" name="tc_identity_no" id="tc_identity_no" value="#attributes.tc_identity_no#" size="11" style="width:100px;"></td></cfif>
         <!---           <td><cf_get_lang_main no='1050.İsim Soyisim'> :	</td>
                    <td><cfinput type="text" name="member_calisan" value="#attributes.member_calisan#" style="width:100px;"></td>   --->
                    <td>
                        <select name="membercat_id" id="membercat_id" style="width:132px;">
                            <option value="">Kategori</option>
                            <cfoutput query="get_companycat">
                                <option value="#companycat_id#" <cfif isDefined('attributes.membercat_id') and attributes.membercat_id eq companycat_id>selected</cfif>>#companycat#</option>
                            </cfoutput>
                        </select>                    
                    </td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <td><cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
                    <td><cf_wrk_search_button is_excel='0'></td>
                </tr> 
            </table>
        </td>
    </tr>
	<!---<tr>
        <td colspan="2" align="right" style="text-align:right;">
			<table>
				<tr>
				   	<cfif isdefined('attributes.is_my_members_city') and attributes.is_my_members_city eq 1>
						<td>
							<select name="city" id="city" style="width:132px;">
								<option value=""><cf_get_lang_main no='559.Şehir'></option>
								<cfoutput query="get_city">
									<option value="#city_id#" <cfif attributes.city eq city_id>selected</cfif>>#city_name#</option>
								</cfoutput>
							</select>
						</td>
					 </cfif>
					 <cfif isdefined('attributes.is_my_members_sector_cat_id') and attributes.is_my_members_sector_cat_id eq 1>
						 <td>
							<select name="sector_cat_id" id="sector_cat_id" style="width:150px;">
								<option value=""><cf_get_lang no='1560.Sektör Seçiniz'></option>
								<cfoutput query="get_company_sector">
									<option value="#sector_cat_id#" <cfif sector_cat_id eq attributes.sector_cat_id>selected</cfif>>#sector_cat#</option>
								</cfoutput>
							</select>
						</td>
					</cfif>
				</tr>
			</table>
		</td>
		<!-- sil -->
    </tr> --->
</table>
</cfform>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">
	<tr class="color-header" style="height:22px;">
		<td class="form-title">
			<cfif isdefined('attributes.is_my_members') and attributes.is_my_members eq 1><cf_get_lang no='513.Üye Tipi'><cfelse><cf_get_lang_main no='75.No'></cfif>
		</td>
		<td class="form-title"><cf_get_lang_main no='146.Üye No'></td>
		<cfif isdefined('attributes.is_my_members_tc') and attributes.is_my_members_tc eq 1><td class="form-title"><cf_get_lang_main no='1215.Kimlik No'></td></cfif>
		<td class="form-title"><cf_get_lang_main no='246.Üye'></td>
		<td class="form-title"><cf_get_lang_main no='74.Kategori'></td>
		<cfif isdefined('attributes.is_my_members_city') and attributes.is_my_members_city eq 1><td class="form-title"><cf_get_lang_main no='559.Şehir'></td></cfif>
		<!-- sil --> <td class="form-title" width="65"><cf_get_lang_main no='731.İletişim'></td> <!-- sil -->
	</tr>
    <cfif get_company.recordcount>
		<cfset city_list = ''>
		<cfset county_list = ''>
		<cfset partner_name_list = ''>
		<cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(city) and not listfind(city_list,city)>
				<cfset city_list = listappend(city_list,city)>
			</cfif>
			<cfif len(county) and not listfind(county_list,county)>
				<cfset county_list = listappend(county_list,county)>
			</cfif>
			<cfif len(manager_partner_id) and not listfind(partner_name_list,manager_partner_id)>
				<cfset partner_name_list = listappend(partner_name_list,manager_partner_id)>
			</cfif>
		</cfoutput>
		<cfif len(city_list)>
			<cfquery name="GET_COMPANY_CITY" datasource="#DSN#">
				SELECT
					CITY_ID,
					CITY_NAME
				FROM
					SETUP_CITY
				WHERE
					CITY_ID IN (#city_list#)
				ORDER BY
					CITY_ID
			</cfquery>
			<cfset city_list=listsort(valuelist(get_company_city.city_id,','),"numeric","ASC",",")>
		</cfif>
		<cfif len(county_list)>
			<cfquery name="GET_COMPANY_COUNTY" datasource="#DSN#">
				SELECT
					COUNTY_ID,
					COUNTY_NAME
				FROM
					SETUP_COUNTY
				WHERE
					COUNTY_ID IN (#county_list#)
				ORDER BY
					COUNTY_ID
			</cfquery>
			<cfset county_list=listsort(valuelist(get_company_county.county_id,','),"numeric","ASC",",")>
		</cfif>
		<cfif len(partner_name_list)>
			<cfquery name="GET_PARTNER" datasource="#DSN#">
				SELECT 
					PARTNER_ID,
					COMPANY_PARTNER_NAME,
					COMPANY_PARTNER_SURNAME,
					TC_IDENTITY
				FROM  
					COMPANY_PARTNER
				WHERE 
					PARTNER_ID IN (#partner_name_list#)  
				ORDER BY 
					PARTNER_ID
			</cfquery>
			<cfset partner_name_list=listsort(valuelist(get_partner.partner_id,','),"numeric","ASC",",")>
		</cfif>
		  
		<cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr style="height:20px;" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>
					<cfif isdefined('attributes.is_my_members') and attributes.is_my_members eq 1> 
						<cfif member_type eq 1><cf_get_lang_main no='173.Kurumsal'><cfelse>><cf_get_lang_main no='174.Bireysel'></cfif>
					<cfelse>
						#currentrow#
					</cfif>
				</td>
				<td>#member_id#</td>
				<cfif isdefined('attributes.is_my_members_tc') and attributes.is_my_members_tc eq 1>
					<td>
						<cfif len(tc_identity_no)>
							#tc_identity_no#
						<cfelse>
							<cfif len(partner_name_list)>#get_partner.tc_identity[listfind(partner_name_list,manager_partner_id,',')]#</cfif>
						</cfif>
					</td>
				</cfif>
				<td>
					<cfif member_type eq 1>
						<cfif isdefined('attributes.is_my_members') and attributes.is_my_members eq 1>
							<!---<a href="#request.self#?fuseaction=objects2.upd_my_member&company_id=#member_id#" class="tableyazi">--->#member_name# -<!---</a>---> 
							<!---<a href="#request.self#?fuseaction=objects2.upd_my_partner&partner_id=#manager_partner_id#&comp_id=#member_id#" class="tableyazi">--->
							<cfif len(partner_name_list)>#get_partner.company_partner_name[listfind(partner_name_list,manager_partner_id,',')]#</cfif>
							<cfif len(partner_name_list)>#get_partner.company_partner_surname[listfind(partner_name_list,manager_partner_id,',')]#</cfif>
							<!---</a>--->
						<cfelse>
							<!---<a href="#request.self#?fuseaction=objects2.view_member&company_id=#member_id#" class="tableyazi">--->#member_name# -<!---</a>--->
							<cfif len(partner_name_list)>#get_partner.company_partner_name[listfind(partner_name_list,manager_partner_id,',')]#</cfif>
							<cfif len(partner_name_list)>#get_partner.company_partner_surname[listfind(partner_name_list,manager_partner_id,',')]#</cfif>
						</cfif>
					<cfelse>
						#member_name#
						<a href="#request.self#?fuseaction=objects2.upd_my_consumer&consumer_id=#get_company.member_id#" class="tableyazi">
							#member_calisan#
						</a>
					</cfif>
				</td>
				<td>#member_cat#</td>
				<cfif isdefined('attributes.is_my_members_city') and attributes.is_my_members_city eq 1><td><cfif len(city_list)>#get_company_city.city_name[listfind(city_list,city,',')]#</cfif>/<cfif len(county_list)>#get_company_county.county_name[listfind(county_list,county,',')]#</cfif></td></cfif>
				<!-- sil -->     
				<td>
					<img src="/images/tel.gif" title="#telcod# #tel1#">
					<img src="/images/fax.gif" title="#telcod# #fax#">
					<img src="/images/mail.gif" title="#email#">
				</td>
				<!-- sil -->
			</tr>
		</cfoutput>
    <cfelse>
        <tr class="color-row" style="height:20px;">
            <td colspan="7"><cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no="289.Filtre Ediniz"> !</cfif></td>
        </tr>
    </cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "#adres#">
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
   <!--- <cfif isdefined("attributes.member_calisan") and len(attributes.member_calisan)>
		<cfset url_str = "#url_str#&member_calisan=#attributes.member_calisan#">
	</cfif> --->
    <cfif isDefined("attributes.city") and len(attributes.city)>
		<cfset url_str = "#url_str#&city=#attributes.city#">
	</cfif>
    <cfif isDefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>
		<cfset url_str = "#url_str#&sector_cat_id=#attributes.sector_cat_id#">
	</cfif>
    <table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%; height:35px;">
    	<tr>
    		<td>
        		<cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#url_str#&form_submitted=1">
      		<td align="right" style="text-align:right;"><cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#get_company.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td>
    	</tr>
	</table>
</cfif>
