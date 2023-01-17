<!--- Islenen Emir Talepleri --->
<cfif not len(attributes.cat) or listfind('3,4',attributes.cat)>
	<cfquery name="GET_DISPATCH_SHIP" datasource="#DSN2#">
		SELECT DISPATCH_SHIP_ID FROM SHIP WHERE DISPATCH_SHIP_ID IS NOT NULL
	</cfquery>
</cfif>
<!--- Siparisler --->
<cfif not len(attributes.cat) or listfind('1,2',attributes.cat)>
	<cfquery name="GET_ORDER_LIST_1" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
		SELECT DISTINCT
			1 TYPE_ID,
			O.ORDER_ID ISLEM_ID,
			O.ORDER_NUMBER ISLEM_NO,
			O.ORDER_HEAD,
			O.PARTNER_ID,
			O.COMPANY_ID,
			O.CONSUMER_ID,
			O.PRIORITY_ID,
			O.ORDER_ZONE,
			O.PURCHASE_SALES,
			O.ORDER_DATE ISLEM_TARIHI,
			O.DELIVERDATE TESLIM_TARIHI,
			ORR.DELIVER_DEPT DEPT_IN,
			-1 DEPT_OUT,
			O.RECORD_EMP,
			O.RECORD_DATE
		FROM 
			ORDERS O,
			ORDER_ROW ORR
		WHERE
			ORR.ORDER_ID = O.ORDER_ID 
			<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
				AND (ORR.DELIVER_DEPT = #attributes.department_id# OR O.DELIVER_DEPT_ID = #attributes.department_id#)
			</cfif>
			AND	O.ORDER_STATUS = 1 
			AND 
			(
				(O.IS_PROCESSED = 1 AND ORR.ORDER_ROW_CURRENCY IN (-3,-6,-7)) OR
				(O.IS_PROCESSED = 0 AND ORR.ORDER_ROW_CURRENCY = -6)
			)
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
				(
					O.ORDER_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
					OR O.ORDER_HEAD LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
				)
		</cfif>
		<cfif isDefined("attributes.cat") and len(attributes.cat)>
			<cfif attributes.cat eq 1>
				AND(O.ORDER_ZONE = 0 AND O.PURCHASE_SALES = 0)		
			<cfelseif attributes.cat eq 2>
				AND
				(
					(
						(O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1)
					)
					OR O.ORDER_ZONE = 2 <!--- BK 20060612 Bu sart dogru mu ??? --->
				)
			</cfif>	
		 </cfif>
		 <cfif isdefined("attributes.company") and len(attributes.company) and len(attributes.company_id)>
			 AND O.COMPANY_ID = #attributes.company_id#
		 </cfif>
		 <cfif isdefined("attributes.date1") and len(attributes.date1)>
			AND O.DELIVERDATE >= #attributes.date1#
		 </cfif>
		 <cfif isdefined("attributes.date2") and  len(attributes.date2)>
			AND O.DELIVERDATE <= #attributes.date2#
		 </cfif>	 
	</cfquery>
	<cfquery name="GET_ORDER_LIST_2" datasource="#DSN3#">
		SELECT DISTINCT
			1 TYPE_ID,
			O.ORDER_ID ISLEM_ID,
			O.ORDER_NUMBER ISLEM_NO,
			O.ORDER_HEAD,
			O.PARTNER_ID,
			O.COMPANY_ID,
			O.CONSUMER_ID,
			O.PRIORITY_ID,
			O.ORDER_ZONE,
			O.PURCHASE_SALES,
			O.ORDER_DATE ISLEM_TARIHI,
			O.DELIVERDATE TESLIM_TARIHI,
			ORR.DELIVER_DEPT DEPT_IN,
			-1 DEPT_OUT,
			O.RECORD_EMP,
			O.RECORD_DATE
		FROM 
			ORDERS O,
			ORDER_ROW ORR
		WHERE 
			ORR.ORDER_ID = O.ORDER_ID
			<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
				AND (ORR.DELIVER_DEPT = #attributes.department_id# OR O.DELIVER_DEPT_ID = #attributes.department_id#)
			</cfif>
			AND	O.ORDER_STATUS = 1 
			AND 
			(
				(O.IS_PROCESSED = 1 AND ORR.ORDER_ROW_CURRENCY IN (-3,-6,-7)) OR
				(O.IS_PROCESSED = 0 AND ORR.ORDER_ROW_CURRENCY = -6)
			)
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
				(
					O.ORDER_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
					OR O.ORDER_HEAD LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
				)
		</cfif>
		<cfif isDefined("attributes.cat") and len(attributes.cat)>
			<cfif attributes.cat eq 1>
				AND(O.ORDER_ZONE = 0 AND O.PURCHASE_SALES = 0)		
			<cfelseif attributes.cat eq 2>
				AND
				(
					(
						(O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1)
					)
					OR O.ORDER_ZONE = 2 <!--- BK 20060612 Bu sart dogru mu ??? --->
				)
			</cfif>	
		 </cfif>
		 <cfif isdefined("attributes.company") and len(attributes.company) and len(attributes.company_id)>
			 AND O.COMPANY_ID = #attributes.company_id#
		 </cfif>
		 <cfif isdefined("attributes.date1") and len(attributes.date1)>
			AND O.DELIVERDATE >= #attributes.date1#
		 </cfif>
		 <cfif isdefined("attributes.date2") and  len(attributes.date2)>
			AND O.DELIVERDATE <= #attributes.date2#
		 </cfif>	 
	</cfquery>
</cfif>
<!--- Sevk Talepleri --->
<cfif not len(attributes.cat) or listfind('3,4',attributes.cat)>
	<cfquery name="GET_ORDER_LIST_3" datasource="#DSN3#">
		SELECT
			2 TYPE_ID,
			SI.DISPATCH_SHIP_ID ISLEM_ID,
			'' ISLEM_NO,
			'' ORDER_HEAD,
			-1 PARTNER_ID,
			-1 COMPANY_ID,
			-1 CONSUMER_ID,
			-99 PRIORITY_ID,
			-1 ORDER_ZONE,
			-1 PURCHASE_SALES,
			SHIP_DATE ISLEM_TARIHI,
			DELIVER_DATE TESLIM_TARIHI,
			DEPARTMENT_IN DEPT_IN,
			DEPARTMENT_OUT DEPT_OUT,
			RECORD_EMP,
			RECORD_DATE
		FROM 
			#dsn2_alias#.SHIP_INTERNAL SI
		WHERE
			(
			DEPARTMENT_IN IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#) OR
			DEPARTMENT_OUT IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
			)
		  <cfif isDefined("attributes.cat") and attributes.cat eq 3>
			AND DISPATCH_SHIP_ID IN (SELECT DISPATCH_SHIP_ID FROM #dsn2_alias#.SHIP WHERE DISPATCH_SHIP_ID IS NOT NULL)
		  <cfelseif isDefined("attributes.cat") and attributes.cat eq 4>
			AND DISPATCH_SHIP_ID NOT IN (SELECT DISPATCH_SHIP_ID FROM #dsn2_alias#.SHIP WHERE DISPATCH_SHIP_ID IS NOT NULL)
		  </cfif>
		  <cfif isdate(attributes.date1)>
			AND SI.DELIVER_DATE >= #attributes.date1#
		  </cfif>
		  <cfif isdate(attributes.date2)>
			AND SI.DELIVER_DATE <= #attributes.date2#
		  </cfif>
	</cfquery>
</cfif>
<!--- Teslim Alinan Irsaliyeler, Teslim Alinmayan Irsaliyeler --->
<cfif not len(attributes.cat) or listfind('5,6',attributes.cat)>
	<cfquery name="GET_ORDER_LIST_4" datasource="#DSN3#">
		SELECT
			3 TYPE_ID,
			S.SHIP_ID ISLEM_ID,
			S.SHIP_NUMBER ISLEM_NO,
			'' ORDER_HEAD,
			-1 PARTNER_ID,
			-1 COMPANY_ID,
			-1 CONSUMER_ID,
			-99 PRIORITY_ID,
			-1 ORDER_ZONE,
			-1 PURCHASE_SALES,
			S.SHIP_DATE ISLEM_TARIHI,
			S.DELIVER_DATE TESLIM_TARIHI,
			S.DEPARTMENT_IN DEPT_IN,
			S.DELIVER_STORE_ID DEPT_OUT,
			S.RECORD_EMP,
			S.RECORD_DATE
		FROM 
			#dsn2_alias#.SHIP S
		WHERE
			S.SHIP_TYPE = 81
			AND S.IS_SHIP_IPTAL = 0
			AND DEPARTMENT_IN IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
		  <cfif attributes.cat eq 5>
			AND S.IS_DELIVERED = 1		
		  <cfelse>
			AND (S.IS_DELIVERED = 0 OR S.IS_DELIVERED IS NULL)
		  </cfif>	  	
		  <cfif isdate(attributes.date1)>
			AND S.DELIVER_DATE >= #attributes.date1#
		  </cfif>
		  <cfif isdate(attributes.date2)>
			AND S.DELIVER_DATE <= #attributes.date2#
		  </cfif>
		  <cfif len(attributes.keyword)>
			AND (S.SHIP_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
		  </cfif>	  	
	</cfquery>
</cfif>

<cfquery name="GET_ORDER_LIST" dbtype="query">
<!--- Siparisler --->
	<cfif not len(attributes.cat) or listfind('1',attributes.cat)>
	
		SELECT
			*
		FROM
			GET_ORDER_LIST_1
	</cfif>	
	<cfif not len(attributes.cat) or listfind('2',attributes.cat)>
	  <cfif not len(attributes.cat)>
		UNION
	  </cfif>	  
		SELECT
			*
		FROM
			GET_ORDER_LIST_2
	</cfif>
	<cfif not len(attributes.cat) or listfind('3,4',attributes.cat)>
	  <cfif not len(attributes.cat)>
		UNION
	  </cfif>
		SELECT
			*
		FROM
			GET_ORDER_LIST_3
	</cfif>
	<cfif not len(attributes.cat) or listfind('5,6',attributes.cat)>
	  <cfif not len(attributes.cat)>
		UNION
	  </cfif>
		SELECT
			*
		FROM
			GET_ORDER_LIST_4
	</cfif>
</cfquery>
