<cftry>
	<cfset attributes.emp_id = decrypt(attributes.emp_id,"WORKCUBE","BLOWFISH","Hex")>
	<cfcatch type="any">
		<script language="javascript">
			alert('Yetkiniz Yok!');
			history.back(-1);
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<cfinclude template="../query/get_emp_det.cfm">
<cfif len(detail_emp.imcat_id)>
	<cfset attributes.imcat_id = detail_emp.imcat_id>
	<cfinclude template="../query/get_imcat.cfm">
</cfif>
<cfif len(get_emp_pos.title_id)>
	<cfset attributes.title_id = get_emp_pos.title_id>
	<cfinclude template="../query/get_title.cfm">
</cfif>
<cfif len(get_emp_pos.department_id)>
	<cfset attributes.department_id = get_emp_pos.department_id>
	<cfinclude template="../query/get_location.cfm">
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_location.company_id#">
	</cfquery>
<cfelse>
	<cfset attributes.department_id = 0>
</cfif>
<cfif len(get_emp_pos.position_code)>
<cfset attributes.pos_id = get_emp_pos.position_code>
<cfquery name="GET_CHIEFS" datasource="#DSN#">
	SELECT CHIEF1_CODE,CHIEF2_CODE FROM EMPLOYEE_POSITIONS_STANDBY WHERE EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_id#">
</cfquery>
</cfif>
<cfquery name="GET_EMP_ALL_POS" datasource="#DSN#">
	SELECT 
		POSITION_CODE,
		POSITION_NAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
</cfquery>

