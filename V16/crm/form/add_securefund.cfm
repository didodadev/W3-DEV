<cfif attributes.fuseaction eq 'crm.list_company_securefund'>
	<cf_catalystHeader>
</cfif>
<cfif isdefined("attributes.is_page") and not isdefined("attributes.cpid")>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Teminat Yönetimi','51999')#">
			<cfform name="add_event" method="post" action="">
			<input type="hidden" name="is_page" id="is_page" value="">
				<cf_box_search plus="0">
					<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="cpid" id="cpid" value="">
							<input type="hidden" name="partner_id" id="partner_id" value="">
							<input type="hidden" name="partner_name" id="partner_name" value="">
							<input type="text" name="company_name" id="company_name" value="" readonly>
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&is_buyer_seller=0&field_id=add_event.partner_id&field_comp_name=add_event.company_name&field_name=add_event.partner_name&field_comp_id=add_event.cpid&is_single=1&select_list=2,6');"></span>
						</div>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function='all_select()'>
					</div>
				</cf_box_search>
			</cfform>
		</cf_box>
		<script type="text/javascript">
			function all_select()
			{
				if(document.add_event.cpid.value == "")
				{
					alert("<cf_get_lang no='574.Lütfen Müşteri Seçiniz'> !");
					return false;
				}
				else
					return true;
			}
		</script>
	</div>
