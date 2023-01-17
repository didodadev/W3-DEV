<cfquery name="GET_CONTENT_COMMENT" datasource="#DSN#">
	SELECT 
		CONTENT_ID, 
		CONTENT_COMMENT_ID, 
		NAME, 
		SURNAME, 
		MAIL_ADDRESS, 
		CONTENT_COMMENT_POINT, 
		CONTENT_COMMENT,
		PARTNER_ID,
		RECORD_DATE, 
		EMP_ID 
	FROM 
		CONTENT_COMMENT 
	WHERE 
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#">
</cfquery>

<cfparam name="attributes.maxrows" default='25'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#get_content_comment.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="CONTENT_VOTE_" datasource="#DSN#">
	SELECT 
		COUNT(CONTENT_COMMENT_POINT) AS PUAN_YUZDE
	FROM 
		CONTENT_COMMENT 
	WHERE 
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#">
</cfquery>

<cfquery name="GET_CONTENT_VOTE" datasource="#DSN#">
	SELECT 
		CONTENT_COMMENT_POINT,
		COUNT(CONTENT_COMMENT_POINT) AS PUAN
	FROM 
		CONTENT_COMMENT 
	WHERE 
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#">
	GROUP BY 
		CONTENT_COMMENT_POINT
</cfquery>

<cfinclude template="../query/get_content_head.cfm">
<cfsavecontent  variable="head"><cf_get_lang dictionary_id='50583.İerik yorumları'></cfsavecontent>
<cf_box title="#head#" closable="1"><!---İçerik Yorumları--->
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfif get_content_comment.recordcount>
            <cfoutput query="get_content_comment" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfsavecontent variable="txt">
                    #dateformat(dateadd('h',session.ep.time_zone,get_content_comment.record_date),dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,get_content_comment.record_date),timeformat_style)#) -	
                    <cfif len(get_content_comment.emp_id)> #get_emp_info(get_content_comment.emp_id,0,0)#</cfif>
                    <cfif len(get_content_comment.partner_id)>#get_par_info(get_content_comment.partner_id,0,0,0)#</cfif>
                </cfsavecontent> 
                <cf_seperator id="com_#currentrow#" header="#txt#">
                <cf_flat_list id="com_#currentrow#">
                    <tr>
                        <td class="bold"><cf_get_lang dictionary_id='57480.Konu'></td>
                        <td>: #get_content_head.cont_head#</td>
                    </tr>
                    <tr>
                        <td class="bold"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
                        <td>: #name# #surname#</td>
                    </tr>
                    <tr>
                        <td class="bold"><cf_get_lang dictionary_id='57428.Email'></td>
                        <td><a href="mailto:#mail_address#">: #mail_address#</a></td>
                    </tr>
                    <tr>
                        <td class="bold"><cf_get_lang dictionary_id='58984.Puan'></td>
                        <td>: #content_comment_point#</td>
                    </tr>
                    <tr>
                        <td class="bold"><cf_get_lang dictionary_id='29805.Yorum'><a href="javascript://" class="margin-left-10" onClick="windowopen('#request.self#?fuseaction=content.popup_upd_content_comment&content_id=#attributes.content_id#&content_comment_id=#content_comment_id#','large');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='50623.Yorum Düzenle'>" title="<cf_get_lang dictionary_id='50623.Yorum Düzenle'>"></i></a>  </td>
                        <td>: #content_comment#</td>
                    </tr>
                </cf_flat_list>
            </cfoutput>
            <cfif attributes.maxrows lt attributes.totalrecords>
                <cfset adres = "content.popup_view_content_comment&content_id=#attributes.content_id#">
                <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#">
                  
    		</cfif>
        <cfelse>
        	<table>
                <tr>
                    <td><cf_get_lang no='89.İçeriğe Yorum Eklenmemiş'></td>
                </tr>
            </table>
        </cfif>
    </div>
    <cfif isdefined("form.graph_type") and len(form.graph_type)>
        <cfset graph_type = form.graph_type>
    <cfelse>
        <cfset graph_type = "pie">
    </cfif>
    <cfif get_content_vote.recordcount>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <!--- <cfoutput query="get_content_vote">
                    <cfif content_vote_.puan_yuzde neq 0>
                        <cfset my_width = (#get_content_vote.puan#*100/#content_vote_.puan_yuzde#)>	
                        <tr>
                            <td style="vertical-align:top">#content_comment_point# <cf_get_lang dictionary_id='1572.Puan'></td>
                            <td style="width:85%"> 
                                <img src="images/leftbackbrown2.gif" alt="" width="#my_width#%" height="15" align="absmiddle"> 
                                <br />#puan# <cf_get_lang dictionary_id='2034.Kişi'> - %#tlformat(my_width,0)#
                            </td>
                        </tr>
                    </cfif>
                </cfoutput>  --->
           
                    <script src="JS/Chart.min.js"></script>
                    <cfoutput query="get_content_vote">
                                <cfif content_vote_.puan_yuzde neq 0>
                                    <cfset my_width = (#get_content_vote.puan#/#content_vote_.puan_yuzde#)>
                                    <cfset item=#content_comment_point#>
                                    <Cfset value="#my_width#">
                                    <cfset 'item_#currentrow#'="#value#">
		                        	<cfset 'value_#currentrow#'="#item#"> 
                                </cfif>
                              </cfoutput>
                    <canvas id="myChart" style="float:left;max-height:300px;max-width:300px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_content_vote.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "grafik yuzdesi",
									backgroundColor: [<cfloop from="1" to="#get_content_vote.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_content_vote.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
                            options: {
                                legend: {
                                    display: false
                                }
                            }
					});
				</script>		             
        </div>
    </cfif>
</cf_box>
