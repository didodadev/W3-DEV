<cfif isDate(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih='attributes.finishdate'></cfif>
<cfif isDate(attributes.other_date1)><cf_date tarih='attributes.other_date1'></cfif>
<cfif isDate(attributes.other_date2)><cf_date tarih='attributes.other_date2'></cfif>
<cfquery name="UPP_TARGET" datasource="#dsn#">
	UPDATE 
		TARGET
	SET 
		<cfif isDefined("attributes.position_code")>
		POSITION_CODE =  #attributes.position_code# ,
		</cfif>
		TARGETCAT_ID = #attributes.targetcat_id#,
		STARTDATE = <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
		FINISHDATE  = <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
		TARGET_HEAD  = '#attributes.target_head#',
		TARGET_NUMBER =  <cfif len(attributes.target_number)>#attributes.target_number#<cfelse>NULL</cfif>,
		TARGET_DETAIL = '#attributes.target_detail#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE=#NOW()#,
		CALCULATION_TYPE = <cfif isdefined("attributes.calculation_type") and len(attributes.calculation_type)>#attributes.calculation_type#<cfelse>NULL</cfif>,
		SUGGESTED_BUDGET = <cfif isdefined("attributes.suggested_budget") and len(attributes.suggested_budget)>#attributes.suggested_budget#<cfelse>NULL</cfif>,
		TARGET_MONEY = <cfif isdefined("attributes.money_type") and len(attributes.money_type)>'#attributes.money_type#'<cfelse>NULL</cfif>,
		TARGET_EMP = <cfif len(attributes.target_emp_id)>#attributes.target_emp_id#<cfelse>#session.ep.userid#</cfif>,
		TARGET_HELP = <cfif len(attributes.target_help)>'#attributes.target_help#'<cfelse>NULL</cfif>,
		TARGET_SHARE = <cfif len(attributes.target_share)>'#attributes.target_share#'<cfelse>NULL</cfif>,
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
<!--- //hedef yetkinlik formundan gelen guncelleme icin--->

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
