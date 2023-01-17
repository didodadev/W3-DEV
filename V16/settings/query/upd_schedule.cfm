<cfquery name="GET_SCHEDULED_TASK" datasource="#DSN#">
	SELECT    	
    	SCHEDULE_NAME 
    FROM 
    	SCHEDULE_SETTINGS 
    WHERE    	
    	SCHEDULE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.schedule_name)#"> AND
        SCHEDULE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.schedule_id#"> 
</cfquery>
<cfif get_scheduled_task.recordcount neq 0>
	<script type="text/javascript">
    	alert("<cf_get_lang dictionary_id='60684.Güncelleme Başarısız'>! \n <cf_get_lang dictionary_id='57425.Uyarı'>: <cf_get_lang dictionary_id='60685.Aynı isimle, zaman ayarlı görev tanımı bulunmaktadır'>!");
		history.back();
    </script>
    <cfabort>
<cfelse>
    <cf_date tarih="attributes.startdate">
    <cfif len(attributes.finishdate)>
   		<cf_date tarih="attributes.finishdate">
    </cfif>

   <cfif len(attributes.finishdate)  and attributes.ScheduleType eq "Custom">
   		<cfif DateDiff('d',attributes.startdate,attributes.finishdate) gte 0 >
                <cfset timeDiff = attributes.finish_clock - attributes.start_clock>
    			<cfif timeDiff lte 0 >
                    <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='60686.Zaman ayarlı saat aralığını kontrol ediniz'>.");
                    history.back();
                    </script>
                    <cfabort>
                </cfif>
        <cfelse>
		<script type="text/javascript">
            alert("<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>");
            history.back();
        </script>
        <cfabort>
    </cfif>
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
            schedule_interval = 3600 * attributes.customInterval_hour + 60 * attributes.customInterval_min + attributes.customInterval_sec;
            if(schedule_interval lt 60)
                schedule_interval = 60;
            arrangeStartdate(0,attributes.start_clock,0);
        }	
        
        if(len(attributes.finishdate))
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
            
        attributes.schedule_url	= attributes.schedule_url & "&schedule_id=" & attributes.schedule_id;		
    </cfscript>
    
    <!--- schedule Silme de sorun olursa --->
    <cftry>
        <cfschedule action="Delete" task="#attributes.old_schedule_name#">
        <cfcatch type="any">
        </cfcatch>    
    </cftry>
    
    <cfif len(attributes.finishdate) and attributes.ScheduleType neq "Once">
        <cfschedule  
            action="update"
            task="#attributes.schedule_name#"
            operation="httprequest"
            url="#attributes.schedule_url#"
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
            url="#attributes.schedule_url#"
            startdate="#DateFormat(attributes.startdate,'yyyy-mm-dd')#"
            starttime="#TimeFormat(attributes.startdate,'hh:mm tt')#"
            interval="#schedule_interval#"
            resolveurl="yes" />
    </cfif>			 
    <cflock name="#CreateUUID()#" timeout="60">
        <cftransaction>
            <cfquery name="GET_SCHEDULES" datasource="#DSN#">
                UPDATE 
                    SCHEDULE_SETTINGS
                SET
                    SCHEDULE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.schedule_name)#">,
                    SCHEDULE_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.schedule_url#">,
                    SCHEDULE_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ScheduleType#">,
                    SCHEDULE_STARTDATE = #attributes.startdate#,
                
                    SCHEDULE_FINISHDATE = <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
                
                    SCHEDULE_INTERVAL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#schedule_interval#">,
                    SCHEDULE_DESC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
                    RELATED_COMPANY_INFO = <cfif isDefined("attributes.our_company_ids") and len(attributes.our_company_ids)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.our_company_ids#">,<cfelse>NULL,</cfif>
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = #session.ep.userid#	 
                WHERE
                    SCHEDULE_ID = #attributes.schedule_id#
            </cfquery>
            <!--- ilişkili kurallar ekleniyor --->
            <cfquery name="del_row" datasource="#dsn#">
                DELETE FROM SCHEDULE_SETTINGS_ROW WHERE SCHEDULE_ID = #attributes.schedule_id#
            </cfquery>
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
                                #attributes.schedule_id#,
                                #Evaluate("attributes.pos_line_#i#")#,
                                #Evaluate("attributes.pos_operation_id_#i#")#
                            )
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
        </cftransaction>
    </cflock>
</cfif>