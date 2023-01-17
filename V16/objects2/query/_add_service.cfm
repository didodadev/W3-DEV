<cfif len(attributes.service_product_id) and len(attributes.service_product_serial)>
	<cfquery name="control_kapsam" datasource="#dsn3#">
		SELECT
			GUARANTY_INSIDE,
			SERVICE_ID
		FROM
			SERVICE
		WHERE
			SERVICE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_product_id#"> AND
			PRO_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.service_product_serial#"> AND
			GUARANTY_INSIDE = 0
	</cfquery>
	
	<cfif control_kapsam.recordcount>
		<script type="text/javascript">
			alert("<cfoutput>#control_kapsam.SERVICE_ID#</cfoutput><cf_get_lang no ='1438.Seri nolu ürün başvuruda garanti kapsamı dışına alınmıştır'>!");
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>

<cftransaction>
	<cf_papers paper_type="SERVICE_APP">
	<cfset system_paper_no=paper_code & '-' & paper_number>
	<cfset system_paper_no_add=paper_number>
	
	<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
		UPDATE
			GENERAL_PAPERS
		SET
			SERVICE_APP_NUMBER = #system_paper_no_add#
		WHERE
			SERVICE_APP_NUMBER IS NOT NULL
	</cfquery>
</cftransaction>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_SERVICE" datasource="#dsn3#">
		INSERT INTO
			SERVICE(
				SERVICE_ACTIVE,
				ISREAD,
				<cfif len(APPCAT_ID)>SERVICECAT_ID,</cfif>
				<cfif isDefined("STOCK_ID") and len(STOCK_ID)>STOCK_ID,</cfif>
				<cfif len(COMMETHOD_ID)>COMMETHOD_ID,</cfif>
				SERVICE_HEAD,
				<cfif len(SERVICE_DETAIL)>
				SERVICE_DETAIL,
				</cfif>
				<cfif len(SERVICE_ADDRESS)>
				SERVICE_ADDRESS,
				</cfif>
				<cfif len(SERVICE_COUNTY)>
				SERVICE_COUNTY,
				</cfif>
				<cfif len(SERVICE_CITY)>
				SERVICE_CITY,
				</cfif>
				<cfif len(APPLY_DATE)>
				APPLY_DATE,
				</cfif>
				<cfif isDefined("SERVICE_PRODUCT_ID") and len(SERVICE_PRODUCT_ID) and len(SERVICE_PRODUCT)>SERVICE_PRODUCT_ID,</cfif>						
				<cfif isDefined("SERVICE_BRANCH_ID") and len(SERVICE_BRANCH_ID)>SERVICE_BRANCH_ID,</cfif>
				APPLICATOR_NAME,
				<cfif len(service_product)>
				PRODUCT_NAME,
				</cfif>
				<cfif len(service_product_serial)>
				PRO_SERIAL_NO,
				GUARANTY_INSIDE,
				</cfif>
				SERVICE_NO,
				<cfif len(BRING_TEL_NO)>
					BRING_TEL_NO,
				</cfif>
				RECORD_DATE,
				RECORD_MEMBER
			
			)
	  VALUES(
				1,
				0,
			<cfif len(APPCAT_ID)>#APPCAT_ID#,</cfif>
			<cfif isDefined("STOCK_ID") and len(STOCK_ID)>#STOCK_ID#,</cfif>
			<cfif len(COMMETHOD_ID)>#COMMETHOD_ID#,</cfif>
			'#SERVICE_HEAD#',
			<cfif len(SERVICE_DETAIL)>
			'#SERVICE_DETAIL#',
			</cfif>
			<cfif len(SERVICE_ADDRESS)>
			'#SERVICE_ADDRESS#',
			</cfif>
			<cfif len(SERVICE_COUNTY)>
			'#SERVICE_COUNTY#',
			</cfif>
			<cfif len(SERVICE_CITY)>
			'#SERVICE_CITY#',
			</cfif>
			<cfif len(APPLY_DATE)>
			#APPLY_DATE#,
			</cfif>
			<cfif isDefined("SERVICE_PRODUCT_ID") and len(SERVICE_PRODUCT_ID) and len(service_product)>#service_product_id#,</cfif>			
			<cfif isDefined("SERVICE_BRANCH_ID") and len(SERVICE_BRANCH_ID)>#service_branch_id#,</cfif>
			'#made_application#',
			<cfif len(service_product)>
			'#service_product#',
			</cfif>
			<cfif len(service_product_serial)>
			'#service_product_serial#',
			1,
			</cfif>
			'#system_paper_no#',
			<cfif len(BRING_TEL_NO)>
				'#BRING_TEL_NO#',
			</cfif>
			
			#NOW()#,
			#SESSION.EP.USERID#
			)
		</cfquery>	
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=objects2.add_service" addtoken="no">
