<cfset url_string = "">
<cfif isdefined("attributes.keyword")>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.comp_cat")>
	<cfset url_string = "#url_string#&comp_cat=#comp_cat#">
</cfif>
<cfif isdefined("attributes.search_type")>
	<cfset url_string = "#url_string#&search_type=#search_type#">
</cfif>
<cfif isdefined("attributes.search_status")>
	<cfset url_string = "#url_string#&search_status=#search_status#">
</cfif>
<cfif isdefined("attributes.search_potential")>
	<cfset url_string = "#url_string#&search_potential=#search_potential#">
</cfif>
<cfif isdefined("attributes.sz_id")>
	<cfset url_string = "#url_string#&sz_id=#attributes.sz_id#">
</cfif>
<cfquery name="GET_COMPANY_CAT_" datasource="#DSN#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT_" datasource="#DSN#">
	SELECT CONSCAT_ID, CONSCAT FROM CONSUMER_CAT
</cfquery>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		C.FULLNAME,
		C.COMPANYCAT_ID,
		C.MANAGER_PARTNER_ID,
		C.ISPOTANTIAL,
		C.COMPANY_EMAIL,
		C.COMPANY_TEL1,
		C.COMPANY_FAX,
		C.COMPANY_TELCODE,
		(	SELECT
					POSITION_CODE 
				FROM
					WORKGROUP_EMP_PAR
				WHERE
					IS_MASTER = 1 AND
					OUR_COMPANY_ID = #session.ep.company_id# AND 
					COMPANY_ID = C.COMPANY_ID AND
					COMPANY_ID IS NOT NULL
			) POSITION_CODE
	FROM
		COMPANY C
	WHERE
		C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#">
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
	</cfif>
</cfquery>
<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		REF_POS_CODE,
		CONSUMER_EMAIL,
		CONSUMER_WORKTELCODE,
		CONSUMER_WORKTEL,
		CONSUMER_WORKTELCODE,
		CONSUMER_FAXCODE,
		CONSUMER_FAX,
		CONSUMER_CAT_ID,
		ISPOTANTIAL,
		(SELECT
				POSITION_CODE 
			FROM
				WORKGROUP_EMP_PAR
			WHERE
				IS_MASTER = 1 AND
				OUR_COMPANY_ID = #session.ep.company_id# AND 
				CONSUMER_ID = CONSUMER.CONSUMER_ID AND
				CONSUMER_ID IS NOT NULL
		) POSITION_CODE
	FROM
		CONSUMER
	WHERE
		SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#">
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME LIKE #sql_unicode()#'%#attributes.keyword#%'
	</cfif>
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_potential" default="0">
<cfparam name="attributes.search_status" default=1>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_company.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" action="#request.self#?fuseaction=salesplan.popup_list_sales_company&sz_id=#attributes.sz_id#" method="post">
<cf_box title="#getLang('','Kurumsal Üyeler',29408)#">
	<cf_grid_list>
		<div class="row">
			<div class="row form-inline">
				<div class="form-group" id="item-keyword">
					<div class="col col-12 col-xs-12">
						<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
					</div>
				</div>		
				<div class="form-group x-5">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button>
				</div>
			</div>
		</div>
	</cf_grid_list>
	<cf_grid_list>
		<cfset sayac = 0>
			<thead>
				<tr>
					<th width="25"><cf_get_lang dictionary_id='57496.No'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='29511.Yönetici'></th>
					<!-- sil -->
					<th><cf_get_lang dictionary_id='57908.Temsilci'></th>
					<th width="75"><cf_get_lang dictionary_id='57577.Potansiyel'></th>
					<th width="80"><cf_get_lang dictionary_id='58143.İletişim'></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_company.recordcount>
					<cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfquery name="GET_COMPANY_CAT" dbtype="query">
							SELECT COMPANYCAT_ID, COMPANYCAT FROM GET_COMPANY_CAT_ WHERE COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#companycat_id#">
						</cfquery>
						<tr>
							<td width="25">#currentrow#</td>
							<td>#fullname#</td>
							<td>#get_company_cat.companycat#</td>
							<td><cfif isdefined("manage_partner_id") and len(manage_partner_id) and manage_partner_id neq 0>#get_par_info(manage_partner_id,0,-1,0)#<cfelse><cf_get_lang no='111.Tanımlı Değil'> </cfif></td>
							<!-- sil -->
							<td><cfif isdefined("position_code") and len(position_code)>#get_emp_info(get_company.position_code,1,1)#<cfelse><cf_get_lang no='111.Tanımlı Değil'></cfif></td>
							<td><cfif ispotantial eq 0><cf_get_lang dictionary_id='58061.Potansiyel'><cfelse><cf_get_lang dictionary_id='57577.Cari'></cfif></td>
							<td>
								<div class="form-group">
									<cfif len(company_email)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&special_mail=#company_email#','list')"><i class="fa fa-envelope" title="<cf_get_lang no='113.Mail Olarak Yolla'>" border="0"></i></a></cfif>
									<cfif len(company_tel1)><a href="javascript://"><i class="fa fa-phone" border="0" title="Telefon:#company_telcode# - #company_tel1#"></i></a></cfif>
									<cfif len(company_fax)><a href="javascript://"><i class="fa fa-fax"  title="Fax:#company_telcode# - #company_fax#" border="0"></i></a></cfif>
								</div>								
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
</cf_box>
</cfform>

<br/>
<cf_box title="#getLang('','Bireysel Üyeler',29406)#">
	<cf_grid_list>
		<thead>
				<tr>
					<th width="25"><cf_get_lang dictionary_id='57496.No'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='58636.Referans Uye'> </th>
					<th><cf_get_lang dictionary_id='37134.Referans Kod'></th>
					<th><cf_get_lang dictionary_id='57577.Potansiyel'></th>
					<th><cf_get_lang dictionary_id='58143.İletişim'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_consumer.recordcount>
					<cfoutput query="get_consumer" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfquery name="GET_CONSUMER_CAT" dbtype="query">
							SELECT CONSCAT FROM GET_CONSUMER_CAT_ WHERE CONSCAT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_cat_id#">
						</cfquery>
						<tr>
							<td width="25">#currentrow#</td>
							<td>#consumer_name# #consumer_surname#</td>
							<td>#get_consumer_cat.conscat#</td>
							<td><cfif len(get_consumer.ref_pos_code) >#get_cons_info(get_consumer.ref_pos_code,0,0)#</cfif></td>
							<td></td>
							<td><cfif ispotantial eq 0><cf_get_lang dictionary_id='58061.Cari'><cfelse><cf_get_lang dictionary_id='57577.Potansiyel'></cfif></td>
							<td><cfif len(consumer_email)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&special_mail=#consumer_email#','list')"><span class="fa fa-envelope" title="<cf_get_lang no='113.Mail Olarak Yolla'>" border="0"></span></a></cfif>
							<cfif len(consumer_worktel)><span class="fa fa-phone" border="0" title="Telefon:#consumer_worktelcode# - #consumer_worktel#"></span></cfif>
							<cfif len(consumer_fax)>&nbsp;<span class="fa fa-fax"  title="Fax:#consumer_faxcode# - #consumer_fax#" border="0"></cfif></span></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
</cf_box>

<br/>
<cfif attributes.totalrecords gt attributes.maxrows and get_company.recordcount>
	<table width="99%" align="center">
		<tr>
			<td>
				<cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="salesplan.popup_list_sales_company#url_string#">
			</td>
			<!-- sil -->
			<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='59064.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
		</tr>
	</table>
</cfif>
