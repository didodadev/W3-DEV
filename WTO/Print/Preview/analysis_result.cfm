<cfif isdefined("attributes.action_id")>
    <cfset attributes.analysis_id = attributes.action_id>
</cfif>
<cfif isdefined("attributes.action_row_id")>
    <cfset attributes.result_id = attributes.action_row_id>
</cfif>
<cfinclude template="../../../V16/member/query/get_analysis.cfm">
<cfquery name="get_analysis_result" datasource="#dsn#">                        
	SELECT * FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value=#attributes.analysis_id#>  AND RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value=#attributes.result_id#>
</cfquery>
<cfdocument format="pdf" pagetype="a4" >
    <style>
        table{font-family: "Roboto";}
        .ListContent{margin:auto;padding:50px 25px}
        .bold{font-weight:bold;}
        .progress {
            height: 20px;
            margin:30px 3px 50px 8px!important;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1); 
        }        
        .progress-bar {
            float: left;
            width: 0%;
            height: 100%;
            font-size: 16px;
            line-height: 30px;
            color: #fff;
            text-align: right;
            -webkit-box-shadow: inset 0 -1px 0 rgba(0, 0, 0, 0.15);
            box-shadow: inset 0 -1px 0 rgba(0, 0, 0, 0.15);
            -webkit-transition: width 0.6s ease;
            -o-transition: width 0.6s ease;
            transition: width 0.6s ease; 
        }
        .bg-color-1{background-color: #d7a4f1;}
        .bg-color-2{background-color: #ffeb3b;}
        .bg-color-3{background-color: #faa61c;}
        .bg-color-4{background-color: #2196f3;}
        .bg-color-5{background-color: #28a745;}
        .info_card_item_stage .progress{overflow:visible;}
        .info_card_item_stage .progress-bar{position:relative;color:#000;}
        .scor{
            position: absolute;
            top: -5%;
            left: 36%;
            height: 45px;
            border: 3px solid #e38283;
            background-color: #e38283;
        }
        .mid_header{
        padding: 0 0 20px 0;
        color: #f27575;
        }
        .mt-30{margin-top:30px!important}
    </style>
    <table class="ListContent" width="700px" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td><img src="https://networg.workcube.com/images/helpdesklogo.png" border="0" width="80px" alt="" style="margin-bottom:30px"></td>
            <td><span onclick="window.open('www.workcube.com')" style="font-size:11px;"><i>www.workcube.com</i></span></td>
        </tr>
        <tr>
            <td>
                <div class="mid_header">
                    <h2><cfoutput>#get_analysis.analysis_head#</cfoutput></h2>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <cfif get_analysis_result.recordcount>
                    <cfif len(get_analysis_result.company_id)>
                        <cfquery name="GET_COM" datasource="#DSN#">
                            SELECT FULLNAME AS COMP FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_analysis_result.company_id#">
                        </cfquery>
                    </cfif>       
                    <cfset comp = isdefined('get_com.comp') and len(get_com.comp)?get_com.comp:''>
                    <cfif len(get_analysis_result.partner_id) or len(get_analysis_result.consumer_id)>
                        <cfquery name="GET_PARTNER" datasource="#DSN#">
                            <cfif len(get_analysis_result.partner_id)>
                                SELECT
                                    C.FULLNAME
                                FROM
                                    COMPANY_PARTNER CP,
                                    COMPANY C
                                WHERE
                                    CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_analysis_result.partner_id#"> AND
                                    CP.COMPANY_ID = C.COMPANY_ID
                            <cfelseif len(get_analysis_result.consumer_id)>
                                SELECT
                                    CONSUMER_NAME +' '+ CONSUMER_SURNAME AS FULLNAME
                                FROM
                                    CONSUMER
                                WHERE
                                    CONSUMER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_analysis_result.consumer_id#"> 
                            </cfif>
                        </cfquery>
                    </cfif>
                    <cfset fullname = isdefined('get_partner.fullname') and len(get_partner.fullname)?get_partner.fullname:''>
                    <table>
                        <tbody>
                            <cfoutput>
                                <tr id="comp-id">
                                    <td class="bold"><p style="margin-right:20px">Analiz Yapılan Kurum</p></td> 
                                    <td>#iif(len(get_analysis_result.ATTENDANCE_COMPANY),'get_analysis_result.ATTENDANCE_COMPANY','comp')#</td>
                                </tr>                
                                <tr id="answer-name">
                                    <td class="bold"><p style="margin-right:20px">Analize Cevap Veren</p></td> 
                                    <td>#iif(len(get_analysis_result.attendance_name),'get_analysis_result.attendance_name','fullname')#</td>
                                </tr>
                                <tr id="record-date">
                                    <td class="bold"><p style="margin-right:20px">Analiz Tarihi</p></td> 
                                    <td>#dateformat(get_analysis_result.record_date,dateformat_style)#</td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </table>
                </cfif>    
            </td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr height="20">
                        <td colspan="2"><p class="mt-30"><cfoutput>#get_analysis.ANALYSIS_OBJECTIVE#</cfoutput></p></td>
                    </tr>                                    
                </table>
            </td>
        </tr>
         <tr>
            <td>
                <table>
                    <tr height="20">
                        <td colspan="2"><p class="mt-30"><cfoutput>#get_analysis.detail#</cfoutput></p></td>
                    </tr>                                    
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <div class="mid_header mt-30">
                    <p class="bold" style="font-size:22px">Sonuç</p>
                </div>
            </td>
        </tr> 
        <tr><td class="bold"><p style="font-size:20px">Puanınız: <cfoutput>#get_analysis_result.USER_POINT#</cfoutput></p></td></tr>
        <tr>
            <td>
                <cfset level = 0>
                <cfset comment_head = "Puan aralığı bilgileri girilmemiştir.">
                <cfset comment = "Puana göre açıklama belirtilmemiştir.">
                <cfoutput query="get_analysis">
                    <cfif get_analysis_result.USER_POINT lt score5 or get_analysis_result.USER_POINT eq score5>
                        <cfset comment_head = "(#score5# - 0 arası puan alanlar)">
                        <cfset comment = COMMENT5>
                        <cfset level = 5>
                    <cfelseif get_analysis_result.USER_POINT gt score5 and (get_analysis_result.USER_POINT lt score4 or get_analysis_result.USER_POINT eq score4)>
                        <cfset comment_head = " (#score4# -  #isNumeric(score5)?score5+1:'üstü'#  puan alanlar)">
                        <cfset comment = COMMENT4>
                        <cfset level = 4>
                    <cfelseif get_analysis_result.USER_POINT gt score4 and (get_analysis_result.USER_POINT lt score3 or get_analysis_result.USER_POINT eq score3)>
                        <cfset comment_head = "(#score3# -  #isNumeric(score4)?score4+1:'üstü'# puan alanlar)">
                        <cfset comment = COMMENT3>
                        <cfset level = 3>
                    <cfelseif get_analysis_result.USER_POINT gt score3 and (get_analysis_result.USER_POINT lt score2 or get_analysis_result.USER_POINT eq score2)>
                        <cfset comment_head = "(#score2# - #isNumeric(score3)?score3+1:'üstü'# puan alanlar)">
                        <cfset comment = COMMENT2>
                        <cfset level = 2>
                    <cfelseif get_analysis_result.USER_POINT gt score2 and (get_analysis_result.USER_POINT lt score1 or get_analysis_result.USER_POINT eq score1)>
                        <cfset comment_head = "(#score1# -  #isNumeric(score2)?score2+1:'üstü'#  arası puan alanlar)">
                        <cfset comment = COMMENT1>
                        <cfset level = 1>
                    </cfif>
                    <cfscript>
                        count = 0;
                        if(isNumeric(score5)){ count = count + 1; }
                        if(isNumeric(score4)){ count = count + 1; }
                        if(isNumeric(score3)){ count = count + 1; }
                        if(isNumeric(score2)) {count = count + 1; }
                        if(isNumeric(score1)) {count = count + 1; }
                        if(count neq 0) {count  = 100/count; }
                    </cfscript>
                    <div class="info_card_item_stage" style="padding-left:0!important;margin-left:0!important">                 
                        <div class="progress">        
                            <cfif isNumeric(score5)>
                                <div class="progress-bar bg-color-1 text-right bold" style="width:#count#%" role="progressbar" aria-valuenow="#score5#" aria-valuemin="0" aria-valuemax="#score5#"><cfif level eq 5><span class="scor"></span></cfif>#score5#</div>
                            </cfif>
                            <cfif isNumeric(score4)>
                                <div class="progress-bar bg-color-2 text-right bold" style="width:#count#%" role="progressbar" aria-valuenow="#score4#" aria-valuemin="#iif( isNumeric(score5),'score5',DE('0'))+1#" aria-valuemax="#score4#"><cfif level eq 4><span class="scor"></span></cfif>#score4#</div>   
                            </cfif>
                            <cfif isNumeric(score3)>
                                <div class="progress-bar bg-color-3 text-right bold" style="width:#count#%" role="progressbar" aria-valuenow="#score3#" aria-valuemin="#iif( isNumeric(score4),'score4',DE('0'))+1#" aria-valuemax="#score3#"><cfif level eq 3><span class="scor"></span></cfif>#score3#</div> 
                            </cfif>
                            <cfif isNumeric(score2)>
                                <div class="progress-bar bg-color-4 text-right bold" style="width:#count#%" role="progressbar" aria-valuenow="#score2#" aria-valuemin="#iif( isNumeric(score3),'score3',DE('0'))+1#" aria-valuemax="#score2#"><cfif level eq 2><span class="scor"></span></cfif>#score2#</div> 
                            </cfif>
                            <cfif isNumeric(score1)>
                                <div class="progress-bar bg-color-5 text-right bold" style="width:#count#%" role="progressbar" aria-valuenow="#score1#" aria-valuemin="#iif( isNumeric(score2),'score2',DE('0'))+1#" aria-valuemax="#score1#"><cfif level eq 1><span class="scor"></span></cfif>#score1#</div>
                            </cfif>         
                        </div> 
                    </div>
                    <div class="col col-12 col-12 col-md-12 col-sm-12 col-xs-12">  
                        <p class="bold">#comment_head#</p>
                        <p>#comment#</p>
                    </div>
                </cfoutput>
            </td>
        </tr>
    </table>
</cfdocument>
