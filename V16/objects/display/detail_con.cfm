<!--- <cfdump var="#attributes#" abort> --->
<cfif isdefined('session.ep.userid') and session.ep.member_view_control>
	<cfquery name="view_control" datasource="#DSN#">
		SELECT
			IS_MASTER
		FROM
			WORKGROUP_EMP_PAR
		WHERE
			CONSUMER_ID =<cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.con_id#"> AND
			OUR_COMPANY_ID = #session.ep.company_id# AND
			POSITION_CODE = #session.ep.position_code#
	</cfquery>
	<cfif not view_control.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='33782.Bu Üyeyi Görmek İçin Yetkiniz Yok'>!");
			window.close();
		</script>
	</cfif>
</cfif>
<cfinclude template="../query/get_con_det.cfm">
<cfif len(detail_con.imcat_id)>
	<cfset attributes.imcat_id = detail_con.imcat_id>
    <cfinclude template="../query/get_imcat.cfm">
</cfif>
<cfset attributes.consumer_id = attributes.con_id>

<cfinclude template="../../member/query/get_consumer.cfm">
<cfsavecontent variable="right_images_">
	<cfoutput>
		<li><a href="<cfoutput>#request.self#?fuseaction=member.consumer_list&event=det&cid=#attributes.con_id#</cfoutput>" target="_blank" class="font-red-pink"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a> </li>
		<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#con_id#<cfif isdefined("attributes.is_store_module")>&is_store_module=1</cfif>','page')" class="font-red-pink"><i class="fa fa-table" title="<cf_get_lang dictionary_id='57809.Hesap Ekstresi'>"></i></a></li>
		<cfif isdefined('session.ep.userid') and get_module_user(11) and session.ep.our_company_info.subscription_contract eq 1>
			<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_list_subscription_contract&cid=#url.con_id#&member_name=#detail_con.consumer_name#&nbsp;#detail_con.consumer_surname#','list')" class="font-red-pink"><i class="fa fa-handshake-o" title="<cf_get_lang dictionary_id='33253.Sistemler'>"></i></a></li>
		</cfif>
		<cfif isdefined('session.ep.userid') and get_module_user(3) and not listfindnocase(denied_pages,'report.bsc_company') and fusebox.use_period>
			<li><a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=consumer&consumer_id=#url.con_id#&member_name=#detail_con.consumer_name# #detail_con.consumer_surname#&finance=1','wide');" class="font-red-pink"><i class="fa fa-dashboard" title="<cf_get_lang dictionary_id ='33781.BSC Raporu'>"></i></a></li>
		</cfif>
		<li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=member.popup_member_history&member_type=consumer&member_id=#url.con_id#','medium','popup_member_history');" class="font-red-pink"><i class="fa fa-history" title="<cf_get_lang dictionary_id='57473.Tarihçe'>" border="0"></i></a></li>
		<!--- <a href="javascript://" onclick="self.close();"><img src="/images/close.gif" title="<cf_get_lang dictionary_id='57553.Kapat'>"></a>  --->
	</cfoutput>
