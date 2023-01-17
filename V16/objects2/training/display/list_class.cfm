<cf_get_lang_set module_name="training">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.online" default="">
<cfparam name="attributes.active" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfscript>
	get_training_cat_action = createObject("component","training.cfc.get_training_cat");
	get_training_cat_action.dsn = dsn;
	get_training_cat = get_training_cat_action.get_training_cat_fnc
					(
						module_name : fusebox.circuit
					);
	get_training_sec_action = createObject("component","training.cfc.get_training_sec_names");
	get_training_sec_action.dsn = dsn;
	get_training_sec = get_training_sec_action.get_training_sec_fnc
					(
						module_name : fusebox.circuit
					);
</cfscript>
<cfif isdefined('session.ep')>
	<cfquery name="GET_EMP_DET" datasource="#DSN#">
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
			EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
			EP.IS_MASTER = 1
	</cfquery>
<cfelse>
	<cfset get_emp_det.recordcount = 0>
</cfif>
<cfif get_emp_det.recordcount>
	<cfquery name="GET_TRAIN_ID" datasource="#DSN#">
		SELECT
			RELATION_FIELD_ID
		FROM
			RELATION_SEGMENT_TRAINING
		WHERE
			<cfif len(get_emp_det.comp_id)>
			(
				RELATION_ACTION = 1 AND
				RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.comp_id#">
			) OR
			</cfif>
			<cfif len(get_emp_det.department_id)>
			(
				RELATION_ACTION = 2 AND
				RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.department_id#">
			) OR
			</cfif>
			<cfif len(get_emp_det.position_cat_id)>
			(
				RELATION_ACTION = 3 AND
				RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.position_cat_id#">
			) OR
			</cfif>
			<cfif len(get_emp_det.func_id)>
			(
				RELATION_ACTION = 5 AND
				RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.func_id#">
			) OR
			</cfif>
			<cfif len(get_emp_det.organization_step_id)>
			(
				RELATION_ACTION = 6 AND
				RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.organization_step_id#">
			) OR
			</cfif>
			<cfif len(get_emp_det.branch_id)>
			(
				RELATION_ACTION = 7 AND
				RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.branch_id#">
			)
			</cfif>
	</cfquery>
	<cfset train_id_list = valuelist(get_train_id.relation_field_id)>
</cfif>
<cfquery name="CLASS_SECTIONS" datasource="#DSN#">
	SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE CLASS_ID IS NOT NULL
