<cf_xml_page_edit fuseact="myhome.list_my_extra_worktimes">
<cfparam name="attributes.emp_name" default="get_emp_info(session.ep.userid,0,0)">
<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfset is_approve_min = 0>
<cfset not_approve_min = 0>
<cfset minutesRemaining = 0>
<cfset hours = 0>
<cfset minutes = 0>
<cfset minutesRemaining_notapprove = 0>
<cfset hours_notapprove = 0>
<cfset minutes_notapprove = 0>
<cfset minutesRemaining_total = 0>
<cfset hours_total = 0>
<cfset minutes_total = 0>
<cfset pos_code_list = valuelist(get_emp_pos.position_code)>
<!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
<cfquery name="Get_Offtime_Valid" datasource="#dsn#">
	SELECT
		O.EMPLOYEE_ID,
		EP.POSITION_CODE
	FROM
		OFFTIME O,
		EMPLOYEE_POSITIONS EP
	WHERE
		O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
		O.VALID = 1 AND
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN O.STARTDATE AND O.FINISHDATE
</cfquery>
<cfif Get_Offtime_Valid.recordcount>
	<cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
	<cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
	</cfquery>
	<cfoutput query="Get_StandBy_Position1">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
	</cfquery>
	<cfoutput query="Get_StandBy_Position2">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_3 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
	</cfquery>
	<cfoutput query="Get_StandBy_Position3">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
	</cfoutput>
</cfif>
<cfset puantaj_gun_ = daysinmonth(now())>
<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(year(now()),month(now()),1))>
<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(year(now()),month(now()),puantaj_gun_)))>
<cfset gecen_ay_ = date_add("m",-1,puantaj_start_)>
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfparam name="attributes.startdate" default="">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfparam name="attributes.finishdate" default="">
</cfif>
<cfquery name="get_ext_worktimes" datasource="#dsn#">
    SELECT
		EMPLOYEES_EXT_WORKTIMES.*,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		BRANCH.BRANCH_NAME,
        (SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = EMPLOYEES_EXT_WORKTIMES.PROCESS_STAGE ) as STAGE
	FROM
		EMPLOYEES_EXT_WORKTIMES,
		EMPLOYEES,
		BRANCH,
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES_EXT_WORKTIMES.EMPLOYEE_ID
		AND EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_EXT_WORKTIMES.IN_OUT_ID
		AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
        <cfif isdefined("attributes.startdate") and len(attributes.startdate) or isdefined("attributes.finishdate") and len(attributes.finishdate)>
        	 <cfif len(attributes.startdate) and len(attributes.finishdate)>
               AND  (
                    (
                    EMPLOYEES_EXT_WORKTIMES.WORK_START_TIME >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.STARTDATE#"> AND
                    EMPLOYEES_EXT_WORKTIMES.WORK_START_TIME < <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD("d",1,attributes.FINISHDATE)#">
                    )
                OR
                    (
                    EMPLOYEES_EXT_WORKTIMES.WORK_START_TIME >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.STARTDATE#"> AND
                    EMPLOYEES_EXT_WORKTIMES.WORK_END_TIME <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.STARTDATE#">
                    )
                )
            <cfelseif len(attributes.FINISHDATE)>
                <!--- SADECE BITIŞ --->                
               AND (
                EMPLOYEES_EXT_WORKTIMES.WORK_END_TIME < <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD("d",1,attributes.FINISHDATE)#">
                OR
                    (
                    EMPLOYEES_EXT_WORKTIMES.WORK_END_TIME <= <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD("d",1,attributes.FINISHDATE)#"> AND
                    EMPLOYEES_EXT_WORKTIMES.WORK_END_TIME  > <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD("d",1,attributes.FINISHDATE)#">
                    )
                )
            </cfif>
        <cfelse>
			AND EMPLOYEES_EXT_WORKTIMES.START_TIME BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> 
        </cfif>
        ORDER BY
		EMPLOYEES_EXT_WORKTIMES.START_TIME DESC,
		EMPLOYEES_EXT_WORKTIMES.RECORD_DATE DESC,		
		EMPLOYEES.EMPLOYEE_NAME ASC,
		EMPLOYEES.EMPLOYEE_SURNAME ASC
