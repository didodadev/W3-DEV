<cfif isdefined("session_base.userid")>
	<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
		<cfset attributes.member_type = "partner">
		<cfquery name="GET_P" datasource="#DSN#">
			SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<cfif get_p.recordcount>			
			<cfset attributes.member_id = "#get_p.manager_partner_id#">
		<cfelse>
			<script type="text/javascript">
				alert('Şirket Yetkilisini Tanımlayınız!');
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfelseif isdefined("session.pp.userid")>
        <cfset attributes.member_type = "partner">
        <cfset attributes.member_id = "#session.pp.userid#">
    <cfelse>
        <cfset attributes.member_type = "consumer">
        <cfset attributes.member_id = "#session.ww.userid#">
    </cfif>
    <cfif attributes.member_type eq "partner">
        <cfquery name="GET_PARTNER_IDS" datasource="#DSN#">
            SELECT 
                PARTNER_ID
            FROM 
                COMPANY_PARTNER 
            WHERE 
                COMPANY_ID = 
                ( 
                    SELECT 
                        COMPANY_ID 
                    FROM 
                        COMPANY_PARTNER 
                    WHERE 
                        COMPANY_PARTNER.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
                )
        </cfquery>
    </cfif>
    <cfquery name="GET_ANALYSIS_RESULTS" datasource="#DSN#">
        SELECT 
            COMPANY_ID
        FROM 
            MEMBER_ANALYSIS_RESULTS
        WHERE
            ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#"> AND
            <cfif attributes.member_type eq "partner">
                PARTNER_ID IN (#ValueList(get_partner_ids.partner_id)#)
            <cfelse>
                CONSUMER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"> 
            </cfif>
    </cfquery>
    <cfif get_analysis_results.recordcount>
        <cfset is_open_ = 0>
    <cfelse>
        <cfset is_open_ = 1>
    </cfif>
    <cfif attributes.member_type is "partner">
        <cfset session.member_type = "partner">
        <cfset session.memberid = attributes.member_id>
        <cfset url.pid = attributes.member_id>
    <cfelseif attributes.member_type is "consumer">
        <cfset session.member_type = "consumer">
        <cfset session.memberid = attributes.member_id>
        <cfset url.cid = attributes.member_id>
    </cfif>
    <cfset session.analysis_id = attributes.analysis_id>
    <cfinclude template="../query/get_analysis.cfm">
    <table cellpadding="2" cellspacing="1" style="width:100%;">
        <tr class="color-row" style="height:30px;">
            <td class="txtboldblue">&nbsp;<cf_get_lang_main no='148.Analiz'> : <cfoutput>#get_analysis.analysis_head#</cfoutput></td>
        </tr>
        <tr class="color-row">
            <td class="txtboldblue">&nbsp;<cf_get_lang_main no='1195.Firma'>/<cf_get_lang_main no='166.Yetkili'>: <cfoutput><cfif attributes.member_type is "partner">#get_par_info(attributes.member_id,0,1,0)#<cfelse></cfif></cfoutput></td>
        </tr>
        <tr class="color-row">
            <td style="vertical-align:top;">
                <!--- sorular duzenli ve birarada --->
                <cfinclude template="../query/get_analysis_questions.cfm">
                <cfinclude template="../display/dsp_mq1.cfm">
            </td>
        </tr>
    </table>
    <script language="JavaScript1.1">
        function right(e)
        {
            if(navigator.appName == 'Netscape' && (e.which == 3 || e.which == 2)) return false;
            else if (navigator.appName == 'Microsoft Internet Explorer' && (event.button == 2 || event.button == 3)) 
            {
                alert("<cf_get_lang no='1029.Sağ Tıklama İzniniz Yok'> !");
                return false;
            }
        
            if (event.altKey || event.ctrlKey) 
            {
            //alert("Kısayol Tuşlarına İzniniz Yok !");
            //return false;
            }
            return true;
        }
        
        document.onkeydown=right;
        
        if (document.layers) window.captureEvents(Event.KEYDOWN);
        
        window.onmousedown=right;
        window.onmouseup=right;
        window.onkeydown=right;
    </script>
<cfelse>
    <cfset session.analysis_id = attributes.analysis_id>
    <cfinclude template="../query/get_analysis.cfm">
    <table style="width:100%;">
        <tr class="color-list" style="height:35px;">
            <td class="headbold">&nbsp;<cf_get_lang_main no='148.Analiz'> : <cfoutput>#get_analysis.analysis_head#</cfoutput></td>
        </tr>
        <tr class="color-row">
            <td style="vertical-align:top;">
                <cfinclude template="../query/get_analysis_questions.cfm">
                <cfif get_analysis_questions.recordcount>
                    <form name="make_analysis" method="post" action="">
                        <cfoutput query="get_analysis_questions">
                            <table align="center" class="color-row" style="width:99%;">
                                <tr>
                                    <td><strong><cf_get_lang_main no='1398.Soru'> #currentrow#:</strong> #question# </td>
                                </tr>
                                <cfif answer_number neq 0>
                                    <cfloop from="1" to="20" index="i">
                                        <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                                            <tr class="color-row">
                                                <td>
                                                    <cfswitch expression="#question_type#">
                                                        <cfcase value="1">
                                                            <input type="Radio" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
                                                        </cfcase>
                                                        <cfcase value="2">
                                                            <input type="checkbox" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
                                                        </cfcase>
                                                    </cfswitch>
                                                    <input type="hidden" name="user_answer_#currentrow#_point" id="user_answer_#currentrow#_point" value="#evaluate('answer'&i&'_point')#">
                                                    #evaluate("answer"&i&"_text")#
                                                    <cfif len(evaluate("answer"&i&"_photo"))>
                                                        <cf_get_server_file output_file="member/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1" alt="#getLang('main',668)#" title="#getLang('main',668)#">
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </cfif>
                                    </cfloop>
                                <cfelse>
                                    <input type="hidden" name="open_question" id="open_question" value="1">
                                    <tr class="color-row">
                                        <td><textarea name="user_answer_#currentrow#" id="user_answer_#currentrow#" cols="45" rows="4"></textarea></td>
                                    </tr>
                                </cfif>
                                <cfif len(question_info)>
                                    <tr class="color-row">
                                        <td> <strong><cf_get_lang no='217.Açıklama'>:</strong> #question_info# </td>
                                    </tr>
                                </cfif>
                                <tr>
                                    <td><img src="/images/cizgi_yan_50.gif" width="100%" height="15"></td>
                                </tr>
                                <tr>
                                    <td><a href="#request.self#?fuseaction=objects2.public_login">
                                            <font color="red"> >><cf_get_lang no='1030.Analizi Yapmak İçin Üye Girişi Yapmalısınız'>.</font>
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                    </form>
                </cfif>
            </td>
        </tr>
    </table>
	<script language="JavaScript1.1">
        function right(e)
        {
            if(navigator.appName == 'Netscape' && (e.which == 3 || e.which == 2)) return false;
            else if (navigator.appName == 'Microsoft Internet Explorer' && (event.button == 2 || event.button == 3)) 
            {
                alert("<cf_get_lang no='1029.Sağ Tıklama İzniniz Yok'> !");
                return false;
            }
        
            if (event.altKey || event.ctrlKey) 
            {
            }
            return true;
        }
        
        document.onkeydown=right;
        
        if (document.layers) window.captureEvents(Event.KEYDOWN);
        
        window.onmousedown=right;
        window.onmouseup=right;
        window.onkeydown=right;
    </script>
</cfif>
