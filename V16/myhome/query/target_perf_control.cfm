<!---hedef yetkinlik performansları için yetkisiz bir forma girmemesi için kontrol --->
<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
</cfquery>
<cfset position_list=valuelist(get_emp_pos.POSITION_CODE,',')>
<cfif not session.ep.ehesap>
	<cfquery name="get_kontrol" datasource="#dsn#">
		SELECT 
			EP.EMP_ID
		FROM 
			EMPLOYEE_PERFORMANCE_TARGET EPT,
			EMPLOYEE_PERFORMANCE EP
		WHERE
			EP.PER_ID=EPT.PER_ID AND
			EPT.PER_ID=#attributes.per_id# AND
			(	
				EPT.FIRST_BOSS_CODE IN (#position_list#) OR
				EPT.SECOND_BOSS_CODE IN (#position_list#) OR
				EPT.THIRD_BOSS_CODE IN (#position_list#) OR
				EPT.FOURTH_BOSS_CODE IN (#position_list#) OR
				EPT.FIFTH_BOSS_CODE IN (#position_list#) OR
				EP.EMP_ID = #session.ep.userid#
			)
	</cfquery>
    
	<cfif not get_kontrol.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1227.Bu formu görüntülemeye yetkiniz yok'>!");
			<cfif fuseaction contains 'popup'>
				window.close();
			<cfelse>
				history.back();
			</cfif>
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- yetkisiz bir forma girmemesi için kontrol --->
