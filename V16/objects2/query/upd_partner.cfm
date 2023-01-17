<cf_date tarih = "attributes.birthdate">
<cfif isDefined('attributes.company_partner_password') and len(attributes.company_partner_password)>
	<cf_cryptedpassword	password='#attributes.company_partner_password#' output='PASS' mod=1>
</cfif>
<cfif (len(attributes.company_partner_username)) and (isDefined('attributes.company_partner_password') and len(attributes.company_partner_password))>
	<cfquery name="CHECK_USERNAME" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_USERNAME 
		FROM 
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.company_partner_username#"> AND 
			COMPANY_PARTNER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pass#"> AND
			PARTNER_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
	</cfquery>	
	<cfif check_username.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='1446.Girdiğiniz Kullanıcı adı ve Şifre Kullanılıyor Lütfen Geri Dönüp Kontrol Ediniz'>");
			window.history.go(-1);
		</script>
	  <cfabort>
	</cfif>
</cfif>

<cfif not isdefined("form.del_photo")> 	
	<cfif len(form.photo)>			
		<cfset file_name = createUUID()>		
		<cffile action="upload" nameconflict="MakeUnique" destination="#upload_folder#member#dir_seperator#" filefield="photo">
		<cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#" destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
        <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
        <cfif listfind(blackList,assetTypeName,',')>
            <cffile action="delete" file="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
            <script type="text/javascript">
                alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                history.back();
            </script>
            <cfabort>
        </cfif>
		<cfset cffile.serverfile = "#file_name#.#cffile.serverfileext#">
		<cfset path = "#file_web_path#member#dir_seperator##cffile.ServerFile#">
		<cfquery name="UPD_PHOTO" datasource="#DSN#">
			UPDATE COMPANY_PARTNER SET PHOTO = '#cffile.serverfile#' WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
		</cfquery>								
	</cfif>
