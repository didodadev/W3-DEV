<cfquery name="GET_PARTNER" datasource="#DSN#">
   SELECT 
   		PARTNER_ID 
   FROM 
   		COMPANY_PARTNER
   WHERE 
		COMPANY_ID = #attributes.CPID#
</cfquery>
<cfset attributes.PAR_ID= GET_PARTNER.PARTNER_ID>
<cfif GET_PARTNER.recordcount>
<cfif not isDefined('attributes.station_id')>
	<cfquery name="get_workstations" datasource="#dsn#">
		SELECT
			W.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			B.BRANCH_ID,
			B.BRANCH_NAME
		FROM
			#dsn3_alias#.WORKSTATIONS W,
			EMPLOYEES E,
			BRANCH B
		WHERE
			W.EMP_ID = E.EMPLOYEE_ID
		
		<cfif isdefined("attributes.up_search")>
			AND
			W.UP_STATION = #attributes.up_search#
			AND
		</cfif>
		<cfif isdefined('attributes.branch_id') and LEN(attributes.branch_id) >
			AND
			W.BRANCH = #attributes.branch_id#
		</cfif>
		AND
			W.BRANCH=B.BRANCH_ID
		<cfif isdefined('attributes.PAR_ID')>	
		AND
			W.OUTSOURCE_PARTNER = #attributes.PAR_ID#
		</cfif>
		<cfif isdefined('attributes.keyword') and LEN(attributes.keyword)>
		AND
			W.STATION_NAME LIKE '%#attributes.keyword#%'
		</cfif>
		<cfif  isDefined('attributes.ws_status_') >
			<cfswitch expression="#attributes.ws_status_#">
					<cfcase value="1">
						AND
						W.ACTIVE = 1
					</cfcase>
					<cfcase value="2">
					</cfcase>
					<cfcase value="0">
						AND 
							W.ACTIVE = 0
					</cfcase>
			</cfswitch>
		</cfif>	
	</cfquery>
<cfelse>
	<cfquery name="get_workstations" datasource="#dsn#">

		SELECT
			DISTINCT 
			W.STATION_ID,
			W.STATION_NAME,
			E.EMPLOYEE_NAME ,
			E.EMPLOYEE_SURNAME ,
			E.EMPLOYEE_ID
		FROM
			#dsn3_alias#.WORKSTATIONS W,
			EMPLOYEES E
		WHERE
			W.EMP_ID=E.EMPLOYEE_ID
		<cfif isdefined('attributes.station_id')>			
		AND 	
			W.UP_STATION=#attributes.station_id# 
		</cfif>
		<cfif isdefined('attributes.station_id')>
		AND
			W.STATION_ID <> #attributes.station_id#
		</cfif>
		<cfif isdefined('attributes.PAR_ID') and LEN(attributes.PAR_ID)>
			AND
			W.OUTSOURCE_PARTNER =#attributes.PAR_ID#
		</cfif>
		</cfquery>
</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='15.Seçtiğiniz Üyenin Kayıtlı Çalışanı Yoktur ! Önce Çalışan Ekleyiniz !'>");
		window.close();
	</script>
	<cfabort>
</cfif>
