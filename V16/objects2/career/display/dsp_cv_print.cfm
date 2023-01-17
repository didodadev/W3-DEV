<cfsetting showdebugoutput="no">
<cfif isdefined("session.cp.userid")>
	<cfset EMPAPP_ID = attributes.empapp_id>
	<cfset EMPAPP_ID = session.cp.userid>
<cfelseif isdefined("session.pp.userid")>
	<cfset EMPAPP_ID = attributes.empapp_id>
</cfif>
<cfquery name="GET_APP" datasource="#DSN#">
	SELECT 
		EA.*,
		EI.MARRIED,
		EI.BIRTH_DATE,
		EI.BIRTH_PLACE
	FROM 
		EMPLOYEES_APP EA, EMPLOYEES_IDENTY EI
	WHERE 
		EA.EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> AND 
		EI.EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#">
</cfquery>
<cfquery name="get_app_work_info" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_APP_WORK_INFO
	WHERE
		EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#">
</cfquery>
<cfquery name="get_app_edu_info" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_APP_EDU_INFO
	WHERE
		EMPAPP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> AND
		EDU_TYPE NOT IN (1,2)
	ORDER BY EDU_START DESC
</cfquery>
<cfquery name="get_app_unit" datasource="#dsn#"> 
	SELECT UNIT_ID,UNIT_ROW FROM EMPLOYEES_APP_UNIT WHERE EMPAPP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#EMPAPP_ID#">
</cfquery>
<cfquery name="get_cv_unit" datasource="#DSN#">
	SELECT * FROM SETUP_CV_UNIT WHERE IS_VIEW=1
</cfquery>
<cfif get_app.recordcount>
<cfoutput query="get_app">
	<cfquery name="KNOW_LEVELS" datasource="#dsn#">
		SELECT * FROM SETUP_KNOWLEVEL
	</cfquery>
	<cfif len(get_app.homecity)>
		<cfquery name="get_city" datasource="#dsn#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.homecity#">
		</cfquery>
	</cfif>
	<cfif len(get_app.homecountry)>
		<cfquery name="get_country" datasource="#dsn#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.homecountry#">
		</cfquery>
	</cfif>
<!--- 	<cfif len(get_app.edu4_id)>
		<cfquery name="get_edu4_1" datasource="#dsn#">
			SELECT SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID=#get_app.edu4_id#
		</cfquery>
	</cfif>
	<cfif len(get_app.edu4_id_2)>
		<cfquery name="get_edu4_2" datasource="#dsn#">
			SELECT SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID=#get_app.edu4_id_2#
		</cfquery>
	</cfif>
	<cfif len(get_app.edu4_part_id)>
		<cfquery name="get_edu4_part_1" datasource="#dsn#">
			SELECT PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID=#get_app.edu4_part_id#
		</cfquery>
	</cfif>
	<cfif len(get_app.edu4_part_id_2)>
		<cfquery name="get_edu4_part_2" datasource="#dsn#">
			SELECT PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID=#get_app.edu4_part_id_2#
		</cfquery>
	</cfif>
	<cfif len(get_app.edu3_part)>
		<cfquery name="get_edu3_part" datasource="#dsn#">
			SELECT HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID=#get_app.edu3_part#
		</cfquery>
	</cfif> --->
	<cfif len(get_app.training_level)>
		<cfquery name="get_edu_level" datasource="#dsn#">
			SELECT EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.training_level#">
		</cfquery>
	</cfif>
	<cfquery name="GET_CITY_NAME" datasource="#dsn#">
		SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
	</cfquery>
<div align="center">
<br/><br/><br/><br/><br/>
<table  border="0" width="98%">
<tr>
	<!-- sil -->
	<td  style="text-align:right;"><a href="javascript://" onclick="<cfoutput>windowopen('#request.self#?fuseaction=objects2.popup_dsp_cv_print&print=true#page_code#','page')</cfoutput>" title="<cf_get_lang_main no='1331.Gönder'>"><img src="/images/print.gif" alt="<cf_get_lang_main no='1331.Gönder'>" border="0" /></a></td>
	<cf_workcube_file_action pdf='0' mail='1' doc='0' print='0'>
	<!-- sil -->