<cfelse>
	<cfquery name="GET_PHOTO" datasource="#DSN#">
		SELECT PHOTO FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
	</cfquery>
	<cfif len(get_photo.photo)>
		<cffile action="DELETE" file="#upload_folder#member#dir_seperator##get_photo.photo#">			
		<cfquery name="UPD_PHOTO" datasource="#DSN#">
			UPDATE COMPANY_PARTNER SET PHOTO = '' WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
		</cfquery>
	</cfif>
	<cfif len(attributes.photo)>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" 
			nameconflict="MAKEUNIQUE" 
		   	destination="#upload_folder#member#dir_seperator#"
			filefield="photo" accept="image/*">
		<cffile action="rename"
			source="#upload_folder#member#dir_seperator##cffile.serverfile#"
		   	destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset cffile.serverfile = #file_name#&"."&#cffile.serverfileext#>
		<cfset path = "#upload_folder#member#dir_seperator##CFFILE.ServerFile#">
		<cfquery name="UPD_PHOTO" datasource="#DSN#">
			UPDATE 
				COMPANY_PARTNER 
			SET 
				PHOTO = '#CFFILE.SERVERFILE#',
				PHOTO_SERVER_ID = #fusebox.server_machine#
			WHERE 
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
		</cfquery>
	</cfif>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_PARTNER" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER 
			SET
				COMPANY_PARTNER_USERNAME= <cfif len(attributes.company_partner_username)>'#attributes.company_partner_username#'<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.company_partner_password') and len(attributes.company_partner_password)>
					COMPANY_PARTNER_PASSWORD='#PASS#',
					LAST_PASSWORD_CHANGE = #now()#,
				</cfif>							
				COMPANY_PARTNER_NAME = '#attributes.company_partner_name#',
				COMPANY_PARTNER_SURNAME = '#attributes.company_partner_surname#',
				COMPANY_PARTNER_STATUS = <cfif isDefined("attributes.company_partner_status")>1<cfelse>0</cfif>,
				MISSION = <cfif len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,
				DEPARTMENT= <cfif len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
				TITLE = '#attributes.title#',
				COMPANY_PARTNER_EMAIL = <cfif len(attributes.company_partner_email)>'#attributes.company_partner_email#'<cfelse>NULL</cfif>,
				SEX= #attributes.sex#,
				IMCAT_ID = <cfif len(attributes.imcat_id)>#attributes.imcat_id#<cfelse>NULL</cfif>,
				IM ='#attributes.im#',
				MOBIL_CODE = <cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
				MOBILTEL = <cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
				COMPANY_PARTNER_TELCODE = <cfif len(attributes.company_partner_telcode)>'#attributes.company_partner_telcode#'<cfelse>NULL</cfif>,
				COMPANY_PARTNER_TEL = <cfif len(attributes.company_partner_tel)>'#attributes.company_partner_tel#'<cfelse>NULL</cfif>,
				COMPANY_PARTNER_TEL_EXT = <cfif len(attributes.company_partner_tel_ext)>'#attributes.company_partner_tel_ext#'<cfelse>NULL</cfif>,
				COMPANY_PARTNER_FAX = <cfif len(attributes.company_partner_fax)>'#attributes.company_partner_fax#'<cfelse>NULL</cfif>,
				HOMEPAGE = <cfif len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
				LANGUAGE_ID = '#attributes.language_id#',
				UPDATE_DATE = #now()#,
				UPDATE_PAR = #session.pp.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				<cfif len(attributes.photo)>PHOTO='#file_name#.#cffile.serverfileext#',</cfif>
				<cfif len(attributes.photo)>PHOTO_SERVER_ID=#fusebox.server_machine#,</cfif>
				COMPBRANCH_ID = #attributes.compbranch_id#,
				COMPANY_PARTNER_ADDRESS = '#attributes.company_partner_address#',
				COMPANY_PARTNER_POSTCODE = '#attributes.company_partner_postcode#',
				COUNTY = <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				CITY = <cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
				SEMT= <cfif isdefined("attributes.semt") and len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
				COUNTRY = <cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>
			WHERE 
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
		</cfquery>
		<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
			SELECT PARTNER_ID FROM COMPANY_PARTNER_DETAIL WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
		</cfquery>
		<cfif get_partner_detail.recordcount>
			<cfquery name="UPD_PARTNER_DETAIL" datasource="#DSN#">
				UPDATE
					COMPANY_PARTNER_DETAIL
				SET
					BIRTHPLACE = '#attributes.birthplace#',
					BIRTHDATE = #attributes.birthdate#
				WHERE
					PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
			</cfquery>
		<cfelse>
			<cfquery name="ADD_PARTNER_DETAIL" datasource="#DSN#">
				INSERT INTO
					COMPANY_PARTNER_DETAIL
				(
					PARTNER_ID,
					BIRTHPLACE,
					BIRTHDATE
				)
				VALUES
				(
					#attributes.partner_id#,
					'#attributes.birthplace#',
					#attributes.birthdate#
				)
			</cfquery>
		</cfif>
		
		<cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
            SELECT 
            	TOP 1 
                CSR.SECTOR_ID,
                C.SECTOR_CAT_ID,
                C.FULLNAME 
            FROM 
            	COMPANY_SECTOR_RELATION CSR,
                COMPANY C 
            WHERE 
            	C.COMPANY_ID = CSR.COMPANY_ID AND 
                C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        </cfquery>
        <!--- Adres Defteri --->
		<cfif not isDefined("attributes.company_partner_status")><cfset attributes.status_ = 0><cfelse><cfset attributes.status_ = 1></cfif>
		<cf_addressbook
			design		= "2"
			type		= "2"
			type_id		= "#attributes.partner_id#"
			active		= "#attributes.status_#"
			name		= "#attributes.company_partner_name#"
			surname		= "#attributes.company_partner_surname#"
			sector_id	= "#ListFirst(get_company_name.sector_cat_id)#"
			company_name= "#get_company_name.fullname#"
			title		= "#attributes.title#"
			email		= "#attributes.company_partner_email#"
			telcode		= "#attributes.company_partner_telcode#"
			telno		= "#attributes.company_partner_tel#"
			faxno		= "#attributes.company_partner_fax#"
			mobilcode	= "#attributes.mobilcat_id#"
			mobilno		= "#attributes.mobiltel#"
			web			= "#attributes.homepage#"
			postcode	= "#attributes.company_partner_postcode#"
			address		= "#wrk_eval('attributes.company_partner_address')#"
			semt		= "#attributes.semt#"
			county_id	= "#attributes.county_id#"
			city_id		= "#attributes.city#"
			country_id	= "#attributes.country#">		
		
		<cfquery name="UPD_PARTNER_SETTINGS" datasource="#DSN#">
			UPDATE 
				MY_SETTINGS_P 
			SET 
				LANGUAGE_ID = '#attributes.language_id#',
				TIMEOUT_LIMIT = '#attributes.timeout_limit#' 
			WHERE 
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
		</cfquery>
		<cfquery name="DEL_WRK_APP" datasource="#DSN#">
			DELETE FROM WRK_SESSION WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"> AND USER_TYPE = 1
		</cfquery>
	</cftransaction>
</cflock>
<cfif attributes.partner_id eq session.pp.userid>
	<cflocation url="#request.self#?fuseaction=home.logout" addtoken="No">
<cfelse>
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_partner&pid=#attributes.partner_id#" addtoken="No">
</cfif>
