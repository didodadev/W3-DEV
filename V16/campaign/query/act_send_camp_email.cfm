<!--- --- 18/08/2004 18:14:00 --- --->
<!--- UPDATED BY N OMER HAMZAOGLU --->
<!--- --- 18/08/2004 18:14:00 --- --->
<cfinclude template="get_campaign.cfm">
<cfinclude template="get_camp_proms.cfm">
<cfinclude template="get_email_cont.cfm">
<cfinclude template="get_email_assets.cfm">
<cfif IsDefined ('attributes.consumer_id') and len(attributes.consumer_id)>
    <cfquery name="GET_CONS_STATUS" datasource="#DSN#">
    	SELECT CONSUMER_STATUS FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
    </cfquery>
</cfif>
<cfif cgi.server_port eq 443>
	<cfset user_domain_ = "https://#cgi.server_name#">
<cfelse>
	<cfset user_domain_ = "http://#cgi.server_name#">
</cfif>
<cfquery datasource="#DSN#" name="GET_COMP">
	SELECT COMPANY_NAME,EMAIL FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif Len(attributes.survey_id)><!--- anket varmý --->
	<cfquery name="GET_SURVEY" datasource="#DSN#">
		SELECT
			SURVEY
		FROM
			SURVEY	
		WHERE 
			SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
	</cfquery>
	<cfquery name="GET_SURVEY_ALTS" datasource="#DSN#"><!--- Anket sonuçlarý --->
		SELECT
			ALT_ID
		FROM
			SURVEY_ALTS
		WHERE
			SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
	</cfquery>
</cfif>
<cfquery name="GET_COMP_INFO" datasource="#DSN#">
	SELECT
		WEB,
		EMAIL,
		COMPANY_NAME,
		NICK_NAME
	FROM
		OUR_COMPANY
</cfquery>
<cfquery name="GET_LOGOS" datasource="#DSN#">
	SELECT
		ASSET_FILE_NAME,
		ASSET_FILE_SERVER_ID
	FROM
		OUR_COMPANY_ASSET
