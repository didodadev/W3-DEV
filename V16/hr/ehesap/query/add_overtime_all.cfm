<!--- çalışanlara toplam fazla mesai toplu ekleme ekranı query--->
<cfset liste="">
<cftransaction>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol_#i#") and evaluate("attributes.row_kontrol_#i#") neq 0 and len(evaluate("attributes.employee_id#i#"))>
        <cfquery name="get_control" datasource="#dsn#">
            SELECT 
                WORKTIMES_ID 
            FROM 
                EMPLOYEES_OVERTIME
            WHERE
                IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.employee_in_out_id#i#')#"> AND
                OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.term#i#')#"> AND
                OVERTIME_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.start_mon#i#')#">
        </cfquery>
        <cfif get_control.recordcount>
        	<cfset liste=listappend(liste,'#evaluate("attributes.employee#i#")#  #getLang('','Çalışanı için daha önce eklenmiş bir kayıt var','64672')#!',',')>
        <cfelse>
        	<cfquery name="add_overtime" datasource="#dsn#">
            	INSERT INTO
                	EMPLOYEES_OVERTIME
                 	(
                    	OVERTIME_PERIOD,
                        OVERTIME_MONTH,
                        EMPLOYEE_ID,
                        IN_OUT_ID,
                        OVERTIME_VALUE_0,
                        OVERTIME_VALUE_1,
                        OVERTIME_VALUE_2,
                        OVERTIME_VALUE_3,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )
               VALUES
               		(
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.term#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.start_mon#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.employee_id#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.employee_in_out_id#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.overtime_value_0_#i#'))#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.overtime_value_1_#i#'))#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.overtime_value_2_#i#'))#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate('attributes.overtime_value_3_#i#'))#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                    )
            </cfquery>
        </cfif>
    </cfif>
</cfloop>
</cftransaction>
<cfoutput>
	<cfloop list="#liste#" index="i" delimiters=",">
		#i#<br/>
	</cfloop>
</cfoutput>

<script type="text/javascript">
    alert('<cf_get_lang dictionary_id='44519.İşlem Tamamlandı'>!');
        <cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
      
</script>
		



