<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY
</cfquery>
<cfparam name="attributes.pos_type" default="">
<cfsavecontent variable="title"><cf_get_lang no='369.Sanal POS'><cf_get_lang_main no='170.Ekle'></cfsavecontent>
	<div class="col col-12">
		<cf_box draggable="1" title="#title#" closable="1">
			<cfform name="form_pos" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_pos_relation">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_active" id="is_active" value="1" checked="checked"  /> <cf_get_lang_main no='81.Aktif'>
							</label>
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_secure" id="is_secure" value="1"/> <cf_get_lang no='380.3D Secure'>
							</label>
						</div>
						<div class="form-group" id="item-pos_name">
							<label class="col col-4 col-xs-12"><cf_get_lang no='382.Pos Adı'> *</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="pos_name" id="pos_name" value="" />
							</div>
						</div>
						<div class="form-group" id="item-pos_type">
							<label class="col col-4 col-xs-12"><cf_get_lang no='378.Sanal POS Tipi'> *</label>
							<div class="col col-8 col-xs-12">
								<select name="pos_type" id="pos_type"><!---Statik olarak gelir,sanal pos işlemleri içindir AE20060314--->
									<option value=""><cf_get_lang no='378.Sanal POS Tipi'><cf_get_lang_main no='322.Seçiniz'></option>
									<option value="1" <cfif attributes.pos_type eq 1> selected </cfif> >Akbank</option>
									<option value="2" <cfif attributes.pos_type eq 2> selected </cfif>>N Kolay</option>
									<option value="3" <cfif attributes.pos_type eq 3> selected </cfif>>İş Bankası</option>
									<option value="4" <cfif attributes.pos_type eq 4> selected </cfif>>Denizbank</option>
									<option value="5" <cfif attributes.pos_type eq 5> selected </cfif>>Finansbank</option>
									<option value="6" <cfif attributes.pos_type eq 6> selected </cfif>>HSBC</option>
									<option value="7" <cfif attributes.pos_type eq 7> selected </cfif>>Vakıfbank</option>
									<option value="8" <cfif attributes.pos_type eq 8> selected </cfif>>Garanti</option>
									<option value="9" <cfif attributes.pos_type eq 9> selected </cfif>>YapıKredi</option>
									<option value="10" <cfif attributes.pos_type eq 10> selected </cfif>>Halkbank</option>
									<option value="11" <cfif attributes.pos_type eq 11> selected </cfif>>Türkiye Finans</option>
									<option value="12" <cfif attributes.pos_type eq 12> selected </cfif>>Bank Asya</option>
									<option value="13" <cfif attributes.pos_type eq 13> selected </cfif>>Citi Bank</option>
									<option value="14" <cfif attributes.pos_type eq 14> selected </cfif>>TEB</option>
									<option value="15" <cfif attributes.pos_type eq 15> selected </cfif>>Ziraat</option>
									<option value="16" <cfif attributes.pos_type eq 16> selected </cfif>>ING Bank</option>
									<option value="17" <cfif attributes.pos_type eq 17> selected </cfif>>Odea Bank</option>
									<option value="18" <cfif attributes.pos_type eq 18> selected </cfif>>Şekerbank</option>
									<option value="20" <cfif attributes.pos_type eq 20> selected </cfif>>Albaraka Türk</option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-company_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='162.Şirket'>*</label>
							<div class="col col-8 col-xs-12">
								<select name="our_company" id="our_company">
									<cfoutput query="get_our_company"> 
										<option value="#comp_id#">#company_name#</option>
									</cfoutput> 
								 </select>
							</div>
						</div>
						<div class="form-group" id="item-user_name">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='139.Kullanıcı Adı'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="user_name" id="user_name" value="" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-user_password">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='140.Şifre'></label>
							<div class="col col-8 col-xs-12">
								<input type="password" name="user_password" id="user_password" value="" maxlength="50"  />
							</div>
						</div>
						<div class="form-group" id="item-client_id">
							<label class="col col-4 col-xs-12">Client ID</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="client_id" id="client_id" value="" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-terminal_no">
							<label class="col col-4 col-xs-12"><cf_get_lang no='404.Terminal No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="terminal_no" id="terminal_no" value="" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-host">
							<label class="col col-4 col-xs-12"><cf_get_lang no='405.Banka Sunucu Adresi'>*</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="host" id="host" value="" maxlength="250" />
							</div>
						</div>
						<div class="form-group" id="item-host_3d">
							<label class="col col-4 col-xs-12"><cf_get_lang no='407.Banka 3D Adresi'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="host_3d" id="host_3d" value="" maxlength="250" />
							</div>
						</div>
						<div class="form-group" id="item-store_key">
							<label class="col col-4 col-xs-12"><cf_get_lang no='418.Mağaza Anahtarı'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="store_key" id="store_key" value="" maxlength="100">
							</div>
						</div>
						<div class="form-group" id="item-ssl_ip">
							<label class="col col-4 col-xs-12">SSL IP (<cf_get_lang no='419.Sunucu IP'>)</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ssl_ip" id="ssl_ip" value="" maxlength="40">
							</div>
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='55.Not'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="detail" id="detail" value="" maxlength="250" />
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
                    <div class="col col-12">
                        <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
                    </div>
                </cf_box_footer>
			</cfform>
		</cf_box>
	</div>

<script type="text/javascript">
function kontrol()
{
	if (form_pos.pos_name.value==""){
		alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='382.Pos Adı'>");
		form_pos.pos_name.focus();
		return false;
	}
	if (form_pos.pos_type.value==""){
		alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='378.Sanal POS Tipi'>");
		form_pos.pos_type.focus();
		return false;
	}
	var filter = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/;
	if (!filter.test(form_pos.host.value)) {
		alert("<cf_get_lang no='420.Girilen Sunucu Adresi Geçersizdir'>");
		form_pos.host.focus();
		return false;
	}
	if (form_pos.ssl_ip.value.length>0){
		var filter = /^([1-9][0-9]{0,2})+\.([1-9][0-9]{0,2})+\.([1-9][0-9]{0,2})+\.([1-9][0-9]{0,2})+$/;
		if (!filter.test(form_pos.ssl_ip.value)) {
			alert("<cf_get_lang no='421.Girilen IP Geçersizdir'>");
			form_pos.ssl_ip.focus();
			return false;
		}
	}
}
</script>

