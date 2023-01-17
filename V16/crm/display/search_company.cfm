<cfparam name="attributes.hedefkodu" default="">
<cfparam name="attributes.glncode" default="">
<cfparam name="attributes.fullname" default="">
<cfparam name="attributes.cp_name" default="">
<cfparam name="attributes.cp_surname" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.ekip" default="">
<cfparam name="attributes.vergi_no" default="">
<cfparam name="attributes.customer_type" default="">
<cfparam name="attributes.customer_type_id" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.citycode" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.branch_state" default="3">
<cfparam name="attributes.pro_rows" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.carihesapkod" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.tckimlikno" default="">
<cfif not len(attributes.customer_type)>
	<cfset attributes.customer_type_id = "">
</cfif>
<cfif len(attributes.customer_type_id)>
	<cfset cust_type_ = "">
	<cfloop from="1" to="#listlen(attributes.customer_type_id)#" index="i">
		<cfset cust_type_ = listappend(cust_type_, listgetat(attributes.customer_type_id, i, ','), ',')>
	</cfloop>
	<cfset attributes.customer_type_id = cust_type_>
</cfif>
<cfinclude template="../query/get_city.cfm">
<cfquery name="GET_CUSTOM_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT_ID
</cfquery>
<cfquery name="GET_ZONE" datasource="#DSN#">
	SELECT ZONE_ID,ZONE_NAME FROM ZONE ORDER BY ZONE_NAME
</cfquery>
<cfquery name="GET_BRANCH_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES ORDER BY TR_NAME
</cfquery>
<cfquery name="Get_Country_Info" datasource="#dsn#">
	SELECT COUNTRY_ID, COUNTRY_NAME, COUNTRY_PHONE_CODE, IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_PRO_TYPEROWS" datasource="#DSN#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.form_add_company%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>