<table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%;">
  	<tr class="color-border"> 
		<td>
	 		<table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:100%;">
       			<tr class="color-list" style="height:35px; vertical-align:middle;"> 
					<td>
						<table align="center" style="width:100%;">
          					<tr> 
         						<td class="headbold">&nbsp;<cfoutput>#detail_emp.employee_name# #detail_emp.employee_surname#</cfoutput></td>
								<td  style="text-align:right;">
			    					<cfif isdefined("session.ep.userid")>
			    						<cfform name="get_events" method="post" action="#request.self#?fuseaction=objects.popup_emp_events">
			    							<table>
                								<input type="Hidden" name="emp_id" id="emp_id" value="<cfoutput>#emp_id#</cfoutput>">
                								<input type="Hidden" name="pos_id" id="pos_id" value="<cfoutput>#get_emp_pos.position_code#</cfoutput>">
                								<cfif not isdefined("attributes.startdate")>
                  									<cfset attributes.startdate = "">
                								</cfif>
                								<cfif not isdefined("attributes.finishdate")>
                  									<cfset attributes.finishdate = "">
                								</cfif>
                								<tr style="height:22px;">
				 									<td><cf_online id="#attributes.emp_id#" zone="ep"></td>
                  									<td  style="text-align:right;"> 
				  										<cfsavecontent variable="message"><cf_get_lang no ='326.Başlangıç Tarihi Giriniz'> !</cfsavecontent>
				  										<cfinput type="text" name="startdate" id="startdate" style="width:65px;" required="Yes" message="#message#" validate="eurodate" value="#attributes.startdate#"> 
                    									<cf_wrk_date_image date_field="startdate"> 
                    									 -
					 									<cfsavecontent variable="message2"><cf_get_lang no ='327.Bitiş Tarihi Girinizmelisiniz'> !</cfsavecontent>
                    									<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" required="Yes" message="#message2#" validate="eurodate" value="#attributes.finishdate#"> 
														<cf_wrk_date_image date_field="finishdate"> 
                    									<cf_wrk_search_button>
                  									</td>
                								</tr>
			 	 							</table>
			  							</cfform>
			  						</cfif>
			  					</td>
			  				</tr>
            			</table>
					</td>
        		</tr>
        		<tr class="color-row" style="vertical-align:top;"> 
          			<td> 
		  				<table style="width:99%;">
              				<cfoutput> 
                    			<tr style="height:22px;">
									<td class="txtbold" style="width:100px;"><cf_get_lang_main no='162.Şirket'></td>
								  	<td colspan="3"><cfif attributes.department_id neq 0>#get_company.company_name#</cfif></td>
                      				<td rowspan="14"  style="text-align:right; vertical-align:top;">
				       					<cfif len(detail_emp.photo)>
					    					<cf_get_server_file output_file="hr/#detail_emp.photo#" output_server="#detail_emp.photo_server_id#" output_type="0"  image_width="105" image_height="136" image_link="1" alt="#getLang('main',164)#" title="#getLang('main',164)#">
					    				</cfif>
				      				</td>
                    			</tr>
                    			<tr style="height:22px;">
									<td class="txtbold"><cf_get_lang_main no='75.No'></td>
									<td>#detail_emp.member_code#</td>
									<td class="txtbold"><cf_get_lang_main no='1584.Dil'></td>
									<td>#get_languages.language_set#</td>
                  				</tr>
                    			<tr style="height:22px;">
							  		<td class="txtbold"><cf_get_lang_main no='219.Ad'></td>
									<td style="width:150px;">#detail_emp.employee_name#</td>
							  		<td class="txtbold" style="width:75px;"><cf_get_lang_main no='16.e-mail'></td>
							  		<td style="width:175px;"><a href="mailto:#detail_emp.employee_email#" class="tableyazi">#detail_emp.employee_email#</a></td>
			    				</tr>
                    			<tr style="height:22px;">
							  		<td class="txtbold" style="width:75px;"><cf_get_lang_main no='1314.Soyad'></td>
							  		<td>#detail_emp.employee_surname#</td>
							 		<td class="txtbold">Ins Mesaj</td>
							  		<td>
							  			<cfif len(detail_emp.imcat_id)>#get_imcat.imcat#</cfif>/#detail_emp.im#
							  		</td>
                				</tr>
                    			<tr style="height:22px;">
                  					<td class="txtbold"><cf_get_lang_main no='159.Ünvan'></td>
                  					<td>
										<cfif len(get_emp_pos.title_id)>
											#get_title.title#
										</cfif>
				 	 				</td>
                  					<td class="txtbold"><cf_get_lang_main no='87.Telefon'></td>
                  					<td>#detail_emp.direct_telcode#-#detail_emp.direct_tel#</td>
                				</tr>
                    			<tr style="height:22px;"> 
						  			<td class="txtbold"><cf_get_lang_main no='1085.Pozisyon'></td>
						  			<td>
				  						<cfquery name="POSITION" datasource="#DSN#">
					  						SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
										</cfquery>	
										#position.position_name#  
				  					</td>
                  					<td  class="txtbold"><cf_get_lang no='231.Dahili'></td>
                  					<td>#detail_emp.extension#</td>
                   				</tr>
                    			<tr style="height:22px;">
							  		<td class="txtbold"><cf_get_lang_main no='580.Bölge'></td>
							  		<td><cfif attributes.department_id neq 0>#get_location.zone_name#</cfif></td>
							 		<td class="txtbold"><cf_get_lang_main no='1070.Mobil Tel'>.</td>
							  		<td>
										#detail_emp.mobilcode# / #detail_emp.mobiltel#
				 						<cfif isdefined("session.ep.userid")>
				  							<cfif (len(detail_emp.mobilcode) is 3) and (len(detail_emp.mobiltel) is 7) and  (session.ep.our_company_info.sms eq 1)>
													<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=employee&member_id=#detail_emp.EMPLOYEE_ID#&sms_action=#attributes.fuseaction#','small');">
					  								<img src="/images/mobil.gif" title="<cf_get_lang no='526.Sms Gönder'>" border="0" align="absmiddle">
					  							</a>
				  							</cfif>
				  						</cfif>
					  				</td>
                                    <td class="txtbold" >&nbsp;</td>
                  					<td></td>
                				</tr>
                    			<tr style="height:22px;">
                 					<td class="txtbold"><cf_get_lang_main no='41.Şube'></td>
                  					<td><cfif attributes.department_id neq 0>#get_location.branch_name#</cfif></td>
                  					<td class="txtbold" >&nbsp;</td>
                  					<td></td>
			    				</tr>
                    			<tr style="height:22px;">
                  					<td class="txtbold"><cf_get_lang_main no='160.Departman'></td>
                  					<td><cfif attributes.department_id neq 0>#get_location.department_head#</cfif></td>
                  					<td class="txtbold">&nbsp;</td>
                  					<td>&nbsp;</td>
                				</tr>
								<tr>
									<td class="txtbold"><cf_get_lang no ='1342.Pozisyonlar'></td>
									<td colspan="3"><cfloop query="get_emp_all_pos">#position_name#, </cfloop></td>
								</tr>
								<cfif attributes.department_id neq 0>	
									<cfinclude template="workgroup_emp.cfm">
								</cfif>
								<cfif len(get_emp_pos.position_code)>
									<cfif len(get_chiefs.chief1_code)>
										<cfquery name="GET_CHIEF1_NAME" datasource="#DSN#">
											SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_chiefs.chief1_code#">
										</cfquery>
										<tr style="height:22px;">
											<td class="txtbold"><cf_get_lang_main no='1869.Amir'></td>
										  	<td colspan="3">#get_chief1_name.position_name#(#get_chief1_name.employee_name# #get_chief1_name.employee_surname#)</td>
										</tr>
									</cfif>
									<cfif len(get_chiefs.chief2_code)>
										<cfquery name="GET_CHIEF2_NAME" datasource="#DSN#">
											SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_chiefs.chief2_code#">
										</cfquery>
										<tr style="height:22px;">
                  							<td class="txtbold"><cf_get_lang no='223.Yedek'></td>
                  							<td colspan="3">#get_chief2_name.position_name#(#get_chief2_name.employee_name# #get_chief2_name.employee_surname#) </td>
                						</tr>				
									</cfif>
								</cfif>
              				</cfoutput>
             			</table>
          			</td>
        		</tr>
      		</table>
		</td>
	</tr>
</table>
