<!--- Bu sayfanin amacini anlayamadim. Ayrıca CONT_BODY alani icin CONTAINS ile Fulltext Search arama yapmalı. BK 20130112 --->

<!---Değiştirilen Başlıklar--->
<cfif isdefined("attributes.heads")>	
	<cf_seperator title="#getLang('content',139)#" id="baslik_seperator">
	<div style="display:none;" id="baslik_seperator">
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57480.Konu'></th>
					<th ><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th ><cf_get_lang dictionary_id='57995.Bölüm'></th>
					<th ><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th ><i class="fa fa-pencil"></i></th>
				</tr>
			</thead>
			<tbody> 
				<cfquery name="GET_FOUND_CONTENTS" datasource="#DSN#">
					SELECT 
						C.CONTENT_ID,
						C.CONT_HEAD
					FROM 
						<cfif len(attributes.contentcat_id) and len(attributes.contentcat_name)>
							CONTENT_CHAPTER CC,
						</cfif>
						CONTENT C 
					WHERE 
						<cfif len(attributes.contentcat_id) and len(attributes.contentcat_name)>
							CC.CHAPTER_ID = C.CHAPTER_ID AND
							CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contentcat_id#"> AND
						</cfif>
						<cfif len(attributes.chapter_id) and len(attributes.chapter_name)>
							C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#"> AND
						</cfif>
						<cfif attributes.search_type eq 0>
							C.CONT_HEAD LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#%"> 
						<cfelseif attributes.search_type eq 1>
							(
								C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#"> OR
								C.CONT_HEAD LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#%"> OR
								C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#%"> OR
								C.CONT_HEADY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#">
							)
						<cfelseif attributes.search_type eq 2>
							(
								C.CONT_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#"> OR
								C.CONT_HEAD LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#%"> OR
								C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#%"> OR
								C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#"> OR
								C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#."> OR
								C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#,"> OR
								C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#!"> OR
								C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#?">
							)
						</cfif>
				</cfquery>
				<cfif not get_found_contents.recordcount>
					<tr>
						<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr> 
				<cfelse>
					<cfset baslik_count = 0> <!--- bu kontrol buyuk kucuk harf duyarliligi icin konuldu --->
					<cfset content_id_list = ''> <!--- bu kontrol buyuk kucuk harf duyarliligi icin konuldu --->
					<cfoutput query="get_found_contents">
						<cfif Find('#attributes.old_text#',cont_head)>
							<cfset baslik_count = baslik_count + 1>
							<cfset content_id_list = listappend(content_id_list,content_id)>
							<cfset myStr = replace(cont_head,attributes.old_text,attributes.new_text,'all')>
							<cfquery name="UPDATE_CONTENT_" datasource="#DSN#">
								UPDATE 
									CONTENT 
								SET 
									CONT_HEAD = #sql_unicode()#'#myStr#',
									UPD_COUNT = UPD_COUNT +1,
									UPDATE_MEMBER = #SESSION.EP.USERID#,					
									UPDATE_DATE = #NOW()#
								WHERE 
									CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_id#">
							</cfquery>
						</cfif>
					</cfoutput>
					<cfif baslik_count>
						<cfquery name="INSERT_HISTORY" datasource="#DSN#">
							INSERT INTO CONTENT_HISTORY
								(
									CONTENT_STATUS,
									CHAPTER_ID,
									CONTENT_ID,
									COMPANY_CAT,
									CONSUMER_CAT,
									POSITION_CAT_IDS,
									USER_GROUP_IDS,
									CAREER_VIEW,
									INTERNET_VIEW,
									EMPLOYEE_VIEW,
									CONT_POSITION,
									CONT_HEAD,
									CONT_SUMMARY,
									CONT_BODY,
									CONTENT_PROPERTY_ID,
									NONE_TREE,
									LASTVISIT,
									RECORD_DATE,
									RECORD_MEMBER,
									RECORD_IP,
									PRIORITY,
									UPD_COUNT,
									UPDATE_DATE,
									UPDATE_MEMBER,
									IS_VIEWED,
									VIEW_DATE_START,
									POSITION_ID,
									POSITION_CAT_ID,
									VIEW_DATE_FINISH,
									STAGE_ID,
									SPOT,
									HIT_EMPLOYEE,
									HIT_PARTNER
								)
							SELECT 
									CONTENT_STATUS,
									CHAPTER_ID,
									CONTENT_ID,
									COMPANY_CAT,
									CONSUMER_CAT,
									POSITION_CAT_IDS,
									USER_GROUP_IDS,
									CAREER_VIEW,
									INTERNET_VIEW,
									EMPLOYEE_VIEW,
									CONT_POSITION,
									CONT_HEAD,
									CONT_SUMMARY,
									CONT_BODY,
									CONTENT_PROPERTY_ID,
									NONE_TREE,
									LASTVISIT,
									RECORD_DATE,
									RECORD_MEMBER,
									RECORD_IP,
									PRIORITY,
									UPD_COUNT,
									UPDATE_DATE,
									UPDATE_MEMBER,
									IS_VIEWED,
									VIEW_DATE_START,
									POSITION_ID,
									POSITION_CAT_ID,
									VIEW_DATE_FINISH,
									STAGE_ID,
									SPOT,
									HIT_EMPLOYEE,
									HIT_PARTNER
							FROM CONTENT
							WHERE CONTENT_ID IN (#valuelist(get_found_contents.content_id)#)
						</cfquery>
						<cfquery name="GET_CONTENT" datasource="#DSN#">
							SELECT
								CCH.CONTENTCAT_ID, 
								CCH.CHAPTER,
								CC.CONTENTCAT, 
								C.CONTENT_ID,
								C.EMPLOYEE_VIEW,
								C.CONT_HEAD,
								C.CONT_SUMMARY,
								C.CONT_BODY,
								C.CONT_POSITION,
								C.CONSUMER_CAT,
								C.RECORD_MEMBER,
								C.COMPANY_CAT,
								C.CHAPTER_ID ,
								E.EMPLOYEE_NAME,
								E.EMPLOYEE_SURNAME,
								E.EMPLOYEE_EMAIL,
								E.EMPLOYEE_ID
							FROM
								CONTENT C ,
								CONTENT_CAT CC, 
								CONTENT_CHAPTER CCH,
								EMPLOYEES E
							WHERE
								C.CHAPTER_ID = CCH.CHAPTER_ID AND
								CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
								E.EMPLOYEE_ID = C.RECORD_MEMBER AND
								C.CONTENT_STATUS = 1 AND
								CONTENT_ID IN (#content_id_list#)
						</cfquery>
						<cfoutput query="get_content">
							<tr>
								<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.view_content&cntid=#content_id#" class="tableyazi">#cont_head#</a></td>
								<td>#contentcat#</td>
								<td>#chapter#</td>					
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
								<td><a href="#request.self#?fuseaction=content.list_content&event=det&cntid=#content_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
						</tr> 
					</cfif>
				</cfif>
			</tbody>
		</cf_flat_list>
	</div>
</cfif>
		
<!-- BASLIKLAR BITTI -->
<cfif isdefined("attributes.summary")>
	<cf_seperator title="#getLang('','Değiştirilen Özetler','50641')#" id="ozet_seperator">
	<div style="display:none;" id="ozet_seperator"><!---Değiştirilen Özetler--->
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57480.Konu'></th>
					<th ><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th ><cf_get_lang dictionary_id='57995.Bölüm'></th>
					<th ><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th ><i class="fa fa-pencil"></i></th>
				</tr>
			</thead>
			<tbody>
			<cfquery name="GET_FOUND_CONTENTS" datasource="#DSN#">
				SELECT 
					C.CONTENT_ID,
					C.CONT_SUMMARY
				FROM 
					<cfif len(attributes.contentcat_id) and len(attributes.contentcat_name)>
						CONTENT_CHAPTER CC,
					</cfif>
					CONTENT C 
				WHERE 
					<cfif len(attributes.contentcat_id) and len(attributes.contentcat_name)>
						CC.CHAPTER_ID = C.CHAPTER_ID AND
						CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contentcat_id#"> AND
					</cfif>
					<cfif len(attributes.chapter_id) and len(attributes.chapter_name)>
						C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#"> AND
					</cfif>
				<cfif attributes.search_type eq 0>
					C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#%">
				<cfelseif attributes.search_type eq 1>
					(
						C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#"> OR
						C.CONT_SUMMARY LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#%"> OR
						C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#%"> OR
						C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#">
					)
				<cfelseif attributes.search_type eq 2>
					(
						C.CONT_SUMMARY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#"> OR
						C.CONT_SUMMARY LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#%"> OR
						C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#%"> OR
						C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#"> OR
						C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#."> OR
						C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#,"> OR
						C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#!"> OR
						C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#?">
					)
				</cfif>
			</cfquery>
			<cfif not get_found_contents.recordcount>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			<cfelse>
				<cfset baslik_count = 0> <!--- bu kontrol buyuk kucuk harf duyarliligi icin konuldu --->
				<cfset content_id_list = ''> <!--- bu kontrol buyuk kucuk harf duyarliligi icin konuldu --->
				<cfoutput query="get_found_contents">
					<cfif Find('#attributes.old_text#',cont_summary)>
						<cfset baslik_count = baslik_count + 1>
						<cfset content_id_list = listappend(content_id_list,content_id)>
						<cfset myStr = replace(cont_summary,attributes.old_text,attributes.new_text,'all')>
					
						<cfquery name="UPDATE_CONTENT_" datasource="#DSN#">
							UPDATE 
								CONTENT 
							SET 
								CONT_SUMMARY = #sql_unicode()#'#myStr#',
								UPD_COUNT = UPD_COUNT +1,
								UPDATE_MEMBER = #SESSION.EP.USERID#,					
								UPDATE_DATE = #NOW()#
							WHERE 
								CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_id#">
						</cfquery>
					</cfif>
				</cfoutput>
				<cfif baslik_count>
					<cfquery name="INSERT_HISTORY" datasource="#DSN#">
						INSERT INTO CONTENT_HISTORY
							(
								CONTENT_STATUS,
								CHAPTER_ID,
								CONTENT_ID,
								COMPANY_CAT,
								CONSUMER_CAT,
								POSITION_CAT_IDS,
								USER_GROUP_IDS,
								CAREER_VIEW,
								INTERNET_VIEW,
								EMPLOYEE_VIEW,
								CONT_POSITION,
								CONT_HEAD,
								CONT_SUMMARY,
								CONT_BODY,
								CONTENT_PROPERTY_ID,
								NONE_TREE,
								LASTVISIT,
								RECORD_DATE,
								RECORD_MEMBER,
								RECORD_IP,
								PRIORITY,
								UPD_COUNT,
								UPDATE_DATE,
								UPDATE_MEMBER,
								IS_VIEWED,
								VIEW_DATE_START,
								POSITION_ID,
								POSITION_CAT_ID,
								VIEW_DATE_FINISH,
								STAGE_ID,
								SPOT,
								HIT_EMPLOYEE,
								HIT_PARTNER
							)
						SELECT 
								CONTENT_STATUS,
								CHAPTER_ID,
								CONTENT_ID,
								COMPANY_CAT,
								CONSUMER_CAT,
								POSITION_CAT_IDS,
								USER_GROUP_IDS,
								CAREER_VIEW,
								INTERNET_VIEW,
								EMPLOYEE_VIEW,
								CONT_POSITION,
								CONT_HEAD,
								CONT_SUMMARY,
								CONT_BODY,
								CONTENT_PROPERTY_ID,
								NONE_TREE,
								LASTVISIT,
								RECORD_DATE,
								RECORD_MEMBER,
								RECORD_IP,
								PRIORITY,
								UPD_COUNT,
								UPDATE_DATE,
								UPDATE_MEMBER,
								IS_VIEWED,
								VIEW_DATE_START,
								POSITION_ID,
								POSITION_CAT_ID,
								VIEW_DATE_FINISH,
								STAGE_ID,
								SPOT,
								HIT_EMPLOYEE,
								HIT_PARTNER
						FROM CONTENT
						WHERE CONTENT_ID IN (#valuelist(get_found_contents.CONTENT_ID)#)
					</cfquery>
					<cfquery name="GET_CONTENT" datasource="#DSN#">
						SELECT
							CCH.CONTENTCAT_ID, 
							CCH.CHAPTER,
							CC.CONTENTCAT, 
							C.CONTENT_ID,
							C.EMPLOYEE_VIEW,
							C.CONT_HEAD,
							C.CONT_SUMMARY,
							C.CONT_BODY,
							C.CONT_POSITION,
							C.CONSUMER_CAT,
							C.RECORD_MEMBER,
							C.COMPANY_CAT,
							C.CHAPTER_ID ,
							E.EMPLOYEE_NAME,
							E.EMPLOYEE_SURNAME,
							E.EMPLOYEE_EMAIL,
							E.EMPLOYEE_ID
						FROM
							CONTENT C ,
							CONTENT_CAT CC, 
							CONTENT_CHAPTER CCH,
							EMPLOYEES E
						WHERE
							C.CHAPTER_ID = CCH.CHAPTER_ID AND
							CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
							E.EMPLOYEE_ID = C.RECORD_MEMBER AND
							C.CONTENT_STATUS = 1 AND
							CONTENT_ID IN (#content_id_list#)
					</cfquery>
						<cfoutput query="get_content">
						<tr>
							<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.list_content&event=det&cntid=#content_id#" class="tableyazi">#cont_head#</a></td>
							<td>#contentcat#</td>
							<td>#chapter#</td>					
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
							<td ><a href="#request.self#?fuseaction=content.list_content&event=det&cntid=#content_id#"><i class="fa  fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
					</tr> 
				</cfif>
		</cfif>
		</tbody>
			</cf_flat_list>
	</div>
</cfif>
<!--- ozetler bitti --->
<cfif isdefined("attributes.contents")>
	<cf_seperator title="#getLang('','Değiştirilen İçerikler','50648')#" id="icerik_seperator">
		<div style="display:none;" id="icerik_seperator"><!---Değiştirilen İçerikler--->
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57480.Konu'></th>
					<th ><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th ><cf_get_lang dictionary_id='57995.Bölüm'></th>
					<th ><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><i class="fa  fa-pencil"></i></th>
				</tr>
			</thead>
			<tbody>
			<cfquery name="GET_FOUND_CONTENTS" datasource="#DSN#">
				SELECT 
					C.CONTENT_ID,
					C.CONT_BODY
				FROM 
					<cfif len(attributes.contentcat_id) and len(attributes.contentcat_name)>
						CONTENT_CHAPTER CC,
					</cfif>
					CONTENT C 
				WHERE 
					<cfif len(attributes.contentcat_id) and len(attributes.contentcat_name)>
						CC.CHAPTER_ID = C.CHAPTER_ID AND
						CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contentcat_id#"> AND
					</cfif>
					<cfif len(attributes.chapter_id) and len(attributes.chapter_name)>
						C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#"> AND
					</cfif>
					<cfif attributes.search_type eq 0>
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#%">
					<cfelseif attributes.search_type eq 1>
						(
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#"> OR
						C.CONT_BODY LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#%"> OR
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#%"> OR
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#">
						)
					<cfelseif attributes.search_type eq 2>
						(
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#"> OR
						C.CONT_BODY LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#%"> OR
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_text#%"> OR
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#"> OR
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#."> OR
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#,"> OR
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#!"> OR
						C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.old_text#?"> OR
						)
					</cfif>
			</cfquery>
			<cfif not get_found_contents.recordcount>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
				</tr>
			<cfelse>
				<cfset baslik_count = 0> <!--- bu kontrol buyuk kucuk harf duyarliligi icin konuldu --->
				<cfset content_id_list = ''> <!--- bu kontrol buyuk kucuk harf duyarliligi icin konuldu --->
				<cfoutput query="get_found_contents">
					<cfif Find('#attributes.old_text#',cont_body)>
						<cfset baslik_count = baslik_count + 1>
						<cfset content_id_list = listappend(content_id_list,content_id)>
						<cfset myStr = replace(cont_body,attributes.old_text,attributes.new_text,'all')>
						<cfquery name="UPDATE_CONTENT_" datasource="#DSN#">
							UPDATE 
								CONTENT 
							SET 
								CONT_BODY = #sql_unicode()#'#myStr#',
								UPD_COUNT = UPD_COUNT +1,
								UPDATE_MEMBER = #SESSION.EP.USERID#,					
								UPDATE_DATE = #NOW()#
							WHERE 
								CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_id#">
						</cfquery>
					</cfif>
				</cfoutput>
				<cfif baslik_count>
					<cfquery name="INSERT_HISTORY" datasource="#dsn#">
						INSERT INTO CONTENT_HISTORY
							(
									CONTENT_STATUS,
									CHAPTER_ID,
									CONTENT_ID,
									COMPANY_CAT,
									CONSUMER_CAT,
									POSITION_CAT_IDS,
									USER_GROUP_IDS,
									CAREER_VIEW,
									INTERNET_VIEW,
									EMPLOYEE_VIEW,
									CONT_POSITION,
									CONT_HEAD,
									CONT_SUMMARY,
									CONT_BODY,
									CONTENT_PROPERTY_ID,
									NONE_TREE,
									LASTVISIT,
									RECORD_DATE,
									RECORD_MEMBER,
									RECORD_IP,
									PRIORITY,
									UPD_COUNT,
									UPDATE_DATE,
									UPDATE_MEMBER,
									IS_VIEWED,
									VIEW_DATE_START,
									POSITION_ID,
									POSITION_CAT_ID,
									VIEW_DATE_FINISH,
									STAGE_ID,
									SPOT,
									HIT_EMPLOYEE,
									HIT_PARTNER
							)
						SELECT 
								CONTENT_STATUS,
								CHAPTER_ID,
								CONTENT_ID,
								COMPANY_CAT,
								CONSUMER_CAT,
								POSITION_CAT_IDS,
								USER_GROUP_IDS,
								CAREER_VIEW,
								INTERNET_VIEW,
								EMPLOYEE_VIEW,
								CONT_POSITION,
								CONT_HEAD,
								CONT_SUMMARY,
								CONT_BODY,
								CONTENT_PROPERTY_ID,
								NONE_TREE,
								LASTVISIT,
								RECORD_DATE,
								RECORD_MEMBER,
								RECORD_IP,
								PRIORITY,
								UPD_COUNT,
								UPDATE_DATE,
								UPDATE_MEMBER,
								IS_VIEWED,
								VIEW_DATE_START,
								POSITION_ID,
								POSITION_CAT_ID,
								VIEW_DATE_FINISH,
								STAGE_ID,
								SPOT,
								HIT_EMPLOYEE,
								HIT_PARTNER
						FROM CONTENT
						WHERE CONTENT_ID IN (#valuelist(get_found_contents.content_id)#)
					</cfquery>
					<cfquery name="GET_CONTENT" datasource="#DSN#">
						SELECT
							CCH.CONTENTCAT_ID, 
							CCH.CHAPTER,
							CC.CONTENTCAT, 
							C.CONTENT_ID,
							C.EMPLOYEE_VIEW,
							C.CONT_HEAD,
							C.CONT_SUMMARY,
							C.CONT_BODY,
							C.CONT_POSITION,
							C.CONSUMER_CAT,
							C.RECORD_MEMBER,
							C.COMPANY_CAT,
							C.CHAPTER_ID ,
							E.EMPLOYEE_NAME,
							E.EMPLOYEE_SURNAME,
							E.EMPLOYEE_EMAIL,
							E.EMPLOYEE_ID
						FROM
							CONTENT C ,
							CONTENT_CAT CC, 
							CONTENT_CHAPTER CCH,
							EMPLOYEES E
						WHERE
							C.CHAPTER_ID = CCH.CHAPTER_ID AND
							CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
							E.EMPLOYEE_ID = C.RECORD_MEMBER AND
							C.CONTENT_STATUS = 1 AND
							CONTENT_ID IN (#content_id_list#)
					</cfquery>
					<cfoutput query="get_content">
						<tr>
							<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.list_content&event=det&cntid=#content_id#" class="tableyazi">#cont_head#</a></td>
							<td>#contentcat#</td>
							<td>#chapter#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
							<td ><a href="#request.self#?fuseaction=content.list_content&event=det&cntid=#content_id#"><i class="fa  fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
		</cfif>
		</tbody>
		</cf_flat_list>
	</div>
</cfif>

