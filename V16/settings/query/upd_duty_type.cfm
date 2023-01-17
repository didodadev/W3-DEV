<cfquery name="GET_CONTROL" datasource="#DSN#">
	SELECT DUTY_TYPE_ID FROM COMPANY_BRANCH_CONTRACT_ROW WHERE DUTY_TYPE_ID = #attributes.duty_type_id#
</cfquery>

<cfif get_control.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2546.Bu Hizmet Tipi, Anlaşma İçeriğinde Kullanılmış, Kontrol Ediniz'> !");
		history.back();
	</script>
	<cfabort>
<cfelse>
	 <cflock timeout="60">
		<cftransaction>
			<cfquery name="UPD_ASSETP_CAT" datasource="#DSN#">
				UPDATE
					SETUP_DUTY_TYPE
				SET
					DUTY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.duty_type#">,
					IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
					IS_TARGET = #attributes.is_target#,
					IS_VALUE = #attributes.is_value#,
					IS_CATEGORY = #attributes.is_category#,
					CUSTOMER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.customer_type#,">,
					DUTY_UNIT_CAT_ID = #attributes.duty_unit_cat#,
				<cfif attributes.cost_id eq 0>
					COST_ID = #attributes.cost_id#,
					COST_AMOUNT = #attributes.cost_amount#,
					CALCULATE_METHOD = NULL,
					CALCULATE_AMOUNT = NULL,
					COST_CALCULATE_ID = 1,
					DUTY_AMOUNT = #attributes.cost_amount#,
				<cfelse>
					COST_ID = #attributes.cost_id#,
					COST_AMOUNT = NULL,
					CALCULATE_METHOD = #attributes.calculate_method#,
					CALCULATE_AMOUNT = <cfif attributes.calculate_method eq 3>#attributes.calculate_amount#<cfelse>NULL</cfif>,
					COST_CALCULATE_ID = <cfif attributes.calculate_method eq 1>2<cfelseif attributes.calculate_method eq 2>3<cfelseif attributes.calculate_method eq 3>4</cfif>,
					DUTY_AMOUNT = <cfif attributes.calculate_method eq 3>#attributes.calculate_amount#<cfelse>NULL</cfif>,
				</cfif>
					DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					UPDATE_DATE = #now()#,
					UPDATE_EMP = #session.ep.userid#
				WHERE
					DUTY_TYPE_ID = #attributes.duty_type_id#
			</cfquery>
			
			<cfset is_cost_type = 0><!--- Radio butonlarin kontrolu icin (Maliyet) --->
			<cfset is_customer_type = 0><!--- Multiple selectboxin kontrolu icin (Müsteri Tipi) --->
			<cfset control_list1 = "">
			<cfset control_list2 = "">
			<cfset control_list1 = listappend(control_list1,attributes.old_cost_id,',')>
			<cfif len(attributes.old_calculate_method)>
				<cfset control_list1 = listappend(control_list1,attributes.old_calculate_method,',')>
			<cfelse>
				<cfset control_list1 = listappend(control_list1,'m',',')>
			</cfif>
			
			<cfset control_list2 = listappend(control_list2,attributes.cost_id,',')>
			<cfif isdefined("attributes.calculate_method")>
				<cfset control_list2 = listappend(control_list2,attributes.calculate_method,',')>
			<cfelse>
				<cfset control_list2 = listappend(control_list2,'m',',')>
			</cfif>
			<cfloop from="1" to="2" index="j">
				<cfset value_list2 = listgetat(control_list2,j,',')>
				<!--- bk eski hai 90 gune sil <cfif not listfind(control_list1,value_list2,',')> --->
				<cfif listgetat(control_list1,j) neq listgetat(control_list2,j)>
					<cfset is_cost_type = 1>
				</cfif>
			</cfloop>
			<cfoutput> control_list1 : #control_list1#--control_list2: #control_list2#--is_cost_type:#is_cost_type#</cfoutput>
			
			<cfif listlen(attributes.customer_type) eq listlen(attributes.old_customer_type)>
				<cfloop from="1" to="#listlen(attributes.customer_type)#" index="k">
					<cfset value_list = listgetat(attributes.customer_type,k)>
					<cfif not listfind(attributes.old_customer_type,value_list,',')>
						<cfset is_customer_type = 1>
					</cfif>
				</cfloop>
			<cfelse>
				<cfset is_customer_type = 1>
			</cfif>
			
			<cfif 	(attributes.duty_type is not attributes.old_duty_type) or
					(attributes.detail is not attributes.old_detail) or
					(attributes.duty_unit_cat is not attributes.old_duty_unit_cat) or
					(is_customer_type eq 1) or 
					(is_cost_type eq 1) or
					(attributes.cost_amount is not attributes.old_cost_amount) or
					(attributes.calculate_amount is not attributes.old_calculate_amount) or
					(attributes.is_active is not attributes.old_is_active) or
					(attributes.is_target is not attributes.old_is_target) or
					(attributes.is_value is not attributes.old_is_value) or
					(attributes.is_category is not attributes.old_is_category)>
				<cfquery name="ADD_DUTY_TYPE_HISTORY" datasource="#DSN#">
					INSERT INTO
						SETUP_DUTY_TYPE_HISTORY
					(
						DUTY_TYPE_ID,
						DUTY_TYPE,
						IS_ACTIVE,
						IS_TARGET,
						IS_VALUE,
						IS_CATEGORY,
						CUSTOMER_TYPE_ID,
						DUTY_UNIT_CAT_ID,
						COST_ID,
						COST_AMOUNT,
						CALCULATE_METHOD,
						CALCULATE_AMOUNT,
						COST_CALCULATE_ID,
						DUTY_AMOUNT,
						DETAIL,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#attributes.duty_type_id#,
						'#attributes.old_duty_type#',
						#attributes.old_is_active#,
						#attributes.old_is_target#,
						#attributes.old_is_value#,
						#attributes.old_is_category#,
						',#attributes.old_customer_type#,',
						#attributes.old_duty_unit_cat#,
						#attributes.old_cost_id#,
						<cfif len(attributes.old_cost_amount)>#attributes.old_cost_amount#<cfelse>NULL</cfif>,
						<cfif len(attributes.old_calculate_method)>#attributes.old_calculate_method#<cfelse>NULL</cfif>,
						<cfif len(attributes.old_calculate_amount)>#attributes.old_calculate_amount#<cfelse>NULL</cfif>,
						<cfif attributes.old_calculate_method eq 1>2<cfelseif attributes.old_calculate_method eq 2>3<cfelseif attributes.old_calculate_method eq 3>4<cfelse>1</cfif>,
						<cfif attributes.old_cost_id eq 0>#attributes.old_cost_amount#<cfelseif attributes.old_calculate_method eq 3>#attributes.old_calculate_amount#<cfelse>NULL</cfif>,
						'#attributes.old_detail#',
						#now()#,
						#session.ep.userid#,
						'#cgi.remote_addr#'
					)
				</cfquery>
			</cfif>		
		</cftransaction>
	</cflock>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.add_duty_type" addtoken="no">
