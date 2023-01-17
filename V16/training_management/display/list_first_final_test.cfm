<cfparam name="attributes.sirala_1" default="">
<cfparam name="attributes.sirala_2" default="">
<cfparam name="attributes.sirala_3" default="">
<cfif not isDefined("attributes.IC_DIS")>
 <cfset attributes.IC_DIS = 0>
</cfif>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.online")>
	<cfset url_str = "#url_str#&online=#attributes.online#">
<cfelse>
	<cfset attributes.online = "">
</cfif>
<cfif isdefined("attributes.CLASS_ID")>
	<cfset url_str = "#url_str#&CLASS_ID=#attributes.CLASS_ID#">
<cfelse>
	<cfset attributes.CLASS_ID = "">
</cfif>
<cfif isdefined("attributes.date1")>
	<cfset url_str = "#url_str#&date1=#attributes.date1#">					  
<cfelse>
	<cfset attributes.date1 = "">
</cfif>
<cfif isDefined("attributes.IC_DIS")>
   <cfset url_str = "#url_str#&IC_DIS=#attributes.IC_DIS#">
</cfif>
<cfinclude template="../query/get_class_finished.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_class_finished.RECORDCOUNT#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td valign="top"> 
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
        <tr> 
          <td class="headbold"><cf_get_lang no='309.İlk Son Test Sonuçları'></td>
           <!-- sil -->
		  <td valign="bottom" style="text-align:right;"> 
            <table>
              <cfform name="form1" method="post" action="">
                <tr> 
                  <td class="label"><cf_get_lang_main no='48.Filtre'>:</td>
                  <td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
				  <td>
					  <cfset attributes.date1=dateformat(attributes.date1,dateformat_style)>
					  <cfinput name="date1" type="text" value="#attributes.date1#" style="width:80px;" validate="#validate_style#" message="Tarih Girmelisiniz !">
					  <cf_wrk_date_image date_field="date1">
					  <cf_get_lang no='212.tarihinden itibaren'>
				  </td>
				  <!---  sakin silinmesin
				  <td>
				  <select name="online">
					<option value=""  <cfif attributes.online is "">selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
					<option value="1" <cfif attributes.online is "1">selected</cfif>><cf_get_lang_main no='2218.Online'></option>
					<option value="0" <cfif attributes.online is "0">selected</cfif>><cf_get_lang no='159.Online Değil'></option>
				  </select>
				  </td>--->
				 <td>
				   <select name="IC_DIS" id="IC_DIS">
						 <option value="0" <cfif attributes.IC_DIS EQ 0>SELECTED</cfif>><cf_get_lang_main no='296.Tümü'></option>
						 <option value="1" <cfif attributes.IC_DIS EQ 1>SELECTED</cfif>><cf_get_lang_main no='1149.İç'></option>
						 <option value="2" <cfif attributes.IC_DIS EQ 2>SELECTED</cfif>><cf_get_lang_main no='1150.Dış'></option>
				   </select>
				 </td>
				 <td>
				 		<select name="sirala_1" id="sirala_1" style="width=56px;">
							<option value=""><cf_get_lang_main no='1512.Sırala'></option>						
							<option <cfif attributes.sirala_1 eq "ZONE_NAME">selected</cfif> value="ZONE_NAME"><cf_get_lang_main no='580.Bölge'></option>
							<option <cfif attributes.sirala_1 eq "BRANCH_NAME">selected</cfif> value="BRANCH_NAME"><cf_get_lang_main no='41.Şube'></option>
							<option <cfif attributes.sirala_1 eq "DEPARTMENT_HEAD">selected</cfif> value="DEPARTMENT_HEAD"><cf_get_lang_main no='160.Departman'></option>
							<option <cfif attributes.sirala_1 eq "ATTENDER_NAME">selected</cfif> value="ATTENDER_NAME"><cf_get_lang_main no='1983.Katılımcı'></option>							
							<option <cfif attributes.sirala_1 eq "TRAINER_NAME">selected</cfif> value="TRAINER_NAME"><cf_get_lang no='23.Eğitimci'></option>
							<option <cfif attributes.sirala_1 eq "CLASS_NAME">selected</cfif> value="CLASS_NAME"><cf_get_lang_main no='7.Eğitim'></option>																					
						</select>
						<select name="sirala_2" id="sirala_2"  style="width=56px;">
							<option value=""  ><cf_get_lang_main no='1512.Sırala'></option>
							<option <cfif attributes.sirala_2 eq "ZONE_NAME">selected</cfif> value="ZONE_NAME"><cf_get_lang_main no='580.Bölge'></option>
							<option <cfif attributes.sirala_2 eq "BRANCH_NAME">selected</cfif> value="BRANCH_NAME"><cf_get_lang_main no='41.Şube'></option>
							<option <cfif attributes.sirala_2 eq "DEPARTMENT_HEAD">selected</cfif> value="DEPARTMENT_HEAD"><cf_get_lang_main no='160.Departman'></option>	
							<option <cfif attributes.sirala_2 eq "ATTENDER_NAME">selected</cfif> value="ATTENDER_NAME"><cf_get_lang_main no='1983.Katılımcı'></option>							
							<option <cfif attributes.sirala_2 eq "TRAINER_NAME">selected</cfif> value="TRAINER_NAME"><cf_get_lang no='23.Eğitimci'></option>				
							<option <cfif attributes.sirala_2 eq "CLASS_NAME">selected</cfif> value="CLASS_NAME"><cf_get_lang_main no='7.Eğitim'></option>																																	
						</select>
						<select name="sirala_3" id="sirala_3" style="width=56px;">
							<option value=""><cf_get_lang_main no='1512.Sırala'></option>
							<option <cfif attributes.sirala_3 eq "ZONE_NAME">selected</cfif> value="ZONE_NAME"><cf_get_lang_main no='580.Bölge'></option>
							<option <cfif attributes.sirala_3 eq "BRANCH_NAME">selected</cfif> value="BRANCH_NAME"><cf_get_lang_main no='41.Şube'></option>
							<option <cfif attributes.sirala_3 eq "DEPARTMENT_HEAD">selected</cfif> value="DEPARTMENT_HEAD"><cf_get_lang_main no='160.Departman'></option>
							<option <cfif attributes.sirala_3 eq "ATTENDER_NAME">selected</cfif> value="ATTENDER_NAME"><cf_get_lang_main no='1983.Katılımcı'></option>							
							<option <cfif attributes.sirala_3 eq "TRAINER_NAME">selected</cfif> value="TRAINER_NAME"><cf_get_lang no='23.Eğitimci'></option>										
							<option <cfif attributes.sirala_3 eq "CLASS_NAME">selected</cfif> value="CLASS_NAME"><cf_get_lang_main no='7.Eğitim'></option>																												
						</select>
				</td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
                  <td><cf_wrk_search_button></td>
			  	<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
                </tr>
              </cfform>
            </table>
          </td>
		  <!-- sil -->
        </tr>
      </table>
      <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
        <tr class="color-border"> 
          <td> 
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header" height="22"> 
				<td class="form-title" width="130"><cf_get_lang_main no='1983.Katılımcı'></td>
				<cfsavecontent variable="message"><cf_get_lang no='173.Şirket/Şube/Departman'></cfsavecontent>
				<td class="form-title" width="40"><cfoutput>#ListGetAt(message,1,'/')#</cfoutput></td>
				<td class="form-title" width="40"><cfoutput>#ListGetAt(message,2,'/')#</cfoutput></td>
				<td class="form-title" width="40"><cfoutput>#ListGetAt(message,3,'/')#</cfoutput></td>
                <td class="form-title"><cf_get_lang_main no='7.Eğitim'></td>
                <td class="form-title" width="100"><cf_get_lang_main no='330.Tarih'></td>
				<td class="form-title" width="50"><cf_get_lang no='112.G/S'></td>
				<td class="form-title" width="130"><cf_get_lang no='23.Eğitimci'></td>
				<td class="form-title" width="80"><cf_get_lang no='381.İlk Son Test'></td>
              </tr>
	   
	    <cfif get_class_finished.RECORDCOUNT>
		 <cfoutput QUERY="get_class_finished" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#ATTENDER_ID#','project');" class="tableyazi">#ATTENDER_NAME#</a></td>
			<td><cfif ZONE_NAME neq "Z+++">#ZONE_NAME#</cfif></td>
			<td><cfif ZONE_NAME neq "Z+++">#branch_name#</cfif></td>
			<td><cfif ZONE_NAME neq "Z+++">#department_head#</cfif></td>
			<td>
			  <cfif CLASS_ID neq 0>
			     <a href="#request.self#?fuseaction=training_management.form_upd_class&class_id=#class_id#" class="tableyazi">#class_name#</a>
			  <cfelseif EX_CLASS_ID neq 0>
			     <a href="#request.self#?fuseaction=training_management.form_upd_ex_class&ex_class_id=#ex_class_id#" class="tableyazi">#class_name#</a>
			  </cfif>
			</td> 
			<td>
			  <cfif isDefined("START_DATE") and isDefined("FINISH_DATE")  and len(START_DATE) and len(FINISH_DATE)>
			    <cfif dateformat(start_date,dateformat_style) eq dateformat(now(),dateformat_style) or dateformat(finish_date,dateformat_style) eq dateformat(now(),dateformat_style) ><font  color="##FF0000"> </cfif>
					#dateformat(date_add("h",SESSION.EP.TIME_ZONE,start_date),dateformat_style)# (#timeformat(date_add("h",SESSION.EP.TIME_ZONE,start_date),timeformat_style)#)<br/>#dateformat(date_add("h",SESSION.EP.TIME_ZONE,finish_date),dateformat_style)# (#timeformat(date_add("h",SESSION.EP.TIME_ZONE,finish_date),timeformat_style)#) 
			  <cfelseif isDefined("CLASS_DATE") and len(CLASS_DATE)>
			     #dateformat(class_date,dateformat_style)# (#timeformat(date_add("h",SESSION.EP.TIME_ZONE,class_date),timeformat_style)#) 
			  </cfif>
			</td>
			<td>#DATE_NO# / #HOUR_NO#</td>
			<td>
				<cfif TRAINER_TYPE eq 2 >
					 <cfset link_tra="#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#TRAINER_ID#">
					 <a href="javascript://"  class="tableyazi"onClick="windowopen('#link_tra#','project');">
				</cfif>
					#TRAINER_NAME#
				<cfif TRAINER_TYPE eq 2 ></a></cfif>
			</td> 
			<td>#PRETEST_POINT# / #FINALTEST_POINT#</td>
		  </tr>
		 </cfoutput>
		 <cfelse>
		 <tr class="color-row" height="20">
		  <td colspan="9"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
		 </tr>
	    </cfif>	   
            </table>
          </td>
        </tr>
      </table>
	<cfif get_class_finished.recordcount and (attributes.totalrecords gt attributes.maxrows)>
      <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td height="35">
		  <cf_pages 
			  page="#attributes.page#" 
			  maxrows="#attributes.maxrows#" 
			  totalrecords="#attributes.totalrecords#" 
			  startrow="#attributes.startrow#" 
			  adres="training_management.list_class_finished#url_str#"> 
          </td>
          <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
      </table>
	</cfif>
    </td>
  </tr>
