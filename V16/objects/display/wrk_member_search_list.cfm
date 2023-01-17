<cfparam name="attributes.boxwidth" default="200"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.boxTitle" default="Projeler"><!--- Divin üzerinde gelen başlık.. --->
<cfparam name="attributes.period_id" default="10">
<cfparam name="attributes.listPage" default="0">
<cfparam name="attributes.wrk_member_type" default="2"> <!--- 1:çalışanlar,2:kurumsal üyeler,3:bireysel üyeler --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.updPageUrl" default="">
<cfparam name="attributes.addPageUrl" default="">
<cfscript>
	url_str = '';
	url_str = '#url_str#&boxwidth=#attributes.boxwidth#';
	url_str = '#url_str#&boxheight=#attributes.boxheight#';
	url_str = '#url_str#&boxTitle=#attributes.boxTitle#';
	url_str = '#url_str#&select_list=#attributes.select_list#';
	url_str = '#url_str#&listPage=#attributes.listPage#';
</cfscript>
<table border="0" cellpadding="2" cellspacing="1" align="center" width="98%" height="35" class="color-header">
	<tr class="color-list">
		<td>
        <cfform name="member_search_form" action="">
            <div style="position:absolute;">
			<cfoutput>
                <select name="categories" id="categories" onChange="change_member_list(this.value)">
                <cfif listcontainsnocase(attributes.select_list,1)>
                    <option value="1" <cfif attributes.wrk_member_type eq 1>selected</cfif>>#attributes.select_list#-<cf_get_lang dictionary_id='58875.Calisanlar'></option>
                </cfif>
                <cfif listcontainsnocase(attributes.select_list,2)>
                    <option value="2" <cfif attributes.wrk_member_type eq 2>selected</cfif>>#attributes.select_list#-<cf_get_lang dictionary_id='32995.C Kurumsal Uyeler'></option>
                </cfif>
                <cfif listcontainsnocase(attributes.select_list,3)>
                    <option value="3" <cfif attributes.wrk_member_type eq 3>selected</cfif>>#attributes.select_list#-<cf_get_lang dictionary_id='32996.C Bireysel Uyeler'></option>
                </cfif>
                </select>
            </cfoutput>
            </div>
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<cfif isdefined('attributes.wrk_member_type') and attributes.wrk_member_type eq 1><!--- çalışanlar listesi filteleri --->
				<cfparam name="attributes.compenent_name" default="getConsumer"><!--- compenentid --->
				<cfset attributes.boxTitle="Çalışanlar">
				<cfparam name="attributes.dsp_branch" default="1">
				<cfparam name="attributes.branch_id" default="">
				<cfif isdefined("attributes.tree_category_id") and len(attributes.tree_category_id)>
					<cfparam name="attributes.dsp_tree_category" default="1">
				<cfelse>
					<cfparam name="attributes.dsp_tree_category" default="0">
				</cfif>
				<table width="100%" border="0">
					<tr valign="top">
						<td style="text-align:right;">
							<cf_get_lang dictionary_id='57460.Filtre'>&nbsp;
							<cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:80px;">
							<cfif isdefined('attributes.dsp_branch') and attributes.dsp_branch eq 1>
								<cfquery name="get_branches" datasource="#dsn#">
									SELECT 
										BRANCH.BRANCH_NAME,
										BRANCH.BRANCH_ID	
									FROM 
										BRANCH
									WHERE 
										BRANCH_ID IS NOT NULL
										<cfif isDefined("attributes.our_cid")>AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"></cfif>
										<cfif isdefined("attributes.branch_related")>AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)</cfif>
									ORDER BY
										BRANCH_NAME
								</cfquery>
								&nbsp;&nbsp;
								<select name="branch_id" id="branch_id" style="width:120px;">
									<option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
									<cfoutput query="get_branches">
										<option value="#branch_id#"<cfif branch_id eq attributes.branch_id> selected</cfif>>#branch_name#</option>
									</cfoutput>
								</select>
							</cfif>
						<!--- prnet icin --->
							<cfif isdefined("attributes.dsp_tree_category") and attributes.dsp_tree_category eq 1>
							&nbsp;&nbsp;<select name="sub_tree_category_id" id="sub_tree_category_id" style="width:160px;">
								<option value="0" <cfif isdefined('attributes.sub_tree_category_id') and attributes.sub_tree_category_id eq 0>selected</cfif>><cf_get_lang dictionary_id='34274.Alt Tree Yetkilisine Bakmasın'></option>
								<option value="1" <cfif not isdefined('attributes.sub_tree_category_id') or attributes.sub_tree_category_id eq 1>selected</cfif>><cf_get_lang dictionary_id='34275.Alt Tree Yetkilisine Baksın'></option>
							</select>
							</cfif>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							&nbsp;&nbsp;<cfinput type="text" name="maxrows" required="yes" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							&nbsp;&nbsp;<cf_wrk_search_button search_function='call_list_page()'>
						</td>
					</tr>
				</table>
			<cfelseif isdefined('attributes.wrk_member_type') and attributes.wrk_member_type eq 2><!--- kurumsal üyeler listesi filteleri --->
				<cfparam name="attributes.compenent_name" default="getCompany"><!--- compenentid --->
				<!--- attribute değerler... --->
				<cfparam name="attributes.keyword_partner" default="">
				<cfparam name="attributes.sector_cat_id" default="">
				<cfparam name="attributes.customer_value_id" default="">
				<cfparam name="attributes.comp_cat" default="">
				<cfparam name="attributes.sz_id" default="">
				<cfparam name="attributes.sales_zones" default="">
				<cfparam name="attributes.pos_code" default="">
				<cfparam name="attributes.pos_code_text" default="">
				<cfparam name="attributes.period_id" default="">
				<cfparam name="attributes.is_buyer_seller" default="">
				<cfparam name="attributes.customer_value" default="">
				
				<!--- filtre alanlarının display degerleri --->
				<cfparam name="attributes.dsp_kywrd" default="1">
				<cfparam name="attributes.dsp_prtnr_kywrd" default="1">
				<cfparam name="attributes.dsp_comp_cat" default="1">
				<cfparam name="attributes.dsp_sector_catid" default="1">
				<cfparam name="attributes.dsp_customer_value" default="1">
				<cfparam name="attributes.dsp_buyer_seller" default="1">
				<cfparam name="attributes.dsp_sz_id" default="1">
				<cfparam name="attributes.dsp_pos_code" default="1">
				<cfparam name="attributes.dsp_period" default="1">
				<!--- <cfdump var="#attributes#"> --->

				<cfset attributes.boxTitle="Kurumsal Üyeler">
				<cfscript>
					/*parametrelerden sadece 0 olan yani listede gosterilmesi istenmeyenler wrk_search sayfasına gonderiliyor*/
					/*if(len(attributes.CompNo) and attributes.CompNo eq 1)
						url_str = '#url_str#&CompNo=#attributes.CompNo#';
					if(len(attributes.CompName) and attributes.CompName eq 1)
						url_str = '#url_str#&CompName=#attributes.CompName#';
					if(len(attributes.PrtnrName) and attributes.PrtnrName eq 1)
						url_str = '#url_str#&PrtnrName=#attributes.PrtnrName#';
					if(len(attributes.CompCity) and attributes.CompCity eq 1)
						url_str = '#url_str#&CompCity=#attributes.CompCity#';
					if(len(attributes.CompCat) and attributes.CompCat eq 1)
						url_str = '#url_str#&CompCat=#attributes.CompCat#';
					if(len(attributes.CompExtre) and attributes.CompExtre eq 1)
						url_str = '#url_str#&CompExtre=#attributes.CompExtre#';
					if(len(attributes.CompInfo) and attributes.CompInfo eq 1)
						url_str = '#url_str#&CompInfo=#attributes.CompInfo#';
					if(len(attributes.AddComp) and attributes.AddComp eq 1)
						url_str = '#url_str#&AddComp=#attributes.AddComp#';*/

					defaultColumnList="COMPANY_ID@NO,COMPANY_NAME@Cari Hesap";
					columnList='';
					'lang_COMPANY_ID' = 'NO';
					'lang_COMPANY_NAME' = 'Cari Hesap';
					'lang_PARTNER_NAME' = 'Ad Soyad';
					'lang_CITY' = 'Şehir';
					'lang_COMPANYCAT' = 'Kategori';
						
					StructList = StructKeyList(attributes,',');
					compenent_url = '';
					for(arg_ind=1;arg_ind lte listlen(StructList,',');arg_ind=arg_ind+1){
						object_ = ListGetAt(StructList,arg_ind,',');
						object_value = Evaluate("attributes.#object_#");
						if(object_ neq 'FUSEACTION'){
						if((object_ is 'COMPANY_ID' or object_ is 'COMPANY_NAME' or object_ is 'PARTNER_NAME' or object_ is 'CITY' or object_ is 'COMPANYCAT') and object_value gt 0)
							columnList = ListAppend(columnList,"#object_#@#Evaluate("lang_#object_#")#",',');
						else
							if(len(object_value))
								compenent_url='#compenent_url#&#object_#=#object_value#';
						}		
					}
					newColumnList='';//alanları sıralamak için yeni bir columnlist tanımlıyoruz..
					if(listlen(columnList,',')){
						newColumnList = ArrayNew(1);
						for(clind=1;clind lte listlen(columnList,',');clind=clind+1){
							columnName = ListGetAt(ListGetAt(columnList,clind,','),1,'@');
							if(isdefined("attributes.#columnName#")){
								newColumnList[Evaluate("attributes.#columnName#")] ='#ListGetAt(columnList,clind,',')#';
							}	
						}
						newColumnList = ArrayToList(newColumnList,',');
					}
					newColumnList='#defaultColumnList#,#newColumnList#';
					compenent_url = '#compenent_url#&columnList=#newColumnList#';
					
				</cfscript>
				<table width="100%">
				<tr valign="top">
					<td style="text-align:right;">
						<cf_get_lang dictionary_id='58585.Kod'> - <cf_get_lang dictionary_id='57574.Şirket'>
						<cfset attributes.keyword=''>
						<cfinput type="text" name="keyword" id="comp_keyword" value="#attributes.keyword#" maxlength="255" style="width:120px;">
						<cfif isdefined('attributes.dsp_prtnr_kywrd') and attributes.dsp_prtnr_kywrd eq 1>
							<cf_get_lang dictionary_id='57576.Çalışan'>
							<cfinput type="text" name="keyword_partner" value="#attributes.keyword_partner#" maxlength="255" style="width:120px;">
						</cfif>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="" required="yes" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" style="width:25px;">
						<cf_wrk_search_button search_function="call_list_page('#compenent_url#')">
						<a href="javascript:history.go(-1);"><img src="/images/back.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57432.Geri'>"></a>		  
					</td>
				</tr>
				<tr>
					<td style="text-align:right;">
						<cfif isdefined('attributes.dsp_period') and attributes.dsp_period eq 1 and fusebox.use_period eq 1>
							<cfquery name="GET_PERIOD" datasource="#DSN#">
								SELECT
									OUR_COMPANY.COMP_ID,
									OUR_COMPANY.COMPANY_NAME,
									SETUP_PERIOD.PERIOD_ID,
									SETUP_PERIOD.PERIOD
								FROM
									SETUP_PERIOD,
									OUR_COMPANY,
									EMPLOYEE_POSITION_PERIODS EPP
								WHERE 
									EPP.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
									EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid# AND IS_MASTER = 1) AND
									SETUP_PERIOD.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID 
								ORDER BY 
									OUR_COMPANY.COMPANY_NAME,
									SETUP_PERIOD.PERIOD_YEAR
							</cfquery>
							<cfset period_id_list = listsort(listdeleteduplicates(valueList(get_period.period_id,',')),'numeric','ASC',',')>
							<cfquery name="GET_COMP" dbtype="query">
								SELECT DISTINCT COMP_ID,COMPANY_NAME FROM GET_PERIOD ORDER BY COMPANY_NAME
							</cfquery>
							<select name="period_id" style="width:175px;" id="comp_period_id">
							<option value=""><cf_get_lang dictionary_id ='33596.Dönem'></option>
							<cfset totalvalue = 0>
							<cfoutput query="get_comp">
								<cfset totalvalue = totalvalue + 1>
								<cfquery name="GET_PERIODID" dbtype="query">
									SELECT * FROM GET_PERIOD WHERE COMP_ID = #comp_id#
								</cfquery>
								<option value="#totalvalue#,0,#comp_id#,0" <cfif len(attributes.period_id) and  listgetat(attributes.period_id,1,',') eq totalvalue>selected</cfif>>#company_name#</option>
								<cfloop query="get_periodid">
									<cfset totalvalue = totalvalue + 1>
									<option value="#totalvalue#,1,#comp_id#,#period_id#" <cfif len(attributes.period_id) and listgetat(attributes.period_id,1,',') eq totalvalue>selected</cfif>>&nbsp;&nbsp;&nbsp;#period#</option>
								</cfloop>
							</cfoutput>
							</select>
						</cfif>
						<cfif isdefined('attributes.dsp_sector_catid') and attributes.dsp_sector_catid eq 1><!--- sektörler --->
							<cfquery name="GET_COMPANY_SECTOR" datasource="#dsn#">
								SELECT * FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT ASC
							</cfquery>
							<select name="sector_cat_id" style="width:150px;" id="comp_sector_cat_id">
								<option value=""><cf_get_lang dictionary_id='33222.Sektörler'>
								<cfoutput query="get_company_sector">
									<option value="#sector_cat_id#"<cfif sector_cat_id eq attributes.sector_cat_id>selected</cfif>>#sector_cat#</option>
								</cfoutput>
							</select>
						</cfif>
						<cfif isdefined('attributes.dsp_comp_cat') and attributes.dsp_comp_cat eq 1>
							<cfquery name="GET_COMP_CAT" datasource="#DSN#">
								SELECT 
									DISTINCT
									CT.COMPANYCAT_ID, 
									CT.COMPANYCAT
								FROM
									COMPANY_CAT CT,
									COMPANY_CAT_OUR_COMPANY CO
								WHERE
									CT.COMPANYCAT_ID = CO.COMPANYCAT_ID AND
									CO.OUR_COMPANY_ID IN (SELECT DISTINCT	SP.OUR_COMPANY_ID
															FROM
																EMPLOYEE_POSITIONS EP,
																SETUP_PERIOD SP,
																EMPLOYEE_POSITION_PERIODS EPP,
																OUR_COMPANY O
															WHERE 
																SP.OUR_COMPANY_ID = O.COMP_ID AND
																SP.PERIOD_ID = EPP.PERIOD_ID AND
																EP.POSITION_ID = EPP.POSITION_ID AND
																EP.EMPLOYEE_ID = #session.ep.userid#)
								ORDER BY
									COMPANYCAT
							</cfquery>
							<select name="comp_cat" style="width:120px;" id="comp_cat">
								<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
								<cfoutput query="get_comp_cat">
									<option value="#get_comp_cat.companycat_id#" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat eq get_comp_cat.companycat_id>selected</cfif>>#get_comp_cat.companycat#</option>
								</cfoutput>
							</select>
						</cfif>
						<cfif isdefined('attributes.dsp_sz_id') and attributes.dsp_sz_id eq 1><!--- satış bölgesi filtresi --->
							<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
								SELECT SZ_ID, SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
							</cfquery>
							<select name="sales_zones" style="width:100px;" id="comp_sales_zones">
							<option value=""><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>
							<cfoutput query="get_sales_zones">
								<option value="#sz_id#" <cfif isdefined("attributes.sales_zones") and sz_id eq attributes.sales_zones> selected</cfif>>#sz_name#</option>

							</cfoutput>
							</select>
						</cfif>
					</td>
				</tr>
				<tr>
					<td  style="text-align:right;">
						<cfif isdefined('attributes.dsp_pos_code') and attributes.dsp_pos_code eq 1>
							<cf_get_lang dictionary_id='57908.Temsilci'>
							<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code) and len(attributes.pos_code_text)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
							<input type="text" name="pos_code_text" id="pos_code_text" value="<cfif len(attributes.pos_code) and len(attributes.pos_code_text)><cfoutput>#attributes.pos_code_text#</cfoutput></cfif>" style="width:120px;">						
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_par.pos_code&field_name=search_par.pos_code_text&select_list=1','list','popup_list_positions');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						</cfif>
						<cfif isdefined('attributes.dsp_pos_code') and attributes.dsp_pos_code eq 1>
							<cfquery name="GET_CITY_NAME" datasource="#DSN#">
								SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
							</cfquery>
							<select name="city_name" style="width:125px;" id="comp_city_name">
							<option value=""><cf_get_lang dictionary_id='57971.Şehir'></option>
							<cfoutput query="get_city_name">
								<option value="#city_id#" <cfif isdefined("attributes.city_name") and city_id eq attributes.city_name>selected</cfif>>#city_name#</option>
							</cfoutput>
							</select>
						</cfif>
						<cfif isdefined('attributes.dsp_customer_value') and attributes.dsp_customer_value eq 1>
							<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
								SELECT
									CUSTOMER_VALUE_ID,
									CUSTOMER_VALUE 
								FROM
									SETUP_CUSTOMER_VALUE
								ORDER BY
									CUSTOMER_VALUE
							</cfquery>
							<select name="customer_value" style="width:100px;" id="comp_customer_value">
							<option value=""><cf_get_lang dictionary_id='58552.Müşteri Değeri'></option>
							<cfoutput query="get_customer_value">
								<option value="#customer_value_id#" <cfif isdefined("attributes.customer_value") and customer_value_id eq attributes.customer_value>selected</cfif>>#customer_value#</option>
							</cfoutput>
							</select>
						</cfif>
						<cfif isdefined('attributes.dsp_buyer_seller') and attributes.dsp_buyer_seller eq 1>
							<select name="is_buyer_seller" style="width:60px;" id="comp_buyer_seller">
								<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
								<option value="0" <cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 0>selected</cfif>><cf_get_lang dictionary_id='58733.Alıcı'></option>
								<option value="1" <cfif isdefined("attributes.is_buyer_seller") and attributes.is_buyer_seller eq 1>selected</cfif>><cf_get_lang dictionary_id='58873.Satıcı'></option>
							</select>
						</cfif>
					</td>
				</tr>
			</table>
			<cfelseif isdefined('attributes.wrk_member_type') and attributes.wrk_member_type eq 3><!--- bireysel üyeler listesi filteleri --->
				<cfparam name="attributes.compenent_name" default="getEmployee"><!--- compenentid --->
				<cfparam name="attributes.ref_code_name" default="">
				<cfparam name="attributes.ref_code" default="">
				<cfparam name="attributes.period_id" default="">
				<cfparam name="attributes.search_status" default=1>
				<cfparam name="attributes.dsp_cons_status" default="1">
				<cfparam name="attributes.dsp_cons_period" default="1">
				<cfparam name="attributes.dsp_cons_cat" default="1">
				<cfparam name="attributes.dsp_cons_ref_code" default="1">
				<cfif fusebox.fuseaction contains "popup_list_all_cons">
					<cfparam name="attributes.type" default="">
				<cfelseif fusebox.fuseaction contains "popup_list_pot_cons">
					<cfparam name="attributes.type" default="1">
				<cfelse>
					<cfparam name="attributes.type" default="0">
				</cfif>
				<cfset attributes.boxTitle="Bireysel Üyeler">
				<table width="100%">
							<tr valign="top">
								<td style="text-align:right;">
								<cf_get_lang dictionary_id='57460.Filtre'>
								<cfinput type="text" maxlength="255" value="#attributes.keyword#" name="keyword" style="width:100px;">
								&nbsp;<cf_get_lang dictionary_id ='33915.Üye Kodu'>
								<input type="text" maxlength="100" value="<cfif isdefined("attributes.member_code")><cfoutput>#attributes.member_code#</cfoutput></cfif>" name="member_code" id="identity_no" style="width:80px;">
								&nbsp;<cf_get_lang dictionary_id ='58627.Kimlik No'>
								<input type="text" maxlength="100" value="<cfif isdefined("attributes.identity_no")><cfoutput>#attributes.identity_no#</cfoutput></cfif>" name="identity_no" id="identity_no" style="width:80px;">
								<cfif isdefined('attributes.dsp_cons_status') and attributes.dsp_cons_status eq 1>&nbsp;&nbsp;
									<select name="search_status" id="search_status">			
										<option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
										<option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
										<option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
									</select>		
								</cfif>
								&nbsp;<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
									<cfinput type="text" name="maxrows" required="yes" maxlength="3" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#">
								&nbsp;<cf_wrk_search_button search_function='call_list_page()'>
								&nbsp;<a href="<cfoutput>#request.self#?fuseaction=objects.popup_form_add_consumer</cfoutput>"><img src="/images/plus1.gif" border="0" title="<cf_get_lang dictionary_id='29407.Bireysel Üye Ekle'>" align="absmiddle"></a>
								&nbsp;<a href="javascript:history.go(-1);"><img src="/images/back.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57432.Geri'>"></a>
								</td>
							</tr>
							<tr>
								<td style="text-align:right;">
								<cfif isdefined('attributes.dsp_cons_period') and attributes.dsp_cons_period eq 1 and fusebox.use_period>
									<cfquery name="GET_PERIOD" datasource="#DSN#">
										SELECT
											OUR_COMPANY.COMP_ID,
											OUR_COMPANY.COMPANY_NAME,
											SP.PERIOD_ID,
											SP.PERIOD
										FROM
											SETUP_PERIOD SP,
											OUR_COMPANY,
											EMPLOYEE_POSITION_PERIODS EPP
										WHERE 
											EPP.PERIOD_ID = SP.PERIOD_ID AND
											EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid# AND IS_MASTER = 1) AND
											SP.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID 
										ORDER BY 
											OUR_COMPANY.COMPANY_NAME,
											SP.PERIOD_YEAR
									</cfquery>
									<cfset period_id_list = listsort(listdeleteduplicates(valueList(get_period.period_id,',')),'numeric','ASC',',')>
									<cfquery name="GET_COMP" dbtype="query">
										SELECT DISTINCT COMP_ID,COMPANY_NAME FROM GET_PERIOD ORDER BY COMPANY_NAME
									</cfquery>	
									<select name="period_id" id="period_id" style="width:150px;">
										<option value=""><cf_get_lang dictionary_id='58472.Dönem'></option>
										<cfset totalvalue = 0>
										<cfoutput query="get_comp">
											<cfset totalvalue = totalvalue + 1>
											<cfquery name="GET_PERIODID" dbtype="query">
												SELECT * FROM GET_PERIOD WHERE COMP_ID = #comp_id#
											</cfquery>
											<option value="#totalvalue#,0,#comp_id#,0" <cfif len(attributes.period_id) and  listgetat(attributes.period_id,1,',') eq totalvalue>selected</cfif>>#company_name#</option>
											<cfloop query="get_periodid">
												<cfset totalvalue = totalvalue + 1>
												<option value="#totalvalue#,1,#comp_id#,#period_id#" <cfif len(attributes.period_id) and listgetat(attributes.period_id,1,',') eq totalvalue>selected</cfif>>&nbsp;&nbsp;&nbsp;#period#</option>
											</cfloop>
										</cfoutput>
									</select>
								</cfif>
								<cfif isdefined('attributes.dsp_cons_cat') and attributes.dsp_cons_cat eq 1>
									<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
										SELECT 
											DISTINCT
											CT.CONSCAT_ID, 
											CT.CONSCAT,
											CT.HIERARCHY
										FROM
											CONSUMER_CAT CT,
											CONSUMER_CAT_OUR_COMPANY CO
										WHERE
											CT.CONSCAT_ID = CO.CONSCAT_ID AND
											CO.OUR_COMPANY_ID IN (	SELECT 
																		DISTINCT
																		SP.OUR_COMPANY_ID
																	FROM
																		EMPLOYEE_POSITIONS EP,
																		SETUP_PERIOD SP,
																		EMPLOYEE_POSITION_PERIODS EPP,
																		OUR_COMPANY O
																	WHERE 
																		SP.OUR_COMPANY_ID = O.COMP_ID AND
																		SP.PERIOD_ID = EPP.PERIOD_ID AND
																		EP.POSITION_ID = EPP.POSITION_ID AND
																		EP.EMPLOYEE_ID = #session.ep.userid#
																)
										ORDER BY
											HIERARCHY
									</cfquery>
									&nbsp;&nbsp;<select name="consumer_cat" id="consumer_cat" style="width:140px;">
										<option value=""><cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'></option>
										<cfoutput query="get_consumer_cat">
										<option value="#get_consumer_cat.CONSCAT_ID#" <cfif isdefined("attributes.consumer_cat") and attributes.consumer_cat eq get_consumer_cat.CONSCAT_ID>selected</cfif>>#get_consumer_cat.CONSCAT#</option>
										</cfoutput>
									</select>
								</cfif>
								<cfif isdefined('attributes.dsp_cons_ref_code') and attributes.dsp_cons_ref_code eq 1>
									&nbsp;&nbsp;<cf_get_lang dictionary_id ='58636.Referans Üye'>
									<input type="hidden" name="ref_code" id="ref_code" value="<cfif len(attributes.ref_code) and len(attributes.ref_code_name)><cfoutput>#attributes.ref_code#</cfoutput></cfif>">
									<input name="ref_code_name" type="text"  id="ref_code_name" style="width:125px;" onFocus="AutoComplete_Create('ref_code_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_autocomplete','\'2\',\'\',0,0,0','CONSUMER_ID','ref_code','search_con','3','250');" value="<cfif len(attributes.ref_code) and len(attributes.ref_code_name)><cfoutput>#attributes.ref_code_name#</cfoutput></cfif>" autocomplete="off">
									<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=search_con.ref_code&field_name=search_con.ref_code_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=3'</cfoutput>,'list')"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0" align="absmiddle"></a>
								</cfif>
								</td>
							</tr>
						</table>
			</cfif>
		</cfform>
		</td>
	</tr>
	<tr class="color-row">
		<td>
			<div id="member_list_page">
				
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
<cfoutput>
	function change_member_list(page_type)
	{
	
		AjaxPageLoad('#request.self#?fuseaction=objects.popup_wrk_member_search&wrk_member_type='+page_type+'&comp_div_id=#attributes.comp_div_id#&#compenent_url#&#url_str#','#attributes.comp_div_id#',1);
	}
	function call_list_page(url_aaa)
	{	
		var page_url_str_='';
		<cfif attributes.wrk_member_type eq 2>
				page_url_str_= page_url_str_+'&keyword='+encodeURIComponent(document.getElementById("comp_keyword").value);
			if(document.getElementById("comp_period_id").value!='')
				page_url_str_= page_url_str_+'&period_id='+document.getElementById("comp_period_id").value;
			if(document.getElementById("sector_cat_id").value!='')
				page_url_str_= page_url_str_+'&sector_cat_id='+document.getElementById("sector_cat_id").value;
			if(document.getElementById("comp_cat").value!='')
				page_url_str_= page_url_str_+'&comp_cat='+document.getElementById("comp_cat").value;
			if(document.getElementById("sales_zones").value!='')
				page_url_str_= page_url_str_+'&sales_zones='+document.getElementById("sales_zones").value;
			if(document.getElementById("is_buyer_seller").value!='')
				page_url_str_= page_url_str_+'&is_buyer_seller='+document.getElementById("is_buyer_seller").value;
			if(document.getElementById("customer_value").value!='')
				page_url_str_= page_url_str_+'&customer_value='+document.getElementById("customer_value").value;
		</cfif>
		AjaxPageLoad('#request.self#?fuseaction=objects.popup_wrk_list_comp&comp_div_id=member_list_page'+url_aaa+''+page_url_str_+'&#url_str#',"member_list_page",1);
		return false;
	}
</script>
</cfoutput>
