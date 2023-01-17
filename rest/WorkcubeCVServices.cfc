<cfcomponent rest="true" restpath="/CVServices">
	<!--- TC Kimlik Noya Göre Çekme --->
	<cfset dsn = "workcube_ussas">
	<cffunction name="GetEmployeeAppIdenty" 
	            access="remote" 
	            httpmethod="GET"
	            restpath="EmployeeAppIdenty/{tcidenty}"
	            returntype="string"
	            produces="application/json">
		<cfargument name="tcidenty" restargsource="path" type="string"/>
		<cfquery name="GetIdenty" datasource="#dsn#">
			SELECT
                CV_STAGE, TC_IDENTY_NO, NAME, SURNAME, EMPAPP_ID, SEX, EMAIL, PHOTO, MOBIL, MOBIL2, HOMEPOSTCODE, HOMECOUNTRY, HOMECITY, HOMECOUNTY, HOMEDISTRICT, HOMEBUILDING,
                HOMEAPARTMENT, HOMEADDRESS, TRAINING_LEVEL, ELECTRONIC_TOOLS, PROFESSION, EXPERIENCE, APPLICANT_NOTES, RECORD_APP_DATE, RECORD_APP, RECORD_DATE
            FROM EMPLOYEES_APP WHERE TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.tcidenty#"> AND APP_STATUS = 1
		</cfquery>
		<cfreturn Replace(serializeJSON(GetIdenty),'//','')>
	</cffunction>
    <cffunction name="saveProfilePicture"
        access="remote"
        httpmethod="POST"
        restpath="saveProfile"
        returntype="string">

        <cfargument name="uploadedImage" restargsource="form"/>


        <cfset errorMsg = "Hata yok">
        <cftry>
            <cffile
                action="upload"
                destination="#expandPath('./documents')#"
                result="arguments.uploadedImage"
                accept="image/jpg,image/jpeg"
            />
            <cfcatch type="Any">
                <cfset errorMsg = CFCATCH.message>
            </cfcatch>
        </cftry>
        <cfreturn errorMsg>
    </cffunction>
	<!--- Ilan Listesi --->
	<cffunction name="GetEmployeeApp" 
	            access="remote" 
	            httpmethod="GET"
	            restpath="EmployeeApp"
	            returntype="string"
	            produces="application/json">
		<cfquery name="GetEmployeeApp" datasource="#dsn#">
			SELECT 
				NOTICES.NOTICE_ID,<!--- Ilan ID --->
				NOTICES.NOTICE_NO,<!--- Ilan No --->
				NOTICES.NOTICE_HEAD,<!--- Baslik --->
				NOTICES.DETAIL,<!--- Açiklama --->
				NOTICES.STATUS,<!--- Durum --->
				NOTICES.POSITION_CAT_NAME,<!--- Pozisyon Kategorisi --->
				NOTICES.POSITION_CAT_ID,<!--- Pozisyon Kategori ID --->
				NOTICES.POSITION_NAME,<!--- Pozisyon Adi --->
				NOTICES.POSITION_ID,<!--- Pozisyon ID --->
				NOTICES.VALIDATOR_POSITION_CODE,<!--- Onaylayacak Pozisyon Kodu --->
				NOTICES.STARTDATE,<!--- Yayin Baslangiç --->
				NOTICES.FINISHDATE,<!--- Yayin Bitis --->
				NOTICES.WORK_DETAIL,<!--- Isin Tanimi --->
				NOTICES.COUNT_STAFF,<!--- Ise Alinacak Eleman. Kadro Sayisi --->
				NOTICES.RECORD_EMP,<!--- Kayit Eden --->
				NOTICES.RECORD_DATE,<!--- Kayit Tarihi --->
				NOTICES.COMPANY_ID,<!--- Ilanin Yayinlandigi Sirket ID --->
				NOTICES.COMPANY,<!--- Ilanin Yayinlandigi Sirket Adı --->
                NOTICES.WORK_LOCATION,<!--- Ilanin Yayinlandigi Sirket Adı --->
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME VALIDATOR_POSITION_NAME,<!--- Onaylayacak --->
				DEPARTMENT.DEPARTMENT_ID,<!--- Ilan Departman ID --->
				DEPARTMENT.DEPARTMENT_HEAD,<!--- Ilan Departman Ismi --->
				BRANCH.BRANCH_ID,<!--- Ilan Sube ID --->
				BRANCH.BRANCH_NAME<!--- Ilan Sube Ismi --->
			FROM 
				NOTICES 
				LEFT OUTER JOIN EMPLOYEE_POSITIONS ON NOTICES.VALIDATOR_POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE 
				LEFT OUTER JOIN DEPARTMENT ON DEPARTMENT.DEPARTMENT_ID = NOTICES.DEPARTMENT_ID
				LEFT OUTER JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
			WHERE 
				NOTICES.STATUS = 1
		</cfquery>
		<cfreturn Replace(serializeJSON(GetEmployeeApp),'//','')>
	</cffunction>
	<!--- CV Ekleme Güncelleme --->
	<cffunction name="GetEmployeeAppRecord" 
	            access="remote" 
	            httpmethod="POST"
	            restpath="EmployeeAppRecord/{status}"
	            returntype="string"
				produces="text/plain">
		<cfargument name="status" restargsource="path" type="string"><!--- O ise Ekleme 1 ise Güncelleme. Boş Gelemez. --->
		<cfargument name="empappid" restargsource="form" type="numeric"><!--- Ekleme Ise 0 Gönderilmelidir. Güncelleme İse O CV'nin IDsi Gönderilmelidir. Boş Gelemez.  --->
		<cfargument name="companyid" restargsource="form" type="numeric"><!--- Workcube'teki Kendi Şirketimizin IDsi. Boş Gelemez.  --->
		<cfargument name="process_stage" restargsource="form" type="numeric"><!--- CV Eklemede Süreç Yönetiminde Kayıt Edilmek İstenilen Sürecin İlk Kayıt Aşamasının IDsi. Boş Gelemez. --->
		<cfargument name="name" restargsource="form" type="string"><!--- İsim En Fazla 50 karakter Olabilir. Boş Gelemez.  --->
		<cfargument name="surname" restargsource="form" type="string"><!--- Soyisim En Fazla 50 karakter Olabilir. Boş Gelemez. --->
		<cfargument name="tcidentyno" restargsource="form" type="string"><!--- TC Kimlik No. En Fazla 75 Karakter Olabilir. Boş Gelemez. --->

		<cfargument name="birthdate" restargsource="form" type="string"><!--- Doğum Tarihi. dd/mm/yyyy formatında olmalıdır. Boş Gelebilir. --->
		<cfargument name="email" restargsource="form" type="string"><!--- Email. En Fazla 100 karakter Olabilir. Boş Gelebilir. --->
		<cfargument name="photo" restargsource="form" type="string"><!--- Photo. UUID Şeklinde Gelmelidir. Fotoğraf documents içerisinde hr içine atıldıktan sonra kendisine verilen UUID değer gönderilir. En fazla 255 karakter olabilir. Zorunlu Değildir. --->
		<cfargument name="sex" restargsource="form" type="string"><!--- Yoksa -1 Gönderiniz. 1 Erkek - 0 : Kadın. Zorunlu Değildir. --->
		<cfargument name="mobil" restargsource="form" type="string"><!--- Mobil Kodu. En Fazla 43 karakter Olabilir. Zorunlu Değildir.  --->
		<cfargument name="mobilcode" restargsource="form" type="string"><!--- Mobil Telefon. En Fazla 43 karakter Olabilir. Zorunlu Değildir.  --->
		<cfargument name="mobil2" restargsource="form" type="string"><!--- Başvuranın Yakını Mobil Kodu. En Fazla 43 karakter Olabilir. Zorunlu Değildir.  --->
		<cfargument name="mobilcode2" restargsource="form" type="string"><!--- Başvuranın Yakını Mobil Telefon. En Fazla 43 karakter Olabilir. Zorunlu Değildir.  --->

		<cfargument name="homepostcode" restargsource="form" type="string"><!--- Posta Kodu. En Fazla 43 karakter Olabilir. Zorunlu Değildir.  --->
		<cfargument name="homecountry" restargsource="form" type="numeric"><!--- Ülke. Sayısal Değer. Zorunlu Değildir. --->
		<cfargument name="homecity" restargsource="form" type="numeric"><!--- Şehir. Sayısal Değer. Zorunlu Değildir. --->
		<cfargument name="homecounty" restargsource="form" type="numeric"><!--- İl. Sayısal Değer. Zorunlu Değildir. --->
		<cfargument name="homedistrict" restargsource="form" type="string"><!--- Mahalle ve Cadde. String Değer en fazla 100 karakter olabilir. Zorunlu Değildir.  --->
		<cfargument name="homebuilding" restargsource="form" type="string"><!--- Bina No. String Değer en fazla 40 karakter olabilir. Zorunlu Değildir.  --->
		<cfargument name="homeapartment" restargsource="form" type="string"><!--- Apartman No. String Değer en fazla 40 karakter olabilir. Zorunlu Değildir.  --->

		<cfargument name="traininglevel" restargsource="form" type="numeric"><!--- Eğitim Durumu. Nümerik. Zorunlu Değildir. --->
		<cfargument name="universityid" restargsource="form" type="numeric"><!--- Üniversite. Eğer eğitim durumu ön lisans, lisans, doktora ve master seçilmiş ise gönderilmelidir. Diğerlerinde gönderilmemelidir. Zorunlu değildir. --->
		<cfargument name="universitypartid" restargsource="form" type="numeric"><!--- Üniversite Bölümü. Eğer eğitim durumu ön lisans, lisans, doktora ve master seçilmiş ise gönderilmelidir. Diğerlerinde gönderilmemelidir. Zorunlu değildir. --->
		<cfargument name="highschoolpartid" restargsource="form" type="numeric"><!--- Lise Bölümü. Sadece Lise Seçilmiş İse Gönderilir. Zorunlu Değildir.  --->
		<cfargument name="certificate" restargsource="form" type="string"><!--- Sertifikalar. En fazla 500 karakter. Zorunlu Değildir.  --->
		<cfargument name="language" restargsource="form" type="string"><!--- Bilgiği Diller. Liste Şeklinde Gönderilir. 1,5,6,7,11 gibi. Zorunlu Değildir.   --->

		<cfargument name="profession" restargsource="form" type="string"><!--- Sertifikalar. En fazla 500 karakter. Zorunlu Değildir.   --->
		<cfargument name="experience" restargsource="form" type="string"><!--- Deneyim. En fazla 500 karakter. Zorunlu Değildir.   --->
		<cfargument name="ability" restargsource="form" type="string"><!--- Yapabileceğin İşler. En fazla 500 karakter. Zorunlu Değildir.   --->

		<cfargument name="assetcatid" restargsource="form" type="numeric"><!--- Fiziki Varlık Kategorisi. En fazla 500 karakter. Zorunlu Değildir. -8 İnsan Kaynakları  --->
		<cfargument name="identitydoc" restargsource="form" type="string"><!--- Nüfus Cüzdanı Belge İsmi.  Zorunlu Değildir.   --->
		<cfargument name="identitydoctype" restargsource="form" type="numeric"><!--- Nüfus Cüzdanının Gönderileceği Kategori. Eğer Nüfus Cüzdanı Yüklenmiş İse Zorunludur   --->
		<cfargument name="criminaldoc" restargsource="form" type="string"><!--- Adli Belge İsmi.  Zorunlu Değildir.   --->
		<cfargument name="criminaldoctype" restargsource="form" type="numeric"><!--- Adli Belge Gönderileceği Kategori. Eğer Adli Belge Yüklenmiş İse Zorunludur   --->
		<cfargument name="residencedoc" restargsource="form" type="string"><!--- İkamet İsmi.  Zorunlu Değildir.   --->
		<cfargument name="residencedoctype" restargsource="form" type="numeric"><!--- İkamet Gönderileceği Kategori. Eğer İkamet Belge Yüklenmiş İse Zorunludur   --->
		<cfargument name="familydoc" restargsource="form" type="string"><!--- Aİle Belge İsmi.  Zorunlu Değildir.   --->
		<cfargument name="familydoctype" restargsource="form" type="numeric"><!--- Aile Belge Gönderileceği Kategori. Eğer Aile Belge Yüklenmiş İse Zorunludur   --->
		
		<cfset errorMsg = 'Hata yok'>
		<cftry>
			<!--- Status 0 Geldi. Kayit Yapilacak --->
			<cfif arguments.status eq 0>
				<cflock timeout="60">
					<cftransaction>
						<cfquery name="AddEmpApp" datasource="#dsn#" result="maxid">
							INSERT
							INTO
								EMPLOYEES_APP
								(
									CV_TYPE,
									CV_STAGE,
									STEP_NO,
									APP_STATUS,
									WORK_STARTED,
									WORK_FINISHED,
									NAME,
									SURNAME,
									TC_IDENTY_NO,
									EMAIL,
									PHOTO,
									PHOTO_SERVER_ID,
									SEX,
									MOBIL,
									MOBILCODE,
									MOBIL2,
									MOBILCODE2,

									HOMEPOSTCODE,
									HOMECOUNTRY,
									HOMECITY,
									HOMECOUNTY,
									HOMEDISTRICT,<!--- Yeni Açilacak --->
									HOMEBUILDING,<!--- Yeni Açilacak --->
									HOMEAPARTMENT,<!--- Yeni Açilacak --->
									HOMEADDRESS,

									TRAINING_LEVEL,
									ELECTRONIC_TOOLS,
									IS_APPROVE,<!--- Yeni Açilacak --->
									PROFESSION,<!--- Yeni Açilacak --->
									EXPERIENCE,<!--- Yeni Açilacak --->
									APPLICANT_NOTES,

									RECORD_APP_DATE,
									RECORD_APP,
									RECORD_APP_IP,

									RECORD_EMP,
									RECORD_DATE,
									RECORD_IP

								)
								VALUES
								(
									0,
									#arguments.process_stage#,
								   -1,
									1,
									0,
									0,
								   '#arguments.name#',
								   '#arguments.surname#',
								   '#arguments.tcidentyno#',
									<cfif arguments.email neq -1><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
									<cfif arguments.photo neq -1><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.photo#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
									1,
									<cfif arguments.sex eq 1 or arguments.sex eq 0>#arguments.sex#<cfelse>null</cfif>,
									<cfif arguments.mobil neq -1>'#arguments.mobil#'<cfelse>null</cfif>,
									<cfif arguments.mobilcode neq -1>'#arguments.mobilcode#'<cfelse>null</cfif>,
									<cfif arguments.mobil2 neq -1>'#arguments.mobil2#'<cfelse>null</cfif>,
									<cfif arguments.mobilcode2 neq -1>'#arguments.mobilcode2#'<cfelse>null</cfif>,

									<cfif arguments.homepostcode neq -1>'#arguments.homepostcode#'<cfelse>null</cfif>,
									<cfif arguments.homecountry neq -1 and arguments.homecountry neq 0>'#arguments.homecountry#'<cfelse>null</cfif>,
									<cfif arguments.homecity neq -1 and arguments.homecity neq 0>#arguments.homecity#<cfelse>null</cfif>,
									<cfif arguments.homecounty neq -1 and arguments.homecounty neq 0>#arguments.homecounty#<cfelse>null</cfif>,
									<cfif arguments.homedistrict neq -1>'#arguments.homedistrict#'<cfelse>null</cfif>,
									<cfif arguments.homebuilding neq -1>'#arguments.homebuilding#'<cfelse>null</cfif>,
									<cfif arguments.homeapartment neq -1>'#arguments.homeapartment#'<cfelse>null</cfif>,
									'#arguments.homedistrict# #arguments.homebuilding# #arguments.homeapartment#',

									<cfif arguments.traininglevel neq -1 and arguments.traininglevel neq 0>'#arguments.traininglevel#'<cfelse>null</cfif>,
									<cfif arguments.certificate neq -1>'#arguments.certificate#'<cfelse>null</cfif>,
									1,
									<cfif arguments.profession neq -1>'#arguments.profession#'<cfelse>null</cfif>,
									<cfif arguments.experience neq -1>'#arguments.experience#'<cfelse>null</cfif>,
									<cfif arguments.ability neq -1>'#arguments.ability#'<cfelse>null</cfif>,

									#now()#,
									1,
								   '#cgi.remote_addr#',

									1,
									#now()#,
								   '#cgi.remote_addr#'
								)
						</cfquery>
						<cfset empappidvalue = maxid.identitycol>
						<cfquery name="ADD_IDENTY" datasource="#dsn#">
							INSERT
							INTO
								EMPLOYEES_IDENTY
								(
									EMPAPP_ID,
									TC_IDENTY_NO,
									BIRTH_DATE,
									RECORD_DATE,
									RECORD_IP,
									RECORD_EMP
								)
								VALUES
								(
									#empappidvalue#,
									'#arguments.tcidentyno#',
									<cfif arguments.birthdate neq -1>#arguments.birthdate#<cfelse>null</cfif>,
									#now()#,
								   '#cgi.remote_addr#',
									1
								)
						</cfquery>
						<cfif arguments.traininglevel neq -1 and arguments.traininglevel neq 0>
							<cfif arguments.universitypartid neq -1 and arguments.universitypartid neq 0>
								<cfset partid = arguments.universitypartid>
							<cfelseif arguments.highschoolpartid neq -1 and arguments.highschoolpartid neq 0>
								<cfset partid = arguments.highschoolpartid>
							<cfelse>
								<cfset partid = -1>
							</cfif>
							<cfquery name="AddEmpAppEduInfo" datasource="#dsn#">
								INSERT
								INTO
									EMPLOYEES_APP_EDU_INFO
									(
										EMPAPP_ID,
										EMPLOYEE_ID,
										EDU_TYPE,
										EDU_ID,
										EDU_NAME,
										EDU_PART_ID,
										EDU_PART_NAME,
										EDU_START,
										EDU_FINISH,
										EDU_RANK,
										IS_EDU_CONTINUE
									)
									VALUES
									(
										#empappidvalue#,
										NULL,
										#arguments.traininglevel#,
										<cfif arguments.universityid neq -1 and arguments.universityid neq 0>#arguments.universityid#,<cfelse>null,</cfif>
										NULL,
										<cfif partid neq -1>#partid#,<cfelse>null,</cfif>
										NULL,
										NULL,
										NULL,
										NULL,
										NULL
									)
							</cfquery>
						</cfif>
						<cfif arguments.language neq -1>
							<cfloop list="#arguments.language#" index="i">
								<cfquery name="AddEmpAppLang" datasource="#dsn#">
									INSERT
										INTO
										EMPLOYEES_APP_LANGUAGE
										 (
											EMPAPP_ID,
											LANG_ID,
											LANG_SPEAK,
											LANG_WRITE,
											LANG_MEAN,
											LANG_WHERE,
											RECORD_DATE,
											RECORD_EMP,
											RECORD_IP
										)
										VALUES
										(
											#empappidvalue#,
											#i#,
											NULL,
											NULL,
											NULL,
											NULL,
											#now()#,
											1,
										   '#cgi.remote_addr#'
										)
								</cfquery>
							</cfloop>
						</cfif>
						<!--- Dökümanlar Ekleniyor - Nüfus Cüzdani --->
						<!--- Nüfus Cüzdanı --->
						<cfif arguments.identitydoc neq -1>
							<cfquery name="GetPeriod" datasource="#dsn#" maxrows="1">
								SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #arguments.companyid# ORDER BY PERIOD_ID DESC
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								SELECT ASSET_NO, ASSET_NUMBER FROM GENERAL_PAPERS_MAIN
							</cfquery>
							<cfquery name="AddEmpAppIdentyDoc" datasource="#dsn#">
								INSERT
								INTO
									ASSET
									(
										PERIOD_ID, ASSET_NO, MODULE_NAME, MODULE_ID, ACTION_SECTION, PROJECT_ID, PROJECT_MULTI_ID, ACTION_ID,
										COMPANY_ID, ASSETCAT_ID, ASSET_FILE_NAME, ASSET_FILE_REAL_NAME, ASSET_FILE_SIZE, ASSET_FILE_SERVER_ID, ASSET_NAME, ASSET_DETAIL,
										IS_INTERNET, RECORD_DATE, RECORD_EMP, RECORD_IP, PROPERTY_ID, DEPARTMENT_ID, BRANCH_ID, ASSET_DESCRIPTION,
										IS_LIVE, FEATURED, IS_SPECIAL, IS_TV_PUBLISH, IS_RADIO, TV_CAT_ID, SERVER_NAME, IS_IMAGE,
										LIVE ,IS_DPL ,IS_ACTIVE ,PRODUCT_ID ,REVISION_NO ,VALIDATE_DATE
									)
									VALUES
									(
										#GetPeriod.period_id#, '#getnumber.asset_no#-#getnumber.asset_number+1#', 'hr', 3, 'EMPLOYEES_APP_ID', NULL, NULL, #empappidvalue#,
										#arguments.companyid#, #arguments.assetcatid#, '#arguments.identitydoc#', '#arguments.identitydoc#', 0, 1, 'Nüfus Cüzdani', '',
										0, #now()#, 1, '#cgi.remote_addr#', #arguments.identitydoctype#, 1, 1, 'CV İnternet Başvurusu Nüfus Cüzdanı',
										0, 0, 0, 0, 0, NULL, 'ERP.YPU.COM.TR', 0 ,
										0 ,0 ,1 ,NULL ,0 ,NULL )
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								UPDATE GENERAL_PAPERS_MAIN SET ASSET_NUMBER = ASSET_NUMBER + 1
							</cfquery>
						</cfif>
						<!--- Sabıka Kaydı --->
						<cfif arguments.criminaldoc neq -1>
							<cfquery name="GetPeriod" datasource="#dsn#" maxrows="1">
								SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #arguments.companyid# ORDER BY PERIOD_ID DESC
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								SELECT ASSET_NO, ASSET_NUMBER FROM GENERAL_PAPERS_MAIN
							</cfquery>
							<cfquery name="AddEmpAppIdentyDoc" datasource="#dsn#">
								INSERT
								INTO
									ASSET
									(
										PERIOD_ID, ASSET_NO, MODULE_NAME, MODULE_ID, ACTION_SECTION, PROJECT_ID, PROJECT_MULTI_ID, ACTION_ID,
										COMPANY_ID, ASSETCAT_ID, ASSET_FILE_NAME, ASSET_FILE_REAL_NAME, ASSET_FILE_SIZE, ASSET_FILE_SERVER_ID, ASSET_NAME, ASSET_DETAIL,
										IS_INTERNET, RECORD_DATE, RECORD_EMP, RECORD_IP, PROPERTY_ID, DEPARTMENT_ID, BRANCH_ID, ASSET_DESCRIPTION,
										IS_LIVE, FEATURED, IS_SPECIAL, IS_TV_PUBLISH, IS_RADIO, TV_CAT_ID, SERVER_NAME, IS_IMAGE,
										LIVE ,IS_DPL ,IS_ACTIVE ,PRODUCT_ID ,REVISION_NO ,VALIDATE_DATE
									)
									VALUES
									(
										#GetPeriod.period_id#, '#getnumber.asset_no#-#getnumber.asset_number+1#', 'hr', 3, 'EMPLOYEES_APP_ID', NULL, NULL, #empappidvalue#,
										#arguments.companyid#, #arguments.assetcatid#, '#arguments.criminaldoc#', '#arguments.criminaldoc#', 0, 1, 'Sabıka Kaydı', '',
										0, #now()#, 1, '#cgi.remote_addr#', #arguments.criminaldoctype#, 1, 1, 'CV İnternet Başvurusu Sabıka Kaydı',
										0, 0, 0, 0, 0, NULL, 'ERP.YPU.COM.TR', 0 ,
										0 ,0 ,1 ,NULL ,0 ,NULL )
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								UPDATE GENERAL_PAPERS_MAIN SET ASSET_NUMBER = ASSET_NUMBER + 1
							</cfquery>
						</cfif>
						<!--- İkametgah --->
						<cfif arguments.residencedoc neq -1>
							<cfquery name="GetPeriod" datasource="#dsn#" maxrows="1">
								SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #arguments.companyid# ORDER BY PERIOD_ID DESC
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								SELECT ASSET_NO, ASSET_NUMBER FROM GENERAL_PAPERS_MAIN
							</cfquery>
							<cfquery name="AddEmpAppIdentyDoc" datasource="#dsn#">
								INSERT
								INTO
									ASSET
									(
										PERIOD_ID, ASSET_NO, MODULE_NAME, MODULE_ID, ACTION_SECTION, PROJECT_ID, PROJECT_MULTI_ID, ACTION_ID,
										COMPANY_ID, ASSETCAT_ID, ASSET_FILE_NAME, ASSET_FILE_REAL_NAME, ASSET_FILE_SIZE, ASSET_FILE_SERVER_ID, ASSET_NAME, ASSET_DETAIL,
										IS_INTERNET, RECORD_DATE, RECORD_EMP, RECORD_IP, PROPERTY_ID, DEPARTMENT_ID, BRANCH_ID, ASSET_DESCRIPTION,
										IS_LIVE, FEATURED, IS_SPECIAL, IS_TV_PUBLISH, IS_RADIO, TV_CAT_ID, SERVER_NAME, IS_IMAGE,
										LIVE ,IS_DPL ,IS_ACTIVE ,PRODUCT_ID ,REVISION_NO ,VALIDATE_DATE
									)
									VALUES
									(
										#GetPeriod.period_id#, '#getnumber.asset_no#-#getnumber.asset_number+1#', 'hr', 3, 'EMPLOYEES_APP_ID', NULL, NULL, #empappidvalue#,
										#arguments.companyid#, #arguments.assetcatid#, '#arguments.residencedoc#', '#arguments.residencedoc#', 0, 1, 'İkametgah', '',
										0, #now()#, 1, '#cgi.remote_addr#', #arguments.residencedoctype#, 1, 1, 'CV İnternet Başvurusu İkametgah',
										0, 0, 0, 0, 0, NULL, 'ERP.YPU.COM.TR', 0 ,
										0 ,0 ,1 ,NULL ,0 ,NULL )
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								UPDATE GENERAL_PAPERS_MAIN SET ASSET_NUMBER = ASSET_NUMBER + 1
							</cfquery>
						</cfif>
						<!--- Aile Durum Bildirimi --->
						<cfif arguments.familydoc neq -1>
							<cfquery name="GetPeriod" datasource="#dsn#" maxrows="1">
								SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #arguments.companyid# ORDER BY PERIOD_ID DESC
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								SELECT ASSET_NO, ASSET_NUMBER FROM GENERAL_PAPERS_MAIN
							</cfquery>
							<cfquery name="AddEmpAppIdentyDoc" datasource="#dsn#">
								INSERT
								INTO
									ASSET
									(
										PERIOD_ID, ASSET_NO, MODULE_NAME, MODULE_ID, ACTION_SECTION, PROJECT_ID, PROJECT_MULTI_ID, ACTION_ID,
										COMPANY_ID, ASSETCAT_ID, ASSET_FILE_NAME, ASSET_FILE_REAL_NAME, ASSET_FILE_SIZE, ASSET_FILE_SERVER_ID, ASSET_NAME, ASSET_DETAIL,
										IS_INTERNET, RECORD_DATE, RECORD_EMP, RECORD_IP, PROPERTY_ID, DEPARTMENT_ID, BRANCH_ID, ASSET_DESCRIPTION,
										IS_LIVE, FEATURED, IS_SPECIAL, IS_TV_PUBLISH, IS_RADIO, TV_CAT_ID, SERVER_NAME, IS_IMAGE,
										LIVE ,IS_DPL ,IS_ACTIVE ,PRODUCT_ID ,REVISION_NO ,VALIDATE_DATE
									)
									VALUES
									(
										#GetPeriod.period_id#, '#getnumber.asset_no#-#getnumber.asset_number+1#', 'hr', 3, 'EMPLOYEES_APP_ID', NULL, NULL, #empappidvalue#,
										#arguments.companyid#, #arguments.assetcatid#, '#arguments.familydoc#', '#arguments.familydoc#', 0, 1, 'Aile Durum Bildirimi', '',
										0, #now()#, 1, '#cgi.remote_addr#', #arguments.familydoctype#, 1, 1, 'CV İnternet Başvurusu Aile Durum Bildirimi',
										0, 0, 0, 0, 0, NULL, 'ERP.YPU.COM.TR', 0 ,
										0 ,0 ,1 ,NULL ,0 ,NULL )
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								UPDATE GENERAL_PAPERS_MAIN SET ASSET_NUMBER = ASSET_NUMBER + 1
							</cfquery>
						</cfif>
					</cftransaction>
				</cflock>
			</cfif>
			<!--- Status 1 Geldi. Kayit Yapilacak --->
			<cfif arguments.status eq 1>
				<cfset empappidvalue = arguments.empappid>
				<cflock timeout="60">
					<cftransaction>
						<cfquery name="AddEmpApp" datasource="#dsn#" result="maxid">
							UPDATE
								EMPLOYEES_APP
							SET
								CV_TYPE = 0,
								CV_STAGE = #arguments.process_stage#,
								STEP_NO = -1,
								APP_STATUS = 1,
								WORK_STARTED = 0,
								WORK_FINISHED = 0,
								NAME = '#arguments.name#',
								SURNAME = '#arguments.surname#',
								TC_IDENTY_NO = '#arguments.tcidentyno#',
								EMAIL = '#arguments.email#',
								PHOTO = '#arguments.photo#',
								PHOTO_SERVER_ID = 1,
								SEX = <cfif arguments.sex eq 1 or arguments.sex eq 0>#arguments.sex#<cfelse>null</cfif>,
								MOBIL = <cfif arguments.mobil neq -1>'#arguments.mobil#'<cfelse>null</cfif>,
								MOBILCODE = <cfif arguments.mobilcode neq -1>'#arguments.mobilcode#'<cfelse>null</cfif>,
								MOBIL2 = <cfif arguments.mobil2 neq -1>'#arguments.mobil2#'<cfelse>null</cfif>,
								MOBILCODE2 = <cfif arguments.mobilcode2 neq -1>'#arguments.mobilcode2#'<cfelse>null</cfif>,

								HOMEPOSTCODE = <cfif larguments.homepostcode neq -1>'#arguments.homepostcode#'<cfelse>null</cfif>,
								HOMECOUNTRY = <cfif arguments.homecountry neq -1 and arguments.homecountry neq 0>'#arguments.homecountry#'<cfelse>null</cfif>,
								HOMECITY = <cfif arguments.homecity neq -1 and arguments.homecity neq 0>#arguments.homecity#<cfelse>null</cfif>,
								HOMECOUNTY = <cfif arguments.homecounty neq -1 and arguments.homecounty neq 0>#arguments.homecounty#<cfelse>null</cfif>,
								HOMEDISTRICT =  <cfif arguments.homedistrict neq -1>'#arguments.homedistrict#'<cfelse>null</cfif>,
								HOMEBUILDING = <cfif arguments.homebuilding neq -1>'#arguments.homebuilding#'<cfelse>null</cfif>,
								HOMEAPARTMENT = <cfif arguments.homeapartment neq -1>'#arguments.homeapartment#'<cfelse>null</cfif>,
								HOMEADDRESS = '#arguments.homedistrict# #arguments.homebuilding# #arguments.homeapartment#',

								TRAINING_LEVEL = <cfif arguments.traininglevel neq -1 and arguments.traininglevel neq 0>'#arguments.traininglevel#'<cfelse>null</cfif>,
								ELECTRONIC_TOOLS = <cfif arguments.certificate neq -1>'#arguments.certificate#'<cfelse>null</cfif>,
								IS_APPROVE = 1,
								PROFESSION = <cfif arguments.profession neq -1>'#arguments.profession#'<cfelse>null</cfif>,
								EXPERIENCE = <cfif arguments.experience neq -1>'#arguments.experience#'<cfelse>null</cfif>,
								APPLICANT_NOTES = <cfif arguments.ability neq -1>'#arguments.ability#'<cfelse>null</cfif>,

								UPDATE_APP_DATE = #now()#,
								UPDATE_APP = 1,
								UPDATE_APP_IP = '#cgi.remote_addr#',

								UPDATE_EMP = 1,
								UPDATE_DATE = #now()#,
								UPDATE_IP = '#cgi.remote_addr#'
							WHERE
								EMPAPP_ID = #empappidvalue#
						</cfquery>
						<cfquery name="ADD_IDENTY" datasource="#dsn#">
							UPDATE
								EMPLOYEES_IDENTY
							SET
								TC_IDENTY_NO = '#arguments.tcidentyno#',
								BIRTH_DATE = <cfif arguments.birthdate neq -1>#arguments.birthdate#<cfelse>null</cfif>,
								RECORD_DATE = #now()#,
								RECORD_IP = '#cgi.remote_addr#',
								RECORD_EMP = 1
							WHERE
								EMPAPP_ID = #empappidvalue#
						</cfquery>
						<cfquery name="DelEmpAppEduInfo" datasource="#dsn#">
							DELETE FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #empappidvalue#
						</cfquery>
						<cfif arguments.traininglevel neq -1 and arguments.traininglevel neq 0>
							<cfif arguments.universitypartid neq -1 and arguments.universitypartid neq 0>
								<cfset partid = arguments.universitypartid>
							<cfelseif arguments.highschoolpartid neq -1 and arguments.highschoolpartid neq 0>
								<cfset partid = arguments.highschoolpartid>
							<cfelse>
								<cfset partid = -1>
							</cfif>
							<cfquery name="AddEmpAppEduInfo" datasource="#dsn#">
								INSERT
								INTO
									EMPLOYEES_APP_EDU_INFO
									(
										EMPAPP_ID,
										EMPLOYEE_ID,
										EDU_TYPE,
										EDU_ID,
										EDU_NAME,
										EDU_PART_ID,
										EDU_PART_NAME,
										EDU_START,
										EDU_FINISH,
										EDU_RANK,
										IS_EDU_CONTINUE
									)
									VALUES
									(
										#empappidvalue#,
										NULL,
										#arguments.traininglevel#,
										<cfif arguments.universityid neq -1 and arguments.universityid neq 0>#arguments.universityid#,<cfelse>null,</cfif>
										NULL,
										<cfif partid neq -1>#partid#,<cfelse>null,</cfif>
										NULL,
										NULL,
										NULL,
										NULL,
										NULL
									)
							</cfquery>
						</cfif>
						<cfquery name="DelEmpAppLang" datasource="#dsn#">
							DELETE FROM EMPLOYEES_APP_LANGUAGE WHERE EMPAPP_ID = #empappidvalue#
						</cfquery>
						<cfif arguments.language neq -1>
							<cfloop list="#arguments.language#" index="i">
								<cfquery name="AddEmpAppLang" datasource="#dsn#">
									INSERT
										INTO
										EMPLOYEES_APP_LANGUAGE
										 (
											EMPAPP_ID,
											LANG_ID,
											LANG_SPEAK,
											LANG_WRITE,
											LANG_MEAN,
											LANG_WHERE,
											RECORD_DATE,
											RECORD_EMP,
											RECORD_IP
										)
										VALUES
										(
											#empappidvalue#,
											#i#,
											NULL,
											NULL,
											NULL,
											NULL,
											#now()#,
											1,
										   '#cgi.remote_addr#'
										)
								</cfquery>
							</cfloop>
						</cfif>
						<!--- Dökümanlar Ekleniyor - Nüfus Cüzdani --->
						<!--- Nüfus Cüzdanı --->
						<cfquery name="DelDoc" datasource="#dsn#">
							DELETE FROM ASSET WHERE MODULE_NAME = 'hr' AND MODULE_ID = 3 AND ACTION_SECTION = 'EMPLOYEES_APP_ID' AND ACTION_ID = #empappidvalue#
						</cfquery>
						<cfif arguments.identitydoc neq -1>
							<cfquery name="GetPeriod" datasource="#dsn#" maxrows="1">
								SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #arguments.companyid# ORDER BY PERIOD_ID DESC
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								SELECT ASSET_NO, ASSET_NUMBER FROM GENERAL_PAPERS_MAIN
							</cfquery>
							<cfquery name="AddEmpAppIdentyDoc" datasource="#dsn#">
								INSERT
								INTO
									ASSET
									(
										PERIOD_ID, ASSET_NO, MODULE_NAME, MODULE_ID, ACTION_SECTION, PROJECT_ID, PROJECT_MULTI_ID, ACTION_ID,
										COMPANY_ID, ASSETCAT_ID, ASSET_FILE_NAME, ASSET_FILE_REAL_NAME, ASSET_FILE_SIZE, ASSET_FILE_SERVER_ID, ASSET_NAME, ASSET_DETAIL,
										IS_INTERNET, RECORD_DATE, RECORD_EMP, RECORD_IP, PROPERTY_ID, DEPARTMENT_ID, BRANCH_ID, ASSET_DESCRIPTION,
										IS_LIVE, FEATURED, IS_SPECIAL, IS_TV_PUBLISH, IS_RADIO, TV_CAT_ID, SERVER_NAME, IS_IMAGE,
										LIVE ,IS_DPL ,IS_ACTIVE ,PRODUCT_ID ,REVISION_NO ,VALIDATE_DATE
									)
									VALUES
									(
										#GetPeriod.period_id#, '#getnumber.asset_no#-#getnumber.asset_number+1#', 'hr', 3, 'EMPLOYEES_APP_ID', NULL, NULL, #empappidvalue#,
										#arguments.companyid#, #arguments.assetcatid#, '#arguments.identitydoc#', '#arguments.identitydoc#', 0, 1, 'Nüfus Cüzdani', '',
										0, #now()#, 1, '#cgi.remote_addr#', #arguments.identitydoctype#, 1, 1, 'CV İnternet Başvurusu Nüfus Cüzdanı',
										0, 0, 0, 0, 0, NULL, 'ERP.YPU.COM.TR', 0 ,
										0 ,0 ,1 ,NULL ,0 ,NULL )
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								UPDATE GENERAL_PAPERS_MAIN SET ASSET_NUMBER = ASSET_NUMBER + 1
							</cfquery>
						</cfif>
						<!--- Sabıka Kaydı --->
						<cfif arguments.criminaldoc neq -1>
							<cfquery name="GetPeriod" datasource="#dsn#" maxrows="1">
								SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #arguments.companyid# ORDER BY PERIOD_ID DESC
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								SELECT ASSET_NO, ASSET_NUMBER FROM GENERAL_PAPERS_MAIN
							</cfquery>
							<cfquery name="AddEmpAppIdentyDoc" datasource="#dsn#">
								INSERT
								INTO
									ASSET
									(
										PERIOD_ID, ASSET_NO, MODULE_NAME, MODULE_ID, ACTION_SECTION, PROJECT_ID, PROJECT_MULTI_ID, ACTION_ID,
										COMPANY_ID, ASSETCAT_ID, ASSET_FILE_NAME, ASSET_FILE_REAL_NAME, ASSET_FILE_SIZE, ASSET_FILE_SERVER_ID, ASSET_NAME, ASSET_DETAIL,
										IS_INTERNET, RECORD_DATE, RECORD_EMP, RECORD_IP, PROPERTY_ID, DEPARTMENT_ID, BRANCH_ID, ASSET_DESCRIPTION,
										IS_LIVE, FEATURED, IS_SPECIAL, IS_TV_PUBLISH, IS_RADIO, TV_CAT_ID, SERVER_NAME, IS_IMAGE,
										LIVE ,IS_DPL ,IS_ACTIVE ,PRODUCT_ID ,REVISION_NO ,VALIDATE_DATE
									)
									VALUES
									(
										#GetPeriod.period_id#, '#getnumber.asset_no#-#getnumber.asset_number+1#', 'hr', 3, 'EMPLOYEES_APP_ID', NULL, NULL, #empappidvalue#,
										#arguments.companyid#, #arguments.assetcatid#, '#arguments.criminaldoc#', '#arguments.criminaldoc#', 0, 1, 'Sabıka Kaydı', '',
										0, #now()#, 1, '#cgi.remote_addr#', #arguments.criminaldoctype#, 1, 1, 'CV İnternet Başvurusu Sabıka Kaydı',
										0, 0, 0, 0, 0, NULL, 'ERP.YPU.COM.TR', 0 ,
										0 ,0 ,1 ,NULL ,0 ,NULL )
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								UPDATE GENERAL_PAPERS_MAIN SET ASSET_NUMBER = ASSET_NUMBER + 1
							</cfquery>
						</cfif>
						<!--- İkametgah --->
						<cfif arguments.residencedoc neq -1>
							<cfquery name="GetPeriod" datasource="#dsn#" maxrows="1">
								SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #arguments.companyid# ORDER BY PERIOD_ID DESC
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								SELECT ASSET_NO, ASSET_NUMBER FROM GENERAL_PAPERS_MAIN
							</cfquery>
							<cfquery name="AddEmpAppIdentyDoc" datasource="#dsn#">
								INSERT
								INTO
									ASSET
									(
										PERIOD_ID, ASSET_NO, MODULE_NAME, MODULE_ID, ACTION_SECTION, PROJECT_ID, PROJECT_MULTI_ID, ACTION_ID,
										COMPANY_ID, ASSETCAT_ID, ASSET_FILE_NAME, ASSET_FILE_REAL_NAME, ASSET_FILE_SIZE, ASSET_FILE_SERVER_ID, ASSET_NAME, ASSET_DETAIL,
										IS_INTERNET, RECORD_DATE, RECORD_EMP, RECORD_IP, PROPERTY_ID, DEPARTMENT_ID, BRANCH_ID, ASSET_DESCRIPTION,
										IS_LIVE, FEATURED, IS_SPECIAL, IS_TV_PUBLISH, IS_RADIO, TV_CAT_ID, SERVER_NAME, IS_IMAGE,
										LIVE ,IS_DPL ,IS_ACTIVE ,PRODUCT_ID ,REVISION_NO ,VALIDATE_DATE
									)
									VALUES
									(
										#GetPeriod.period_id#, '#getnumber.asset_no#-#getnumber.asset_number+1#', 'hr', 3, 'EMPLOYEES_APP_ID', NULL, NULL, #empappidvalue#,
										#arguments.companyid#, #arguments.assetcatid#, '#arguments.residencedoc#', '#arguments.residencedoc#', 0, 1, 'İkametgah', '',
										0, #now()#, 1, '#cgi.remote_addr#', #arguments.residencedoctype#, 1, 1, 'CV İnternet Başvurusu İkametgah',
										0, 0, 0, 0, 0, NULL, 'ERP.YPU.COM.TR', 0 ,
										0 ,0 ,1 ,NULL ,0 ,NULL )
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								UPDATE GENERAL_PAPERS_MAIN SET ASSET_NUMBER = ASSET_NUMBER + 1
							</cfquery>
						</cfif>
						<!--- Aile Durum Bildirimi --->
						<cfif arguments.familydoc neq -1>
							<cfquery name="GetPeriod" datasource="#dsn#" maxrows="1">
								SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #arguments.companyid# ORDER BY PERIOD_ID DESC
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								SELECT ASSET_NO, ASSET_NUMBER FROM GENERAL_PAPERS_MAIN
							</cfquery>
							<cfquery name="AddEmpAppIdentyDoc" datasource="#dsn#">
								INSERT
								INTO
									ASSET
									(
										PERIOD_ID, ASSET_NO, MODULE_NAME, MODULE_ID, ACTION_SECTION, PROJECT_ID, PROJECT_MULTI_ID, ACTION_ID,
										COMPANY_ID, ASSETCAT_ID, ASSET_FILE_NAME, ASSET_FILE_REAL_NAME, ASSET_FILE_SIZE, ASSET_FILE_SERVER_ID, ASSET_NAME, ASSET_DETAIL,
										IS_INTERNET, RECORD_DATE, RECORD_EMP, RECORD_IP, PROPERTY_ID, DEPARTMENT_ID, BRANCH_ID, ASSET_DESCRIPTION,
										IS_LIVE, FEATURED, IS_SPECIAL, IS_TV_PUBLISH, IS_RADIO, TV_CAT_ID, SERVER_NAME, IS_IMAGE,
										LIVE ,IS_DPL ,IS_ACTIVE ,PRODUCT_ID ,REVISION_NO ,VALIDATE_DATE
									)
									VALUES
									(
										#GetPeriod.period_id#, '#getnumber.asset_no#-#getnumber.asset_number+1#', 'hr', 3, 'EMPLOYEES_APP_ID', NULL, NULL, #empappidvalue#,
										#arguments.companyid#, #arguments.assetcatid#, '#arguments.familydoc#', '#arguments.familydoc#', 0, 1, 'Aile Durum Bildirimi', '',
										0, #now()#, 1, '#cgi.remote_addr#', #arguments.familydoctype#, 1, 1, 'CV İnternet Başvurusu Aile Durum Bildirimi',
										0, 0, 0, 0, 0, NULL, 'ERP.YPU.COM.TR', 0 ,
										0 ,0 ,1 ,NULL ,0 ,NULL )
							</cfquery>
							<cfquery name="GETNUMBER" datasource="#dsn#">
								UPDATE GENERAL_PAPERS_MAIN SET ASSET_NUMBER = ASSET_NUMBER + 1
							</cfquery>
						</cfif>
					</cftransaction>
				</cflock>
			</cfif>
			<cfcatch>
				<cfset errorMsg = CFCATCH.message>
			</cfcatch>
		</cftry>
		<cfreturn (errorMsg eq  'Hata yok' ? empappidvalue : errorMsg)>
	</cffunction>
	<cffunction name="GetEmpAppLocation" 
	            access="remote" 
	            httpmethod="GET"
	            restpath="EmpAppLocation/{empappid}"
	            returntype="string"
	            produces="application/json">
		<cfargument name="empappid" restargsource="path" type="numeric"/>
		<cfquery name="GetLocation" datasource="#dsn#">
			SELECT MAP_LOCATION FROM EMPLOYEES_APP WHERE EMPAPP_ID = #arguments.empappid#
		</cfquery>
		<cfreturn Replace(serializeJSON(GetLocation),'//','')>
	</cffunction>
	<cffunction name="UpdEmpAppLocationRecord" 
	            access="remote" 
	            httpmethod="POST"
	            restpath="EmpAppLocationRecord/{empappid}"
	            returntype="string"
	            produces="application/json">
		<cfargument name="empappid" restargsource="path" type="numeric"/>
		<cfargument name="maplocation" restargsource="form" type="string"/>
		<cfquery name="GetLocation" datasource="#dsn#">
			UPDATE 
				EMPLOYEES_APP 
			SET
				MAP_LOCATION = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.maplocation#">
			WHERE 
				EMPAPP_ID = #arguments.empappid#
		</cfquery>
	</cffunction>
	<cffunction name="GetEmpAppNotices" 
	            access="remote" 
	            httpmethod="GET"
	            restpath="EmpAppNotices/{chapterid}"
	            returntype="string"
	            produces="application/json">
		<cfargument name="chapterid" restargsource="path" type="numeric"/>
		<cfquery name="GetLocation" datasource="#dsn#">
			SELECT CONTENT_ID, CONTENT_STATUS, CONT_HEAD, CONT_SUMMARY, CONT_BODY, VIEW_DATE_START, VIEW_DATE_FINISH FROM CONTENT WHERE CHAPTER_ID = #arguments.chapterid#
		</cfquery>
		<cfreturn Replace(serializeJSON(GetLocation),'//','')>
	</cffunction>
        <!--- Çalışanı Seçim Listesine Eklenme. Her İlan Eklendikten Sonra Ona Bağlı Bir Seçim Listesinin Otomatik Olarak Oluşturulması Gerekmektedir. --->
    <cffunction name="GetEmpAppListRecord"
        access="remote"
        httpmethod="POST"
        restpath="EmpAppListRecord/{empappid}"
        returntype="string"
        produces="application/json">
        <cfargument name="empappid" required="yes" restargsource="path" type="numeric"/><!--- CV IDsi --->
        <cfargument name="listid" required="yes" restargsource="form" type="numeric"/><!--- Seçim Listesinin IDsi --->
        <cfset errorMsg = 'Hata yok'>
        <cftry>
            <cfquery name="add_list_row_pos" datasource="#dsn#">
            INSERT
        INTO
        EMPLOYEES_APP_SEL_LIST_ROWS
        (
            EMPAPP_ID,
            APP_POS_ID,
            STAGE,
            ROW_STATUS,
            LIST_ID,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
        )
        VALUES
        (
        #arguments.empappid#,
        NULL,
            NULL,
            1,
        #arguments.listid#,
        #now()#,
        1,
            '#cgi.remote_addr#'
        )
        </cfquery>
        <cfcatch>
            <cfset errorMsg = CFCATCH.message>
        </cfcatch>
        </cftry>
        <cfset emplistalue = "">
        <cfreturn (errorMsg eq 'Hata yok' ? emplistalue : errorMsg)>
    </cffunction>
    <!--- İlana Bağlı Seçim Listesi Getirir --->
    <cffunction name="GetEmpAppList"
        access="remote"
        httpmethod="GET"
        restpath="EmpAppList/{noticeid}"
        returntype="string"
        produces="application/json">
        <cfargument name="noticeid" required="yes" restargsource="path" type="numeric"/>
        <cfquery name="GetNotice" datasource="#dsn#">
            SELECT LIST_ID, LIST_STATUS, LIST_NAME, NOTICE_ID FROM EMPLOYEES_APP_SEL_LIST WHERE NOTICE_ID = #arguments.noticeid#
        </cfquery>
        <cfreturn Replace(serializeJSON(GetNotice),'//','')>
    </cffunction>
    <!--- O Kişinin O İlana Başvuru Yapmış Olup Olmadığını Getirir --->
    <cffunction name="GetEmpAppPos"
        access="remote"
        httpmethod="POST"
        restpath="EmpAppPos/{noticeid}"
        returntype="string"
        produces="application/json">
        <cfargument name="noticeid" required="yes" restargsource="path" type="numeric"/>
        <cfargument name="empappid" required="yes" restargsource="form" type="numeric"/>
        <cfquery name="GetAppPos" datasource="#dsn#">
            SELECT APP_POS_ID, EMPAPP_ID, NOTICE_ID, APP_DATE, APP_NO, SALARY_WANTED, SALARY_WANTED_MONEY, APP_POS_STATUS, VALID, VALID_DATE FROM EMPLOYEES_APP_POS WHERE NOTICE_ID = #arguments.noticeid# AND EMPAPP_ID = #arguments.empappid#
        </cfquery>
        <cfreturn Replace(serializeJSON(GetAppPos),'//','')>
    </cffunction>
    <!--- Kişinin Başvura Tıkladığı Anda Başvuru Yapmasını Sağlar --->
    <cffunction name="GetEmpAppPosRecord"
        access="remote"
        httpmethod="POST"
        restpath="EmpAppPosRecord/{noticeid}"
        returntype="string"
        produces="application/json">
        <cfargument name="noticeid" required="yes" restargsource="path" type="numeric"/><!--- İlan No --->
        <cfargument name="empappid" required="yes" restargsource="form" type="numeric"/><!--- CV IDsi --->
        <cfargument name="commethod_id" restargsource="form" type="numeric"><!--- İletişim Yöntemi --->
        <cfargument name="salary_wanted" restargsource="form" type="numeric"><!--- İstenilen Ücret --->
        <cfargument name="salary_wanted_money" restargsource="form" type="string"><!--- İstenilen Ücret Para Birimi --->
        <cfargument name="detail_app" restargsource="form" type="string"><!--- Açıklama --->
        <cfargument name="startdate_if_accepted" restargsource="form" type="string"><!--- Doğum Tarihi. dd/mm/yyyy formatında olmalıdır. Boş Gelebilir. --->
        <cfset errorMsg = 'Hata yok'>
        <cftry>
            <cfquery name="GetNotice" datasource="#dsn#">
            SELECT POSITION_ID, POSITION_CAT_ID, OUR_COMPANY_ID, BRANCH_ID, DEPARTMENT_ID FROM NOTICES WHERE NOTICE_ID = #arguments.noticeid#
        </cfquery>
        <cfquery name="AddEmpPos" datasource="#dsn#">
            INSERT
            INTO
            EMPLOYEES_APP_POS
            (
                EMPAPP_ID,
                NOTICE_ID,
                POSITION_ID,
                POSITION_CAT_ID,
                APP_DATE,
                COMPANY_ID,
                OUR_COMPANY_ID,
                DEPARTMENT_ID,
                BRANCH_ID,
                COMMETHOD_ID,
                APP_POS_STATUS,
                SALARY_WANTED,
                SALARY_WANTED_MONEY,
                DETAIL,
                STARTDATE_IF_ACCEPTED,
                RECORD_DATE,
                RECORD_IP,
                RECORD_EMP
            )
            VALUES
            (
            #arguments.empappid#,
            #arguments.noticeid#,
            <cfif len(GetNotice.position_id)>#GetNotice.position_id#<cfelse>1</cfif>,
            <cfif len(GetNotice.position_cat_id)>#GetNotice.position_cat_id#<cfelse>1</cfif>,
            #now()#,
            NULL,
            <cfif len(GetNotice.our_company_id)>#GetNotice.our_company_id#<cfelse>null</cfif>,
            <cfif len(GetNotice.department_id)>#GetNotice.department_id#<cfelse>null</cfif>,
            <cfif len(GetNotice.branch_id)>#GetNotice.branch_id#<cfelse>null</cfif>,
                <cfif arguments.commethod_id neq -1>#arguments.commethod_id#<cfelse>null</cfif>,
                1,
                <cfif arguments.salary_wanted neq -1>#arguments.salary_wanted#<cfelse>null</cfif>,
                <cfif arguments.salary_wanted_money neq -1>'#arguments.salary_wanted_money#'<cfelse>null</cfif>,
                <cfif arguments.detail_app neq -1>'#arguments.detail_app#'<cfelse>null</cfif>,
                <cfif arguments.startdate_if_accepted neq -1>#arguments.startdate_if_accepted#<cfelse>null</cfif>,
            #now()#,
            '#cgi.remote_addr#',
                1
            )
        </cfquery>
        <cfcatch>
            <cfset errorMsg = CFCATCH.message>
        </cfcatch>
        </cftry>
        <cfset emplistalue = "">
        <cfreturn (errorMsg eq 'Hata yok' ? emplistalue : errorMsg)>
    </cffunction>
</cfcomponent>