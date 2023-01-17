<cfquery name="GET_CLASS_ATTENDAR_EMP" datasource="#dsn#">
    SELECT 
        TRAINING_GROUP_ID, 
        EMP_ID, 
        COMP_ID, 
        STATUS
    FROM 
        TRAINING_GROUP_ATTENDERS AS TC
	WHERE
		TRAINING_GROUP_ID = #attributes.TRAIN_GROUP_ID#
</cfquery>
<cfquery name="GET_CLASS_PROPERTY" datasource="#dsn#">
	SELECT
		TCG.GROUP_HEAD AS CLASS_NAME,
		TCG.START_DATE,
		TCG.FINISH_DATE
	FROM
		TRAINING_CLASS_GROUPS AS TCG
	WHERE
		TRAIN_GROUP_ID = #attributes.TRAIN_GROUP_ID#
</cfquery>
<cf_box title="#getLang('training_management',330)#">
<!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
	<cf_grid_list>
		<thead>
			<tr>
				<th nowrap><cf_get_lang_main no='158.Ad Soyad'></th>
				<cfif isdefined("attributes.levelid_1")>
					<th nowrap><cf_get_lang no='344.Yaş'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_2")>
					<th nowrap><cf_get_lang no='332.Medeni Hal'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_3")>
					<th nowrap><cf_get_lang_main no='352.Cinsiyet'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_4")>
					<th nowrap><cf_get_lang no='338.Askerlik'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_5")>
					<th nowrap><cf_get_lang no='345.Öğrenim Seviyesi'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_6")>
					<th nowrap><cf_get_lang no='346.Yabancı Dil'>1/ <cf_get_lang no='347.Seviye'></th>
					<th nowrap><cf_get_lang no='346.Yabancı Dil'>2/ <cf_get_lang no='347.Seviye'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_7")>
					<th nowrap><cf_get_lang no='348.Lisans/Fakülte/Üniversite'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_8")>
					<th nowrap><cf_get_lang no='349.Yüksek Lisans/Üniversite'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_9")>
					<th nowrap><cf_get_lang no='350.Kurs'> 1</th>
					<th nowrap><cf_get_lang no='350.Kurs'> 2</th>
					<th nowrap><cf_get_lang no='350.Kurs'> 3</th>
				</cfif>
				<cfif isdefined("attributes.levelid_10")>
					<th nowrap><cf_get_lang no='351.Tecrübe'> 1/<cf_get_lang_main no='1085.Pozisyon'></th>
					<th nowrap><cf_get_lang no='351.Tecrübe'> 2/<cf_get_lang_main no='1085.Pozisyon'></th>
					<th nowrap><cf_get_lang no='351.Tecrübe'> 3/<cf_get_lang_main no='1085.Pozisyon'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_11")>
					<th nowrap><cf_get_lang no='352.Şirket/Şube/Departman'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_12")>
					<th nowrap><cf_get_lang_main no='159.Ünvan'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_13")>
					<th nowrap><cf_get_lang_main no='1085.Pozisyon'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_14")>
					<th nowrap><cf_get_lang no='353.Gruba Giriş Tarihi'></th>
				</cfif>
				<cfif isdefined("attributes.levelid_15")>
					<th nowrap>Katılımcı Notu</th>
				</cfif>
			</tr>
		</thead>
		<tbody>
			<cfset i=0>
			<cfset toplam_yas=0>
			<cfset j=0>
			<cfset k=0>
			<cfset m=0>
			<cfset n=0>
			<cfset yapti=0>
			<cfset yapmadi=0>
			<cfset muaf=0>
			<cfset yabanci=0>
			<cfset tecilli=0>
			<cfloop query="GET_CLASS_ATTENDAR_EMP">
				<cfif len(GET_CLASS_ATTENDAR_EMP.EMP_ID)><!--- sadece çalışan için bunun kurumsal ve bireysel katılımcılar icinde yapılması gerekliii --->
					<cfquery name="GET_CLASS_ATTENDAR_NAME" datasource="#dsn#">
						SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, GROUP_STARTDATE FROM EMPLOYEES WHERE EMPLOYEE_ID = #GET_CLASS_ATTENDAR_EMP.EMP_ID#
					</cfquery>
					<cfquery NAME="GET_ATTENDER_IDENTY" DATASOURCE="#DSN#">
						SELECT 
							EI.BIRTH_DATE, 
							EI.MARRIED, 
							ED.SEX, 
							ED.MILITARY_STATUS,
							ED.KURS1,
							ED.KURS2, 
							ED.KURS3, 
							ED.LAST_SCHOOL
						FROM 
							EMPLOYEES_IDENTY AS EI, 
							EMPLOYEES_DETAIL AS ED 
						WHERE 
							EI.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
							EI.EMPLOYEE_ID = #GET_CLASS_ATTENDAR_EMP.EMP_ID#
					</cfquery>
					<cfquery name="get_language" datasource="#dsn#" maxrows="2">
						SELECT LANG_ID,LANG_WHERE,LANG_WRITE,LANG_SPEAK,LANG_MEAN FROM EMPLOYEES_APP_LANGUAGE WHERE EMPLOYEE_ID = #GET_CLASS_ATTENDAR_EMP.EMP_ID# 
					</cfquery>
					<cfquery name="get_attender_identy_work" datasource="#dsn#" maxrows="3">
						SELECT EXP, EXP_POSITION FROM EMPLOYEES_APP_WORK_INFO WHERE EMPLOYEE_ID = #GET_CLASS_ATTENDAR_EMP.EMP_ID#
					</cfquery>
					<cfquery NAME="GET_ATTENDER_POSITION" DATASOURCE="#DSN#">
						SELECT
							EP.POSITION_NAME,
							EP.DEPARTMENT_ID,
							EP.POSITION_CAT_ID
						FROM
							EMPLOYEE_POSITIONS AS EP
						WHERE
							EP.EMPLOYEE_ID = #GET_CLASS_ATTENDAR_EMP.EMP_ID# AND
							EP.IS_MASTER = 1
					</cfquery>
					<cfif GET_ATTENDER_POSITION.RecordCount>
						<cfquery NAME="GET_ATTENDART_DEPARTMENT" DATASOURCE="#DSN#">
							SELECT
								DEPARTMENT.DEPARTMENT_ID,
								DEPARTMENT.DEPARTMENT_HEAD,
								BRANCH.BRANCH_ID,
								BRANCH.BRANCH_NAME,
								OUR_COMPANY.COMP_ID,
								OUR_COMPANY.NICK_NAME
							FROM
								DEPARTMENT,
								BRANCH,
								OUR_COMPANY
							WHERE
								DEPARTMENT.DEPARTMENT_ID = #GET_ATTENDER_POSITION.DEPARTMENT_ID# AND
								BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
								OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
						</cfquery>
						<cfoutput>
						<tr height="20" class="color-row">
							<td>#GET_CLASS_ATTENDAR_NAME.EMPLOYEE_NAME#&nbsp;#GET_CLASS_ATTENDAR_NAME.EMPLOYEE_SURNAME#</td> 
							<cfif isdefined("attributes.levelid_1")>
								<td><cfif len(GET_ATTENDER_IDENTY.BIRTH_DATE)>
										<cfset yas=year("#NOW()#") - year("#GET_ATTENDER_IDENTY.BIRTH_DATE#")>
										#YAS#
										<cfset toplam_yas=toplam_yas+yas>
										<cfset i=i+1>
									</cfif>
								</td>
							</cfif>
							<cfif isdefined("attributes.levelid_2")>
								<td><cfif GET_ATTENDER_IDENTY.MARRIED eq 1><cf_get_lang no='333.Evli'></cfif>
									<cfif GET_ATTENDER_IDENTY.MARRIED eq 0><cf_get_lang no='334.Bekar'></cfif>
									<cfif len(GET_ATTENDER_IDENTY.MARRIED)>
										<cfif GET_ATTENDER_IDENTY.MARRIED eq 1>
											<cfset j=j+1>
										<cfelse>
											<cfset k=k+1>
										</cfif>
									</cfif>
								</td>
							</cfif>
							<cfif isdefined("attributes.levelid_3")>
								<td><cfif GET_ATTENDER_IDENTY.SEX eq 1><cf_get_lang_main no='1547.Erkek'></cfif>        
									<cfif GET_ATTENDER_IDENTY.SEX eq 0><cf_get_lang_main no='1546.Kadın'></cfif>        
									<cfif len(GET_ATTENDER_IDENTY.SEX)>
										<cfif GET_ATTENDER_IDENTY.SEX eq 1>
											<cfset m=m+1>
										<cfelse>
											<cfset n=n+1>
										</cfif>
									</cfif>
								</td>
							</cfif>
							<cfif isdefined("attributes.levelid_4")>
								<td><cfif len(GET_ATTENDER_IDENTY.MILITARY_STATUS)>
										<cfif GET_ATTENDER_IDENTY.MILITARY_STATUS eq 0>
											<cf_get_lang no='340.Yapmadı'>
											<cfset yapmadi=yapmadi+1>
										</cfif>
										<cfif GET_ATTENDER_IDENTY.MILITARY_STATUS eq 1>
											<cf_get_lang no='339.Yaptı'>
											<cfset yapti=yapti+1>
										</cfif>
										<cfif GET_ATTENDER_IDENTY.MILITARY_STATUS eq 2>
											<cf_get_lang no='341.Muaf'>
											<cfset muaf=muaf+1>
										</cfif>
										<cfif GET_ATTENDER_IDENTY.MILITARY_STATUS eq 3>
											<cf_get_lang no='343.Yabancı'>
											<cfset yabanci=yabanci+1>
										</cfif>
										<cfif GET_ATTENDER_IDENTY.MILITARY_STATUS eq 4>
											<cf_get_lang no='342.Tecilli'>
											<cfset tecilli=tecilli+1>
										</cfif>
									</cfif>
								</td>
							</cfif>
							<cfif isdefined("attributes.levelid_5")>
								<td><cfif len(GET_ATTENDER_IDENTY.LAST_SCHOOL)>
										<cfquery NAME="GET_ATTENDER_SCHOOL" DATASOURCE="#DSN#">
											SELECT 
												EDU_LEVEL_ID, 
												EDUCATION_NAME, 
												EDU_TYPE
											FROM 
												SETUP_EDUCATION_LEVEL 
											WHERE 
												EDU_LEVEL_ID = #GET_ATTENDER_IDENTY.LAST_SCHOOL#
										</cfquery>
										#GET_ATTENDER_SCHOOL.EDUCATION_NAME#
									</cfif>
								</td>
							</cfif>
							<cfif isdefined("attributes.levelid_6")>
								<cfif get_language.recordcount>
									<cfloop query="get_language">
									<td>
										<cfquery name="GET_LANG_SET" datasource="#dsn#">
											SELECT LANGUAGE_SET FROM SETUP_LANGUAGES WHERE LANGUAGE_ID = #lang_id#		
										</cfquery>
										#GET_LANG_SET.LANGUAGE_SET#
										/
										<cfquery name="get_level" datasource="#dsn#">
											SELECT KNOWLEVEL_ID,KNOWLEVEL FROM SETUP_KNOWLEVEL WHERE KNOWLEVEL_ID = #LANG_SPEAK#
										</cfquery>
										#get_level.KNOWLEVEL#
									</td>
									</cfloop>
								<cfif get_language.recordcount eq 1><td></td></cfif>
								<cfelse>
									<td></td>
									<td></td>
								</cfif>		
							</cfif>
							<cfif isdefined("attributes.levelid_7")>
								<td><cfquery name="get_school_" datasource="#dsn#" maxrows="1">
										SELECT 
											EMPLOYEE_ID, 
											EDU_TYPE, 
											EDU_NAME, 
											EDU_PART_NAME, 
											EDU_START 
										FROM 
											EMPLOYEES_APP_EDU_INFO 
										WHERE 
											EMPLOYEE_ID = #GET_CLASS_ATTENDAR_EMP.EMP_ID# AND EDU_TYPE = 4 ORDER BY EDU_START DESC
									</cfquery>
									<cfif get_school_.recordcount>#get_school_.edu_name#/ #get_school_.edu_part_name#</cfif>
								</td>
							</cfif>
							<cfif isdefined("attributes.levelid_8")>
								<td><cfquery name="get_school_2" datasource="#dsn#">
										SELECT 
											EMPLOYEE_ID, 
											EDU_TYPE, 
											EDU_NAME, 
											EDU_PART_NAME, 
											EDU_START 
										FROM 
											EMPLOYEES_APP_EDU_INFO 
										WHERE 
											EMPLOYEE_ID = #GET_CLASS_ATTENDAR_EMP.EMP_ID# AND EDU_TYPE = 5
									</cfquery>
									<cfif get_school_2.recordcount>#get_school_2.edu_name#/ #get_school_2.edu_part_name#</cfif>
								</td>
							</cfif>
							<cfif isdefined("attributes.levelid_9")>
								<td width="100">#GET_ATTENDER_IDENTY.KURS1#</td>
								<td width="100">#GET_ATTENDER_IDENTY.KURS2#</td>
								<td width="100">#GET_ATTENDER_IDENTY.KURS3#</td>
							</cfif>
							<cfif isdefined("attributes.levelid_10")>
								<cfloop from="1" to="3" index="w">
									<td><cfif len(get_attender_identy_work.EXP[w])>#get_attender_identy_work.EXP[w]#/ #get_attender_identy_work.EXP_POSITION[w]#<cfelse>&nbsp;</cfif></td>
								</cfloop>
							</cfif>
							<cfif isdefined("attributes.levelid_11")>
								<td>#GET_ATTENDART_DEPARTMENT.NICK_NAME#/ #GET_ATTENDART_DEPARTMENT.BRANCH_NAME#/ #GET_ATTENDART_DEPARTMENT.DEPARTMENT_HEAD#</td>
							</cfif>
							<cfif isdefined("attributes.levelid_12")>
								<td><cfif len(GET_ATTENDER_POSITION.POSITION_CAT_ID)>
										<cfquery NAME="GET_POSITION_ATTENDER_CAT" DATASOURCE="#DSN#">
											SELECT 
												POSITION_CAT_ID, 
												POSITION_CAT
											FROM 
												SETUP_POSITION_CAT 
											WHERE 
												POSITION_CAT_ID = #GET_ATTENDER_POSITION.POSITION_CAT_ID#
										</cfquery>
										#GET_POSITION_ATTENDER_CAT.POSITION_CAT#
									</cfif>
								</td>
							</cfif>
							<cfif isdefined("attributes.levelid_13")>
								<td>#GET_ATTENDER_POSITION.POSITION_NAME#</td>
							</cfif>
							<cfif isdefined("attributes.levelid_14")>
								<td>#dateformat(GET_CLASS_ATTENDAR_NAME.GROUP_STARTDATE,dateformat_style)#</td>
							</cfif>
						</tr>
						</cfoutput>
					</cfif>
				</cfif>
			</cfloop>
		</tbody>
	</cf_grid_list>
</cf_box>