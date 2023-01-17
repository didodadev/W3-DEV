<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.gender" default="">
<cfparam name="attributes.military_status" default="">
<cfparam name="attributes.training_level" default="">
<cfparam name="attributes.is_cont_work" default="">
<cfquery name="get_fast_cv" datasource="#dsn#">
	SELECT
        EMPLOYEES_APP.EMPAPP_ID, 
        EMPLOYEES_APP.EMPLOYEE_ID, 
        EMPLOYEES_APP.NAME, 
        EMPLOYEES_APP.SURNAME, 
        EMPLOYEES_APP.SEX, 
        EMPLOYEES_APP.HOMECOUNTY, 
        EMPLOYEES_APP.HOMETELCODE, 
        EMPLOYEES_APP.HOMETEL, 
        EMPLOYEES_APP.MOBILCODE, 
	    EMPLOYEES_APP.MOBIL, 
        EMPLOYEES_APP.MILITARY_STATUS,
        EMPLOYEES_APP.APPLICANT_NOTES, 
        EMPLOYEES_APP.TRAINING_LEVEL, 
        EMPLOYEES_APP.HEAD_CV, 
		EMPLOYEES_IDENTY.BIRTH_DATE,
		EMPLOYEES_IDENTY.MARRIED
	FROM
		EMPLOYEES_APP,
		EMPLOYEES_IDENTY
	WHERE
		EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP.EMPAPP_ID
		AND EMPLOYEES_APP.EMPLOYEE_ID IS NULL
		<cfif len(attributes.keyword)>
		AND ((EMPLOYEES_APP.HEAD_CV LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%')<!---  OR ((EMPLOYEES_APP.HEAD_CV LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%')) --->
		</cfif>
		<cfif isdefined("attributes.gender") and len(attributes.gender)>
		AND EMPLOYEES_APP.SEX = #attributes.gender#
		</cfif>
		<cfif isdefined("attributes.military_status") and len(attributes.military_status)>
		AND EMPLOYEES_APP.MILITARY_STATUS = #attributes.military_status#
		</cfif>
		<cfif isdefined("attributes.training_level") and len(attributes.training_level)>
		AND  EMPLOYEES_APP.TRAINING_LEVEL = #attributes.training_level#
		</cfif>
		<cfif isdefined("attributes.is_cont_work") and len(attributes.is_cont_work) and attributes.is_cont_work eq 1>
		AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO WHERE IS_CONT_WORK = 1 AND EMPLOYEE_ID IS NULL)
		<cfelseif  isdefined("attributes.is_cont_work") and len(attributes.is_cont_work) and attributes.is_cont_work eq 0>
		AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO WHERE (IS_CONT_WORK = 0 OR IS_CONT_WORK IS NULL) AND EMPLOYEE_ID IS NULL)
		</cfif>
</cfquery>
<cfquery name="get_edu_level" datasource="#DSN#">
	SELECT 
    	EDU_LEVEL_ID, 
        EDUCATION_NAME 
    FROM 
	    SETUP_EDUCATION_LEVEL
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.cp.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_fast_cv.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
 <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
 	<tr>
		<td colspan="2" height="35" class="headbold"><strong><cf_get_lang dictionary_id='60808.Yönetici Cv Listesi'></strong></td>
	</tr>
	<tr>
	  <!-- sil -->
	  <td align="right" valign="bottom" style="text-align:right;">
	  <cfform name="form" action="#request.self#?fuseaction=objects2.list_manager_fast_cv" method="post">
		<table border="1" width="100%">
			<tr>
			  <td width="25"><cf_get_lang dictionary_id='57460.Filtre'></td>
			  <td width="100"><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
			  <td width="55">
				<select name="gender">
				<option value="" <cfif attributes.gender eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
				<option value="1" <cfif attributes.gender eq 1>selected</cfif>><cf_get_lang dictionary_id='58959.Erkek'>
				<option value="0" <cfif attributes.gender eq 0>selected</cfif>><cf_get_lang dictionary_id='58958.Kadın'>			                        
				</select>
			  </td>
			  <td width="100">
				<select name="military_status">
				<option value="" <cfif attributes.military_status eq 3>selected</cfif>><cf_get_lang dictionary_id='56545.Askerlik Durumu'>
				<option value="2" <cfif attributes.military_status eq 2>selected</cfif>><cf_get_lang dictionary_id='55626.Muaf'>
				<option value="4" <cfif attributes.military_status eq 4>selected</cfif>><cf_get_lang dictionary_id='55340.Tecilli'>
				<option value="1" <cfif attributes.military_status eq 1>selected</cfif>><cf_get_lang dictionary_id='38307.Tamamlamış'>	                        
				</select>
			  </td>
			  <td width="190">
				<select name="training_level" style="width:190px;">
					<option value=""><cf_get_lang dictionary_id='55337.Eğitim Seviyesi'></option>
					<cfloop query="get_edu_level">
						<option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>" <cfif attributes.training_level eq get_edu_level.edu_level_id>selected</cfif>><cfoutput>#get_edu_level.education_name#</cfoutput></option>
					</cfloop>
				</select>
			  </td>
			  <td width="50">
				<select name="is_cont_work">
				<option value="" <cfif attributes.gender eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
				<option value="1" <cfif attributes.gender eq 1>selected</cfif>><cf_get_lang dictionary_id='55755.Çalışıyor'>
				<option value="0" <cfif attributes.gender eq 0>selected</cfif>><cf_get_lang dictionary_id='56365.Çalışmıyor'>			                        
				</select>
			  </td>
		      <td>&nbsp;</td>
			  <td width="25" align="right" style="text-align:right;"><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				  <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			  </td>
			  <td width="15"><cf_wrk_search_button is_excel="0"></td>
			</tr>
		</table>
		</cfform>
	  </td>
	  <!-- sil -->
	</tr>
  </table>
