<!--- 
	Bu sayfada cf administrator page deki schedules bolumune ilgili kaydi ekler ve 
	DSN veritabanına da ayni kaydi ekleme islemini yapar.
--->
<cfquery name="GET_SCHEDULED_TASK" datasource="#DSN#">
	SELECT 
    	SCHEDULE_NAME 
    FROM 
    	SCHEDULE_SETTINGS 
    WHERE 
    	SCHEDULE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.schedule_name)#">
</cfquery>
<cfif get_scheduled_task.recordcount>
	<script type="text/javascript">
        alert('Aynı isimle birden fazla zaman ayarlı görev ekleyemezsiniz !');
		history.back();
    </script>
<cfelse>
    <cf_date tarih="attributes.startdate">
    <cfif len(attributes.finishdate)>
   		<cf_date tarih="attributes.finishdate">
    </cfif>
	
   <cfif len(attributes.finishdate) and attributes.ScheduleType eq "Custom">
   		<cfif DateDiff('d',attributes.startdate,attributes.finishdate) gte 0 >
                <cfset timeDiff = attributes.finish_clock - attributes.start_clock>
    			<cfif timeDiff lte 0 >
                    <script type="text/javascript">
                    alert('Zaman ayarlı saat aralığını kontrol ediniz.');
                    history.back();
                    </script>
                    <cfabort>
                </cfif>
        <cfelse>
		<script type="text/javascript">
            alert("<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>");
            history.back();
        </script>
        <cfabort>
        </cfif>
   </cfif>
    
    <cfquery name="get_max_schedule_id" datasource="#DSN#">
        SELECT MAX(SCHEDULE_ID) AS MAX_SCHEDULE_ID FROM	SCHEDULE_SETTINGS		
    </cfquery>
    <cfif len(get_max_schedule_id.MAX_SCHEDULE_ID) and isnumeric(get_max_schedule_id.MAX_SCHEDULE_ID)>
        <cfset MAX_SCHEDULE_ID = get_max_schedule_id.MAX_SCHEDULE_ID + 1>
    <cfelse>
        <cfset MAX_SCHEDULE_ID = 1>
    </cfif>
    <cfif isdefined("form.is_pos_operation") and form.is_pos_operation eq 1>
        <cfset attributes.Once_Hour = attributes.Once_Hour - 2>
        <cfset attributes.Recurring_Hour = attributes.Recurring_Hour - 2>
    </cfif>
    <cfscript>
        function arrangeStartdate(days,hours,mins){
            attributes.startdate = date_add('d',days, attributes.startdate);
            attributes.startdate = date_add('h',hours, attributes.startdate);
            attributes.startdate = date_add('n',mins, attributes.startdate);
        }
    
        schedule_interval = "Daily";
        recursive_interval = 1;
        if(attributes.ScheduleType eq "Once"){
            schedule_interval = "Once";
            arrangeStartdate(0,attributes.Once_Hour,attributes.Once_Minute);	
        }
        else
        if(attributes.ScheduleType eq "Recurring"){
            if(attributes.Interval eq "Daily"){
                schedule_interval = "Daily";
                arrangeStartdate(0,attributes.Recurring_Hour,attributes.Recurring_Minute);							
            }
            else
            if(attributes.Interval eq "Weekly"){
                schedule_interval = "Weekly";
                arrangeStartdate(0,attributes.Recurring_Hour,attributes.Recurring_Minute);
            }
            else
            if(attributes.Interval eq "Monthly"){
                schedule_interval = "Monthly";
                arrangeStartdate(0,attributes.Recurring_Hour,attributes.Recurring_Minute);
            }		
        }
        else
        if(attributes.ScheduleType eq "Custom"){
            if(not Len(attributes.customInterval_hour))
                attributes.customInterval_hour = 0;
            if(not Len(attributes.customInterval_min))
                attributes.customInterval_min = 0;
            if(not Len(attributes.customInterval_sec))
                attributes.customInterval_sec = 0;						
            schedule_interval = 3600 * attributes.customInterval_hour + 60 * attributes.customInterval_min + attributes.customInterval_sec;
            if(schedule_interval lt 60)
                schedule_interval = 60;
            arrangeStartdate(0,attributes.start_clock,0);
        }	
        
        if (len(attributes.finishdate))
            attributes.finishdate = date_add('h',attributes.finish_clock, attributes.finishdate);
        else
            attributes.finishdate = "";
    
        status = 0;	
        if(isDefined("attributes.record") and not isDefined("attributes.email"))
            status = 0;
        else 
        if(isDefined("attributes.email") and not isDefined("attributes.record"))
            status = 1;
        else 
        if(isDefined("attributes.record") and isDefined("attributes.email"))
            status = 2;
        else
        if(not isDefined("attributes.record") and not isDefined("attributes.email"))
            status = -1;
    
        attributes.temp_schedule_url = attributes.schedule_url & "&schedule_id=" & MAX_SCHEDULE_ID;
    </cfscript>

    <cfif len(attributes.finishdate) and attributes.ScheduleType neq "Once">
        <!--- port eklenecek --->
        <cfschedule
            action="update"
            task="#attributes.schedule_name#"
            operation="httprequest"
            url="#attributes.temp_schedule_url#"
            startdate="#DateFormat(attributes.startdate,'yyyy-mm-dd')#"
            starttime="#TimeFormat(attributes.startdate,'hh:mm tt')#"
            enddate="#DateFormat(attributes.finishdate,'yyyy-mm-dd')#"
            endtime="#TimeFormat(attributes.finishdate,'hh:mm tt')#"
            interval="#schedule_interval#"
            resolveurl="yes" />
    <cfelse>
        <cfschedule
            action="update"
            task="#attributes.schedule_name#"
            operation="httprequest"
            url="#attributes.temp_schedule_url#"
            startdate="#DateFormat(attributes.startdate,'yyyy-mm-dd')#"
            starttime="#TimeFormat(attributes.startdate,'hh:mm tt')#"
            interval="#schedule_interval#"
            resolveurl="yes" />
    </cfif>
                    
    <cflock name="#CreateUUID()#" timeout="60">
        <cftransaction>
            <cfquery name="GET_SCHEDULES" datasource="#DSN#" >
                INSERT INTO
                    SCHEDULE_SETTINGS
                (
                    SCHEDULE_ID,
                    SCHEDULE_NAME,
                    SCHEDULE_URL,
                    SCHEDULE_TYPE,
                    SCHEDULE_STARTDATE,
                    SCHEDULE_FINISHDATE,
                    SCHEDULE_INTERVAL,
                    SCHEDULE_DESC,
                    RELATED_COMPANY_INFO,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    IS_POS_OPERATION
                )
                VALUES
                (
                    #MAX_SCHEDULE_ID#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.schedule_name)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.temp_schedule_url#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ScheduleType#">,
                    #attributes.startdate#,
                    <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#schedule_interval#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
                    <cfif isDefined("attributes.our_company_ids") and len(attributes.our_company_ids)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.our_company_ids#">,<cfelse>NULL,</cfif>
                    #now()#,
                    #session.ep.userid#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfif isDefined("attributes.is_pos_operation") and attributes.is_pos_operation eq 1>1<cfelse>0</cfif>
                )	
            </cfquery>
            <!--- ilişkili kurallar ekleniyor --->
            <cfif isdefined("attributes.record_num")>
                <cfloop from="1" to="#attributes.record_num#" index="i">
                    <cfif isdefined("attributes.row_kontrol_#i#") and evaluate("attributes.row_kontrol_#i#") eq 1>
                        <cfquery name="add_row" datasource="#dsn#">
                            INSERT INTO 
                                SCHEDULE_SETTINGS_ROW
                            (
                                SCHEDULE_ID,
                                ROW_NUMBER,
                                POS_OPERATION_ID
                            )
                            VALUES
                            (	
                                #MAX_SCHEDULE_ID#,
                                #Evaluate("attributes.pos_line_#i#")#,
                                #Evaluate("attributes.pos_operation_id_#i#")#
                            )
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
        </cftransaction>
    </cflock>
    <cfset attributes.actionId = MAX_SCHEDULE_ID />
</cfif>