</cfsavecontent>
<!---  --->
	<cf_box right_images="#right_images_#" scroll="1" collapsable="1" resize="1" title='#detail_con.consumer_name# #detail_con.consumer_surname#' popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_elements>
			<cf_tab divID="sayfa_1,sayfa_2,sayfa_3" defaultOpen="sayfa_1" divLang="#getLang('','Adres',58723)#-#getLang('','İletişim',58143)#;#getLang('','Notlar',57422)#;#getLang('','Finansal Özet',58085)#" afterFunction="pageload(1,unique_sayfa_1)|pageload(2,unique_sayfa_2)|pageload(3,unique_sayfa_3)">
				<cfoutput>
						<div id="unique_sayfa_1" class="ui-info-text uniqueBox">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<cf_flat_list>
									<tr>
										
										<td  class="txtbold"><cf_get_lang dictionary_id='57487.No'></td>
										<td >#detail_con.member_code#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='57631.Ad'></td>
										<td>#detail_con.consumer_name#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='58726.Soyad'></td>
											<td>#detail_con.consumer_surname#</td>
									</tr>
									<tr>
										
										<td class="txtbold"><cf_get_lang dictionary_id='58025.TC Kimlik No'></td>
											<td>#get_consumer.tc_identy_no#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='57571.Ünvan'></td>
											<td>#detail_con.title#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='57574.Şirket'></td>
											<td>#detail_con.company#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='57908.Temsilci'></td>
											<td>#get_emp_info(detail_con.position_code,1,0)#</td>
									</tr>
									<tr>
										<td class="txtbold" nowrap="nowrap"><cf_get_lang dictionary_id='58636.Referans Üye'></td>
											<td><cfif len(detail_con.ref_pos_code)>#get_cons_info(detail_con.ref_pos_code,0,0)#</cfif></td>
									</tr>

									<tr>
										<td class="txtbold" nowrap="nowrap"><cf_get_lang dictionary_id='32622.Ev Adresi'></td>
											<td colspan="3" >
												#detail_con.homeaddress# #detail_con.homepostcode# #detail_con.homesemt#
												<cfif len(detail_con.home_county_id)>
													<cfquery name="GET_COUNTY" datasource="#DSN#">
														SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_con.home_county_id#">
													</cfquery>		
													#get_county.county_name#
												</cfif>
												<cfif len(detail_con.home_city_id)>
													<cfquery name="GET_CITY" datasource="#DSN#">
														SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_con.home_city_id#">
													</cfquery>
													&nbsp;#get_city.city_name#  
												</cfif>  
												<cfif len(detail_con.home_country_id)>
													<cfquery name="GET_COUNTRY" datasource="#DSN#">
														SELECT COUNTRY_ID, COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_con.home_country_id#">
													</cfquery>
													&nbsp;#get_country.country_name#  
												</cfif>  
											</td>
									</tr>
									<tr>
										<td class="txtbold" nowrap="nowrap"><cf_get_lang dictionary_id='32600.İş Adresi'></td>
											<td colspan="3" >
												#detail_con.workaddress# #detail_con.workpostcode# #detail_con.worksemt#
												<cfif len(detail_con.work_county_id)>
													<cfquery name="GET_COUNTY" datasource="#DSN#">
														SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_con.work_county_id#">
													</cfquery>		
													#get_county.county_name#
												</cfif>
												<cfif len(detail_con.work_city_id)>
													<cfquery name="GET_CITY" datasource="#DSN#">
														SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_con.work_city_id#">
													</cfquery>
													&nbsp;#get_city.city_name#  
												</cfif>  
												<cfif len(detail_con.work_country_id)>
													<cfquery name="GET_COUNTRY" datasource="#DSN#">
														SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_con.work_country_id#">
													</cfquery>
													&nbsp;#get_country.country_name#  
												</cfif>  
											</td>
									</tr>
								</cf_flat_list>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<cf_flat_list>
									<tr>
										<td  class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></td>
											<td >#get_consumer_cat.conscat#</td>
									</tr>
									<tr>
										<cfif len(detail_con.picture)>
										<td valign="top" style="text-align:right;">
												<cf_get_server_file output_file="member/consumer/#detail_con.picture#" output_server="#detail_con.picture_server_id#" image_width="105" imageheight="136" output_type="0">
												</td>
										</cfif>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='57428.e-mail'></td>
											<td><a href="mailto:#detail_con.consumer_email#" >#detail_con.consumer_email#</a></td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='32486.Ins Mesaj'></td>
											<td><cfif len(detail_con.imcat_id)>#get_imcat.imcat#</cfif>- #detail_con.im#</td>
									</tr>
									<tr>
										<td class="txtbold" ><cf_get_lang dictionary_id='57499.Telefon'></td>
											<td><cf_santral tel="#detail_con.consumer_worktelcode##detail_con.consumer_worktel#"></cf_santral></td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='57488.Fax'></td>
											<td>#detail_con.consumer_fax#</td>
									</tr>
									<tr>
										<td class="txtbold" ><cf_get_lang dictionary_id='58482.Mobil Tel'></td>
											<td>
												<cf_santral mobile="#detail_con.mobil_code##detail_con.mobiltel#"></cf_santral>
												<cfif isdefined('session.ep.userid') and (len(detail_con.mobil_code) is 3) and (len(detail_con.mobiltel) is 7) and (session.ep.our_company_info.sms eq 1)>
													&nbsp;<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=consumer&member_id=#DETAIL_CON.CONSUMER_ID#&sms_action=#fuseaction#','small');"><img src="/images/mobil.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id ='58590.SMS Gönder'>"></a>
												</cfif>
											</td>
									</tr>
						
								</cf_flat_list>
							</div>
						</div>

						<div id="unique_sayfa_2" class="ui-info-text uniqueBox">
							<cfoutput>
								<!--- Notlar --->
								<cfsavecontent variable="title_"><cf_get_lang dictionary_id="57422.Notlar"></cfsavecontent>
								<cf_get_workcube_note action_section='CONSUMER_ID' action_id='#attributes.con_id#' style="1">
							</cfoutput>
						</div>

						
						<div id="unique_sayfa_3" class="ui-info-text uniqueBox">
							
						
										<cfoutput>
											<cfif fusebox.use_period>		
											
													<cfset attributes.company = detail_con.consumer_name & ' ' & detail_con.consumer_surname>
													<cfset attributes.consumer_id = detail_con.consumer_id>
													<cfset member_type = 'consumer'>
												<cfinclude template="../../objects/display/dsp_extre_summary_popup.cfm">
												
											</cfif>		
										</cfoutput>
									
						</div>
					
				</cfoutput>
			</cf_tab>
		</cf_box_elements>

					



	</cf_box>


