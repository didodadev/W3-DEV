<cfquery name="GET_EMP_DETAIL" datasource="#DSN#" maxrows="1">
	SELECT TRANSPORT_TYPE_ID,IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE TRANSPORT_TYPE_ID = #URL.ID#
</cfquery>
<cfquery name="get_record" datasource="#dsn#">
	SELECT 
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP
	FROM
	SETUP_TRANSPORT_TYPES 
	WHERE 
	TRANSPORT_TYPE_ID = #URL.ID#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='44817.Ulaşım Yöntemleri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_transport_type" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_transport_type.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
	  		<cfform action="#request.self#?fuseaction=settings.emptypopup_upd_hr_transport_type" method="post" name="computer_info">
				<cfquery name="CATEGORY" datasource="#dsn#">
					SELECT 
						TRANSPORT_TYPE_ID,
						#dsn#.Get_Dynamic_Language(TRANSPORT_TYPE_ID,'#session.ep.language#','SETUP_TRANSPORT_TYPES','TRANSPORT_TYPE',NULL,NULL,TRANSPORT_TYPE) AS TRANSPORT_TYPE,
						#dsn#.Get_Dynamic_Language(TRANSPORT_TYPE_ID,'#session.ep.language#','SETUP_TRANSPORT_TYPES','TRANSPORT_TYPE_DETAIL',NULL,NULL,TRANSPORT_TYPE_DETAIL) AS TRANSPORT_TYPE_DETAIL,
						BRANCH_ID
					FROM 
						SETUP_TRANSPORT_TYPES
					WHERE 
						TRANSPORT_TYPE_ID = #URL.ID#
				</cfquery>
				<input type="Hidden" name="TRANSPORT_TYPE_ID" id="TRANSPORT_TYPE_ID" value="<cfoutput>#URL.ID#</cfoutput>">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="transport_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45122.Ulaşım Yöntemi'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='29483.Ulaşım Yöntemi Giriniz'>!</cfsavecontent>
									<cfinput type="Text" name="transport_type" size="30" value="#category.transport_type#" maxlength="50" required="Yes" message="#message#">
									<span class="input-group-addon">
										<cf_language_info 
										table_name="SETUP_TRANSPORT_TYPES" 
										column_name="TRANSPORT_TYPE" 
										column_id_value="#url.id#" 
										maxlength="500" 
										datasource="#dsn#" 
										column_id="TRANSPORT_TYPE_ID" 
										control_type="0">
									</span>
								</div>
							</div>	
						</div>
						<div class="form-group" id="item-branch_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfquery name="get_branchs" datasource="#DSN#">
									SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
								</cfquery>
								<select name="branch_id" id="branch_id">
									<option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
									<cfoutput query="get_branchs">
										<option value="#BRANCH_ID#" <cfif BRANCH_ID eq category.branch_id>selected</cfif>>#BRANCH_NAME#</option>
									</cfoutput>
								</select>
							</div>	
						</div>
						<div class="form-group" id="detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57771.Detay'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput type="Text" name="transport_type_detail" id="transport_type_detail" size="60" value="#category.transport_type_detail#" maxlength="50" required="Yes">
										<span class="input-group-addon">
											<cf_language_info 
											table_name="SETUP_TRANSPORT_TYPES" 
											column_name="TRANSPORT_TYPE_DETAIL" 
											column_id_value="#url.id#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="TRANSPORT_TYPE_ID" 
											control_type="0">
										</span>
								</div>
							</div>	
						</div>
					</div>
				</cf_box_elements>
    	     </div>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box_footer>
				<cf_record_info query_name="get_record">
				<cfif get_emp_detail.recordcount>
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>                  
				<cfelse>
					<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_hr_transport_type&transport_type_id=#URL.ID#'>
				</cfif>
			</cf_box_footer>
		</div>
		</cfform>
  	</cf_box>
</div>
<!---

	<table>
	  <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_hr_transport_type" method="post" name="computer_info">
		<cfquery name="CATEGORY" datasource="#dsn#">
			SELECT 
				* 
			FROM 
				SETUP_TRANSPORT_TYPES
			WHERE 
				TRANSPORT_TYPE_ID = #URL.ID#
		</cfquery>
		<input type="Hidden" name="TRANSPORT_TYPE_ID" id="TRANSPORT_TYPE_ID" value="<cfoutput>#URL.ID#</cfoutput>">
<cfif not isdefined("attributes.upper")>
<tr>
<td><cf_get_lang no='2839.Ulaşım Türü'></td>
<td>
	
	<select name="upper_transport_type_id" id="upper_transport_type_id">
		<cfoutput query="get_uppers">
			<option value="#transport_type_id#" <cfif transport_type_id eq category.upper_transport_type_id>selected</cfif>>#transport_type#</option>
		</cfoutput>
	</select>
</td>
</tr>

<tr>
<td><cf_get_lang_main no='41.Şube'></td>
<td>
	<cfquery name="get_branchs" datasource="#DSN#">
		SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
	</cfquery>
	<select name="branch_id" id="branch_id">
		<option value="">Şube Seçiniz</option>
		<cfoutput query="get_branchs">
			<option value="#BRANCH_ID#" <cfif BRANCH_ID eq category.branch_id>selected</cfif>>#BRANCH_NAME#</option>
		</cfoutput>
	</select>
</td>
</tr> 
</cfif>
		<tr>
		  <td width="100"><cf_get_lang no='2838.Ulaşım Tipi'> *</td>
		  <td>
		  <cfsavecontent variable="message">Tip Girmelisiniz!</cfsavecontent>
		  <cfinput type="Text" name="transport_type" size="30" value="#category.transport_type#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
		  </td>
		</tr>
		<tr>
		  <td valign="top"><cf_get_lang no='26.Ayrıntı'></td>
		  <td>
			<Textarea name="transport_type_detail" id="transport_type_detail" cols="60" rows="2" style="width:200px;height:50px;"><cfoutput>#category.transport_type_detail#</cfoutput></TEXTAREA>
		  </td>
		</tr>
		<tr>
		<td></td>
		  <td height="35"> 
		  <cfif get_emp_detail.recordcount>
		  	<cf_workcube_buttons is_upd='1' is_delete='0'>                  
		  <cfelse>
		  	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_hr_transport_type&transport_type_id=#URL.ID#'>
		  </cfif>
		  </td>
		</tr>
		<tr>
		<td colspan="2"><cf_get_lang_main no='71.Kayıt'> :
		<cfoutput>
			<cfif len(category.record_emp)>#get_emp_info(category.record_emp,0,0)#</cfif>
			<cfif len(category.record_date)>#dateformat(category.record_date,'dd/mm/yyyyy')#</cfif>
			<cfif len(category.update_emp)>
				<br/>
			<cf_get_lang_main no='479.Guncelleyen'> :
				#get_emp_info(category.update_emp,0,0)#
				#dateformat(category.update_date,'dd/mm/yyyyy')#
			</cfif>
		</cfoutput>
		</td>
		</tr>
	  </cfform>
	</table>
  </td>
</tr>
</table>

--->