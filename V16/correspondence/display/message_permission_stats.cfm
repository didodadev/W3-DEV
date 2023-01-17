<cfif isdefined("attributes.type") and listFindNoCase('1,2,3',attributes.type)>
<cfquery name="GET_USERS" datasource="#DSN#">
	SELECT 
		COUNT(*) AS COUNT
	FROM 
		<cfif attributes.type eq 1>
			COMPANY_PARTNER
		<cfelseif attributes.type eq 2>
			CONSUMER
		<cfelse>
			EMPLOYEES_APP
		</cfif>
	WHERE
		<cfif attributes.type eq 1>
			COMPANY_PARTNER_STATUS = 1
		<cfelseif attributes.type eq 2>
			CONSUMER_STATUS = 1
		<cfelse>
			APP_STATUS = 1
		</cfif>
</cfquery>
<cfquery name="GET_INFO" datasource="#dsn#" result="ABC">
	SELECT
		COUNT(*) AS COUNT,
		ISNULL(VALID_MAIL.MAIL_COUNT,0) AS VALID_COUNT,
		1 AS TYPE
	FROM 
		<cfif attributes.type eq 1>
			COMPANY_PARTNER
			OUTER APPLY
			(
				SELECT COUNT(*) AS  MAIL_COUNT FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_STATUS = 1 AND ISNULL(WANT_EMAIL,1) = 1 AND COMPANY_PARTNER_EMAIL LIKE '%_@__%.__%' AND LEN(COMPANY_PARTNER_EMAIL) BETWEEN 6 AND 256
			) AS VALID_MAIL
		<cfelseif attributes.type eq 2>
			CONSUMER
			OUTER APPLY
			(
				SELECT COUNT(*) AS  MAIL_COUNT FROM CONSUMER WHERE CONSUMER_STATUS = 1 AND ISNULL(WANT_EMAIL,1) = 1 AND CONSUMER_EMAIL LIKE '%_@__%.__%' AND LEN(CONSUMER_EMAIL) BETWEEN 6 AND 256
			) AS VALID_MAIL
		<cfelse>
			EMPLOYEES_APP
			OUTER APPLY
			(
				SELECT COUNT(*) AS  MAIL_COUNT FROM EMPLOYEES_APP WHERE APP_STATUS = 1 AND ISNULL(WANT_EMAIL,1) = 1 AND EMAIL LIKE '%_@__%.__%' AND LEN(EMAIL) BETWEEN 6 AND 256
			) AS VALID_MAIL
		</cfif>
	WHERE 
		<cfif attributes.type eq 1>
			COMPANY_PARTNER_STATUS = 1
		<cfelseif attributes.type eq 2>
			CONSUMER_STATUS = 1
		<cfelse>
			APP_STATUS = 1
		</cfif>
		AND ISNULL(WANT_EMAIL,1) = 1
	GROUP BY
		VALID_MAIL.MAIL_COUNT
	UNION ALL
	SELECT
		COUNT(*) AS COUNT,
		ISNULL(VALID_SMS.SMS_COUNT,0),
		2 AS TYPE
	FROM 
		<cfif attributes.type eq 1>
			COMPANY_PARTNER
			OUTER APPLY
			(
				SELECT COUNT(*) AS  SMS_COUNT FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_STATUS = 1 AND ISNULL(WANT_SMS,1) = 1 AND LEN(MOBIL_CODE) > 0 AND LEN(MOBILTEL)>0 AND LEN(MOBIL_CODE+MOBILTEL) BETWEEN 10 AND 13
			) AS VALID_SMS
		<cfelseif attributes.type eq 2>
			CONSUMER
			OUTER APPLY
			(
				SELECT COUNT(*) AS  SMS_COUNT FROM CONSUMER WHERE CONSUMER_STATUS = 1 AND ISNULL(WANT_SMS,1) = 1 AND LEN(MOBIL_CODE) > 0 AND LEN(MOBILTEL)>0 AND LEN(MOBIL_CODE+MOBILTEL) BETWEEN 10 AND 13
			) AS VALID_SMS
		<cfelse>
			EMPLOYEES_APP
			OUTER APPLY
			(
				SELECT COUNT(*) AS  SMS_COUNT FROM EMPLOYEES_APP WHERE APP_STATUS = 1 AND ISNULL(WANT_SMS,1) = 1 AND LEN(MOBILCODE) > 0 AND LEN(MOBIL)>0 AND LEN(MOBILCODE+MOBIL) BETWEEN 10 AND 13
			) AS VALID_SMS
		</cfif>
	WHERE 
		<cfif attributes.type eq 1>
			COMPANY_PARTNER_STATUS = 1
		<cfelseif attributes.type eq 2>
			CONSUMER_STATUS = 1
		<cfelse>
			APP_STATUS = 1
		</cfif>
		AND ISNULL(WANT_SMS,1) = 1
	GROUP BY
		VALID_SMS.SMS_COUNT
	UNION ALL
	SELECT
		COUNT(*) AS COUNT,
		ISNULL(VALID_CALL.CALL_COUNT,0),
		3 AS TYPE
	FROM 
		<cfif attributes.type eq 1>
			COMPANY_PARTNER
			OUTER APPLY
			(
				SELECT COUNT(*) AS  CALL_COUNT FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_STATUS = 1 AND ISNULL(WANT_CALL,1) = 1 AND LEN(MOBIL_CODE) > 0 AND LEN(MOBILTEL)>0 AND LEN(MOBIL_CODE+MOBILTEL) BETWEEN 10 AND 13
			) AS VALID_CALL
		<cfelseif attributes.type eq 2>
			CONSUMER
			OUTER APPLY
			(
				SELECT COUNT(*) AS  CALL_COUNT FROM CONSUMER WHERE CONSUMER_STATUS = 1 AND ISNULL(WANT_CALL,1) = 1 AND LEN(MOBIL_CODE) > 0 AND LEN(MOBILTEL)>0 AND LEN(MOBIL_CODE+MOBILTEL) BETWEEN 10 AND 13
			) AS VALID_CALL
		<cfelse>
			EMPLOYEES_APP
			OUTER APPLY
			(
				SELECT COUNT(*) AS  CALL_COUNT FROM EMPLOYEES_APP WHERE APP_STATUS = 1 AND ISNULL(WANT_CALL,1) = 1 AND LEN(MOBILCODE) > 0 AND LEN(MOBIL)>0 AND LEN(MOBILCODE+MOBIL) BETWEEN 10 AND 13
			) AS VALID_CALL
		</cfif>
	WHERE 
		<cfif attributes.type eq 1>
			COMPANY_PARTNER_STATUS = 1
		<cfelseif attributes.type eq 2>
			CONSUMER_STATUS = 1
		<cfelse>
			APP_STATUS = 1
		</cfif>
		AND ISNULL(WANT_CALL,1) = 1
	GROUP BY
		VALID_CALL.CALL_COUNT
