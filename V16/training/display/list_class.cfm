<cf_get_lang_set module_name="training">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.online" default="">
<cfparam name="attributes.active" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfscript>
	get_training_cat_action = createObject("component","V16.training.cfc.get_training_cat");
	get_training_cat_action.dsn = dsn;
	get_training_cat = get_training_cat_action.get_training_cat_fnc
					(
						module_name : fusebox.circuit
					);
	get_training_sec_action = createObject("component","V16.training.cfc.get_training_sec_names");
	get_training_sec_action.dsn = dsn;
	get_training_sec = get_training_sec_action.get_training_sec_fnc
					(
						module_name : fusebox.circuit
					);
</cfscript>
<cfif isdefined('session.ep')>
	<cfquery name="get_emp_det" datasource="#dsn#">
		SELECT
			OC.COMP_ID,
			B.BRANCH_ID,
			D.DEPARTMENT_ID,
			EP.FUNC_ID,
			EP.POSITION_CAT_ID,
			EP.ORGANIZATION_STEP_ID
		FROM
			EMPLOYEE_POSITIONS EP,
			OUR_COMPANY OC,
			BRANCH B,
			DEPARTMENT D
		WHERE
			OC.COMP_ID = B.COMPANY_ID AND
			B.BRANCH_ID = D.BRANCH_ID AND
			D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
			EP.EMPLOYEE_ID = #session.ep.userid# AND
			EP.IS_MASTER = 1
	</cfquery>
<cfelse>
	<cfset get_emp_det.recordcount = 0>
</cfif>
<cfif get_emp_det.recordcount>
	<cfquery name="get_train_id" datasource="#DSN#">
		SELECT
			RELATION_FIELD_ID
		FROM
			RELATION_SEGMENT_TRAINING
		WHERE
			<cfif len(get_emp_det.COMP_ID)>
			(
				RELATION_ACTION = 1 AND
				RELATION_ACTION_ID = #get_emp_det.COMP_ID#
			) OR
			</cfif>
			<cfif len(get_emp_det.DEPARTMENT_ID)>
			(
				RELATION_ACTION = 2 AND
				RELATION_ACTION_ID = #get_emp_det.DEPARTMENT_ID#
			) OR
			</cfif>
			<cfif len(get_emp_det.POSITION_CAT_ID)>
			(
				RELATION_ACTION = 3 AND
				RELATION_ACTION_ID = #get_emp_det.POSITION_CAT_ID#
			) OR
			</cfif>
			<cfif len(get_emp_det.FUNC_ID)>
			(
				RELATION_ACTION = 5 AND
				RELATION_ACTION_ID = #get_emp_det.FUNC_ID#
			) OR
			</cfif>
			<cfif len(get_emp_det.ORGANIZATION_STEP_ID)>
			(
				RELATION_ACTION = 6 AND
				RELATION_ACTION_ID = #get_emp_det.ORGANIZATION_STEP_ID#
			) OR
			</cfif>
			<cfif len(get_emp_det.BRANCH_ID)>
			(
				RELATION_ACTION = 7 AND
				RELATION_ACTION_ID = #get_emp_det.BRANCH_ID#
			)
			</cfif>
	</cfquery>
	<cfset train_id_list = valuelist(get_train_id.RELATION_FIELD_ID)>
</cfif>
<cfquery name="class_sections" datasource="#dsn#">
	SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE CLASS_ID IS NOT NULL
</cfquery>
<cfset class_id_list = valuelist(class_sections.CLASS_ID)>
<cfif isdefined('session.ep')>
	<cfquery name="get_branchs" datasource="#dsn#">
		SELECT 
			BRANCH_ID,
			BRANCH_NAME 
		FROM 
			BRANCH
		WHERE
			BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #SESSION.EP.POSITION_CODE#	
						)
		ORDER BY BRANCH_ID
	</cfquery>
<cfelse>
	<cfset get_branchs.recordcount = 0>
</cfif>
<cfif get_branchs.recordcount>
	<cfset branch_id_list = listsort(valuelist(get_branchs.branch_id,','),"Numeric","Desc")>
<cfelse>
	<cfset branch_id_list = 0>
