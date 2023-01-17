<cf_xml_page_edit fuseact="settings.form_add_period">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfform name="period1" method="post"action="#request.self#?fuseaction=settings.emptypopup_period_add">
	<cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
		<input type="hidden" name="is_special_period_date" id="is_special_period_date" value="<cfoutput>#is_special_period_date#</cfoutput>" />
	<cfelse>
		<input type="hidden" name="is_special_period_date" id="is_special_period_date" value="" />
	</cfif>
	<cf_box title="#getLang(499,'Muhasebe Dönemleri',42172)#">
		<cf_box_elements>			
			<div class="col col-3 col-xs-12" type="column" index="1" sort="true">
				<div class="scrollbar" style="max-height:403px;overflow:auto;">
					<div id="cc">
						<cfinclude template="../display/list_periods.cfm">
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-IS_INTEGRATED">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42485.Entegre'> * </label>
					<div class="col col-4 col-xs-12">
						<cfinput type="Checkbox" name="IS_INTEGRATED" id="IS_INTEGRATED" value="1">
					</div>
					<div class="col col-4 col-xs-12">
						<cf_get_lang dictionary_id='57495.Evet'>
					</div>
				</div>
				<div class="form-group" id="item-IS_OLD_ACCOUNT_PLAN">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42739.Hesap Planı Önceki Döneme Göre al'> *</label>
					<div class="col col-4 col-xs-12">
						<cfinput type="checkbox" name="IS_OLD_ACCOUNT_PLAN" id="IS_OLD_ACCOUNT_PLAN" checked="yes" value="1" >
					</div>
					<div class="col col-4 col-xs-12">
						<cf_get_lang dictionary_id='57495.Evet'>
					</div>
				</div>
				<div class="form-group" id="item-COMPANY_ID">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
					<div class="col col-8 col-xs-12">
						<cfquery name="OUR_COMPANY" datasource="#DSN#">
							SELECT 
								COMP_ID,
								COMPANY_NAME,
								NICK_NAME
							FROM 
								OUR_COMPANY
							ORDER BY 
								COMPANY_NAME
						</cfquery>
						<select name="COMPANY_ID" id="COMPANY_ID">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfif our_company.recordcount>
								<cfoutput query="our_company">
									<option value="#comp_id#" <cfif currentrow is 1>selected</cfif>>#company_name#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-period_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42483.Dönem Adı'> *</label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="period_name" id="period_name" size="60" value="" maxlength="50" required="Yes" message="#getLang('','Dönem Adı girmelisiniz',42617)#">
					</div>
				</div>
				<div class="form-group" id="item-inventory_calc_type">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42074.Envanter Yöntemi '></label>
					<div class="col col-8 col-xs-12">
						<select name="inventory_calc_type" id="inventory_calc_type">
							<option value="3"><cf_get_lang dictionary_id='42100.Ağırlıklı Ortalama'></option>
							<option value="1"><cf_get_lang dictionary_id='42193.İlk Giren İlk Çıkar'></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-period_year">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42484.Dönem Yılı'> </label>
					<div class="col col-8 col-xs-12">
						<!--- bulundugu donemden bir onceki yil ile bir sonraki yıl arasinda donem acilir --->
						<select name="period_year" id="period_year">
							<cfloop from="#session.ep.period_year-5#" to="#session.ep.period_year+1#" index="i">
								<cfoutput>
								<option value="#i#"<cfif i eq dateformat(now(),'yyyy')> selected</cfif>>#i# 
								</cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-PERIOD_DATE">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51145.Muhasebe İşlem Tarihi Kısıtı'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput validate="#validate_style#" message="#getLang('','Lutfen Tarih Giriniz',58503)#!" type="text" name="PERIOD_DATE" id="PERIOD_DATE">
							<span class="input-group-addon"><cf_wrk_date_image date_field="PERIOD_DATE"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-budget_period_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60556.Bütçe İşlem Tarih Kısıtı'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput validate="#validate_style#" message="#getLang('','Lutfen Tarih Giriniz',58503)#!" type="text" name="budget_period_date" id="budget_period_date">
							<span class="input-group-addon"><cf_wrk_date_image date_field="budget_period_date"></span>
						</div>
					</div>
				</div>
				<cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
				<div class="form-group" id="item-finish_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58690.Tarih Aralığı"></label>
					<div class="col col-4 col-xs-12">
						<div class="input-group">
							<cfinput validate="#validate_style#" message="#getLang('','Lutfen Tarih Giriniz',58503)#!" type="text" name="start_date" id="start_date">							
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date">
						</div>
					</div>
					<div class="col col-4 col-xs-12">
					<div class="input-group">
						<cfinput validate="#validate_style#" message="#getLang('','Lutfen Tarih Giriniz',58503)#!" type="text" name="finish_date" id="finish_date">						
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date">
						</div>
					</div>
				</div>
				</cfif>
				<div class="form-group" id="item-other_money">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43267.İkinci Döviz Birimi'> *</label>
					<div class="col col-8 col-xs-12">
						<select name="other_money" id="other_money">
							<option value=""><cf_get_lang dictionary_id ='58474.Para Br'></option>
							<cfoutput query="get_money">
								<option value="#money#">#money#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-standart_process_money">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='43708.Standart İşlem Dövizi'></label>
					<div class="col col-8 col-xs-12">
						<select name="standart_process_money" id="standart_process_money">
							<option value=""><cf_get_lang dictionary_id ='58474.Para Br'></option>
							<cfoutput query="get_money">
								<option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfif not (isdefined("database_password") and len(database_password)) or (isdefined("database_password") and not len(database_password)) and fusebox.use_period>
					<div class="form-group" id="item-tr_db_username">
						<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='33511.DB Kullanıcı Adı'>*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="db_username" id="db_username" value="" >
						</div>
					</div>
					<div class="form-group" id="item-tr_db_password">
						<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='33515.DB Şifresi'>*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="password" name="db_password" id="db_password" value="" >
						</div>
					</div>
					<div class="form-group" id="item-tr_db_password">
						<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='33516.CF Şifresi'>*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="password" name="cf_admin_password" id="cf_admin_password" value="" required="yes"  message="#getLang('','Coldfusion Admin Şifresi Girmelisiniz',61079)#!">
						</div>
					</div>
				</cfif>
			</div>
			<div class="col col-5 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="text-bold" style="font-size:x-large;"><cf_get_lang dictionary_id='57433.Yardım'></div>
				<cftry>
					<cfinclude template="#file_web_path#templates/period_help/addPeriod_#session.ep.language#.html">
					<cfcatch>
						<script type="text/javascript">
							alert("<cf_get_lang dictionary_id='29760.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
						</script>
					</cfcatch>
				</cftry>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='chk()'>
		</cf_box_footer>
	</cf_box>
</cfform>
<script type="text/javascript">
function chk()
{
	
		if (document.period1.COMPANY_ID.options[document.period1.COMPANY_ID.selectedIndex].value == "")
		{
			alert("<cf_get_lang dictionary_id='43709.Lütfen Şirket Seçiniz Eğer Kayıtlı Bir Şirket Yoksa Önce Şirket Tanımlayınız'>");
			return false;
		} 
		if (document.period1.other_money.value == "")
		{
			alert("<cf_get_lang dictionary_id='43267.İkinci Döviz Birimi'> <cf_get_lang dictionary_id='57734.Seçiniz'> !");
			return false;
		} 
		<cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
			if(document.getElementById('start_date').value !='' && document.getElementById('finish_date').value != '')
			{
				if (!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!"))
					return false;
				else
					return true;	
			}
		</cfif>
	
		if(document.getElementById('db_password').value=='')
		{
			alert("Veritanı Şifre Hanesi boş geçilemez");
			return false;
		}
		if(document.getElementById('db_username').value =='')
		{
			alert("<cf_get_lang dictionary_id='61080.Veritanı Kullanıcı Adı Hanesi boş geçilemez'>");
			return false;
		}
	
}

function  check_win_auth()
{
			document.getElementById('tr_db_password').style.display = "";
			document.getElementById('tr_db_username').style.display = "";
}
</script>