</cfquery>

<cfquery name="GET_RESOURCES" datasource="#dsn#">
	WITH CTE1 AS
	(
	SELECT 
		COMPANY_PARTNER_RESOURCE.RESOURCE_ID,
		#dsn#.Get_Dynamic_Language(COMPANY_PARTNER_RESOURCE.RESOURCE_ID,'#session.ep.language#','COMPANY_PARTNER_RESOURCE','RESOURCE',NULL,NULL,COMPANY_PARTNER_RESOURCE.RESOURCE) AS RESOURCE
	FROM 
		COMPANY_PARTNER_RESOURCE
	UNION ALL
	SELECT 
		0 AS RESOURCE_ID,
		'#getlang("","Tanımsız",58845)#'
	),
	CTE2 AS 
	(
		SELECT
			COUNT(*) AS COUNT,
			ISNULL(RESOURCE_ID,0) AS RESOURCE_ID
		FROM 
			<cfif attributes.type eq 1>
				COMPANY_PARTNER
			<cfelseif attributes.type eq 2>
				CONSUMER
			<cfelse>
				EMPLOYEES_APP
			</cfif> 
		WHERE 
			<cfif attributes.type eq 1>
				COMPANY_PARTNER_STATUS = 1
			<cfelseif attributes.type eq 2>
				CONSUMER_STATUS = 1
			<cfelse>
				APP_STATUS = 1
			</cfif>
		GROUP BY
			RESOURCE_ID
	)
	SELECT 
		CTE1.RESOURCE_ID,
		#dsn#.Get_Dynamic_Language(CTE1.RESOURCE_ID,'#session.ep.language#','CTE1','RESOURCE',NULL,NULL,CTE1.RESOURCE) AS RESOURCE,
		ISNULL(CTE2.COUNT,0) AS COUNT 
	FROM
		CTE1 
		LEFT JOIN CTE2 ON CTE1.RESOURCE_ID = CTE2.RESOURCE_ID
</cfquery>
<cfoutput>
	<div class="row">
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<div class="row">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<h2>
						<b>#GET_USERS.COUNT#</b>
					</h2>
				</div>
			</div>
			<div class="row">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12 text-center">
					<h2 title="MAİL">
						<b><i class="fa fa-envelope fa-2x gainsboro"></i><br /><br />#GET_INFO.COUNT[1]#<br /><br /><font color="green"><cf_get_lang dictionary_id='959.Geçerli'></font> : #GET_INFO.VALID_COUNT[1]#<br /><br /><font color="red"><cf_get_lang dictionary_id='958.Geçersiz'></font> : <cfif len(GET_INFO.COUNT[1]) and len(GET_INFO.VALID_COUNT[1])>#GET_INFO.COUNT[1]-GET_INFO.VALID_COUNT[1]#</cfif></b>
					</h2>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12 text-center">
					<h2 title="SMS">
						<b><i class="fa fa-comment fa-2x blue"></i><br /><br />#GET_INFO.COUNT[2]#<br /><br /><font color="green"><cf_get_lang dictionary_id='959.Geçerli'></font> : #GET_INFO.VALID_COUNT[2]#<br /><br /><font color="red"><cf_get_lang dictionary_id='958.Geçersiz'></font> : <cfif len(GET_INFO.COUNT[2]) and len(GET_INFO.VALID_COUNT[2])>#GET_INFO.COUNT[2]-GET_INFO.VALID_COUNT[2]#</cfif></b>
					</h2>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12 text-center">
					<h2 title="IVR">
						<b><i class="fa fa-phone fa-2x forestgreen"></i><br /><br />#GET_INFO.COUNT[3]#<br /><br /><font color="green"><cf_get_lang dictionary_id='959.Geçerli'></font> : #GET_INFO.VALID_COUNT[3]#<br /><br /><font color="red"><cf_get_lang dictionary_id='958.Geçersiz'></font> : <cfif len(GET_INFO.COUNT[3]) and len(GET_INFO.VALID_COUNT[3])>#GET_INFO.COUNT[3]-GET_INFO.VALID_COUNT[3]#</cfif></b>
					</h2>
				</div>
			</div>
			<div class="row">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<h1><b><cf_get_lang dictionary_id='960.İlişki Tiplerine Göre İzinler'></b></h1>
				</div>
			</div>
			<cfloop query="GET_RESOURCES">
				<div class="row">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						#RESOURCE#
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right">
						<b>#COUNT#</b>
					</div>
				</div>
			</cfloop>
		</div>
	</div>
