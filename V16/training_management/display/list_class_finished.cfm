<cfparam name="attributes.sirala_1" default="">
<cfparam name="attributes.sirala_2" default="">
<cfparam name="attributes.sirala_3" default="">
<cfparam name="attributes.IC_DIS" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.keyword" default="">
	<cfset url_str = "">
    <cfif len(attributes.keyword)>
        <cfset url_str = url_str&"&keyword="&attributes.keyword>
    </cfif>
    <cfif isdefined("attributes.date1") and len(attributes.date1)>
        <cfset url_str = url_str&"&date1="&attributes.date1>			  
     </cfif>
    <cfif isDefined("attributes.IC_DIS") and len(attributes.IC_DIS)>
        <cfset url_str = url_str&"&IC_DIS="&attributes.IC_DIS>			  
    </cfif>
    <cfif isDefined("attributes.sirala_1") and len(attributes.sirala_1)>
        <cfset url_str = url_str&"&sirala_1="&attributes.sirala_1>			  
    </cfif>
    <cfif isDefined("attributes.sirala_2") and len(attributes.sirala_2)>
        <cfset url_str = url_str&"&sirala_2="&attributes.sirala_2>			  
    </cfif>
    <cfif isDefined("attributes.sirala_3") and len(attributes.sirala_3)>
        <cfset url_str = url_str&"&sirala_3="&attributes.sirala_3>			  
    </cfif>
     <cfif isDefined("attributes.form_submitted") and len(attributes.form_submitted)>
        <cfset url_str = url_str&"&form_submitted="&attributes.form_submitted>			  
    </cfif>
 <cfif isdefined ("attributes.form_submitted")> 
	<cfinclude template="../query/get_class_finish.cfm">
 <cfelse>
	<cfset get_union_class_finish.recordcount=0>
