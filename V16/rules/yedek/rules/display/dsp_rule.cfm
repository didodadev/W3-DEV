<meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="css/assets/template/w3-intranet/style.css?57867687686">
<meta charset="UTF-8">
<!-- Go to www.addthis.com/dashboard to customize your tools --> 
<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-57b2bf8be5b4014c"></script>

<script type="text/javascript">
	function connectAjax()
	{
		var bb = "<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_body_query&content_id=#attributes.cntid#&is_body=1</cfoutput>";
		AjaxPageLoad(bb,'content_body_place',0);
	}
</script>
<!--- bu sayfa birde Doruk için add_options altında vardır,yapılan genel değişiklik ordada yapılmalıdır AE20060621--->
<cfinclude template="../query/get_content.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_chapter_menu.cfm">
<cfinclude template="../query/get_content_cat.cfm">
<cfinclude template="../query/get_customer_cat.cfm">
<cfquery name="GET_ASSET_CATS" datasource="#DSN#">
	SELECT ASSETCAT_ID,ASSETCAT_PATH FROM ASSET_CAT
</cfquery>
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT IS_CONTENT_FOLLOW FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif get_content.recordcount>
	<cfinclude template="../query/get_content_property.cfm">
	<cfinclude template="../query/get_content_file.cfm">
	<cfinclude template="../query/get_related_cont.cfm">
	<cfif len(get_content.hit_employee)>
		<cfset hit_employee = get_content.hit_employee + 1>
	<cfelse>
		<cfset hit_employee = 1>
	</cfif>
	<cfquery name="HIT_UPDATE" datasource="#DSN#">
		UPDATE CONTENT SET HIT_EMPLOYEE = #hit_employee#, LASTVISIT = #now()# WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
	</cfquery>
<cfelse>
	<script type="text/javascript">
		alert('İçerik Bulunamadı!');
		history.back();
	</script>
	<cfabort>
</cfif>
<input type="hidden" name="cntid" id="cntid" value="<cfoutput>#attributes.cntid#</cfoutput>">
<cfset attributes.is_home = 1>






<div class="w3-intranet">
    <div class="container-fluid ">
    <cfinclude template="search.cfm">
    <cfsavecontent variable="kategori"><cf_get_lang_main no='725.Kategoriler'>/<cf_get_lang_main no='727.Bölümler'></cfsavecontent>
    
    <cfinclude template="rule_menu.cfm">
    <div class="w3-dsp-rule">
        <cfinclude template="i_dsp_rule.cfm">
        
    </div>
    </div>