</cfoutput>
<cfelseif isdefined("attributes.type") and attributes.type eq 4>
	<cf_tab divID = "sayfa_1,sayfa_2,sayfa_3" defaultOpen="sayfa_1" divLang = "#getlang('','Kurumsal',57255)#;#getlang('','Bireysel',43938)#;#getlang('','Çalışan Adayı',969)#" tabcolor = "fff">
		<div id = "unique_sayfa_1" class = "uniqueBox">
			<form name="add_permissions1" id="add_permissions1" method="post" action="">
				<cf_box_elements id="genel_bilgiler" vertical="1">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-resource">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'></label>
							<div class="col col-8 col-sm-12">
								<cf_wrk_combo 
									name="resource"
									query_name="GET_PARTNER_RESOURCE"
									value=""
									option_name="resource"
									option_value="resource_id"
									width="150">
							</div>                
						</div>
						<div class="form-group" id="item-email_confirm">
							<label class="col col-4 col-sm-12" for="email_confirm"><cf_get_lang dictionary_id='961.Email İzni Verenler'></label>
							<div class="col col-8 col-sm-12">
								<input type="checkbox" name="email_confirm" id="email_confirm" value="1" />
							</div>                
						</div>
						<div class="form-group" id="item-sms_confirm">
							<label class="col col-4 col-sm-12" for="sms_confirm"><cf_get_lang dictionary_id='962.Sms İzni Verenler'></label>
							<div class="col col-8 col-sm-12">
								<input type="checkbox" name="sms_confirm" id="sms_confirm" value="1" />
							</div>                
						</div>
						<div class="form-group" id="item-start_date">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54892.Kayıt Başlangıç Tarihi'></label>
							<div class="col col-8 col-sm-12">
								<input maxlength="10" type="date" id="start_date" name="start_date" value="">
							</div>
						</div>
						<div class="form-group" id="item-finish_date_1">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54893.Kayıt Bitiş Tarihi'></label>
							<div class="col col-8 col-sm-12">
								<input maxlength="10" type="date" id="finish_date" name="finish_date" value="">
							</div>                
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-resource">
							<label class="col col-4 col-sm-12"> <cf_get_lang dictionary_id='963.Güncellenecek İlişki Şekli'></label>
							<div class="col col-8 col-sm-12">
								<cf_wrk_combo 
									name="new_resource"
									query_name="GET_PARTNER_RESOURCE"
									value=""
									option_name="resource"
									option_value="resource_id"
									width="150">
							</div>                
						</div>
						<div class="form-group" id="item-resource">
							<label class="col col-4 col-sm-12">&nbsp;</label>
							<div class="col col-8 col-sm-12">
								<input type="button" value="<cf_get_lang dictionary_id='964.Kurumsal Verileri Güncelle'>" class="ui-wrk-btn ui-wrk-btn-success" onclick="savePermissions(1)"/>
							</div>                
						</div>
					</div>
				</cf_box_elements>
			</form>
		</div>
		<div id = "unique_sayfa_2" class = "uniqueBox">
			<form name="add_permissions2" id="add_permissions2" method="post" action="">
				<cf_box_elements id="genel_bilgiler" vertical="1">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-resource">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'></label>
							<div class="col col-8 col-sm-12">
								<cf_wrk_combo 
									name="resource"
									query_name="GET_PARTNER_RESOURCE"
									value=""
									option_name="resource"
									option_value="resource_id"
									width="150">
							</div>                
						</div>
						<div class="form-group" id="item-email_confirm">
							<label class="col col-4 col-sm-12" for="email_confirm"><cf_get_lang dictionary_id='961.Email İzni Verenler'></label>
							<div class="col col-8 col-sm-12">
								<input type="checkbox" name="email_confirm" id="email_confirm" value="1" />
							</div>                
						</div>
						<div class="form-group" id="item-sms_confirm">
							<label class="col col-4 col-sm-12" for="sms_confirm"><cf_get_lang dictionary_id='962.Sms İzni Verenler'></label>
							<div class="col col-8 col-sm-12">
								<input type="checkbox" name="sms_confirm" id="sms_confirm" value="1" />
							</div>                
						</div>
						<div class="form-group" id="item-start_date">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54892.Kayıt Başlangıç Tarihi'></label>
							<div class="col col-8 col-sm-12">
								<input maxlength="10" type="date" id="start_date" name="start_date" value="">
							</div>
						</div>
						<div class="form-group" id="item-finish_date_1">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54893.Kayıt Bitiş Tarihi'></label>
							<div class="col col-8 col-sm-12">
								<input maxlength="10" type="date" id="finish_date" name="finish_date" value="">
							</div>                
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-resource">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='963.Güncellenecek İlişki Şekli'></label>
							<div class="col col-8 col-sm-12">
								<cf_wrk_combo 
									name="new_resource"
									query_name="GET_PARTNER_RESOURCE"
									value=""
									option_name="resource"
									option_value="resource_id"
									width="150">
							</div>                
						</div>
						<div class="form-group" id="item-resource">
							<label class="col col-4 col-sm-12">&nbsp;</label>
							<div class="col col-8 col-sm-12">
								<input type="button" value="<cf_get_lang dictionary_id='965.Bireysel Verileri Güncelle'>" class="ui-wrk-btn ui-wrk-btn-success" onclick="savePermissions(2)"/>
							</div>                
						</div>
					</div>
				</cf_box_elements>
			</form>
		</div>
		<div id = "unique_sayfa_3" class = "uniqueBox">
			<form name="add_permissions3" id="add_permissions3" method="post" action="">
				<cf_box_elements id="genel_bilgiler" vertical="1">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-resource">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'></label>
							<div class="col col-8 col-sm-12">
								<cf_wrk_combo 
									name="resource"
									query_name="GET_PARTNER_RESOURCE"
									value=""
									option_name="resource"
									option_value="resource_id"
									width="150">
							</div>                
						</div>
						<div class="form-group" id="item-email_confirm">
							<label class="col col-4 col-sm-12" for="email_confirm"><cf_get_lang dictionary_id='961.Email İzni Verenler'></label>
							<div class="col col-8 col-sm-12">
								<input type="checkbox" name="email_confirm" id="email_confirm" value="1" />
							</div>                
						</div>
						<div class="form-group" id="item-sms_confirm">
							<label class="col col-4 col-sm-12" for="sms_confirm"><cf_get_lang dictionary_id='962.Sms İzni Verenler'></label>
							<div class="col col-8 col-sm-12">
								<input type="checkbox" name="sms_confirm" id="sms_confirm" value="1" />
							</div>                
						</div>
						<div class="form-group" id="item-start_date">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54892.Kayıt Başlangıç Tarihi'></label>
							<div class="col col-8 col-sm-12">
								<input maxlength="10" type="date" id="start_date" name="start_date" value="">
							</div>
						</div>
						<div class="form-group" id="item-finish_date_1">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54893.Kayıt Bitiş Tarihi'></label>
							<div class="col col-8 col-sm-12">
								<input maxlength="10" type="date" id="finish_date" name="finish_date" value="">
							</div>                
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-resource">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='963.Güncellenecek İlişki Şekli'></label>
							<div class="col col-8 col-sm-12">
								<cf_wrk_combo 
									name="new_resource"
									query_name="GET_PARTNER_RESOURCE"
									value=""
									option_name="resource"
									option_value="resource_id"
									width="150">
							</div>                
						</div>
						<div class="form-group" id="item-resource">
							<label class="col col-4 col-sm-12">&nbsp;</label>
							<div class="col col-8 col-sm-12">
								<input type="button" value="<cf_get_lang dictionary_id='966.Çalışan Adayı Verilerini Güncelle'>" class="ui-wrk-btn ui-wrk-btn-success" onclick="savePermissions(3)"/>
							</div>                
						</div>
					</div>
				</cf_box_elements>
			</form>
		</div>
	</cf_tab>