</tr>
<tr>
<td>
<table style="width:175mm" align="center" border="1" cellpadding="0" cellspacing="0">
<tr>
	<td width="10" class="txtbold">&nbsp;I &nbsp;L &nbsp;E &nbsp;T &nbsp;I &nbsp;S &nbsp;I &nbsp;M&nbsp;</td>
	<td valign="top" width="750" align="center">
		<table width="100%" border="0" cellspacing="2" cellpadding="1" height="100%">
		<tr>
			<td class="txtbold" width="107"><cf_get_lang_main no='158.Ad Soyad'>:</td>
			<td class="headbold">#get_app.name# #get_app.surname#<br/></td>
			<td rowspan="10" width="120">
				<table border="0" width="100%" height="100%"><tr><td align="center">
				<cfif len(get_app.photo)>
					<img src="<cfoutput>#file_web_path#hr/#get_app.photo#</cfoutput>" border="0" width="120" height="140" alt="<cf_get_lang no='207.Fotoğraf'>" title="<cf_get_lang no='207.Fotoğraf'>" align="center" />
				<cfelse>
					<cf_get_lang_main no='716.Fotografi Yok'>
				</cfif>
				</td></tr></table>
			</td>
		</tr>
		<tr>
			<td class="txtbold" width="107"></td>
			<td>#get_app.homeaddress# #get_app.homecounty# 	<br/><cfif len(get_app.homecity)>#get_city.city_name#</cfif><cfif len(get_app.homecountry)>#get_country.country_name#</cfif><cfif len(get_app.homepostcode)> - #get_app.homepostcode#</cfif><br/></td>
		</tr>
		<tr>
			<td width="107"><cfif len(get_app.hometel)><b><cf_get_lang no='226.Ev'>:</b></cfif></td>
			<td>
			<cfif len(get_app.hometel)>
				#get_app.hometelcode# #get_app.hometel#<br/>
			<cfelse>&nbsp;
			</cfif>
			</td>
		</tr>
		<tr>
			<td width="107"><cfif len(get_app.worktel)><b><cf_get_lang no='227.Is'>:</b></cfif></td>
			<td>
			<cfif len(get_app.worktel)>
				 #get_app.worktelcode# #get_app.worktel#<br/>
				<cfelse>&nbsp;
			</cfif>
			</td>
		</tr>
		<tr>
			<td width="107"><cfif len(get_app.mobil)><b><cf_get_lang_main no='1070.Cep'>:</b></cfif></td>
			<td><cfif len(get_app.mobil)>#get_app.mobilcode# #get_app.mobil#<br/><cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td width="107"><cfif len(get_app.mobil2)><b><cf_get_lang_main no='1070.Cep'>:</b></cfif></td>
			<td><cfif len(get_app.mobil2)>#get_app.mobilcode2# #get_app.mobil2#<br/><cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td class="txtbold" width="107"><cf_get_lang_main no='16.Email'>:</td>
			<td>#get_app.email#</td>
		</tr>
		</table>  
	</td>
