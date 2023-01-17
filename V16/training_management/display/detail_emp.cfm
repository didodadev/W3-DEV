<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str="keyword=#attributes.keyword#">
<cfinclude template="../query/get_emp_training.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
<cf_box title="#get_emp_info(attributes.emp_id,0,0)#" uidrop="1" popup_box="1">
    <!-- sil -->
	<cf_seperator title="#getLang('48','katıldığı eğitimler',30921)#" id="detail_seperator">
		<cf_grid_list title="Katıldığı Eğitimler">
			<thead>
				<tr>
					<th width="150"><cf_get_lang_main no='7.Katıldığı Eğitimler'></th>
					<th width="150">Eğitim Yeri</th>
					<th width="75"><cf_get_lang_main no='78.Gün'>/<cf_get_lang_main no='79.Saat'></th>
					<th><cf_get_lang_main no='89.Başlama'><cf_get_lang_main no='90.Bitiş'></th>
					<th width="120">Yoklama</th>
					<th width="40">Ön T</th>
					<th width="40">Son T</th>
				</tr>
			</thead>
			<tbody>
				<cfif get_tra_dep.recordcount>
					<cfoutput query="get_tra_dep" >
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
								TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> 
								AND TCADT.EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
								AND TCADT.IS_TRAINER = 0
								AND TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID
							</cfquery>
							<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_RESULTS">
							SELECT 
							PRETEST_POINT, 
							FINALTEST_POINT 
							FROM 
							TRAINING_CLASS_RESULTS
							WHERE 
								CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
								AND EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
							</cfquery>
						<tr>
							<td><a href="#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#class_id#" class="tableyazi" target="_blank">#CLASS_NAME#</a></td>
							<td>#CLASS_PLACE#</td>
							<td><cfif DATE_NO AND HOUR_NO>
								#DATE_NO# / #HOUR_NO#
							</cfif>
							</td>
							<td>#dateformat(START_DATE,dateformat_style)#-#dateformat(FINISH_DATE,dateformat_style)#</td>
							<td>
								<cfloop query="GET_TRAIN_CLASS_DT">
										#DateFormat(START_DATE,dateformat_style)#-
									<cfif len(ATTENDANCE_MAIN)>
										%#ATTENDANCE_MAIN#
										<cfelseif IS_EXCUSE_MAIN IS 1>
										#EXCUSE_MAIN#
									</cfif><br />
								</cfloop>
							</td>
							<td>#GET_TRAIN_CLASS_RESULTS.PRETEST_POINT#</td>
							<td>#GET_TRAIN_CLASS_RESULTS.FINALTEST_POINT#</td>
						</tr>
					</cfoutput>
					<cfelse>
					<tr>
					<td colspan="7"><cf_get_lang_main no='72.Kayit Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	
		<!--- <cf_medium_list_search title="Katılacağı Kesinleşen Eğitimler"></cf_medium_list_search> --->
		<!-- sil -->
		<cf_seperator title="#getLang('48','training_management',30902)#" id="detail_seperator">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="300"><cf_get_lang_main no='7.Katıldığı Eğitimler'></th>
					<th width="300">Eğitim Yeri</th>
					<th width="120"><cf_get_lang_main no='78.Gün'>/<cf_get_lang_main no='79.Saat'></th>
					<th width="85"><cf_get_lang_main no='89.Başlangıç'></th>
					<th width="85"><cf_get_lang_main no='90.Bitiş'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_trains.recordcount>
					<cfoutput query="get_trains" >
						<tr height="20">
							<td><a href="#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#class_id#" class="tableyazi" target="_blank">#CLASS_NAME#</a></td>
							<td>#CLASS_PLACE#</td>
							<td><cfif DATE_NO AND HOUR_NO>
								#DATE_NO# / #HOUR_NO#
							</cfif>
							</td>
							<td>#dateformat(START_DATE,dateformat_style)#</td>
							<td>#dateformat(FINISH_DATE,dateformat_style)#</td>
						</tr>
						</cfoutput>
						<cfelse>
						<tr height="20">
							<td colspan="6"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

    	<br/>
   
	<cf_seperator title="#getLang('training_management',389)#" id="detail_seperator">
    <cf_grid_list>
        <thead>
        <tr> 
            <th><cf_get_lang_main no='75.No'></th>
            <th><cf_get_lang_main no='7.Eğitim'></th>		
            <th><cf_get_lang_main no='74.Kategori'></th>		
            <th><cf_get_lang_main no='583.Bölüm'></th>
            <th><cf_get_lang no='29.Eğitim Şekli'></th>
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
              <td colspan="5"><cf_get_lang_main no='72.Kayit Bulunamadi'></td>
            </tr>
        </cfif>
        </tbody>
    </cf_grid_list>

</cf_box>
</div>