</cfquery>
<cfset class_id_list = valuelist(class_sections.class_id)>
<cfif isdefined('session.ep')>
	<cfquery name="GET_BRANCHS" datasource="#DSN#">
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
                                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">	
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
    <cfquery name="GET_CLASS" datasource="#DSN#">
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
            (SELECT TCT.EMP_ID FROM TRAINING_CLASS_TRAINERS TCT WHERE TCT.CLASS_ID = TC.CLASS_ID) AS TRAINER_EMP,
            (SELECT TCT.PAR_ID FROM TRAINING_CLASS_TRAINERS TCT WHERE TCT.CLASS_ID = TC.CLASS_ID) AS TRAINER_PAR,
            (SELECT TCT.CONS_ID FROM TRAINING_CLASS_TRAINERS TCT WHERE TCT.CLASS_ID = TC.CLASS_ID) AS TRAINER_CONS,
            TC.ONLINE
        FROM
            TRAINING_CLASS TC,
            TRAINING_CLASS_SECTIONS TCS
			<cfif isDefined("attributes.training_cat_id") AND attributes.training_cat_id neq 0>
                ,TRAINING_CAT
                ,TRAINING_SEC
            </cfif>
        WHERE
            TC.CLASS_ID = TCS.CLASS_ID
            AND TC.CLASS_ID IS NOT NULL
            <cfif isDefined("attributes.training_cat_id") AND attributes.training_cat_id neq 0>
                AND TC.TRAINING_SEC_ID=TRAINING_SEC.TRAINING_SEC_ID
                AND TRAINING_SEC.TRAINING_CAT_ID=TRAINING_CAT.TRAINING_CAT_ID
                AND TRAINING_CAT.TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat_id#">
            </cfif>
            <cfif isDefined("attributes.training_cat_id") and (attributes.training_cat_id neq 0)>
                AND TC.TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat_id#">
            </cfif>
            <cfif isDefined("attributes.training_sec_id") and (attributes.training_sec_id neq 0)>
                AND TC.TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_sec_id#">
            </cfif>
            <cfif get_emp_det.recordcount and listlen(train_id_list)>
                AND TCS.TRAIN_ID IN (#train_id_list#)
            </cfif>
            AND
            (
                <cfif isdefined('session.ep')>
                    TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID IN (#branch_id_list#)))) OR
                    TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) OR 
                    TC.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER) OR 
                    TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) OR
                    TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
                <cfelseif isdefined('session.pp')>
                    TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">) OR 
                    TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">) OR
                    TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">) OR
                    (
                        TC.IS_INTERNET = 1 AND
                        TC.CLASS_ID IN (
                                            SELECT 
                                                TRAINING_CLASS_ID 
                                            FROM 
                                                TRAINING_CLASS_SITE_DOMAIN 
                                            WHERE 
                                            	MENU_ID = <cfif isDefined('session.pp.menu_id')>
                                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#">
                                                             <cfelse>
                                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#">
                                                             </cfif>
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
                (SELECT TCT.EMP_ID FROM TRAINING_CLASS_TRAINERS TCT WHERE TCT.CLASS_ID = TC.CLASS_ID) AS TRAINER_EMP,
                (SELECT TCT.PAR_ID FROM TRAINING_CLASS_TRAINERS TCT WHERE TCT.CLASS_ID = TC.CLASS_ID) AS TRAINER_PAR,
                (SELECT TCT.CONS_ID FROM TRAINING_CLASS_TRAINERS TCT WHERE TCT.CLASS_ID = TC.CLASS_ID) AS TRAINER_CONS,
                TC.ONLINE
            FROM
                TRAINING_CLASS TC
            WHERE
                TC.CLASS_ID IS NOT NULL
                <cfif isDefined("attributes.training_cat_id") and (attributes.training_cat_id neq 0)>
                    AND TC.TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat_id#">
                </cfif>
                <cfif isdefined("attributes.training_sec_id") and (attributes.training_sec_id neq 0)>
                    AND TC.TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_sec_id#">
                </cfif>
                <cfif class_sections.recordcount and listlen(class_id_list)>AND TC.CLASS_ID NOT IN (#class_id_list#)</cfif>
                <cfif isdefined("attributes.class_id")>
                    AND <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
                </cfif>
                AND
                (
                    <cfif isdefined('session.ep')>
                        TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID IN (#branch_id_list#)))) OR
                        TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) OR 
                        TC.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER) OR
                        TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) OR
                        TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
                    <cfelseif isdefined('session.pp')>
                        TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">) OR 
                        TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">) OR
                        TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">) OR
                        (
                            TC.IS_INTERNET = 1 AND
                            TC.CLASS_ID IN (
                                                SELECT 
                                                    TRAINING_CLASS_ID 
                                                FROM 
                                                    TRAINING_CLASS_SITE_DOMAIN 
                                                WHERE 
                                                    MENU_ID = <cfif isDefined('session.pp.menu_id')>
                                                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#">
                                                                 <cfelse>
                                                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#">
                                                                 </cfif>                            			
                            				)
                        )
                    </cfif>
                )
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    AND TC.CLASS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
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
    <table align="right">
        <tr>
            <td><cf_get_lang_main no='48.Filtre'></td>
            <td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"></td>
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
                <cfinput type="text" name="startdate" id="startdate" style="width:65px;" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" maxlength="10" validate="eurodate" message="#message#" >
                <cf_wrk_date_image date_field="startdate">
            </td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no='327.bitiş tarihi girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" maxlength="10" validate="eurodate" message="#message#" >
                <cf_wrk_date_image date_field="finishdate">
            </td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;">
            </td>
            <td><cf_wrk_search_button search_function='kontrol()'></td>
        </tr>
    </table>
</cfform>

<table class="color-list" style="width:100%;">
	<thead>
		<tr class="color-header">
			<th class="form-title" style="width:35px;"><cf_get_lang_main no='1165. Sıra'></th>
			<th class="form-title" style="width:20px;">&nbsp;</th>
			<th class="form-title"><cf_get_lang no='15.Ders'></th>
			<th class="form-title" style="width:100px;"><cf_get_lang no='16.Yer'></th>
			<th class="form-title"><cf_get_lang no='7.Amaç'></th>
			<th class="form-title" style="width:120px;"><cf_get_lang no='51.Eğitimci'></th>
			<th class="form-title" style="width:130px;"><cf_get_lang_main no='330.Tarih'></th>
	 	 </tr>
	 </thead>
	 <tbody>
		<cfif get_class.recordcount>
			<cfoutput query="get_class" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr class="color-row">
					<td>#currentrow#</td>
					<td align="center">
					  <cfif Len(start_date) and (datediff('n',now(),start_date) lte 15) and Len(finish_date) and (datediff('n',now(),finish_date) gte 0) and online eq 1>
						<cfif (isdefined("flashComServerApplicationsPath")) and (len(flashComServerApplicationsPath))>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_online_white_board&class_id=#class_id#&trainer_emp=#trainer_emp#&trainer_par=#trainer_par#&trainer_cons=#trainer_cons#&educationName=#class_name#','white_board');"><img src="/images/onlineuser.gif" title="Canlı Yayın" align="absmiddle"></a>
						</cfif>
					  </cfif>
					</td>
					<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.view_class&class_id=#class_id#" class="tableyazi">#class_name#</a></td>
					<td>#class_place#</td>
					<td>#class_target#</td>
					<td>
						<cfif len(trainer_emp)>
							#get_emp_info(trainer_emp,0,1)#
						<cfelseif len(trainer_par)>
							#get_par_info(trainer_par,0,0,1)#
						<cfelseif len(trainer_cons)>
							#get_cons_info(trainer_cons,0,1)#
						</cfif>
					</td>
					<td>#dateformat(start_date,'dd/mm/yyyy')# - #dateformat(finish_date,'dd/mm/yyyy')#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</table>

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
	<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#">
</cfif> 
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
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
