<!--- 
	Bu sayfanın aynısı Member modulu altında bulunmaktadır. 
	Burada yapılan degisiklikler oraya da yansıtılmalıdır.
	Not: Sirket bilgisinde link olmaması attributes.is_not_link parametresinin tanımlı olması yada member de yetkisine baglıdır. 
	BK 051026
 --->
<cfscript>
	attributes.fullname = trim(attributes.fullname);
	attributes.nickname = trim(attributes.nickname);
	if(not (isdefined('attributes.invoice_retail') or isdefined('attributes.is_from_sale')))
	{
		attributes.name = trim(attributes.name);
		attributes.surname = trim(attributes.surname);
		attributes.tel_code = trim(attributes.tel_code);
		attributes.telefon = trim(attributes.telefon);
	}
</cfscript>
<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		COMPANYCAT		
</cfquery>
<cfset company_cat_list = valuelist(get_companycat.companycat_id,',')>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 
		COMPANY.COMPANY_ID,
		COMPANY.MEMBER_CODE,
		COMPANY.FULLNAME,
		COMPANY.NICKNAME,
		COMPANY.TAXOFFICE,
		COMPANY.TAXNO,
		COMPANY.IMS_CODE_ID,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1,
		COMPANY.ISPOTANTIAL,
		COMPANY.COMPANY_STATE,
		COMPANY_CAT.COMPANYCAT_TYPE,
		COMPANY_CAT.COMPANYCAT,
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY.COMPANY_FAX,						
		COMPANY.COMPANY_ADDRESS,
		COMPANY.CITY,
		COMPANY.COUNTY,
		COMPANY.COUNTRY,
		COMPANY.COMPANY_EMAIL,
		COMPANY.MEMBER_CODE,
		COMPANY.OZEL_KOD,
		COMPANY.MOBIL_CODE,
		COMPANY.MOBILTEL,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.MANAGER_PARTNER_ID        
	<cfif isdefined("attributes.is_store_module")><!--- Subeden geliyorsa sube bireysel uye iliskisi var mi ? --->
		,ISNULL((SELECT BRANCH_ID FROM COMPANY_BRANCH_RELATED WHERE COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND COMPANY_BRANCH_RELATED.BRANCH_ID=#listgetat(session.ep.user_location,2,'-')#),0) AS IS_RELATED
	</cfif>
	FROM 
		COMPANY,
		COMPANY_PARTNER,
		COMPANY_CAT
	WHERE 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
		(
			COMPANY.COMPANY_ID IS NULL
			<cfif len(attributes.fullname)>OR COMPANY.FULLNAME LIKE '%#URLDecode(attributes.fullname)#%'</cfif>
			<!--- BK ekledi 20050520 Hedef de tedarikci eklemede calısan kosuluna girmemeli --->
			<cfif not isdefined("attributes.type")>
				<cfif len(attributes.name) or len(attributes.surname)>
					<cfif database_type is "MSSQL">
						OR COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' '+ COMPANY_PARTNER.COMPANY_PARTNER_SURNAME = '#URLDecode(attributes.name)# #URLDecode(attributes.surname)#'
					<cfelseif database_type is "DB2">
						OR COMPANY_PARTNER.COMPANY_PARTNER_NAME ||' '|| COMPANY_PARTNER.COMPANY_PARTNER_SURNAME = '#URLDecode(attributes.name)# #URLDecode(attributes.surname)#'
					</cfif>
				</cfif>
			</cfif>
			<cfif len(attributes.nickname)>OR COMPANY.NICKNAME = '#URLDecode(attributes.nickname)#'</cfif>
			<cfif len(attributes.telefon)>OR COMPANY.COMPANY_TEL1 = '#attributes.telefon#'</cfif>
            <cfif len(attributes.tax_num)>OR COMPANY.TAXNO = '#attributes.tax_num#'</cfif>
		)
		<cfif fusebox.use_period>
			AND COMPANY.COMPANY_ID IN (
									SELECT
										CPE.COMPANY_ID
									FROM
										COMPANY_PERIOD CPE
									WHERE
										COMPANY.COMPANY_ID = CPE.COMPANY_ID AND
										CPE.PERIOD_ID = #session.ep.period_id#
								)
		</cfif>
		<cfif len(company_cat_list)>
			AND COMPANY.COMPANYCAT_ID IN (#company_cat_list#)
		</cfif>
	ORDER BY
		COMPANY.FULLNAME
</cfquery>
<cfif isdefined("attributes.is_store_module") and get_company.recordcount>
	<cfquery name="GET_BRANCH_ALL" datasource="#DSN#">
		SELECT 
			COMPANY_BRANCH_RELATED.COMPANY_ID,
			BRANCH.BRANCH_NAME
		FROM
			COMPANY_BRANCH_RELATED,
			BRANCH
		WHERE
			COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
			COMPANY_BRANCH_RELATED.COMPANY_ID IN(#valuelist(get_company.company_id)#)
	</cfquery>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33649.Benzer Kriterlerde Kayitlar Bulundu'></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cf_grid_list>
    <thead>	
        <tr>
            <th width="25"><cf_get_lang dictionary_id='57487.No'></th>
			<th width="25"><cf_get_lang dictionary_id='57558.Uye No'></th>
            <th nowrap width="120"><cf_get_lang dictionary_id='57750.İşyeri Adı'></th>
            <th nowrap><cf_get_lang dictionary_id='57751.Kısa Ad'></th>
            <th nowrap><cf_get_lang dictionary_id='57486.Kategori'></th>
            <th nowrap><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th nowrap width="120"><cf_get_lang dictionary_id='58723.Adres'></th>
			<th><cf_get_lang dictionary_id='60078.Alias'></th>
            <th width="80"><cf_get_lang dictionary_id='57752.Vergi No'></th>
            <th nowrap width="80"><cf_get_lang dictionary_id='57499.Telefon'></th>
            <th nowrap width="80"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></th>
            <cfif isdefined("attributes.is_store_module")>
                <th><cf_get_lang dictionary_id ='33650.İlişkili Şubeleri'></th>
                <th></th>
            </cfif>			
        </tr>
    </thead>
    <cfset currentroww=0>
	<form name="search_" id="search_" method="post" action="">
	<cfif get_company.recordcount>
		<cfset county_id_list=''>
		<cfoutput query="get_company">
			<cfif len(county) and not listfind(county_id_list,county)>
				<cfset county_id_list=listappend(county_id_list,county)>
			</cfif>
		</cfoutput>
		<cfif len(county_id_list)>
			<cfset county_id_list=listsort(county_id_list,"numeric","ASC",",")>
			<cfquery name="get_county_detail" datasource="#dsn#">
				SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#) ORDER BY COUNTY_ID
			</cfquery>
		</cfif>
        <tbody>
		<cfoutput query="get_company">
		<tr><cfset currentroww+=1>
			<td>#currentroww#</td>
			<td>#member_code#</td>
			<td nowrap>
				<cfif isdefined("get_company.manager_partner_id") and len(get_company.manager_partner_id)>
					<cfquery name="get_partner_" datasource="#DSN#">
						SELECT 
							CP.PARTNER_ID,
							CP.COMPANY_PARTNER_NAME,
							CP.COMPANY_PARTNER_SURNAME,
							CP.TC_IDENTITY
						FROM
							COMPANY_PARTNER CP, 
							COMPANY C
						WHERE 
							CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.company_id#"> AND 
							CP.COMPANY_ID = C.COMPANY_ID AND
							COMPANY_PARTNER_STATUS = 1
						ORDER BY 
							CP.COMPANY_PARTNER_NAME
					</cfquery>
					<cfquery name="get_tc" dbtype="query">
						SELECT TC_IDENTITY
						FROM GET_PARTNER_
						WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.manager_partner_id#">
					</cfquery>
				</cfif>
				<cfif isdefined('get_tc.TC_IDENTITY') and len(get_tc.TC_IDENTITY)>
					<cfset tc_num = get_tc.TC_IDENTITY>
				<cfelse>
					<cfset tc_num = ''>
				</cfif>
				<cfif len(ims_code_id)>
					<cfquery name="get_ims_name" datasource="#dsn#">
						SELECT IMS_CODE_NAME,IMS_CODE FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #ims_code_id#
					</cfquery>
				</cfif>
				<cfset adres_ = Replace(Replace(company_address,Chr(10),"","all"),Chr(13),"","all")><!--- Satir kirma sorun oldugundan kaldirmak icin eklendi degistirmeyin FBS --->
				<cfif isdefined('attributes.type_assetp') and attributes.type_assetp eq 1>
                	<a href="javascript://" onclick="control(3,#company_id#,#partner_id#);" class="tableyazi"><cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif></a>
				<cfelseif get_module_user(4) and not isdefined("attributes.is_not_link") and not (isdefined("attributes.invoice_retail") or isdefined("attributes.is_from_sale"))>
					<a href="javascript://" onclick="control(1,#company_id#,'');" class="tableyazi"><cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif></a>
				<cfelseif isdefined("attributes.invoice_retail") or isdefined("attributes.is_from_sale")><!--- Perakende faturasindan acilmissa --->
					<cfif isdefined("attributes.is_store_module") and is_related eq 1><!--- Subeden gelmis ve sube consumer iliskisi mevcutsa --->
						<a href="javascript://" onclick="send_comp_info('#company_id#','#partner_id#','#fullname#','#tc_num#','#company_partner_name#','#company_partner_surname#','#member_code#','#ozel_kod#','#trim(adres_)#','#city#', '<cfif len(county)>#get_county_detail.county_name[listfind(county_id_list,county,',')]#</cfif>','#county#','#company_telcode#','#company_tel1#','#company_telcode#','#company_fax#','#taxoffice#','#taxno#','#company_email#','#mobil_code#','#mobiltel#','#COUNTRY#',''<cfif len(ims_code_id)>,'#ims_code_id#','#get_ims_name.ims_code# #get_ims_name.ims_code_name#'</cfif>);" class="tableyazi">#fullname#</a>
					<cfelseif isdefined("attributes.is_store_module") and is_related eq 0><!--- Subeden gelmis ve sube consumer iliskisi yoksa --->
						<cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif>
					<cfelse>
						<a href="javascript://" onclick="send_comp_info('#company_id#','#partner_id#','#fullname#','#tc_num#','#company_partner_name#','#company_partner_surname#','#member_code#','#ozel_kod#','#trim(adres_)#','#city#', '<cfif len(county)>#get_county_detail.county_name[listfind(county_id_list,county,',')]#</cfif>','#county#','#company_telcode#','#company_tel1#','#company_telcode#','#company_fax#','#taxoffice#','#taxno#','#company_email#','#mobil_code#','#mobiltel#','#COUNTRY#',''<cfif len(ims_code_id)>,'#ims_code_id#','#get_ims_name.ims_code# #get_ims_name.ims_code_name#'</cfif>);" class="tableyazi">#fullname#</a>
					</cfif>
				<cfelse>
					<cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif>
				</cfif>
			</td>
			<td><cfif attributes.nickname eq trim(nickname)><font color="##990000">#nickname#</font><cfelse>#nickname#</cfif></td>
			<td nowrap>#companycat#</td>
			<td nowrap>
				<cfif attributes.name eq trim(company_partner_name)><font color="##990000">#company_partner_name#</font><cfelse>#company_partner_name#</cfif>
				<cfif attributes.surname eq trim(company_partner_surname)><font color="##990000">#company_partner_surname#</font><cfelse>#company_partner_surname#</cfif>
			</td>
			<td>#adres_#</td>
			<td></td>
			<td>#taxno#</td>
			<td nowrap><cfif attributes.telefon eq trim(company_tel1)><font color="##990000">#company_telcode# #company_tel1#</font><cfelse>#company_telcode# #company_tel1#</cfif></td>
			<td><cfif len(ims_code_id) and isdefined('get_ims_name.ims_code_name') and len(get_ims_name.ims_code_name)>#get_ims_name.ims_code_name#</cfif>
			</td>
			<cfif isdefined("attributes.is_store_module")>
				<cfquery name="GET_BRANCH" dbtype="query">
					SELECT BRANCH_NAME FROM GET_BRANCH_ALL WHERE COMPANY_ID = #get_company.company_id#
				</cfquery>
				<td><cfloop query="GET_BRANCH">#branch_name#,<br/></cfloop></td>
				<td align="center"><cfif is_related eq 0><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=member.emptypopup_add_member_branch&cpid=#company_id#','list');"><cf_get_lang dictionary_id ='34108.Şube İle İlişkilendir'></a></cfif></td>
			</cfif>
		</tr>
<!--- alias için --->
		<cfquery name="GET_COMPANY_" datasource="#DSN#">
		SELECT
			C.COMPANY_ID,
			C.MEMBER_CODE,
			C.FULLNAME,
			C.NICKNAME,
			C.TAXOFFICE,
			C.TAXNO,
			C.IMS_CODE_ID,
			C.COMPANY_TELCODE,
			C.COMPANY_TEL1,
			C.ISPOTANTIAL,
			C.COMPANY_STATE,
			CC.COMPANYCAT_TYPE,
			CC.COMPANYCAT,
			CP.PARTNER_ID,
			C.COMPANY_FAX,						
			C.COMPANY_ADDRESS,
			C.CITY,
			C.COUNTY,
			C.COUNTRY,
			C.COMPANY_EMAIL,
			C.MEMBER_CODE,
			C.OZEL_KOD,
			C.MOBIL_CODE,
			C.MOBILTEL,
			CP.COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME,
			C.MANAGER_PARTNER_ID,
			CB.* 
			FROM
				COMPANY C,
				COMPANY_CAT CC,
				COMPANY_PARTNER CP,
				COMPANY_BRANCH CB
			WHERE 
				C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
				CB.COMPANY_ID = C.COMPANY_ID AND
				CP.PARTNER_ID = c.MANAGER_PARTNER_ID AND
				C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
		</cfquery>	
		<cfif GET_COMPANY_.recordcount>
				<cfset county_id_list=''>
				<cfloop query="get_company_">
					<cfif len(county_id) and not listfind(county_id_list,county_id)>
						<cfset county_id_list=listappend(county_id_list,county_id)>
					</cfif>
				</cfloop>
				<cfif len(county_id_list)>
					<cfset county_id_list=listsort(county_id_list,"numeric","ASC",",")>
					<cfquery name="get_county_detail_" datasource="#dsn#">
						SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#) ORDER BY COUNTY_ID
					</cfquery>
				</cfif>
		<cfloop query="GET_COMPANY_">
			<tr>
				<cfset currentroww+=1>
				<td>#currentroww#</td>
				<td>#member_code#</td>
				<td nowrap>
					<cfif isdefined("get_company.manager_partner_id") and len(get_company.manager_partner_id)>
						<cfquery name="get_partner_" datasource="#DSN#">
							SELECT 
								CP.PARTNER_ID,
								CP.COMPANY_PARTNER_NAME,
								CP.COMPANY_PARTNER_SURNAME,
								CP.TC_IDENTITY
							FROM
								COMPANY_PARTNER CP, 
								COMPANY C
							WHERE 
								CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.company_id#"> AND 
								CP.COMPANY_ID = C.COMPANY_ID AND
								COMPANY_PARTNER_STATUS = 1
							ORDER BY 
								CP.COMPANY_PARTNER_NAME
						</cfquery>
						<cfquery name="get_tc" dbtype="query">
							SELECT TC_IDENTITY
							FROM GET_PARTNER_
							WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.manager_partner_id#">
						</cfquery>
					</cfif>
					<cfif isdefined('get_tc.TC_IDENTITY') and len(get_tc.TC_IDENTITY)>
						<cfset tc_num = get_tc.TC_IDENTITY>
					<cfelse>
						<cfset tc_num = ''>
					</cfif>
					<cfif len(ims_code_id)>
						<cfquery name="get_ims_name" datasource="#dsn#">
							SELECT IMS_CODE_NAME,IMS_CODE FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #ims_code_id#
						</cfquery>
					</cfif>
					<cfset adres_ = Replace(Replace(compbranch_address,Chr(10),"","all"),Chr(13),"","all")><!--- Satir kirma sorun oldugundan kaldirmak icin eklendi degistirmeyin FBS --->
					<cfif isdefined('attributes.type_assetp') and attributes.type_assetp eq 1>
						<a href="javascript://" onclick="control(3,#company_id#,#partner_id#);" class="tableyazi"><cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif></a>
					<cfelseif get_module_user(4) and not isdefined("attributes.is_not_link") and not (isdefined("attributes.invoice_retail") or isdefined("attributes.is_from_sale"))>
						<a href="javascript://" onclick="control(1,#company_id#,'');" class="tableyazi"><cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif></a>
					<cfelseif isdefined("attributes.invoice_retail") or isdefined("attributes.is_from_sale")><!--- Perakende faturasindan acilmissa --->
						<cfif isdefined("attributes.is_store_module") and is_related eq 1><!--- Subeden gelmis ve sube consumer iliskisi mevcutsa --->
							<a href="javascript://" onclick="send_comp_info('#company_id#','#partner_id#','#fullname#','#tc_num#','#company_partner_name#','#company_partner_surname#','#member_code#','#ozel_kod#','#compbranch_address#','#city_id#', '<cfif len(county_id)>#get_county_detail_.county_name[listfind(county_id_list,county_id,',')]#</cfif>','#county_id#','#compbranch_telcode#','#compbranch_tel1#','#compbranch_telcode#','#compbranch_fax#','#taxoffice#','#taxno#','#compbranch_email#','#compbranch_mobil_code#','#compbranch_mobiltel#','#COUNTRY#','#COMPBRANCH_ID#'<cfif len(ims_code_id)>,'#ims_code_id#','#get_ims_name.ims_code# #get_ims_name.ims_code_name#'</cfif>);" class="tableyazi">#fullname#</a>
						<cfelseif isdefined("attributes.is_store_module") and is_related eq 0><!--- Subeden gelmis ve sube consumer iliskisi yoksa --->
							<cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif>
						<cfelse>
							<a href="javascript://" onclick="send_comp_info('#company_id#','#partner_id#','#fullname#','#tc_num#','#company_partner_name#','#company_partner_surname#','#member_code#','#ozel_kod#','#compbranch_address#','#city_id#', '<cfif len(county_id)>#get_county_detail_.county_name[listfind(county_id_list,county_id,',')]#</cfif>','#county_id#','#compbranch_telcode#','#compbranch_tel1#','#compbranch_telcode#','#compbranch_fax#','#taxoffice#','#taxno#','#compbranch_email#','#compbranch_mobil_code#','#compbranch_mobiltel#','#COUNTRY#','#COMPBRANCH_ID#'<cfif len(ims_code_id)>,'#ims_code_id#','#get_ims_name.ims_code# #get_ims_name.ims_code_name#'</cfif>);" class="tableyazi">#fullname#</a>
						</cfif>
					<cfelse>
						<cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif>
					</cfif>
				</td>
				<td><cfif attributes.nickname eq trim(nickname)><font color="##990000">#nickname#</font><cfelse>#nickname#</cfif></td>
				<td nowrap>#companycat#</td>
				<td nowrap>
					<cfif attributes.name eq trim(company_partner_name)><font color="##990000">#company_partner_name#</font><cfelse>#company_partner_name#</cfif>
					<cfif attributes.surname eq trim(company_partner_surname)><font color="##990000">#company_partner_surname#</font><cfelse>#company_partner_surname#</cfif>
				</td>
				<td>#adres_#</td>
				<td>#compbranch_alias#</td>
				<td>#taxno#</td>
				<td nowrap>#compbranch_telcode# #compbranch_tel1#</td>
				<td><cfif len(ims_code_id) and isdefined('get_ims_name.ims_code_name') and len(get_ims_name.ims_code_name)>#get_ims_name.ims_code_name#</cfif>
				</td>
				<cfif isdefined("attributes.is_store_module")>
					<cfquery name="GET_BRANCH" dbtype="query">
						SELECT BRANCH_NAME FROM GET_BRANCH_ALL WHERE COMPANY_ID = #get_company.company_id#
					</cfquery>
					<td><cfloop query="GET_BRANCH">#branch_name#,<br/></cfloop></td>
					<td align="center"><cfif is_related eq 0><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=member.emptypopup_add_member_branch&cpid=#company_id#','list');"><cf_get_lang dictionary_id ='34108.Şube İle İlişkilendir'></a></cfif></td>
				</cfif>
			</tr>
		</cfloop>
	</cfif>
		</cfoutput>
        </tbody>
       
	  <cfelse>
        <tbody>
            <tr>
                <td colspan="11"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
            </tr>
        </tbody>
	</cfif>
	</form>
</cf_grid_list>
<cf_box_footer>
	<a class="ui-wrk-btn ui-wrk-btn-success" value="asds" onclick="control(2,0,'');"><cf_get_lang dictionary_id ='33918.Varolan Kayıtları Gözardi Et'></a>
</cf_box_footer>
</cf_box>
<script type="text/javascript">
<cfif not get_company.recordcount>
	<cfif not (isdefined("attributes.invoice_retail") or isdefined("attributes.is_from_sale"))>	
		<cfif not isdefined("attributes.draggable")>opener.</cfif>form_add_company.submit();
	<cfelseif isdefined("attributes.is_from_sale")>
		alert("<cf_get_lang dictionary_id ='33916.Benzer Kayıt Yok ! Üye Kaydı Yapmalısınız'> !");
		<cfif isdefined("attributes.call_function")>
			<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.call_function#</cfoutput>;
		</cfif>
	<cfelse>
		alert("<cf_get_lang dictionary_id ='33917.Benzer Kayıt Yok'> !");
	</cfif>
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
</cfif>
function control(id,value,partner)
{
	if(id==1)
	{	
		<cfif not isdefined("attributes.draggable")>opener.</cfif>location.href='<cfoutput>#request.self#?fuseaction=member.form_list_company&event=upd&is_search=1&cpid=</cfoutput>' + value;
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
	}
	if(id==2)
	{	<cfif not (isdefined("attributes.invoice_retail") or isdefined("attributes.is_from_sale"))>	
			<cfif not isdefined("attributes.draggable")>opener.</cfif>form_add_company.submit();
		</cfif>
		<cfif isdefined("attributes.call_function")>
			<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.call_function#</cfoutput>;
		</cfif>	
		<cfif not isdefined("attributes.draggable")>
			window.close();
		<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		</cfif>
	}
	if(id==3)
	{	
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>form_add_company._company_id_.value = value;
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>form_add_company._partner_id_.value = partner;
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>form_add_company.is_add_member.checked = true;
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>form_add_company.submit();
		<cfif not isdefined("attributes.draggable")>
			window.close();
		<cfelse>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		</cfif>
	}
}

function send_comp_info(comp_id,partner_id,comp_name,tc_num,member_name,member_surname,member_code,ozel_kod,address,city_id,country,county_id,tel_code,tel_number,faxcode,fax_number,tax_office,tax_num,email,mobil_tel_code,mobil_tel_number,country_id,companybranch_id,im_cod_id,im_cod_nam)
{	
	<cfif isdefined("attributes.field_company_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_company_id#</cfoutput>.value = comp_id;
	</cfif>
	<cfif isdefined("attributes.field_partner_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_partner_id#</cfoutput>.value = partner_id;
	</cfif>
	<cfif isdefined("attributes.field_consumer_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_consumer_id#</cfoutput>.value = '' ;  
	</cfif>
	<cfif isdefined("attributes.field_comp_name")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_comp_name#</cfoutput>.value = comp_name;
	</cfif>
	<cfif isdefined("attributes.field_member_name")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_member_name#</cfoutput>.value = member_name ;
	</cfif>
	<cfif isdefined("attributes.field_member_surname")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_member_surname#</cfoutput>.value = member_surname ;
	</cfif>
	<cfif isdefined("attributes.field_member_code")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_member_code#</cfoutput>.value = member_code ;
	</cfif>
	<cfif isdefined("attributes.field_ozel_kod")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_ozel_kod#</cfoutput>.value = ozel_kod ;
	</cfif>
	<cfif isdefined("attributes.field_address")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_address#</cfoutput>.value = address;
	</cfif>
	LoadCity(country_id,'city','county_id',0);
	<cfif isDefined('field_country')>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_country#</cfoutput>.value = country_id;
		<cfif isdefined("attributes.field_city")>
			<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_city#</cfoutput>.value = city_id;
			LoadCounty(city_id,'county_id');
		</cfif>	
	</cfif>
	<cfif isdefined("attributes.field_county_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_county_id#</cfoutput>.value = county_id;
	</cfif>
	<cfif isdefined("attributes.field_ship_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_ship_id#</cfoutput>.value = companybranch_id;
	</cfif>
	<cfif isdefined("attributes.field_tel_code")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_tel_code#</cfoutput>.value = tel_code;
	</cfif>
	<cfif isdefined("attributes.field_tel_number")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_tel_number#</cfoutput>.value = tel_number;
	</cfif>
	<cfif isdefined("attributes.field_mobil_tel")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_mobil_tel#</cfoutput>.value = mobil_tel_number;
	</cfif>
	<cfif isdefined("attributes.field_mobil_code")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_mobil_code#</cfoutput>.value = mobil_tel_code;
	</cfif>
	<cfif not isdefined("attributes.is_from_sale")>
		<cfif isdefined("attributes.field_faxcode")>
			<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_faxcode#</cfoutput>.value = faxcode;
		</cfif>
		<cfif isdefined("attributes.field_fax_number")>
			<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_fax_number#</cfoutput>.value = fax_number;
		</cfif>
	</cfif>
	<cfif isdefined("attributes.field_tax_office")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_tax_office#</cfoutput>.value = tax_office;
	</cfif>
	<cfif isdefined("attributes.field_tax_num")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_tax_num#</cfoutput>.value = tax_num;
	</cfif>
	<cfif isdefined("attributes.field_email")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_email#</cfoutput>.value = email;
	</cfif>
	<cfif isdefined("attributes.call_function")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.call_function#</cfoutput>
	</cfif>
	<cfif isdefined("attributes.field_tc_num")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#field_tc_num#</cfoutput>.value = tc_num;
	</cfif>
	<cfif isdefined("attributes.field_ims_code_id")>
		if(im_cod_id != undefined)
		{
			<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_ims_code_id#</cfoutput>.value = im_cod_id;
		}
	</cfif> 
	<cfif isdefined("attributes.field_ims_code_name") and isdefined('get_ims_name.ims_code_name') and len(get_ims_name.ims_code_name)>
		if(im_cod_nam != undefined)
		{
			<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_ims_code_name#</cfoutput>.value = im_cod_nam;
		}
	</cfif>
	if(typeof(<cfif not isdefined("attributes.draggable")>opener.</cfif>set_price_catid_options) != 'undefined')  //baskete seri ve barkoddan urun ekleme bolumu icin eklendi, add_company_js.cfm 'de de var.
		{
			try{<cfif not isdefined("attributes.draggable")>opener.</cfif>set_price_catid_options();}
				catch(e){};
		}
	<cfif not isdefined("attributes.draggable")>window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
	
}
</script>
