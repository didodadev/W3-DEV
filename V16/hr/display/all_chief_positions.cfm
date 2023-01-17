<cfinclude template="../ehesap/query/get_our_comp_and_branchs.cfm">
<cfinclude template="../query/get_emp_codes.cfm">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.modal_id" default="">

<cf_box title="#getLang('','Şube Değerlendiricileri',55485)#" scroll="1" collapsable="1" resize="1" uidrop="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="" method="post" name="add_">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group">
					<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id="57789.Özel Kod"></label>
						<div class="col col-8  col-xs-12">
							<cfinput type="text" name="hierarchy" value="#attributes.hierarchy#" maxlength="50">
                        </div>
						
				</div>
				<div class="form-group">
					<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id="57453.Şube"></label>
						<div class="col col-8  col-xs-12">
                            
									<select name="branch_id" id="branch_id">
										<option value=""><cf_get_lang dictionary_id="29434.Şubeler"></option>
										<cfoutput query="get_our_comp_and_branchs">
											<option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
										</cfoutput>
									</select>
                        
                        </div>
						
				</div>
			</div>
	</cf_box_elements>
	<cf_box_footer>
		<cf_wrk_search_button button_type="5"  search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_' , #attributes.modal_id#)"),DE(""))#">
		<!--- <input type="submit"  value="<cf_get_lang dictionary_id='57565.Ara'>" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_' , #attributes.modal_id#)"),DE(""))#"> --->
		</cf_box_footer>
    </cfform>				

<cfif len(attributes.branch_id) or len(attributes.hierarchy)>
	<cfquery name="get_standbys" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE,
		EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE,
		EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS_STANDBY.SB_ID,		
		B.BRANCH_NAME,
		D.DEPARTMENT_HEAD
	FROM
		EMPLOYEE_POSITIONS_STANDBY,
		EMPLOYEE_POSITIONS,
		EMPLOYEES,
		OUR_COMPANY,
		BRANCH B,
		DEPARTMENT D
	WHERE			
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE AND
		OUR_COMPANY.COMP_ID=B.COMPANY_ID AND 
		B.BRANCH_ID=D.BRANCH_ID AND 
		D.DEPARTMENT_ID=EMPLOYEE_POSITIONS.DEPARTMENT_ID		
		ORDER BY EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE DESC,EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE DESC
	</cfquery>
	<cfset chief_codes = ''>
	<cfif get_standbys.recordcount>
		<cfloop query="get_standbys">
			<cfif len(CHIEF1_CODE) and not listfind(chief_codes,CHIEF1_CODE,',')>
				<cfset chief_codes = listappend(chief_codes,CHIEF1_CODE,',')>
			</cfif>
			<cfif len(CHIEF2_CODE) and not listfind(chief_codes,CHIEF2_CODE,',')>
				<cfset chief_codes = listappend(chief_codes,CHIEF2_CODE,',')>
			</cfif>
			<cfif len(CHIEF3_CODE) and not listfind(chief_codes,CHIEF3_CODE,',')>
				<cfset chief_codes = listappend(chief_codes,CHIEF3_CODE,',')>
			</cfif>
		</cfloop>
	</cfif>	
	
<cfif len(chief_codes)>
	<cfquery name="get_position_employees" datasource="#dsn#">
		SELECT 	
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.EMPLOYEE_ID,
			EP.POSITION_NAME,
			EP.POSITION_CODE 
		FROM 
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D,
			BRANCH B 
		WHERE 
			EP.POSITION_CODE IN (#chief_codes#) AND 
			D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND 
			B.BRANCH_ID = D.BRANCH_ID
			<cfif len(attributes.branch_id)>		
			AND	B.BRANCH_ID = #ATTRIBUTES.BRANCH_ID#
			</cfif>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND ('.' + EP.HIERARCHY + '.') LIKE '%.#code_i#.%'
				<cfelseif database_type is "DB2">
					AND ('.' || EP.HIERARCHY || '.') LIKE '%.#code_i#.%'
				</cfif>
			</cfloop>
	</cfquery>
	<cf_grid_list>
    <thead>
	<cfif len(attributes.branch_id)>	
		<cfquery name="get_branch_name" dbtype="query">
			SELECT BRANCH_NAME FROM get_our_comp_and_branchs WHERE BRANCH_ID = #attributes.branch_id#
		</cfquery>	
             <tr>
                 <th colspan="5"><cfoutput>#get_branch_name.branch_name#</cfoutput></th>
             </tr>
	 </cfif>
		  <tr>
			<th><cf_get_lang dictionary_id="58497.Pozisyon"></th>
			<th width="125"><cf_get_lang dictionary_id="57576.Çalışan"></th>
			<th width="25" >1.<cf_get_lang dictionary_id="55620.Değerlendirici"></th>
			<th width="25" >2.<cf_get_lang dictionary_id="55620.Değerlendirici"></th>
			<th width="25"><cf_get_lang dictionary_id="56016.Görüş"></th>
		  </tr>
	</thead>
    <tbody>
		<cfoutput query="get_position_employees">
        <tr>
            <td>#position_name#</td>
            <td>#employee_name# #employee_surname#</td>
            <td align="center">
                <cfquery name="get_position_chief1" dbtype="query">
                    SELECT COUNT(POSITION_CODE) AS SAYI1 FROM get_standbys WHERE CHIEF1_CODE = #POSITION_CODE#
                </cfquery>
            <cfif len(get_position_chief1.SAYI1)>#get_position_chief1.SAYI1#<cfelse>-</cfif>
            </td>
            <td align="center">
                <cfquery name="get_position_chief2" dbtype="query">
                    SELECT COUNT(POSITION_CODE) AS SAYI2 FROM get_standbys WHERE CHIEF2_CODE = #POSITION_CODE#
                </cfquery>
            <cfif len(get_position_chief2.SAYI2)>#get_position_chief2.SAYI2#<cfelse>-</cfif>
            </td>
            <td align="center">
                <cfquery name="get_position_chief3" dbtype="query">
                    SELECT COUNT(POSITION_CODE) AS SAYI3 FROM get_standbys WHERE CHIEF3_CODE = #POSITION_CODE#
                </cfquery>
            <cfif len(get_position_chief3.SAYI3)>#get_position_chief3.SAYI3#<cfelse>-</cfif>
            </td>
        </tr>
        </cfoutput>
	</tbody>
    </cf_grid_list>
</cfif>		
</cfif>
</cf_box>