<cfif isdefined("attributes.is_submitted")>
	<cfscript>
		if (len(attributes.fullname))
		{
			fullname_1 = replacelist(attributes.fullname,"ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö","u,g,i,s,c,o,U,G,I,S,C,O");
			fullname_2 = replacelist(attributes.fullname,"u,g,i,s,c,o,U,G,I,S,C,O","ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö");
		}
	</cfscript>
  	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT
			COMPANY.COMPANY_ID,
			COMPANY.CITY,
			COMPANY.COUNTY,
			COMPANY.IMS_CODE_ID,
			COMPANY.FULLNAME,
			COMPANY.COMPANY_TELCODE,
			COMPANY.COMPANY_TEL1,
			COMPANY.TAXNO,
			COMPANY.ISPOTANTIAL,
			COMPANY_PARTNER.PARTNER_ID,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
			COMPANY_PARTNER.TC_IDENTITY
		FROM 
			COMPANY, 
			COMPANY_PARTNER, 
			COMPANY_CAT
		WHERE 
		<cfif len(attributes.hedefkodu)>COMPANY.COMPANY_ID = #attributes.hedefkodu# AND</cfif>
		<cfif len(attributes.glncode)>COMPANY.GLNCODE = '#attributes.glncode#' AND</cfif>
		<cfif len(attributes.tckimlikno)>COMPANY_PARTNER.TC_IDENTITY = '#attributes.tckimlikno#' AND</cfif>
		<cfif len(attributes.county) and len(attributes.county_id)>COMPANY.COUNTY = #attributes.county_id# AND</cfif>
		<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>COMPANY.IMS_CODE_ID = #attributes.ims_code_id# AND</cfif>
		<cfif len(attributes.city)>COMPANY.CITY = #attributes.city# AND</cfif>
		<cfif len(attributes.vergi_no)>COMPANY.TAXNO = '#attributes.vergi_no#' AND</cfif>
		<cfif len(attributes.customer_type) and len(attributes.customer_type_id)>COMPANY.COMPANYCAT_ID IN (#attributes.customer_type_id#) AND</cfif>
		<cfif len(attributes.cp_name)>COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '#attributes.cp_name#%' AND</cfif>
		<cfif len(attributes.is_active)>COMPANY.COMPANY_STATUS = #attributes.is_active# AND</cfif>
		<cfif len(attributes.cp_surname)>COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '#attributes.cp_surname#%' AND</cfif>
			COMPANY.COMPANY_ID IN
				(
				SELECT
					CBR.COMPANY_ID
				FROM
					COMPANY_BRANCH_RELATED CBR,
					EMPLOYEE_POSITION_BRANCHES EPB
				WHERE
					CBR.MUSTERIDURUM IS NOT NULL AND
					EPB.POSITION_CODE = #session.ep.position_code# AND
					<cfif len(attributes.branch_id)>CBR.BRANCH_ID = #attributes.branch_id# AND</cfif>
					<cfif len(attributes.branch_state)>CBR.MUSTERIDURUM = #attributes.branch_state# AND</cfif>
					<cfif len(attributes.pro_rows)>CBR.DEPO_STATUS = #attributes.pro_rows# AND</cfif>
					<cfif len(attributes.carihesapkod)>CBR.CARIHESAPKOD = '#attributes.carihesapkod#' AND</cfif>
					EPB.BRANCH_ID = CBR.BRANCH_ID
				) AND
			COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND 
			COMPANY.IMS_CODE_ID IS NOT NULL AND
			COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
			COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
			COMPANY_CAT.COMPANYCAT_TYPE = 0
			<cfif len(attributes.fullname)>AND (COMPANY.FULLNAME LIKE '#attributes.fullname#%' OR COMPANY.FULLNAME LIKE '#fullname_1#%' OR COMPANY.FULLNAME LIKE '#fullname_2#%' )</cfif>
		ORDER BY 
			COMPANY.FULLNAME
	</cfquery>
	<cfif get_company.recordcount>
		<cfquery name="GET_COMPANY_ACCOUNT" datasource="#DSN#">
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
				SETUP_MEMBERSHIP_STAGES.TR_ID = COMPANY_BRANCH_RELATED.MUSTERIDURUM AND
				COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
				OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
				<cfif len(attributes.branch_state)>AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.branch_state#</cfif>
				<cfif get_company.recordcount and (get_company.recordcount lt 2000)>AND COMPANY_BRANCH_RELATED.COMPANY_ID IN (#valuelist(get_company.company_id,',')#)</cfif>
			
			UNION ALL
			
			SELECT
				BRANCH.BRANCH_NAME,
				COMPANY_BRANCH_RELATED.COMPANY_ID,
				COMPANY_BRANCH_RELATED.CARIHESAPKOD,
				COMPANY_BRANCH_RELATED.IS_SELECT,
				'' TR_NAME
			FROM
				BRANCH,
				COMPANY_BRANCH_RELATED,
				OUR_COMPANY
			WHERE
				COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NULL AND
				COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
				OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
				<cfif len(attributes.branch_state)>AND COMPANY_BRANCH_RELATED.MUSTERIDURUM = #attributes.branch_state#</cfif>
				<cfif get_company.recordcount and (get_company.recordcount lt 2000)>AND COMPANY_BRANCH_RELATED.COMPANY_ID IN (#valuelist(get_company.company_id,',')#)</cfif>
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_company.recordcount = 0>
</cfif>
<cfset county_id_ = ''>
<cfset county_ = ''>
<cfset city_id_ = ''>
<cfset telcod_ = ''>
<cfset country_id_ = ''>
<cfset country_ = ''>
<cfparam name='attributes.totalrecords' default='#get_company.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_company" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction#">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<input type="hidden" name="click_count" id="click_count" value="0">
			<cf_box_search >	
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57750.İşyeri Adı'></cfsavecontent>
					<cfinput type="text" name="fullname" placeholder="#place#"  value="#attributes.fullname#" maxlength="255">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='30723.Hedef Kodu'></cfsavecontent>
						<cfinput type="text" name="hedefkodu" placeholder="#place#" value="#attributes.hedefkodu#" onKeyUp="isNumber(this);" style="width:60px;">
					</div>
				</div>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='30725.GLN Kodu'></cfsavecontent>
						<cfinput type="text" name="glncode" placeholder="#place#" value="#attributes.glncode#" maxlength="13" onKeyUp="isNumber(this);" style="width:80px;">
				</div>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57752.Vergi No'></cfsavecontent>
					<cfinput type="text" name="vergi_no" placeholder="#place#" onKeyUp="isNumber(this);"  value="#attributes.vergi_no#">
				</div>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57631.Ad'></cfsavecontent>
					<cfinput type="text" name="vergi_no" placeholder="#place#" onKeyUp="isNumber(this);"  value="#attributes.vergi_no#">
				</div>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
					<cfinput type="text" name="cp_surname" placeholder="#place#"  value="#attributes.cp_surname#" maxlength="255">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel="0" search_function='hepsini_sec()'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>                
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                  
                        <div class="form-group" >
                            <label class="col col-12"><cf_get_lang dictionary_id='30680.Müşteri Tipi'></label>
								<div class="col col-12">
									<div class="input-group" >
									<cfif len(attributes.customer_type_id)>
										<cfquery name="GET_CUSTCAT" datasource="#DSN#">
											SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID IN (#attributes.customer_type_id#)
										</cfquery>
										<input type="hidden" name="customer_type_id" id="customer_type_id" value="<cfoutput>#attributes.customer_type_id#</cfoutput>">
										<input type="text" name="customer_type" id="customer_type" style="width:100px;" value="<cfoutput query="get_custcat">#companycat#,</cfoutput>">
									<cfelse>
										<input type="hidden" name="customer_type_id" id="customer_type_id" value="">
										<input type="text" name="customer_type" id="customer_type" style="width:100px;" value="">
									</cfif>
									<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_partner_cats_search&field_name=search_company.customer_type&field_id=search_company.customer_type_id&click_count=search_company.click_count&customer_type=1','small');"></span>
								
								</div>
                            </div>
                        </div>

						<div class="form-group" >
                            <label class="col col-12"><cf_get_lang dictionary_id='57894.Statü'></label>
                            <div class="col col-12">
								<select name="branch_state" id="branch_state" >
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_branch_status">
										<option value="#tr_id#" <cfif attributes.branch_state eq tr_id>selected</cfif>>#tr_name#</option>
									</cfoutput>
								</select>
                            </div>
                        </div>
						<div class="form-group" >
                            <label class="col col-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
                            <div class="col col-12">
                                <input type="text" name="tckimlikno" id="tckimlikno" onKeyUp="isNumber(this);" maxlength="11" style="width:60;" value="<cfoutput>#attributes.tckimlikno#</cfoutput>">
                            </div>
                        </div>

						<div class="form-group" >
                            <label class="col col-12"><cf_get_lang dictionary_id='57519.CariHesap'></label>
                            <div class="col col-12">
                                <input type="text" name="carihesapkod" id="carihesapkod" maxlength="10" value="<cfoutput>#attributes.carihesapkod#</cfoutput>" style="width:70px;">
                            </div>
                        </div>
						<div class="form-group" >
                            <label class="col col-12"><cf_get_lang dictionary_id='29434.Şubeler'></label>
							<div class="col col-12">
								<select name="branch_id" id="branch_id" style="width:150px;">
									<option value=""></option>
									<cfoutput query="get_branch">
										<option value="#branch_id#" <cfif branch_id eq attributes.branch_id>selected</cfif>>#branch_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
				
                </div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" >
						<label class="col col-12"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></label>
						<div class="col col-12">
							<div class="input-group" >
								<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
                    			<cfinput type="text" name="ims_code_name" style="width:100px;" value="#attributes.ims_code_name#">
                    			<span class="input-group-addon icon-ellipsis" onClick="pencere_ac();"></span>
							</div>
						</div>
					</div>
					
					<div class="form-group" id="item-branch">
						<label class="col col-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-12"> 
							<cfquery name="Get_Country_Info" datasource="#dsn#">
								SELECT COUNTRY_ID, COUNTRY_NAME, COUNTRY_PHONE_CODE, IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
							</cfquery>
							<select name="country_id" id="country_id" style="width:150px;" onchange="LoadCity(this.value,'city_id','county_id',0)" tabindex="7"> 
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="Get_Country_Info">
									<option value="#Get_Country_Info.Country_Id#" <cfif (Get_Country_Info.Country_Id eq Country_) or (Get_Country_Info.Is_Default eq 1)> selected</cfif>>#Get_Country_Info.Country_Name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-12"><cf_get_lang dictionary_id='57971.Sehir'></label>
						<div class="col col-12">
						<cfoutput>
								<select name="city_id" id="city_id" style="width:150px;" onchange="LoadCounty(this.value,'county_id','telcod')" tabindex="8">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								</select>
							</cfoutput>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-12">
							<div class="input-group" >
								<select name="county_id" id="county_id" style="width:150px;" tabindex="9">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>						
									<cfif len(county_)>
										<cfquery name="Get_County_Info" datasource="#dsn#">
											SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY ORDER BY COUNTY_NAME
										</cfquery>
										<cfoutput query="Get_County_Info">
											<option value="#Get_County_Info.County_Id#" <cfif Get_County_Info.County_Id eq county_id_>selected</cfif>>#Get_County_Info.County_Name#</option>
										</cfoutput>
									</cfif>
								</select>
							</div>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
						<div class="col col-12">
							<select name="pro_rows" id="pro_rows" >
								<option value=""></option>
								<cfoutput query="get_pro_typerows">
									<option value="#process_row_id#" <cfif attributes.pro_rows eq process_row_id>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-12"><cf_get_lang dictionary_id='57756.Durum'></label>
						<div class="col col-12">
							<select name="is_active" id="is_active">
								<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
								<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							</select>
						</div>
					</div>
				
				</div>
			</cf_box_search_detail> 
				<cfoutput>
					<ul class="link-list">
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=A&is_submitted=1">A</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=B&is_submitted=1">B</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=C&is_submitted=1">C</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=Ç&is_submitted=1">Ç</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=D&is_submitted=1">D</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=E&is_submitted=1">E</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=F&is_submitted=1">F</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=G&is_submitted=1">G</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=Ğ&is_submitted=1">Ğ</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=H&is_submitted=1">H</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=I&is_submitted=1">I</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=İ&is_submitted=1">İ</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=J&is_submitted=1">J</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=K&is_submitted=1">K</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=L&is_submitted=1">L</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=M&is_submitted=1">M</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=N&is_submitted=1">N</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=O&is_submitted=1">O</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=Ö&is_submitted=1">Ö</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=P&is_submitted=1">P</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=Q&is_submitted=1">Q</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=R&is_submitted=1">R</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=S&is_submitted=1">S</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=Ş&is_submitted=1">Ş</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=T&is_submitted=1">T</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=U&is_submitted=1">U</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=Ü&is_submitted=1">Ü</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=V&is_submitted=1">V</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=W&is_submitted=1">W</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=Y&is_submitted=1">Y</a></li>
							<li><a href="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#&fullname=Z&is_submitted=1">Z</a></li>
						
						</ul>
				</cfoutput>
		</cfform>
	</cf_box>

<cf_box title="#getLang('','Müşteri Ara',51736)#" uidrop="1" >
		
<cf_grid_list>
    <thead>
        <tr>
            <th ><cf_get_lang dictionary_id='57487.No'></th>
            <th ><cf_get_lang dictionary_id='52115.Hedef Kodu'></th>
            <th><cf_get_lang dictionary_id='57750.İşyeri Adı'></th>
            <th ><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th ><cf_get_lang dictionary_id='58134.Mikro Bolge Kodu'></th>
            <th ><cf_get_lang dictionary_id='57752.Vergi No'></th>
            <th ><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>				
            <th ><cf_get_lang dictionary_id='58638.İlçe'></th>
            <th ><cf_get_lang dictionary_id='58608.İl'></th>
            <th ><cf_get_lang dictionary_id='57499.Telefon'></th>
            <th><cf_get_lang dictionary_id='57453.Şube'></th>
            <th ><cf_get_lang dictionary_id='57894.Statü'></th>
        </tr>
    </thead>
    <tbody>
		<cfif get_company.recordcount>
		  <cfset city_name_list = "">
		  <cfset county_name_list = "">
		  <cfset ims_code_list = "">
		   <cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<cfif len(city) and not listfind(city_name_list,city)>
					<cfset city_name_list=listappend(city_name_list,city)>
				</cfif>
				<cfif len(county) and not listfind(county_name_list,county)>
					<cfset county_name_list=listappend(county_name_list,county)>
				</cfif>
				<cfif len(ims_code_id) and not listfind(ims_code_list,ims_code_id)>
					<cfset ims_code_list=listappend(ims_code_list,ims_code_id)>
				</cfif>
		   </cfoutput>
		   <cfif len(city_name_list)>
				<cfquery name="get_city_name" datasource="#DSN#">
					SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_name_list#) ORDER BY CITY_ID
				</cfquery>
				<cfset city_name_list = listsort(listdeleteduplicates(valuelist(get_city_name.city_id,',')),'numeric','ASC',',')>
		   </cfif>
		   <cfif len(county_name_list)>
		   		<cfquery name="get_county_name" datasource="#DSN#">
					SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_name_list#) ORDER BY COUNTY_ID
				</cfquery>
				<cfset county_name_list = listsort(listdeleteduplicates(valuelist(get_county_name.county_id,',')),'numeric','ASC',',')>
		   </cfif>
		   <cfif len(ims_code_list)>
		   		<cfquery name="get_ims_name" datasource="#DSN#">
					SELECT IMS_CODE_ID, IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID IN (#ims_code_list#) ORDER BY IMS_CODE_ID
				</cfquery>
				<cfset ims_code_list = listsort(listdeleteduplicates(valuelist(get_ims_name.ims_code_id,',')),'numeric','ASC',',')>
		   </cfif>
		  
		  <cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
			<cfquery name="get_comp_info" dbtype="query">
				SELECT TR_NAME, BRANCH_NAME, CARIHESAPKOD, IS_SELECT FROM GET_COMPANY_ACCOUNT WHERE COMPANY_ID = #get_company.company_id#
			</cfquery>
			<tr>
				<td width="30">#currentrow#</td>
				<td>#company_id#</td>
				<td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#&is_search=1" class="tableyazi">#fullname#<cfif ispotantial neq 0> - <cf_get_lang dictionary_id='57577.Potansiyel'></cfif></a></td>
				<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#');" >#company_partner_name# #company_partner_surname#</a></td>
				<td title="#get_ims_name.ims_code_name[listfind(ims_code_list,ims_code_id,',')]#">#get_ims_name.ims_code[listfind(ims_code_list,ims_code_id,',')]#</td>
				<td>#taxno#</td>
				<td>#tc_identity#</td>
				<td>#get_county_name.county_name[listfind(county_name_list,county,',')]#</td>
				<td>#get_city_name.city_name[listfind(city_name_list,city,',')]#</td>
				<td>#company_telcode# #company_tel1#</td>
				<td><cfloop query="get_comp_info">#get_comp_info.branch_name# <cfif len(get_comp_info.carihesapkod)>/ #get_comp_info.carihesapkod#</cfif><cfif get_comp_info.is_select eq 0> - <cf_get_lang dictionary_id='57577.Potansiyel'></cfif><br/></cfloop></td>
				<td><cfloop query="get_comp_info"><cfif len(get_comp_info.tr_name)>#get_comp_info.tr_name#</cfif><br/></cfloop></td>
			</tr>
		  </cfoutput>
		<cfelse>
			<tr>
				<td colspan="30"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
    </tbody>
</cf_grid_list>

			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
					<cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
				</cfif>
							<cf_paging 
								page="#attributes.page#"
								maxrows="#attributes.maxrows#"
								totalrecords="#attributes.totalrecords#"
								startrow="#attributes.startrow#"
								adres="crm.#fusebox.fuseaction##url_str#"
								isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
						<!--- <td style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td> --->
			</cfif>
	</cf_box>

</div>
<script type="text/javascript">
search_company.fullname.focus();

var country_ = document.all.country_id.value;
	if(country_.length)
		LoadCity(country_,'city_id','county_id',0);

function remove_field(field_option_name)
{
	field_option_name_value = eval('document.search_company.' + field_option_name);
	for (i=field_option_name_value.options.length-1;i>-1;i--)
	{
		if (field_option_name_value.options[i].selected==true)
		{
			field_option_name_value.options.remove(i);
		}
	}
}
function county_id_clear()
{	
	document.search_company.county.value = '';
	document.search_company.county_id.value = '';
	document.search_company.ims_code_id.value = '';
	document.search_company.ims_code_name.value = '';
}
function pencere_ac(selfield)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=search_company.ims_code_name&field_id=search_company.ims_code_id&is_submitted=1&il_id=' +document.search_company.city.value);
}
// function pencere_ac2(no)
// {
// 	x = document.search_company.city.selectedIndex;
// 	if (document.search_company.city[x].value == "")
// 		alert("<cf_get_lang dictionary_id='57257.İlk Olarak İl Seçiniz'> !");
// 	else
// 	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=search_company.county_id&field_name=search_company.county&city_id=' + document.search_company.city.value);
// }
function pencere_ac_companycat()
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_partner_cats&field_name=search_company.customer_type&customer_type=' + document.search_company.company_type.value,'small');
}
function select_all(selected_field)
{
	var m = eval("document.search_company."+selected_field+".length");
	for(i=0;i<m;i++)
	{
		eval("document.search_company."+selected_field+"["+i+"].selected=true")
	}
}
function hepsini_sec()
{
	select_all('customer_type');
	return true;
}
</script>
<cfif isdefined("attributes.is_submitted")>
	<cfset url_str = "#url_str#&is_submitted=1">
</cfif>
<cfif len(attributes.hedefkodu)>
	<cfset url_str = "#url_str#&hedefkodu=#attributes.hedefkodu#">
</cfif>
<cfif len(attributes.glncode)>
	<cfset url_str = "#url_str#&glncode=#attributes.glncode#">
</cfif>
<cfif len(attributes.branch_state)>
	<cfset url_str = "#url_str#&branch_state=#attributes.branch_state#">
</cfif>
<cfif len(attributes.fullname)>
	<cfset url_str = "#url_str#&fullname=#attributes.fullname#">
</cfif>
<cfif len(attributes.pro_rows)>
	<cfset url_str = "#url_str#&pro_rows=#attributes.pro_rows#">
</cfif>
<cfif len(attributes.cp_name)>
	<cfset url_str = "#url_str#&cp_name=#attributes.cp_name#">
</cfif>
<cfif len(attributes.cp_surname)>
	<cfset url_str = "#url_str#&cp_surname=#attributes.cp_surname#">
</cfif>
<cfif len(attributes.ims_code_id)>
	<cfset url_str = "#url_str#&ims_code_id=#attributes.ims_code_id#">
</cfif>
<cfif len(attributes.ims_code_name)>
	<cfset url_str = "#url_str#&ims_code_name=#attributes.ims_code_name#">
</cfif>
<cfif len(attributes.ekip)>
	<cfset url_str = "#url_str#&ekip=#attributes.ekip#">
</cfif>
<cfif len(attributes.vergi_no)>
	<cfset url_str = "#url_str#&vergi_no=#attributes.vergi_no#">
</cfif>
<cfif len(attributes.customer_type)>
	<cfset url_str = "#url_str#&customer_type=#attributes.customer_type#">
</cfif>
<cfif len(attributes.customer_type_id)>
	<cfset url_str = "#url_str#&customer_type_id=#attributes.customer_type_id#">
</cfif>
<cfif len(attributes.city)>
	<cfset url_str = "#url_str#&city=#attributes.city#">
</cfif>
<cfif len(attributes.citycode)>
	<cfset url_str = "#url_str#&citycode=#attributes.citycode#">
</cfif>
<cfif len(attributes.county)>
	<cfset url_str = "#url_str#&county=#attributes.county#">
</cfif>
<cfif len(attributes.county_id)>
	<cfset url_str = "#url_str#&county_id=#attributes.county_id#">
</cfif>
<cfif len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif len(attributes.is_active)>
	<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
</cfif>