</div>
<table class="dpm" cellpadding="4" cellspacing="4">	
	<tr>
  		<td valign="top" width="200">
        	<cf_box><cfinclude template="search.cfm"></cf_box>
            <cfsavecontent variable="kategori"><cf_get_lang_main no='725.Kategoriler'>/<cf_get_lang_main no='727.Bölümler'></cfsavecontent>
			<cf_box title="#kategori#" closable="1"><cfinclude template="list_cat_chapter_home.cfm"></cf_box>
 		</td>
  		<td valign="top">
  			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
                    <td id="search_menu_new" style="display:none;" valign="top">
                        <cfsavecontent variable="aratitle"><cf_get_lang no ='14.İçerik Yönetimi Detaylı Arama'></cfsavecontent>
                        <cf_box title="#aratitle#" closable="1"><cfinclude template="list_main_news.cfm"></cf_box>
                    </td>
                </tr>
			</table>

    		<cf_box>


                <table>
                    <cfif get_content.is_dsp_header eq 0>
                        <tr>
                            <td class="headbold"><br/> <cfoutput>#get_content.cont_head#</cfoutput> </td>
                        </tr>
                    </cfif>
                    <cfif get_our_company_info.is_content_follow eq 1>
                        <tr>
                            <td colspan="2" style="vertical-align:top;">
                                <table>
                                    <tr>
                                        <td><div style="width:98%" id="content_body_place"></div></td>
                                    </tr>
                                </table>
                                <script type="text/javascript">connectAjax();</script>
                            </td>
                        </tr>
                    <cfelse>
						<!--- edit edildi AFS 16/07/2007 --->
                        <cfif get_content.is_dsp_summary eq 0>
                            <tr style="height:10px;">
                                <td class="txtbold" colspan="2">
                                    <br/>
                                    <cfoutput>#get_content.cont_summary#</cfoutput><br/><br/>
                                </td>
                            </tr>
                        </cfif>
                            <tr>
                                <td colspan="2" style="vertical-align:top;">
                                    <cfoutput>#get_content.cont_body#</cfoutput>
                                </td>
                            </tr>
                        </cfif>
                        <tr>
                            <td colspan="2" ><hr style="height:1px; color:CCCCCC;"></td>
                        </tr>
                        <td>
                            <table style="width:350px;">
                                <tr>
                                    <td><cf_get_lang_main no='583.Bölüm'>:
                                        <cfoutput query="get_chapter_menu"> 
                                            <cfif get_content.chapter_id is chapter_id>#chapter#</cfif> 
                                        </cfoutput>		
                                    </td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang_main no='218.Tip'>: 
                                        <cfoutput query="get_content_property">					
                                          <cfif get_content.content_property_id is content_property_id>#name#</cfif>
                                        </cfoutput>  
                                    </td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang_main no='71.Kayıt'> :  <cfoutput>#get_content.employee_name# #get_content.employee_surname# -  <cfif len(get_content.record_date)>#dateformat(date_add('h',session.ep.time_zone,get_content.record_date),'dd/mm/yy')# #timeformat(date_add('h',session.ep.time_zone,get_content.record_date),timeformat_style)#</cfif></cfoutput></td>
                                </tr>
                                <cfif get_content.recordcount and len(get_content.upd_count) and len(get_content.update_date) and len(get_content.update_member)>
                                    <tr>
                                        <td><cf_get_lang_main no='291.Son Guncelleme'>: 
                                            <cfset tarih=date_add('h',session.ep.time_zone,get_content.update_date)>
                                            <cfset attributes.employee_id = get_content.update_member>
                                            <cfinclude template="../query/get_employee_name.cfm">
                                            <cfoutput>#get_employee_name.employee_name# #get_employee_name.employee_surname# - #dateformat(tarih,'dd/mm/yy')# #timeformat(tarih,timeformat_style)# </cfoutput>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang_main no='291.Güncelleme'>: <cfoutput>#get_content.upd_count#</cfoutput></td>
                                    </tr>
                                </cfif>
                            </table>
                        </td>
                        <td>
                            <table style="width:200px;">
                                <cfoutput>
                                    <tr>
                                        <td>HIT</td>
                                    </tr>
                                    <tr>
                    
                                        <td>Employee &nbsp;:<cfoutput>#get_content.hit_employee#</cfoutput></td>
                                    </tr>
                                    <tr>
                                        <td>Partner &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<cfoutput>#get_content.hit_partner#</cfoutput></td>
                                    </tr>
                                    <tr>
                                         <td>Public &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;:<cfoutput>#get_content.hit#</cfoutput></td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>	  
                </table>

            </cf_box>
			<!--- Orta --->
  		</td>
  		<td align="right" style="text-align:right; vertical-align:top; width:210px;">
  			<cf_box>
              	<table cellpadding="0" cellspacing="0" border="0" style="width:100%; height:30px;">
                	<tr> 
                  		<!-- sil -->
                  		<td align="right" class="color-row" style="text-align:right;">
						  	<cfoutput>
                          	<cfif not listfindnocase(denied_pages,'rule.popup_add_content_comment')><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=rule.popup_add_content_comment&content_id=#attributes.cntid#','large');"><img src="/images/add_not.gif" title="<cf_get_lang no='28.Yorum Ekle'>" border="0"></a></cfif>
                          	<cfif not listfindnocase(denied_pages,'rule.popup_view_content_comment')><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=rule.popup_view_content_comment&content_id=#attributes.cntid#','medium');"><img src="/images/im.gif" border="0" title="<cf_get_lang no='30.Yorum Oku'>"></a></cfif>
                          	<cfif get_module_user(2)>
                          	<a href="#request.self#?fuseaction=content.list_content&event=det&cntid=#attributes.cntid#"><img src="/images/refer.gif" border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                          	</cfif>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_temp_rule&action=print&id=#attributes.cntid#&module=rule','page');return false;"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_temp_rule&action=mail&id=#attributes.cntid#&module=rule','page')"><img src="/images/mail.gif" title="<cf_get_lang_main no='63.Mail Gönder'>" border="0"></a>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_temp_rule&action=pdf&id=#attributes.cntid#&module=rule','page')"><img src="/images/pdf.gif" title="<cf_get_lang_main no='66.PDF Yap'>" border="0"></a>
                          	</cfoutput>
                  		</td>
                  		<!-- sil -->
                	</tr>
            	</table>
            </cf_box>
 			<!-- Ilişkiler -->
			<table border="0" align="center" style="width:98%;">
			  	<cfoutput query="get_related_cont">
			    	<tr> 
		         		<td><img src="/images/arrow_blue.gif"  align="absmiddle"> <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#" class="tableyazi">#cont_head#</a></td>
		        	</tr>
			  	</cfoutput>
          	</table>
			<cfif get_asset.recordcount>
              	<table  border="0" style="width:99%;">

					<cfquery name="GET_ASSETS" dbtype="query">
						SELECT * FROM GET_ASSET WHERE ASSET_FILE_NAME NOT LIKE '%.flv%' AND ASSET_FILE_NAME NOT LIKE '%.swf%'
					</cfquery>

					<cfif get_assets.recordcount>
				 		<tr style="height:22px;">
                  			<td class="txtboldblue"><cf_get_lang_main no ='156.Belgeler'></td>
                		</tr>

						<cfoutput query="get_assets">
							<cfquery name="GET_ASSET_CAT" dbtype="query">
								SELECT ASSETCAT_ID,ASSETCAT_PATH FROM GET_ASSET_CATS WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetcat_id#">
							</cfquery>
							<cfif not len(asset_file_path_name)>
								<cfif assetcat_id gte 0>
									<cfset folder="asset/#get_asset_cat.assetcat_path#">
								<cfelse>
									<cfset folder="#get_asset_cat.assetcat_path#">
								</cfif>
							</cfif>
						  	<tr style="height:20px;">
								<td> <img src="/images/tree_1.gif" align="absmiddle"><a href="javascript:windowopen('#file_web_path##folder#/#asset_file_name#','small');" title="#asset_detail#" class="tableyazi">#asset_name# (#name#)</a></td>
						  	</tr>
						</cfoutput>
					</cfif>
					<cfquery name="GET_VIDEOS" dbtype="query">
						SELECT * FROM GET_ASSET WHERE ASSET_FILE_NAME LIKE '%.flv%' OR ASSET_FILE_NAME LIKE '%.swf%' ORDER BY ASSET_NAME
					</cfquery>
					<cfif get_videos.recordcount>
                        <tr style="height:22px;">
                          	<td class="txtboldblue"><cf_get_lang no ='3.Videolar'></td>
                        </tr>
                        <cfoutput query="get_videos">
                            <cfquery name="GET_ASSET_CAT" dbtype="query">
                                SELECT ASSETCAT_ID,ASSETCAT_PATH FROM GET_ASSET_CATS WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetcat_id#">
                            </cfquery>
                            <cfif not len(asset_file_path_name)>
                                <cfif assetcat_id gte 0>
                                    <cfset folder="asset/#get_asset_cat.assetcat_path#">
                                <cfelse>
                                    <cfset folder="#get_asset_cat.assetcat_path#">
                                </cfif>
                            </cfif>
                          	<tr style="height:20px;">
                            	<td> <img src="/images/tree_1.gif" align="absmiddle"><a href="javascript:windowopen('#file_web_path##folder#/#asset_file_name#','small');" title="#asset_detail#" class="tableyazi">#asset_name# (#name#)</a></td>
                          	</tr>
                        </cfoutput>
                    </cfif>
              	</table>
              	<br/>
            </cfif> 
			<cfinclude template="../query/get_image_cont.cfm">
			<table border="0" cellpadding="2" cellspacing="1" style="width:190px;">
				<cfoutput query="get_image_cont">
                    <tr style="height:20px;"> 
                      	<td><a href="javascript://" onclick="windowopen('#file_web_path#content/#contimage_small#','small');" title="#detail#"><img src="#file_web_path#content/#contimage_small#" border="0" title="<cf_get_lang no='16.Orjinal Resim İçin Tıklayınız...'>" width="190" height="150"></a></td>
                    </tr> 
				</cfoutput> 
            </table>
			<br/>
		</td>
  	</tr>
</table>
<cfif get_our_company_info.is_content_follow eq 1> <!--- bu kontrol icerik detayli takibi yapilabilmesi ve icerik kopyalama engeli icin konuldu 30062007 FS --->
	<cfquery name="ADD_CONTENT_FOLLOWS" datasource="#DSN#">
		INSERT INTO CONTENT_FOLLOWS 
		(
            CONTENT_ID,
            EMPLOYEE_ID,
            READ_DATE,
            READ_IP
		)
		VALUES
		(
            #attributes.cntid#,
            #session.ep.userid#,
            #now()#,
            '#CGI.REMOTE_ADDR#'
		)
	</cfquery>
</cfif>