</tr>
<tr>
	<td width="10" class="txtbold">&nbsp;K &nbsp;I &nbsp;S &nbsp;I &nbsp;S &nbsp;E &nbsp;L</td>
	<td>
		<table>
			<tr>
				<td class="txtbold"><cf_get_lang_main no='1315.Doğum Tarihi'>:</td>
				<td>#dateformat(get_app.birth_date,'dd/mm/yyyy')#</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang_main no='378.Doğum Yeri'> (<cf_get_lang_main no='1226.İlçe'> / <cf_get_lang_main no='559.İl'>):</td>
				<td>#get_app.birth_place#</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang no='910.Ehliyet'>:</td>
				<td><cfif isdefined('get_app.driver_licence_type') and len(get_app.driver_licence_type)>
						<cf_get_lang_main no='1152.Var'> <cf_get_lang no='912.Sınıfı'>: #get_app.driver_licence_type#
					<cfelse>
						<cf_get_lang_main no='1134.Yok'>
					</cfif>
				</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang no='815.Medeni Durum'>:</td>
				<td><cfif get_app.married eq 1>
					<cf_get_lang no='209.Evli'>
				<cfelse>
					<cf_get_lang no='816.Bekar'>
				</cfif>
				</td>
			</tr>
			<cfif get_app.married eq 1 and len(get_app.child)>
			<tr>
				<td class="txtbold"><cf_get_lang no='206.Çocuk Sayısı'>:</td>
				<td>#get_app.child#</td>
			</tr>
			</cfif>
			<tr>
				<td class="txtbold"><cf_get_lang no='820.Askerlik Durumu'>:</td>
				<td><cfif get_app.military_status eq 1> 
						<cf_get_lang no='320.Yaptı'> <cfif len(get_app.military_finishdate)>#dateformat(get_app.military_finishdate,'dd/mm/yyyy')#</cfif>
					<cfelseif get_app.military_status eq 2>
						<cf_get_lang no='321.Muaf'> #get_app.military_exempt_detail#
					<cfelseif get_app.military_status eq 3>
						<cf_get_lang no='322.Yabancı'>
					<cfelseif get_app.military_status eq 4>
						<cf_get_lang no='323.Tecilli'> #get_app.military_delay_reason# <cfif len(get_app.military_delay_date)>#dateformat(get_app.military_delay_date,'dd/mm/yyyy')#</cfif>
					</cfif>
				</td>
			</tr>
			<cfif len(get_app.hobby)>
         	<tr>
				<td class="txtbold"><cf_get_lang no='857.Özel İlgi Alanlarınız'>:</td>
				<td><cfoutput>#get_app.hobby#</cfoutput></td>
			</tr>
			</cfif>
			<tr>
				<td class="txtbold"><cf_get_lang no='858.Üye Olduğunuz Klüp Ve Dernekler'>:</td>
				<td>&nbsp;&nbsp;#get_app.club#</td>
			</tr>
			<cfif get_app.defected eq 1>
			<tr>
				<td class="txtbold"><cf_get_lang no='913.Fiziksel Engel'>:</td>
				<td> %<cfoutput>#get_app.defected_level#</cfoutput> <cf_get_lang no='915.engelli'></td>
			</tr>
			</cfif>
			<cfif get_app.sentenced eq 1>
			<tr>
				<td class="txtbold"><cf_get_lang no='818.Hiç Yargılandınız mı ve/veya Hüküm Giydiniz mi'>:</td>
				<td><cf_get_lang_main no='83.Evet'></td>
			</tr>
			</cfif>
			<cfif get_app.martyr_relative eq 1>
			<tr>
				<td class="txtbold"><cf_get_lang no='307.Şehit Yakını Misiniz'></td>
				<td>&nbsp;<cf_get_lang_main no='83.Evet'></td>
				
			</tr>
			</cfif>
	</table>