<cfelse>
	<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
		SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
	</cfquery>
	<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT 
			COMPANY_BRANCH_RELATED.RELATED_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			BRANCH.COMPANY_ID
		FROM
			BRANCH,
			COMPANY_BRANCH_RELATED
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
			COMPANY_BRANCH_RELATED.IS_SELECT <> 0 AND
			BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
			COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND
			BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
			<!--- BK ekledi 20081011 Aydın Ersoz istegi KAPANMIS,DIGER,SUBE DEGISIKLIGI --->
			COMPANY_BRANCH_RELATED.MUSTERIDURUM NOT IN (1,4,66)			
	</cfquery>
	<cfquery name="GET_RELATED_BRANCH" dbtype="query">
		SELECT BRANCH_ID FROM GET_BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
	</cfquery>
	<cfquery name="SETUP_SECUREFUND" datasource="#DSN#">
		SELECT SECUREFUND_CAT_ID, SECUREFUND_CAT FROM SETUP_SECUREFUND
	</cfquery>
	 <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <div class="col col-9 col-md-9 col-sm-12 col-xs-12">
			<cf_box title="#getLang('','Teminat Yönetimi','51999')#">
				<cfform name="add_secure" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_securefund">
					<cf_box_elements>	
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-is_active">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12">&nbsp</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <label><input type="checkbox" value="1" name="securefund_status" id="securefund_status" checked><cf_get_lang dictionary_id='57493.Aktif'></label>
                                </div>
                            </div>
							<div class="form-group" id="item-branch_id">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="our_company_id" id="our_company_id" onChange="degistir()">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_branch">
											<option value="#company_id#,#related_id#,#branch_id#" <cfif branch_id eq listgetat(session.ep.user_location,2,'-')>selected</cfif>>#branch_name# (#related_id#)</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-member">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfquery name="GET_COMPANY" datasource="#DSN#">
										SELECT 
											COMPANY_PARTNER.COMPANY_PARTNER_NAME,
											COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
											COMPANY.MANAGER_PARTNER_ID, 
											COMPANY.FULLNAME 
										FROM 
											COMPANY,
											COMPANY_PARTNER
										WHERE 
											COMPANY.COMPANY_ID = #attributes.cpid# AND
											COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID
									</cfquery>
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.cpid#</cfoutput>">
									<input type="hidden" name="member_type" id="member_type" value="partner">
									<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_company.manager_partner_id#</cfoutput>">
									<input type="hidden" name="member" id="member" value="<cfoutput>#get_company.fullname#</cfoutput>">
									<cfinput type="text" name="memb_n" readonly value="#get_company.fullname#">
								</div>
							</div>
							<div class="form-group" id="item-securefund_cat">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="securefund_cat_id" id="securefund_cat_id">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option> 
										<cfoutput query="setup_securefund">
											<option value="#securefund_cat_id#">#securefund_cat#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-bank_branch">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58933.Banka Şubesi'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfinput name="bank_branch" type="text" value="" maxlength="50">
								</div>
							</div>
							<div class="form-group" id="item-money_type">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="securefund_total" id="securefund_total" value="" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
										<span class="input-group-addon width">
											<select name="money_type" id="money_type">
												<cfoutput query="get_money_rate">
													<option value="#money#" <cfif session.ep.money is '#money#'>selected</cfif>>#money#</option>
												</cfoutput>
											</select>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-start_date">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'>!</cfsavecontent>
										<cfinput value="" validate="#validate_style#" required="Yes" message="#message#" type="text" name="start_date"> 
										<span class="input-group-addon">
											<cf_wrk_date_image date_field="start_date">
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-warning_date">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='38414.Uyarı Tarihi'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='52068.Uyarı Tarihi Girmelisiniz'>!</cfsavecontent>
										<cfinput value="" validate="#validate_style#" required="Yes" message="#message#" type="text" name="warning_date"> 
										<span class="input-group-addon">
											<cf_wrk_date_image date_field="warning_date">
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-mortgage_total">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52070.İpotek Beyan Bedeli'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="mortgage_total" id="mortgage_total" value="" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
										<span class="input-group-addon width">
											<select name="mortgage_money_type" id="mortgage_money_type">
												<cfoutput query="get_money_rate">
													<option value="#money#" <cfif session.ep.money is '#money#'>selected</cfif>>#money#</option>
												</cfoutput>
											</select>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-mortgage_rate">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52074.İpotek Derecesi'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="mortgage_rate" id="mortgage_rate">
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="3">3</option>
										<option value="4">4</option>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-mortgage_bank">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52516.İpotek Bankası'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text" name="mortgage_bank" id="mortgage_bank" value="" maxlength="25">
								</div>
							</div>
							<div class="form-group" id="item-mortgage_type">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52515.Nevi'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="mortgage_type" id="mortgage_type">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option> 
										<option value="1"><cf_get_lang dictionary_id='58480.Araç'></option>
										<option value="2"><cf_get_lang dictionary_id='52520.Arsa'></option>
										<option value="3"><cf_get_lang dictionary_id='52518.Bağ'></option>
										<option value="4"><cf_get_lang dictionary_id='52521.Bina'></option>
										<option value="5"><cf_get_lang dictionary_id='52522.Dükkan'></option>
										<option value="6"><cf_get_lang dictionary_id='52523.Mesken'></option>
										<option value="7"><cf_get_lang dictionary_id='52524.Tarla'></option>
									</select>
								</div>
							</div>
						</div>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item_name">
								<label class="col col-4 col-md-4 col-sm-4 -col-xs-12">&nbsp</label>
							</div>
							<div class="form-group" id="item-file">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57468.Belge'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="file" name="SECUREFUND_FILE">
								</div>
							</div>
							<div class="form-group" id="item-_process">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cf_workcube_process is_upd='0'	process_cat_width='150' is_detail='0'>
								</div>
							</div>
							<div class="form-group" id="item-give_take">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="give_take" id="give_take">
										<option value="0" selected><cf_get_lang dictionary_id='58488.Alınan'></option>
										<option value="1"><cf_get_lang dictionary_id='58490.Verilen'></option>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-bank">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57521.Banka'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfinput name="bank" type="text" value="" maxlength="50">
								</div>
							</div>
							<div class="form-group" id="item-money">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58930.Masraf'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="expense_total" id="expense_total" value="" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
										<span class="input-group-addon width">
											<select name="money_cat_expense" id="money_cat_expense">
												<cfoutput query="get_money_rate">
													<option value="#money#">#money#</option>
												</cfoutput>
											</select>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-finish_date">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
										<cfinput name="finish_date" type="text" value="" validate="#validate_style#" required="Yes" message="#message#"> 
										<span class="input-group-addon">
											<cf_wrk_date_image date_field="finish_date">
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-mortgage_owner">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52069.İpotek Sahibi'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text" name="mortgage_owner" id="mortgage_owner" maxlength="100" value="<cfoutput>#Left(get_company.company_partner_name&' '&get_company.company_partner_surname,100)#</cfoutput>">
								</div>
							</div>
							<div class="form-group" id="item-expert_money_type">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52072.Expertiz Değeri'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="expert_total" id="expert_total" value="" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
										<span class="input-group-addon width">
											<select name="expert_money_type" id="expert_money_type">
												<cfoutput query="get_money_rate">
													<option value="#money#" <cfif session.ep.money is '#money#'>selected</cfif>>#money#</option>
												</cfoutput>
											</select>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-mortgage_bank_dept">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52514.Banka Borcu'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="mortgage_bank_dept" id="mortgage_bank_dept" value="" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
										<span class="input-group-addon width">
											<select name="bank_money_type" id="bank_money_type">
												<cfoutput query="get_money_rate">
													<option value="#money#" <cfif session.ep.money is '#money#'>selected</cfif>>#money#</option>
												</cfoutput>
											</select>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-mortgage_total2">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52517.İpotek Tutarı'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="mortgage_total2" id="mortgage_total2" value="" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
										<span class="input-group-addon width">
											<select name="mortgage_money_type2" id="mortgage_money_type2">
												<cfoutput query="get_money_rate">
													<option value="#money#" <cfif session.ep.money is '#money#'>selected</cfif>>#money#</option>
												</cfoutput>
											</select>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-realestate_detail">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<textarea name="realestate_detail" id="realestate_detail" maxlength="500" onKeyUp="return ismaxlength(this);" onBlur="return ismaxlength(this);" message="<cf_get_lang dictionary_id='56882.500 Karakterden Fazla Yazmayınız!!'>" style="width:430px;height:80px;"></textarea>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer><cf_workcube_buttons is_upd='0' add_function="kontrol()" type_format="1"></cf_box_footer>
				</cfform>
			</cf_box> 
		</div>
		<div class="col col-3 col-md-3 col-sm-12 col-xs-12">
            <div id="general">
                <cf_box id="member_frame" title="#getLang('','Genel Bilgiler','57980')#" box_page="#request.self#?fuseaction=crm.popup_dsp_teminat_info&cpid=#attributes.cpid#&iframe=1&branch_id=#get_related_branch.branch_id#"></cf_box>
            </div>
        </div>
	</div>
	<script type="text/javascript">
		function kontrol()
		{	
			x = document.add_secure.our_company_id.selectedIndex;
			if (document.add_secure.our_company_id[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='52077.Lütfen Şirketinizi Seçiniz'>!");
				return false;
			}
			x = document.add_secure.securefund_cat_id.selectedIndex;
			if (document.add_secure.securefund_cat_id[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='52076.Teminat Kategorisi Seçiniz'> !");
				return false;
			}
			
			if(document.add_secure.securefund_total.value == "")
			{
				alert("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'>!");
				return false;
			}
			if(document.add_secure.securefund_cat_id.value == 2)  // Ep: 2  / Hedef: 21
			{
				if (document.add_secure.mortgage_type.value == "")
				{
					alert("<cf_get_lang dictionary_id='31853.Lütfen Nevi Değerini Seçiniz'>");
					return false;
				}
				if(document.add_secure.mortgage_rate.value >= 2)
				{
					if (document.add_secure.mortgage_bank_dept.value == "")
					{
						alert("<cf_get_lang dictionary_id='31851.Lütfen Banka Borcunu Giriniz'>!");
						return false;
					}
					if(document.add_secure.mortgage_total2.value == "")
					{
						alert("<cf_get_lang dictionary_id='31850.Lütfen İpotek Tutarını Giriniz'>!");
						return false;
					}
					if(document.add_secure.mortgage_bank.value == "")
					{
						alert("<cf_get_lang dictionary_id='31842.Lütfen İpotek Bankasını Giriniz'>!");
						return false;
					}
		    	}
			}
			if(document.add_secure.realestate_detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='52066.Lütfen Açıklama Giriniz'>!");
				return false;
			}
			return unformat_fields();
		}
		
		function unformat_fields()
		{
			document.add_secure.securefund_total.value = filterNum(document.add_secure.securefund_total.value);
			document.add_secure.expense_total.value = filterNum(document.add_secure.expense_total.value);
			document.add_secure.mortgage_total.value = filterNum(document.add_secure.mortgage_total.value);
			document.add_secure.expert_total.value = filterNum(document.add_secure.expert_total.value);
			document.add_secure.mortgage_bank_dept.value = filterNum(document.add_secure.mortgage_bank_dept.value);
			document.add_secure.mortgage_total2.value = filterNum(document.add_secure.mortgage_total2.value);
			return process_cat_control();
		}
			
		function degistir()
		{
			deger_branch_id_ilk = "";
			deger_branch_id = document.add_secure.our_company_id.value.split(',');
			if(deger_branch_id != "")
			{
				deger_branch_id_ilk = deger_branch_id[2];
			}
			reload_member_frame('branch_id=' + deger_branch_id_ilk);
			
			company_id=document.add_secure.company_id.value;
			branch_id=list_getat(document.add_secure.our_company_id.value,3,',');
			var listParam = company_id + "*" + branch_id ;
			var get_carihesapkod = wrk_safe_query('crm_get_carihesapkod','dsn',0,listParam);
			if(document.add_secure.our_company_id.value != '' && get_carihesapkod.CARIHESAPKOD != '')
				
				document.all.chkod.innerText='(Cari Hesap Kodu : '+ get_carihesapkod.CARIHESAPKOD + ')';
		}
	</script>
</cfif>