</cfif> 
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_union_class_finish.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form1" method="post" action="#request.self#?fuseaction=training_management.list_class_finished">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#place#" maxlength="50">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfset attributes.date1=dateformat(attributes.date1,dateformat_style)>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'>!</cfsavecontent>
						<cfinput name="date1" type="text" value="#attributes.date1#" style="width:75px;" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="IC_DIS" id="IC_DIS">
						<option value=""<cfif attributes.IC_DIS is ""> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="0" <cfif attributes.IC_DIS EQ 0>SELECTED</cfif>><cf_get_lang dictionary_id='58561.İç'></option>
						<option value="1" <cfif attributes.IC_DIS EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='58562.Dış'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="sirala_1" id="sirala_1" style="width=58px;">
						<option value=""><cf_get_lang dictionary_id='46610.Sırala'> 1</option>						
						<option value="1" <cfif attributes.sirala_1 eq 1>selected</cfif>><cf_get_lang dictionary_id='57992.Bölge'></option>
						<option value="2" <cfif attributes.sirala_1 eq 2>selected</cfif>><cf_get_lang dictionary_id='57453.Şube'></option>
						<option value="3" <cfif attributes.sirala_1 eq 3>selected</cfif>><cf_get_lang dictionary_id='57572.Departman'></option>
						<option value="4" <cfif attributes.sirala_1 eq 4>selected</cfif>> <cf_get_lang dictionary_id='29780.Katılımcı'></option>							
						<option value="5" <cfif attributes.sirala_1 eq 5>selected</cfif>> <cf_get_lang dictionary_id='57419.Eğitim'></option>																				
					</select>
				</div>
				<div class="form-group">
					<select name="sirala_2" id="sirala_2"  style="width=58px;">
						<option value=""><cf_get_lang dictionary_id='46610.Sırala'> 2</option>
						<option value="1" <cfif attributes.sirala_2 eq 1>selected</cfif>><cf_get_lang dictionary_id='57992.Bölge'></option>
						<option value="2" <cfif attributes.sirala_2 eq 2>selected</cfif>><cf_get_lang dictionary_id='57453.Şube'></option>
						<option value="3" <cfif attributes.sirala_2 eq 3>selected</cfif>><cf_get_lang dictionary_id='57572.Departman'></option>
						<option value="4" <cfif attributes.sirala_2 eq 4>selected</cfif>><cf_get_lang dictionary_id='29780.Katılımcı'></option>										
						<option value="5" <cfif attributes.sirala_2 eq 5>selected</cfif>><cf_get_lang dictionary_id='57419.Eğitim'></option>																																	
					</select>
				</div>
				<div class="form-group">
					<select name="sirala_3" id="sirala_3" style="width=58px;">
						<option value=""><cf_get_lang dictionary_id='46610.Sırala'> 3</option>
						<option value="1"<cfif attributes.sirala_3 eq 1>selected</cfif>><cf_get_lang dictionary_id='57992.Bölge'></option>
						<option value="2"<cfif attributes.sirala_3 eq 2>selected</cfif>><cf_get_lang dictionary_id='57453.Şube'></option>
						<option value="3"<cfif attributes.sirala_3 eq 3>selected</cfif>><cf_get_lang dictionary_id='57572.Departman'></option>
						<option value="4"<cfif attributes.sirala_3 eq 4>selected</cfif>><cf_get_lang dictionary_id='29780.Katılımcı'></option>																
						<option value="5"<cfif attributes.sirala_3 eq 5>selected</cfif>><cf_get_lang dictionary_id='57419.Eğitim'></option>																												
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol_sirala()'>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(56,'Biten Eğitimler',46263)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<!---<td height="22" class="form-title" width="150">Katılımcı</td> --->
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='29780.Katılımcı'></th>
					<th><cf_get_lang dictionary_id ='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id ='57453.Şube'></th>
					<th><cf_get_lang dictionary_id ='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='57779.Pozisyon Tipi'></th>
					<th><cf_get_lang dictionary_id='57419.Eğitim'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='46319.G/S'></th>
					<th><cf_get_lang dictionary_id='46230.Eğitimci'></th>
					<th><cf_get_lang dictionary_id ='46703.İlk Test'></th>
					<th><cf_get_lang dictionary_id ='46383.Son Test'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_union_class_finish.RECORDCOUNT>
				<!--- <cfset trainer_par_list=''>
				<cfset trainer_cons_list=''>
				<cfset trainer_emp_list=''> --->
				<cfset attender_par_list=''>
				<cfset attender_cons_list=''>
				<cfset attender_emp_list=''>
					<cfoutput QUERY="get_union_class_finish" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<!--- <cfif not listfind(trainer_par_list,TRAINER_PAR)>
							<cfset trainer_par_list=listappend(trainer_par_list,TRAINER_PAR)>
						</cfif>
						<cfif not listfind(trainer_cons_list,TRAINER_CONS)>
							<cfset trainer_cons_list=listappend(trainer_cons_list,TRAINER_CONS)>
						</cfif>
						<cfif not listfind(trainer_emp_list,TRAINER_EMP)>
							<cfset trainer_emp_list=listappend(trainer_emp_list,TRAINER_EMP)>
						</cfif> --->
						<cfif not listfind(attender_par_list,PAR_ID)>
							<cfset attender_par_list=listappend(attender_par_list,PAR_ID)>
						</cfif>
						<cfif not listfind(attender_cons_list,CON_ID)>
							<cfset attender_cons_list=listappend(attender_cons_list,CON_ID)>
						</cfif>
						<cfif not listfind(attender_emp_list,EMP_ID)>
							<cfset attender_emp_list=listappend(attender_emp_list,EMP_ID)>
						</cfif>
					</cfoutput>
				<!---  <cfset trainer_par_list=listsort(trainer_par_list,"numeric")>
				<cfset trainer_cons_list=listsort(trainer_cons_list,"numeric")>
				<cfset trainer_emp_list=listsort(trainer_emp_list,"numeric")> --->
				<cfset attender_par_list=listsort(attender_par_list,"numeric")>
				<cfset attender_cons_list=listsort(attender_cons_list,"numeric")>
				<cfset attender_emp_list=listsort(attender_emp_list,"numeric")>
				<!--- <cfif len(trainer_emp_list)>
					<cfquery name="get_trainer_emp" datasource="#DSN#">
						SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#trainer_emp_list#">) ORDER BY EMPLOYEE_ID
					</cfquery>
					</cfif>
					<cfif len(trainer_par_list)>
						<cfquery name="get_trainer_par" datasource="#DSN#">
							SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#trainer_par_list#">) ORDER BY PARTNER_ID
						</cfquery>
					</cfif>
					<cfif len(trainer_cons_list)>
						<cfquery name="get_trainer_cons" datasource="#DSN#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#trainer_cons_list#">) ORDER BY CONSUMER_ID
						</cfquery>
					</cfif> --->
					<cfif len(attender_emp_list) or len(attender_par_list) or len(attender_cons_list)>
						<cfquery name="get_point" datasource="#dsn#">
							SELECT 
								PAR_ID,
								CON_ID,
								EMP_ID,
								CLASS_ID,
								PRETEST_POINT,
								FINALTEST_POINT 
							FROM 
								TRAINING_CLASS_RESULTS 
							WHERE
								CLASS_ID IS NOT NULL
							<cfif len(attender_emp_list)>
								AND EMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attender_emp_list#">)
							</cfif>
							<cfif len(attender_par_list)>
								AND PAR_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attender_par_list#">)
							</cfif>
							<cfif len(attender_cons_list)>
								AND CON_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attender_cons_list#">)
							</cfif>
						</cfquery>
					</cfif>
					<cfoutput query="get_union_class_finish" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">(#class_id#)#currentrow#</td>
							<td>
								<cfif type is 'employee'><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#EMP_ID#','project');" class="tableyazi"><cfelseif type is 'partner'><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#PAR_ID#','small');" class="tableyazi"><cfelseif type is 'consumer'><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CON_ID#','small');" class="tableyazi"></cfif>
									#ATTENDER_NAME#
								<cfif type is 'employee' or type is 'partner' or type is 'consumer'></a></cfif>
							</td>
							<td>#NICK_NAME#</td>
							<td>#branch_name#</td>
							<td>#DEPARTMAN#</td>
							<td>#POSITION#</td>
							<td>
								<a href="#request.self#?fuseaction=training_management.list_training_recommendations&event=upd&class_id=#class_id#" class="tableyazi">#class_name#</a>
							</td> 
							<td><cfif int_or_ext eq 1><cf_get_lang dictionary_id='58562.Dış'><cfelseif int_or_ext eq 2 or int_or_ext eq 0><cf_get_lang dictionary_id='58561.İç'></cfif></td>
							<td>
							<cfif isDefined("START_DATE") AND isDefined("FINISH_DATE")  and len(START_DATE) and len(FINISH_DATE)>
								<cfif dateformat(start_date,dateformat_style) eq dateformat(now(),dateformat_style) or dateformat(finish_date,dateformat_style) eq dateformat(now(),dateformat_style) ><font  color="##FF0000"> </cfif>
									#dateformat(date_add("h",SESSION.EP.TIME_ZONE,start_date),dateformat_style)# (#timeformat(date_add("h",SESSION.EP.TIME_ZONE,start_date),timeformat_style)#)<br/>#dateformat(date_add("h",SESSION.EP.TIME_ZONE,finish_date),dateformat_style)# (#timeformat(date_add("h",SESSION.EP.TIME_ZONE,finish_date),timeformat_style)#) 
							</cfif>
							</td>
							<td>#DATE_NO#/#HOUR_NO#</td>
							<td>
								<!--- <cfif len(TRAINER_EMP)>#get_trainer_emp.EMPLOYEE_NAME[listfind(trainer_emp_list,TRAINER_EMP,',')]# #get_trainer_emp.EMPLOYEE_SURNAME[listfind(trainer_emp_list,TRAINER_EMP,',')]#
								<cfelseif len(TRAINER_PAR)>#get_trainer_par.COMPANY_PARTNER_NAME[listfind(trainer_par_list,TRAINER_PAR,',')]# #get_trainer_par.COMPANY_PARTNER_SURNAME[listfind(trainer_par_list,TRAINER_PAR,',')]#
								<cfelseif len(TRAINER_CONS)>#get_trainer_cons.CONSUMER_NAME[listfind(trainer_cons_list,TRAINER_CONS,',')]# #get_trainer_cons.CONSUMER_SURNAME[listfind(trainer_cons_list,TRAINER_CONS,',')]#</cfif> --->
								<cfscript>
									get_trainers = createObject("component","V16.training_management.cfc.get_class_trainers");
									get_trainers.dsn = dsn;
									get_trainer_names = get_trainers.get_class_trainers
													(
														module_name : fusebox.circuit,
														class_id : class_id
													);
								</cfscript>
								<cfloop query="get_trainer_names">#trainer#<cfif get_trainer_names.recordcount neq 1>,</cfif></cfloop>				
							</td> 
							<td>
								<cfif len(EMP_ID) or len(PAR_ID) or len(CON_ID)>
									<cfquery name="point_query" dbtype="query">
										SELECT 
											FINALTEST_POINT,
											PRETEST_POINT
										FROM 
											get_point  
										WHERE
											<cfif len(EMP_ID)>
												EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#EMP_ID#">
											</cfif>
											<cfif len(PAR_ID)>
												PAR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#PAR_ID#">
											</cfif>
											<cfif len(CON_ID)>
												CON_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#CON_ID#">
											</cfif>
											AND CLASS_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#CLASS_ID#"> 
									</cfquery>
											#point_query.PRETEST_POINT#
								</cfif>
							</td>
							<td><cfif len(EMP_ID) or len(PAR_ID) or len(CON_ID)>#point_query.FINALTEST_POINT#</cfif></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="13"><cfif isdefined('attributes.form_submitted') and attributes.form_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>	   
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="training_management.list_class_finished#url_str#"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol_sirala()
	{
		if(document.form1.sirala_1.value != "" || document.form1.sirala_2.value != "" || document.form1.sirala_3.value != "")
			if((document.form1.sirala_1.value == document.form1.sirala_2.value) && (document.form1.sirala_1.value != "" && document.form1.sirala_2.value != ""))	
			{
				alert("<cf_get_lang dictionary_id ='46705.Sıralamalar aynı seçilemez'>!");
				return false;
			}
			if((document.form1.sirala_1.value == document.form1.sirala_3.value)  && (document.form1.sirala_1.value != "" && document.form1.sirala_3.value != ""))
			{
				alert("<cf_get_lang dictionary_id ='46705.Sıralamalar aynı seçilemez'>!");
				return false;
			}
			if((document.form1.sirala_2.value == document.form1.sirala_3.value)  && (document.form1.sirala_2.value != "" && document.form1.sirala_3.value != ""))
			{
				alert("<cf_get_lang dictionary_id ='46705.Sıralamalar aynı seçilemez'>!");
				return false;
			}
			return true;
	}
</script>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