<cfelseif isdefined("attributes.type") and attributes.type eq 5>
	<cftry>
	<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
	<cfset zip_filename = "IYS_Export_#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#.zip">
	<cfif not DirectoryExists("#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##session.ep.userid#_zip")>
		<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##session.ep.userid#_zip">
	<cfelse>
		<cfdirectory action="delete" directory="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##session.ep.userid#_zip" recurse="yes">
		<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##session.ep.userid#_zip">
	</cfif>
	<cfquery name="GET_DATA_TACIR" datasource="#dsn#">
		SELECT
			'EPOSTA' AS IZIN_TURU,
			COMPANY_PARTNER_EMAIL AS ALICI,
			1 AS ONAY,
			'' AS IZIN_KAYNAGI,
			CONVERT(nvarchar, RECORD_DATE, 20) AS IZIN_TARIHI,
			'' AS ILGILI_BAYI
		FROM
			COMPANY_PARTNER
		WHERE
			COMPANY_PARTNER_STATUS = 1 AND
			ISNULL(WANT_EMAIL,1) = 1 AND
			COMPANY_PARTNER_EMAIL IS NOT NULL AND 
			LEN(COMPANY_PARTNER_EMAIL) > 1 AND
			COMPANY_PARTNER_EMAIL LIKE '%_@__%.__%' AND 
			LEN(COMPANY_PARTNER_EMAIL) BETWEEN 6 AND 256
		UNION ALL
		SELECT
			'SMS' AS IZIN_TURU,
			CASE WHEN
				SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,2) = 90 THEN '+'+REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL	
			WHEN 
				SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,1) = 0 THEN '+9'+REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL
			WHEN
				SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,1) != 0 THEN '+90'+REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL
			ELSE 
				REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL END AS ALICI,
			1 AS ONAY,
			'' AS IZIN_KAYNAGI,
			CONVERT(nvarchar, RECORD_DATE, 20) AS IZIN_TARIHI,
			'' AS ILGILI_BAYI
		FROM
			COMPANY_PARTNER
		WHERE
			COMPANY_PARTNER_STATUS = 1 AND
			ISNULL(WANT_SMS,1) = 1 AND
			MOBIL_CODE IS NOT NULL AND 
			MOBILTEL IS NOT NULL AND 
			LEN(MOBIL_CODE) > 0 AND 
			LEN(MOBILTEL)>0 AND 
			LEN(MOBIL_CODE+MOBILTEL) BETWEEN 10 AND 13
		UNION ALL
		SELECT
			'ARAMA' AS IZIN_TURU,
			CASE WHEN
				SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,2) = 90 THEN '+'+REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL	
			WHEN 
				SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,1) = 0 THEN '+9'+REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL
			WHEN
				SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL,1,1) != 0 THEN '+90'+REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL
			ELSE 
				REPLACE(MOBIL_CODE,'+','')+''+MOBILTEL END AS ALICI,
			1 AS ONAY,
			'' AS IZIN_KAYNAGI,
			CONVERT(nvarchar, RECORD_DATE, 20) AS IZIN_TARIHI,
			'' AS ILGILI_BAYI
		FROM
			COMPANY_PARTNER
		WHERE
			COMPANY_PARTNER_STATUS = 1 AND
			ISNULL(WANT_CALL,1) = 1 AND
			MOBIL_CODE IS NOT NULL AND 
			MOBILTEL IS NOT NULL AND 
			LEN(MOBIL_CODE) > 0 AND 
			LEN(MOBILTEL)>0 AND 
			LEN(MOBIL_CODE+MOBILTEL) BETWEEN 10 AND 13
	</cfquery>
	<cfset file_name2 = "iysExportTacir_#session.ep.userid#_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#.csv">
	<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
		<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
	</cfif>
	<cfset columnList = ''>
	<cfloop index="ind" from="1" to="#arrayLen(GetMetaData(GET_DATA_TACIR))#">
		<cfset columnList = listAppend(columnList,trim(GetMetaData(GET_DATA_TACIR)[ind]['Name']))>
	</cfloop>
	<cfset strOutput = QueryToCSV(GET_DATA_TACIR,columnList) />
	<cffile action="write" addnewline="yes" file="#upload_folder#reserve_files#dir_seperator##drc_name_#/#session.ep.userid#_zip/#file_name2#" output="#strOutput#" fixnewline="yes" charset="iso-8859-9">
	
	<cfquery name="GET_DATA_BIREY" datasource="#dsn#">
		SELECT
			'EPOSTA' AS IZIN_TURU,
			C.CONSUMER_EMAIL AS ALICI,
			1 AS ONAY,
			ISNULL(CPR.IYS_INFO,'') AS IZIN_KAYNAGI,
			CONVERT(nvarchar, C.RECORD_DATE, 20) AS IZIN_TARIHI,
			'' AS ILGILI_BAYI
		FROM
			CONSUMER AS C
			LEFT JOIN COMPANY_PARTNER_RESOURCE AS CPR ON C.RESOURCE_ID = CPR.RESOURCE_ID
		WHERE
			C.CONSUMER_STATUS = 1 AND
			ISNULL(C.WANT_EMAIL,1) = 1 AND
			C.CONSUMER_EMAIL IS NOT NULL AND 
			LEN(C.CONSUMER_EMAIL) > 1 AND
			C.CONSUMER_EMAIL LIKE '%_@__%.__%' AND 
			LEN(C.CONSUMER_EMAIL) BETWEEN 6 AND 256
		UNION ALL
		SELECT
			'SMS' AS IZIN_TURU,
			CASE WHEN
				SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,2) = 90 THEN '+'+REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL	
			WHEN 
				SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,1) = 0 THEN '+9'+REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL
			WHEN
				SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,1) != 0 THEN '+90'+REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL
			ELSE 
				REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL END AS ALICI,
			1 AS ONAY,
			ISNULL(CPR.IYS_INFO,'') AS IZIN_KAYNAGI,
			CONVERT(nvarchar, C.RECORD_DATE, 20) AS IZIN_TARIHI,
			'' AS ILGILI_BAYI
		FROM
			CONSUMER AS C
			LEFT JOIN COMPANY_PARTNER_RESOURCE AS CPR ON C.RESOURCE_ID = CPR.RESOURCE_ID
		WHERE
			C.CONSUMER_STATUS = 1 AND
			ISNULL(C.WANT_SMS,1) = 1 AND
			C.MOBIL_CODE IS NOT NULL AND 
			C.MOBILTEL IS NOT NULL AND
			LEN(C.MOBIL_CODE) > 0 AND 
			LEN(C.MOBILTEL)>0 AND 
			LEN(C.MOBIL_CODE+C.MOBILTEL) BETWEEN 10 AND 13
		UNION ALL
		SELECT
			'ARAMA' AS IZIN_TURU,
			CASE WHEN
				SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,2) = 90 THEN '+'+REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL	
			WHEN 
				SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,1) = 0 THEN '+9'+REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL
			WHEN
				SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,1) != '+' AND SUBSTRING(REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL,1,1) != 0 THEN '+90'+REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL
			ELSE 
				REPLACE(C.MOBIL_CODE,'+','')+''+C.MOBILTEL END AS ALICI,
			1 AS ONAY,
			ISNULL(CPR.IYS_INFO,'') AS IZIN_KAYNAGI,
			CONVERT(nvarchar, C.RECORD_DATE, 20) AS IZIN_TARIHI,
			'' AS ILGILI_BAYI
		FROM
			CONSUMER AS C
			LEFT JOIN COMPANY_PARTNER_RESOURCE AS CPR ON C.RESOURCE_ID = CPR.RESOURCE_ID
		WHERE
			C.CONSUMER_STATUS = 1 AND
			ISNULL(C.WANT_CALL,1) = 1 AND
			C.MOBIL_CODE IS NOT NULL AND 
			C.MOBILTEL IS NOT NULL AND 
			LEN(C.MOBIL_CODE) > 0 AND 
			LEN(C.MOBILTEL)>0 AND 
			LEN(C.MOBIL_CODE+C.MOBILTEL) BETWEEN 10 AND 13
		UNION ALL
		SELECT
			'EPOSTA' AS IZIN_TURU,
			EMAIL AS ALICI,
			1 AS ONAY,
			ISNULL(CPR.IYS_INFO,'') AS IZIN_KAYNAGI,
			CONVERT(nvarchar, EA.RECORD_DATE, 20) AS IZIN_TARIHI,
			'' AS ILGILI_BAYI
		FROM
			EMPLOYEES_APP AS EA
			LEFT JOIN COMPANY_PARTNER_RESOURCE AS CPR ON EA.RESOURCE_ID = CPR.RESOURCE_ID
		WHERE
			EA.APP_STATUS = 1 AND
			ISNULL(EA.WANT_EMAIL,1) = 1 AND
			EA.EMAIL IS NOT NULL AND 
			LEN(EA.EMAIL) > 1 AND 
			EA.EMAIL LIKE '%_@__%.__%' AND 
			LEN(EA.EMAIL) BETWEEN 6 AND 256
		UNION ALL
		SELECT
			'SMS' AS IZIN_TURU,
			CASE WHEN
				SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,1) != '+' AND SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,2) = 90 THEN '+'+REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL	
			WHEN 
				SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,1) != '+' AND SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,1) = 0 THEN '+9'+REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL
			WHEN
				SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,1) != '+' AND SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,1) != 0 THEN '+90'+REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL
			ELSE 
				REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL END AS ALICI,
			1 AS ONAY,
			ISNULL(CPR.IYS_INFO,'') AS IZIN_KAYNAGI,
			CONVERT(nvarchar, EA.RECORD_DATE, 20) AS IZIN_TARIHI,
			'' AS ILGILI_BAYI
		FROM
			EMPLOYEES_APP AS EA
			LEFT JOIN COMPANY_PARTNER_RESOURCE AS CPR ON EA.RESOURCE_ID = CPR.RESOURCE_ID
		WHERE
			EA.APP_STATUS = 1 AND
			ISNULL(EA.WANT_SMS,1) = 1 AND
			EA.MOBILCODE IS NOT NULL AND 
			EA.MOBIL IS NOT NULL AND
			LEN(EA.MOBILCODE) > 0 AND 
			LEN(EA.MOBIL)>0 AND 
			LEN(EA.MOBILCODE+MOBIL) BETWEEN 10 AND 13
		UNION ALL
		SELECT
			'ARAMA' AS IZIN_TURU,
			CASE WHEN
				SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,1) != '+' AND SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,2) = 90 THEN '+'+REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL	
			WHEN 
				SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,1) != '+' AND SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,1) = 0 THEN '+9'+REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL
			WHEN
				SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,1) != '+' AND SUBSTRING(REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL,1,1) != 0 THEN '+90'+REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL
			ELSE 
				REPLACE(EA.MOBILCODE,'+','')+''+EA.MOBIL END AS ALICI,
			1 AS ONAY,
			ISNULL(CPR.IYS_INFO,'') AS IZIN_KAYNAGI,
			CONVERT(nvarchar, EA.RECORD_DATE, 20) AS IZIN_TARIHI,
			'' AS ILGILI_BAYI
		FROM
			EMPLOYEES_APP AS EA
			LEFT JOIN COMPANY_PARTNER_RESOURCE AS CPR ON EA.RESOURCE_ID = CPR.RESOURCE_ID
		WHERE
			EA.APP_STATUS = 1 AND
			ISNULL(EA.WANT_CALL,1) = 1 AND
			EA.MOBILCODE IS NOT NULL AND 
			EA.MOBIL IS NOT NULL AND 
			LEN(EA.MOBILCODE) > 0 AND 
			LEN(EA.MOBIL)>0 AND 
			LEN(EA.MOBILCODE+MOBIL) BETWEEN 10 AND 13
	</cfquery>
	<cfset file_name2 = "iysExportBirey_#session.ep.userid#_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#.csv">
	<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
		<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
	</cfif>
	<cfset columnList = ''>
	<cfloop index="ind" from="1" to="#arrayLen(GetMetaData(GET_DATA_BIREY))#">
		<cfset columnList = listAppend(columnList,trim(GetMetaData(GET_DATA_BIREY)[ind]['Name']))>
	</cfloop>
	<cfset strOutput = QueryToCSV(GET_DATA_BIREY,columnList) />
	<cffile action="write" addnewline="yes" file="#upload_folder#reserve_files#dir_seperator##drc_name_#/#session.ep.userid#_zip/#file_name2#" output="#strOutput#" fixnewline="yes" charset="iso-8859-9">
	
	<cfzip file="#upload_folder#/reserve_files/#drc_name_#/#session.ep.userid#_zip/#zip_filename#" source="#upload_folder#/reserve_files/#drc_name_#/#session.ep.userid#_zip">	
	<script type="text/javascript">
		<cfoutput>
			get_wrk_message_div("ZIP","ZIP","documents/reserve_files/#drc_name_#/#session.ep.userid#_zip/#zip_filename#");
		</cfoutput>
	</script>
	<cfcatch>
		<cfdump var="#cfcatch#">
		<script type="text/javascript">
			<cfoutput>
				alert('<cf_get_lang dictionary_id='967.Excel oluşturulurken hata oluştu..'>');
			</cfoutput>
		</script>
	</cfcatch>
	</cftry>
