<cf_xml_page_edit fuseact="assetcare.assetp_reserve_clock">
<!--- Fiziki Varlık Rezervasyon M.T --->
<cfif isDefined("attributes.event_id") AND attributes.EVENT_ID neq 0>
    <cfinclude template="../query/get_event_dates.cfm">
 
    <cfset STARTDATE_TEMP = dateadd('h',session.ep.time_zone,EVENT_DATES.startdate)>
    <cfset FINISHDATE_TEMP = dateadd('h',session.ep.time_zone,EVENT_DATES.finishdate)>
    <cfset startdate = dateformat(STARTDATE_TEMP,dateformat_style)>
    <cfset starthour = timeformat(STARTDATE_TEMP,"HH")>
    <cfset startmin = timeformat(STARTDATE_TEMP,"MM")>
    <cfset finishdate = dateformat(FINISHDATE_TEMP,dateformat_style)>
    <cfset finishhour = timeformat(FINISHDATE_TEMP,"HH")>
    <cfset finishmin = timeformat(FINISHDATE_TEMP,"MM")>
<cfelseif isDefined("attributes.project_id") AND attributes.project_id neq 0>
    <cfinclude template="../query/get_event_dates.cfm">
    <cfset STARTDATE_TEMP = dateadd('h',session.ep.time_zone,attributes.STARTDATE_TEMP)>
    <cfset FINISHDATE_TEMP = dateadd('h',session.ep.time_zone,attributes.FINISHDATE_TEMP)>
    <cfset startdate = dateformat(STARTDATE_TEMP,dateformat_style)>
    <cfset starthour = timeformat(STARTDATE_TEMP,"HH")>
    <cfset startmin = timeformat(STARTDATE_TEMP,"MM")>
    <cfset finishdate = dateformat(FINISHDATE_TEMP,dateformat_style)>
    <cfset finishhour = timeformat(FINISHDATE_TEMP,"HH")>
    <cfset finishmin = timeformat(FINISHDATE_TEMP,"MM")>
<cfelseif isDefined("attributes.class_id") AND attributes.class_id neq 0>
    <cfinclude template="../query/get_class_dates.cfm">
    <cfif len(get_class_dates.start_date) and len(get_class_dates.finish_date)>
		<cfset STARTDATE_TEMP = dateadd('h',session.ep.time_zone,get_class_dates.start_date)>
        <cfset FINISHDATE_TEMP = dateadd('h',session.ep.time_zone,get_class_dates.finish_date)>
        <cfset startdate = dateformat(STARTDATE_TEMP,dateformat_style)>
        <cfset starthour = timeformat(STARTDATE_TEMP,"HH")>
        <cfset startmin = timeformat(STARTDATE_TEMP,"MM")>
        <cfset finishdate = dateformat(FINISHDATE_TEMP,dateformat_style)>
        <cfset finishhour = timeformat(FINISHDATE_TEMP,"HH")>
        <cfset finishmin = timeformat(FINISHDATE_TEMP,"MM")>
    <cfelse>
		<cfset STARTDATE_TEMP = "">
        <cfset FINISHDATE_TEMP = "">
        <cfset startdate = "">
        <cfset starthour = 0>
        <cfset startmin = 0>
        <cfset finishdate = "">
        <cfset finishhour = 0>
        <cfset finishmin = 0>
    </cfif>
<cfelse>
	<cfset STARTDATE_TEMP = "">
    <cfset FINISHDATE_TEMP = "">
    <cfset startdate = "">
    <cfset starthour = 0>
    <cfset startmin = 0>
    <cfset finishdate = "">
    <cfset finishhour = 0>
    <cfset finishmin = 0>
</cfif>

<cfsetting showdebugoutput="yes">
<cfparam name="attributes.day_" default="#now()#">
<cfparam name="attributes.change_type" default="">
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.form_submitted")>
	<cf_date tarih="attributes.day_">
</cfif>

