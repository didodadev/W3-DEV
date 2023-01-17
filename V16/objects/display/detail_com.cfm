<cfif isDefined('session.ep.userid')>
	<cfif session.ep.member_view_control eq 1>
		<cfquery name="VIEW_CONTROL" datasource="#DSN#">
			SELECT
				IS_MASTER
			FROM
				WORKGROUP_EMP_PAR
			WHERE
				COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
				OUR_COMPANY_ID = #session.ep.company_id# AND
				POSITION_CODE = #session.ep.position_code#
		</cfquery>
		<cfif not view_control.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='33782.Bu Üyeyi Görmek İçin Yetkiniz Yok'>");
				window.close();
			</script>
		</cfif>
	</cfif>
	<cfinclude template="../query/get_com_det.cfm">
	<cfsavecontent variable="right_images_">
		<cfoutput>
			<li><a href="<cfoutput>#request.self#?fuseaction=member.form_list_company&event=det&cpid=#url.company_id#</cfoutput>" target="_blank" class="font-red-pink"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a></li>
		<cfif get_module_user(4) and get_module_user(37)>
			<li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=member.popup_list_comp_agenda&company_id=#attributes.company_id#');" class="font-red-pink"><i class="fa fa-hourglass-3" title="<cf_get_lang dictionary_id='33504.Toplantılar'>"></i></a></li>
		</cfif>
		<cfif (len(get_company.is_buyer) and get_company.is_buyer) or (len(get_company.is_seller) and get_company.is_seller)>
			<cfif  get_module_user(22)   and get_module_user(66)>
				<li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_periods&cpid=#url.company_id#','','ui-draggable-box-small')" class="font-red-pink"><i class="fa fa-hand-o-up" title="<cf_get_lang dictionary_id='33503.Muhasebe-Çalışma Dönemleri'>"></i></a></li>
			</cfif>
			<cfif isDefined('session.ep.userid')>
				<cfif get_module_user(23) and get_module_user(22) and not listfindnocase(denied_pages,'objects.popup_list_comp_extre')>
					<li><a href="#request.self#?fuseaction=ch.list_company_extre&popup_page=1&member_type=partner&member_id=#url.company_id#<cfif isdefined("attributes.is_store_module")>&is_store_module=1</cfif>" target="_blank" class="font-red-pink"><i class="fa fa-table" title="<cf_get_lang dictionary_id='57809.Hesap Ekstresi'>"></i></a></li>
				</cfif>
				<cfif get_module_user(33) and not listfindnocase(denied_pages,'report.bsc_company') and fusebox.use_period>
					<li><a href="#request.self#?fuseaction=report.popup_bsc_company&member_type=partner&company_id=#url.company_id#&member_name=#get_company.fullname#&finance=1" target="_blank" class="font-red-pink"><i class="fa fa-dashboard" title="<cf_get_lang dictionary_id ='33781.BSC Raporu'>"></i></a></li>
				</cfif>
				<cfif get_module_user(23) and get_module_user(22) and not listfindnocase(denied_pages,'objects.popup_list_comp_extre')>  
					<li><a href="#request.self#?fuseaction=ch.dsp_make_age&company_id=#url.company_id#" target="_blank" class="font-red-pink"><i class="fa fa-money" title="<cf_get_lang dictionary_id='57802.Ödeme Performansı'>"></i></a></li>
				</cfif> 
			</cfif>
		</cfif>		
		<cfif get_module_user(11) and session.ep.our_company_info.subscription_contract eq 1>
			<li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=member.popup_list_subscription_contract&cpid=#url.company_id#&member_name=#get_company.fullname#');" class="font-red-pink"><i class="fa fa-inbox" title="<cf_get_lang dictionary_id='30003.Aboneler'>"></i></a></li>
		</cfif>
		</cfoutput>
	</cfsavecontent>
	<cfparam name="attributes.modal_id" default="">
	<cf_box title="#get_company.fullname#" right_images="#right_images_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_elements>
			<cf_tab divID="sayfa_1,sayfa_2,sayfa_3,sayfa_4,sayfa_5,sayfa_6" defaultOpen="sayfa_1" divLang="#getLang('','Adres',58723)#-#getLang('','İletişim',58143)#;#getLang('','Şubeler',29434)#;#getLang('','Çalışanlar',58875)#;#getLang('','Banka Hesapları',59002)#;#getLang('','Finansal Özet',58085)#;#getLang('','Notlar',57422)#" afterFunction="pageload(1,unique_sayfa_1)|pageload(2,unique_sayfa_2)|pageload(3,unique_sayfa_3)|pageload(4,unique_sayfa_4)|pageload(5,unique_sayfa_5)|pageload(6,unique_sayfa_6)">
				<cfoutput>
					<div id="unique_sayfa_1" class="ui-info-text uniqueBox">
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cf_flat_list>
								<tr>
									<td>
										<cf_get_lang dictionary_id='57574.Şirket Adı'>
									</td>
									<td>
										#get_company.fullname#
									</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='57487.No'></td>
									<td>#get_company.member_code#</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='57486.Kategori'></td>
									<td>#get_company.companycat#</td>
								</tr>
								<tr>
									<cfif len(get_company.country) and isnumeric(get_company.country)>
										<cfquery name="GET_COUNTRY" datasource="#DSN#">
											SELECT COUNTRY_PHONE_CODE,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_company.country#
										</cfquery>
									</cfif>
									<td><cf_get_lang dictionary_id='29511.Yönetici'></td>
									<td>#get_manager.company_partner_name# #get_manager.company_partner_surname#</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='57499.Telefon'></td>
									<td><cfif len(get_company.country) and Len(get_country.country_phone_code)>(#get_country.country_phone_code#) </cfif><cf_santral tel="#get_company.company_telcode##get_company.company_tel1#"></cf_santral></td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
									<td>#get_company.taxoffice#</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='57499.Telefon'> 2</td>
									<td><cf_santral tel="#get_company.company_telcode##get_company.company_tel2#"></cf_santral></td>
								</tr>
								<cfquery name="get_tc_control" datasource="#DSN#">
									SELECT 
										CP.PARTNER_ID,
										CP.COMPANY_PARTNER_NAME,
										CP.COMPANY_PARTNER_SURNAME,
										CP.TC_IDENTITY
									FROM
										COMPANY_PARTNER CP, 
										COMPANY C
									WHERE 
										CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND 
										CP.COMPANY_ID = C.COMPANY_ID AND
										COMPANY_PARTNER_STATUS = 1
									ORDER BY 
										CP.COMPANY_PARTNER_NAME
								</cfquery>
								<cfquery name="get_tc" dbtype="query">
									SELECT TC_IDENTITY
									FROM get_tc_control
									WHERE PARTNER_ID = #get_company.manager_partner_id#
								</cfquery>
								<tr>
									<td><cf_get_lang dictionary_id='57752.Vergi No'></td>
									<td>#get_company.taxno#</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='57499.Telefon'> 3</td>
									<td><cf_santral tel="#get_company.company_telcode##get_company.company_tel3#"></td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='57579.Sektör'></td>
									<td>#get_company_sector.sector_cat#</td>
								</tr>
							</cf_flat_list>
						</div>	
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cf_flat_list>
								<tr>
									<td><cf_get_lang dictionary_id='57488.Faks'></td>
									<td>#get_company.company_fax#</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='58025.TC Kimlik No'></td>
									<td>#get_tc.tc_identity#</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='33288.Kod / Mobil'></td>
									<td><cf_santral mobile="#get_company.mobil_code##get_company.mobiltel#"></td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='57580.Buyukluk'></td>
									<td>#get_company_size.company_size_Cat#</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='57428.e-mail'></td>
									<td><a href="mailto:#get_company.company_email#" class="tableyazi">#get_company.company_email#</a></td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='57908.Temsilci'></td>
									<td>#get_employee_positions.employee_name# #get_employee_positions.employee_surname#</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='32481.İnternet'></td>
									<td><a href="#get_company.homepage#" target="_blank">#get_company.homepage#</a></td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='32482.Üst Şirket'></td>
									<td><cfif len(get_company.hierarchy_id)>#get_upper_company.nickname#</cfif></td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='58723.Adres'></td>
									<td>
										#get_company.company_address# #get_company.company_postcode# #get_company.semt#
										<cfif len(get_company.county) and isnumeric(get_company.county)>
											<cfquery name="GET_COUNTY" datasource="#DSN#">
												SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_company.county#
											</cfquery>
											#get_county.county_name#
										</cfif>				
										<cfif len(get_company.city) and isnumeric(get_company.city)>
											<cfquery name="GET_CITY" datasource="#DSN#">
												SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_company.city#
											</cfquery>
											#get_city.city_name#
										</cfif>
										<cfif len(get_company.country) and isnumeric(get_company.country)>
											#get_country.country_name#
										</cfif>
									</td>
								</tr>
							</cf_flat_list>
						</div>	
					</div>
					<div id="unique_sayfa_2" class="ui-info-text uniqueBox"></div>
					<div id="unique_sayfa_3" class="ui-info-text uniqueBox"></div>
					<div id="unique_sayfa_4" class="ui-info-text uniqueBox"></div>
					<div id="unique_sayfa_5" class="ui-info-text uniqueBox">
						<cfif fusebox.use_period>
							<cfset attributes.company = get_company.fullname>
							<cfset member_type = 'partner'>
							<cfinclude template="../../objects/display/dsp_extre_summary_popup.cfm">
						</cfif>
					</div>
					<div id="unique_sayfa_6" class="ui-info-text uniqueBox">
						<cf_get_workcube_note action_section='COMPANY_ID' action_id='#attributes.company_id#' style="1" no_border="1">
					</div>
				</cfoutput> 
			</cf_tab>
		</cf_box_elements>
	</cf_box>
<cfelse>
	<script>
		alert("<cf_get_lang dictionary_id='57532.Yetkiniz Yok'>!");
	</script>
</cfif>

<script>
function pageload(page)
{
	<cfoutput>
		if(page==2)
		{
			_link_ = 'unique_sayfa_2';
			var url_str = "#request.self#?fuseaction=objects.popup_detail_branches&company_id=#attributes.company_id#";
		}
		else if(page==3)
		{
			_link_ = 'unique_sayfa_3';
			var url_str = "#request.self#?fuseaction=objects.popup_detail_personnel&company_id=#attributes.company_id#";
		}
		else if(page==4)
		{
			_link_ = 'unique_sayfa_4';
			var url_str = "#request.self#?fuseaction=objects.popup_detail_bankaccounts&company_id=#attributes.company_id#";
		}
		if(page!=1) AjaxPageLoad(url_str,_link_,1,'<cf_get_lang dictionary_id="58891.Yükleniyor">');
		return true;
	</cfoutput>
}
</script>