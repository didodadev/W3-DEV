<cfquery name="CAMPAIGN" datasource="#dsn3#">
	SELECT
		*
	FROM
		CAMPAIGNS
	WHERE
		CAMP_ID = #attributes.campaign_id#
</cfquery>	

<cfoutput>
  <table cellspacing="0" cellpadding="0" width="100%" height="100%">
    <tr class="color-border">
      <td valign="top">
        <table cellpadding="2" cellspacing="1" width="100%" height="100%">
          <tr height="35" clasS="color-list">
            <td>
              <table width="100%">
                <tr>
                  <td class="headbold"><cf_get_lang dictionary_id='57446.Kampanya'> : #CAMPAIGN.CAMP_HEAD#</td>
                  <td  style="text-align:right;"> <a href="javascript://" onclick="self.close();"><img src="/images/close.gif" title="<cf_get_lang dictionary_id='57553.Kapat'>" name="A" border="0" align="absmiddle"></a> </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr class="color-row">
            <td valign="top">
         			<br/>
					<table>
                            <tr> 
                              <td class="txtbold"><cf_get_lang dictionary_id='33079.Kampanya No'></td>
                              <td width="150">: #campaign.camp_no#</td>
                              <td width="50" class="txtbold"><cf_get_lang dictionary_id='57756.Durum'></td>
                              <td>:
							  <cfif campaign.camp_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif>
							  -
							  <!--- BK kapatti 6 aya silinsin 20090112
							<cfquery name="GET_CAMPAIGN_STAGES" datasource="#dsn#">
								SELECT
									*
								FROM
									SETUP_CAMP_STAGE
								WHERE 
									STAGE_ID = #CAMPAIGN.CAMP_STAGE_ID# 
							</cfquery>
							#GET_CAMPAIGN_STAGES.STAGE_NAME# --->							  
							  </td>
                            </tr>
                            <tr> 
                              <td class="txtbold"><cf_get_lang dictionary_id='57486.kategori'></td>
                              <td colspan="3">:
								 <cfquery name="GET_CAT" datasource="#DSN3#">
								   SELECT
		                              *
	                               FROM
		                              CAMPAIGN_CATS
								   WHERE
								     CAMP_CAT_ID = #campaign.camp_cat_id#
								 </cfquery>
								 #GET_CAT.CAMP_CAT_NAME#
							  </td>
                            </tr>
                            <tr>
                              <td class="txtbold"><cf_get_lang dictionary_id='29472.Yöntem'></td>
                              <td colspan="3">
							  :<cfquery name="COMMETHODS" datasource="#dsn#">
									SELECT 
										* 
									FROM 
										SETUP_COMMETHOD
								</cfquery>			

							  <cfloop query="commethods"> 
                                  <cfif listfindnocase(valuelist(campaign.commethods),commethod_id)>#commethod#, </cfif>                               
							  </cfloop>
							  </td>
                            </tr>
							<tr>
							  <td class="txtbold"><cf_get_lang dictionary_id='57742.tarih'></td>
							  <td colspan="3">: #dateformat(campaign.camp_startdate,dateformat_style)# - #dateformat(campaign.camp_finishdate,dateformat_style)#</td>
							</tr>
							<tr>
							  <td class="txtbold">
							 <!---  <cf_get_lang no='410.Lider'> --->
							  </td>
							  <td>:
							    <!--- <cfif len(campaign.leader_position_code)>
                                  #get_emp_info(campaign.leader_position_code,1,1)#
							    </cfif> --->
							  </td>
							  <td class="txtbold"><!--- <cf_get_lang_main no='88.Onay'> ---></td>
							  <td>: 
							 <!---  <cfif len(campaign.validator_position_code)>
                                    #get_emp_info(campaign.validator_position_code,1,1)#
								</cfif> --->
							  </td>
							</tr>                         
                            <tr> 
                              <td class="txtbold"><cf_get_lang dictionary_id='57483.Kayıt'></td>
							  <td colspan="3"> : 
                                #get_emp_info(campaign.record_emp,0,0)# - #dateformat(campaign.record_date,dateformat_style)#</td>
                            </tr>
							<tr>
							  <td class="txtbold"><cf_get_lang dictionary_id='33080.İlgili Proje'></td>
							  <td colspan="3">: 
							  <cfif len(campaign.project_id)>
							  <cfset attributes.project_id = campaign.project_id>
							  <cfinclude template="../query/get_project_head.cfm">
							  <a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=project.projects&event=det&id=#attributes.project_id#';window.close();" class="tableyazi">#get_project_head.project_head#</a>
							  </cfif>
							  </td>
					  </tr>
							<tr> 
                              <td class="txtbold"><cf_get_lang dictionary_id='33081.Amaç'></td>
                              <td colspan="3">: #campaign.camp_objective#</td>
						    </tr>
						  </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfoutput> 