</table>

	   <!--- 
	       <cfif (attributes.IC_DIS EQ 0) OR (attributes.IC_DIS EQ 1)>
			  <cfif get_class_finished.recordcount>
              <cfoutput QUERY="get_class_finished" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
               <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                  <td><a href="#request.self#?fuseaction=training_management.form_upd_class&class_id=#class_id#" class="tableyazi">#class_name#</a></td>
                <td>
				<cfif dateformat(start_date,dateformat_style) eq dateformat(now(),dateformat_style) or dateformat(finish_date,dateformat_style) eq dateformat(now(),dateformat_style) ><font  color="##FF0000"> </cfif>
					#dateformat(start_date,dateformat_style)# (#timeformat(start_date,timeformat_style)#) - #dateformat(finish_date,dateformat_style)# (#timeformat(finish_date,timeformat_style)#) 
				</td>
                  <td>
				  	<cfset attributes.class_id = class_id>
					<cfinclude template="../QUERY/get_class_trainer.cfm">
					  <cfloop QUERY="get_class_trainer_emps">
						#employee_name# #employee_surname#,
					  </cfloop>
					  <cfloop QUERY="get_class_trainer_pars">
						#nickname# - #company_partner_name# #company_partner_surname#, 
					  </cfloop>
					  <cfloop QUERY="get_class_trainer_grps">
						* #group_name#, 
					  </cfloop>
				  </td>
				<td>
				  <cfset attributes.employee_id = EMP_ID>					  
				  <cfinclude template="../QUERY/get_employee.cfm">
				<cfset attributes.department_id = GET_EMPLOYEE.department_id>
				<cfQUERY name="GET_LOCATION" datasource="#dsn#">
					SELECT 
						DEPARTMENT.DEPARTMENT_HEAD, 
						BRANCH.BRANCH_NAME,
						ZONE.ZONE_NAME,
						BRANCH.COMPANY_ID
					FROM 
						BRANCH,
						DEPARTMENT,
						ZONE 
					WHERE
						ZONE.ZONE_ID = BRANCH.ZONE_ID
						AND
						BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
						AND
						DEPARTMENT.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
				</cfQUERY>
				<cfQUERY name="get_company" datasource="#DSN#">
				SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = #GET_LOCATION.COMPANY_ID#
				</cfQUERY>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#attributes.employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>				
				</td>  
				<td>
				#get_company.COMPANY_NAME#/#get_location.branch_name#/#get_location.department_head#
				</td>  
				</tr>
              </cfoutput> 
			  </cfif>
			</cfif>
			<cfif (attributes.IC_DIS EQ 0) OR (attributes.IC_DIS EQ 2)>
			  <cfif get_class_ex.recordcount>
			    <cfoutput QUERY="get_class_ex">
				  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				    <td><a href="#request.self#?fuseaction=training_management.form_upd_ex_class&ex_class_id=#ex_class_id#" class="tableyazi">#class_name#</a></td>
				    <td>
				  <cfif LEN(class_date)>
					#dateformat(class_date,dateformat_style)# (#timeformat(class_date,timeformat_style)#)  
				  </cfif>	
				    </td>
					<td>
					  <cfif len(trainer_emp)>
					   <cfset attributes.trainer_emp = trainer_emp>
					    <cfQUERY name="get_tra_emp_ex" datasource="#dsn#">
						  SELECT 
						    EMP.EMPLOYEE_NAME,
							EMP.EMPLOYEE_SURNAME,
							TC.TRAINERS_EMP
						 FROM
						    EMPLOYEES EMP,
							TRAINING_EX_CLASS TC
						WHERE
						    TC.EX_CLASS_ID = #ex_class_id#
							  AND
							EMP.EMPLOYEE_ID = #attributes.trainer_emp#
							  
						</cfQUERY>
					     #get_tra_emp_ex.employee_name# #get_tra_emp_ex.employee_surname#
					  <cfelseif len(trainer_par)>
					    <cfQUERY name="get_tra_par_ex" datasource="#dsn#">
						  SELECT
						    COMPANY_PARTNER_NAME,
							COMPANY_PARTNER_SURNAME
						  FROM
						    COMPANY_PARTNER
						  WHERE
						    PARTNER_ID = #trainer_par#
						</cfQUERY>
						#get_tra_par_ex.COMPANY_PARTNER_NAME# #get_tra_par_ex.COMPANY_PARTNER_SURNAME#
					  </cfif>
					  
					</td>
					<td>
					 <cfset attributes.employee_id = record_emp>	
					  <cfinclude template="../QUERY/get_employee.cfm">
				<cfset attributes.department_id = GET_EMPLOYEE.department_id>
				<cfQUERY name="GET_LOCATION" datasource="#dsn#">
					SELECT 
						DEPARTMENT.DEPARTMENT_HEAD, 
						BRANCH.BRANCH_NAME,
						ZONE.ZONE_NAME,
						BRANCH.COMPANY_ID
					FROM 
						BRANCH,
						DEPARTMENT,
						ZONE 
					WHERE
						ZONE.ZONE_ID = BRANCH.ZONE_ID
						AND
						BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
						AND
						DEPARTMENT.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
				</cfQUERY>
				<cfQUERY name="get_company" datasource="#DSN#">
				SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = #GET_LOCATION.COMPANY_ID#
				</cfQUERY>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#attributes.employee_id#','medium');" class="tableyazi">#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME#</a>		
					</td>
					<td>
					  #get_company.COMPANY_NAME#/#get_location.branch_name#/#get_location.department_head#
					</td>
				  </tr>
				</cfoutput>
			  </cfif>
			</cfif>--->
              <!---<cfelse>
              <tr class="color-row" height="20"> 
                <td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
              </tr>
              </cfif>--->
			  

