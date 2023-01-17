<!--- hedef yetkinlik formundan gelen ekleme için--->
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
<!--- //hedef yetkinlik formundan gelen ekleme için--->
<cfif isDate(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih='attributes.finishdate'></cfif>
<cfif isdefined('attributes.other_date1') and len(attributes.other_date1) and isDate(attributes.other_date1)><cf_date tarih='attributes.other_date1'></cfif>
<cfif isdefined('attributes.other_date2') and len(attributes.other_date2) and isDate(attributes.other_date2)><cf_date tarih='attributes.other_date2'></cfif>
<cfif year(attributes.startdate) neq year(attributes.finishdate)>
	<script type="text/javascript">
		alert("Eklediğiniz hedefin başlangıç ve bitiş tarihi dönemi aynı olmalıdır !");
		history.back();
	</script>
	<cfabort>
</cfif>
<!--- eger birden cok calisan secilmiş ise: --->
<cfif len(attributes.record_num)>
	<cfloop from="1" to="#record_num#" index="i">
		<cfif isdefined("attributes.row_kontrol#i#") and (evaluate("attributes.row_kontrol#i#") neq 0) and len(evaluate("attributes.emp_id#i#"))>
			<cfquery name="get_pos_code" datasource="#DSN#" >
				SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #evaluate("attributes.emp_id#i#")#
			</cfquery>
			<cfset attributes.position_code = get_pos_code.position_code>
            <cfquery name="get_total_target_weight" datasource="#DSN#" >
        		SELECT 
                	SUM(TARGET_WEIGHT) AS TOTAL_WEIGHT
                    <!---,COUNT (TARGET_ID) AS TARGET_COUNT--->
               	FROM 
                	TARGET 
              	WHERE 
                	YEAR(FINISHDATE) = #year(attributes.finishdate)# AND
                    YEAR(STARTDATE) = #year(attributes.startdate)#
                    AND EMP_ID = #evaluate("attributes.emp_id#i#")#
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
           <!--- <cfif get_total_target_weight.TARGET_COUNT gte 3>
            	<script type="text/javascript">
					alert("Çalışanın aynı dönem içerisinde maksimum 3 hedefi olabilir !");
					history.back();
				</script>
				<cfabort>
			</cfif>--->
            <cfif new_weight gt 100>
            	<script type="text/javascript">
					alert("Çalışanın hedef ağırlıkları toplamı 100'den büyük olamaz !");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<cfquery name="ADD_TARGETS" datasource="#dsn#">
				INSERT INTO
					TARGET
				(
					RECORD_EMP,
					RECORD_IP,
					<cfif isdefined('attributes.per_id') and len(attributes.per_id)>PER_ID,</cfif>
					POSITION_CODE,
					EMP_ID,
					TARGETCAT_ID,
					STARTDATE,
					FINISHDATE,
					TARGET_HEAD,
					TARGET_NUMBER,
					<cfif isdefined("attributes.target_detail") and len(attributes.target_detail)>
					TARGET_DETAIL,
					</cfif>
					<cfif isdefined("attributes.calculation_type") and len(attributes.calculation_type)>CALCULATION_TYPE,</cfif>
					SUGGESTED_BUDGET,
					TARGET_MONEY,
					TARGET_EMP,
					TARGET_HELP,
					TARGET_SHARE,
					TARGET_WEIGHT,
					OTHER_DATE1,
					OTHER_DATE2
				)
				VALUES 
				(
					#attributes.record_emp#,
					'#attributes.record_ip#',
					<cfif isdefined('attributes.per_id') and len(attributes.per_id)>#attributes.per_id#,</cfif>
					#attributes.position_code#,
					#evaluate("attributes.emp_id#i#")#,
					#attributes.targetcat_id#,
					<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
					<cfif isdate(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
					'#attributes.target_head#',
					<cfif isdefined('attributes.target_number') and len(attributes.target_number)>#attributes.target_number#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.target_detail") and len(attributes.target_detail)>'#attributes.target_detail#',</cfif>
					<cfif isdefined("attributes.calculation_type") and len(attributes.calculation_type)>#attributes.calculation_type#,</cfif>
					<cfif isdefined("attributes.suggested_budget") and len(attributes.suggested_budget)>#attributes.suggested_budget#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.money_type') and len(attributes.money_type)>'#attributes.money_type#'<cfelse>NULL</cfif>,
					#attributes.target_emp_id#,
					<cfif isdefined('attributes.target_help') and len(attributes.target_help)>'#attributes.target_help#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.target_share') and len(attributes.target_share)>'#attributes.target_share#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.target_weight') and len(attributes.target_weight)>'#attributes.target_weight#'<cfelse>0</cfif>,
					<cfif isdefined('attributes.other_date1') and len(attributes.other_date1)>#attributes.other_date1#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.other_date2') and len(attributes.other_date2)>#attributes.other_date2#<cfelse>NULL</cfif>
				)
			</cfquery>
	
		</cfif>		
	</cfloop>
