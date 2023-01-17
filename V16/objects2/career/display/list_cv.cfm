<cfparam name="attributes.startdate" default="1/#month(now())#/#session.pp.period_year#">
<cfparam name="attributes.finishdate" default="#day(now())#/#month(now())#/#session.pp.period_year#">

<cfif len(attributes.startdate) gt 5>
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif len(attributes.finishdate) gt 5>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate="">
</cfif>

<cfif not isdefined("attributes.keyword")>
	<cfset filtered = 0>
<cfelse>
	<cfset filtered = 1>
</cfif>

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword2" default="">
<cfif filtered>
	<cfquery name="GET_CV" datasource="#DSN#">
		SELECT
			AP.EMPAPP_ID,
			AP.NAME,
			AP.SURNAME,
			AP.EMAIL,
			AP.MOBILCODE,
			AP.MOBIL,
			AP.MOBILCODE2,
			AP.MOBIL2,
			AP.PHOTO,
			AP.PHOTO_SERVER_ID,
			AP.HOMETELCODE,
			AP.HOMETEL,
			AP.SEX,
			AP.RECORD_DATE
		FROM
			EMPLOYEES_APP AP
		WHERE
			EMPAPP_ID IS NOT NULL AND
			APP_STATUS = 1
			<cfif len(attributes.keyword)>
				AND (AP.NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">)
			</cfif>
			<cfif len(attributes.keyword2)>
				AND (AP.SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword2#%">)
			</cfif>
			<cfif isDefined('attributes.STARTDATE') and len(attributes.STARTDATE) gt 5>
				AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#">
		    </cfif>
		    <cfif isDefined('attributes.FINISHDATE') and len(attributes.FINISHDATE) gt 5>
				AND RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.finishdate)#">
		    </cfif>
			ORDER BY 
				NAME
	</cfquery>
<cfelse>
	<cfset get_cv.recordcount=0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_cv.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" cellpadding="0" cellspacing="0" border="0" height="100%">
	<tr>
		<td valign="top">
			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td class="headbold" height="35">CV </td>
					<td  valign="bottom" style="text-align:right;">
						<!--- Arama --->
						<table>
							<cfset url_str = "">
							<cfif isdefined("attributes.keyword")>
								<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
							</cfif>
							<cfif isdefined("attributes.keyword2")>
								<cfset url_str = "#url_str#&keyword2=#attributes.keyword2#">
							</cfif>
							<cfif len(attributes.startdate) gt 5>
								<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#">
							</cfif>
							<cfif len(attributes.finishdate) gt 5>
								<cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
							</cfif>
							<cfform name="form" action="#request.self#?fuseaction=objects2.list_cv" method="post">
								<tr>
									<td><cf_get_lang_main no='219.Ad'></td>
									<td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>	
									<td><cf_get_lang_main no='1314.Soyad'></td>
									<td><cfinput type="text" name="keyword2" id="keyword2" style="width:100px;" value="#attributes.keyword2#" maxlength="255"></td>	
									<td>
										<cfsavecontent variable="alert"><cf_get_lang_main no ='370.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
										<cfif len(attributes.startdate) gt 5>
											<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" validate="eurodate" message="#alert#">
										<cfelse>
											<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" value="" validate="eurodate" message="#alert#">
										</cfif>
										<cf_wrk_date_image date_field="startdate">
									</td>
									<td>
										<cfsavecontent variable="alert"><cf_get_lang_main no ='370.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
										<cfif len(attributes.finishdate) gt 5>
											<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" validate="eurodate" message="#alert#">
										<cfelse>
											<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" value="" validate="eurodate" message="#alert#">
										</cfif>
										<cf_wrk_date_image date_field="finishdate">
									</td>		
									<td>
										<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
										<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
									</td>
									<td><cf_wrk_search_button></td>
								 </tr>
							</cfform>
						</table>
						<!--- Arama --->
					</td>
				</tr>
			</table>
			<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
				<tr class="color-border">
					<td>
						<table cellspacing="1" cellpadding="2" width="100%" border="0">
							<tr class="color-header">
								<td height="22" class="form-title" width="50"><cf_get_lang_main no='75.No'></td>
								<td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
								<td class="form-title"><cf_get_lang_main no='297.Okul'> / <cf_get_lang_main no='583.Bölüm'></td>
								<td class="form-title"><cf_get_lang no='922.Son İş Tecrübesi'></td>
								<td class="form-title"><cf_get_lang no='923.Yaş'></td>
								<td class="form-title" width="60"><cf_get_lang_main no='71.Kayıt'></td>
								<!-- sil -->
								<td width="85" class="form-title"><cf_get_lang_main no='731.İletişim'></td>
								<td width="15"><img src="/images/print2_white.gif" border="0" alt="<cf_get_lang_main no='62.Yazdır'>" title="<cf_get_lang_main no='62.Yazdır'>" /></td>
								<!-- sil -->
							</tr>
							<cfif get_cv.recordcount>
								<cfoutput query="get_cv" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
									<tr height="22" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
										<td><a href="#request.self#?fuseaction=objects2.dsp_cv_partner&empapp_id=#empapp_id#" class="tableyazi">#currentrow#</a></td>
										<td><a href="#request.self#?fuseaction=objects2.dsp_cv_partner&empapp_id=#empapp_id#" class="tableyazi">#name# #surname#</a></td>
										<td>
											<cfquery name="GET_APP_EDU_INFO" datasource="#DSN#" maxrows="1">
												SELECT EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> ORDER BY EDU_START DESC
											</cfquery>
											<cfif get_app_edu_info.recordcount> #get_app_edu_info.edu_name# / #get_app_edu_info.edu_part_name#</cfif>
										</td>
										<td>
											<cfquery name="GET_APP_WORK_INFO" datasource="#DSN#" maxrows="1">
												SELECT EXP,EXP_POSITION FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> ORDER BY EXP_START DESC
											</cfquery>
											 #get_app_work_info.exp#<br/>#get_app_work_info.exp_position#
										</td>
										<td>
										<cfquery name="GET_BIRTH_DATE" datasource="#DSN#">
											SELECT BIRTH_DATE FROM EMPLOYEES_IDENTY WHERE EMPAPP_ID IS NOT NULL AND EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> 
										</cfquery>
										<cfif get_birth_date.recordcount and len(get_birth_date.birth_date)>
											<cfset yas = datediff("yyyy",get_birth_date.birth_date,now())>
											<cfif yas neq 0>
												#yas#
											</cfif>	
										</cfif>
										</td>
										<td>#dateformat(record_date,'dd/mm/yyyy')#</td>
										<!-- sil -->
										<td>
											<cfif len(get_cv.email)><a href="mailto:#get_cv.email#" title="#get_cv.email#"><img src="/images/mail.gif" border="0" alt="#get_cv.email#" /></a>&nbsp;</cfif>
											<cfif ((len(get_cv.mobilcode) and len(get_cv.mobil)) or (len(get_cv.mobilcode2) and len(get_cv.mobil2)))><img alt="( #get_cv.mobilcode# ) #get_cv.mobil#" title="( #get_cv.mobilcode# ) #get_cv.mobil#" src="/images/mobil.gif" border="0" /></cfif>
											<cfif len(get_cv.hometelcode) and len(get_cv.hometel)><img title="( #hometelcode# ) #hometel#" alt="( #hometelcode# ) #hometel#" src="/images/tel.gif" border="0" /></cfif>
											<cfif len(get_cv.photo)>
											<cf_get_server_file output_file="hr/#get_cv.photo#" output_server="#get_cv.photo_server_id#" output_type="2" small_image="/images/photo.gif" image_link="1" alt="#getLang('main',164)#" title="#getLang('main',164)#">
											</cfif>
										</td>
										<td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_dsp_cv_print&empapp_id=#empapp_id#','page');return false;" title="<cf_get_lang_main no='62.Yazdır'>"><img src="/images/print2.gif" alt="<cf_get_lang_main no='62.Yazdır'>" border="0" /></a></td>
										<!-- sil -->
									</tr>
								</cfoutput>
							<cfelse>
								<tr class="color-row" height="20">
									<td colspan="10"><cfif filtered><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
								</tr>
							</cfif>
						</table>
					</td>
				</tr>
			</table>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
					<tr>
						<td> <cf_pages 
						page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="objects2.list_cv#url_str#"> </td>
						<!-- sil -->
						<td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
						<!-- sil -->
					</tr>
				</table>
			</cfif>
		</td>
	</tr>
</table>
<br/>
