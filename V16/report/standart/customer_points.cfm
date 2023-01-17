<cfparam name="attributes.module_id_control" default="14">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.companycat_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="0">
<cfinclude template="../../member/query/get_company_cat.cfm">
<cfinclude template="../../member/query/get_country.cfm">
<cfform name="theForm" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
<input type="hidden" name="is_submitted" id="is_submitted" value="1">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='40562.Müşteri Puanları'></cfsavecontent>
<cf_report_list_search title="#title#">
    <cf_report_list_search_area>
		<div class="row">
            <div class="col col-12 col-xs-12">
                    <div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
										<div class="col col-12 col-xs-12">
											<cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:180px">
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
										<div class="col col-12 col-xs-12">
											<select name="companycat_id" id="companycat_id">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_companycat">
													<option value="#companycat_id#" <cfif attributes.companycat_id eq companycat_id> selected</cfif>>#companycat#</option>
												</cfoutput>
											</select>	
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58219.Ülke'></label>
										<div class="col col-12 col-xs-12">
											<select name="country" id="country" tabindex="25" onchange="LoadCity(this.value,'city_id','county_id',0)"> 
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_country">
												<option  value="#get_country.country_id#"<cfif (is_default eq 1 and not isdefined("attributes.is_submitted")) or (isdefined("attributes.is_submitted") and attributes.country eq country_id)>selected</cfif>>#get_country.country_name#</option>
												</cfoutput>
											</select>				
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
										<div class="col col-12 col-xs-12">
											<cfif isdefined('attributes.city_id') and len(attributes.city_id)>
											<cfquery name="GET_CITY" datasource="#DSN#">
												SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
											</cfquery>
											<select name="city_id" id="city_id" tabindex="26" onchange="LoadCounty(this.value,'county_id','telcod')">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="GET_CITY">
													<option value="#city_id#" <cfif city_id eq attributes.city_id>selected</cfif>>#city_name#</option>
												</cfoutput>
											</select>
										<cfelse>
											<select name="city_id" id="city_id" tabindex="27" onchange="LoadCounty(this.value,'county_id','telcod')">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											</select>
										</cfif>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58638.İlçe'></label>
										<div class="col col-12 col-xs-12">
											<select name="county_id" id="county_id" tabindex="28">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>						
												<cfif isdefined('attributes.county_id') and len(attributes.county_id)>
													<cfquery name="GET_COUNTY" datasource="#DSN#">
														SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY
													</cfquery>
													<cfoutput query="get_county">
														<option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
													</cfoutput>
												</cfif>
											</select>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				<div class="row ReportContentBorder">
					<div class="ReportContentFooter">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
						<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
						</cfif>
						<cf_wrk_report_search_button button_type='1' is_excel='1'>
					</div>
				</div>
			</div>
		</div>
    </cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_submitted")>
<cf_report_list>
	<cfquery name="get_points" datasource="#dsn#">
		SELECT
			CP.COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME,
			C.NICKNAME,
			CPP.*
		FROM
			COMPANY_PARTNER CP,
			COMPANY C,
			COMPANY_PARTNER_POINTS CPP
		WHERE
			<cfif len(attributes.keyword)>
				(
				C.NICKNAME LIKE '%#attributes.keyword#%' OR
				CP.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' OR 
				CP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%'
				)
				AND
			</cfif>
			<cfif len(attributes.country)>
				C.COUNTRY = #attributes.country# AND
			</cfif>
			<cfif len(attributes.city_id)>
				C.CITY = #attributes.city_id# AND
			</cfif>
			CPP.PARTNER_ID = CP.PARTNER_ID AND
			CP.COMPANY_ID = C.COMPANY_ID
	</cfquery>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.totalrecords" default=#get_points.recordcount#>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<thead>
        <tr> 
			<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57585.Kurumsal Üye'></th>
			<th width="100"><cf_get_lang dictionary_id='57631.Ad'></th>
			<th width="100"><cf_get_lang dictionary_id='58726.Soyad'></th>
			<th width="200"><cf_get_lang dictionary_id='57776.Toplam Puan'></th>
			<th width="100"><cf_get_lang dictionary_id='40561.Harcadığı Puan'></th>
			<th width="100"><cf_get_lang dictionary_id='40560.Kalan Puan'></th>
		</tr>
        </thead>
        <tbody>
		<cfif get_points.recordcount>
			<cfoutput query="get_points" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<thead>
				<tr>
					<td>#currentrow#</td>
					<td>#nickname#</td>
					<td>#COMPANY_PARTNER_NAME#</td>
					<td>#COMPANY_PARTNER_SURNAME#</td>
					<td><cfif len(USER_POINT)>#USER_POINT#</cfif></td>
					<td><cfif len(USED_USER_POINT)>#USED_USER_POINT#</cfif></td>
					<td><cfif len(USED_USER_POINT)>#USER_POINT - USED_USER_POINT#<cfelse>#USER_POINT#</cfif></td>
				</tr>
			</thead>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '>!</cfif></td>
			</tr>
		</cfif>
        </tbody>

	<cfif attributes.totalrecords gt attributes.maxrows>
		<!-- sil --><cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction#&is_submitted=1&keyword=#attributes.keyword#&companycat_id=#attributes.companycat_id#&city_id=#attributes.city_id#&country=#attributes.country#"><!-- sil -->		
	</cfif>
</cf_report_list>
</cfif>
<cfif not isdefined("attributes.city_id")>
<script type="text/javascript">
	var country_ = document.form_.country.value;
	if(country_.length)
		LoadCity(country_,'city_id','county_id',0);
</script>
</cfif>
