<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.is_onay" default="1">
<cfquery name="GET_POSITION_BRANCH" datasource="#dsn#">
	SELECT BRANCH_NAME, BRANCH_ID FROM  BRANCH WHERE BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) ORDER BY BRANCH_NAME
</cfquery>
<cfif len(attributes.is_submitted)>
	<cfquery name="GET_CLIENTS" datasource="#dsn#">
		SELECT 
			COMPANY.COMPANY_POSTCODE,
			COMPANY.COMPANY_TELCODE,
			COMPANY.COMPANY_TEL1,
			COMPANY.COMPANY_ID, 
			COMPANY.COUNTRY,
			COMPANY.TAXNO,
			COMPANY.FULLNAME, 
			COMPANY.IMS_CODE_ID,
			COMPANY.TAXOFFICE,
			COMPANY.DISTRICT,
			COMPANY.MAIN_STREET,
			COMPANY.STREET,
			COMPANY.SEMT,
			COMPANY.DUKKAN_NO,
			COMPANY.COUNTY,
			SETUP_IMS_CODE.IMS_CODE,
			SETUP_IMS_CODE.IMS_CODE_NAME,
			COMPANY_CAT.COMPANYCAT,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
			COMPANY.ISPOTANTIAL,
			SETUP_COUNTY.COUNTY_NAME,
			SETUP_CITY.CITY_NAME,
			COMPANY.COMPANY_ADDRESS,
			SETUP_COUNTRY.COUNTRY_NAME
		FROM 
			COMPANY,
			SETUP_IMS_CODE,
			COMPANY_CAT,
			COMPANY_PARTNER,
			SETUP_COUNTY,
			SETUP_CITY,
			SETUP_COUNTRY
		WHERE 
			SETUP_CITY.CITY_ID = COMPANY.CITY AND
			SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY AND
			COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
			COMPANY.IMS_CODE_ID = SETUP_IMS_CODE.IMS_CODE_ID AND
			COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND 
			COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
			SETUP_COUNTRY.COUNTRY_ID = COMPANY.COUNTRY AND
			COMPANY.COMPANY_ID IN
			(
			SELECT
				CBR.COMPANY_ID
			FROM
				COMPANY_BRANCH_RELATED CBR,
				EMPLOYEE_POSITION_BRANCHES EPB
			WHERE
				CBR.MUSTERIDURUM IS NOT NULL AND
				CBR.IS_SELECT = 1 AND
				EPB.POSITION_CODE = #session.ep.position_code# AND
				EPB.BRANCH_ID = CBR.BRANCH_ID AND 
				CBR.VALID_EMP IS NOT NULL
				<cfif len(attributes.branch_id)>AND CBR.BRANCH_ID = #attributes.branch_id#</cfif>
			)
			<cfif len(attributes.keyword)>AND COMPANY.FULLNAME LIKE '#attributes.keyword#%'</cfif>
		 ORDER BY 
			COMPANY.FULLNAME
	</cfquery>
	<cfquery name="GET_BRANCH" datasource="#dsn#">
		SELECT
			COMPANY_BRANCH_RELATED.COMPANY_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			COMPANY_BRANCH_RELATED.CARIHESAPKOD,
			COMPANY_BRANCH_RELATED.VALID_EMP,
			COMPANY_BRANCH_RELATED.VALID_DATE,
			SETUP_MEMBERSHIP_STAGES.TR_NAME AS TR_NAME,
			COMPANY_BRANCH_RELATED.SALES_DIRECTOR,
			COMPANY_BRANCH_RELATED.BOYUT_TAHSILAT,
			COMPANY_BRANCH_RELATED.BOYUT_ITRIYAT,
			COMPANY_BRANCH_RELATED.BOYUT_TELEFON,
			COMPANY_BRANCH_RELATED.BOYUT_PLASIYER,
			COMPANY_BRANCH_RELATED.BOYUT_BSM,
			COMPANY_BRANCH_RELATED.PLASIYER_ID,
			COMPANY_BRANCH_RELATED.TEL_SALE_PREID,
			COMPANY_BRANCH_RELATED.TAHSILATCI,
			COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI,
			COMPANY_BRANCH_RELATED.VALID_DATE,
			COMPANY_BRANCH_RELATED.VALID_EMP
		FROM
			BRANCH,
			COMPANY_BRANCH_RELATED,
			SETUP_MEMBERSHIP_STAGES
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
			SETUP_MEMBERSHIP_STAGES.TR_ID = COMPANY_BRANCH_RELATED.MUSTERIDURUM AND
			COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID 
			<cfif len(attributes.branch_id)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
			<cfif len(attributes.is_onay) and (attributes.is_onay eq 1)>
				AND COMPANY_BRANCH_RELATED.VALID_EMP IS NOT NULL
			<cfelse>
				AND COMPANY_BRANCH_RELATED.VALID_EMP IS NULL
			</cfif>
		UNION ALL
		SELECT
			COMPANY_BRANCH_RELATED.COMPANY_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			COMPANY_BRANCH_RELATED.CARIHESAPKOD,
			COMPANY_BRANCH_RELATED.VALID_EMP,
			COMPANY_BRANCH_RELATED.VALID_DATE,
			'' AS TR_NAME,
			COMPANY_BRANCH_RELATED.SALES_DIRECTOR,
			COMPANY_BRANCH_RELATED.BOYUT_TAHSILAT,
			COMPANY_BRANCH_RELATED.BOYUT_ITRIYAT,
			COMPANY_BRANCH_RELATED.BOYUT_TELEFON,
			COMPANY_BRANCH_RELATED.BOYUT_PLASIYER,
			COMPANY_BRANCH_RELATED.BOYUT_BSM,
			COMPANY_BRANCH_RELATED.PLASIYER_ID,
			COMPANY_BRANCH_RELATED.TEL_SALE_PREID,
			COMPANY_BRANCH_RELATED.TAHSILATCI,
			COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI,
			COMPANY_BRANCH_RELATED.VALID_DATE,
			COMPANY_BRANCH_RELATED.VALID_EMP
		FROM
			BRANCH,
			COMPANY_BRANCH_RELATED
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NULL AND
			COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID 
			<cfif len(attributes.branch_id)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
			<cfif len(attributes.is_onay) and (attributes.is_onay eq 1)>
				AND COMPANY_BRANCH_RELATED.VALID_EMP IS NOT NULL
			<cfelse>
				AND COMPANY_BRANCH_RELATED.VALID_EMP IS NULL
			</cfif>
	</cfquery>
	<cfparam name="attributes.totalrecords" default='#get_clients.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="right">
	<cf_workcube_file_action pdf='1' mail='1' print='0' box="1" tag_module="printBuyers" isAjaxPage="1">
	<li><a href="javascript://" onClick="print_buyers()">
		<i class="fa fa-print" title="Yazdır" id="list_print_button"></i>
	</a></li>
