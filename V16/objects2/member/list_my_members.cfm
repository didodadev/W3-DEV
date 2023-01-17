<!--- üyelerimi veya tüm kurumsal üyeleri getirir is_my_members değiskeni 1 olursa üyeye ait bireysel veya kurumsal üyeleri beraber getirir --->
<cfparam name="attributes.city" default="">
<cfparam name="attributes.sector_cat_id" default="">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.member_id" default="">
<!---<cfparam name="attributes.member_calisan" default=""> --->
<cfparam name="attributes.tc_identity_no" default="">
<cfinclude template="../query/get_company_sector.cfm">
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
        CC.COMPANYCAT_ID = C.COMPANYCAT_ID AND
		CC.IS_VIEW = 1 AND
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
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_company.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset adres = "#attributes.fuseaction#">

<cfform name="seller" action="" method="post">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<div class="form-row">
		<div class="form-group col-md-2 mb-3">
			<input class="form-control" type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="255" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>">
		</div>
		<div class="form-group col-md-2 mb-3">
			<input class="form-control" type="text" name="member_id" id="member_id" value="<cfoutput>#attributes.member_id#</cfoutput>" validate="integer" placeholder="<cf_get_lang dictionary_id='57558.Üye No'>">
		</div>
		<cfif isdefined('attributes.is_my_members_tc') and attributes.is_my_members_tc eq 1>
			<div class="form-group col-md-2 mb-3">
				<input class="form-control" type="text" name="tc_identity_no" id="tc_identity_no" value="<cfoutput>#attributes.tc_identity_no#</cfoutput>" size="11" placeholder="<cf_get_lang dictionary_id='58627.Kimlik No'>">
			</div>
		</cfif>
		<div class="form-group col-md-1 mb-3">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput class="form-control" type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
		</div>
		<cfif isdefined('attributes.is_my_members_city') and attributes.is_my_members_city eq 1>
			<div class="form-group col-md-2 mb-3">
				<select name="city" id="city">
					<option value=""><cf_get_lang dictionary_id='57971.Şehir'></option>
					<cfoutput query="get_city">
						<option value="#city_id#" <cfif attributes.city eq city_id>selected</cfif>>#city_name#</option>
					</cfoutput>
				</select>
			</div>
		</cfif>
		<cfif isdefined('attributes.is_my_members_sector_cat_id') and attributes.is_my_members_sector_cat_id eq 1>
			<div class="form-group col-md-2 mb-3">
				<select name="sector_cat_id" id="sector_cat_id">
					<option value=""><cf_get_lang dictionary_id='35881.Sektör Seçiniz'></option>
					<cfoutput query="get_company_sector">
						<option value="#sector_cat_id#" <cfif sector_cat_id eq attributes.sector_cat_id>selected</cfif>>#sector_cat#</option>
					</cfoutput>
				</select>
			</div>
		</cfif>
		<div class="form-group col-md-2 mb-3">            
			<cfif isDefined('attributes.is_document_icon') and attributes.is_document_icon eq 1>
				<cf_wrk_search_button>
			<cfelse>
				<cf_wrk_search_button  is_excel='0'>
			</cfif>
		</div>
	</div>
</cfform>

<div class="table-responsive-lg">
	<table class="table">
		<thead class="main-bg-color">
			<tr>
				<td>
					<cfif isdefined('attributes.is_my_members') and attributes.is_my_members eq 1><cf_get_lang dictionary_id='34834.Üye Tipi'><cfelse><cf_get_lang dictionary_id='57487.No'></cfif>
				</td>
				<td><cf_get_lang dictionary_id='57558.Üye No'></td>
				<cfif isdefined('attributes.is_my_members_tc') and attributes.is_my_members_tc eq 1><td><cf_get_lang dictionary_id='58627.Kimlik No'></td></cfif>
				<td><cf_get_lang dictionary_id='57658.Üye'></td>
				<td><cf_get_lang dictionary_id='57486.Kategori'></td>
				<cfif isdefined('attributes.is_my_members_city') and attributes.is_my_members_city eq 1><td><cf_get_lang dictionary_id='57971.Şehir'></td></cfif>
				<!-- sil --> <td width="65"><cf_get_lang dictionary_id='58143.İletişim'></td> <!-- sil -->
			</tr>
		</thead>
		<tbody>
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
					<tr>
						<td>
							<cfif isdefined('attributes.is_my_members') and attributes.is_my_members eq 1> 
								<cfif member_type eq 1><cf_get_lang dictionary_id='57585.Kurumsal'><cfelse>><cf_get_lang dictionary_id='57586.Bireysel'></cfif>
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
									<a href="#request.self#?fuseaction=objects2.upd_my_member&company_id=#member_id#" class="tableyazi">#member_name# -</a> 
									<a href="#request.self#?fuseaction=objects2.upd_my_partner&partner_id=#manager_partner_id#&comp_id=#member_id#" class="tableyazi">
									<cfif len(partner_name_list)>#get_partner.company_partner_name[listfind(partner_name_list,manager_partner_id,',')]#</cfif>
									<cfif len(partner_name_list)>#get_partner.company_partner_surname[listfind(partner_name_list,manager_partner_id,',')]#</cfif>
									</a>
								<cfelse>
									<a href="#request.self#?fuseaction=objects2.view_member&company_id=#member_id#" class="tableyazi">#member_name#</a>
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
				<tr>
					<td colspan="7"><cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</table>
</div>
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
      		<td style="text-align:right;"><cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#get_company.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td>
    	</tr>
	</table>
</cfif>
