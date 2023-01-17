<cfset SRC_POS = attributes.pos_from>
<cfset TRG_POS = attributes.pos_TO>
<cfif not len(SRC_POS)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1722.Görevleri Aktarılacak Pozisyonu Seçmediniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif not len(TRG_POS)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1722.Görevleri Aktarılacak Pozisyonu Seçmediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_src_pos" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.DEPARTMENT_ID,
		DEPARTMENT.BRANCH_ID
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT
	WHERE
		EMPLOYEE_POSITIONS.POSITION_CODE = #SRC_POS# AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
</cfquery>
<cfquery name="get_trg_pos" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.DEPARTMENT_ID,
		DEPARTMENT.BRANCH_ID
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT
	WHERE
		EMPLOYEE_POSITIONS.POSITION_CODE = #TRG_POS# AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
</cfquery>
<cfquery name="transfer_pro_projects" datasource="#dsn#">
	UPDATE
		PRO_PROJECTS
	SET
		POSITION_CODE = #TRG_POS#
	WHERE
		POSITION_CODE = #SRC_POS#<!---  AND
		PRO_CURRENCY_ID = -3 --->
</cfquery>
<cfset pos_code=TRG_POS>
<cfquery name="GET_POS" datasource="#dsn#">
	SELECT
		MAX(POSITION_ID) AS POSITION_ID
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_CODE=#pos_code#
</cfquery>
<cfquery name="get_for_pro_projects_history" datasource="#dsn#">
	SELECT
		* 
	FROM
		PRO_HISTORY 
	WHERE
		PROJECT_ID IN (SELECT PROJECT_ID FROM PRO_PROJECTS WHERE PRO_CURRENCY_ID = -3)
</cfquery>
<cfif get_for_pro_projects_history.RecordCount>
	<cfquery name="GET_POS_DETAIL" datasource="#dsn#">
		SELECT
			*
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_ID=#GET_POS.POSITION_ID#
	</cfquery>
	<cfoutput query="get_for_pro_projects_history">
		<cfquery name="transfer_pro_projects_history" datasource="#dsn#">
			INSERT INTO 
				PRO_HISTORY 
			(
				PROJECT_ID,
				POSITION_CODE,
				COMPANY_ID,
				TARGET_START,
				TARGET_FINISH,
				PRO_CURRENCY_ID,
				PRO_PRIORITY_ID,
				UPDATE_DATE,
				OUTSRC_CMP_ID,
				OUTSRC_PARTNER_ID,
				PARTICIPATOR_PAR,
				EMPLOYEE_ID,
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME,
				UPDATE_AUTHOR,
				UPDATE_PAR
			)
			VALUES 
			(
				#PROJECT_ID#,
				#TRG_POS#,
				'#COMPANY_ID#',
				'#TARGET_START#',
				'#TARGET_FINISH#',
				#PRO_CURRENCY_ID#,
				#PRO_PRIORITY_ID#,
				'#UPDATE_DATE#',
				#OUTSRC_CMP_ID#,
				#OUTSRC_PARTNER_ID#,
				'#PARTICIPATOR_PAR#',
				#GET_POS_DETAIL.EMPLOYEE_ID#,
				'#GET_POS_DETAIL.EMPLOYEE_NAME#',
				'#GET_POS_DETAIL.EMPLOYEE_SURNAME#',
				#UPDATE_AUTHOR#,
				#UPDATE_PAR#
			)
		</cfquery>
	</cfoutput>
</cfif>
<cfquery name="transfer_pro_works" datasource="#dsn#">
	UPDATE
		PRO_WORKS
	SET
		POSITION_CODE = #TRG_POS#
	WHERE
		POSITION_CODE = #SRC_POS# AND
		WORK_CURRENCY_ID = -3
</cfquery>
<cfquery name="get_for_pro_works_history" datasource="#dsn#">
	SELECT
		* 
	FROM
		PRO_WORKS_HISTORY 
	WHERE
		WORK_ID IN (SELECT WORK_ID FROM PRO_WORKS WHERE WORK_CURRENCY_ID = -3)