</cfsavecontent>
<cf_box title="#getLang('','Müsterilerim',51628)#" scroll="1" right_images='#right#' collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_form" action="#request.self#?fuseaction=crm.popup_print_myvalid_buyers" method="post">
		<cf_box_search>
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<div class="form-group">
				<select name="branch_id" id="branch_id">
					<option value=""><cf_get_lang no ='107.Yetkili Şubeler'></option>
					<cfoutput query="get_position_branch">
						<option value="#branch_id#" <cfif branch_id eq attributes.branch_id>selected</cfif>>#branch_name#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<select name="is_onay" id="is_onay">
					<option value="1" <cfif attributes.is_onay eq 1>selected</cfif>><cf_get_lang_main no ='204.Onaylı'></option>
					<option value="2" <cfif attributes.is_onay eq 2>selected</cfif>><cf_get_lang no ='508.Onaysız'></option>
				</select>
			</div>
			<div class="form-group">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" placeHolder="#getLang('','filtre',57460)#">
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function='controlForm() && #iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_form' , #attributes.modal_id#)"),DE(""))#'>
			</div>								
		</cf_box_search>
	</cfform>
	<div id="printBuyers" style="page-break-after: always;">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="25"><cf_get_lang_main no="75.No"></th>
					<th nowrap><cf_get_lang no ='610.Eczane Adı'></th>
					<th><cf_get_lang no ='600.Müşteri Durum'></th>
					<th><cf_get_lang no ='35.Müşteri Tipi'></th>
					<th><cf_get_lang_main no='780.Müşteri Adı'></th>
					<th><cf_get_lang no ='37.Müşteri Soyadı'></th>
					<th><cf_get_lang_main no='340.Vergi No'></th>
					<th><cf_get_lang_main no='1350.Vergi Dairesi'></th>
					<th><cf_get_lang_main no='1323.Mahalle'></th>
					<th><cf_get_lang_main no='1196.İl'></th>
					<th><cf_get_lang no='45.Cadde'></th>
					<th><cf_get_lang_main no='1226.İlçe'></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted) and  get_clients.recordcount>
					<cfoutput query="get_clients" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfquery name="GET_BRANCH_INFO" dbtype="query">
							SELECT VALID_EMP, VALID_DATE, BRANCH_NAME, TR_NAME, BRANCH_ID, VALID_EMP, VALID_DATE, SALES_DIRECTOR, BOYUT_TAHSILAT, BOYUT_ITRIYAT, BOYUT_TELEFON, BOYUT_PLASIYER, BOYUT_BSM, CARIHESAPKOD, PLASIYER_ID,TEL_SALE_PREID, TAHSILATCI, ITRIYAT_GOREVLI FROM  GET_BRANCH WHERE COMPANY_ID = #company_id#
						</cfquery>
						<tr class="nohover">
							<td rowspan="5">#currentrow#</td>
							<td rowspan="5">#fullname#</td>
							<td>#get_branch_info.tr_name#</td>
							<td>#companycat#</td>
							<td>#company_partner_name#</td>
							<td>#company_partner_surname#</td>
							<td>#taxno#</td>
							<td>#taxoffice#</td>
							<td>#district#</td>
							<td>#city_name#</td>
							<td>#main_street#</td>
							<td>#county_name#</td>
						</tr>
						<tr class="nohover">
						<td><b><cf_get_lang no='46.Sokak'></b></td>
						<td><b><cf_get_lang_main no='720.Semt'></b></td>
						<td><b><cf_get_lang_main no='60.Posta Kodu'></b></td>
						<td><b><cf_get_lang no ='845.Dükkan No'></b></td>
						<td><b><cf_get_lang no ='102.Bölge Satış Müd'></b></td>
						<td><B><cf_get_lang no='337.Kod Telefon'></B></td>
						<td><b><cf_get_lang_main no='722.IMS Bölge Kodu'></b></td>
						<td><b><cf_get_lang_main no='1351.Depo'></b></td>
						<td><b><cf_get_lang no='226.Cari Hesap Kodu'></b></td>
						<td><b><cf_get_lang_main no ='88.Onay'></b></td>
						</tr>
						<tr class="nohover">
							<td>#street#</td>
							<td>#semt#</td>
							<td>#COMPANY_POSTCODE#</td>
							<td>#dukkan_no#</td>
							<td>#get_emp_info(GET_BRANCH_INFO.sales_director,1,0)#</td>
							<td>#company_telcode# / #company_tel1#</td>
							<td>#ims_code# #ims_code_name#</td>
							<td>#GET_BRANCH_INFO.branch_name#</td>
							<td>#GET_BRANCH_INFO.carihesapkod#</td>
							<td>#get_emp_info(get_branch_info.valid_emp,0,0)#</td>
						</tr>
						<tr class="nohover">
						<td><b><cf_get_lang no ='689.Boyut Kodu'></b></td>
						<td><b><cf_get_lang no ='101.Saha Satış Gör'></b></td>
						<td><b><cf_get_lang no ='689.Boyut Kodu'></b></td>
						<td><b><cf_get_lang no ='657.Tel Satıs Gör'></b></td>
						<td><b><cf_get_lang no ='689.Boyut Kodu'></b></td>
						<td><b><cf_get_lang no='205.Tahsilatçı'></b></td>
						<td><b><cf_get_lang no ='689.Boyut Kodu'></b></td>
						<td><b><cf_get_lang no ='646.Itriyat Satış Gör'></b></td>
						<td><b><cf_get_lang no ='689.Boyut Kodu'></b></td>
						<td><b><cf_get_lang no ='648.Onay Tarihi'></b></td>
						</tr>
						<tr class="nohover">
							<td>#GET_BRANCH_INFO.boyut_bsm#</td>
							<td>#get_emp_info(GET_BRANCH_INFO.plasiyer_id,1,0)#</td>
							<td>#GET_BRANCH_INFO.boyut_plasiyer#</td>                   
							<td>#get_emp_info(GET_BRANCH_INFO.tel_sale_preid,1,0)#</td>
							<td>#GET_BRANCH_INFO.boyut_telefon#</td>
							<td>#get_emp_info(GET_BRANCH_INFO.tahsilatci,1,0)#</td>
							<td>#GET_BRANCH_INFO.boyut_tahsilat#</td>
							<td>#get_emp_info(GET_BRANCH_INFO.itriyat_gorevli,1,0)#</td>
							<td>#GET_BRANCH_INFO.boyut_itriyat#</td>
							<td>#dateformat(get_branch_info.valid_date,dateformat_style)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="20"><cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)><cf_get_lang_main no="72.Kayıt Yok">!<cfelse><cf_get_lang_main no="289.Filtre Ediniz">!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</div>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.branch_id)>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif len(attributes.is_submitted)>
			<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<cfif len(attributes.is_onay)>
			<cfset url_str = "#url_str#&is_onay=#attributes.is_onay#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="crm.popup_print_myvalid_buyers#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
	function print_buyers(){		
		$('#printBuyers').printThis();	
	}
	function controlForm()
	{
		x = document.search_form.branch_id.selectedIndex;
		if (document.search_form.branch_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no ='1167.Lütfen Şube Seçiniz'> !");
			return false;
		}
		else
			return true;
	}
</script>
