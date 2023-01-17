<cfif not isdefined('attributes.register_type')>
    
    <cfif isdefined("attributes.login_language") and len(attributes.login_language)>
        <cfset session.ep.language = attributes.login_language />
        <cfset response = {status: true} />
        <cfoutput>#replace(SerializeJson( response ), '//', '')#</cfoutput>
        <cfabort>
    </cfif>
    
    <cfquery name="GET_EMAIL" datasource="#DSN#">
        <cfif attributes.member_type eq 0>
            (SELECT 
                EMPLOYEE_EMAIL AS EMAIL,
                EMPLOYEE_USERNAME AS USERNAME,
                EMPLOYEE_PASSWORD,
                EMPLOYEE_ID
            FROM
                EMPLOYEES
            WHERE
                EMPLOYEE_STATUS = 1 AND
                EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#"> AND
                EMPLOYEE_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail_address#">
            )
        <cfelseif attributes.member_type eq 1>
            (
            SELECT 
                C.CONSUMER_EMAIL AS EMAIL, 
                C.CONSUMER_USERNAME AS USERNAME 
            FROM 
                CONSUMER C,
                COMPANY_CONSUMER_DOMAINS CCD,
                MAIN_MENU_SETTINGS MMS
            WHERE 
                CCD.MENU_ID = MMS.MENU_ID AND     	
                <!---CCD.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND---> 
                CCD.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#"> AND
                C.CONSUMER_ID = CCD.CONSUMER_ID AND
                C.CONSUMER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail_address#">)
        <cfelseif attributes.member_type eq 2>
            (SELECT
                 CP.COMPANY_ID AS COMPANY, 
                 CP.COMPANY_PARTNER_EMAIL AS EMAIL ,
                 CP.COMPANY_PARTNER_USERNAME AS USERNAME,
                 C.MEMBER_CODE
            FROM
                COMPANY_PARTNER CP,
                COMPANY C
                <cfif not isdefined('session.wp')>
                    ,COMPANY_CONSUMER_DOMAINS CCD
                    ,MAIN_MENU_SETTINGS MMS
                </cfif>
            WHERE
                <cfif not isdefined('session.wp')>
                    CCD.MENU_ID = MMS.MENU_ID AND
                    CCD.PARTNER_ID = CP.PARTNER_ID AND
                    <cfif isdefined('attributes.partner_login_url') and len(attributes.partner_login_url)>
                        MMS.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.partner_login_url#"> AND 
                    <cfelse>
                        MMS.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND 
                    </cfif>
                </cfif>
                C.COMPANY_ID = CP.COMPANY_ID AND
                CP.COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail_address#">)
        </cfif>		
    </cfquery>
    
    <cfquery name="GET_OUR_EMAIL" datasource="#DSN#">
        SELECT
            COMPANY_NAME,
            EMAIL
        FROM
            OUR_COMPANY
        WHERE
            COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#default_company_id_#">
    </cfquery>
    <cfif attributes.member_type eq 2>
        <cfquery name="GET_MY_MENU" datasource="#DSN#" maxrows="1">
            SELECT 
                IS_PASSWORD_CONTROL,
                MENU_ID,
                IS_PUBLISH,
                LEFT_MARJIN,
                TOP_MARJIN,
                GENERAL_WIDTH,
                GENERAL_WIDTH_TYPE,
                GENERAL_ALIGN,
                TOP_INNER_MARJIN,
                LEFT_INNER_MARJIN
            FROM 
                MAIN_MENU_SETTINGS 
            WHERE 
                IS_ACTIVE = 1 AND 
                SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">
            ORDER BY 
                MENU_ID DESC
        </cfquery>
        <cfset attributes.our_company_id = default_company_id_>
    </cfif>
    <cfif get_email.recordcount>
        <cfif isdefined('attributes.member_type') and attributes.member_type neq 1>
            <cfif isdefined("attributes.is_password_info") and attributes.is_password_info eq 1>
                <cfset letters = "1,2,3,4,5,6,7,8,9,0">
                <cfset password = ''>
                <cfloop from="1" to="6" index="ind">				     
                     <cfset random = RandRange(1, 10)>
                     <cfset password = "#password##ListGetAt(letters,random,',')#">
                </cfloop>
            <cfelse>
                <cfset letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,y,z,1,2,3,4,5,6,7,8,9,0">
                <cfset password = ''>
                <cfloop from="1" to="8" index="ind">				     
                     <cfset random = RandRange(1, 33)>
                     <cfset password = "#password##ListGetAt(letters,random,',')#">
                </cfloop>
            </cfif>
        </cfif>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='29708.Şifre Bilgilendirme İşlemi'></cfsavecontent>		
        <cftry>
            <cfset encmail = attributes.mail_address>
            <cfset encmail = encrypt(encmail,'AERTYASD6G6SA3E7',"CFMX_COMPAT","Hex")>		
            <cfmail  
                to = "#attributes.mail_address#"
                from = "#get_our_email.email#"
                subject = "#message#"
                type="HTML">  
                <style type="text/css">
                    .label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
                    .headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
                </style>
                <br/>
                <table align="center" style="width:590px;">
                    <tr style="height:35px;">
                        <td class="headbold"><cf_get_lang dictionary_id='58226.Şifre Hatırlatıcı'></td>
                    </tr>
                    <cfif attributes.member_type eq 2 and not isdefined('session.wp')>	
                        <tr>
                            <td><cf_get_lang dictionary_id='57558.Üye No'>:<strong>#get_email.member_code#</strong></td>
                        </tr> 
                    </cfif>
                    <tr>
                        <td><cf_get_lang dictionary_id='29709.Kullanıcı Adınız'>:<strong>#get_email.username#</strong></td>
                    </tr>
                    <cfif isdefined('attributes.member_type') and (attributes.member_type eq 1 or attributes.member_type eq 2)>
                        <tr>
                            <td><cf_get_lang dictionary_id="29710.Bu e-posta size yeni şifre talebiniz üzerine gönderilmiştir."></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id="29711.Eğer böyle bir talebiniz olmadıysa lütfen bu mesajı yoksayınız."></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id="29712.Yeni şifre oluşturmak için lütfen aşağıdaki linke tıklayınız."></td>
                        </tr>
                        <cfif isdefined('session.wp')>
                            <tr>
                                <td>
                                    <a href="<cfoutput>http://#cgi.HTTP_HOST#/#request.self#?fuseaction=worknet.wp_change_pass&ma=#encmail#&mt=#attributes.member_type#</cfoutput>"><cf_get_lang dictionary_id="29713.Şifrenizi Değiştirmek İçin Tıklayınız!"></a>
                                </td>
                            </tr>
                        <cfelseif isdefined('attributes.member_type') and attributes.member_type eq 2>
                            <tr>
                                <td>
                                    <a href="<cfoutput>http://#cgi.HTTP_HOST#/#request.self#?fuseaction=objects2.popup_change_pass&ma=#encmail#&menu_id=#get_my_menu.menu_id#&mt=#attributes.member_type#</cfoutput>"><cf_get_lang dictionary_id="29713.Şifrenizi Değiştirmek İçin Tıklayınız!"></a>
                                </td>
                            </tr>
                        <cfelse>
                            <tr>
                                <td>
                                    <a href="<cfoutput>http://#cgi.HTTP_HOST#/#request.self#?fuseaction=objects2.change_pass&ma=#encmail#&mt=#attributes.member_type#</cfoutput>"><cf_get_lang dictionary_id="29713.Şifrenizi Değiştirmek İçin Tıklayınız!"></a>
                                </td>
                            </tr>	
                        </cfif>
                    <cfelse>
                        <tr>
                            <td><cf_get_lang dictionary_id='57552.Şifreniz'>:<strong>#password#</strong></td>
                        </tr>
                    </cfif>
                </table>
                <br/>
            </cfmail>
            <cfif attributes.member_type eq 0>
                <cf_CryptedPassword password="#password#" output = "password">	
                <cfquery name="SET_NEW_PASSWORD" datasource="#DSN#">
                     UPDATE 
                        EMPLOYEES
                     SET	
                        EMPLOYEE_PASSWORD = '#password#'
                     WHERE
                         EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#"> AND
                         EMPLOYEE_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail_address#">
                </cfquery>
                <cfquery name="SET_NEW_PASS_HIST" datasource="#DSN#">
                    INSERT INTO
                        EMPLOYEES_HISTORY
                    (
                        EMPLOYEE_ID,
                        IS_PASSWORD_CHANGE,
                        OLD_PASSWORD,
                        NEW_PASSWORD,
                        FORCE_PASSWORD_CHANGE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        #GET_EMAIL.EMPLOYEE_ID#,
                        1,
                        '#GET_EMAIL.EMPLOYEE_PASSWORD#',
                        '#password#',
                        1,
                        #now()#,
                        #GET_EMAIL.EMPLOYEE_ID#,
                        '#cgi.remote_addr#'
                    )
                </cfquery>
            <cfelseif attributes.member_type eq 2>
                <cf_CryptedPassword password="#password#" output = "password">		
                <cfquery name="SET_NEW_PASSWORD" datasource="#DSN#">
                     UPDATE 
                        COMPANY_PARTNER
                     SET	
                         COMPANY_PARTNER_PASSWORD = '#password#'
                     WHERE
                         COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail_address#">
                </cfquery>			
            </cfif>
            <cfquery name="unban_user" datasource="#DSN#">
                UPDATE
                    FAILED_LOGINS
                SET
                    IS_ACTIVE = 0
                WHERE
                    USER_NAME = '#get_email.username#'
            </cfquery>
            <cfset user_domain = (( cgi.server_port eq 443 ) ? 'https://' : 'http://') & cgi.server_name >
            <div class="boxRow uniqueBox" style="padding:200px;">
                <cf_box style="box-shadow:0 0 20px 12px rgb(0 0 0 / 8%);margin:auto;width:600px;height:300px;position:relative;">
                    <div class="portHeadLight">	
                        <div class="portHeadLightTitle">
                            <span>
                                <img src="css/assets/icons/catalyst-icon-svg/workcube-logo.svg" width="65px" height="80px" style="margin:15px 0 0 60px;">
                            </span> 
                        </div>
                    </div>
                    <div class="protein-table">
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <p style="font-family: sans-serif; font-size:14px;">
                                            <label style="line-height:30px;margin:0 0 0 60px;"><cf_get_lang dictionary_id='63699.Yeni Şifreniz'> <cfoutput>#replacelistnocase(GET_EMAIL.EMAIL, 'b,ç,e,g,h,i,k,m,o,p,s,v,z', '*,*,*,*,*,*,*,*,*,*,*,*,*')#</cfoutput></label><br>
                                            <label style="line-height:30px;margin:0 0 0 60px;"><cf_get_lang dictionary_id='63700.mail hesabınıza gönderildi'>.</label><br>
                                        </p>
                                        <p style="font-family: sans-serif; font-size:14px;">
                                            <label style="line-height:30px;margin:0 0 0 60px;"><cf_get_lang dictionary_id='63701.Mailinizi Lütfen Kontrol Edin'>.</label><br>
                                            <label style="line-height:30px;margin:0 0 0 60px;"><cf_get_lang dictionary_id='63702.Yeni Kullanıcı ve şifreniz ile tekrar giriniz'>.</label><br>
                                            <label style="line-height:30px;margin:0 0 0 60px;"><cfoutput><a style="color:black;" href="#user_domain#">#cgi.SERVER_NAME#</a></cfoutput></label>
                                        </p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </cf_box>
            </div>
        <cfcatch type="any">
            <div class="boxRow uniqueBox" style="padding:200px;">
                <cf_box style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08);margin:auto;width:600px;height:300px;position:relative;">
                    <div class="portHeadLight">	
                        <div class="portHeadLightTitle">
                            <span>
                                <img src="css/assets/icons/catalyst-icon-svg/workcube-logo.svg" width="50px" height="80px" style="margin:15px 0 0 60px;">
                            </span> 
                        </div>
                    </div>
                    <div class="protein-table">
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <b style="line-height:50px;margin:0 0 0 60px;">Mail Gönderirken Bir Hata Oluştu.</b><br>
                                        <b style="margin:0 0 0 60px;">Lütfen Verileri Kontrol Edip Tekrar Deneyin.</b>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </cf_box>
            </div>	
        </cfcatch>	
        </cftry>
    <cfelse>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='29830.Sistemde kayıtlı olmayan kullanıcı adı veya şifre girdiniz'>!");
            <cfif isdefined("attributes.referer")>
                document.location.href='<cfoutput>#attributes.referer#</cfoutput>';
            <cfelse>	
                history.back();	
            </cfif>	   
        </script>
        <cfabort>	
    </cfif>

	<cfif isdefined("attributes.referer")>
        <script type="text/javascript">
            function waitfor()
            {
                document.location.href='<cfoutput>#attributes.referer#</cfoutput>';
            }
            setTimeout("waitfor()",3000);  
        </script>
    <cfelse>
        <script type="text/javascript">
            function waitfor()
            {
                <cfif attributes.member_type eq 0>
                    window.parent.gizle_iframe();
                <cfelse>
                    window.close();
                </cfif>
            }
            setTimeout("waitfor()",3000);  
        </script>
    </cfif>
<cfelse>

    <cfinclude template="register_control.cfm" />

</cfif>
<cfabort>