</cfif>
<cfif isdefined("attributes.is_submit")>
<cfif len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfquery name="get_class" datasource="#dsn#">
	SELECT DISTINCT
		TC.CLASS_ID,
		TC.CLASS_NAME,
		TC.CLASS_PLACE,
		<cfif database_type is 'MSSQL'>
			CAST(TC.CLASS_TARGET AS NVARCHAR(100)) AS CLASS_TARGET,
		<cfelse>
			CAST(TC.CLASS_TARGET AS VARGRAPHIC(100)) AS CLASS_TARGET,
		</cfif>
		TC.START_DATE,
		TC.FINISH_DATE,
		<!--- TC.TRAINER_EMP,
        TC.TRAINER_PAR,
        TC.TRAINER_CONS, --->
        TC.ONLINE
	FROM
		TRAINING_CLASS TC,
		TRAINING_CLASS_SECTIONS TCS
	<cfif isDefined("attributes.TRAINING_CAT_ID") AND attributes.TRAINING_CAT_ID NEQ 0>
		,TRAINING_CAT
		,TRAINING_SEC
	</cfif>
	WHERE
		TC.CLASS_ID = TCS.CLASS_ID
		AND TC.CLASS_ID IS NOT NULL
        <cfif isDefined("attributes.TRAINING_CAT_ID") AND attributes.TRAINING_CAT_ID NEQ 0>
			AND TC.TRAINING_SEC_ID=TRAINING_SEC.TRAINING_SEC_ID
			AND TRAINING_SEC.TRAINING_CAT_ID=TRAINING_CAT.TRAINING_CAT_ID
			AND TRAINING_CAT.TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#
		</cfif>
		<cfif isDefined("attributes.TRAINING_CAT_ID") and (attributes.TRAINING_CAT_ID NEQ 0)>
			AND TC.TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#
		</cfif>
		<cfif isDefined("attributes.TRAINING_SEC_ID") and (attributes.TRAINING_SEC_ID NEQ 0)>
			AND TC.TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#
		</cfif>
		<cfif get_emp_det.recordcount and listlen(train_id_list)>
			AND TCS.TRAIN_ID IN (#train_id_list#)
		</cfif>
		AND
		(
			<cfif isdefined('session.ep')>
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID IN (#branch_id_list#)))) OR
				<!--- TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS WHERE TRAINER_EMP = #session.ep.userid#) OR  --->
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #session.ep.userid#) OR
				TC.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER) OR 
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE EMP_ID = #session.ep.userid#) OR
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = #session.ep.userid#)
			<cfelseif isdefined('session.pp')>
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS WHERE TRAINER_PAR = #session.pp.userid#) OR 
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE PAR_ID = #session.pp.userid#) OR
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE PAR_ID = #session.pp.userid#) OR
				(
					TC.IS_INTERNET = 1 AND
					TC.CLASS_ID IN (
                    					<!---SELECT TRAINING_CLASS_ID FROM TRAINING_CLASS_SITE_DOMAIN WHERE SITE_DOMAIN = '#cgi.HTTP_HOST#' --->
                                        SELECT 
                                            TRAINING_CLASS_ID 
                                        FROM 
                                            TRAINING_CLASS_SITE_DOMAIN 
                                        WHERE 
                                            MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#">
                                    )
				)
			</cfif>
		)
        <cfif isDefined("attributes.online") and attributes.online eq 1>
			AND TC.ONLINE = 1
        <cfelseif isDefined("attributes.online") and attributes.online eq 2>
        	AND TC.ONLINE = 0
        </cfif>
		<cfif isdefined("attributes.active") and attributes.active eq 1>
        	AND TC.IS_ACTIVE = 1
        <cfelseif isdefined("attributes.active") and attributes.active eq 2>
        	AND TC.IS_ACTIVE=0
		</cfif>
		<cfif len(attributes.startdate) or len(attributes.finishdate)>
		<cfif len(attributes.startdate) and not len(attributes.finishdate)>
		 	AND	TC.START_DATE <= #attributes.startdate# 
			AND TC.FINISH_DATE >= #attributes.startdate#
		<cfelseif not len(attributes.startdate) and len(attributes.finishdate)>
			AND TC.START_DATE <= #attributes.finishdate# 
			AND TC.FINISH_DATE >= #attributes.finishdate#
		<cfelse>
		AND	(
				(
				TC.START_DATE <= #attributes.startdate# AND
				TC.FINISH_DATE >= #attributes.finishdate#
				)
				OR
				(
				TC.START_DATE >= #attributes.startdate# AND
				TC.START_DATE <= #attributes.finishdate#
				)
				OR
				(
				TC.FINISH_DATE >= #attributes.startdate# AND
				TC.FINISH_DATE <= #attributes.finishdate#
				)
			)
		</cfif>
		</cfif>
	UNION ALL 
	 SELECT
		TC.CLASS_ID,
		TC.CLASS_NAME,
		TC.CLASS_PLACE,
		<cfif database_type is 'MSSQL'>
			CAST(TC.CLASS_TARGET AS NVARCHAR(100)) AS CLASS_TARGET,
		<cfelse>
			CAST(TC.CLASS_TARGET AS VARGRAPHIC(100)) AS CLASS_TARGET,
		</cfif>
		TC.START_DATE,
		TC.FINISH_DATE,
		<!--- TC.TRAINER_EMP,
        TC.TRAINER_PAR,
        TC.TRAINER_CONS, --->
        TC.ONLINE
	FROM
		TRAINING_CLASS TC
	WHERE
		TC.CLASS_ID IS NOT NULL
		<cfif isDefined("attributes.TRAINING_CAT_ID") and (attributes.TRAINING_CAT_ID NEQ 0)>
			AND TC.TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#
		</cfif>
		<cfif isdefined("attributes.TRAINING_SEC_ID") and (attributes.TRAINING_SEC_ID NEQ 0)>
			AND TC.TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#
		</cfif>
		<cfif class_sections.recordcount and listlen(class_id_list)>AND TC.CLASS_ID NOT IN (#class_id_list#)</cfif>
		<cfif isdefined("attributes.CLASS_ID")>
			AND #attributes.CLASS_ID#
		</cfif>
		AND
		(
			<cfif isdefined('session.ep')>
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID IN (#branch_id_list#)))) OR
				<!--- TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS WHERE TRAINER_EMP = #session.ep.userid#) OR  --->
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #session.ep.userid#) OR
				TC.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER) OR
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE EMP_ID = #session.ep.userid#) OR
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = #session.ep.userid#)
			<cfelseif isdefined('session.pp')>
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS WHERE TRAINER_PAR = #session.pp.userid#) OR 
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE PAR_ID = #session.pp.userid#) OR
				TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE PAR_ID = #session.pp.userid#) OR
				(
					TC.IS_INTERNET = 1 AND
					TC.CLASS_ID IN (
                                        SELECT 
                                            TRAINING_CLASS_ID 
                                        FROM 
                                            TRAINING_CLASS_SITE_DOMAIN 
                                        WHERE 
                                            MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#">
                                    )
				)
			</cfif>
		)
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND TC.CLASS_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
        <cfif isDefined("attributes.online") and attributes.online eq 1>
			AND TC.ONLINE = 1
        <cfelseif isDefined("attributes.online") and attributes.online eq 2>
        	AND TC.ONLINE = 0
        </cfif>
        <cfif isDefined("attributes.active") and attributes.active eq 1>
        	AND TC.IS_ACTIVE=1
        <cfelseif isdefined("attributes.active") and attributes.active eq 2>
        	AND TC.IS_ACTIVE=0
		</cfif>
		<cfif len(attributes.startdate) or len(attributes.finishdate)>
		<cfif len(attributes.startdate) and not len(attributes.finishdate)>
		 	AND	TC.START_DATE <= #attributes.startdate# 
			AND TC.FINISH_DATE >= #attributes.startdate#
		<cfelseif not len(attributes.startdate) and len(attributes.finishdate)>
			AND TC.START_DATE <= #attributes.finishdate# 
			AND TC.FINISH_DATE >= #attributes.finishdate#
		<cfelse>
		AND	(
				(
				TC.START_DATE <= #attributes.startdate# AND
				TC.FINISH_DATE >= #attributes.finishdate#
				)
				OR
				(
				TC.START_DATE >= #attributes.startdate# AND
				TC.START_DATE <= #attributes.finishdate#
				)
				OR
				(
				TC.FINISH_DATE >= #attributes.startdate# AND
				TC.FINISH_DATE <= #attributes.finishdate#
				)
			)
		</cfif>
		</cfif>
		ORDER BY START_DATE DESC
</cfquery>
<cfelse>
	<cfset get_class.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfif isdefined('session.ep')>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_class.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form1" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_class">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cf_big_list_search title="#getLang('main',7)#"> 
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50"></td>
				<td>
					<select name="training_cat_id" id="training_cat_id" style="width:135px">
					<option value="0"><cf_get_lang_main no='74.Kategori'></option>
					<cfoutput query="get_training_cat">
					<option value="#training_cat_id#" <cfif isdefined("attributes.training_cat_id") and (attributes.training_cat_id eq training_cat_id)>selected</cfif>>#training_cat#</option>
					</cfoutput>
					</select>
				</td>
				<td>
					<select name="training_sec_id" id="training_sec_id" style="width:135px">
						<option value="0"><cf_get_lang_main no ='583.Bölüm'></option>
						<cfoutput query="get_training_sec">
							<option value="#training_sec_id#" <cfif isdefined("attributes.training_sec_id") and (attributes.training_sec_id eq training_sec_id)>selected</cfif>>#section_name#</option>
						</cfoutput>
					</select>
				</td>
				<td> 
					<select name="online" id="online">
					  <option value=""<cfif attributes.online is ""> selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
					  <option value="1"<cfif attributes.online is "1"> selected</cfif>><cf_get_lang_main no='2218.Online'></option>
					  <option value="2"<cfif attributes.online is "2"> selected</cfif>><cf_get_lang no='50.Online Değil'></option>
					</select>
				</td>
				<td>
					<select name="active" id="active">
						<option value="" <cfif attributes.active is "">selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
						<option value="1" <cfif attributes.active is "1">selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
						<option value="2" <cfif attributes.active is "2">selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
					</select>
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='326.başlangıç tarihi girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="startdate" id="startdate" style="width:65px;" value="#dateformat(attributes.startdate,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" >
					<cf_wrk_date_image date_field="startdate">
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='327.bitiş tarihi girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" value="#dateformat(attributes.finishdate,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" >
					<cf_wrk_date_image date_field="finishdate">
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;">
				</td>
				<td><cf_wrk_search_button search_function='kontrol()'></td>
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th style="width:15px;"><cf_get_lang_main no='1165. Sıra'></th>
			<th class="header_icn_text"><cf_get_lang_main no='2218.Online'></th>
			<th><cf_get_lang_main no='7.Eğitim'></th>
			<th width="100"><cf_get_lang no='16.Yer'></th>
			<th><cf_get_lang no='7.Amaç'></th>
			<th width="120"><cf_get_lang no='51.Eğitimci'></th>
			<th width="130"><cf_get_lang_main no='330.Tarih'></th>
	 	 </tr>
	 </thead>
	 <tbody>
		<cfif get_class.recordcount>
			<cfoutput query="get_class" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td align="center">
					  <cfquery name="get_trainer" datasource="#dsn#" maxrows="1">
					  	SELECT EMP_ID,PAR_ID,CONS_ID FROM TRAINING_CLASS_TRAINERS WHERE CLASS_ID = #class_id#
					  </cfquery>
					  <cfif Len(start_date) and (datediff('n',now(),start_date) lte 15) and Len(finish_date) and (datediff('n',now(),finish_date) gte 0) and online eq 1>
						<cfif (isdefined("flashComServerApplicationsPath")) and (len(flashComServerApplicationsPath))>
							<!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_online_white_board&class_id=#class_id#&trainer_emp=#trainer_emp#&trainer_par=#trainer_par#&trainer_cons=#trainer_cons#&educationName=#class_name#','white_board');"><img src="/images/onlineuser.gif" title="Canlı Yayın" align="absmiddle"></a> --->
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_online_white_board&class_id=#class_id#&trainer_emp=#get_trainer.emp_id#&trainer_par=#get_trainer.par_id#&trainer_cons=#get_trainer.cons_id#&educationName=#class_name#','white_board');"><img src="/images/instmes.gif" title="Canlı Yayın" align="absmiddle"></a>
						</cfif>
					  </cfif>
					</td>
					<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.view_class&class_id=#class_id#" class="tableyazi">#class_name#</a></td>
					<td>#class_place#</td>
					<td>#class_target#</td>
					<td>
						<!--- <cfif len(TRAINER_EMP)>
							#get_emp_info(TRAINER_EMP,0,1)#
						<cfelseif len(TRAINER_PAR)>
							#get_par_info(TRAINER_PAR,0,0,1)#
						<cfelseif len(TRAINER_CONS)>
							#get_cons_info(TRAINER_CONS,0,1)#
						</cfif> --->
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
					<td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
			</tr>
		</cfif>
		</tbody>
</cf_big_list>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.online)>
	<cfset url_str = "#url_str#&online=#attributes.online#">
</cfif>        
<cfif isdefined("attributes.training_cat_id") and len(attributes.training_cat_id)>
	<cfset url_str = "#url_str#&training_cat_id=#attributes.training_cat_id#">
</cfif>        
<cfif isdefined("attributes.training_sec_id") and len(attributes.training_sec_id)>
	<cfset url_str = "#url_str#&training_sec_id=#attributes.training_sec_id#">
</cfif> 
<cfif isdefined("attributes.is_submit")>
	<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
</cfif> 
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
</cfif> 
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
</cfif> 
<cf_paging
	page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#listgetat(attributes.fuseaction,1,'.')#.list_class#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
	{
		if(datediff(document.getElementById('startdate').value,document.getElementById('finishdate').value,0)<0)
		{
			alert("<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!");
			return false;
		}
		return true;
	}
</script>	