<cfelseif isdefined("attributes.type") and attributes.type eq 6>
	<cfif len(attributes.start_date)>
		<cfset attributes.newStartDate = CreateDateTime(listFirst(attributes.start_date,'-'),listGetAt(attributes.start_date,2,'-'),listLast(attributes.start_date,'-'),0,0,0)>
	<cfelse>
		<cfset attributes.newStartDate = ''>
	</cfif>
	<cfif len(attributes.finish_date)>
		<cfset attributes.newFinishDate = CreateDateTime(listFirst(attributes.finish_date,'-'),listGetAt(attributes.finish_date,2,'-'),listLast(attributes.finish_date,'-'),0,0,0)>
	<cfelse>
		<cfset attributes.newFinishDate = ''>
	</cfif>
	<cfif attributes.permissionType eq 1>
		<cfif len(attributes.new_resource)>
			<cfquery name="UPD_DATA" datasource="#DSN#">
				UPDATE
					COMPANY_PARTNER
				SET
					RESOURCE_ID = #attributes.new_resource#
				WHERE
					COMPANY_PARTNER_STATUS = 1
					<cfif len(attributes.resource)>
						AND RESOURCE_ID = #attributes.resource#
					</cfif>
					<cfif len(attributes.newStartDate) and len(attributes.newFinishDate)>
						AND RECORD_DATE BETWEEN #attributes.newStartDate# AND #dateadd('d',1,attributes.newFinishDate)#
					<cfelseif len(attributes.newStartDate)>
						AND RECORD_DATE > #attributes.newStartDate#
					<cfelseif len(attributes.newFinishDate)>
						AND RECORD_DATE < #dateadd('d',1,attributes.newFinishDate)#
					</cfif>
					<cfif isdefined("attributes.sms_confirm") and attributes.sms_confirm eq 1>
						AND ISNULL(WANT_SMS,1) = 1
					</cfif>
					<cfif isdefined("attributes.email_confirm") and attributes.email_confirm eq 1>
						AND ISNULL(WANT_EMAIL,1) = 1
					</cfif>
			</cfquery>
			<script type="text/javascript">
				$("#messageField").removeClass('show').addClass('hide');
				refresh_box('project_summary_1','V16/correspondence/display/message_permission_stats.cfm?type=1','0');
			</script>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='968.Lütfen Yeni İlişki Tipi Seçiniz'>");
				refresh_box('project_summary_4','V16/correspondence/display/message_permission_stats.cfm?type=4','0');
			</script>
		</cfif>
	<cfelseif attributes.permissionType eq 2>
		<cfif len(attributes.new_resource)>
			<cfquery name="UPD_DATA" datasource="#DSN#">
				UPDATE
					CONSUMER
				SET
					RESOURCE_ID = #attributes.new_resource#
				WHERE
					CONSUMER_STATUS = 1
					<cfif len(attributes.resource)>
						AND RESOURCE_ID = #attributes.resource#
					</cfif>
					<cfif len(attributes.newStartDate) and len(attributes.newFinishDate)>
						AND RECORD_DATE BETWEEN #attributes.newStartDate# AND #dateadd('d',1,attributes.newFinishDate)#
					<cfelseif len(attributes.newStartDate)>
						AND RECORD_DATE > #attributes.newStartDate#
					<cfelseif len(attributes.newFinishDate)>
						AND RECORD_DATE < #dateadd('d',1,attributes.newFinishDate)#
					</cfif>
					<cfif isdefined("attributes.sms_confirm") and attributes.sms_confirm eq 1>
						AND ISNULL(WANT_SMS,1) = 1
					</cfif>
					<cfif isdefined("attributes.email_confirm") and attributes.email_confirm eq 1>
						AND ISNULL(WANT_EMAIL,1) = 1
					</cfif>
			</cfquery>
			<script type="text/javascript">
				$("#messageField").removeClass('show').addClass('hide');
				refresh_box('project_summary_2','V16/correspondence/display/message_permission_stats.cfm?type=2','0');
			</script>
		<cfelse>
			<script type="text/javascript">
				alert('<cf_get_lang dictionary_id='968.Lütfen Yeni İlişki Tipi Seçiniz'>');
				refresh_box('project_summary_4','V16/correspondence/display/message_permission_stats.cfm?type=4','0');
			</script>
		</cfif>
	<cfelseif attributes.permissionType eq 3>
		<cfif len(attributes.new_resource)>
			<cfquery name="UPD_DATA" datasource="#DSN#">
				UPDATE
					EMPLOYEES_APP
				SET
					RESOURCE_ID = #attributes.new_resource#
				WHERE
					APP_STATUS = 1
					<cfif len(attributes.resource)>
						AND RESOURCE_ID = #attributes.resource#
					</cfif>
					<cfif len(attributes.newStartDate) and len(attributes.newFinishDate)>
						AND RECORD_DATE BETWEEN #attributes.newStartDate# AND #dateadd('d',1,attributes.newFinishDate)#
					<cfelseif len(attributes.newStartDate)>
						AND RECORD_DATE > #attributes.newStartDate#
					<cfelseif len(attributes.newFinishDate)>
						AND RECORD_DATE < #dateadd('d',1,attributes.newFinishDate)#
					</cfif>
					<cfif isdefined("attributes.sms_confirm") and attributes.sms_confirm eq 1>
						AND ISNULL(WANT_SMS,1) = 1
					</cfif>
					<cfif isdefined("attributes.email_confirm") and attributes.email_confirm eq 1>
						AND ISNULL(WANT_EMAIL,1) = 1
					</cfif>
			</cfquery>
			<script type="text/javascript">
				$("#messageField").removeClass('show').addClass('hide');
				refresh_box('project_summary_3','V16/correspondence/display/message_permission_stats.cfm?type=3','0');
			</script>
		<cfelse>
			<script type="text/javascript">
				alert('<cf_get_lang dictionary_id='968.Lütfen Yeni İlişki Tipi Seçiniz'>');
				refresh_box('project_summary_4','V16/correspondence/display/message_permission_stats.cfm?type=4','0');
			</script>
		</cfif>
	</cfif>
