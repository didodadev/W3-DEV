<cfsetting showdebugoutput="no">
<cfquery name="GET_HELP1" datasource="#DSN#">
	SELECT
		CH.CUS_HELP_ID,
		CH.PARTNER_ID,
		CH.CONSUMER_ID,
		CH.SUBJECT,
		CH.SOLUTION_DETAIL,
		CH.APPLICANT_NAME,
		CH.APPLICANT_MAIL,
		CH.RECORD_DATE,
		CH.IS_REPLY,
		CH.IS_REPLY_MAIL
	FROM
		CUSTOMER_HELP CH
	WHERE
		CH.CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>

<cfquery name="GET_PRO_WORKS" datasource="#DSN#">
	SELECT WORK_ID,WORK_HEAD,PROJECT_ID FROM PRO_WORKS WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND CUS_HELP_ID IS NOT NULL
</cfquery>

<cfquery name="GET_SERVICE" datasource="#DSN3#">
	SELECT SERVICE_NO FROM SERVICE WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND CUS_HELP_ID IS NOT NULL
</cfquery>

<cfquery name="GET_REL_ASSET" datasource="#DSN#">
    SELECT
        ASSET.MODULE_NAME,
        ASSET.ACTION_SECTION,
        ASSET.ACTION_ID,
        ASSET.ASSET_ID,
        ASSET.ASSET_NAME,
        ASSET.ASSET_FILE_NAME,
        ASSET.ASSET_FILE_PATH_NAME,
        ASSET.ASSET_FILE_SERVER_ID,
        ASSET.ASSET_FILE_SIZE,
        ASSET.UPDATE_DATE,
        ASSET.UPDATE_EMP,
        ASSET.UPDATE_PAR,
        ASSET_CAT.ASSETCAT,
        ASSET_CAT.ASSETCAT_PATH,
        ASSET_DESCRIPTION AS DETAIL,
        ASSET_DETAIL AS DESCRIPTION,
        ASSET.ASSETCAT_ID,
        ASSET.PROPERTY_ID,
        ASSET.RECORD_DATE,
        ASSET_SITE_DOMAIN.SITE_DOMAIN
    FROM 
        ASSET,
        ASSET_CAT,
        ASSET_SITE_DOMAIN
    WHERE
    	ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND 
        ASSET.ACTION_SECTION = 'CUS_HELP_ID' AND
        ASSET.IS_INTERNET = 1 AND
        ASSET_SITE_DOMAIN.ASSET_ID = ASSET.ASSET_ID AND
        ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
        ASSET_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">
        <cfif isdefined("session.ww.userid")>
            AND ASSET_CAT.IS_INTERNET = 1
        <cfelseif isdefined("session.pp.userid")>
            AND ASSET_CAT.IS_EXTRANET = 1
        <cfelse>
            AND ASSET_CAT.IS_INTERNET = 1
        </cfif>
</cfquery>

<cfoutput>
	<table align="center" style="width:98%">
 		<cfif len(get_help1.partner_id)>
  			<tr>	
				<td style="width:110px;"><strong><cf_get_lang_main no='1195.Firma'></strong></td>
				<td>:&nbsp;#get_par_info(get_help1.partner_id,0,1,0)#</td>
  			</tr>
  		</cfif>
  		<tr>				
			<td style="width:110px;"><strong><cf_get_lang_main no='1717.Başvuruyu Yapan'></strong></td>
			<td>:&nbsp;#get_help1.applicant_name#</td>
  		</tr>
  		<tr>				
			<td><strong><cf_get_lang no='426.Başvuru'> <cf_get_lang_main no='16.E-Posta'></strong></td>
			<td>:&nbsp;#get_help1.applicant_mail#</td>
  		</tr>
  		<tr>				
			<td><strong><cf_get_lang no='468.Başvuru Tarihi'></strong></td>
			<td>:&nbsp;#dateformat(GET_HELP1.record_date,'dd/mm/yyyy')#</td>
  		</tr>
  		<tr>
			<td style="vertical-align:top"><strong><cf_get_lang_main no='68.Konu'></strong></td>
			<td>:&nbsp;#get_help1.subject#</td>
  		</tr>	
  		<tr>
			<td style="vertical-align:top"><strong><cf_get_lang_main no='1242.Cevap'></strong></td> 
			<td>:&nbsp;
				<cfif len(get_help1.solution_detail)>
					#get_help1.solution_detail#
				<cfelse>
					<font color="FFF0000"><cf_get_lang no='108.Cevaplandırılmadı'></font>
				</cfif>
			</td>
  		</tr>

  		<cfif get_pro_works.recordcount>
  			<tr>
  				<td><strong><cf_get_lang no='726.İlişkili İş'> <cf_get_lang_main no='75.No'></strong></td>
				<td>:&nbsp;
					<cfloop query="get_pro_works">
						<cfif isdefined('session.pp.userid')>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&id=#project_id#&work_id=#encrypt(work_id,"WORKCUBE","BLOWFISH","Hex")#','project');">#work_id#</a>,
						<cfelse>
							#work_id#
						</cfif>
					</cfloop>
				</td>
  			</tr>
  		</cfif>

  		<cfif get_service.recordcount>
   			<tr>
				<td><strong><cf_get_lang no='107.İlişkili Servis Başvuruları'></strong></td>
				<td>:&nbsp;
					<cfloop query="get_service">
						#service_no#
					</cfloop>
  				</td>
  			</tr>
  		</cfif>
        <cfif get_rel_asset.recordcount>
     		<tr>
				<td><strong><cf_get_lang_main no='1966.İlişkili Belgeler ve Notlar'></strong></td>
				<td>:&nbsp;
                	<cfloop query="get_rel_asset">
						<a href="javascript:" onclick="windowopen('/documents/asset/#get_rel_asset.assetcat_path#/#get_rel_asset.asset_file_name#','small')"><img src="/images/download.gif" alt="<cf_get_lang_main no='49.Kaydet'>" title="<cf_get_lang_main no='49.Kaydet'>"></a>
					</cfloop>
  				</td>
  			</tr>      
        </cfif>
	</table>
</cfoutput>
<cfabort>
