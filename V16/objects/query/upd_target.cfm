<!---20131122--->
<cfquery name="get_total_target_weight" datasource="#DSN#" >
    SELECT 
        SUM(TARGET_WEIGHT) AS TOTAL_WEIGHT 
    FROM 
        TARGET 
    WHERE 
    	<cfif isDefined("attributes.emp_id") and len(attributes.emp_id)>
        	EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
        <cfelseif isDefined("attributes.position_code") and len(attributes.position_code)>
        	POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
        </cfif>
        AND YEAR(FINISHDATE) = (SELECT YEAR(FINISHDATE) FROM TARGET WHERE TARGET_ID = #attributes.target_id#)
        AND YEAR(STARTDATE) = (SELECT YEAR(STARTDATE) FROM TARGET WHERE TARGET_ID = #attributes.target_id#)
        AND TARGET_ID <> #attributes.target_id#
</cfquery>
<cfif len(get_total_target_weight.TOTAL_WEIGHT)>
	<cfset temp_total = get_total_target_weight.TOTAL_WEIGHT>
<cfelse>
    <cfset temp_total = 0>
</cfif>
<cfif isdefined('attributes.target_weight') and len(attributes.target_weight)>
    <cfset new_weight = attributes.target_weight + temp_total>
<cfelse>
    <cfset new_weight = temp_total>
</cfif>
<cfif new_weight gt 100>
    <script type="text/javascript">
        alert("Çalışanın hedef ağırlıkları toplamı 100'den büyük olamaz !");
        history.back();
    </script>
    <cfabort>
</cfif>
<!---20131122--->
<cfif isDate(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih='attributes.finishdate'></cfif>
<cfif isdefined('attributes.other_date1') and len(attributes.other_date1) and isDate(attributes.other_date1)><cf_date tarih='attributes.other_date1'></cfif>
<cfif isdefined('attributes.other_date2') and len(attributes.other_date2) and isDate(attributes.other_date2)><cf_date tarih='attributes.other_date2'></cfif>
<cfquery name="UPP_TARGET" datasource="#dsn#">
	UPDATE 
		TARGET
	SET 
		<cfif isDefined("attributes.position_code") and len(attributes.position_code)>
		POSITION_CODE =  #attributes.position_code# ,
		</cfif>
		TARGETCAT_ID = #attributes.targetcat_id#,
		STARTDATE = <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
		FINISHDATE  = <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
		TARGET_HEAD  = '#attributes.target_head#',
		TARGET_NUMBER =  <cfif isdefined('attributes.target_number') and len(attributes.target_number)>#attributes.target_number#<cfelse>NULL</cfif>,
		TARGET_DETAIL = '#attributes.target_detail#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE=#NOW()#,
		CALCULATION_TYPE = <cfif isdefined("attributes.calculation_type") and len(attributes.calculation_type)>#attributes.calculation_type#<cfelse>NULL</cfif>,
		SUGGESTED_BUDGET = <cfif isdefined("attributes.suggested_budget") and len(attributes.suggested_budget)>#attributes.suggested_budget#<cfelse>NULL</cfif>,
		TARGET_MONEY = <cfif isdefined("attributes.money_type") and len(attributes.money_type)>'#attributes.money_type#'<cfelse>NULL</cfif>,
		TARGET_EMP = <cfif len(attributes.target_emp_id)>#attributes.target_emp_id#<cfelse>#session.ep.userid#</cfif>,
		TARGET_HELP = <cfif isdefined('attributes.target_help') and len(attributes.target_help)>'#attributes.target_help#'<cfelse>NULL</cfif>,
		TARGET_SHARE = <cfif isdefined('attributes.target_share') and len(attributes.target_share)>'#attributes.target_share#'<cfelse>NULL</cfif>,
		TARGET_WEIGHT=<cfif isdefined('attributes.target_weight') and len(attributes.target_weight)>'#attributes.target_weight#'<cfelse>0</cfif>,
		OTHER_DATE1=<cfif isdefined('attributes.other_date1') and len(attributes.other_date1)>#attributes.other_date1#<cfelse>NULL</cfif>,
		OTHER_DATE2=<cfif isdefined('attributes.other_date2') and len(attributes.other_date2)>#attributes.other_date2#<cfelse>NULL</cfif>
	WHERE 
		TARGET_ID = #attributes.target_id#
</cfquery>

<!--- hedef yetkinlik formundan gelen guncelleme icin--->
<cfif isdefined('attributes.per_id') and len(attributes.per_id)>
	<cfquery name="upd_perform" datasource="#dsn#">
		UPDATE
			EMPLOYEE_PERFORMANCE_TARGET
		SET
			FIRST_BOSS_VALID_FORM=NULL,
			FIRST_BOSS_VALID_DATE_FORM=NULL,
			SECOND_BOSS_VALID_FORM=NULL,
			SECOND_BOSS_VALID_DATE_FORM=NULL,
			THIRD_BOSS_VALID_FORM=NULL,
			THIRD_BOSS_VALID_DATE_FORM=NULL,
			FOURTH_BOSS_VALID_FORM=NULL,
			FOURTH_BOSS_VALID_DATE_FORM=NULL,
			FIFTH_BOSS_VALID_FORM=NULL,
			FIFTH_BOSS_VALID_DATE_FORM=NULL,
			UPDATE_EMP = '#SESSION.EP.USERID#',
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #now()#
		WHERE
			PER_ID = #attributes.per_id#
	</cfquery>
</cfif>
<cfinclude template = "/V16/hr/query/get_targets.cfm">
<!--- //hedef yetkinlik formundan gelen guncelleme icin--->
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.targets&event=upd&target_id=#attributes.target_id#</cfoutput>" 
</script>