</td>
</tr>
<tr>
	<td width="10" class="txtbold">&nbsp;E &nbsp;Ğ &nbsp;İ &nbsp;T &nbsp;İ &nbsp;M</td>
	<td>
		<table>
			<tr>
				<td class="txtbold"><cf_get_lang no='225.Eğitim Bilgileri'>:</td>
				<td><cfif len(get_app.training_level)>#get_edu_level.EDUCATION_NAME#<cfelse> - </cfif></td>
			</tr>
			<cfloop query="get_app_edu_info">
				<tr>
					<td class="txtbold"><cfif get_app_edu_info.edu_type eq 1><cf_get_lang no='837.İlköğretim'><cfelseif get_app_edu_info.edu_type eq 2><cf_get_lang no='523.Ortaokul'><cfelseif get_app_edu_info.edu_type eq 3><cf_get_lang no='524.Lise'><cfelseif get_app_edu_info.edu_type eq 4><cf_get_lang_main no='1958.Üniversite'><cfelseif get_app_edu_info.edu_type eq 5><cf_get_lang no='526.Yükseklisans'><cfelseif get_app_edu_info.edu_type eq 6><cf_get_lang no='840.Doktora'></cfif></td>
					<td>#get_app_edu_info.edu_name#</td>
				</tr>
				<tr>
					<td class="txtbold"></td>
					<td>#get_app_edu_info.edu_part_name# (#get_app_edu_info.edu_start# - #get_app_edu_info.edu_finish#)</td>
				</tr>
			</cfloop>
		<tr>
			<td class="txtbold"><cf_get_lang no='841.Yabancı Dil'>:</td>
			<td><cfif len(get_app.lang1)>
					<cfquery name="get_lang" datasource="#dsn#">
						SELECT LANGUAGE_SET FROM SETUP_LANGUAGES WHERE LANGUAGE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang1#">
					</cfquery>
						#get_lang.language_set# 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang1_write)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang1_write#"><cfelse>0</cfif>
					</cfquery>
						(<cf_get_lang no='844.Yazma'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang1_mean)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang1_mean#"><cfelse>0</cfif>
					</cfquery>
						<cf_get_lang no='843.Anlama'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang1_speak)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang1_speak#"><cfelse>0</cfif>
					</cfquery>
						<cf_get_lang no='842.Konuşma'>: #know_level.knowlevel#)<br/>
				</cfif>
				<cfif len(get_app.lang2)>
					<cfquery name="get_lang" datasource="#dsn#">
						SELECT LANGUAGE_SET FROM SETUP_LANGUAGES WHERE LANGUAGE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang2#">
					</cfquery>
						#get_lang.language_set# 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang2_write)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang2_write#"><cfelse>0</cfif>
					</cfquery>
						(<cf_get_lang no='844.Yazma'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang2_mean)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang2_mean#"><cfelse>0</cfif>
					</cfquery>
						<cf_get_lang no='843.Anlama'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang2_speak)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang2_speak#"><cfelse>0</cfif>
					</cfquery>
						<cf_get_lang no='842.Konuşma'>: #know_level.knowlevel#)<br/>
				</cfif>
				<cfif len(get_app.lang3)>
					<cfquery name="get_lang" datasource="#dsn#">
						SELECT LANGUAGE_SET FROM SETUP_LANGUAGES WHERE LANGUAGE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang3#">
					</cfquery>
						#get_lang.language_set# 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang3_write)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang3_write#"><cfelse>0</cfif>
					</cfquery>
						(<cf_get_lang no='844.Yazma'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang3_mean)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang3_mean#"><cfelse>0</cfif>
					</cfquery>
						<cf_get_lang no='843.Anlama'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang3_speak)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang3_speak#"><cfelse>0</cfif>
					</cfquery>
						<cf_get_lang no='842.Konuşma'>: #know_level.knowlevel#)<br/>
				</cfif>
				<cfif len(get_app.lang4)>
					<cfquery name="get_lang" datasource="#dsn#">
						SELECT LANGUAGE_SET FROM SETUP_LANGUAGES WHERE LANGUAGE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang4#">
					</cfquery>
						#get_lang.language_set# 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang4_write)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang4_write#"><cfelse>0</cfif>
					</cfquery>
						(<cf_get_lang no='844.Yazma'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang4_mean)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang4_mean#"><cfelse>0</cfif>
					</cfquery>
						<cf_get_lang no='843.Anlama'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang4_speak)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang4_speak#"><cfelse>0</cfif>
					</cfquery>
						<cf_get_lang no='842.Konuşma'>: #know_level.knowlevel#)<br/>
				</cfif>
				<cfif len(get_app.lang5)>
					<cfquery name="get_lang" datasource="#dsn#">
						SELECT LANGUAGE_SET FROM SETUP_LANGUAGES WHERE LANGUAGE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang5#">
					</cfquery>
						#get_lang.language_set# 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang5_write)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang5_write#"><cfelse>0</cfif>
					</cfquery>
						(<cf_get_lang no='844.Yazma'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang5_mean)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang5_mean#"><cfelse>0</cfif>
					</cfquery>
						<cf_get_lang no='843.Anlama'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app.lang5_speak)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.lang5_speak#"><cfelse>0</cfif>
					</cfquery>
						<cf_get_lang no='842.Konuşma'>: #know_level.knowlevel#)
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang no='847.Bilgisayar Bilgileri'>:</td>
			<td>#get_app.comp_exp#</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td width="10" class="txtbold">&nbsp;D  &nbsp;E  &nbsp;N  &nbsp;E  &nbsp;Y &nbsp;İ &nbsp;M</td>
		<td valign="top">
			<table vspace="top" border="0">
			<cfloop query="get_app_work_info">
				<tr>
					<td class="txtbold" width="100">&nbsp;</td>
					<td width="180" align="left">&nbsp;&nbsp;<b>#dateformat(get_app_work_info.exp_start,'mm/yyyy')# - #dateformat(get_app_work_info.exp_finish,'mm/yyyy')#</b></td>
					<td width="30" class="txtbold">&nbsp;</td>
					<td width="150">&nbsp;&nbsp;<b>#get_app_work_info.exp#</b></td>
					<td width="30" class="txtbold">&nbsp;</td>
					<td width="120">&nbsp;&nbsp;#get_app_work_info.exp_position#</td>
				</tr>	
				<tr>	    
					<td class="txtbold" width="100"><cf_get_lang no='765.Görev Sorumluluk ve Ek Açıklamalar'>:</td>
					<td colspan="5" height="35">&nbsp;&nbsp;#exp_extra#</td>
				</tr>
				</cfloop>
				<!--- <cfelse>
					&nbsp;
				</cfif>
				<cfif len(get_app.exp2) or len(get_app.exp2_position) or len(get_app.exp2_start)>
				<tr>
					<td class="txtbold" width="100">&nbsp;</td>
					<td width="180" abbr="left">&nbsp;&nbsp;<b>#dateformat(get_app.exp2_start,'mm/yyyy')# - #dateformat(get_app.exp2_finish,'mm/yyyy')#</b></td>
					<td width="30" class="txtbold">&nbsp;</td>
					<td width="150">&nbsp;&nbsp;<b>#get_app.exp2#</b></td>
					<td width="30" class="txtbold">&nbsp;</td>
					<td width="120">&nbsp;&nbsp;#get_app.exp2_position#</td>
				</tr>	
				<tr>	    
					<td class="txtbold"><br/>Görev Ve Sorumluluk:</td>
					<td colspan="5" height="35">&nbsp;&nbsp;#get_app.exp2_extra#<br/></td>
				</tr>
				<cfelse>
					&nbsp;
				</cfif>
				<cfif len(get_app.exp3) or len(get_app.exp3_position) or len(get_app.exp3_start)>
				<tr>
					<td class="txtbold" width="100">&nbsp;</td>
					<td width="180" align="left">&nbsp;&nbsp;<b>#dateformat(get_app.exp3_start,'mm/yyyy')# - #dateformat(get_app.exp3_finish,'mm/yyyy')#</b></td>
					<td width="30" class="txtbold">&nbsp;</td>
					<td width="150">&nbsp;&nbsp;<b>#get_app.exp3#</b></td>
					<td width="30" class="txtbold">&nbsp;</td>
					<td width="120">&nbsp;&nbsp;#get_app.exp3_position#</td>
				</tr>	
				<tr>	    
					<td class="txtbold"><br/>Görev Ve Sorumluluk:</td>
					<td colspan="5" height="35">&nbsp;&nbsp;#get_app.exp3_extra#<br/></td>
				</tr>
				<cfelse>
					&nbsp;
				</cfif>
				<cfif len(get_app.exp4) or len(get_app.exp4_position) or len(get_app.exp4_start)>
				<tr>
					<td class="txtbold" width="100">&nbsp;</td>
					<td width="180" align="left">&nbsp;&nbsp;<b>#dateformat(get_app.exp4_start,'mm/yyyy')# - #dateformat(get_app.exp4_finish,'mm/yyyy')#</b></td>
					<td width="30" class="txtbold">&nbsp;</td>
					<td width="150">&nbsp;&nbsp;<b>#get_app.exp4#</b></td>
					<td width="30" class="txtbold">&nbsp;</td>
					<td width="120">&nbsp;&nbsp;#get_app.exp4_position#</td>
				</tr>	
				<tr>	    
					<td class="txtbold"><br/>Görev Ve Sorumluluk:</td>
					<td colspan="5" height="35">&nbsp;&nbsp;#get_app.exp4_extra#<br/></td>
				</tr>
				<cfelse>
					&nbsp;
				</cfif> --->
			</table>
		</td>
	</tr>
	<tr>
	<td width="10" class="txtbold">&nbsp;R &nbsp;E &nbsp;F &nbsp;E &nbsp;R &nbsp;A &nbsp;N &nbsp;S</td>
	<td>
		<table border="0">
		<tr>
			<td valign="top" colspan="5" class="txtbold"><cf_get_lang no='853.Hakkınızda Bilgi Edinebileceğimiz Kişiler'><br/></td>
		<tr>
		<cfif len(get_app.ref1)>
		<tr>
			<td class="txtbold" width="120"><cf_get_lang_main no='158.Ad Soyad'> </td>
			<td class="txtbold" width="160"><cf_get_lang_main no='162.Şirket'> </td>
			<td class="txtbold" width="150"><cf_get_lang_main no='1085.Pozisyon'> </td>
			<td class="txtbold" width="110"><cf_get_lang_main no='87.Tel'> </td>
			<td class="txtbold" width="140"><cf_get_lang_main no='16.E posta'> </td>
		</tr>
		<tr>
			<td>#get_app.ref1#</td>
			<td>#get_app.ref1_company#&nbsp;&nbsp;</td>
			<td>#get_app.ref1_position#</td>
			<td>#get_app.ref1_telcode# - #get_app.ref1_tel#</td>
			<td>#get_app.ref1_email#</td>
		</tr>
		<tr>
			<td height="10"></td>
		</tr>
		<cfelse>
			&nbsp;
		</cfif>
		<cfif len(get_app.ref2)>
		<tr>
			<td>#get_app.ref2#</td>
			<td>#get_app.ref2_company#&nbsp;&nbsp;</td>
			<td>#get_app.ref2_position#</td>
			<td>#get_app.ref2_telcode# - #get_app.ref2_tel#</td>
			<td>#get_app.ref2_email#</td>
		</tr>
		<tr>
			<td height="10"></td>
		</tr>
		<cfelse>
		&nbsp;
		</cfif>
		<cfif len(get_app.ref1_emp)>
		<tr>
			<td valign="top" class="txtbold" colspan="5"><cf_get_lang no='855.Şirketimizde Çalışan Akraba, Tanıdık ve/veya Arkadaşınız'><br/></td>
		</tr>
		<tr>
			<td class="txtbold" width="120"><cf_get_lang_main no='158.Ad Soyad'> </td>
			<td class="txtbold" width="160"><cf_get_lang_main no='162.Şirket'> </td>
			<td class="txtbold" width="150"><cf_get_lang_main no='1085.Pozisyon'> </td>
			<td class="txtbold" width="110"><cf_get_lang_main no='87.Tel'> </td>
			<td class="txtbold" width="140"><cf_get_lang_main no='16.E posta'> </td>
		</tr>
		<tr>
			<td>#get_app.ref1_emp#</td>
			<td>#get_app.ref1_company_emp#</td>
			<td>#get_app.ref1_position_emp#<br/></td>
			<td>#get_app.ref1_telcode_emp# - #get_app.ref1_tel_emp#</td>
			<td>#get_app.ref1_email_emp#<br/></td>
		</tr>
		<tr>
			<td height="10">
		</tr>
		</cfif>
		<cfif len(get_app.ref2_emp)>
		<tr>
			<td>#get_app.ref2_emp#</td>
			<td>#get_app.ref2_company_emp#</td>
			<td>#get_app.ref2_position_emp#<br/></td>
			<td>#get_app.ref2_telcode_emp# - #get_app.ref2_tel_emp#</td>
			<td>#get_app.ref2_email_emp#<br/></td>
		</tr>
		<tr>
			<td height="10">
		</tr>
		</cfif>
		</table>
		</cfoutput>
		</td>
	 </tr>
	 <tr>
		<td width="10" class="txtbold">&nbsp;D &nbsp;İ &nbsp;Ğ &nbsp;E &nbsp;R</td>
		 <cfif get_cv_unit.recordcount>
			<td>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr><td class="txtbold" valign="top" width="200" height="20"><cf_get_lang no ='1153.Çalışmak İstenilen Birim'><br/></td></tr>
					<cfset liste = valuelist(get_app_unit.unit_id)>
					<cfset liste_row = valuelist(get_app_unit.unit_row)>					
					<cfoutput query="get_cv_unit">
						<cfif get_cv_unit.currentrow-1 mod 3 eq 0><tr></cfif>
						  <td width="120" class="txtbold">#get_cv_unit.unit_name# :</td>
						  <td width="50" align="left">
							<cfif listfind(liste,get_cv_unit.unit_id,',')>
								#ListGetAt(liste_row,listfind(liste,get_cv_unit.unit_id,','),',')#
							<cfelse>
								--
							 </cfif>
						  </td>
						<cfif get_cv_unit.currentrow mod 3 eq 0 and get_cv_unit.currentrow-1 neq 0></tr></cfif>	  
					</cfoutput>
					<tr><td class="txtbold" width="200" height="25" colspan="4"><cf_get_lang no ='874.Çalışmak İstediğiniz Şehir'>:</td>
					<td class="txtbold"><cf_get_lang no ='875.Seyahat Edebilir misiniz'>? : </td>
					<td>&nbsp;
						<cfif get_app.IS_TRIP is 1 OR get_app.IS_TRIP IS ""><cf_get_lang_main no ='83.Evet'> 
						<cfelseif get_app.IS_TRIP is 0><cf_get_lang_main no ='84.Hayır'></cfif> 
						</td>
					</tr>
					<tr>
						<td colspan="4">
							<table>
								<tr>
								<td>1-</td>
								<td>
									<cfif listfind(get_app.prefered_city,'',',') or not len(get_app.prefered_city)>TÜM TÜRKİYE
									<cfelse>
										<cfoutput query="get_city_name">
											<cfif listlen(get_app.prefered_city,',') gt 0 and listgetat(get_app.prefered_city,1,',') eq get_city_name.city_id>#city_name#</cfif>
										</cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td>2-</td>
								<td>
									<cfif listfind(get_app.prefered_city,'',',') or not len(get_app.prefered_city)>TÜM TÜRKİYE
									<cfelse>
										<cfoutput query="get_city_name">
											<cfif listlen(get_app.prefered_city,',') gt 1 and listgetat(get_app.prefered_city,2,',') eq get_city_name.city_id>#city_name#</cfif>
										</cfoutput>
									</cfif>
								</td>
								<td></td>
								</tr>
								<tr>
								<td>3-</td>
								<td>
									<cfif listfind(get_app.prefered_city,'',',') or not len(get_app.prefered_city)>TÜM TÜRKİYE
									<cfelse>
										<cfoutput query="get_city_name">
											<cfif listlen(get_app.prefered_city,',') gt 2 and listgetat(get_app.prefered_city,3,',') eq get_city_name.city_id>#city_name#</cfif>
										</cfoutput>
									</cfif>
								</td>
								<td></td>
							</tr>
							</table>
						</td>
					</tr>
			</table>
		</td>
		<cfelse>
		<td>&nbsp;</td>
		</cfif>
	 </tr>
	</table>
	</td>
	</tr>
</table>
</cfif>
</div>
<br/>
<cfif isdefined("attributes.print")>
	<script type="text/javascript">
	function waitfor(){
	  window.close();
	}
	setTimeout("waitfor()",3000);
	window.print();
	</script>
</cfif>