</cfif>
<cffunction
	name="QueryToCSV"
	access="public"
	returntype="string"
	output="false"
	hint="I take a query and convert it to a comma separated value string.">

	<cfargument
		name="Query"
		type="query"
		required="true"
		hint="I am the query being converted to CSV."
		/>
	<cfargument
		name="Fields"
		type="string"
		required="true"
		hint="I am the list of query fields to be used when creating the CSV value."
		/>
	<cfargument
		name="CreateHeaderRow"
		type="boolean"
		required="false"
		default="true"
		hint="I flag whether or not to create a row of header values."
		/>
	<cfargument
		name="Delimiter"
		type="string"
		required="false"
		default=","
		hint="I am the field delimiter in the CSV value."
		/>

	<cfset var LOCAL = {} />

	<cfset LOCAL.ColumnNames = [] />

	<cfloop
		index="LOCAL.ColumnName"
		list="#ARGUMENTS.Fields#"
		delimiters=",">

		<cfset ArrayAppend(
			LOCAL.ColumnNames,
			Trim( LOCAL.ColumnName )
			) />

	</cfloop>

	<cfset LOCAL.ColumnCount = ArrayLen( LOCAL.ColumnNames ) />
	<cfset LOCAL.Buffer = CreateObject( "java", "java.lang.StringBuffer" ).Init() />
	<cfset LOCAL.NewLine = (Chr( 13 ) & Chr( 10 )) />

	<cfif ARGUMENTS.CreateHeaderRow>
		<cfset LOCAL.RowData = [] />
		<cfloop
			index="LOCAL.ColumnIndex"
			from="1"
			to="#LOCAL.ColumnCount#"
			step="1">
			<cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = """#LOCAL.ColumnNames[ LOCAL.ColumnIndex ]#""" />
		</cfloop>

		<cfset LOCAL.Buffer.Append(
			JavaCast(
				"string",
				(
					ArrayToList(
						LOCAL.RowData,
						ARGUMENTS.Delimiter
						) &
					LOCAL.NewLine
				))
			) />
	</cfif>

	<cfloop query="ARGUMENTS.Query">
		<cfset LOCAL.RowData = [] />
		<cfloop
			index="LOCAL.ColumnIndex"
			from="1"
			to="#LOCAL.ColumnCount#"
			step="1">
			<cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = ARGUMENTS.Query[ LOCAL.ColumnNames[ LOCAL.ColumnIndex ] ][ ARGUMENTS.Query.CurrentRow ] />
		</cfloop>

		<cfset LOCAL.Buffer.Append(
			JavaCast(
				"string",
				(
					ArrayToList(
						LOCAL.RowData,
						ARGUMENTS.Delimiter
						) &
					LOCAL.NewLine
				))
			) />
	</cfloop>

	<!--- Return the CSV value. --->
	<cfreturn LOCAL.Buffer.ToString() />
</cffunction>