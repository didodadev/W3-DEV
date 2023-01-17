<cffunction name="muhasebe_kod_ekle">
	<cfargument name="muh_kodu" type="string">
	<cfargument name="urun_ismi" type="string">
	<cfargument name="alis_satis" type="boolean">
	
	<cfif alis_satis>
		<cfset alis_satis_ = 'Ürün Alış İşlem'>
	<cfelse>
		<cfset alis_satis_ = 'Ürün Satış İşlem'>
	</cfif>
	<cfif len(muh_kodu)>
		<cfset str_hesap_kodu = muh_kodu >
		<cfset int_sira = ListLen(str_hesap_kodu, "." ) >
		<cfset str_muh_kodu = "" >
		<cfif len(str_hesap_kodu) >
			<cfloop from="1" to="#int_sira#" index="k">
				<cfset str_muh_kodu = ListAppend( str_muh_kodu , ListGetAt( str_hesap_kodu , k , "." ) , "." )>
				<cfquery name="get_account_record" datasource="#DSN2#">
					SELECT * FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#trim(str_muh_kodu)#'<!---  AND SUB_ACCOUNT = 0 --->
				</cfquery>
				<cfif not get_account_record.recordcount and k eq int_sira>
					<cfquery datasource="#DSN2#" name="add_account">
						INSERT INTO 
						ACCOUNT_PLAN 
						(
							ACCOUNT_CODE,
							ACCOUNT_NAME,
							SUB_ACCOUNT,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						)
						VALUES 
						(
							'#str_muh_kodu#',
							'#alis_satis_#',
							0,
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							#now()#							
						)
					</cfquery>
					<cfset str_muh_main_code = "" >
					<cfloop index="m" from="1" to="#evaluate(k-1)#">
						<cfset str_muh_main_code = ListAppend( str_muh_main_code , ListGetAt( str_hesap_kodu , m , "." ) , "." )>
						<cfquery datasource="#DSN2#" name="add_account">
							UPDATE
								 ACCOUNT_PLAN 
							SET 
								SUB_ACCOUNT = 1 ,
								UPDATE_EMP = #SESSION.EP.USERID#,
								UPDATE_IP = '#CGI.REMOTE_ADDR#',
								UPDATE_DATE = #now()#							
							WHERE 
								ACCOUNT_CODE='#str_muh_main_code#'
						</cfquery>
					</cfloop>							
				<cfelseif not get_account_record.recordcount>
					<cfquery datasource="#DSN2#" name="add_account">
						INSERT INTO ACCOUNT_PLAN (
							ACCOUNT_CODE,
							ACCOUNT_NAME,
							SUB_ACCOUNT,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE						
						) VALUES (
							'#str_muh_kodu#',
							'#alis_satis_#',
							1,
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							#now()#
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	<cfreturn true>
</cffunction>