</cfquery>
<cfif get_for_pro_works_history.RecordCount>
	<cfquery name="GET_POS_DETAIL" datasource="#dsn#">
		SELECT
			*
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_ID=#GET_POS.POSITION_ID#
	</cfquery>
	<cfoutput query="get_for_pro_works_history">
		<cfquery name="transfer_pro_works_history" datasource="#dsn#">
			INSERT INTO 
				PRO_WORKS_HISTORY 
			(
				WORK_ID,
				UPDATE_DATE,
			  <cfif len(RELATED_WORK_ID)>
				RELATED_WORK_ID,
			  </cfif>	
				POSITION_CODE,
				EMPLOYEE_ID,
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
			  <cfif len(PROJECT_ID)>
				,PROJECT_ID
			  </cfif>
			  <cfif len(COMPANY_ID)>
				,COMPANY_ID
			  </cfif>
			  <cfif len(COMPANY_PARTNER_ID)>
				,COMPANY_PARTNER_ID
			  </cfif>
			  <cfif len(TARGET_START)>
				,TARGET_START
			  </cfif>
			  <cfif len(TARGET_FINISH)>
				,TARGET_FINISH
			  </cfif>
			  <cfif len(WORK_CURRENCY_ID)>
				,WORK_CURRENCY_ID
			  </cfif>
			  <cfif isdefined("WORK_PRIORITY_ID") and len(WORK_PRIORITY_ID)>
				,WORK_PRIORITY_ID
			  </cfif>
			  <cfif len(OUTSRC_CMP_ID)>
				,OUTSRC_CMP_ID
			 </cfif>
			 <cfif len(OUTSRC_PARTNER_ID)>
				,OUTSRC_PARTNER_ID
			</cfif>
			 <cfif len(UPDATE_AUTHOR)>
				,UPDATE_AUTHOR
			 </cfif>	
			 <cfif len(UPDATE_PAR)>
				,UPDATE_PAR
			 </cfif>
			)
			VALUES 
			(
				#WORK_ID#,
				'#UPDATE_DATE#',
			  <cfif len(RELATED_WORK_ID)>	
				#RELATED_WORK_ID#,
			  </cfif>
			  
				#TRG_POS#,
				#GET_POS_DETAIL.EMPLOYEE_ID#,
				'#GET_POS_DETAIL.EMPLOYEE_NAME#',
				'#GET_POS_DETAIL.EMPLOYEE_SURNAME#'
			<cfif len(PROJECT_ID)>
				,#PROJECT_ID#
			</cfif>
			<cfif len(COMPANY_ID)>
				,#COMPANY_ID#
			</cfif>
			<cfif len(COMPANY_PARTNER_ID)>
				,#COMPANY_PARTNER_ID#
			</cfif>
			<cfif len(TARGET_START)>
				,'#TARGET_START#'
			</cfif>
			<cfif len(TARGET_FINISH)>
				,'#TARGET_FINISH#'
			</cfif>
			<cfif len(WORK_CURRENCY_ID)>
				,#WORK_CURRENCY_ID#
			</cfif>
			<cfif isdefined("WORK_PRIORITY_ID") and len(WORK_PRIORITY_ID)>
				,#WORK_PRIORITY_ID#
			</cfif>
			<cfif len(OUTSRC_CMP_ID)>
				,#OUTSRC_CMP_ID#
			</cfif>
			<cfif len(OUTSRC_PARTNER_ID)>
				,#OUTSRC_PARTNER_ID#
			</cfif>
		     <cfif len(UPDATE_AUTHOR)>
				,#UPDATE_AUTHOR#
			 </cfif>	
			 <cfif len(UPDATE_PAR)>
				,#UPDATE_PAR#
			 </cfif>	
			)
		</cfquery>
	</cfoutput>
</cfif>
<!--- //TRANSFER FOR PROJECT WORK HISTORY --->

<!--- <cfquery name="transfer_unvalidated_orders" datasource="#dsn3#">
	UPDATE
		ORDERS
	SET
		VALIDATOR_POSITION_CODE = #TRG_POS#
	WHERE
		VALIDATOR_POSITION_CODE = #SRC_POS#
		AND
		VALID IS NULL
</cfquery> --->

<!--- <cfquery name="transfer_unvalidated_offers" datasource="#dsn3#">
	UPDATE
		OFFER
	SET
		VALIDATOR_POSITION_CODE = #TRG_POS#
	WHERE
		VALIDATOR_POSITION_CODE = #SRC_POS#
		AND
		VALID IS NULL
</cfquery> --->

<cfquery name="transfer_PRODUCT_CAT" datasource="#dsn3#">
	UPDATE
		PRODUCT_CAT
	SET
		POSITION_CODE = #TRG_POS#
	WHERE
		POSITION_CODE = #SRC_POS#
</cfquery>

<cfquery name="transfer_DEPARTMENT_1" datasource="#dsn#">
	UPDATE
		DEPARTMENT
	SET
		ADMIN1_POSITION_CODE = #TRG_POS#
	WHERE
		ADMIN1_POSITION_CODE = #SRC_POS#
</cfquery>

<cfquery name="transfer_DEPARTMENT_2" datasource="#dsn#">
	UPDATE
		DEPARTMENT
	SET
		ADMIN2_POSITION_CODE = #TRG_POS#
	WHERE
		ADMIN2_POSITION_CODE = #SRC_POS#
</cfquery>

<cfquery name="transfer_BRANCH_1" datasource="#dsn#">
	UPDATE
		BRANCH
	SET
		ADMIN1_POSITION_CODE = #TRG_POS#
	WHERE
		ADMIN1_POSITION_CODE = #SRC_POS#
</cfquery>

<cfquery name="transfer_BRANCH_2" datasource="#dsn#">
	UPDATE
		BRANCH
	SET
		ADMIN2_POSITION_CODE = #TRG_POS#
	WHERE
		ADMIN2_POSITION_CODE = #SRC_POS#
</cfquery>

<cfquery name="transfer_ZONE_1" datasource="#dsn#">
	UPDATE
		ZONE
	SET
		ADMIN1_POSITION_CODE = #TRG_POS#
	WHERE
		ADMIN1_POSITION_CODE = #SRC_POS#
</cfquery>

<cfquery name="transfer_ZONE_2" datasource="#dsn#">
	UPDATE
		ZONE
	SET
		ADMIN2_POSITION_CODE = #TRG_POS#
	WHERE
		ADMIN2_POSITION_CODE = #SRC_POS#
</cfquery>

<cfquery name="transfer_COMPANY" datasource="#dsn#">
	UPDATE
		COMPANY
	SET
		POS_CODE = #TRG_POS#
	WHERE
		POS_CODE = #SRC_POS#
</cfquery>

<cfquery name="transfer_CONSUMER_CAT" datasource="#dsn#">
	UPDATE
		CONSUMER_CAT
	SET
		POSITION_CODE = #TRG_POS#
	WHERE
		POSITION_CODE = #SRC_POS#
</cfquery>


<script type="text/javascript">
	window.close();
</script>
