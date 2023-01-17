<cf_xml_page_edit fuseact="settings.form_add_period">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cf_form_box title="#getLang('settings',2070,'Kurumsal Üye Dönem Aktarım (Geçişli)')#">
	<cf_area width="20%">
		<table>
		<tr>
		<td width="250"><cfinclude template="../display/list_periods.cfm">
	  	</td>
		  </tr>
		  </table>
	</cf_area>
    <cf_area  width="25%">
			<table>
			<cfform name="period1" method="post"action="#request.self#?fuseaction=settings.emptypopup_period_add">
				<cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
					<input type="hidden" name="is_special_period_date" id="is_special_period_date" value="<cfoutput>#is_special_period_date#</cfoutput>" />
				<cfelse>
					<input type="hidden" name="is_special_period_date" id="is_special_period_date" value="" />
				</cfif>
				<tr>
					<td><cf_get_lang_main no='162.Şirket'>*</td>
					<td>
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
						<select name="COMPANY_ID" id="COMPANY_ID" style="width:200px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfif our_company.recordcount>
								<cfoutput query="our_company">
									<option value="#comp_id#" <cfif currentrow is 1>selected</cfif>>#company_name#</option>
								</cfoutput>
							</cfif>
						</select>
					</td>
				</tr>
				<tr>
					<td width="100"><cf_get_lang no='500.Dönem Adı'> *</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang no='634.Dönem Adı girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="period_name" id="period_name" size="60" value="" maxlength="50" required="Yes" message="#message#" style="width:200px;">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no='91.Envanter Yöntemi '></td>
					<td>
						<select name="inventory_calc_type" id="inventory_calc_type" style="width:200px;">
							<option value="3"><cf_get_lang no='117.Ağırlıklı Ortalama'></option>
							<option value="1"><cf_get_lang no='210.İlk Giren İlk Çıkar'></option>
							<!--- <option value="2"><cf_get_lang no='70.Son Giren İlk Çıkar'></option> --->
							<!--- <option value="4"><cf_get_lang no='72.Son Alış Fiyatı'></option>
							<option value="5"><cf_get_lang no='73.İlk Alış Fiyatı'></option>
							<option value="6"><cf_get_lang_main no='1310.Standart Alış'></option>
							<option value="7"><cf_get_lang_main no='1309.Standart Satış'></option>
							<option value="8"><cf_get_lang no='74.Üretim Maliyeti'></option> --->
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no='501.Dönem Yılı'> </td>
					<td>
						<!--- bulundugu donemden bir onceki yil ile bir sonraki yıl arasinda donem acilir --->
						<select name="period_year" id="period_year">
							<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+1#" index="i">
								<cfoutput>
								<option value="#i#"<cfif i eq dateformat(now(),'yyyy')> selected</cfif>>#i# 
								</cfoutput>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no='502.Entegre'> *</td>
					<td><cfinput type="Checkbox" name="IS_INTEGRATED" id="IS_INTEGRATED" value="1"><cf_get_lang_main no='83.Evet'></td>
				</tr>
				<tr>
					<td><cf_get_lang no='756.Hesap Planı Önceki Döneme Göre al'> *</td>
					<td><cfinput type="checkbox" name="IS_OLD_ACCOUNT_PLAN" id="IS_OLD_ACCOUNT_PLAN" checked="yes" value="1" ><cf_get_lang_main no='83.Evet'></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='330.Tarih'></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'>!</cfsavecontent>
						<cfinput validate="#validate_style#" message="#message#" type="text" name="PERIOD_DATE" id="PERIOD_DATE" style="width:70px;">
						<cf_wrk_date_image date_field="PERIOD_DATE">
					</td>
				</tr>
				<cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
					<tr>
						<td>Tarih Aralığı</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'>!</cfsavecontent>
							<cfinput validate="#validate_style#" message="#message#" type="text" name="start_date" id="start_date" style="width:70px;">
							<cf_wrk_date_image date_field="start_date">
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'>!</cfsavecontent>
							<cfinput validate="#validate_style#" message="#message#" type="text" name="finish_date" id="finish_date" style="width:70px;">
							<cf_wrk_date_image date_field="finish_date">
						</td>
					</tr>
				</cfif>
				<tr>
					<td><cf_get_lang no='1284.İkinci Döviz Birimi'> *</td>
					<td>
						<select name="other_money" id="other_money" style="width:70px">
							<option value=""><cf_get_lang_main no ='1062.Para Br'></option>
							<cfoutput query="get_money">
								<option value="#money#">#money#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no ='1725.Standart İşlem Dövizi'></td>
					<td>
						<select name="standart_process_money" id="standart_process_money" style="width:70PX;">
							<option value=""><cf_get_lang_main no ='1062.Para Br'></option>
							<cfoutput query="get_money">
								<option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<cfif not (isdefined("database_password") and len(database_password)) or (isdefined("database_password") and not len(database_password)) and fusebox.use_period>
					<tr>
						<td colspan="2" height="22" class="txtboldblue">Database Bilgileri</td>
					</tr>
					<tr>
						<td>Windows Auth</td>
						<td><input type="checkbox" name="is_windows_auth" id="is_windows_auth" value="1" onchange="check_win_auth()" /></td>
					</tr>
					<tr id="tr_db_username">
						<td width="100" class="txtbold">DB Kullanıcı Adı*</td>
						<td><cfinput type="text" style="width:100px;" name="db_username" id="db_username" value="" ></td>
					</tr>
					<tr id="tr_db_password">
						<td class="txtbold">DB Şifresi*</td>
						<td><cfinput type="password" style="width:100px;" name="db_password" id="db_password" value="" ></td>
					</tr>
					<tr>
						<td class="txtbold">CF Şifresi*</td>
						<td><cfinput type="password" style="width:100px;" name="cf_admin_password" id="cf_admin_password" value="" required="yes"  message="Coldfusion Admin Şifresi Girmelisiniz!"></td>
					</tr>
				</cfif>
				<tr>
					<td></td>
					<td><cf_workcube_buttons is_upd='0' add_function='chk()'></td>
				</tr>
			</cfform>
			</table>
	</cf_area>
    <cf_area width="55%">
			<table>
				<tr height="30">
					<td class="headbold" valign="top"><cf_get_lang_main no='21.Yardım'></td>
				</tr>    
				<tr>
					<td valign="top"> 
						<cftry>
							<cfinclude template="#file_web_path#templates/period_help/addPeriod_#session.ep.language#.html">
							<cfcatch>
								<script type="text/javascript">
									alert("<cf_get_lang_main no='1963.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
								</script>
							</cfcatch>
						</cftry>
					</td>
				</tr>
			</table>
	</cf_area>
	</tr>
</cf_form_box>
<script type="text/javascript">
function chk()
{
	
		if (document.period1.COMPANY_ID.options[document.period1.COMPANY_ID.selectedIndex].value == "")
		{
			alert("<cf_get_lang no='1726.Lütfen Şirket Seçiniz Eğer Kayıtlı Bir Şirket Yoksa Önce Şirket Tanımlayınız'>");
			return false;
		} 
		if (document.period1.other_money.value == "")
		{
			alert("Lütfen <cf_get_lang no='1284.İkinci Döviz Birimi'> Seçiniz !");
			return false;
		} 
		<cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
			if(document.getElementById('start_date').value !='' && document.getElementById('finish_date').value != '')
			{
				if (!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!"))
					return false;
				else
					return true;	
			}
		</cfif>
	
		
	if(document.getElementById('is_windows_auth').checked  == false )
	{
		if(document.getElementById('db_password').value=='')
		{
			alert("Veritanı Şifre Hanesi boş geçilemez");
			return false;
		}
		if(document.getElementById('db_username').value =='')
		{
			alert("Veritanı Kullanıcı Adı Hanesi boş geçilemez");
			return false;
		}
	}	
}

function  check_win_auth()
{
	
		if(document.getElementById('is_windows_auth').checked  == true )
		{
			document.getElementById('tr_db_password').style.display = "none";
			document.getElementById('tr_db_username').style.display = "none";
		}
		else
		{
			document.getElementById('tr_db_password').style.display = "";
			document.getElementById('tr_db_username').style.display = "";
		}	
}
</script>