</cfquery>

<cfparam name="attributes.startrow" default="" />
<cfparam name="attributes.page" default="1" />
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#" />
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1 />
<cfparam name="attributes.totalrecords" default='#get_ext_worktimes.recordCount#' />
<cfsavecontent variable="title"><cf_get_lang dictionary_id='31454.Fazla Mesailerim'></cfsavecontent>
<cf_box title="" closable="0" collapsable="1">
    <cfform name="list_ext_worktimes" action="#request.self#?fuseaction=myhome.list_my_extra_times" method="post">
        <cf_box_search more="0">
            <cfinput id="is_form_submitted" name="is_form_submitted" type="hidden">
            <div class="form-group" id="item-startdate">
                <div class="input-group">
                    <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#getLang('','Başlangıç Tarihi girmelisiniz',57738)#" maxlength="10">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                </div>
            </div>    
            <div class="form-group" id="item-finishdate">
                <div class="input-group">
                    <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="#getLang('','Bitiş Tarihi girmelisiniz',57739)#" maxlength="10">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                </div>
            </div>   
            <div class="form-group small">
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
            </div> 
            <div class="form-group">
                <cf_wrk_search_button search_function='kontrol()' button_type="4">
            </div>
        </cf_box_search>
    </cfform>
</cf_box>
<cf_box title="#getLang('','Fazla Mesailerim',31454)#" id="list_extra_worktimes" add_href="#request.self#?fuseaction=myhome.list_my_extra_times&event=add"  closable="0" collapsable="1">
    <cf_flat_list>
        <div id="extra_list">
            <thead>
                <tr> 	
                    <th></th>	  
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th width="90"><cf_get_lang dictionary_id='58859.Süreç'></th>
                    <th width="65"><cf_get_lang dictionary_id='48233.Mesai Durumu'></th>
                    <th width="65"><cf_get_lang dictionary_id='55753.Çalışma Günü'></th>
                    <th width="40"><cf_get_lang dictionary_id='55538.Çalışma Başlangıç'></th>
                    <th width="40"><cf_get_lang dictionary_id='55555.Çalışma Bitiş'></th>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='31471.Fark (dk)'></th>
                    <th width="125"><cf_get_lang dictionary_id='57982.Tür'></th>
                    <!--- <th width="65"><cf_get_lang dictionary_id='330.Tarih'></th> --->
                    <th width="65"><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <cfif xml_onay eq 1>
                        <th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
                    </cfif>
                    <th></th>
                </tr>
            </thead>
            <tbody>           
                <cfif get_ext_worktimes.recordcount>
                <cfoutput query="get_ext_worktimes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" > 
                    <tr>
                        <td>#currentRow#</td>		
                        <td>#employee_name# #employee_surname#</td>	  
                        <td>#STAGE#</td>  
                        <td><cfif isdefined("WORKTIME_WAGE_STATU") and WORKTIME_WAGE_STATU eq 1>
                                <cf_get_lang dictionary_id='38380.Serbest'>
                            <cfelseif isdefined("WORKTIME_WAGE_STATU") and WORKTIME_WAGE_STATU eq 2>
                                <cf_get_lang dictionary_id='42462.Ucretli'>
                            <cfelse>
                                <cf_get_lang dictionary_id='38380.Serbest'> 
                            </cfif>
                        </td>
                        <td>#dateformat(WORK_START_TIME,dateformat_style)#</td>
                        <td>#TIMEFORMAT(WORK_START_TIME,timeformat_style)#</td>
                        <td>#TIMEFORMAT(WORK_END_TIME,timeformat_style)#</td>
                        <td>#datediff("n",START_TIME,END_TIME)#</td>
                        <td><cfif day_type eq 0><cf_get_lang dictionary_id='31474.Normal Gün'><cfelseif day_type eq 1><cf_get_lang dictionary_id='31472.Hafta Sonu'><cfelseif day_type eq 2><cf_get_lang dictionary_id='31473.Resmi Tatil'></cfif></td>
                        <!--- <td>#dateformat(START_TIME,dateformat_style)#</td> --->
                        <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
                        <cfif xml_onay eq 1>
                            <td>
                                <cfif len(VALID) and VALID eq 1>
                                    <cfset is_approve_min = is_approve_min + datediff("n",START_TIME,END_TIME)>
                                    <cfset minutesRemaining = minutesRemaining + datediff("n",START_TIME,END_TIME)>
                                    <cfset hours = int(minutesRemaining / 60)>
                                    <cfset minutes = minutesRemaining mod 60>
                                    <b><cf_get_lang dictionary_id ='30982.Onaylayan'></b> : #get_emp_info(VALID_EMPLOYEE_ID,0,0)#
                                <cfelseif len(VALID) and VALID eq 0>
                                    <b><cf_get_lang dictionary_id ='31898.Reddeden'></b> : #get_emp_info(VALID_EMPLOYEE_ID,0,0)#
                                <cfelse>
                                    <cfset not_approve_min = not_approve_min + datediff("n",START_TIME,END_TIME)>
                                    <cfset minutesRemaining_notapprove = minutesRemaining_notapprove + datediff("n",START_TIME,END_TIME)>
                                    <cfset hours_notapprove = int(minutesRemaining_notapprove / 60)>
                                    <cfset minutes_notapprove = minutesRemaining_notapprove mod 60>
                                    <b><cf_get_lang dictionary_id ='57615.Onay Bekliyor'></b>
                                </cfif>
                            </td>
                        </cfif>   
                        <td><a href="#request.self#?fuseaction=myhome.list_my_extra_times&event=upd&EWT_ID=#contentEncryptingandDecodingAES(isEncode:1,content:EWT_ID,accountKey:'wrk')#" title="<cf_get_lang dictionary_id = "57464.Güncelle">"><span class="icn-md icon-update" style="color :##808080 !important"></span></a></td>
                    </tr>
                </cfoutput> 
                <cfelse>
                    <tr> 
                        <td colspan="11"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
                    </tr>
                </cfif>
            </tbody>
            <tfoot>
                <cfoutput>
                    <tr>
                        <td><cf_get_lang dictionary_id="41313.Onay Bekleyen Fazla Mesailerim ">: #not_approve_min# <cf_get_lang dictionary_id="58827.dk"> <br>(#hours_notapprove#S #minutes_notapprove#<cf_get_lang dictionary_id="58827.dk">)</td>
                        <td><cf_get_lang dictionary_id="46129.Onaylanan"> <cf_get_lang dictionary_id="31454.Fazla Mesailerim">: #is_approve_min# <cf_get_lang dictionary_id="58827.dk"><br>(#hours#S #minutes#<cf_get_lang dictionary_id="58827.dk">)</td>
                        <td><cf_get_lang dictionary_id="57492.Toplam">:
                            <cfset total_min = not_approve_min + is_approve_min>
                            <cfset minutesRemaining_total = minutesRemaining_total + total_min>
                            <cfset hours_total = hours_total + int(minutesRemaining_total / 60)>
                            <cfset minutes_total = minutes_total + minutesRemaining_total mod 60>
                            #total_min# <cf_get_lang dictionary_id="58827.dk"><br>(#hours_total#S #minutes_total#<cf_get_lang dictionary_id="58827.dk">)
                        </td>
                    </tr>
                </cfoutput>
            </tfoot>
        </div>
    </cf_flat_list>

    <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_my_extra_times" />
    <cfif isDefined('attributes.startdate') and Len(attributes.startdate)>
        <cfset adres = '#adres#&startdate=#attributes.startdate#' />
    </cfif>
    <cfif isDefined('attributes.finishdate') and Len(attributes.finishdate)>
        <cfset adres = '#adres#&finishdate=#attributes.finishdate#' />
    </cfif>
    <cf_paging
        page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#adres#&is_form_submitted=1">
</cf_box>

<cfinclude  template="../display/list_flexible_worktime.cfm">
<!--- <cfinclude  template="../display/list_my_pdks.cfm"> --->

<script type="text/javascript">
	function showDepartment(branch_id)	
	{
		var branch_id = document.search.branch_id.value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
	}
	function kontrol()
	{
		if(!date_check(document.list_ext_worktimes.startdate, document.list_ext_worktimes.finishdate, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz!'>") )
			return false;
		else
			return true;
	}
</script>