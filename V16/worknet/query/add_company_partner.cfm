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
<cfif isdefined('attributes.password') and len(attributes.password)>
	<cf_cryptedpassword	password='#attributes.password#' output='pass' mod=1>
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
			COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#"> 
	</cfquery>
	<cfif check_email.recordcount>
		<script type="text/javascript">
			alert("Bu E-Posta ile bir kayıt bulunmaktadır. Şifrenizi unuttuysanız üye girişi ekranından şifre hatırlatma sayfasına ulaşabilirsiniz");
			window.history.go(-1);
		</script>
	  <cfabort>
	</cfif>
</cfif>

<cfif len(attributes.username) and len(attributes.password)>
	<cfquery name="CHECK_USERNAME" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_USERNAME 
		FROM 
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#"> AND 
			COMPANY_PARTNER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="'#pass#'">
	</cfquery>
	<cfif check_username.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='139.kullanıcı adı'>/<cf_get_lang_main no='140.şifre'><cf_get_lang_main no='781.tekrarı'>");
			window.history.go(-1);
		</script>
	  <cfabort>
	</cfif>
</cfif>

<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfset upload_folder = "#upload_folder#member#dir_seperator#">
		<cfif isDefined("form.photo") and len(form.photo)>
			<cftry>
				<cfset file_name = createUUID()>
				<cffile action="UPLOAD" filefield="photo" nameconflict="MAKEUNIQUE" destination="#upload_folder#" accept="image/*">
				<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">		
				<cfset photo_ = '#file_name#.#cffile.serverfileext#'>
				<cfcatch>
					<script type="text/javascript">
						alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz !'>");
						window.history.go(-1);
					</script>
					<cfabort>
				</cfcatch>
			</cftry>
			<cfif isdefined('session.ep.userid')>
				<cfset our_comp_id = session.ep.company_id>
			<cfelseif isdefined('session.pp.userid')>
				<cfset our_comp_id = session.pp.our_company_id>
			</cfif>
			<cfquery name="get_file_size_comp" datasource="#dsn#">
				SELECT FILE_SIZE,IS_FILE_SIZE FROM OUR_COMPANY_INFO WHERE COMP_ID=#our_comp_id#
			</cfquery>
			<!--- dosya boyutu kontrol --->
			<cfif get_file_size_comp.is_file_size>
				<cfquery name="get_file_size" datasource="#dsn#">
					SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#listlast(cffile.serverfile,'.')#'
				</cfquery>
				<cfif get_file_size.recordcount and len(get_file_size.format_size)>
					<cfset dt_size=get_file_size.format_size * 1048576>
					<cfif INT(dt_size) lte INT(filesize)>
						<cfif FileExists("#upload_folder##photo_#")>
							<cffile action="delete" file="#upload_folder##photo_#">
						</cfif>
						 <script type="text/javascript">
							alert('Fotoğraf ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
							history.back();
						</script>
						<cfabort>
					</cfif>
				</cfif>
			</cfif>
			<!--- dosya boyutu kontrol --->
		<cfelse>
			<cfset photo_ = ''>	
		</cfif>
		
		<cfif isDefined("attributes.want_email")><cfset want_email = 1><cfelse><cfset want_email = 0></cfif>
		<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
		<cfset cmp.addPartner(
				company_id:attributes.company_id,
				username:attributes.username,
				password:pass,
				tc_identity:attributes.tc_identity,
				name:attributes.name,
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
				photo:photo_,
				postcod:attributes.postcod,
				adres:attributes.adres,
				county_id:attributes.county_id,
				city_id:attributes.city_id,
				country:attributes.country,
				semt:attributes.semt,
				birthdate:attributes.birthdate,
				want_email:want_email
			) />
            <cfif len(attributes.email)>
				<cfset subject = "Kullanıcı hesabı bilgilendirmesi">
                <cfoutput>
                    <cfsavecontent variable="message">
                        <p class="yazilar">Sayın #attributes.name# #attributes.soyad#,</p>
                        <p class="yazilar">Styleturkish portali üzerinde adınıza kullanıcı hesabı açılmıştır. </p>
                        <p class="yazilar">Kullanıcı adınız : #attributes.email#</p>
                        <p class="yazilar">Şifre : #attributes.password#</p>
                        <p class="yazilar"></p>
                        <p class="yazilar">Giriş İçin : <a href="http://www.styleturkish.com">Style Turkish</a></p>
                    </cfsavecontent>
                </cfoutput>
                <cfset sendMail = createObject("component","worknet.objects.worknet_objects").getMailTemplate(
                        is_status:1,
                        mail_to:attributes.email,
                        message:message,
                        subject:subject
                    )>
            </cfif>
			<cfquery name="get_max_partner" datasource="#dsn#">
				SELECT MAX(PARTNER_ID) AS MAX_PART FROM COMPANY_PARTNER
			</cfquery>
			<cfquery name="get_company_name" datasource="#DSN#">
                SELECT TOP 1 CSR.SECTOR_ID,C.FULLNAME FROM COMPANY_SECTOR_RELATION CSR,COMPANY C WHERE C.COMPANY_ID = CSR.COMPANY_ID AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
            </cfquery>

			<!--- Adres Defteri --->
			<cf_addressbook
				design		= "1"
				type		= "2"
				type_id		= "#get_max_partner.max_part#"
				name		= "#attributes.name#"
				surname		= "#attributes.soyad#"
				sector_id	= "#ListFirst(get_company_name.SECTOR_ID)#"
				company_name= "#get_company_name.fullname#"
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
<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#attributes.company_id#" addtoken="no">
