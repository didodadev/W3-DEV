<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="GET_COMPANY" datasource="#DSN#">
			SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfquery name="GET_COMPANY_BRANCH_RELATED" datasource="#DSN#">
			SELECT RELATED_ID,SALES_DIRECTOR FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #attributes.cpid# AND BRANCH_ID = #attributes.branch_id#
		</cfquery>
		<cfquery name="ADD_NOTE" datasource="#DSN#">
			INSERT INTO 
				COMPANY_ACTION_PLAN_NOTES 
			(
				COMPANY_ID,
				BRANCH_ID,
				PROCESS_CAT_ID,
				SUBJECT,
				DETAIL,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				RELATED_ACTION_ID
			) 
			VALUES 
			(
				#attributes.cpid#,
				#attributes.branch_id#,
				#attributes.process_stage#,
				'#attributes.subject#',
				'#attributes.detail#',
				#session.ep.userid#,
				#now()#,
				'#cgi.remote_addr#',
				0
			)
		</cfquery>
		<cfquery name="GET_RESPONSIBLE" datasource="#DSN#">
			<!--- Sube Muduru --->
			SELECT 
				'SB' TYPE,
				EMPLOYEES.EMPLOYEE_EMAIL
			FROM 
				EMPLOYEES,
				EMPLOYEE_POSITIONS,
				COMPANY_BOYUT_DEPO_KOD
			WHERE 
				EMPLOYEES.EMPLOYEE_EMAIL IS NOT NULL AND
				EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				COMPANY_BOYUT_DEPO_KOD.SUBE_POS_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND
				COMPANY_BOYUT_DEPO_KOD.W_KODU = #attributes.branch_id#
				
			UNION
			
			<!--- Operasyon Muduru --->
			SELECT 
				'OP' TYPE,
				EMPLOYEES.EMPLOYEE_EMAIL
			FROM 
				EMPLOYEES,
				EMPLOYEE_POSITIONS,
				COMPANY_BOYUT_DEPO_KOD
			WHERE 
				EMPLOYEES.EMPLOYEE_EMAIL IS NOT NULL AND
				EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				COMPANY_BOYUT_DEPO_KOD.OPERASYON_POS_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND
				COMPANY_BOYUT_DEPO_KOD.W_KODU = #attributes.branch_id#
			
			UNION

			<!--- BSM --->
			SELECT 
				'BSM' TYPE,
				EMPLOYEES.EMPLOYEE_EMAIL
			FROM 
				EMPLOYEES,
				EMPLOYEE_POSITIONS,
				COMPANY_BRANCH_RELATED
			WHERE 
				COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
				EMPLOYEES.EMPLOYEE_EMAIL IS NOT NULL AND
				EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				COMPANY_BRANCH_RELATED.SALES_DIRECTOR = EMPLOYEE_POSITIONS.POSITION_CODE AND
				COMPANY_BRANCH_RELATED.RELATED_ID = #get_company_branch_related.related_id#				
		</cfquery>
		
		<cfset responsible_mail=''>
		<cfoutput query="get_responsible">
			<cfset responsible_mail = listappend(responsible_mail,get_responsible.employee_email,',')>
		</cfoutput>
		
		<cfif len(responsible_mail)>
			<cfmail from="CRM Uyari Servisi" to ="#responsible_mail#" subject="#get_company.nickname# Eczanesi Eylem Planı Kayıt Girişi Hk." charset="utf-8" type="html">
				#attributes.detail#'
			</cfmail>
		</cfif>			
	</cftransaction>
</cflock>	
<script type="text/javascript">
	<cfif isDefined("attributes.draggable") and attributes.draggable eq 1>
		location.href = document.referrer;
	<cfelse>
		window.close();
		wrk_opener_reload();
	</cfif>
</script>

