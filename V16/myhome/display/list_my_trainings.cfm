<cf_xml_page_edit fuseact="myhome.list_my_trainings">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str="keyword=#attributes.keyword#">
<cfinclude template="../query/get_emp_training.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30921.Katıldığı Eğitimler'></cfsavecontent>
<cf_box title="#message#" closable="0">
	<cf_ajax_list>
		<div class="extra_list">
			<thead>
				<tr class="">
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57419.Eğitim'></th>
					<th width="300"><cf_get_lang dictionary_id='30916.Eğitim Yeri'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='57490.Gün'>/<cf_get_lang dictionary_id='57491.Saat'></th>
					<th width="125"><cf_get_lang dictionary_id='30913.Başlama Bitiş'></th>
					<th width="100"><cf_get_lang dictionary_id='30911.Yoklama'></th>
					<cfif x_is_maliyet>
						<th><cf_get_lang dictionary_id="58258.Maliyet"></th>
					</cfif>
					<th width="65"><cf_get_lang dictionary_id='30910.Ön Test'></th>
					<th width="65"><cf_get_lang dictionary_id='30909.Son Test'></th>
				</tr>
			
				<cfif get_tra_dep.recordcount>
					<cfoutput query="get_tra_dep">
					<cfquery name="GET_TRAIN_CLASS_DT" datasource="#dsn#">
					  SELECT 
						  TCADT.ATTENDANCE_MAIN,
						  TCADT.IS_EXCUSE_MAIN,
						  TCADT.EXCUSE_MAIN,
						  TCA.START_DATE
					  FROM
						  TRAINING_CLASS_ATTENDANCE TCA,
						  TRAINING_CLASS_ATTENDANCE_DT TCADT
					  WHERE
						  TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> AND
						  TCADT.EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#"> AND
						  TCADT.IS_TRAINER = 0 AND
						  TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID
					</cfquery>
					<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_RESULTS">
					  SELECT
						  PRETEST_POINT,
						  FINALTEST_POINT
					  FROM
						  TRAINING_CLASS_RESULTS
					  WHERE
						  CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> AND
						  EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
					</cfquery>
					<cfif x_is_maliyet>
						<cfquery name="GET_TRAIN_CLASS_COST" datasource="#DSN#">
							SELECT
								 SUM(TCR.GERCEKLESEN_BIRIM) as GERCEKLESEN
							FROM
								TRAINING_CLASS_COST TC,
								TRAINING_CLASS_COST_ROWS TCR
							WHERE
								TC.TRAINING_CLASS_COST_ID = TCR.TRAINING_CLASS_COST_ID
								AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLASS_ID#">
						</cfquery>
					</cfif>
			</thead>
			<tbody>
				
			<tr>
				<td width="35">#currentrow#</td>
				<td>#CLASS_NAME#</td>
				<td>#CLASS_PLACE#</td>
				<td><cfif DATE_NO AND HOUR_NO>#DATE_NO# / #HOUR_NO#</cfif></td>
				<td>#dateformat(START_DATE,dateformat_style)#-#dateformat(FINISH_DATE,dateformat_style)#</td>
				<td>
					<cfloop query="GET_TRAIN_CLASS_DT">
					#DateFormat(START_DATE,dateformat_style)#-
						<cfif IsNumeric(ATTENDANCE_MAIN) AND ATTENDANCE_MAIN>
							%#ATTENDANCE_MAIN#
						<cfelseif IS_EXCUSE_MAIN IS 1>
							#EXCUSE_MAIN#
						</cfif><br />
					</cfloop>
				</td>
                <cfif x_is_maliyet>
                	<td>#TLFormat(GET_TRAIN_CLASS_COST.GERCEKLESEN)#</td>
                </cfif>
				<td>#GET_TRAIN_CLASS_RESULTS.PRETEST_POINT#</td>
				<td>#GET_TRAIN_CLASS_RESULTS.FINALTEST_POINT#</td>
			</tr>
			</cfoutput>
		<cfelse>
        	<cfset colspan_ = 8>
            <cfif x_is_maliyet>
            	<cfset colspan_ = colspan_ + 1>
            </cfif>
			<tr>
				<td colspan="<cfoutput>#colspan_#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
			</tr>
		</cfif>

			</tbody>
		</div>
	</cf_ajax_list>
</cf_box>
 <!--- <cf_medium_list_search title="#getLang('myhome',164)#">
	<cf_medium_list_search_area> --->
			<!--- <tr>
				<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1' tag_module="kontrol">
			</tr> --->	
	<!--- </cf_medium_list_search_area>
   </cf_medium_list_search>
   <cf_medium_list>  --->  
  <!--- </cf_medium_list>  --->





<!--- katilacagi kesinlesen egitimler --->
<!--- <cf_medium_list_search title="#getLang('myhome',145)#"></cf_medium_list_search> 
<cf_medium_list> --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30902.Katılacağı Kesinleşen Eğitimler'></cfsavecontent>
 <cf_box title="#message#" closable="0">
	<cf_ajax_list>
		<div class="extra_list">
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57419.Eğitim'></th>
					<th width="300"><cf_get_lang dictionary_id='30916.Eğitim Yeri'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='57490.Gün'>/<cf_get_lang dictionary_id='57491.Saat'></th>
					<th width="65"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
					<th width="65"><cf_get_lang dictionary_id='57502.Bitiş'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_trains.recordcount>
					<cfoutput query="get_trains" >
						<tr>
							<td width="35">#currentrow#</td>
							<td>#CLASS_NAME#</td>
							<td>#CLASS_PLACE#</td>
							<td><cfif len(DATE_NO) AND len(HOUR_NO)>
							#DATE_NO# / #HOUR_NO#
							</cfif>
							</td>
							<td>#dateformat(START_DATE,dateformat_style)#</td>
							<td>#dateformat(FINISH_DATE,dateformat_style)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
					</tr>
				</cfif>
			</tbody>
		</div>
	</cf_ajax_list>
</cf_box>	
	
		
	
<!--- </cf_medium_list> --->
<cfinclude  template="../display/list_personal_class.cfm">