</cfquery>
<cfif IsDefined ('attributes.consumer_id') and get_cons_status.consumer_status eq 1 or IsDefined ('attributes.partner_id')>
	<cfif Len(consumer_email)> <!--- #consumer_email# #listlast(server_detail)#<#listfirst(server_detail)#>--->
  	  <cfmail 
            from="#get_comp.company_name#<#get_comp.email#>"
            to="#consumer_email#"
            subject="#email_cont.email_subject#" 
            type="HTML"> 
        <html>
        <head>
            <title><cf_get_lang dictionary_id='58783.Workcube'></title>
            <meta name="Language" content="Turkish">
            <meta http-equiv="pragma" content="nocache">
            <meta http-equiv="expires" content="Thu, 1 October 2002 00:00:00 PST">
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            <style type="text/css">
				body {margin:0;}
				.content {margin:0;}
				.content .main_page{ margin:0 auto; clear:both;}
				.content .main_page table{border-collapse:collapse;}	
				.content .main_page p{text-align:center;}	
				.content h2 {font-family:Verdana, Geneva, sans-serif; color:##0088ca; text-align:left; font-size:13px;}
				.content .date_ {float:right; font-family:Verdana, Geneva, sans-serif; font-size:10px; color:##888; text-align:right;}
            </style>
        </head>
        <body>
        	<div class="content">
          		<cfif len(get_logos.asset_file_name)>
            		<div class="main_page">
             			<img src="#user_domain##file_web_path#settings/#get_logos.asset_file_name#" border="0">
            		</div>
          		</cfif>	
                <div class="main_page">
                    <table width="100%">
                    	<tr>
                        	<td><h2>Sn: #attributes.receiver#</h2></td>
                            <td class="date_">#dateformat(now(),dateformat_style)#</td>
                        </tr>
                    </table>
                </div>
                <div class="main_page">
                	<p>#email_cont.email_body#</p>
                </div>
				<cfif camp_proms.recordcount>
	                <div class="main_page"><cf_get_lang dictionary_id='49473.Kampanya Promosyonları'> : <br/>
                        <table>
	                        <cfif camp_proms.recordcount>
				                <cfloop query="camp_proms">
                					<tr> 
                						<td>#prom_head#</td>
                					</tr>
                				</cfloop>
                			</cfif>
                		</table>
                	</div>
                </cfif>
            	<div class="main_page">&nbsp;</div>
          		<cfif Len(attributes.survey_id)>
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
                                                        <cfset part_adr = Encrypt(partner_id,cont_key,"CFMX_COMPAT","Hex")>
                                                    <cfelse>
                                                        <cfset part_adr = Encrypt(consumer_id,cont_key,"CFMX_COMPAT","Hex")>
                                                    </cfif>
                                                    <form name="vote_survey" method="POST" onSubmit="" action="http://#listfirst(server_url,';')#/#request.self#?fuseaction=home.emptypopup_vote_survey">
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
                                                    			<td style="width:20px;text-align:right;">
																	<cfif get_survey.survey_type IS 2>
	                                                                    <input type="Checkbox" name="answer" id="answer" value="#get_survey_alts.alt_id#">
                                                                    <cfelseif get_survey.survey_type IS 1>
   	                                                                	<input type="radio" name="answer" id="answer" value="#get_survey_alts.alt_id#">
                                                                    </cfif>
                                                    			</td>
                                                    			<td style="width:250px;">#alt#</td>
                                                    		</tr>
                                                    	</cfloop>
                                                    	<tr style="height:35px;text-align:right;">
                                                    		<td><input type="image" src="#user_domain#images/hand.gif" value="Oy Ver"></td>
                                                    	</tr>
                                                    </form>
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
							<td style="font-family:Verdana, Geneva, sans-serif; font-size:10px; color:##888; text-align:right">
								<cfset cont_key = 'wrk'>
                                <cfset mail_adr = Encrypt(consumer_email,cont_key,"CFMX_COMPAT","Hex")>
                                <cf_get_lang dictionary_id="49416.Eposta listesinden çıkmak için tıklayınız"> : <a href="#user_domain_#/#request.self#?fuseaction=home.emptypopup_remove_email_from_list&mail_adr=#mail_adr#" style="font-family:Verdana, Geneva, sans-serif; font-size:10px; color:##888; text-align:right; text-decoration:none; font-weight:bold;"> <strong><cf_get_lang dictionary_id='62384.E-posta Almak İstemiyorum'>.</strong></a>
							</td>
						</tr>		
					</table>
	            </div>
    	    </div>
        	<cfloop query="get_email_assets">
        	    <cfmailparam file="#upload_folder#campaign#dir_seperator##get_email_assets.file_name#"> 				
        	</cfloop>
        </body>
	</html>
	</cfmail>
	<cftransaction>
		<cfif isdefined("attributes.consumer_id")>
			<cfquery name="ADD_SENT_CONT" datasource="#DSN#">
                INSERT INTO
                    SEND_CONTENTS
                    (
                        CONT_ID,
                        CONT_TYPE,
                        SEND_CON,
                        SEND_DATE,
                        RECORD_IP,
                        SENDER_EMP,
                        CAMP_ID
                    )
                	VALUES
                    (
                        #email_cont_id#,
                        1,
                        #attributes.consumer_id#,
                        #now()#,
                        '#CGI.REMOTE_ADDR#',
                        #session.ep.userid#,
                        #attributes.camp_id#
                    )
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.partner_id")>
			<cfquery name="ADD_SENT_CONT" datasource="#DSN#"><!--- CONT_TYPE: 1 EMAIL 2 FAX 3 DIRECT-MAIL 4 SMS 5 FACE2FACE --->
                INSERT INTO
                    SEND_CONTENTS
                    (
                        CONT_ID,
                        CONT_TYPE,
                        SEND_PAR,
                        SEND_DATE,
                        RECORD_IP,
                        SENDER_EMP,
                        CAMP_ID
                    )
                    VALUES
                    (
                        #email_cont_id#,
                        1,
                        #attributes.partner_id#,
                        #now()#,
                        '#CGI.REMOTE_ADDR#',
                        #session.ep.userid#,
                        #attributes.camp_id#
				)
			</cfquery>
  	  	</cfif>
	</cftransaction>
	<script language="JavaScript">
		<cfif not isdefined("attributes.draggable")>
			opener.location.reload();
			alert("<cf_get_lang dictionary_id='49454.E-posta Gönderildi'>");
			window.close();
		<cfelse>
			location.reload();
		</cfif>
	</script>
<cfelse>
	<script language="JavaScript">
		alert("<cf_get_lang dictionary_id='58197.başarısız'>:<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>-<cf_get_lang dictionary_id='57428.E-mail'>");
		history.go(-1);
	</script>
</cfif>
<cfelseif IsDefined ('attributes.consumer_id') and get_cons_status.consumer_status eq 0>
	<script language="JavaScript">
		<cfif not isdefined("attributes.draggable")>
			opener.location.reload();
			alert("<cf_get_lang dictionary_id='60852.Mail gönderimi sırasında hata oluştu'>! <cf_get_lang dictionary_id='62383.Pasif bir bireysel üye seçtiniz'>.");
			window.close();
			history.go(-1);
		<cfelse>
			location.reload();
		</cfif>
	</script>
</cfif>