<cfelse>
	<cfquery name="get_total_target_weight" datasource="#DSN#" >
        SELECT 
        	SUM(TARGET_WEIGHT) AS TOTAL_WEIGHT
            <!---,COUNT (TARGET_ID) AS TARGET_COUNT--->
      	FROM 
        	TARGET 
      	WHERE
        	YEAR(FINISHDATE) = #year(attributes.finishdate)# AND
            YEAR(STARTDATE) = #year(attributes.startdate)#
            <cfif isdefined('attributes.emp_id') and len(attributes.emp_id)>
            	AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
            <cfelseif isdefined('attributes.position_code') and len(attributes.position_code)>
            	AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
            </cfif>
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
    </cfif><!---
    <cfif get_total_target_weight.TARGET_COUNT gte 3>
		<script type="text/javascript">
            alert("Çalışanın aynı dönem içerisinde maksimum 3 hedefi olabilir !");
            history.back();
        </script>
        <cfabort>
    </cfif>--->
    <cfif new_weight gt 100>
        <script type="text/javascript">
            alert("Çalışanın hedef ağırlıkları toplamı 100'den büyük olamaz !");
            history.back();
        </script>
        <cfabort>
    </cfif>
	<cfquery name="ADD_TARGET" datasource="#dsn#">
		INSERT INTO 
			TARGET
		(
			RECORD_EMP,
			RECORD_IP,
			<cfif isdefined('attributes.per_id') and len(attributes.per_id)>PER_ID,</cfif>
			POSITION_CODE,
			EMP_ID,
			TARGETCAT_ID,
			STARTDATE,
			FINISHDATE,
			TARGET_HEAD,
			TARGET_NUMBER,
			TARGET_DETAIL,
			TARGET_EMP,
			TARGET_HELP,
			TARGET_SHARE,
			TARGET_WEIGHT,
			OTHER_DATE1,
			OTHER_DATE2
		)
		VALUES 
		(
			#attributes.record_emp#,
			'#attributes.record_ip#',
			<cfif isdefined('attributes.per_id') and len(attributes.per_id)>#attributes.per_id#,</cfif>
			<cfif isdefined('attributes.position_code') and len(attributes.position_code)>#attributes.position_code#<cfelse>NULL</cfif>,
			<cfif len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
			#attributes.targetcat_id#,
			#attributes.startdate#,
			#attributes.finishdate#,
			'#attributes.target_head#',
			<cfif isdefined('attributes.target_number') and len(attributes.target_number)>#attributes.target_number#<cfelse>NULL</cfif>,
			'#attributes.target_detail#',
			'#attributes.target_emp_id#',
			<cfif isdefined('attributes.target_help') and len(attributes.target_help)>'#attributes.target_help#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.target_share') and len(attributes.target_share)>'#attributes.target_share#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.target_weight') and len(attributes.target_weight)>'#attributes.target_weight#'<cfelse>0</cfif>,
			<cfif isdefined('attributes.other_date1') and len(attributes.other_date1)>#attributes.other_date1#,<cfelse>NULL,</cfif>
			<cfif isdefined('attributes.other_date2') and len(attributes.other_date2)>#attributes.other_date2#<cfelse>NULL</cfif>
		)
	</cfquery>
</cfif>
<cfquery name="get_targets" datasource="#dsn#">
	SELECT 
			TARGET.TARGET_ID,
			TARGET.OUR_COMPANY_ID,
			TARGET.STARTDATE,
			TARGET.FINISHDATE,
			TARGET.TARGET_HEAD,
			TARGET.TARGET_NUMBER,
			TARGET.TARGETCAT_ID,
			TARGET_CAT.TARGETCAT_NAME,
			TARGET.TARGET_EMP,
			TARGET.RECORD_EMP,
			TARGET.TARGET_WEIGHT
		FROM 
			TARGET,
			TARGET_CAT
		WHERE
			TARGET_CAT.TARGETCAT_ID = TARGET.TARGETCAT_ID	
			
			<cfif isdefined('attributes.target_id') and len(attributes.target_id)>
			AND TARGET.TARGET_ID= #attributes.target_id#
			</cfif>
		ORDER BY TARGET.TARGET_ID DESC
</cfquery>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.targets&event=upd&target_id=#get_targets.target_id#</cfoutput>" 
</script>