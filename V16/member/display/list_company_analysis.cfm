<cfparam name="attributes.keyword" default="">
<cfquery name="GET_ANALYSIS_MEMBER" datasource="#dsn#">
	SELECT 
		ANALYSIS_ID,
		ANALYSIS_HEAD,
		ANALYSIS_OBJECTIVE,
		IS_ACTIVE,
		IS_PUBLISHED,
		RECORD_EMP,
		RECORD_DATE
	FROM 
		MEMBER_ANALYSIS
	WHERE
		1=1
		<cfif isDefined("attributes.KEYWORD")>
		AND
			(
			ANALYSIS_HEAD LIKE '%#attributes.KEYWORD#%'
		OR
			ANALYSIS_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
			)
		</cfif>	
		<cfif isdefined("attributes.COMPANYCAT_ID")>
		AND
			ANALYSIS_PARTNERS LIKE '%,#attributes.COMPANYCAT_ID#,%'
		</cfif>
</cfquery>
<cfset url_str = "">	
<cfset url_str = "#url_str#&COMPANYCAT_ID=#attributes.COMPANYCAT_ID#">
<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_ANALYSIS_MEMBER.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
	<tr> 
		<td class="headbold" width="300"><cf_get_lang dictionary_id ='58799.Analizler'> : <cfoutput>#get_par_info(attributes.company_id,1,1,1)#</cfoutput></td>
		<!-- sil -->
		<td  valign="bottom" class="headbold" style="text-align:right;"> 
			<table>
				<cfform name="search" method="post" action="">
					<input type="hidden" value="<cfoutput>#attributes.COMPANYCAT_ID#</cfoutput>" name="COMPANYCAT_ID" id="COMPANYCAT_ID">
					<tr>
						<td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
						<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
						<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
						<td><cf_wrk_search_button></td>
					</tr>
				</cfform>
			</table>
		</td>
		<!-- sil -->
	</tr>
</table>
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
	<tr class="color-header" height="22">
		<td class="form-title"><cf_get_lang dictionary_id='29764.Form'></td>
		<td class="form-title" width="150"><cf_get_lang dictionary_id='30277.Amaç'></td>
		<td class="form-title"><cf_get_lang dictionary_id='29775.Hazırlayan'></td>
		<td class="form-title" width="65"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></td>
		<td class="form-title" width="50"><cf_get_lang dictionary_id='57756.Durum'></td>
		<td class="form-title" width="90"><cf_get_lang dictionary_id='29479.Yayın Durumu'></td>
	</tr>
	<cfif GET_ANALYSIS_MEMBER.recordcount>
		<cfoutput query="GET_ANALYSIS_MEMBER" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td><a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=member.analysis_results&analysis_id=#analysis_id#';" class="tableyazi">#analysis_HEAD#</a></td>
				<td>#analysis_objective#</td>
				<td> 
					<cfif len(RECORD_EMP)>
						#get_emp_info(record_emp,0,1)#	
					</cfif>
				</td>
				<td>#dateformat(record_date,dateformat_style)#</td>
				<td><cfif IS_ACTIVE IS 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
				<td><cfif IS_PUBLISHED IS 1><cf_get_lang dictionary_id='30412.Yayınlanıyor'><cfelse><cf_get_lang dictionary_id='30413.Yayınlanmıyor'></cfif></td>
			</tr>
		</cfoutput>
	<cfelse>			
		<tr class="color-row" height="20"> 
			<td colspan="6" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
		<tr> 
			<td>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
				<cf_pages 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="member.popup_list_company_analysis#url_str#"> 
			</td>
			<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
