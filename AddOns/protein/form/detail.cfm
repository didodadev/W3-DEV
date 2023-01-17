
<div class="row">
	<div class="col col-12 uniqueRow">
	<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
		<div class="col col-12">

			<div class="form-group require">
				<div class="col col-3">&nbsp;</div>
				<div class="col col-6">						
						<label class="form-check-label">
							<input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_main_menu.is_active eq 1>checked</cfif>> Aktif					
						</label>

						<label class="form-check-label">
							<input type="checkbox" name="is_alphabetic" id="is_alphabetic" value="1" <cfif get_main_menu.is_alphabetic eq 1>checked</cfif>> Alfabetik					
						</label>			
					
						<label class="form-check-label">
							<input type="checkbox" name="is_publish" id="is_publish" value="1c" <cfif get_main_menu.is_publish eq 1>checked</cfif>> Bakım / Yayın					
						</label>
				</div>
				<div class="col col-3">&nbsp;</div>
			</div>
			<cfoutput>
		
			 <div class="form-group require">
		        <div class="col col-3"><label class="form-label">#getLang('main',480)#</label></div>
				<div class="col col-6">
					<select name="site_domain" class="form-control" id="site_domain" style="width:230px;">
						<option value="">Domain</option>
						<optgroup label="Partner Portal"></optgroup>
						<cfloop list="#application.systemParam.systemParam().partner_url#" index="i" delimiters=";">
							<option value="#i#" <cfif get_main_menu.site_domain is '#i#'>selected</cfif>>#i#</option>
						</cfloop>
						<optgroup label="Public Portal"></optgroup>
						<cfloop list="#application.systemParam.systemParam().server_url#" index="j" delimiters=";">
							<option value="#j#" <cfif get_main_menu.site_domain is '#j#'>selected</cfif>>#j#</option>
						</cfloop>
						<optgroup label="Kariyer Portal"></optgroup>
						<cfloop list="#application.systemParam.systemParam().career_url#" index="x" delimiters=";">
							<option value="#x#" <cfif get_main_menu.site_domain is '#x#'>selected</cfif>>#x#</option>
						</cfloop>
						<optgroup label="Employee Portal"></optgroup>
						<cfloop list="#application.systemParam.systemParam().employee_url#" index="k" delimiters=";">
							<option value="#k#" <cfif get_main_menu.site_domain is '#k#'>selected</cfif>>#k#</option>
						</cfloop>
						<optgroup label="PDA Portal"></optgroup>
						<cfloop list="#application.systemParam.systemParam().pda_url#" index="l" delimiters=";">
							<option value="#l#" <cfif get_main_menu.site_domain is '#l#'>selected</cfif>>#l#</option>
						</cfloop>
					</select>
				</div>
				<div class="col col-3">
					&nbsp;
				</div>
			</div>
			</cfoutput>
			<div class="form-group require">
				<div class="col col-3"><label class="form-label"><cfoutput>#getLang('settings',2687)#</cfoutput></label></div>	
				<div class="col col-6">
					<cfsavecontent variable="menu_name">Menü Adı Girmelisiniz</cfsavecontent>
					<cfoutput> <input type="text" name="menu_name" class="form-control" value="#get_main_menu.menu_name#" style="width:230px;" required="yes" message="#menu_name#" maxlength="100">	</cfoutput>					
				</div>
			</div>
			<div class="form-group require">
				<div class="col col-3"><label class="form-label"><cfoutput>#getLang('main',217)#</cfoutput></label></div>	
				<div class="col col-6">
					<cfoutput><input type="text" name="description" class="form-control" style="width:230px;" value="#get_main_menu.site_description#"></cfoutput>							
				</div>
			</div>
			<div class="form-group require">
				<div class="col col-3"><label class="form-label col-3 col-sm-12"><cfoutput>#getLang('settings',2811)#</cfoutput></label></div>			
				<div class="col col-6">
					<cfoutput><input type="text" name="site_title" class="form-control" value="#get_main_menu.site_title#" style="width:230px;"></cfoutput>								
				</div>
			</div>
			<div class="form-group require">					
				<div class="col col-3"><label class="form-label"><cfoutput>#getLang('settings',2809)#</cfoutput></label></div>				
				<div class="col col-6">
					<textarea name="site_headers" class="form-control" id="site_headers" style="width:230px;height:80px;"><cfoutput>#get_main_menu.site_headers#</cfoutput></textarea>							
				</div>
			</div>
			<div class="form-group require">
				<div class="col col-3"><label class="form-label"><cfoutput>#getLang('settings',289)#</cfoutput></label></div>					
				<div class="col col-6">
					<textarea name="site_keywords" class="form-control" id="site_keywords" style="width:230px;height:80px;"><cfoutput>#get_main_menu.site_keywords#</cfoutput></textarea>								
				</div>
			</div>
				
			<div class="form-group require">				
				<div class="col col-3"><label class="form-label">SEO Code</label></div>		
				<div class="col col-6">
					<input id="seo_code" name="seo_code" type="text" class="form-control">								
				</div>
			</div>
			
			<div class="form-group require">
				<div class="col col-3"><label class="form-label"><cfoutput>#getLang('settings',2810)#</cfoutput></label></div>
				<div class="col col-6">
					<input type="text" class="form-control" value="<cfoutput>#get_main_menu.APP_KEY#</cfoutput>" name="APP_KEY" id="APP_KEY" maxlength="100" style="width:230px;">								
				</div>
			</div>
			
			<div class="form-group require">
				<div class="col col-12"><label class="form-label"><cf_seperator id="general" header="Genel Ayarlar"></label></div>
			</div>
			
			<div class="column" id="general">
				<div class="form-group require">					
					<div class="col col-3"><label class="form-label"><cfoutput>#getLang('main',1584)#</cfoutput></label></div>					
					<div class="col col-6">
						<select name="language_id" class="form-control" id="language_id" style="width:147px;">
							<cfoutput query="get_languages">
								<option value="#language_short#" <cfif get_main_menu.language_id eq language_short>selected</cfif>>#language_short#</option>
							</cfoutput>
						</select>								
					</div>
				</div>
				<div class="form-group require">
					<div class="col col-3"><label class="form-label"><cfoutput>#getLang('main',794)#</cfoutput> Template</label></div>			
					<div class="col col-6">
						<input id="sablon_file" name="sablon_file" type="text" class="form-control" >								
					</div>
				</div>
				<div class="form-group require">
					<div class="col col-3"><label class="form-label">CSS</label></div>
					<div class="col col-6">
						<input type="text" name="css_file" id="css_file" class="form-control" value="<cfoutput>#get_main_menu.css_file#</cfoutput>" style="width:230px;">					
					</div>
					<cfif len(get_main_menu.css_file)>
					<div class="col col-3">
						<cfoutput> <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_css_property&menu_id=#attributes.menu_id#</cfoutput>','medium');" class="tableyazi"> CSS</a></cfoutput>
						
					</div>
					</cfif>
				</div>
				<div class="form-group require">
					<div class="col col-3"><label class="form-label"><cfoutput>#getLang('settings',2809)#</cfoutput></label></div>
					<div class="col col-6">
						<cfoutput><input type="text" name="main_file" class="form-control" id="main_file" value="#get_main_menu.main_file#" style="width:230px;"></cfoutput>								
					</div>
				</div>
				
				<div class="form-group require">
					<div class="col col-3"><label class="form-label">Footer</label></div>				
					<div class="col col-6">
						<cfoutput><input type="text" name="footer_file" class="form-control" id="footer_file" value="#get_main_menu.footer_file#" style="width:230px;"></cfoutput>								
					</div>					
				</div>
			</div>
			
			
			<div class="form-group require">				
				<label class="form-label"><cf_seperator id="access" header="Access and Authorities"></label>	
			</div>
			<div class="column" id="access">
				<!----<div class="form-group require">
					<div class="col col-3 col-sm-12">							
						<label class="form-check-label"><input type="checkbox" name="site_type" id="site_type" value="4" <cfif get_main_menu.site_type eq 4>checked</cfif>> PDA Portalı</label>
					</div>
				</div>---->
				<div class="form-group require">
					<div class="col col-4 col-sm-12">
						 <label class="form-check-label"><input type="checkbox" name="site_type" id="site_type" value="1" <cfif get_main_menu.site_type eq 1>checked</cfif>> <cfoutput>#getLang('settings',2807)#</cfoutput> </label>                        
					</div>
					<div class="col col-4 col-sm-12">							
						<label class="form-check-label"><input type="checkbox" name="site_type" id="site_type" value="2" <cfif get_main_menu.site_type eq 2>checked</cfif>> <cfoutput>#getLang('settings',2805)#</cfoutput></label>
					</div>
					<div class="col col-4 col-sm-12">
						<label class="form-check-label"><input type="checkbox" name="site_type" id="site_type" value="3" <cfif get_main_menu.site_type eq 3>checked</cfif>> <cfoutput>#getLang('settings',2458)#</cfoutput> </label>                           
					</div>
				</div>
				<p>&nbsp;</p>
				<div class="form-group require">					
					<div id="consumerlar" class="col col-4 sol-sm-12">
						<div class="list-block">
							<div class="list-block-content">
							<h3 class="list-title"><cfoutput>#getLang('main',1609)#</cfoutput></h3>
							<div class="list-block-list" style="height:100px;overflow:auto;">									
								<cfoutput query="GET_CONSUMER_CAT">
									<input type="checkbox" name="consumer_cat_ids" id="consumer_cat_ids" value="#CONSCAT_ID#" <cfif listfind(get_main_menu.CONSUMER_CAT_IDS,CONSCAT_ID)>checked</cfif>> 	#CONSCAT# <br>		  
								</cfoutput>
									<input type="checkbox" name="check_all_consumer_cat" id="check_all_consumer_cat" value="1" onclick="check('consumer_cat');" /> <b><cfoutput>#getLang('main',669)#</cfoutput></b>									
							</div>
							</div>
						</div>
					</div>
					<div id="partnerlar" class="col col-4 col-md-12 col-xs-12 col-sm-12">							
						<div class="list-block">
							<div class="list-block-content">
							<h3 class="list-title"><cfoutput>#getLang('main',1611)#</cfoutput></h3>
							<div class="list-block-list" style="height:100px;overflow:auto;">
								<cfoutput query="get_company_cat">											
									<input type="checkbox" name="company_cat_ids" id="company_cat_ids" value="#companycat_id#" <cfif listfind(get_main_menu.company_cat_ids,companycat_id)>checked</cfif> /> #companycat# <br>						  
								</cfoutput>											
								<input type="checkbox" name="check_all_company_cat" id="check_all_company_cat" value="1" onclick="check('company_cat');" /> <b><cfoutput>#getLang('main',669)#</cfoutput></b>
							</div>
							</div>
						</div>
					</div>
					<div id="employees" class="col col-4 col-md-12 col-xs-12 col-sm-12">							
						<div class="list-block">
							<div class="list-block-content">
							<h3 class="list-title"><cfoutput>#getLang('main',164)#</cfoutput></h3>
							<div class="list-block-list" style="height:100px;overflow:auto;">
								<cfoutput query="GET_POSITION_CATS">											
									<input type="checkbox" name="position_cat_ids" id="position_cat_ids" value="#POSITION_CAT_ID#" <cfif listfind(get_main_menu.position_cat_ids,POSITION_CAT_ID)>checked</cfif>> #POSITION_CAT#<br>						  
								</cfoutput>											
								<input type="checkbox" name="check_all_company_cat" id="check_all_company_cat" value="1" onclick="check('company_cat');" /> <b><cfoutput>#getLang('main',669)#</cfoutput></b>
							</div>
							</div>
						</div>
					</div>
				</div>
				<p>&nbsp;</p>
				<div class="form-group require">
					<div class="col col-4 col-md-12 col-xs-12 col-sm-12">
						<div class="list-block">
							<div class="list-block-content">
								<h3 class="list-title"><cfoutput>#getLang('settings',1955)#</cfoutput> <cfoutput>#getLang('settings',2463)#</cfoutput></h3>						
							</div>
						</div>						
						<cfoutput><input type="text" name="login_partner_file" class="form-control" id="login_file" value="#get_main_menu.login_file#"></cfoutput>											
					</div>
					<div class="col col-4 col-md-12 col-xs-12 col-sm-12">
						<div class="list-block">
							<div class="list-block-content">
								<h3 class="list-title"><cfoutput>#getLang('settings',1953)#</cfoutput> <cfoutput>#getLang('settings',2463)#</cfoutput></h3>						
							</div>
						</div>						
						<cfoutput><input type="text" name="login_file" class="form-control" id="login_file" value="#get_main_menu.login_file#"></cfoutput>
					</div>	
					<div class="col col-4 col-md-12 col-xs-12 col-sm-12">
						<div class="list-block">
							<div class="list-block-content">
								<h3 class="list-title"><cfoutput>#getLang('main',164)#</cfoutput> <cfoutput>#getLang('settings',2463)#</cfoutput></h3>						
							</div>
						</div>						
						<cfoutput><input type="text" name="login_employee_file" class="form-control" id="login_file" value="#get_main_menu.login_file#"></cfoutput>
					</div>	
				</div>
				<p>&nbsp;</p>
				<div class="form-group require">
					<div class="col col-6 col-md-12 col-xs-12 col-sm-12">
						<cfoutput>
						Kayit:#get_emp_info(get_main_menu.record_emp,0,0)# - #dateformat(get_main_menu.record_date,'dd/mm/yyyy')#
						<cfif len(get_main_menu.update_emp)><br />Son Güncelleme:#get_emp_info(get_main_menu.update_emp,0,0)# - #dateformat(get_main_menu.update_date,'dd/mm/yyyy')#</cfif>
						</cfoutput>
						
					</div>
					<div class="col col-6 col-md-12 col-xs-12 col-sm-12">
						<cfif session.ep.admin eq 1>
							<cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=protein.emptypopup_del_main_menu&menu_id=#attributes.menu_id#'>
						<cfelse>
							<cf_workcube_buttons is_upd='1' is_delete='0'>
						</cfif>
					</div>					
				</div>
			</div>						
		</div>
	</div>
	</div>
</div>
<p>&nbsp;</p>
