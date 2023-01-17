<cfinclude template="../../config.cfm">
<cfif not isdefined('attributes.username')>
	<cfset attributes.username = attributes.email>
</cfif>
<cfif not isdefined('attributes.language_id')>
	<cfif isdefined('session.pp')>
		<cfset attributes.language_id = session.pp.language>
	<cfelse>
		<cfset attributes.language_id = session.ep.language>
	</cfif>
</cfif>

<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
<cfif len(attributes.password)>
	<CF_CRYPTEDPASSWORD	PASSWORD='#attributes.password#' OUTPUT='PASS' MOD=1>
<cfelse>
	<cfset pass = ''>
</cfif>

<cfif len(attributes.email)>
	<cfquery name="CHECK_EMAIL" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_EMAIL
		FROM 
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#"> AND
			PARTNER_ID <> #attributes.partner_id#
	</cfquery>
	<cfif check_email.recordcount>
		<script type="text/javascript">
			alert("Bu E-posta ile kayıtlı bir üye bulunmaktadır.");
		</script>
	  <cfabort>
	</cfif>
</cfif>

<cfif (len(attributes.username)) and (len(attributes.password))>
	<cfquery name="CHECK_USERNAME" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_USERNAME 
		FROM 
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_USERNAME = '#attributes.username#' AND 
			COMPANY_PARTNER_PASSWORD = '#PASS#' AND
			PARTNER_ID <> #attributes.partner_id#
	</cfquery>	
	<cfif check_username.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='139.kullanıcı adı'>/ <cf_get_lang_main no ='140.şifre'><cf_get_lang_main no='781.tekrarı'>..");
		</script>
	  <cfabort>
	</cfif>
</cfif>
<cfobject name="fileHelper" component="#addonNS#.components.common.filehelper">
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfif not isdefined("form.del_photo")> 	
            <cfif len(form.photo)>
                <cftry>
					<cfset photo_ = fileHelper.save_uploaded_file('photo', '#upload_folder#')>
					<cfcatch>
						<script type="text/javascript">
						alert(<cfoutput>'#catch#'</cfoutput>);
						</script>
						<cfabort>
					</cfcatch>
				</cftry>

				<!--- dosya boyutu kontrol --->
				<cfif isdefined('session.ep.userid')>
					<cfset our_comp_id = session.ep.company_id>
				<cfelseif isdefined('session.pp.userid')>
					<cfset our_comp_id = session.pp.our_company_id>
				</cfif>
				<cfquery name="get_file_size_comp" datasource="#dsn#">
					SELECT FILE_SIZE,IS_FILE_SIZE FROM OUR_COMPANY_INFO WHERE COMP_ID=#our_comp_id#
				</cfquery>

				<cfif get_file_size_comp.is_file_size>
					<cfquery name="get_file_size" datasource="#dsn#">
						SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#listlast(cffile.serverfile,'.')#'
					</cfquery>
                    <cfif get_file_size.recordcount and len(get_file_size.format_size)>
                        <cfif fileHelper.remove_exceed_file(get_file_size.format_size, "#upload_folder##photo_#") eq "1">
                            <script type="text/javascript">
                                alert('Fotoğraf ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
                            </script>
                            <cfabort>
                        </cfif>
					</cfif>
				</cfif>
				<!--- dosya boyutu kontrol --->
			<cfelse>
				<cfset photo_ = ''>
			</cfif>
		<cfelse>
			<cfquery name="GET_PHOTO" datasource="#DSN#">
				SELECT PHOTO, PHOTO_SERVER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.partner_id#
			</cfquery>
			<cfif len(get_photo.photo)>
				<cf_del_server_file output_file="member/#get_photo.photo#" output_server="#get_photo.photo_server_id#"> 		
				<cfquery name="UPD_PHOTO" datasource="#DSN#">
					UPDATE COMPANY_PARTNER SET PHOTO = '' WHERE PARTNER_ID = #attributes.partner_id#
				</cfquery>
			</cfif> 
			<cfif len(attributes.photo)>
				<cfset file_name = createUUID()>
				<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" destination="#upload_folder#member#dir_seperator#" filefield="photo" accept="image/*">
				<cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#" destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
				<cfset cffile.serverfile = "#file_name#.#cffile.serverfileext#">
			</cfif>
			<cfset photo_ = ''>
		</cfif>
		
		<cfif isDefined("attributes.company_partner_status")><cfset partner_status = 1><cfelse><cfset partner_status = 0></cfif>
		<cfif isDefined("attributes.want_email")><cfset want_email = 1><cfelse><cfset want_email = 0></cfif>
		<cfif isDefined("attributes.want_sms")><cfset want_sms = 1><cfelse><cfset want_sms = 0></cfif>
		<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.companies.member") />
		<cfset cmp.updPartner(
				partner_id:attributes.partner_id,
				company_id:attributes.company_id,
				username:attributes.username,
				password:pass,
				tc_identity:attributes.tc_identity,
				name:attributes.nameless,
				soyad:attributes.soyad,
				title:attributes.title,
				sex:attributes.sex,
				department:attributes.department,
				email:attributes.email,
				mobilcat_id:attributes.mobilcat_id,
				mobiltel:attributes.mobiltel,
				telcod:attributes.telcod,
				tel:attributes.tel,
				tel_local:attributes.tel_local,
				fax:attributes.fax,
				homepage:attributes.homepage,
				mission:attributes.mission,
				language_id:attributes.language_id,
				compbranch_id:attributes.compbranch_id,
				postcod:attributes.postcod,
				adres:attributes.adres,
				county_id:attributes.county_id,
				city_id:attributes.city_id,
				country:attributes.country,
				semt:attributes.semt,
				birthdate:attributes.birthdate,
				partner_status:partner_status,
				want_email:want_email,
				want_sms:want_sms,
				photo:photo_
			) />
			
			<!--- Adres Defteri --->
			<cf_addressbook
				design		= "2"
				type		= "2"
				type_id		= "#attributes.partner_id#"
				active		= "#partner_status#"
				name		= "#attributes.nameless#"
				surname		= "#attributes.soyad#"
				title		= "#attributes.title#"
				email		= "#attributes.email#"
				telcode		= "#attributes.telcod#"
				telno		= "#attributes.tel#"
				faxno		= "#attributes.fax#"
				mobilcode	= "#attributes.mobilcat_id#"
				mobilno		= "#attributes.mobiltel#"
				web			= "#attributes.homepage#"
				postcode	= "#attributes.postcod#"
				address		= "#wrk_eval('attributes.adres')#"
				semt		= "#attributes.semt#"
				county_id	= "#attributes.county_id#"
				city_id		= "#attributes.city_id#"
				country_id	= "#attributes.country#">
	</cftransaction>
</cflock>

<script type="text/javscript">
	<cfoutput>
	document.location.href = '#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['det-partner']['nextEvent']##attributes.company_id#';
	</cfoutput>
</script>