<table cellspacing="1" cellpadding="2" width="100%" border="0">
	<tr class="color-header">
		<td height="22" class="form-title" width="85"><cf_get_lang dictionary_id='57708.Tümü'></td>
		<td class="form-title" width="20"><cf_get_lang dictionary_id='55757.Adı Soyadı'></td>
		<td class="form-title" width="30"><cf_get_lang dictionary_id='57764.Cinsiyet'></td>
		<td class="form-title" width="65"><cf_get_lang dictionary_id='56525.Medeni Hal'></td>
		<td class="form-title"><cf_get_lang dictionary_id='58565.Branş'></td>
		<td class="form-title"><cf_get_lang dictionary_id='56521.Staj Bilgileri'></td>
		<td class="form-title" width="60"><cf_get_lang dictionary_id='57419.Eğitim'></td>
		<td class="form-title"><cf_get_lang dictionary_id='60809.Son Çalş. Yer / Görevi'></td>
		<td class="form-title"><cf_get_lang dictionary_id='58638.İlçe'></td>
		<td class="form-title" width="50"><cf_get_lang dictionary_id='55593.Ev Tel'></td>
		<td class="form-title"><cf_get_lang dictionary_id='55477.GSM'></td>
	</tr>
 <cfif get_fast_cv.recordcount>
	<cfoutput query="get_fast_cv" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">	
	  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
	  	<td>#NAME# &nbsp; #SURNAME#</td>
		<td>
		 <cfif len(get_fast_cv.BIRTH_DATE)>
			<cfset YAS = DATEDIFF("yyyy",get_fast_cv.BIRTH_DATE,NOW())>
		   <cfif YAS NEQ 0>
			 #YAS#
		   </cfif>	
		  </cfif>
		</td>
		<td>
			<cfif sex eq 1><cf_get_lang dictionary_id='58959.Erkek'><cfelse><cf_get_lang dictionary_id='55621.Bayan'></cfif>
		</td>
		<td>
			<cfif married eq 1><cf_get_lang dictionary_id='55743.Evli'><cfelse><cf_get_lang dictionary_id='55744.Bekar'></cfif>
		</td>
		<td colspan="2"></td>
		<td>
			<cfif len(training_level)>
				<cfquery name="get_edu_level" datasource="#DSN#">
					SELECT 
    	                * 
                    FROM 
	                    SETUP_EDUCATION_LEVEL 
                    WHERE 
                    	EDU_LEVEL_ID = #TRAINING_LEVEL# 
				</cfquery>
				#get_edu_level.EDUCATION_NAME#
			</cfif>
		</td>
		<td>
			<cfquery name="get_app_work_info" datasource="#dsn#" maxrows="1">
				SELECT EXP,EXP_POSITION FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EXP_START DESC
			</cfquery>
			 #get_app_work_info.exp#<br/>#get_app_work_info.exp_position#
		</td>
		<td>
			#HOMECOUNTY#
		</td>
		<td>#HOMETELCODE# #HOMETEL#</td>
		<td>#MOBILCODE# #MOBIL#</td>
	  </tr>
	</cfoutput>
	<cfelse>
	<tr class="color-row" height="20">
		<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
	</tr>
  </cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.gender") and len(attributes.gender)>
		<cfset url_str = "#url_str#&gender=#attributes.gender#">
	</cfif>
	<cfif isdefined("attributes.military_status") and len(attributes.military_status)>
		<cfset url_str = "#url_str#&military_status=#attributes.military_status#">
	</cfif>
	<cfif isdefined("attributes.training_level") and len(attributes.training_level)>
		<cfset url_str = "#url_str#&training_level=#attributes.training_level#">
	</cfif>
	<cfif isdefined("attributes.is_cont_work") and len(attributes.is_cont_work)>
		<cfset url_str = "#url_str#&is_cont_work=#attributes.is_cont_work#">
	</cfif>
<table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
	<tr>
		<td> <cf_pages 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="objects2.list_manager_fast_cv#url_str#"> </td>
		<!-- sil -->
		<td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		<!-- sil -->
	</tr>
</table>
</cfif>
