<cfset type = evaluate(#listgetat(form.task_,4,',')#)><!--- FA 20070219 selectboxdan gelen id degerlerini çekmek için hem kurumsal hem çalısan için --->
<cfif isDefined('attributes.work_h_start') and len(attributes.work_h_start)>
	<cf_date tarih="attributes.work_h_start">
</cfif>
<cfif isDefined('attributes.work_h_finish') and len(attributes.work_h_finish)>
	<cf_date tarih="attributes.work_h_finish">
</cfif>

<cfif not len(attributes.process_stage)>
	<script type="text/javascript">
		alert("<cf_get_lang no='33.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfscript>
	if(isDefined('attributes.work_h_start') and len(attributes.work_h_start)) attributes.work_h_start = date_add('h', attributes.start_hour - session.pp.time_zone, attributes.work_h_start);
	if(isDefined('attributes.work_h_finish') and len(attributes.work_h_finish)) attributes.work_h_finish = date_add('h', attributes.finish_hour - session.pp.time_zone, attributes.work_h_finish);
</cfscript>
<cfif isDefined('attributes.work_h_start') and isDefined('attributes.work_h_finish')>
	<cfif attributes.work_h_start gt attributes.work_h_finish>
        <script type="text/javascript">
            alert("<cf_get_lang no ='1500.Girdiğiniz İşin Hedef Başlangıç Tarihi ile Hedef Bitiş Tarihi Mantıklı Gözükmüyor Lütfen Düzeltin'>!");
            history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>

<cfif len(form.project_id) and (form.project_id neq 0)>
	<cfquery name="GET_PROJECT" datasource="#DSN#">
		SELECT
			COMPANY_ID,
			PARTNER_ID,
			TARGET_START,
			TARGET_FINISH
		FROM
			PRO_PROJECTS
		WHERE
			PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.project_id#">
	</cfquery>
	<cfif isDefined('attributes.work_h_start') and len(attributes.work_h_start) and attributes.work_h_start lt get_project.target_start>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1498.Girdiğiniz İşin Hedef Başlangıç Tarihi Projesinin Hedef Başlangıç Tarihinden Önce Gözüküyor Lütfen Düzeltin'>!");
			history.back();
		</script>
		<cfabort>
	<cfelseif isDefined('attributes.work_h_finish') and len(attributes.work_h_finish) and  attributes.work_h_finish gt get_project.target_finish>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1499.Girdiğiniz İşin Hedef Bitiş Tarihi Projesinin Hedef Bitiş Tarihinden Sonra Gözüküyor  Lütfen Düzeltin'>!");
			//history.back();
		</script>
		<!---<cfabort>--->
	</cfif>
	<cfif isdefined("attributes.rel_work") and len(attributes.rel_work) and isDefined('attributes.work_h_start') and len(attributes.work_h_start)>
		<!--- bağlantılı işlerin tarihleri ile karşılaştırma --->
		<cfquery name="GET_PROBLEM_RELATED_WORKS" datasource="#DSN#">
			SELECT
				PRO_WORK_RELATIONS.WORK_ID
			FROM
				PRO_WORK_RELATIONS,
				PRO_WORKS PRE,
				PRO_WORKS ORIGINAL
			WHERE
				PRE.WORK_ID = PRO_WORK_RELATIONS.PRE_ID AND
				ORIGINAL.WORK_ID = PRO_WORK_RELATIONS.WORK_ID AND
				PRE.TARGET_START > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_h_start#"> AND
				PRO_WORK_RELATIONS.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.work_id#">
		</cfquery>
		<cfif get_problem_related_works.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang no='144.Girdiğiniz işin bağlı olduğu işlerden bir veya birkaçının başlagıç tarihi işinizin başlangıç tarihinden sonra  Lütfen Düzeltin'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<!--- Değişiklik olduysa history tablosuna satır eklenecek--->
        <cfquery name="GET_WORK_DETAIL" datasource="#DSN#">
            SELECT
                PROJECT_ID
            FROM
                PRO_WORKS
            WHERE
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
        </cfquery>
        
        <cfquery name="DEL_RELATED_WORKS" datasource="#DSN#">
            DELETE FROM
                PRO_WORK_RELATIONS
            WHERE
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
        </cfquery>
        
        <cfif isDefined('attributes.rel_work') and attributes.rel_work contains(";")>
            <cfset related_work_ids ="">			<!--- Iliskili islerin listesi --->
            <cfset related_work_types ="">			<!--- Iliskili is tipleri listesi --->
            <cfset related_work_lags ="">			<!--- Iliskili is gecikmeleri listesi --->
            <cfloop list="#attributes.rel_work#" delimiters=";" index="i">
                <cfif i contains "days"><!--- gecikme varsa--->
                    <cfset i_=listgetat(i,1,'+')>
                <cfelse>
                    <cfset i_=i>
                </cfif>
                <cfset work_id = left(i_,len(i_)-2)>
                <cfset work_relation_type = right(i_,2)>
                <cfif i contains "days">
                    <cfset lag=left(listgetat(i,2,'+'),find(" ",listgetat(i,2,'+'))-1)> 
                <cfelse>
                    <cfset lag = "">
                </cfif>
                <cfset related_work_ids = listappend(related_work_ids,work_id)><!--- is id si --->
                <cfset related_work_types = listappend(related_work_types,work_relation_type)><!--- iliski sekli --->
                <cfif len(lag)>
                    <cfset related_work_lags = listappend(related_work_lags,lag)><!--- gecikme --->
                </cfif>
            </cfloop>
        <cfelse>
            <cfset related_work_ids = ''>
            <cfset related_work_types=''>
            <cfset related_work_lags=''>
        </cfif>
        
        <cfif isdefined("related_work_ids") and len(related_work_ids)>
            <cfloop from="1" to="#listlen(related_work_ids)#" index="k">
                <cfquery name="ADD_PRO_WORK_RELATIONS" datasource="#DSN#">
                    INSERT INTO
                        PRO_WORK_RELATIONS
                        (
                            WORK_ID,
                            PRE_ID,
                            RELATION_TYPE,
                            LAG
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.work_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(related_work_ids,k)#">,
                            <cfif len(related_work_types)>
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(related_work_types,k)#">
                            <cfelse>
                                NULL
                            </cfif>,
                            <cfif len(related_work_lags) and  k lte listlen(related_work_lags) and len(listgetat(related_work_lags,k))>
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(related_work_lags,k)#">
                            <cfelse>
                                NULL
                            </cfif>
                         )
                </cfquery>
            </cfloop>
        </cfif>
        
       <cfquery name="ADD_WORK_HISTORY" datasource="#DSN#">
            INSERT INTO
                PRO_WORKS_HISTORY
                    (
                        <cfif isDefined('attributes.pro_work_cat')>WORK_CAT_ID,</cfif>
                        WORK_ID,
                        WORK_HEAD,
                        WORK_DETAIL,
                        RELATED_WORK_ID,
                        PROJECT_ID,
                        REAL_START,
                        REAL_FINISH,
                        WORK_CURRENCY_ID,
                        <cfif isDefined('attributes.priority_cat')>WORK_PRIORITY_ID,</cfif>
                        PROJECT_EMP_ID,							
                        OUTSRC_CMP_ID,
                        OUTSRC_PARTNER_ID,
                        UPDATE_DATE,
                        UPDATE_PAR				
                    )
                VALUES
                    (
                        <cfif isDefined('attributes.pro_work_cat')>#attributes.pro_work_cat#,</cfif>
                        #attributes.work_id#,
                        '#form.work_head#',
                        '#form.work_detail#',
                        <cfif isdefined('attributes.rel_work') and len(attributes.rel_work)>'#attributes.rel_work#',<cfelse>NULL,</cfif>
                        <cfif len(get_work_detail.project_id)>#get_work_detail.project_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('attributes.work_h_start') and len(attributes.work_h_start)>#attributes.work_h_start#<cfelse>NULL</cfif>,
                        <cfif isDefined('attributes.work_h_finish') and len(attributes.work_h_finish)>#attributes.work_h_finish#<cfelse>NULL</cfif>,
                        #attributes.process_stage#,
                        <cfif isDefined('attributes.priority_cat')>#attributes.priority_cat#,</cfif>
                        <cfif type eq 1>
                            #listgetat(form.task_,3,',')#,
                        <cfelse>
                            NULL,
                        </cfif>
                        <cfif type eq '2' or type eq '3'>
                            #listgetat(form.task_,2,',')#,
                            #listgetat(form.task_,3,',')#,
                        <cfelse>
                            NULL,
                            NULL,
                        </cfif>
                        #now()#,
                        #session.pp.userid#
                    )
        </cfquery>
		
        <!---history tablosuna kayıt bitti--->
        <cfquery name="UPD_WORK" datasource="#DSN#">
           UPDATE 
                PRO_WORKS 
            SET 
                <cfif isDefined('attributes.pro_work_cat')>WORK_CAT_ID = #attributes.pro_work_cat#,</cfif>
                <cfif isDefined("attributes.rel_work") and len(attributes.rel_work)>
                    RELATED_WORK_ID = '#attributes.rel_work#',
                <cfelse>
                    RELATED_WORK_ID = NULL,
                </cfif>
                <cfif isdefined("form.work_status")>
                    WORK_STATUS=1,
                <cfelse>
                    WORK_STATUS=0,
                </cfif>
                PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                WORK_HEAD='#form.work_head#',
                WORK_DETAIL='#form.work_detail#',
                REAL_START = <cfif isDefined('attributes.work_h_start') and len(attributes.work_h_start)>#attributes.work_h_start#<cfelse>NULL</cfif>,
                REAL_FINISH = <cfif isDefined('attributes.work_h_finish') and len(attributes.work_h_finish)>#attributes.work_h_finish#<cfelse>NULL</cfif>,
                WORK_CURRENCY_ID=#attributes.process_stage#,
                <cfif isDefined('attributes.priority_cat')>WORK_PRIORITY_ID=#form.priority_cat#,</cfif>
                <cfif type eq 1>
                    PROJECT_EMP_ID = #listgetat(form.task_,3,',')#,
                <cfelse>
                    PROJECT_EMP_ID = NULL,
                </cfif>					
                <cfif type eq '2' or type eq '3'>
                    OUTSRC_CMP_ID = #listgetat(form.task_,2,',')#,
                    OUTSRC_PARTNER_ID = #listgetat(form.task_,3,',')#,
                <cfelse>
                    OUTSRC_CMP_ID = NULL,
                    OUTSRC_PARTNER_ID = NULL,
                </cfif>
                UPDATE_PAR=#session.pp.userid#,
                UPDATE_DATE=#now()#,
                UPDATE_IP='#CGI.REMOTE_ADDR#'
            WHERE 
                PRO_WORKS.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.work_id#">
        </cfquery>
        
        <cfif isdefined("related_work_ids") and related_work_ids neq 0 and len(related_work_ids) and len(related_work_types)>
            <cfloop from="1" to="#listlen(related_work_ids)#" index="k">
                <cfquery name="getDate" datasource="#DSN#">
                    SELECT TARGET_START,TARGET_FINISH FROM PRO_WORKS WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
                </cfquery>
                <cfquery name="get_relDate" datasource="#DSN#">
                    SELECT TARGET_START,TARGET_FINISH,DATEDIFF("D",TARGET_START,TARGET_FINISH)AS FARK FROM PRO_WORKS WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(related_work_ids,k)#">
                </cfquery>
                <cfif listlen(related_work_lags) and k lte listlen(related_work_lags,k) and len(listgetat(related_work_lags,k))><!--- gecikme var ise--->
                    <cfset tstart_date=dateformat(dateadd('d',listgetat(related_work_lags,k),getDate.target_start))>
                    <cfset tfinish_date=dateformat(dateadd('d',listgetat(related_work_lags,k),getDate.target_finish))>
                <cfelse>
                    <cfset tstart_date=dateformat(getDate.target_start)>
                    <cfset tfinish_date=dateformat(getDate.target_finish)>
                </cfif>
                <cfset tstartend_date=dateadd('d',get_relDate.fark,tstart_date)>
                <cfset tstartminus_date=dateadd('d',-get_relDate.fark,tstart_date)>
                <cfset tfinishend_date=dateadd('d',get_relDate.fark,tfinish_date)>
                <cfset tfinishminus_date=dateadd('d',-get_relDate.fark,tfinish_date)>
                <cfif len(related_work_types)>
                    <cfquery name="setDate" datasource="#DSN#">
                        <cfif listgetat(related_work_types,k) eq 'FS'>
                            UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tfinish_date#">,TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tfinishend_date#"> WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(related_work_ids,k)#">
                        <cfelseif listgetat(related_work_types,k) eq 'SF'>
                            UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tstartminus_date#">,TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tstart_date#"> WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(related_work_ids,k)#">
                        <cfelseif listgetat(related_work_types,k) eq 'SS'>
                            UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tstart_date#">,TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tstartend_date#"> WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(related_work_ids,k)#">
                        <cfelse>
                            UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tfinishminus_date#">,TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tfinish_date#"> WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(related_work_ids,k)#">
                        </cfif>	
                    </cfquery>
                </cfif>
                 <cfoutput>#setWork(listgetat(related_work_ids,k))#</cfoutput>
            </cfloop>
        </cfif>
        
        <cfif listgetat(attributes.task_,4,',') eq 1>
            <cfquery name="GET_EMAIL_ADDRESS" datasource="#DSN#">
                SELECT EMPLOYEE_ID, EMPLOYEE_NAME AS NAME, EMPLOYEE_SURNAME AS SURNAME, EMPLOYEE_EMAIL AS EMAIL_ADDRESS FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.task_,3,',')#">
            </cfquery>
        <cfelse>
            <cfquery name="GET_EMAIL_ADDRESS" datasource="#DSN#">
                SELECT PARTNER_ID, COMPANY_PARTNER_EMAIL AS EMAIL_ADDRESS, COMPANY_PARTNER_NAME AS NAME, COMPANY_PARTNER_SURNAME AS SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.task_,3,',')#">
            </cfquery>
        </cfif>
        <cfif isdefined('get_email_address.email_address') and len(get_email_address.email_address)>
        <cfsavecontent variable="message">Adınıza Yapılmış Yeni Bir Bilgilendirme !</cfsavecontent>
            <cfset task_user_name = get_email_address.name>
            <cfset task_user_surname = get_email_address.surname>
            <cfmail
                to="#get_email_address.email_address#"
                from="#session.pp.our_name#<#session.pp.our_company_email#>"
                subject="#message#" 
                type="HTML">
                <cfinclude template="add_work_mail.cfm">
            </cfmail>   
        </cfif>
        
        <cf_workcube_process 
            is_upd='1' 
            data_source='#dsn#'
            old_process_line='#attributes.old_process_line#' 
            process_stage='#attributes.process_stage#'
            record_member='#session.pp.userid#' 
            record_date='#now()#' 
            action_table='PRO_WORKS'
            action_column='WORK_ID'
            action_id='#attributes.work_id#'
            action_page='#request.self#?fuseaction=objects2.updwork&work_id=#encrypt(attributes.work_id,session.pp.userid,"CFMX_COMPAT","Hex")#' 
            warning_description = 'İlgili İş : #attributes.work_head#'>
	</cftransaction>
</cflock>
	
<script type="text/javascript">
	if (window.opener == undefined)
		location.href = '<cfoutput>#request.self#?fuseaction=objects2.dsp_pro_detail&id=#get_work_detail.project_id#</cfoutput>';
	else
		{
			wrk_opener_reload();
			window.close();
		}
</script>
