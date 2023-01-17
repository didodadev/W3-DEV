<!--- list_my_trainings.cfm --->
<cf_xml_page_edit fuseact="hr.popup_list_emp_trainings">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str="keyword=#attributes.keyword#">
<div class="col col-12">
<cfinclude template="../query/get_emp_training.cfm">
	<cf_box title="#get_emp_info(attributes.emp_id,0,0)#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="55966.Katıldığı Eğitimler"></cfsavecontent>
		<cf_seperator id="attended_trainings" title="#message#">
		<cf_flat_list id="attended_trainings">
		<thead>
			<tr> 
				<th><cf_get_lang dictionary_id='35270.Eğitim Adı'></th>
				<th><cf_get_lang dictionary_id='30916.Eğitim Yeri'></th>		
				<th><cf_get_lang dictionary_id='57490.Gün'>/<cf_get_lang dictionary_id='57491.Saat'></th>		
				<th><cf_get_lang dictionary_id='57501.Başlangıç'> / <cf_get_lang dictionary_id='57502.Bitş'></th>
				<th><cf_get_lang dictionary_id='55968.Yoklama'></th>
				<cfif is_maliyet>
					<th><cf_get_lang dictionary_id="58258.maliyet"></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57467.Not'></th>
			</tr>
		</thead>
		<tbody>
        <cfif get_attenders_joined_training.recordcount>
			<cfoutput query="get_attenders_joined_training" group="class_id"> 
				<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_DT">
					SELECT
						TCADT.ATTENDANCE_MAIN,
						TCADT.IS_EXCUSE_MAIN,
						TCADT.EXCUSE_MAIN,
						TCA.START_DATE
					FROM
						TRAINING_CLASS_ATTENDANCE TCA,
						TRAINING_CLASS_ATTENDANCE_DT TCADT
					WHERE
						TCA.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLASS_ID#">
						AND TCADT.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMP_ID#">
						AND TCADT.IS_TRAINER = 0
						AND TCA.CLASS_ATTENDANCE_ID = TCADT.CLASS_ATTENDANCE_ID
				</cfquery>
				<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_RESULTS">
					SELECT
						PRETEST_POINT,
						FINALTEST_POINT
					FROM
						TRAINING_CLASS_RESULTS
					WHERE
						CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLASS_ID#">
						AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMP_ID#">
				</cfquery>
				<cfif is_maliyet>
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
				<tr>
					<td>#CLASS_NAME#</td>
					<td>#CLASS_PLACE#</td>
					<td><cfif DATE_NO AND HOUR_NO>#DATE_NO# / #HOUR_NO#</cfif></td>
					<td>#dateformat(START_DATE,dateformat_style)#-#dateformat(FINISH_DATE,dateformat_style)#</td>
					<td>
                        <cfif JOINED eq 1>
                            <cf_get_lang dictionary_id='62465.Katıldı'>
                        <cfelseif JOINED eq 3>
                            <cf_get_lang dictionary_id='63442.Geç Katıldı'>
                        </cfif>
                    </td>
				<cfif is_maliyet>
					<td>#TLFormat(GET_TRAIN_CLASS_COST.GERCEKLESEN)#</td>
				</cfif>
					<td>#NOTE#</td>
				</tr>
			</cfoutput>
			<cfelse>
                <cfset colspan_ = 8>
                <cfif is_maliyet>
                    <cfset colspan_ = colspan_ + 1>
                </cfif>
                <tr>
                    <td colspan="<cfoutput>#colspan_#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
                </tr>
			</cfif>
			<tbody>
		</cf_flat_list>

		<cfsavecontent variable="message"><cf_get_lang dictionary_id="55967.Katılacağı Kesinleşen Eğitimler"></cfsavecontent>
		<cf_seperator id="finalized_trainings" title="#message#">
		<cf_flat_list id="finalized_trainings">
		<thead>
			<tr> 
				<th><cf_get_lang dictionary_id='35270.Eğitim Adı'></th>
				<th><cf_get_lang dictionary_id='30916.Eğitim Yeri'></th>		
				<th><cf_get_lang dictionary_id='57490.Gün'>/<cf_get_lang dictionary_id='57491.Saat'></th>		
				<th width="65"><cf_get_lang dictionary_id='57501.Başl'></th>
				<th width="65"><cf_get_lang dictionary_id='57502.Bitş'></th>
			</tr>
			</thead>
			<tbody>
			<cfif get_emp_finalized_trainings.recordcount>
				<cfoutput query="get_emp_finalized_trainings" group="class_id">
					<tr>
					<td>#CLASS_NAME#</td>
					<td>#CLASS_PLACE#</td>
					<td><cfif DATE_NO AND HOUR_NO>#DATE_NO# / #HOUR_NO#</cfif></td>
					<td>#dateformat(START_DATE,dateformat_style)#</td>
					<td>#dateformat(FINISH_DATE,dateformat_style)#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
				<td colspan="6"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
				</tr>
			</cfif>
			</tbody>
		</cf_flat_list>
		<!---<br/>
		<cf_medium_list_search title="#lang_array.item[446]#"></cf_medium_list_search>
		<cf_medium_list>
			<thead>
			<tr> 
				<th><cf_get_lang_main no='7.Eğitim Adı'></th>
				<th><cf_get_lang no='871.Eğitim Yeri'></th>		
				<th><cf_get_lang_main no='78.Gün'>/<cf_get_lang_main no='79.Saat'></th>		
				<th width="65"><cf_get_lang_main no='89.Başl'></th>
				<th width="65"><cf_get_lang_main no='90.Bitş'></th>
			</tr>
			</thead>
			<tbody>
			<cfif get_next_trains.recordcount>
				<cfoutput query="get_next_trains"> 					
					<tr>
					<td>#CLASS_NAME#</td>
					<td>#CLASS_PLACE#</td>
					<td><cfif DATE_NO AND HOUR_NO>#DATE_NO# / #HOUR_NO#</cfif></td>
					<td><cfif D_TYPE eq 2>#dateformat(START_DATE,dateformat_style)#</cfif></td>
					<td><cfif D_TYPE eq 2>#dateformat(FINISH_DATE,dateformat_style)#</cfif></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
				<td colspan="5"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
				</tr>
			</cfif>
			</tbody>
		</cf_medium_list>
		<br/>
		<cf_medium_list_search title="#lang_array.item[446]# (#getLang('main',160)#)"></cf_medium_list_search>
		<cf_medium_list>
			<thead>
			<tr> 
				<th><cf_get_lang_main no='7.Eğitim Adı'></th>
				<th><cf_get_lang no='871.Eğitim Yeri'></th>		
				<th><cf_get_lang_main no='78.Gün'>/<cf_get_lang_main no='79.Saat'></th>		
				<th width="65"><cf_get_lang_main no='89.Başl'></th>
				<th width="65"><cf_get_lang_main no='90.Bitş'></th>
			</tr>
			</thead
			><tbody>
			<cfif get_tra_pos.recordcount>
				<cfoutput query="get_tra_pos" > 					
					<tr class="color-row" height="20">
					<!--- <td>#TRAIN_HEAD#</td>--->
					<td>#CLASS_NAME#</td>
					<td>#CLASS_PLACE#</td>
					<td><cfif DATE_NO AND HOUR_NO>#DATE_NO# / #HOUR_NO#</cfif></td>
					<td><cfif D_TYPE eq 2>#dateformat(START_DATE,dateformat_style)#</cfif></td>
					<td><cfif D_TYPE eq 2>#dateformat(FINISH_DATE,dateformat_style)#</cfif></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr class="color-row" height="20">
				<td colspan="5"><cf_get_lang_main no='72.Kayit Bulunamadi'></td>
				</tr>
			</cfif>
			</tbody>
		</cf_medium_list>--->

		<cfsavecontent variable="message"><cf_get_lang dictionary_id="55531.Alması Gereken Eğitimler"></cfsavecontent>
		<cf_seperator id="mandatory_trainings" title="#message#">
		<cf_flat_list id="mandatory_trainings">
			<thead>
			<tr> 
				<th><cf_get_lang dictionary_id='55657.Sıra No'></th>
				<th><cf_get_lang dictionary_id='57419.Eğitim'></th>		
				<th><cf_get_lang dictionary_id='57486.Kategori'></th>		
				<th><cf_get_lang dictionary_id='57995.Bölüm'></th>
				<th><cf_get_lang dictionary_id="46236.Eğitim Şekli"></th>
			</tr>
			</thead><tbody>
			<cfif get_tra_subjects.recordcount>
				<cfoutput query="get_tra_subjects" > 					
					<tr class="color-row" height="20">
						<td>#currentrow#</td>
						<td>#TRAIN_HEAD#</td>
						<td>#TRAINING_CAT#</td>
						<td>#SECTION_NAME#</td>
						<td>#TRAINING_STYLE#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr class="color-row" height="20">
				<td colspan="5"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'></td>
				</tr>
			</cfif>
			</tbody>
		</cf_flat_list>
	</cf_box>
</div>