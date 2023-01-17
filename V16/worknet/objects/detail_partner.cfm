<cfif isdefined('session.pp.userid') and isdefined('attributes.pid')>
	<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
	<!--- kullanıcı sayısı kontrolu --->
	<cfset getPartner = cmp.getPartner(company_id:session.pp.company_id,partner_status=1) />
	<cfset getMemberSubs = createObject("component","worknet.objects.worknet_objects").getMemberSubs() />
	<cfif getMemberSubs.recordcount and getMemberSubs.STOCK_CODE_2 lte getPartner.recordcount and attributes.pid neq session.pp.userid>
		<script type="text/javascript">
			alert("<cf_get_lang no='289.Kullanıcı limitiniz dolmuştur'> !");
			window.history.back();
		</script>
	  <cfabort>
	</cfif>
	<!--- kullanıcı sayısı kontrolu --->
	<cfset getPartner = cmp.getPartner(partner_id:attributes.pid) />
	<cfif getPartner.company_id eq session.pp.company_id>
		<!---<cfset getMobilcat = cmp.getMobilcat() />--->
		<cfset getCountry = cmp.getCountry() />
		<cfset getPartnerPositions = cmp.getPartnerPositions() />
		<cfset getPartnerDepartments = cmp.getPartnerDepartments() />
		<cfset getLanguage = cmp.getLanguage() />
		<cfset getCompanyBranch = cmp.getCompanyBranch(partner_id:attributes.pid) />
	
		<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
		<div class="haber_liste">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1><cfoutput>#getPartner.company_partner_name# #getPartner.company_partner_surname#</cfoutput></h1></div>
			</div>
			<div class="talep_detay">
				<cfform name="upd_partner" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_company_partner">
				<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getPartner.company_id#</cfoutput>">
				<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#attributes.pid#</cfoutput>">
				<div class="talep_detay_1" style="width:905px;">
					<div class="talep_detay_12">
						<div class="td_kutu">
							<div class="td_kutu_1">
								<h2><cf_get_lang no='4.Kullanıcı Bilgileri'></h2>
							</div>
							<div class="td_kutu_2">
								<table class="addMemberForm">
									<tr>
										<td width="650">
										<table class="addMemberForm">
											<cfif session.pp.userid eq getPartner.manager_partner_id and attributes.pid neq session.pp.userid>
												<tr>
													<td><cf_get_lang_main no='81.Aktif'></td>
													<td><input type="checkbox" name="company_partner_status" id="company_partner_status" <cfif getPartner.company_partner_status eq 1>checked</cfif>></td>
												</tr>
											<cfelse>
												<div style="display:none;"><input type="checkbox" name="company_partner_status" id="company_partner_status" <cfif getPartner.company_partner_status eq 1>checked</cfif>></div>
											</cfif>
											<tr height="25">
												<td style="width:135px;"><cf_get_lang_main no='219.Ad'>*</td>
												<td style="width:180px;"><input type="text" name="name" id="name" value="<cfoutput>#getPartner.company_partner_name#</cfoutput>" maxlength="20" style="width:150px;"></td>
												<td width="80"><cf_get_lang_main no='1314.Soyad'>*</td>
												<td><input type="text" name="soyad" id="soyad" value="<cfoutput>#getPartner.company_partner_surname#</cfoutput>" maxlength="20" style="width:150px;"></td>
											</tr>
											<tr height="25">
												<td><cf_get_lang_main no='16.e-mail'> (<cf_get_lang_main no='139.Kullanıcı Ad'>) *</td>
												<td><cfsavecontent variable="mesaj"><cf_get_lang_main no='1072.Lütfen Geçerli Bir E-mail Adresi Giriniz'></cfsavecontent>
													<cfinput type="text" name="email" id="email" value="#getPartner.company_partner_email#" maxlength="50" validate="email" message="#mesaj#" style="width:150px;">
												</td>
												<td><cf_get_lang_main no='140.Şifre'> *</td>
												<td><input type="Password" name="password" id="password" style="width:150px;" maxlength="16"></td>
											</tr>
											<tr height="25">
												<td><cf_get_lang_main no='159.Ünvan'></td>
												<td><input type="text" name="title" id="title" value="<cfoutput>#getPartner.title#</cfoutput>" maxlength="50" style="width:150px;"></td>
												<td><cf_get_lang_main no='613.TC Kimlik No'></td>
												<td><cf_wrkTcNumber fieldId="tc_identity" tc_identity_required="1" width_info='150' is_verify='0' consumer_name='name' consumer_surname='soyad' birth_date='birthdate' tc_identity_number='#getPartner.TC_IDENTITY#'></td>
											</tr>
											<tr height="25">
												<td><cf_get_lang_main no='161.Görev'></td>
												<td><select name="mission" id="mission" style="width:150px;">
														<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
															<cfoutput query="getPartnerPositions">
																<option value="#partner_position_id#" <cfif getPartner.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
															</cfoutput>
													</select>
												</td>
												<td><cf_get_lang_main no='160.Departman'></td>
												<td>
													<select name="department" id="department" style="width:150px;">
														<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
															<cfoutput query="getPartnerDepartments">
																<option value="#partner_department_id#" <cfif getPartner.department eq partner_department_id>selected</cfif>>#partner_department#</option>
															</cfoutput>
													</select>
												</td>
											</tr>
											<tr height="25">
												<td><cf_get_lang_main no='352.Cinsiyet'></td>
												<td>
													<select name="sex" id="sex" style="width:150px;">
														<option value="1" <cfif getPartner.sex eq 1> selected</cfif>><cf_get_lang_main no='1547.Erkek'></option>
														<option value="2" <cfif getPartner.sex eq 2> selected</cfif>><cf_get_lang_main no='1546.Kadın'></option>
													</select>
												</td>
												<td><cf_get_lang_main no='1315.Doğum Tarihi'></td>
												<td><cfinput type="text" name="birthdate" id="birthdate" value="#DateFormat(getPartner.birthdate,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px; float:left; margin-right:5px;">
													<cf_wrk_date_image date_field="birthdate">
												</td>
											</tr>
											<tr height="25">
												<td><cf_get_lang no='125.Fotoğraf Ekle'></td>
												<td><input type="file" name="photo" id="photo" style="width:150px; float:left;">
													<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
														<a href="javascript://" data-width="500px" style="margin:4px 0px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
															<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
														</a>
													</cfif>
												</td>
											</tr>
										</table>
										</td>
										<td valign="top">
											<cfif len(getPartner.photo)>
												<cf_get_server_file output_file="member/#getPartner.photo#" output_server="#getPartner.photo_server_id#" output_type="0" image_width="120" image_height="160">
												<!--- crop tool --->
												<cfif len(getPartner.photo) and (listlast(getPartner.photo,'.') is 'jpg' or listlast(getPartner.photo,'.') is 'png' or listlast(getPartner.photo,'.') is 'gif' or listlast(getPartner.photo,'.') is 'jpeg')> 
													<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&old_file_server_id=#getPartner.photo_server_id#&old_file_name=#getPartner.photo#&asset_cat_id=-9</cfoutput>','adminTv','wrk_image_editor')"><img src="/images/canta.gif" alt="Edit" title="Crop Tool" border="0"></a>
												</cfif>
											<cfelse>
												<cfif getPartner.sex eq 1>
													<img src="/images/male.jpg">
												<cfelse>
													<img src="/images/female.jpg">
												</cfif> 
											</cfif><br/>
											<div class="ftd_kutu_22">
												<cfif len(getPartner.photo)>
													<samp style="padding-top:3px;"><cf_get_lang no='136.Fotoğrafı Sil'></samp>&nbsp;<input  type="Checkbox" name="del_photo" id="del_photo" value="1">
												</cfif>
											</div>
									   </td>
									</tr>
								</table>
							</div>
						</div>
					</div>
					<div class="talep_detay_12">
						<div class="td_kutu">
							<div class="td_kutu_1">
								<h2><cf_get_lang_main no='731.İletişim'></h2>
							</div>
							<div class="td_kutu_2">
								<table class="addMemberForm">
									<tr height="25"> 
										<td width="135"><cf_get_lang_main no='41.Şube'></td>
										<td colspan="3">
											<select name="compbranch_id" id="compbranch_id" style="width:350px;" onChange="kontrol_et(this.value);">
												<option value="0"><cf_get_lang no='181.Merkez Ofis'> 
												<cfoutput query="getCompanyBranch">
													<option value="#compbranch_id#"<cfif getPartner.compbranch_id eq compbranch_id> selected</cfif>>#compbranch__name#</option>
												</cfoutput>
											</select>
										</td>
									</tr>
									<tr height="25">
										<cfif Len(getPartner.country)>
											<cfquery name="get_country_phone" dbtype="query">
												SELECT COUNTRY_PHONE_CODE FROM GETCOUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartner.country#">
											</cfquery>
										</cfif>
										<td><cf_get_lang_main no='87.Telefon'> <label id="load_phone"><cfif Len(getPartner.country) and len(get_country_phone.country_phone_code)>(<cfoutput>#get_country_phone.country_phone_code#</cfoutput>)</cfif></label><!--- Ulke Telefon Kodunu atiyor ---></td>
										<td>
											<cfsavecontent variable="message"><cf_get_lang no='178.Geçerli Bir Telefon kodu Giriniz !'></cfsavecontent>
											<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='87.telefon'></cfsavecontent>
											<cfinput type="text" name="telcod" id="telcod" value="#getPartner.company_partner_telcode#" validate="integer" message="#message#" maxlength="5" style="width:55px;">
											<cfinput type="text" name="tel" id="tel" value="#getPartner.company_partner_tel#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
										</td>
										<td><cf_get_lang no='121.Dahili'></td>
										<td style="text-align:right;">
											<cfinput type="text" name="tel_local" id="tel_local" value="#getPartner.company_partner_tel_ext#" onChange="IsNumber(this.value)" maxlength="5" style="width:86px;">
										</td>
									</tr>
									<tr height="25">
										<td><cf_get_lang no='116.Kod /Mobil Tel'></td>
										<td><!---<select name="mobilcat_id" id="mobilcat_id" style="width:60px;">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="getMobilcat">
													<option value="#mobilcat#" <cfif mobilcat is getPartner.mobil_code>selected</cfif>>#mobilcat#</option>
												</cfoutput>
											</select>--->
                                            <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getPartner.mobil_code#</cfoutput>" style="width:55px;">
											<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='116.gsm No !'></cfsavecontent>
											<cfinput type="text" name="mobiltel" id="mobiltel" value="#getPartner.mobiltel#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
										</td>
										<td><cf_get_lang_main no='76.Fax'></td>
										<td style="text-align:right;">
											<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='107.Fax No !'></cfsavecontent>
											<cfinput type="text" name="fax" id="fax" value="#getPartner.company_partner_fax#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
										</td>
									</tr>
								</table>
							</div>
						</div>
					</div>	
					<div class="talep_detay_12">
						<div class="td_kutu" style="display:none;">
							<!--- adresler hiddenda tutuluyor çünkü şube ile adres bilgileri düsürülüyor --->
							<table class="addMemberForm">
								<tr> 		
									<td width="100"><cf_get_lang_main no='807.Ülke'></td>
									<td width="175">
										<select name="country" id="country" style="width:150px;" onChange="LoadCity(this.value,'city_id','county_id',0)">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfoutput query="getCountry">
												<option value="#country_id#" <cfif getPartner.country eq country_id>selected</cfif>>#country_name#</option>
											</cfoutput>
										</select>
									</td>
									<td width="80" rowspan="3" valign="top"><cf_get_lang_main no='1311.Adres'></td>
									<td rowspan="3" valign="top">
										<textarea name="adres" id="adres" style="width:150px;height:65px;"><cfoutput>#getPartner.company_partner_address#</cfoutput></textarea>
									</td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='559.Şehir'></td>
									<td>
									   <select name="city_id" id="city_id" style="width:150px;" onChange="LoadCounty(this.value,'county_id','company_partner_telcode')">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfquery name="GET_CITY" datasource="#DSN#">
												SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(getPartner.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartner.country#"></cfif>
											</cfquery>
											<cfoutput query="GET_CITY">
												<option value="#city_id#" <cfif getPartner.city eq city_id>selected</cfif>>#city_name#</option>
											</cfoutput>
										</select>
									</td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='1226.Ilce'></td>
									<td><cfquery name="GET_COUNTY" datasource="#DSN#">
											SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(getPartner.city)>WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartner.city#"></cfif>
										</cfquery>
										<select name="county_id" id="county_id" style="width:150px;">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfquery name="GET_COUNTY" datasource="#DSN#">
												SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(getPartner.city)>WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartner.city#"></cfif>
											</cfquery>
											<cfoutput query="get_county">
												<option value="#county_id#" <cfif getPartner.county eq county_id>selected</cfif>>#county_name#</option>
											</cfoutput>
										</select> 
									</td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='720.Semt'></td>
									<td><input type="text" name="semt" id="semt" value="<cfoutput>#getPartner.semt#</cfoutput>" maxlength="45" style="width:150px;"></td>
									<td><cf_get_lang_main no='60.Posta Kodu'></td>
									<td><input type="text" name="postcod" id="postcod" style="width:150px;" maxlength="15" value="<cfoutput>#getPartner.company_partner_postcode#</cfoutput>"></td>
								</tr>
								<tr>
									<td><cf_get_lang no='41.İnternet'></td>
									<td><input type="text" name="homepage" id="homepage" value="<cfoutput>#getPartner.homepage#</cfoutput>" maxlength="50" style="width:150px;"></td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				<div class="talep_detay_3">
					<div class="sozlesme">
						<div class="sozlesme_1">
							<input type="checkbox" name="want_email" id="want_email" value="1" style="float:left; margin-right:5px;" <cfif getPartner.want_email eq 1>checked="checked"</cfif> />
							<span style="margin-top:3px;"><cf_get_lang no='35.Style Turkish bülten ve epostalarını almak istiyorum'></span>
						</div>
					</div>
					<div class="talep_detay_31">
						<cfsavecontent variable="message"><cf_get_lang_main no="49.Kaydet"></cfsavecontent>
						<input class="btn_1" type="submit" onclick=" return kontrol()" value="<cfoutput>#message#</cfoutput>" />
					</div>
				</div>
				</cfform>
			</div>
		</div>
		<script type="text/javascript">
		var is_tc_number = 1;
		function remove_adress(parametre)
		{
			if(parametre==1)
			{
				document.getElementById('city_id').value = '';
				document.getElementById('county_id').value = '';
				document.getElementById('telcod').value = '';
			}
			else
			{
				document.getElementById('county_id').value = '';
			}	
		}
		
		function kontrol_et(compbranch_id)
		{
			if(compbranch_id == 0)
			{
				get_comp_branch = wrk_safe_query("mr_get_comp_branch","dsn",0,document.getElementById('company_id').value);
				if(get_comp_branch.COUNTRY != '')
				{
					document.getElementById('country').value = get_comp_branch.COUNTRY;
					LoadCity(get_comp_branch.COUNTRY,'city_id','county_id',0);
				}
				else
					document.getElementById('country').value = '';
				if(get_comp_branch.CITY != '')
				{
					document.getElementById('city_id').value = get_comp_branch.CITY;
					LoadCounty(get_comp_branch.CITY,'county_id');
				}
				else
					document.getElementById('city_id').value = '';
				if(get_comp_branch.COUNTY != '')
					document.getElementById('county_id').value = get_comp_branch.COUNTY;
				else
					document.getElementById('county_id').value = '';	
				if(get_comp_branch.COMPANY_ADDRESS != '')
					document.getElementById('adres').value = get_comp_branch.COMPANY_ADDRESS;
				else
					document.getElementById('adres').value = '';
				if(get_comp_branch.COMPANY_POSTCODE != '')
					document.getElementById('postcod').value = get_comp_branch.COMPANY_POSTCODE;
				else
					document.getElementById('postcod').value = '';
				if(get_comp_branch.SEMT != '')
					document.getElementById('semt').value = get_comp_branch.SEMT;
				else
					document.getElementById('semt').value = '';
				if(get_comp_branch.COMPANY_TELCODE != '')
					document.getElementById('telcod').value = get_comp_branch.COMPANY_TELCODE;
				else
					document.getElementById('telcod').value = '';
				if(get_comp_branch.COMPANY_TEL1 != '')
					document.getElementById('tel').value = get_comp_branch.COMPANY_TEL1;
				else
					document.getElementById('tel').value = '';
				if(get_comp_branch.COMPANY_FAX != '')
					document.getElementById('fax').value = get_comp_branch.COMPANY_FAX;
				else
					document.getElementById('fax').value = '';
			}
			else
			{ 
				getCompany_branch = wrk_safe_query("mr_get_company_branch","dsn",0,compbranch_id);
				if(getCompany_branch.COUNTRY_ID != '')
				{
					document.getElementById('country').value = getCompany_branch.COUNTRY_ID;
					LoadCity(getCompany_branch.COUNTRY_ID,'city_id','county_id',0);
				}
				else
					document.getElementById('country').value = '';
				if(getCompany_branch.CITY_ID != '')
				{
					document.getElementById('city_id').value = getCompany_branch.CITY_ID;
					LoadCounty(getCompany_branch.CITY_ID,'county_id',0);
				}
				else
					document.getElementById('city_id').value = '';
				
				if(getCompany_branch.COUNTY_ID != '')
					document.getElementById('county_id').value = getCompany_branch.COUNTY_ID;
				else
					document.getElementById('county_id').value = '';	
				if(getCompany_branch.COMPBRANCH_ADDRESS != '')
					document.getElementById('adres').value = getCompany_branch.COMPBRANCH_ADDRESS;
				else
					document.getElementById('adres').value = '';
				if(getCompany_branch.COMPBRANCH_POSTCODE != '')
					document.getElementById('postcod').value = getCompany_branch.COMPBRANCH_POSTCODE;
				else
					document.getElementById('postcod').value = '';
				if(getCompany_branch.SEMT != '')
					document.getElementById('semt').value = getCompany_branch.SEMT;
				else
					document.getElementById('semt').value = getCompany_branch.SEMT;
				if(getCompany_branch.COMPBRANCH_TELCODE != '')
					document.getElementById('telcod').value = getCompany_branch.COMPBRANCH_TELCODE;
				else
					document.getElementById('telcod').value = '';
				if(getCompany_branch.COMPBRANCH_TEL1 != '')
					document.getElementById('tel').value = getCompany_branch.COMPBRANCH_TEL1;
				else
					document.getElementById('tel').value = '';
				if(getCompany_branch.COMPBRANCH_FAX != '')
					document.getElementById('fax').value = getCompany_branch.COMPBRANCH_FAX;
				else
					document.getElementById('fax').value = '';
			}
		}	
		
		function kontrol ()
		{	
			if (document.getElementById('name').value == '')
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad'> !");
				return false;
			}
			if (document.getElementById('soyad').value == '')
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1314.Soyad'> !");
				return false;
			}
			
			if (document.getElementById('email').value == '')
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='16.Email'> !");
				return false;
			}
			
			var  checkEmail = document.getElementById('email').value;
			if (((checkEmail == '') || (checkEmail.indexOf('@') == -1) || (checkEmail.indexOf('.') == -1) || (checkEmail.length < 6)))
			{ 
				alert("<cf_get_lang_main no='1072.Lütfen geçerli bir e-posta adresi giriniz'>!");
				return false;
			}
			
			<cfif not len(getPartner.company_partner_password)>
				y = (document.getElementById('password').value.length);
				if (document.getElementById('password').value == '' || (document.getElementById('password').value != '')  && ( y < 4 ))
				{ 
					alert ("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='196.Şifre-En Az Dört Karakter'>");
					return false;
				}
			</cfif>
			
			if(document.getElementById('tc_identity').value != "")
			{
				if(!isTCNUMBER(document.getElementById('tc_identity'))) return false;
				if(document.getElementById('tc_identity').value.length != 11)
					{
						alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='436.TC Kimlik Numarası - 11 Hane'> !");
						return false;
					}
			}
			
			var obj =  document.getElementById('photo').value;
			if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
			{
				alert("<cf_get_lang no='197.Lütfen bir resim dosyası(gif,jpg veya png) giriniz!!'>");        
				return false;
			}	
			
			if (confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz, Lütfen yeni kullanıcı kaydını onaylayın!'>")); else return false;
			
		}
		document.getElementById('name').focus();
		</script>
		<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	<cfelse>
		<cfinclude template="hata.cfm">
	</cfif>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>

