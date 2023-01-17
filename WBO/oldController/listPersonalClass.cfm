<cf_get_lang_set module_name="myhome">
<cfif not isDefined('attributes.event') or (isDefined('attributes.event') and attributes.event is 'list')>
	<!--- listenin aynısı training dede var--->
    <!---- katalog/katalog dısı egitim talepleri--->
    <cfparam name="attributes.keyword" default="">
    <cfquery name="GET_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
        SELECT
            TR.TRAIN_REQUEST_ID,
            TR.START_DATE,
            TR.FINISH_DATE,
            TR.REQUEST_TYPE,
            (SELECT DISTINCT TRAIN_HEAD FROM TRAINING T,TRAINING_REQUEST_ROWS TRR WHERE T.TRAIN_ID = TRR.TRAINING_ID AND TRR.TRAIN_REQUEST_ID =TR.TRAIN_REQUEST_ID ) AS TRAIN_HEAD,
            (SELECT DISTINCT OTHER_TRAIN_NAME FROM TRAINING_REQUEST_ROWS TRR WHERE TRR.TRAIN_REQUEST_ID =TR.TRAIN_REQUEST_ID ) AS OTHER_TRAIN_NAME,
            TR.PROCESS_STAGE,
            TR.EMPLOYEE_ID,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            TR.RECORD_DATE,
            TR.REQUEST_TYPE,
            TR.EMP_VALIDDATE
        FROM 
            TRAINING_REQUEST TR
            INNER JOIN EMPLOYEES E
            ON TR.EMPLOYEE_ID = E.EMPLOYEE_ID
        WHERE
            TR.EMPLOYEE_ID = #session.ep.userid# AND 
            TR.REQUEST_TYPE IN(1,2)  <!--- katalog ve katalog disi egitimleri getir--->		
            <cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
            AND
            (
                E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%"> OR
                E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%">
            )
            </cfif>
        ORDER BY
            TR.RECORD_DATE DESC,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME 
    </cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_training_join_requests.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif fusebox.circuit is "report"><!---onay raporu özel rapor icin bu kontrol eklendi --->
        <cfset adres_ = "myhome">
    <cfelse>
        <cfset adres_ = fusebox.circuit> 
    </cfif>
    <cfquery name="get_all_positions" datasource="#dsn#">
        SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfset pos_code_list = valuelist(get_all_positions.position_code)>
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
            #Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
    </cfquery>
    <cfif Get_Offtime_Valid.recordcount>
        <cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
        <cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#pos_code_list#)
        </cfquery>
        <cfoutput query="Get_StandBy_Position1">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#pos_code_list#)
        </cfquery>
        <cfoutput query="Get_StandBy_Position2">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN (#pos_code_list#)
        </cfquery>
        <cfoutput query="Get_StandBy_Position3">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
        </cfoutput>
    </cfif>
	<cfif get_training_join_requests.recordcount>
        <cfset stage_id_list=''>
        <cfoutput query="get_training_join_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
            <cfif len(process_stage) and not listfind(stage_id_list,process_stage)>
                <cfset stage_id_list = Listappend(stage_id_list,process_stage)>
            </cfif>
        </cfoutput>
        <cfif len(stage_id_list)>
            <cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
            <cfquery name="get_content_process_stage" datasource="#DSN#">
                SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_id_list#">) ORDER BY PROCESS_ROW_ID
            </cfquery>
            <cfset stage_id_list = listsort(listdeleteduplicates(valuelist(get_content_process_stage.process_row_id,',')),'numeric','ASC',',')>
        </cfif>
    </cfif>
    <cfset adres = "">
	<cfif fusebox.circuit is "myhome">
        <cfset adres = "myhome.list_class_request">
    </cfif>
    <cfif fusebox.circuit is "training">
        <cfset adres = "training.list_class_request">
    </cfif>
    <cfif len(attributes.keyword)>
        <cfset adres = "#adres#&keyword=#attributes.keyword#">
    </cfif>
    <!--- Yıllık Eğitim Talepleri--->
    <cfquery name="get_training_request" datasource="#dsn#">
        SELECT
            TRAIN_REQUEST_ID,
            REQUEST_YEAR,
            RECORD_DATE,
            PROCESS_STAGE,
            EMP_VALID_ID,
            EMP_VALIDDATE
        FROM
            TRAINING_REQUEST
        WHERE
            EMPLOYEE_ID = #session.ep.userid# AND
            REQUEST_TYPE = 3 <!--- yıllık eğitim talebi--->
        ORDER BY
            RECORD_DATE DESC
    </cfquery>
    <cfif get_training_request.recordcount>
		<cfset stage_id_list=''>
        <cfoutput query="get_training_request" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
            <cfif len(process_stage) and not listfind(stage_id_list,process_stage)>
                <cfset stage_id_list = Listappend(stage_id_list,process_stage)>
            </cfif>
        </cfoutput>
        <cfif len(stage_id_list)>
            <cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
            <cfquery name="get_content_process_stage" datasource="#DSN#">
                SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_id_list#">) ORDER BY PROCESS_ROW_ID
            </cfquery>
            <cfset stage_id_list = listsort(listdeleteduplicates(valuelist(get_content_process_stage.process_row_id,',')),'numeric','ASC',',')>
        </cfif>
    </cfif>
    <!--- onay bekleyen talepler--->
    <cfquery name="get_valid_request" datasource="#dsn#">
        SELECT
            TRAIN_REQUEST_ID,
            REQUEST_YEAR,
            RECORD_DATE,
            PROCESS_STAGE,
            REQUEST_TYPE,
            START_DATE,
            FINISH_DATE,
            EMPLOYEE_ID
        FROM
            TRAINING_REQUEST
        WHERE
            (
                (FIRST_BOSS_CODE IN(#pos_code_list#) AND FIRST_BOSS_VALID_DATE IS NULL AND EMP_VALIDDATE IS NOT NULL) OR <!--- çalışan onayladıysa ve 1.amir oanyında bekliyor ise--->
                (SECOND_BOSS_CODE IN(#pos_code_list#) AND SECOND_BOSS_VALID_DATE IS NULL AND FIRST_BOSS_VALID_DATE IS NOT NULL AND FIRST_BOSS_VALID = 1) OR <!--- 1.amir onayladıysa ve 2.amir onayı bekleniyor ise--->
                (FOURTH_BOSS_CODE IN(#pos_code_list#) AND FOURTH_BOSS_VALID_DATE IS NULL AND THIRD_BOSS_VALID_DATE IS NOT NULL AND THIRD_BOSS_VALID = 1) <!--- IK onayı verildiyse 4.yonetici onaylayacak--->
            )
        ORDER BY
            RECORD_DATE DESC
    </cfquery>
    <cfset stage_id_list=''>
	<cfoutput query="get_valid_request" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
        <cfif len(process_stage) and not listfind(stage_id_list,process_stage)>
            <cfset stage_id_list = Listappend(stage_id_list,process_stage)>
        </cfif>
    </cfoutput>
    <cfif len(stage_id_list)>
        <cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
        <cfquery name="get_content_process_stage" datasource="#DSN#">
            SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_id_list#">) ORDER BY PROCESS_ROW_ID
        </cfquery>
        <cfset stage_id_list = listsort(listdeleteduplicates(valuelist(get_content_process_stage.process_row_id,',')),'numeric','ASC',',')>
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif not isDefined('attributes.event') or (isDefined('attributes.event') and attributes.event is 'list')>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_class_request';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_personal_class.cfm';

</cfscript>
