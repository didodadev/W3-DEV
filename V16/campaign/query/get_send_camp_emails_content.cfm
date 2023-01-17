<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>WORKCUBE</title>
<meta name="Language" content="Turkish">
<meta http-equiv="pragma" content="nocache">
<meta http-equiv="expires" content="Thu, 1 October 2002 00:00:00 PST">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<!---<style type="text/css">
	html,body{height: 100%;width:100%;}
	table{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : 333333;}
	a:visited {text-decoration: none; color:000000;}
	a:active {text-decoration: none;  color:000000;}
	a:hover {text-decoration: underline; color:000000;}
	a:link {text-decoration: none; color:000000;}
	.txtbold {font-weight: bold; font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 10px; color: 000000}
	.printbold {font-weight: bold; font-family: Geneva, Tahoma,Verdana, Arial, sans-serif; font-size: 9px; color: 000000}
	.print {font-family: Geneva,Tahoma, Verdana, Arial, sans-serif; font-size: 9px; color: 000000}
</style>--->
<style type="text/css">
	body {margin:0;}
	.content {margin:0;}
	.content .main_page{ margin:0 auto; clear:both;}
	 .content .main_page table{border-collapse:collapse;}	
	.content .main_page p{text-align:center;}	
	.content h2 {font-family:Verdana, Geneva, sans-serif; color:##0088ca; text-align:left; font-size:13px;}
	.content .date_ {float:right; font-family:Verdana, Geneva, sans-serif; font-size:10px; color:##888; text-align:right;}
</style>
<cfquery name="GET_LOGOS" datasource="#DSN#"><!--- Varsa Logo geliyor. --->
	SELECT ASSET_FILE_NAME FROM OUR_COMPANY_ASSET
</cfquery>
<cfif cgi.server_port eq 443>
	<cfset user_domain_ = "https://#cgi.server_name#">
<cfelse>
	<cfset user_domain_ = "http://#cgi.server_name#">
</cfif>
<!--- <BODY style="background-color:##1e1e1e;"> --->
<body>
    <div class="content">
    	<cfif len(get_logos.asset_file_name)>
            <div class="main_page">
                <img src="#user_domain##file_web_path#settings/#get_logos.asset_file_name#" alt="" border="0">
            </div>
        </cfif>
        <cfif isDefined("attributes.username_surname") and Len(attributes.username_surname)>
            <div class="main_page">
                <table width="100%">
                    <tr>
                        <td><h2><cf_get_lang_main no='1368.Sayın'> #attributes.username_surname#</h2></td>
                        <td class="date_">#DateFormat(now(),dateformat_style)#</td>
                    </tr>
                </table>
            </div>
        </cfif>
        <div class="main_page">
            <p>#email_cont.email_body#</p>
        </div>
		<cfif isdefined('attributes.survey_id') and len(attributes.survey_id)><!--- Anket varsa bu bloða girer. --->
            <cfquery name="GET_SURVEY" datasource="#DSN#">
                SELECT SURVEY FROM SURVEY WHERE SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
            </cfquery>
            <cfquery name="GET_SURVEY_ALTS" datasource="#DSN#">
                SELECT ALT_ID FROM SURVEY_ALTS WHERE SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
            </cfquery>
            <cfset xfa.vote = "myhome.emptypopup_vote_survey">
            <div class="main_page">
                <table cellpadding="0" cellspacing="0" border="0" style="width:98%;">
                    <tr class="color-border">
                        <td>			
                            <table cellpadding="2" cellspacing="1" border="0" style="width:100%;">
                                <tr class="color-row">
                                    <td>	
                                        <table border="0">
                                            <tr style="height:22px;">
                                                <td class="txtbold" colspan="2">#get_survey.survey#</td>
                                            </tr>
                                            <cfset cont_key = 'wrk'>
                                            <cfif IsDefined("attributes.partner_id")>
                                                <cfset part_adr = Encrypt(attributes.partner_id,cont_key,"CFMX_COMPAT","Hex")>
                                            <cfelse>
                                                <cfset part_adr = Encrypt(attributes.consumer_id,cont_key,"CFMX_COMPAT","Hex")>
                                            </cfif>
                                            <cfform name="vote_survey" action="http://#listfirst(server_url,';')#/#request.self#?fuseaction=home.emptypopup_vote_survey" method="post">
                                                <input type="Hidden" name="survey_id" id="survey_id" value="#get_survey.survey_id#">
                                                <input type="hidden" name="user_type" id="user_type" value="<cfif IsDefined("attributes.partner_id")>partner_id<cfelseif IsDefined("attributes.consumer_id")>consumer_id</cfif>">
                                                <input type="hidden" name="user_id" id="user_id" value="#part_adr#">		
                                                <cfif len(get_survey.detail)>
                                                    <tr>
                                                        <td colspan="2">#get_survey.detail#</td>
                                                    </tr>
                                                </cfif>
                                                <cfloop query="get_survey_alts">
                                                    <tr> 
                                                        <td width="20" style="text-align:right;">
                                                            <cfif get_survey.SURVEY_TYPE IS 2>
                                                                <input type="Checkbox" name="answer" id="answer" value="#get_survey_alts.alt_id#">
                                                            <cfelseif get_survey.SURVEY_TYPE IS 1>
                                                                <input type="radio" name="answer"  id="answer" value="#get_survey_alts.alt_id#">
                                                            </cfif>
                                                        </td>
                                                        <td style="width:250px;">#alt#</td>
                                                    </tr>
                                                </cfloop>
                                                <tr style="height:35px;">
                                                    <td style="text-align:right;"><input type="image" src="#user_domain#images/hand.gif" value="Oy Ver"></td>
                                                </tr>
                                            </cfform>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </cfif>
        <div class="main_page">
            <table width="100%" style="float:right;">
                <tr>
                    <td style="font-family:Verdana, Geneva, sans-serif; font-size:10px; color:##888; text-align:center">
                        <cfset cont_key = 'wrk'>
                        <cfset mail_adr = Encrypt(attributes.email_address,cont_key,"CFMX_COMPAT","Hex")>
                        <cf_get_lang no="96.Eposta listesinden çıkmak için tıklayınız">: <a href="#user_domain_#/#request.self#?fuseaction=home.emptypopup_remove_email_from_list&mail_adr=#mail_adr#" style="font-family:Verdana, Geneva, sans-serif; font-size:10px; color:##888; text-align:right; text-decoration:none; font-weight:bold;"><strong>E-posta Almak İstemiyorum.</strong></a>
                    </td>
                </tr>
            </table>
        </div>
    </div>
	<cfif isDefined("attributes.asset_ids") or isDefined("attributes.email_cont_id")>
        <cfinclude template="get_email_assets.cfm"><!--- varlýklar --->
        <cfloop query="get_email_assets">
            <cfmailparam file="#upload_folder#campaign#dir_seperator##get_email_assets.file_name#">				
        </cfloop>
    </cfif>
</body>
</html>
</cfoutput>