<!--- bu sayfaının nerde ise aynısı hr modülündede var bu sayfada yapılan değişiklikler hr deki dosyayada taşınsın--->
<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=myhome.popup_select_list_search&list_id=#attributes.list_id#">

	<table cellspacing="1" cellpadding="2" width="98%" height="100%" border="0" class="color-border" align="center">
		<tr class="color-list" height="35">
			<td class="headbold"><cf_get_lang no='1566.Seçim Listesinde Aday Ara'>
			</td>
		</tr>
		<tr class="color-row">
			<td valign="top">
			<table width="100%">
				<tr>
					<td><cf_get_lang_main no='344.Durum'></td>
					<td>
					<select name="status" id="status">
					<option value="" selected><cf_get_lang_main no='296.Tümü'>
					<option value="1"><cf_get_lang_main no='81.Aktif'>
					<option value="0"><cf_get_lang_main no='82.Pasif'>			                        
					</select> 	 
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no='1569.Çalışmak İstediği Yer'></td>
					<cfquery name="get_city" datasource="#dsn#">
						SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
					</cfquery>
					<td colspan="3">
						<select name="prefered_city" id="prefered_city" style="width:150px;">
							<option value=""><cf_get_lang no='946.TÜM TÜRKİYE'></option>
							<cfoutput query="get_city">
								<option value="#city_id#">#city_name#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td width="125"><cf_get_lang_main no='219.Ad'></td>
					<td><input type="text" name="app_name" id="app_name" value="" style="width:150px;"></td>
				</tr>
				<tr>
					<td width="125"><cf_get_lang_main no='1314.Soyad'></td>
					<td><input type="text" name="app_surname" id="app_surname" value="" style="width:150px;"></td>
				</tr>
				<tr>
					<td width="125"><cf_get_lang no='748.Yaş'></td>
					<td>
					<cfsavecontent variable="message"><cf_get_lang no='1572.Yaş rakamla girmelisiniz'></cfsavecontent>
					<cfinput type="text" style="width:70px;" name="birth_date1" value="" validate="integer" range="1," maxlength="2" message="#message#">
					<cfinput type="text" style="width:70px;" name="birth_date2" value="" validate="integer" range="1," maxlength="2" message="#message#">
					</td>
					</tr>
					<tr>
					<td><cf_get_lang no='446.Medeni Durum'></td>
					<td>
					<input type="checkbox" name="married" id="married" value="0"><cf_get_lang no='448.Bekar'>
					<input type="checkbox" name="married" id="married" value="1"><cf_get_lang no='447.Evli'>
					</td>
				</tr>
				<tr>
					<td width="125"><cf_get_lang_main no='352.Cinsiyet'></td>
					<td>
						<input type="checkbox" name="sex" id="sex" value="1"><cf_get_lang_main no='1547.Erkek'>
						<input type="checkbox" name="sex" id="sex" value="0"><cf_get_lang_main no='1546.Kadın'>
					</td>
				</tr>
				<tr>
					<td width="85"><cf_get_lang no='947.Seyahat Edebilir mi'>?</td>
					<td><input type="checkbox" name="is_trip" id="is_trip" value="1"></td>
				</tr>
				<tr>
					<td width="85"><cf_get_lang no='1576.Ehliyeti Var mı'></td>
					<td><input type="checkbox" name="driver_licence" id="driver_licence" value="1">
					<cf_get_lang no='1577.Ehliyet Sınıf'><cfinput type="Text" name="driver_licence_type" maxlength="15"  style="width:45px;">
					</td>
				</tr>
				<tr height="22">
					<td height="21"><cf_get_lang no='452.Askerlik'></td>
					<td>
					<input type="checkbox" name="military_status" id="military_status" value="0"><cf_get_lang no='453.Yapmadı'>
					<input type="checkbox" name="military_status" id="military_status" value="1"><cf_get_lang no='454.Yaptı'>
					<input type="checkbox" name="military_status" id="military_status" value="2"><cf_get_lang no='455.Muaf'>
					<input type="checkbox" name="military_status" id="military_status" value="3"><cf_get_lang no='456.Yabancı'>
					<input type="checkbox" name="military_status" id="military_status" value="4"><cf_get_lang no='457.Tecilli'>
					</td>
				</tr>
				<tr>
					<td width="125"><cf_get_lang no='1578.Deneyim'></td>
					<td colspan="3">
						<cfsavecontent variable="message"><cf_get_lang no='1579.Deneyimi rakamla giriniz'></cfsavecontent>
						<cfinput name="exp_year_s1" style="width:70px;" value="" validate="integer" range="0,99" maxlength="2" message="#message#"> 
						/ <cfinput name="exp_year_s2" style="width:70px;" value="" validate="integer" range="0,99" maxlength="2" message="#message#"><cf_get_lang_main no='1043.Yıl'>
					</td>
				</tr>
				<cfquery name="GET_EDU4" datasource="#DSN#">
					SELECT
						SCHOOL_ID,
						SCHOOL_NAME
					FROM
						SETUP_SCHOOL
					ORDER BY SCHOOL_NAME
				</cfquery>
			<tr>
				<td><cf_get_lang_main no='1958.Üniversite'></td>
				<td>
					<select name="edu4" id="edu4">
					<option value=""><cf_get_lang_main no='1958.Üniversite'></option>
					<cfloop query="GET_EDU4">
					<option value="<cfoutput>#GET_EDU4.SCHOOL_ID#</cfoutput>"><cfoutput>#GET_EDU4.SCHOOL_NAME#</cfoutput></option>
					</cfloop>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang_main no='583.Bölüm'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<cfsavecontent variable="text"><cf_get_lang_main no='583.Bölüm'></cfsavecontent>
					<cf_wrk_combo
						name="edu4_part"
						query_name="GET_SCHOOL_PART"
						option_name="PART_NAME"
						option_value="PART_ID"
						option_text="#text#">
				</td>
			</tr>
				
				<!--- <cfquery name="get_edu4" datasource="#DSN#">
					SELECT DISTINCT
						EDU4
					FROM
						EMPLOYEES_APP
					WHERE
						EDU4 <> ''
					ORDER BY EDU4
				</cfquery>
				<cfquery name="get_edu4_part" datasource="#DSN#">
					SELECT DISTINCT
						EDU4_PART
					FROM
						EMPLOYEES_APP
					WHERE
						EDU4_PART <> ''
					ORDER BY EDU4_PART
				</cfquery>
				<tr>
					<td><cf_get_lang_main no='1958.Üniversite'></td>
					<td>
					<select name="edu4">
					<option value=""><cf_get_lang_main no='1958.Üniversite'></option>
					<cfloop query="GET_EDU4">
					<option value="<cfoutput>#EDU4#</cfoutput>"><cfoutput>#GET_EDU4.EDU4#</cfoutput></option>
					</cfloop>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang_main no='583.Bölüm'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<select name="edu4_part">
					<option value=""><cf_get_lang_main no='583.Bölüm'></option>
					<cfloop query="get_edu4_part">
					<option value="<cfoutput>#edu4_part#</cfoutput>"><cfoutput>#get_edu4_part.edu4_part#</cfoutput></option>
					</cfloop>
					</select>
					</td>
				</tr> --->
				<tr>
					<td></td>
					<td height="35">
					<cfsavecontent variable="message"><cf_get_lang_main no='153.Ara'></cfsavecontent>
					<cf_workcube_buttons is_upd='0' insert_info='#message#' insert_alert='' >
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
</cfform>