<cfif isdefined("attributes.form_submitted") and attributes.change_type is 'inc'>
	<cfset attributes.day_ = dateadd('d',1,Fix(attributes.day_))>
<cfelseif isdefined("attributes.form_submitted") and attributes.change_type is 'desc'>
	<cfset attributes.day_ = dateadd('d',-1,Fix(attributes.day_))>
<cfelse>
	<cfset attributes.day_ = attributes.day_>
</cfif>
<cfset start_date = createdatetime(year(attributes.day_),month(attributes.day_),day(attributes.day_),00,00,00)>
<cfset finish_date = start_date>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.assetp_name" default=''>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="get_branches" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>

<cfquery name="GET_ASSETP_RESERVE" datasource="#DSN#">
	SELECT
		A.ASSETP_ID,
		A.EVENT_ID,
		A.STARTDATE,
		A.FINISHDATE,
        <!---(SELECT EVENTCAT FROM EVENT_CAT WHERE EVENT_CAT.EVENTCAT_ID = E.EVENTCAT_ID) AS EVENT_TYPE,--->
        AP.ASSETP,
        E.EVENT_HEAD,
        AP.DEPARTMENT_ID,
        AP.STATUS,
        AP.IS_COLLECTIVE_USAGE,
        D.BRANCH_ID
	FROM
		ASSET_P_RESERVE AS A
        LEFT JOIN EVENT AS E ON E.EVENT_ID = A.EVENT_ID
        LEFT JOIN ASSET_P AS AP ON AP.ASSETP_ID = A.ASSETP_ID
        LEFT JOIN DEPARTMENT AS D ON AP.DEPARTMENT_ID = D.DEPARTMENT_ID
	WHERE 
    	CAST(A.STARTDATE AS DATE) <= #start_date# AND #finish_date# <= CAST(A.FINISHDATE AS DATE)
        <!---<cfif isDefined('attributes.eventcat_id') and Len(attributes.eventcat_id)>
			AND E.EVENTCAT_ID IN (#ListSort(ListDeleteDuplicates(attributes.eventcat_id),'numeric','asc',',')#)
		</cfif>--->
		AND D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
        <cfif isDefined('attributes.branch_id') and Len(attributes.branch_id)>
			AND D.BRANCH_ID = #attributes.branch_id#
		</cfif>
        <cfif isDefined('attributes.department') and Len(attributes.department)>
			AND AP.DEPARTMENT_ID = #attributes.department#
		</cfif>
		<cfif isDefined('attributes.assetp_name') and Len(attributes.assetp_name)>
			AND AP.ASSETP LIKE '%#attributes.assetp_name#%'
		</cfif>
        AND AP.STATUS = 1
        AND AP.IS_COLLECTIVE_USAGE = 1
        AND A.EVENT_ID IS NOT NULL
</cfquery>


<cfsavecontent variable="get_1">
	<cfoutput>
        SELECT
            A.ASSETP_ID,
            A.EVENT_ID,
            A.STARTDATE,
            A.FINISHDATE,
            <!---(SELECT EVENTCAT FROM EVENT_CAT WHERE EVENT_CAT.EVENTCAT_ID = E.EVENTCAT_ID) AS EVENT_TYPE,--->
            AP.ASSETP,
            E.EVENT_HEAD,
            AP.DEPARTMENT_ID,
            AP.STATUS,
            AP.IS_COLLECTIVE_USAGE,
            D.BRANCH_ID
        FROM
            ASSET_P_RESERVE AS A
            LEFT JOIN EVENT AS E ON E.EVENT_ID = A.EVENT_ID
            LEFT JOIN ASSET_P AS AP ON AP.ASSETP_ID = A.ASSETP_ID
            LEFT JOIN DEPARTMENT AS D ON AP.DEPARTMENT_ID = D.DEPARTMENT_ID
        WHERE 
            CAST(A.STARTDATE AS DATE) <= #start_date# AND  #finish_date# <= CAST(A.FINISHDATE AS DATE)
			AND D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
			<cfif isDefined('attributes.branch_id') and Len(attributes.branch_id)>
                AND D.BRANCH_ID = #attributes.branch_id#
            </cfif>
            <cfif isDefined('attributes.department') and Len(attributes.department)>
                AND AP.DEPARTMENT_ID = #attributes.department#
            </cfif>
			<cfif isDefined('attributes.assetp_name') and Len(attributes.assetp_name)>
                AND AP.ASSETP LIKE '%#attributes.assetp_name#%'
            </cfif>
            AND AP.STATUS = 1
            AND AP.IS_COLLECTIVE_USAGE = 1
            AND A.EVENT_ID IS NOT NULL
    </cfoutput>
</cfsavecontent>
<cfset records = "">
<cfloop query="#GET_ASSETP_RESERVE#">
	<cfset records = records & "'" & ASSETP &  "',">
</cfloop>
<cfif len(records)>
	<cfset records = left(records,len(records)-1)>
</cfif>
<cfsavecontent variable="get_2">
	<cfoutput>
        SELECT
            '',
            '',
            '',
            '',
        	<!---(SELECT EVENTCAT FROM EVENT_CAT WHERE EVENT_CAT.EVENTCAT_ID = E.EVENTCAT_ID) AS EVENT_TYPE,--->
            AP.ASSETP,
            '',
            AP.DEPARTMENT_ID,
            AP.STATUS,
            AP.IS_COLLECTIVE_USAGE,
            D.BRANCH_ID
        FROM
            <!---  ASSET_P_RESERVE AS A --->
			ASSET_P AS AP
            <!---LEFT JOIN EVENT AS E ON E.EVENT_ID = A.EVENT_ID--->
            <!---LEFT JOIN ASSET_P AS AP ON AP.ASSETP_ID = A.ASSETP_ID--->
            LEFT JOIN DEPARTMENT AS D ON AP.DEPARTMENT_ID = D.DEPARTMENT_ID
        WHERE 
        	1=1
			AND D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
			<cfif GET_ASSETP_RESERVE.recordcount>
				AND AP.ASSETP NOT IN (#records#)
			</cfif>
			<cfif isDefined('attributes.branch_id') and Len(attributes.branch_id)>
                AND D.BRANCH_ID = #attributes.branch_id#
            </cfif>
            <cfif isDefined('attributes.department') and Len(attributes.department)>
                AND AP.DEPARTMENT_ID = #attributes.department#
            </cfif>
			<cfif isDefined('attributes.assetp_name') and Len(attributes.assetp_name)>
                AND AP.ASSETP LIKE '%#attributes.assetp_name#%'
            </cfif>
            AND AP.STATUS = 1
            AND AP.IS_COLLECTIVE_USAGE = 1
        GROUP BY
            AP.ASSETP,
            AP.DEPARTMENT_ID,
            AP.STATUS,
            AP.IS_COLLECTIVE_USAGE,
            D.BRANCH_ID
    </cfoutput>
</cfsavecontent>

<cfquery name="GET_RECORD" datasource="#dsn#">
	<cfif GET_ASSETP_RESERVE.recordcount>
        #PreserveSingleQuotes(get_1)#
        UNION ALL
    </cfif>
    #PreserveSingleQuotes(get_2)#
    ORDER BY
         AP.ASSETP
</cfquery>

<cfparam name="attributes.totalrecords" default='#GET_RECORD.recordcount#'>

<cfif isdefined("x_start_hour") and len(x_start_hour) and isdefined("x_finish_hour") and len(x_finish_hour)>
	
	<cfset x_start_hour_ = TimeFormat(x_start_hour,"mm")>
    <cfset x_finish_hour_ = TimeFormat(x_finish_hour,"mm")>  
    <cfset x_start_hour1 = TimeFormat(x_start_hour,"HH")>
    <cfset x_finish_hour1 = TimeFormat(x_finish_hour,"HH")> 
    <cfif x_start_hour1 eq '00' or x_finish_hour1 eq "00">
    <cfset session.ep.time_zone = 0>
    </cfif> 
	<cfif x_start_hour_ neq '00' and x_finish_hour_ neq '00'>
		<cfset x_start_hour = TimeFormat(x_start_hour,timeformat_style)>   
        <cfset x_finish_hour = TimeFormat(x_finish_hour,timeformat_style)>
        <cfset x_start_hour1 = TimeFormat(x_start_hour,"HH")>
        <cfset x_finish_hour1 = TimeFormat(x_finish_hour,"HH")>
        <cfset x_start_hour_ = TimeFormat(x_start_hour,"mm")>
        <cfset x_finish_hour_ = TimeFormat(x_finish_hour,"mm")> 		
                <cfset mesai_start =  x_start_hour1 - session.ep.time_zone&":"&x_start_hour_> 
                <cfset mesai_finish = x_finish_hour1 - session.ep.time_zone&":"&x_finish_hour_>
     <cfelseif x_start_hour_ neq '00' and x_finish_hour_ eq '00'>
		<cfset x_start_hour = TimeFormat(x_start_hour,timeformat_style)>
        <cfset x_start_hour1 = TimeFormat(x_start_hour,"HH")>
        <cfset x_finish_hour1 = x_finish_hour>
        <cfset x_start_hour_ = TimeFormat(x_start_hour,"mm")>      
                <cfset mesai_start =  x_start_hour1 - session.ep.time_zone&":"&x_start_hour_> 
                <cfset mesai_finish = x_finish_hour1 - session.ep.time_zone&":"&"00">
     <cfelseif x_start_hour_ eq '00' and x_finish_hour_ neq '00'>
		 <cfset x_finish_hour = TimeFormat(x_finish_hour,timeformat_style)>
        <cfset x_start_hour1 = x_start_hour>
         <cfset x_finish_hour1 = TimeFormat(x_finish_hour,"HH")>
          <cfset x_start_hour_ = TimeFormat(x_start_hour,"mm")>     
                <cfset mesai_start =  x_start_hour1 - session.ep.time_zone&":"&"00"> 
                  <cfset mesai_finish = x_finish_hour1 - session.ep.time_zone&":"&x_finish_hour_>       
     <cfelse>
		<cfset x_start_hour1 = x_start_hour>
        <cfset x_finish_hour1 = x_finish_hour>
        <cfset x_start_hour_ = "00">
        <cfset x_finish_hour_ = "00">
        <cfset mesai_start = x_start_hour&":"&x_start_hour_>
        <cfset mesai_finish = x_finish_hour&":"&x_finish_hour_>
     </cfif>   
<cfelse>
<cfset x_start_hour1 = 7>
<cfset x_finish_hour1 = 16>
<cfset x_start_hour_ = "00">
<cfset x_finish_hour_ = "00">
	<cfset mesai_start = 7&":"&x_start_hour_>
	<cfset mesai_finish = 16&":"&x_finish_hour_>
</cfif>

<cfset my_list_all = ''>

<cfloop index="aaa" from="#x_start_hour1#" to="#x_finish_hour1#">
<cfif aaa gte 24>
<cfset aaa1="00"&":"&x_start_hour_>
<cfelse>
<cfset aaa1=aaa&":"&x_start_hour_>
</cfif>
	<cfset my_list_all = listAppend(my_list_all,aaa1,',')> 
</cfloop>

<cfset reserve_times = ''>
<cfset event_id_list = ''>
<cfset event_name_list = ''>
<cfset asset_p_id_list = ''>
<cfoutput query="GET_ASSETP_RESERVE">
	<cfset STARTDATE_NEW = createdatetime(year(STARTDATE),month(STARTDATE),day(STARTDATE),00,00,00)>
	<cfset FINISH_NEW = createdatetime(year(FINISHDATE),month(FINISHDATE),day(FINISHDATE),23,59,59)>
	<cfif dateDiff('d',STARTDATE_NEW,attributes.day_) gt 0>
		<cfset start_time = listFirst(my_list_all,',')>
	<cfelse>
		<cfset start_time = hour(STARTDATE)>
	</cfif>
	<cfif dateDiff('d',attributes.day_,FINISH_NEW) gt 0>
		<cfset finish_time = listLast(my_list_all,',')-1>
	<cfelse>
		<cfset finish_time = hour(FINISHDATE)-1>
	</cfif>
    <cfloop index="aaa" from="#start_time#" to="#finish_time#">
	    <cfset reserve_times = listAppend(reserve_times,aaa&'_'&ASSETP_ID,',')>
	    <cfset asset_p_id_list = listAppend(asset_p_id_list,ASSETP_ID,',')>
        <cfset event_id_list = listAppend(event_id_list,EVENT_ID,',')>
        <cfset event_name_list = listAppend(event_name_list,EVENT_HEAD,',')>
    </cfloop>
</cfoutput>

<cfset asset_p_id_list = listDeleteDuplicates(asset_p_id_list)>
<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
	SELECT 
		<cfif isdefined("session.ep.userid")>
            IS_STANDART = 
            CASE
            	WHEN (SELECT M.EVENTCAT_ID FROM MY_SETTINGS M WHERE M.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND M.EMPLOYEE_ID = #session.ep.userid#) IS NULL THEN '0'
            ELSE '1'
            	END,
		<cfelse>
			'0' AS IS_STANDART,
		</cfif>
		EVENTCAT,
		EVENTCAT_ID		
	FROM 
		EVENT_CAT
	ORDER BY
		EVENTCAT
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfset attributes_day_format = dateformat(attributes.day_,dateformat_style)>
<cfelse>
	<cfset attributes_day_format = attributes.day_>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Rezervasyonlar','33512')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="search_" method="post" action="#request.self#?fuseaction=assetcare.popup_form_assetp_reserve_clocks&assetp_id=#assetp_id#">
            <cf_box_search more="0">
                    <input type="hidden" name="form_submitted" id="form_submitted" value="1" />
                    <input type="hidden" name="change_type" id="change_type" value="" />
                    <!---<td>Varlık Kategorisi</td>
                    <td>
                        <cf_multiselect_check
                            name="eventcat_id"
                            width="130"
                            query_name="get_event_cats"
                            option_name="eventcat"
                            option_value="eventcat_id"
                            value="#attributes.eventcat_id#">
                    </td>--->
                    <div class="form-group" id="item-assetp_name">
                        <div class="input-group x-12">
                            <input type="text" name="assetp_name" id="assetp_name" placeholder="<cfoutput>#getLang('main',1421)#</cfoutput>" value="<cfoutput>#attributes.assetp_name#</cfoutput>"/>
                        </div>
                    </div>
                    <div class="form-group" id="item-day_">
                        <div class="input-group x-12">
                            <div class="input-group">   
                                <cfsavecontent variable="message"><cf_get_lang_main no ='370.Tarih Değerinizi Kontrol Ediniz'>!</cfsavecontent>
                                <cfinput message="#message#" type="text" name="day_" placeholder="#getLang('main',330)#" readonly="yes" maxlength="10" required="yes" validate="#validate_style#" value="#dateformat(attributes_day_format,dateformat_style)#" style="width:65px;">
                                <span class="input-group-addon"> <cf_wrk_date_image date_field="day_"></span>
                            </div>
                        </div>
                    </div>    
                    <div class="form-group" id="item-branch_id">
                        <div class="input-group x-12">
                            <select name="branch_id" id="branch_id" style="width:150px" onChange="showDepartment(this.value)">
                                <option value=""><cf_get_lang_main no='41.Şube'></option>
                                <cfoutput query="get_branches" group="NICK_NAME">
                                    <optgroup label="#NICK_NAME#"></optgroup>
                                    <cfoutput>
                                        <option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
                                    </cfoutput>
                                </cfoutput>
                            </select>
                        </div>
                    </div>    
                    <div class="form-group" id="item-department">
                        <div class="input-group x-12">
                            <div  id="department_place">
                                <select name="department" id="department">
                                    <option value=""><cf_get_lang_main no='160.Departman'></option>
                                    <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                        <cfquery name="get_departmant" datasource="#dsn#">
                                            SELECT 
                                                DEPARTMENT_STATUS, 
                                                BRANCH_ID, 
                                                DEPARTMENT_ID, 
                                                DEPARTMENT_HEAD, 
                                                HIERARCHY, 
                                                RECORD_DATE, 
                                                RECORD_EMP, 
                                                RECORD_IP, 
                                                UPDATE_DATE, 
                                                UPDATE_EMP, 
                                                UPDATE_IP, 
                                                OUR_COMPANY_ID
                                            FROM 
                                                DEPARTMENT 
                                            WHERE 
                                                DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> ORDER BY DEPARTMENT_HEAD
                                        </cfquery>
                                        <cfoutput query="get_departmant">
                                            <option value="#department_id#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.department_id)>selected</cfif>>#department_head#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                    </div>    
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_' , #attributes.modal_id#)"),DE(""))#">
                    </div>
            </cf_box_search>    
            <cf_grid_list>
                    <cfoutput>
                        <cfset x_start_hour_ = TimeFormat(x_start_hour,"mm")>
                        <cfset x_finish_hour_ = TimeFormat(x_finish_hour,"mm")>
                        <cfif x_start_hour_ gt x_finish_hour_>
                            <cfset sonsaat= listlast(my_list_all)>
                            <cfset sonsaat = TimeFormat(sonsaat,timeformat_style)>
                            <cfif x_finish_hour_ neq '00'>
                            <cfset sonsaat_ = replace(sonsaat,TimeFormat(sonsaat,"mm"),x_finish_hour_)>	
                            <cfelse>
                            <cfset sonsaat_ = replace(sonsaat,TimeFormat(sonsaat,"mm"),"00")>	
                            </cfif>
                            <cfset my_list_all = replace(my_list_all,listlast(my_list_all),sonsaat_)>                     
                        <cfelseif  x_start_hour_ lt x_finish_hour_>
                            <cfset sonsaat= listlast(my_list_all)>
                            <cfset sonsaat = TimeFormat(sonsaat,timeformat_style)>                   
                            <cfset x_finish_hour = TimeFormat(x_finish_hour,timeformat_style)>
                            <cfset x_finish_hour2 = TimeFormat(x_finish_hour,"HH")>
                            <cfset x_finish_hour_2 = TimeFormat(x_finish_hour,"mm")>	
                            <cfset _finish = x_finish_hour2&":"&x_finish_hour_2> 
                            <cfset sonsaat_ = replace(sonsaat,TimeFormat(sonsaat,"mm"),x_start_hour_)>	
                            <cfset my_list_all = replace(my_list_all,listlast(my_list_all),sonsaat_)> 
                            <cfset my_list_all = listAppend(my_list_all,_finish,',')> 
                        </cfif>
                        <cfif x_start_hour_ lt x_finish_hour_>
                        <cfset colspan_ = (x_finish_hour1-x_start_hour1) + 4>
                        <cfelseif x_start_hour_ gt x_finish_hour_>
                        <cfset colspan_ = (x_finish_hour1-x_start_hour1) + 3>
                        <cfelse>
                        <cfset colspan_ = (x_finish_hour1-x_start_hour1) + 3>
                        </cfif>
                        <cfset colspan_1 = colspan_ - 2>
                        <div class="margin-bottom-10">
                            <a href="javascript://" onClick="connectAjax2(1);"><i class="fa fa-caret-left" title="Geri"></i></a>
                                #DateFormat(attributes_day_format,dateformat_style)#
                            <a href="javascript://" onClick="connectAjax2(2);"><i class="fa fa-caret-right" title="<cf_get_lang_main no='1431.ileri'>"></i></a>
                        </div>
                        <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                            <th><cf_get_lang dictionary_id='48446.Varlık Adı'></th>
                            <!---<th>Varlık Kategorisi</th>--->
                            <cfloop from="1" to="#colspan_1#" index="time_">
                                <th>#TimeFormat(listgetat(my_list_all,time_,","),"HH")#:#TimeFormat(listgetat(my_list_all,time_,","),"mm")#</th>
                            </cfloop>
                        </tr>
                    </cfoutput>
                </thead>
                <tbody>
                    <cfoutput query="GET_RECORD" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif (currentrow gt 1 and ASSETP neq ASSETP[currentrow-1]) or currentrow eq 1>
                            <tr>
                                <td>#currentrow#</td>
                                <td>#ASSETP# - <cfif is_collective_usage eq 1><font color="FFF0000"><cf_get_lang dictionary_id="47675.Ortak Kullanım"></font></cfif></td>
                                <cfloop from="1" to="#listlen(my_list_all,',')#" index="time_">
                                <cfset kontrol = listGetAt(my_list_all,time_,',')&'_'&ASSETP_ID>
                                    <cfif listFindNoCase(reserve_times,kontrol,',')>
                                        <cfquery name="GET_COLOR" datasource="#dsn#">
                                            SELECT COLOUR FROM EVENT_CAT WHERE EVENTCAT_ID = (SELECT EVENTCAT_ID FROM EVENT WHERE EVENT_ID = #EVENT_ID#)
                                        </cfquery>
                                        <td style="background-color:#GET_COLOR.COLOUR#">
                                            <a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=<cfif listFindNoCase(reserve_times,kontrol,',')>#listGetAt(event_id_list,listFindNoCase(reserve_times,kontrol,','))#</cfif>" target="_blank" class="tableyazi">#listGetAt(event_name_list,listFindNoCase(reserve_times,kontrol,','))#</a>
                                        </td>
                                    <cfelse>
                                        <td></td>
                                    </cfif>
                                </cfloop>
                            </tr>
                        </cfif>                   
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </cfform>      
    </cf_box>
</div>
<cfset url_str = "">
<cfif isdefined("attributes.form_submitted")>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif len(attributes.assetp_name)>
	<cfset url_str = "#url_str#&assetp_name=#attributes.assetp_name#">
</cfif>
<cfif len(attributes.day_)>
	<cfset url_str = "#url_str#&day_=#attributes_day_format#">
</cfif>
<cfif len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif len(attributes.department)>
	<cfset url_str = "#url_str#&department=#attributes.department#">
</cfif>
<cfif len(attributes.change_type)>
	<cfset url_str = "#url_str#&change_type=#attributes.change_type#">
</cfif>
<cf_paging
	page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="assetcare.popup_form_assetp_reserve_clocks&assetp_id=#assetp_id#&#url_str#">
       
<script type="text/javascript">
	function showDepartment(branch_id)	
	{
		var branch_id = document.search_.branch_id.value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_place',1,'İlişkili Departmanlar');
		}
	}

	function connectAjax2(type)
	{
        <cfif not isDefined('attributes.draggable')>
		if(type == 1)
			document.getElementById('change_type').value = 'desc';
		else
			document.getElementById('change_type').value = 'inc';
			document.search_.submit();
        <cfelse>
            if(type == 1)
                document.getElementById('change_type').value = 'desc';
            else
                document.getElementById('change_type').value = 'inc';
                loadPopupBox('search_','<cfoutput>#attributes.modal_id#</cfoutput>');
        </cfif>
	}
</script>
