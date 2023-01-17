<cfif isdefined("attributes.mail")>
    <cfquery name="GET_PROCESS" datasource="#DSN#" maxrows="1">
        SELECT TOP 1
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            <cfif isdefined("session.pp")>
                PTR.IS_PARTNER = 1 AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
            <cfelseif isdefined("session.ww")>
                PTR.IS_CONSUMER = 1 AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
            <cfelseif isdefined('session.cp')>
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#"> AND
            <cfelseif isdefined('session.wp')>
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.wp.our_company_id#"> AND
            <cfelse>
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            </cfif>
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects2.popup_add_new_user%">
        ORDER BY 
            PTR.LINE_NUMBER
	</cfquery>
    
	<cfif not get_process.recordcount>
        <script type="text/javascript">
            alert("<cf_get_lang no='33.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
            history.back();
        </script>
        <cfabort>
    </cfif>
	
    <cfquery name="GET_MAIL" datasource="#DSN#">
		SELECT
			EMAIL
		FROM
			EMPLOYEES_APP
		WHERE
			EMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail#">
	</cfquery>
	<cfif get_mail.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1486.Bu e-posta adresine sahip bir kullanıcı sistemde zaten bulunmaktadır'>.");
			history.back(-1);
		</script>
		<cfabort>
	<cfelse>
		<cfset letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,y,z,1,2,3,4,5,6,7,8,9,0">
		<cfset password = ''>
		<cfloop from="1" to="8" index="ind">				     
			 <cfset random = RandRange(1, 33)>
			 <cfset password = "#password##ListGetAt(letters,random,',')#">
		</cfloop>		
		<cf_cryptedpassword password="#password#" output="sifre">
		<cflock name="#CreateUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="ADD_USER" datasource="#DSN#" result="MAX_ID">
					INSERT INTO
						EMPLOYEES_APP
						(
                        	CV_STAGE,
							APP_STATUS,
							NAME,
							SURNAME,
							EMPAPP_PASSWORD,
							EMAIL,
							WORK_STARTED,
							WORK_FINISHED,
							RECORD_APP_DATE,
							RECORD_APP_IP,
							RECORD_DATE
						)
                        VALUES
						(
                        	#get_process.process_row_id#,
							1,
							'#attributes.user_name#',
							'#attributes.user_surname#',
							'#sifre#',
							'#attributes.mail#',
							0,
							0,
							#now()#,
							'#cgi.REMOTE_ADDR#',
							#now()#
						)
				</cfquery>
				<cfquery name="ADD_IDENTY" datasource="#DSN#">
					INSERT INTO
						EMPLOYEES_IDENTY
						(
							EMPAPP_ID
						)
						VALUES
						(
							#max_id.identitycol#
						)
				</cfquery>
				<cfquery name="GET_INFO" datasource="#DSN#">
					SELECT EMAIL FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
				</cfquery>
				<cfquery name="CHECK" datasource="#DSN#">
					SELECT ASSET_FILE_NAME1 FROM OUR_COMPANY WHERE COMP_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
				</cfquery>
                <cfoutput>
				<cfif get_info.recordcount and len(get_info.email)>
					<cfmail to="#attributes.mail#" from="#get_info.email#" subject="Yeni Kullanıcı Kaydı" type="html" charset="utf-8">
						<table style="width:100%">
							<tr>
								<td><cfif len(check.asset_file_name1)><img src="#user_domain##file_web_path#settings/#check.asset_file_name1#" border="0" title="<cf_get_lang_main no='1225.Logo'>" alt="<cf_get_lang_main no='1225.Logo'>"/></cfif></td>
							</tr>
							<tr>
								<td>
									<span>Sayın; #attributes.user_name# #attributes.user_surname#</span> <br/>
									<p>&nbsp;&nbsp;&nbsp;&nbsp;Üyelik başvurunuz onaylanmıştır. Aşağıda belirtilen e-posta adresiniz ve şifreniz ile giriş yapabilirsiniz.</p>
								</td>
							</tr>
							<tr>
								<td class="txtbold">Kullanıcı adı:</td>
							</tr>
							<tr>
								<td><font size="-1" face="Tahoma">#attributes.mail#</font></td>
							</tr>
							<tr>
								<td class="txtbold">Şifreniz:</td>
							</tr>
							<tr>
								<td><font size="-1" face="Tahoma">#password#</font></td>
							</tr>
							<tr>
								<td><p>&nbsp;&nbsp;&nbsp;&nbsp;Şirketimize gösterdiğiniz ilgi için teşekkür ederiz.</p></td>
							</tr>
						</table>		
					</cfmail>
				</cfif>
                </cfoutput>
			</cftransaction>
		</cflock>
        <script language="javascript">
			alert('Yeni kullanıcı kaydınız başarıyla alınmıştır ve şifre bilgileriniz e-posta adresiniz göndermiştir!');
			window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=career.welcome';
		</script>
	</cfif>
</cfif>
