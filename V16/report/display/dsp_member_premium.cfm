<cfsetting showdebugoutput="no">
<cfset new_cons_cat_list = "3,4,5,6,7,8,14,15,16,17,18,19,20,21,22,23,24,25,26,27">
<cfset new_cons_name_list = "GL,UGL,YGL,YDGL,DGL,AGL,L,ÜL,A,GU,U,ÜU,GY,Y,ÜY,GD,D,ÜD,GYD,YD">
<cfset new_cons_color_list = "CCFF66,FFCCCC,66CCFF,FD794D,FD794D,FFCC99,808080,AD234B,FFD000,6B8E23,6B8E23,228B22,FFD000,FFD000,E45635,FD794D,FD794D,B0C4DE,4169E1,4169E1">
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset attributes.consumer_name = get_cons_info(attributes.consumer_id,0,0)>
</cfif>
<cfif not isdefined("attributes.sales_county")>
	<cfset attributes.sales_county = ''>
</cfif>
<cfquery name="get_camp_date" datasource="#dsn3#">
	SELECT CAMP_STARTDATE,CAMP_FINISHDATE,CAMP_ID FROM CAMPAIGNS WHERE CAMP_ID = #attributes.camp_id#
</cfquery>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="get_cons_cat" datasource="#dsn#">
		SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
	</cfquery>
<cfelse>
	<cfset get_cons_cat.recordcount = 0>
</cfif>
<cfquery name="get_ref_member" datasource="#DSN#">
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		SELECT
			C.CONSUMER_STATUS,
			C.CONSUMER_ID,
			C.MEMBER_CODE,
			C.CONSUMER_REFERENCE_CODE,
			C.REF_POS_CODE,
			C.CONSUMER_NAME,
			C.CONSUMER_SURNAME,
			C.CONSUMER_CAT_ID,
			(SELECT HIERARCHY FROM CONSUMER_CAT WHERE CONSCAT_ID = C.CONSUMER_CAT_ID) AS HIERARCHY,
			IMS_CODE_ID AS IMS_CODE_ID,
			MOBIL_CODE AS MOBIL_CODE,
			MOBILTEL AS MOBILTEL,
			C.CONSUMER_HOMETELCODE AS HOME_CODE,
			C.CONSUMER_HOMETEL  AS HOME_TEL,
			ISNULL((SELECT COUNT(CAMPAIGNS.CAMP_ID) FROM #dsn3_alias#.CAMPAIGNS CAMPAIGNS WHERE CAMPAIGNS.CAMP_STARTDATE >= C.RECORD_DATE),0) AS CAMP_COUNT
		FROM
			CONSUMER C
		WHERE
			C.CONSUMER_ID = #attributes.consumer_id#
	UNION ALL
	</cfif>
	SELECT
		CH.CONSUMER_STATUS,
		CH.CONSUMER_ID,
		CH.MEMBER_CODE,
		CH.CONSUMER_REFERENCE_CODE,
		CH.REF_POS_CODE,
		CH.CONSUMER_NAME,
		CH.CONSUMER_SURNAME,
		CH.CONSUMER_CAT_ID,
		(SELECT HIERARCHY FROM CONSUMER_CAT WHERE CONSCAT_ID = C.CONSUMER_CAT_ID) AS HIERARCHY,
		C.IMS_CODE_ID AS IMS_CODE_ID,
		C.MOBIL_CODE AS MOBIL_CODE,
		C.MOBILTEL  AS MOBILTEL,
		C.CONSUMER_HOMETELCODE AS HOME_CODE,
		C.CONSUMER_HOMETEL  AS HOME_TEL,
		ISNULL((SELECT COUNT(CAMPAIGNS.CAMP_ID) FROM #dsn3_alias#.CAMPAIGNS CAMPAIGNS WHERE CAMPAIGNS.CAMP_STARTDATE >= C.RECORD_DATE),0) AS CAMP_COUNT
	FROM
		CONSUMER_HISTORY CH,
		CONSUMER C
	WHERE
		C.CONSUMER_ID = CH.CONSUMER_ID
		AND CH.CAMP_ID = #attributes.camp_id#
		AND CH.MEMBER_CODE NOT LIKE 'B%'
		AND ((CH.ISPOTANTIAL = 0 AND CH.CONSUMER_STATUS = 1) OR (CH.ISPOTANTIAL = 1 AND CH.CONSUMER_STATUS = 0))
		<!--- AND CH.CONSUMER_REFERENCE_CODE IS NOT NULL --->
		<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
			<cfif isdefined("attributes.is_zone")>
				AND CH.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND <cfif isdefined("session.ep")>OUR_COMPANY_ID= #session.ep.company_id#<cfelse>OUR_COMPANY_ID= #session.ww.our_company_id#</cfif>)
				AND CH.REF_POS_CODE NOT IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND <cfif isdefined("session.ep")>OUR_COMPANY_ID= #session.ep.company_id#<cfelse>OUR_COMPANY_ID= #session.ww.our_company_id#</cfif>)
				AND CH.REF_POS_CODE <> 1
			<cfelse>
				AND CH.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND <cfif isdefined("session.ep")>OUR_COMPANY_ID= #session.ep.company_id#<cfelse>OUR_COMPANY_ID= #session.ww.our_company_id#</cfif>)
				AND CH.REF_POS_CODE IS NOT NULL
			</cfif>
		</cfif>
		<cfif isdefined("attributes.pos_code_list")>
			AND CH.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE IN(#attributes.pos_code_list#) AND IS_MASTER = 1 AND <cfif isdefined("session.ep")>OUR_COMPANY_ID= #session.ep.company_id#<cfelse>OUR_COMPANY_ID= #session.ww.our_company_id#</cfif>)
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND CH.REF_POS_CODE = #attributes.consumer_id#
		</cfif>
	UNION ALL
	SELECT
		CH.CONSUMER_STATUS,
		CH.CONSUMER_ID,
		CH.MEMBER_CODE,
		CH.CONSUMER_REFERENCE_CODE,
		CH.REF_POS_CODE,
		CH.CONSUMER_NAME,
		CH.CONSUMER_SURNAME,
		CH.CONSUMER_CAT_ID,
		(SELECT HIERARCHY FROM CONSUMER_CAT WHERE CONSCAT_ID = C.CONSUMER_CAT_ID) AS HIERARCHY,
		C.IMS_CODE_ID AS IMS_CODE_ID,
		C.MOBIL_CODE AS MOBIL_CODE,
		C.MOBILTEL  AS MOBILTEL,
		C.CONSUMER_HOMETELCODE AS HOME_CODE,
		C.CONSUMER_HOMETEL  AS HOME_TEL,
		ISNULL((SELECT COUNT(CAMPAIGNS.CAMP_ID) FROM #dsn3_alias#.CAMPAIGNS CAMPAIGNS WHERE CAMPAIGNS.CAMP_STARTDATE >= C.RECORD_DATE),0) AS CAMP_COUNT
	FROM 
		CONSUMER_HISTORY CH,
		CONSUMER C
	WHERE
		C.CONSUMER_ID = CH.CONSUMER_ID
		AND ((CH.ISPOTANTIAL = 0 AND CH.CONSUMER_STATUS = 1) OR (CH.ISPOTANTIAL = 1 AND CH.CONSUMER_STATUS = 0 AND CH.RECORD_DATE >= #createodbcdatetime(get_camp_date.camp_startdate)#))
		<!--- AND CH.CONSUMER_REFERENCE_CODE IS NOT NULL --->
		AND CH.MEMBER_CODE NOT LIKE 'B%'
		<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
			<cfif isdefined("attributes.is_zone")>
				AND CH.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND <cfif isdefined("session.ep")>OUR_COMPANY_ID= #session.ep.company_id#<cfelse>OUR_COMPANY_ID= #session.ww.our_company_id#</cfif>)
				AND CH.REF_POS_CODE NOT IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND <cfif isdefined("session.ep")>OUR_COMPANY_ID= #session.ep.company_id#<cfelse>OUR_COMPANY_ID= #session.ww.our_company_id#</cfif>)
				AND CH.REF_POS_CODE <> 1
			<cfelse>
				AND CH.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND <cfif isdefined("session.ep")>OUR_COMPANY_ID= #session.ep.company_id#<cfelse>OUR_COMPANY_ID= #session.ww.our_company_id#</cfif>)
				AND CH.REF_POS_CODE IS NOT NULL
			</cfif>
		</cfif>
		<cfif isdefined("attributes.pos_code_list")>
			AND CH.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE IN(#attributes.pos_code_list#) AND IS_MASTER = 1 AND <cfif isdefined("session.ep")>OUR_COMPANY_ID= #session.ep.company_id#<cfelse>OUR_COMPANY_ID= #session.ww.our_company_id#</cfif>)
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND CH.REF_POS_CODE = #attributes.consumer_id#
		</cfif>
		AND CH.CONSUMER_ID NOT IN (SELECT CONSUMER_ID FROM CONSUMER_HISTORY WHERE CAMP_ID = #attributes.camp_id#)
		AND CH.RECORD_DATE <= #createodbcdatetime(get_camp_date.camp_finishdate)#
		AND CH.CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM CONSUMER_HISTORY CHH WHERE CHH.CONSUMER_ID = CH.CONSUMER_ID AND CHH.RECORD_DATE <= #createodbcdatetime(get_camp_date.camp_finishdate)#)
	ORDER BY HIERARCHY DESC
</cfquery>
<cfif get_ref_member.recordcount>
	<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_ref_member.consumer_id,',')),'numeric','ASC',',')>
	<cfquery name="get_paymethod" datasource="#dsn#" dbtype="query">
		SELECT
			SP.PAYMETHOD_ID,
			SP.PAYMETHOD,
			CC.CONSUMER_ID
		FROM
			SETUP_PAYMETHOD SP,
			SETUP_PAYMETHOD_OUR_COMPANY SPOC,
			COMPANY_CREDIT CC
		WHERE
			SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
			AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfif get_ref_member.recordcount lt 2100>
			AND CC.CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
		<cfelse>
			AND CC.CONSUMER_ID IN (#valuelist(get_ref_member.consumer_id)#)
		</cfif>
			AND CC.REVMETHOD_ID IS NOT NULL
		<cfif isdefined("session.ep")>
			AND CC.OUR_COMPANY_ID = #session.ep.company_id#
		<cfelse>
			AND CC.OUR_COMPANY_ID = #session.ww.our_company_id#
		</cfif>
			AND CC.REVMETHOD_ID = SP.PAYMETHOD_ID
	</cfquery>
	<cfquery name="get_card_paymethod" datasource="#dsn#" dbtype="query">
		SELECT
			SP.PAYMENT_TYPE_ID,
			SP.CARD_NO,
			CC.CONSUMER_ID
		FROM
			#dsn3_alias#.CREDITCARD_PAYMENT_TYPE SP,
			COMPANY_CREDIT CC
		WHERE
		<cfif get_ref_member.recordcount lt 2100>	
			CC.CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->			
		<cfelse>
			CC.CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->			
		</cfif>
			AND CC.CARD_REVMETHOD_ID IS NOT NULL
			<cfif isdefined("session.ep")>
				AND CC.OUR_COMPANY_ID = #session.ep.company_id#
			<cfelse>
				AND CC.OUR_COMPANY_ID = #session.ww.our_company_id#
			</cfif>
			AND CC.CARD_REVMETHOD_ID = SP.PAYMENT_TYPE_ID
	</cfquery>
	<cfquery name="get_member_sale" datasource="#dsn2#">
		SELECT 
			ISNULL(SUM(NETTOTAL),0) NETTOTAL,
			ISNULL(SUM(INV_NETTOTAL),0) INV_NETTOTAL,
			CONSUMER_ID
		FROM(
			SELECT
				SUM(NETTOTAL) NETTOTAL,
				SUM(INV_NETTOTAL) INV_NETTOTAL,
				CONSUMER_ID		
			FROM
				CONSUMER_SALE
			WHERE	
				CONSUMER_ID IN(#consumer_id_list#)
				AND INVOICE_CAT IN(52,53,54,55)
				<cfif get_camp_date.recordcount gt 0>
					AND INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
				</cfif>
			GROUP BY
				CONSUMER_ID
			)T1		
		GROUP BY
			CONSUMER_ID							
	</cfquery>
	<cfquery name="get_member_all_sale" datasource="#dsn2#" dbtype="query">
		SELECT 
			ISNULL(SUM(NETTOTAL),0) NETTOTAL,
			ISNULL(SUM(INV_NETTOTAL),0) INV_NETTOTAL,
			CONSUMER_ID
		FROM(
			SELECT
				SUM(NETTOTAL) NETTOTAL,
				SUM(INV_NETTOTAL) INV_NETTOTAL,
				CONSUMER_ID		
			FROM
				CONSUMER_SALE
			WHERE
			<cfif get_ref_member.recordcount lt 2100>	
				CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			<cfelse>
				CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			</cfif>
			GROUP BY
				CONSUMER_ID
			)T1		
		GROUP BY
			CONSUMER_ID							
	</cfquery>
	<cfquery name="get_pay_member_sale" datasource="#dsn2#" dbtype="query">
		SELECT
			CONSUMER_ID,
			SUM(NETTOTAL) NETTOTAL
		FROM
			(
				SELECT DISTINCT
					REF_CONSUMER_ID CONSUMER_ID,
					(ISNULL((SELECT SUM(CR.CLOSED_AMOUNT) FROM CARI_CLOSED_ROW CR WHERE CR.ACTION_ID = I.INVOICE_ID AND CR.ACTION_TYPE_ID = I.INVOICE_CAT),0)-(I.INV_GROSSTOTAL-I.GROSSTOTAL)) AS NETTOTAL
				FROM
					INVOICE_MULTILEVEL_SALES I
				WHERE
					I.INVOICE_CAT IN(52,53)
					<cfif get_ref_member.recordcount lt 2100>	
						AND I.REF_CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
					<cfelse>
						AND I.REF_CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
					</cfif>
					<cfif get_camp_date.recordcount gt 0>
						AND I.INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
					</cfif>
				GROUP BY
					I.REF_CONSUMER_ID,
					I.INVOICE_CAT,
					I.INVOICE_ID,
					I.GROSSTOTAL,
					I.INV_GROSSTOTAL
			)T1
		GROUP BY
			CONSUMER_ID		
	</cfquery>
	<cfquery name="get_return_sale" datasource="#dsn2#" dbtype="query">
		SELECT
			SUM(NETTOTAL) NETTOTAL,
			CONSUMER_ID
		FROM
			(
				SELECT DISTINCT
					REF_CONSUMER_ID CONSUMER_ID,
					I.GROSSTOTAL NETTOTAL
				FROM
					INVOICE_MULTILEVEL_SALES I
				WHERE
					I.INVOICE_CAT IN(54,55,62)
					<cfif get_ref_member.recordcount lt 2100>
						AND I.REF_CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
					<cfelse>
						AND I.REF_CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
					</cfif>
					<cfif get_camp_date.recordcount gt 0>
						AND I.INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
					</cfif>
			)T1
		GROUP BY
			CONSUMER_ID
	</cfquery>
	<cfquery name="get_order_count" datasource="#dsn2#">
		SELECT
			COUNT(INVOICE_ID) COUNT_ORDER,
			CONSUMER_ID
		FROM
			CONSUMER_SALE
		WHERE
			INVOICE_CAT IN(52,53)
			AND CONSUMER_ID IS NOT NULL
			<cfif get_ref_member.recordcount lt 2100>
				AND CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			<cfelse>
				AND CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->		
			</cfif>
			AND NETTOTAL > 0
			<cfif get_camp_date.recordcount gt 0>
				AND INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
			</cfif>
		GROUP BY
			CONSUMER_ID
	</cfquery>
	<cfquery name="get_order_count_2" datasource="#dsn3#">
		SELECT
			COUNT(ORDER_ID) COUNT_ORDER,
			CONSUMER_ID
		FROM
			ORDERS
		WHERE
			ORDER_STATUS = 1
			AND NETTOTAL > 0
			AND CONSUMER_ID IS NOT NULL
			AND CONSUMER_ID IN(#consumer_id_list#)
			AND ORDER_ID IN(SELECT OI.ORDER_ID FROM ORDERS_INVOICE OI WHERE OI.ORDER_ID = ORDERS.ORDER_ID)
		GROUP BY
			CONSUMER_ID
	</cfquery>
	<cfquery name="get_last_camp" datasource="#dsn3#">
		SELECT
			C.CAMP_HEAD,
			C.CAMP_NO,
			I.CONSUMER_ID
		FROM
			ORDERS I,
			CAMPAIGNS C
		WHERE
			ORDER_STATUS = 1
			AND NETTOTAL > 0
			AND I.CONSUMER_ID IS NOT NULL
			AND I.CONSUMER_ID IN(#consumer_id_list#)
			AND ORDER_DATE BETWEEN C.CAMP_STARTDATE AND C.CAMP_FINISHDATE
			AND I.ORDER_ID = ISNULL((SELECT MAX(OO.ORDER_ID) FROM ORDERS OO WHERE I.CONSUMER_ID = OO.CONSUMER_ID AND OO.ORDER_STATUS = 1 AND OO.NETTOTAL > 0),0)
			AND I.ORDER_ID IN(SELECT OI.ORDER_ID FROM ORDERS_INVOICE OI WHERE OI.ORDER_ID = I.ORDER_ID)
		ORDER BY
			I.ORDER_DATE DESC
	</cfquery>
	<cfquery name="get_first_camp_" datasource="#dsn3#" maxrows="3">
		SELECT CAMP_STARTDATE,CAMP_FINISHDATE,CAMP_ID FROM CAMPAIGNS WHERE CAMP_STARTDATE <=#createodbcdatetime(get_camp_date.camp_startdate)# ORDER BY CAMP_FINISHDATE DESC
	</cfquery>
	<cfquery name="get_min_camp_" dbtype="query" maxrows="1">
		SELECT CAMP_ID FROM get_first_camp_ ORDER BY CAMP_FINISHDATE
	</cfquery>
	<cfquery name="get_last_camp_" datasource="#dsn3#">
		SELECT CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #get_min_camp_.camp_id#
	</cfquery>
	<cfquery name="get_total_member" datasource="#dsn#" dbtype="query">
		SELECT
			C.CONSUMER_ID
		FROM
			CONSUMER_HISTORY C,
			#dsn3_alias#.ORDERS O
		WHERE
			C.CONSUMER_STATUS = 1 AND
			<cfif get_ref_member.recordcount lt 2100>
				C.CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			<cfelse>
				C.CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			</cfif>
			AND C.CONSUMER_ID = O.CONSUMER_ID 
			AND O.NETTOTAL > 0
			AND O.ORDER_STATUS=1
			AND O.ORDER_ID = (SELECT MIN(OO.ORDER_ID) FROM #dsn3_alias#.ORDERS OO WHERE OO.CONSUMER_ID = C.CONSUMER_ID AND OO.ORDER_STATUS=1)
			AND C.CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM CONSUMER_HISTORY CHH WHERE CHH.CONSUMER_ID = C.CONSUMER_ID AND CHH.RECORD_DATE <= #createodbcdatetime(get_camp_date.camp_finishdate)#)
			AND O.ORDER_DATE <= #createodbcdatetime(get_camp_date.camp_finishdate)#
	</cfquery>
	<cfquery name="get_new_consumer" datasource="#dsn#" dbtype="query">
		SELECT
			C.CONSUMER_ID
		FROM
			CONSUMER C,
			#dsn3_alias#.ORDERS O
		WHERE
			C.CONSUMER_STATUS = 1
			<cfif get_ref_member.recordcount lt 2100>
				AND C.CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			<cfelse>
				AND C.CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->		
			</cfif>
			AND C.ISPOTANTIAL = 0
			AND C.CONSUMER_ID = O.CONSUMER_ID 
			AND O.ORDER_STATUS=1
			AND O.NETTOTAL > 0
			AND O.ORDER_ID = (SELECT TOP 1 ORDER_ID FROM workcube_dore_1.ORDERS OO WHERE OO.CONSUMER_ID = C.CONSUMER_ID AND OO.ORDER_STATUS=1 AND OO.NETTOTAL >0 ORDER BY ORDER_DATE)
			AND O.ORDER_DATE >= #createodbcdatetime(get_camp_date.camp_startdate)#
			AND O.ORDER_DATE <= #createodbcdatetime(get_camp_date.camp_finishdate)#
	</cfquery>
	<cfset new_consumer_id_list = valuelist(get_new_consumer.consumer_id)>
	<cfquery name="get_new_consumer_1_3" datasource="#dsn#" dbtype="query">
		SELECT
			C.CONSUMER_ID
		FROM
			CONSUMER C,
			#dsn3_alias#.ORDERS O
		WHERE
			C.CONSUMER_STATUS = 1
			<cfif get_ref_member.recordcount lt 2100>
				AND C.CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->			
			<cfelse>
				AND C.CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			</cfif>
			AND C.ISPOTANTIAL = 0
			AND C.CONSUMER_ID = O.CONSUMER_ID 
			AND O.ORDER_STATUS=1
			AND O.ORDER_ID = (SELECT MIN(OO.ORDER_ID) FROM #dsn3_alias#.ORDERS OO WHERE OO.CONSUMER_ID = C.CONSUMER_ID AND OO.ORDER_STATUS=1)
			AND O.ORDER_DATE >= #createodbcdatetime(get_last_camp_.camp_startdate)#
	</cfquery>
	<cfset new_consumer_id_list_1_3 = valuelist(get_new_consumer_1_3.consumer_id)>
	<cfquery name="get_consumer_2" datasource="#dsn#">
		SELECT DISTINCT
			CH.CONSUMER_ID
		FROM
			CONSUMER_HISTORY CH
		WHERE
			CONSUMER_ID IN(#consumer_id_list#)
			AND CH.CONSUMER_STATUS IS NOT NULL
			AND CH.CONSUMER_STATUS = 0
			AND CH.RECORD_DATE >= #createodbcdatetime(get_camp_date.camp_startdate)#
			AND CH.RECORD_DATE <= #createodbcdatetime(DATEADD('d',1,get_camp_date.camp_finishdate))#
			AND CH.CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM CONSUMER_HISTORY CHH WHERE CHH.CONSUMER_ID = CH.CONSUMER_ID AND CHH.RECORD_DATE >= #createodbcdatetime(get_camp_date.camp_startdate)# AND CHH.RECORD_DATE <= #createodbcdatetime(DATEADD('d',1,get_camp_date.camp_finishdate))#)
	</cfquery>
	<cfset old_consumer_id_list = valuelist(get_consumer_2.consumer_id)>
	<cfquery name="get_consumer_3" datasource="#dsn#" dbtype="query">
		SELECT DISTINCT
			CH.CONSUMER_ID
		FROM
			CONSUMER_HISTORY CH
		WHERE
			CONSUMER_ID IN(#consumer_id_list#)
			AND CH.CONSUMER_STATUS = 1
			AND CH.RECORD_DATE >= #createodbcdatetime(get_camp_date.camp_startdate)#
			AND CH.CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM CONSUMER_HISTORY CHH WHERE CHH.CONSUMER_ID = CH.CONSUMER_ID AND CHH.RECORD_DATE >= #createodbcdatetime(get_camp_date.camp_startdate)#)
			AND CH.CONSUMER_ID IN(SELECT OOO.CONSUMER_ID FROM #dsn3_alias#.ORDERS OOO WHERE OOO.ORDER_STATUS = 1 AND OOO.CONSUMER_ID IS NOT NULL AND OOO.CONSUMER_ID = CH.CONSUMER_ID)
			AND CH.CONSUMER_ID IN(
								SELECT
									CH_.CONSUMER_ID
								FROM
									CONSUMER_HISTORY CH_
								WHERE
									CH_.CONSUMER_ID =CH.CONSUMER_ID
									AND CH_.CONSUMER_STATUS = 0
									AND CH_.RECORD_DATE < #createodbcdatetime(get_camp_date.camp_startdate)#
									AND CH_.CONSUMER_HISTORY_ID = (SELECT MAX(CHH_.CONSUMER_HISTORY_ID) FROM CONSUMER_HISTORY CHH_ WHERE CHH_.CONSUMER_ID = CH_.CONSUMER_ID AND CHH_.RECORD_DATE < #createodbcdatetime(get_camp_date.camp_startdate)#)
								)
	</cfquery>
	<cfquery name="get_catalog_order" datasource="#dsn2#" dbtype="query">
		SELECT
			SUM(IR.AMOUNT) CATALOG_COUNT,
			CONSUMER_ID
		FROM
			INVOICE I,
			INVOICE_ROW IR,
			#dsn3_alias#.PRODUCT PP
		WHERE
			I.INVOICE_ID = IR.INVOICE_ID
			AND IR.PRODUCT_ID = PP.PRODUCT_ID
			AND PP.PRODUCT_CATID IN(99,100,101,102)
			AND I.PURCHASE_SALES = 1 
			AND I.INVOICE_CAT IN(52,53)
			AND I.CONSUMER_ID IS NOT NULL
			<cfif get_ref_member.recordcount lt 2100>
				AND I.CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			<cfelse>
				AND I.CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			</cfif>
			AND I.IS_IPTAL = 0
			AND IR.PRICE > 0
			<cfif get_camp_date.recordcount gt 0>
				AND I.INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
			</cfif>
		GROUP BY
			I.CONSUMER_ID
	</cfquery>
	<cfquery name="get_catalogs" datasource="#dsn2#" dbtype="query">
		SELECT
			ISNULL(SUM(IR.AMOUNT),0) CATALOG_COUNT,
			IR.PRODUCT_ID
		FROM
			INVOICE I,
			INVOICE_ROW IR,
			#dsn3_alias#.PRODUCT PP
		WHERE
			I.INVOICE_ID = IR.INVOICE_ID
			AND IR.PRODUCT_ID = PP.PRODUCT_ID
			AND PP.PRODUCT_CATID IN(99,100,101,102)
			AND I.PURCHASE_SALES = 1 
			AND I.INVOICE_CAT IN(52,53)
			<cfif get_ref_member.recordcount lt 2100>
				AND I.CONSUMER_ID IN (<cfqueryparam value="#ValueList(get_ref_member.consumer_id)#" cfsqltype="cf_sql_integer" list="true" />)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			<cfelse>
				AND I.CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)<!--- (#valuelist(get_ref_member.CONSUMER_ID)#) --->
			</cfif>
			AND I.IS_IPTAL = 0
			AND IR.PRICE > 0
			<cfif get_camp_date.recordcount gt 0>
				AND I.INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
			</cfif>
		GROUP BY
			IR.PRODUCT_ID
	</cfquery>
	<cfquery name="get_products" datasource="#dsn3#">
		SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_CATID IN(99,100,101,102)
	</cfquery>
	<cfset back_consumer_id_list = valuelist(get_consumer_3.consumer_id)>
	<cfquery name="get_cons_bakiye" datasource="#DSN2#">
		SELECT 
			SUM(BAKIYE) BAKIYE,
			CONSUMER_ID
		FROM
		(
			SELECT  
				ROUND((CR.ACTION_VALUE-ISNULL((SELECT SUM(ICR.CLOSED_AMOUNT) FROM CARI_CLOSED_ROW ICR WHERE ICR.ACTION_ID = CR.ACTION_ID AND ICR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID),0)),2) AS BAKIYE,
				CR.TO_CONSUMER_ID CONSUMER_ID
			FROM 
				CARI_ROWS CR 
			WHERE 
				CR.TO_CONSUMER_ID IN  (#ValueList(get_ref_member.consumer_id)#)
				<!--- AND CR.DUE_DATE > #createodbcdatetime(DATEADD('d',-1,now()))# --->
				AND CR.ACTION_TYPE_ID <> 40
				AND CR.ACTION_ID NOT IN(SELECT CRR.INVOICE_ID FROM CARI_ACTIONS CRR WHERE CRR.INVOICE_ID IS NOT NULL)
			UNION ALL
			SELECT  
				ROUND((CR.ACTION_VALUE-ISNULL((SELECT SUM(ICR.CLOSED_AMOUNT) FROM CARI_CLOSED_ROW ICR WHERE ICR.CARI_ACTION_ID = CR.CARI_ACTION_ID AND ICR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID),0)),2) AS BAKIYE,
				CR.TO_CONSUMER_ID CONSUMER_ID
			FROM 
				CARI_ROWS CR 
			WHERE 
				CR.TO_CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)
				<!--- AND CR.DUE_DATE > #createodbcdatetime(DATEADD('d',-1,now()))# --->
				AND CR.ACTION_TYPE_ID = 40
				AND CR.CARI_ACTION_ID NOT IN(SELECT CRR.RELATED_CARI_ACTION_ID FROM CARI_ACTIONS CRR WHERE CRR.RELATED_CARI_ACTION_ID IS NOT NULL)
		)T1
		GROUP BY
			CONSUMER_ID
	</cfquery>

	<cfquery name="get_cons_bakiye2" datasource="#DSN2#">
		SELECT 
			SUM(BAKIYE) BAKIYE,
			CONSUMER_ID
		FROM
		(
			SELECT  
				ROUND((CR.ACTION_VALUE-ISNULL((SELECT SUM(ICR.CLOSED_AMOUNT) FROM CARI_CLOSED_ROW ICR WHERE ICR.ACTION_ID = CR.ACTION_ID AND ICR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID),0)),2) AS BAKIYE,
				CR.TO_CONSUMER_ID CONSUMER_ID
			FROM 
				CARI_ROWS CR 
			WHERE 
				CR.TO_CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)
				AND CR.DUE_DATE < #now()#
				AND CR.ACTION_TYPE_ID = 53
				AND CR.ACTION_ID IN(SELECT CRR.INVOICE_ID FROM CARI_ACTIONS CRR WHERE CRR.INVOICE_ID IS NOT NULL)
			UNION ALL
			SELECT  
				ROUND((CR.ACTION_VALUE-ISNULL((SELECT SUM(ICR.CLOSED_AMOUNT) FROM CARI_CLOSED_ROW ICR WHERE ICR.CARI_ACTION_ID = CR.CARI_ACTION_ID AND ICR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID),0)),2) AS BAKIYE,
				CR.TO_CONSUMER_ID CONSUMER_ID
			FROM 
				CARI_ROWS CR 
			WHERE 
				CR.TO_CONSUMER_ID IN (#ValueList(get_ref_member.consumer_id)#)
				AND CR.DUE_DATE < #now()#
				AND CR.ACTION_TYPE_ID = 40
				AND CR.CARI_ACTION_ID IN(SELECT CRR.RELATED_CARI_ACTION_ID FROM CARI_ACTIONS CRR WHERE CRR.RELATED_CARI_ACTION_ID IS NOT NULL)
		)T1
		GROUP BY
			CONSUMER_ID
	</cfquery>
	<cfif isdefined("attributes.is_total")>
		<cfquery name="get_pasive_return_sale" datasource="#dsn2#">
			SELECT
				ISNULL(SUM(NETTOTAL),0) NETTOTAL
			FROM
				(
					SELECT
						I.GROSSTOTAL NETTOTAL
					FROM
						INVOICE_MULTILEVEL_SALES I
					WHERE
						I.INVOICE_CAT IN(54,55,62)
						AND REF_CONSUMER_ID IN(
												SELECT 
													CH.CONSUMER_ID
												FROM
													#dsn_alias#.CONSUMER_HISTORY CH
												WHERE
													CH.RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)#				
													AND CH.CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM #dsn_alias#.CONSUMER_HISTORY CHH WHERE CHH.CONSUMER_ID = CH.CONSUMER_ID AND CHH.RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)#)
													<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
														AND CH.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND <cfif isdefined("session.ep")>OUR_COMPANY_ID= #session.ep.company_id#<cfelse>OUR_COMPANY_ID= #session.ww.our_company_id#</cfif>)
													<cfelse>
														AND CH.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE IN(#attributes.pos_code_list#) AND IS_MASTER = 1 AND <cfif isdefined("session.ep")>OUR_COMPANY_ID= #session.ep.company_id#<cfelse>OUR_COMPANY_ID= #session.ww.our_company_id#</cfif>)
													</cfif>
													AND CH.CONSUMER_STATUS = 0
												)
						<cfif get_camp_date.recordcount gt 0>
							AND INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
						</cfif>
				)T1
		</cfquery>
	</cfif>
	<cfloop query="get_cons_bakiye">
		<cfif len(bakiye)>	
			<cfset 'bakiye_#get_cons_bakiye.consumer_id#'= get_cons_bakiye.bakiye>
		</cfif>
	</cfloop>
	<cfloop query="get_cons_bakiye2">
		<cfif len(bakiye)>	
			<cfset 'bakiye2_#get_cons_bakiye2.consumer_id#'= get_cons_bakiye2.bakiye>
		</cfif>
	</cfloop>
	<cfloop query="get_member_sale">
		<cfif len(get_member_sale.nettotal)>	
			<cfset 'member_sale_#get_member_sale.consumer_id#'= get_member_sale.nettotal>
		</cfif>
		<cfif len(get_member_sale.inv_nettotal)>	
			<cfset 'total_member_sale_#get_member_sale.consumer_id#'= get_member_sale.inv_nettotal>
		</cfif>
		<cfif len(get_member_sale.inv_nettotal) and len(get_member_sale.nettotal)>	
			<cfset 'other_member_sale_#get_member_sale.consumer_id#'= get_member_sale.inv_nettotal - get_member_sale.nettotal>
		</cfif>
	</cfloop>
	<cfloop query="get_member_all_sale">
		<cfif len(get_member_all_sale.nettotal)>	
			<cfset 'all_member_sale_#get_member_all_sale.consumer_id#'= get_member_all_sale.nettotal+(get_member_all_sale.inv_nettotal-get_member_all_sale.nettotal)>
		</cfif>
	</cfloop>
	<cfloop query="get_pay_member_sale">
		<cfif len(get_pay_member_sale.nettotal)>	
			<cfset 'pay_member_sale_#get_pay_member_sale.consumer_id#'= get_pay_member_sale.nettotal>
		</cfif>
	</cfloop>
	<cfloop query="get_return_sale">
		<cfif len(get_return_sale.nettotal)>	
			<cfset 'return_member_sale_#get_return_sale.consumer_id#'= get_return_sale.nettotal>
		</cfif>
	</cfloop>
	<cfloop query="get_order_count">
		<cfif len(get_order_count.count_order)>	
			<cfset 'order_count_#get_order_count.consumer_id#'= get_order_count.count_order>
		</cfif>
	</cfloop>
	<cfloop query="get_order_count_2">
		<cfif len(get_order_count_2.count_order)>	
			<cfset 'order_count_2_#get_order_count_2.consumer_id#'= get_order_count_2.count_order>
		</cfif>
	</cfloop>
	<cfloop query="get_catalog_order">
		<cfif len(get_catalog_order.catalog_count)>	
			<cfset 'catalog_count_#get_catalog_order.consumer_id#'= get_catalog_order.catalog_count>
		</cfif>
	</cfloop>
	<cfloop query="get_catalogs">
		<cfif len(get_catalogs.catalog_count)>	
			<cfset 'catalog_count_all_#get_catalogs.product_id#'= get_catalogs.catalog_count>
		</cfif>
	</cfloop>
	<cfloop query="get_last_camp">
		<cfset 'last_camp_#get_last_camp.consumer_id#'= get_last_camp.camp_head>
	</cfloop>
	<cfloop query="get_paymethod">
		<cfset 'pay_method_#get_paymethod.consumer_id#'= get_paymethod.paymethod>
	</cfloop>
	<cfloop query="get_card_paymethod">
		<cfset 'card_pay_method_#get_card_paymethod.consumer_id#'= get_card_paymethod.card_no>
	</cfloop>
<cfelse>
	<cfset get_total_member.recordcount = 0>
</cfif>
<cfquery name="get_premium_cons" datasource="#dsn#">
	SELECT 
    	CONSCAT_ID, 
        CONSCAT, 
        IS_PREMIUM, 
        HIERARCHY, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP
    FROM 
    	CONSUMER_CAT 
    WHERE 
	    IS_PREMIUM = 0 
    ORDER BY 
    	HIERARCHY
</cfquery>
<cfoutput query="get_premium_cons">
	<cfset "cons_count_#get_premium_cons.conscat_id#" = 0>
</cfoutput>
<cfif get_cons_cat.recordcount>
	<cfif listfind(new_cons_cat_list,get_cons_cat.consumer_cat_id)>
		<cfset back_color = listgetat(new_cons_color_list,listfind(new_cons_cat_list,get_cons_cat.consumer_cat_id))>
	<cfelse>
		<cfset back_color = 'FFCC99'>
	</cfif>
<cfelseif not isdefined("attributes.is_color")>
	<cfset back_color = 'FFCC99'>
</cfif>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" <cfif isdefined("back_color")>style="background-color:<cfoutput>#back_color#</cfoutput><cfelse>class="color-row"</cfif>">
	<cfscript>
		active_member_count = 0;
		total_net_sale = 0;
		total_prim_sale = 0;
		ref_member_net_sale = 0;
		ref_member_prim_sale = 0;
		total_order_count = 0;
		total_catalog_count = 0;
		member_net_sale_1 = 0;
		prim_member_net_sale_1 = 0;
		member_net_sale_1_3 = 0;
		ref_consumer_list_1 = '';
		ref_consumer_list_2 = '';
		ref_consumer_list_3 = '';
		act_ref_consumer_list_1 = '';
		act_ref_consumer_list_2 = '';
		act_ref_consumer_list_3 = '';
		total_return = 0;
		total_bakiye = 0;
		total_bakiye_2 = 0;
		total_other_sale = 0;
		total_k= 0;
		total_c= 0;
		total_g= 0;
		total_b= 0;
	</cfscript>					
	<cfoutput query="get_ref_member">
		<cfif (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name) and attributes.consumer_id neq consumer_id) or not (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name))>
			<cfif isdefined("cons_count_#consumer_cat_id#")>
				<cfset "cons_count_#consumer_cat_id#" = evaluate("cons_count_#consumer_cat_id#")+1>
			</cfif>
		</cfif>
		<cfif isdefined("total_member_sale_#consumer_id#")><cfset member_net_sale = evaluate("total_member_sale_#consumer_id#")><cfelse><cfset member_net_sale = 0></cfif>
		<cfif isdefined("member_sale_#consumer_id#")><cfset member_sale =evaluate("member_sale_#consumer_id#")><cfelse><cfset member_sale =0></cfif>
			<cfif isdefined("other_member_sale_#consumer_id#")><cfset other_member_sale =evaluate("other_member_sale_#consumer_id#")><cfelse><cfset other_member_sale =0></cfif>
		<cfif isdefined("return_member_sale_#consumer_id#")>
			<cfset return_value = evaluate("return_member_sale_#consumer_id#")>
		<cfelse>
			<cfset return_value = 0>
		</cfif>
		<cfif isdefined("pay_member_sale_#consumer_id#")>
			<cfset pay_value = evaluate("pay_member_sale_#consumer_id#")>
		<cfelse>
			<cfset pay_value = 0>
		</cfif>
		<cfif member_sale lt (pay_value-return_value)><cfset prim_sale = member_sale><cfelseif pay_value-return_value gt 0><cfset prim_sale = pay_value-return_value><cfelse><cfset prim_sale = 0></cfif>
		<cfif isdefined("order_count_#consumer_id#")><cfset order_count=evaluate("order_count_#consumer_id#")><cfelse><cfset order_count=0></cfif>
		<cfif isdefined("order_count_2_#consumer_id#")><cfset order_count_2=evaluate("order_count_2_#consumer_id#")><cfelse><cfset order_count_2=0></cfif>
		<cfif listfind(new_consumer_id_list,consumer_id,',')>
			<cfif (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name) and attributes.consumer_id neq consumer_id) or not (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name))>
				<cfset total_k = total_k + 1>
			</cfif>									
			<cfset member_net_sale_1 = member_net_sale_1 + member_sale>
		<cfelseif listfind(old_consumer_id_list,consumer_id,',')>
			<cfif (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name) and attributes.consumer_id neq consumer_id) or not (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name))>
				<cfset total_c = total_c + 1>
			</cfif>
		<cfelseif listfind(back_consumer_id_list,consumer_id,',')>
			<cfif (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name) and attributes.consumer_id neq consumer_id) or not (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name))>
				<cfset total_g = total_g + 1>
			</cfif>
		<cfelseif order_count_2 eq 0 and consumer_status eq 1>
			<cfif (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name) and attributes.consumer_id neq consumer_id) or not (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name))>
				<cfset total_b = total_b + 1>	
			</cfif>		
		</cfif>
		<cfif listfind(new_consumer_id_list_1_3,consumer_id,',')>
			<cfset member_net_sale_1_3 = member_net_sale_1_3 + member_sale>
		</cfif>						
		<cfif not isdefined("catalog_count_#consumer_id#")>
			<cfset "catalog_count_#consumer_id#" = 0>
		</cfif>
		<cfif isdefined("bakiye_#consumer_id#")>
			<cfset bakiye = evaluate("bakiye_#consumer_id#")>
		<cfelse>
			<cfset bakiye = 0>
		</cfif>
		<cfif isdefined("bakiye2_#consumer_id#")>
			<cfset bakiye_2 = evaluate("bakiye2_#consumer_id#")>
		<cfelse>
			<cfset bakiye_2 = 0>
		</cfif>
		
		<cfif bakiye gte 0><cfset total_bakiye = total_bakiye + bakiye></cfif>
		<cfif bakiye_2 gte 0><cfset total_bakiye_2 = total_bakiye_2 + bakiye_2></cfif>
		<cfset total_return = total_return + return_value>
		<cfset total_catalog_count = total_catalog_count + evaluate("catalog_count_#consumer_id#")>
		<cfif (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name) and attributes.consumer_id neq consumer_id) or not (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name))>
			<cfscript>
				if(isdefined("order_count_#consumer_id#") and  evaluate("order_count_#consumer_id#") gt 0)
					active_member_count = active_member_count + 1;
				total_net_sale = total_net_sale + member_net_sale;
				total_prim_sale = total_prim_sale + member_sale;
				total_order_count = total_order_count + order_count;
				total_other_sale = total_other_sale + other_member_sale;
			</cfscript>
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name) and attributes.consumer_id eq consumer_id>
			<cfscript>
					ref_member_net_sale = ref_member_net_sale + member_net_sale;
					ref_member_prim_sale = ref_member_prim_sale + member_sale;
			</cfscript>
		</cfif>
	</cfoutput>
	<tr>
		<td valign="top">
			<table border="0">
				<cfif get_ref_member.recordcount>
					<cfquery name="get_all_paymethod" dbtype="query">
						SELECT COUNT(CONSUMER_ID) AS PAY_COUNT,PAYMETHOD FROM get_paymethod GROUP BY PAYMETHOD
					</cfquery>
					<cfquery name="get_all_card_paymethod" dbtype="query">
						SELECT COUNT(CONSUMER_ID) AS PAY_COUNT,CARD_NO FROM get_card_paymethod GROUP BY CARD_NO
					</cfquery>
				<cfelse>
					<cfset get_all_paymethod.recordcount = 0>
					<cfset get_all_card_paymethod.recordcount = 0>
					<cfset get_products.recordcount = 0>
				</cfif>
				<cfoutput>
					<tr <cfif isdefined("back_color")>style="background-color:#back_color#"<cfelse>class="color-row"</cfif>>
						<td width="120"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57908.Temsilci'></td>
						<td> : </td>
						<td width="70" align="right" style="text-align:right;"><cfif (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.consumer_name)) and get_total_member.recordcount gt 0><cfset total_count = get_total_member.recordcount-1>#get_total_member.recordcount-1#<cfelse><cfset total_count = get_total_member.recordcount>#get_total_member.recordcount#</cfif></td>
						<td width="15"></td>
						<td width="120"><cf_get_lang dictionary_id='32282.Aktif Temsilci'></td>
						<td> : </td>
						<td width="70" align="right" style="text-align:right;"><cfset aktif_count =active_member_count>#aktif_count#</td>
						<td width="15"></td>
						<td ><cf_get_lang dictionary_id='35977.Sipariş Sayısı'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#total_order_count#</td>
						<td width="15"></td>
						<td rowspan="5" valign="top">
							<table>
								<cfif get_all_paymethod.recordcount or get_all_card_paymethod.recordcount>
									<tr><td><cf_get_lang dictionary_id='49576.Ödeme Yöntemleri'></td></tr>
								<cfelse>
									<tr><td width="125">&nbsp;</td></tr>
								</cfif>
								<cfif get_all_paymethod.recordcount>
									<cfloop query="get_all_paymethod">
										<tr>
											<td valign="top">#get_all_paymethod.paymethod#</td>
											<td valign="top"> : </td>
											<td align="right" valign="top" style="text-align:right;">#get_all_paymethod.pay_count#</td>
										</tr>
									</cfloop>
								</cfif>
								<cfif get_all_card_paymethod.recordcount>
									<cfloop query="get_all_card_paymethod">
										<tr>
											<td valign="top">#get_all_card_paymethod.card_no#</td>
											<td valign="top"> : </td>
											<td align="right" valign="top" style="text-align:right;">#get_all_card_paymethod.pay_count#</td>
										</tr>
									</cfloop>
								</cfif>
							</table>
						</td>
						<td width="15"></td>
						<td rowspan="5" valign="top">
							<table>
								<cfif get_products.recordcount>
									<cfloop query="get_products">
										<cfif isdefined("catalog_count_all_#get_products.product_id#") and evaluate("catalog_count_all_#get_products.product_id#") gt 0>
											<tr>
												<td valign="top">#get_products.product_name#</td>
												<td valign="top"> : </td>
												<td align="right" valign="top" style="text-align:right;">#evaluate("catalog_count_all_#get_products.product_id#")#</td>
											</tr>
										</cfif>
									</cfloop>
								</cfif>
							</table>
						</td>
					</tr>
					<tr <cfif isdefined("back_color")>style="background-color:#back_color#"<cfelse>class="color-row"</cfif>>
						<td><cf_get_lang dictionary_id='54587.Toplam Satış'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#tlformat(total_net_sale)#</td>
						<td width="15"></td>
						<td><cf_get_lang dictionary_id='43218.Aktivite'></td>
						<td> : </td>
						<td align="right" style="text-align:right;"><cfif total_count gt 0>#tlformat(aktif_count/total_count*100)#<cfelse>#tlformat(0)#</cfif> %</td>
						<td width="15"></td>
						<td><cf_get_lang dictionary_id='34616.Sipariş Sıklığı'></td>
						<td> : </td>
						<td align="right" style="text-align:right;"><cfif aktif_count gt 0>#tlformat(total_order_count/aktif_count)#<cfelse>#tlformat(0)#</cfif></td>
					</tr>
					<tr <cfif isdefined("back_color")>style="background-color:#back_color#"<cfelse>class="color-row"</cfif>>
						<td><cf_get_lang dictionary_id='60634.Toplam Hizmet Bedeli'> + <cf_get_lang dictionary_id='60635.Gecikme Cezası'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#tlformat(total_other_sale)#</td>
						<td width="15"></td>
						<td><cf_get_lang dictionary_id='40623.Ortalama Satış'></td>
						<td> : </td>
						<td align="right" style="text-align:right;"><cfif aktif_count neq 0>#tlformat((total_prim_sale)/aktif_count)#<cfelse>#tlformat(0)#</cfif></td>
						<td width="15"></td>
						<td><cf_get_lang dictionary_id='34438.Ortalama'> <cf_get_lang dictionary_id ='57611.Sipariş'></td>
						<td> : </td>
						<td align="right" style="text-align:right;"><cfif total_order_count gt 0>#tlformat((total_prim_sale)/total_order_count)#<cfelse>#tlformat(0)#</cfif></td>
					</tr>
					<tr <cfif isdefined("back_color")>style="background-color:#back_color#"<cfelse>class="color-row"</cfif>>
						<td><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='50335.İade'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#tlformat(total_return)#</td>
						<td width="15"></td>
						<td><cf_get_lang dictionary_id='57483.Kayıt'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#total_k#</td>					
						<td width="15"></td>
						<td>TB <cf_get_lang dictionary_id='60636.Katalog Oranı'></td>
						<td> : </td>
						<td align="right" style="text-align:right;"><cfif get_ref_member.recordcount gt 0>#tlformat(total_catalog_count/get_ref_member.recordcount)#<cfelse>#tlformat(0)#</cfif></td>
					</tr>
					<tr <cfif isdefined("back_color")>style="background-color:#back_color#"<cfelse>class="color-row"</cfif>>
						<cfif isdefined("attributes.is_total")>
							<td><cf_get_lang dictionary_id='60637.Toplam Çıkış Yapan Temsilcilerin İadesi'></td>
							<td> : </td>
							<td align="right" style="text-align:right;">#tlformat(get_pasive_return_sale.nettotal)#</td>
						<cfelse>
							<td></td>
							<td> : </td>
							<td align="right" style="text-align:right;"></td>
						</cfif>
						<td width="15"></td>
						<td><cf_get_lang dictionary_id='60638.Geri Dönüş'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#total_g#</td>	
						<td width="15"></td>
						<td>Net YTA 1 Satış</td>
						<td> : </td>
						<td align="right" style="text-align:right;">#tlformat(member_net_sale_1)#</td>
					</tr>
					<tr <cfif isdefined("back_color")>style="background-color:#back_color#"<cfelse>class="color-row"</cfif>>
						<cfif not (isdefined("attributes.pos_code") and len(attributes.pos_code))>
							<td><cf_get_lang dictionary_id='60639.Kişisel Net Satış'></td>
							<td> : </td>
							<td align="right" style="text-align:right;">#tlformat(ref_member_net_sale)#</td>
						<cfelse>
							<td><cf_get_lang dictionary_id='60640.Toplam Prime Esas Net Satış'></td>
							<td> : </td>
							<td align="right" style="text-align:right;">#tlformat(total_prim_sale)#</td>
						</cfif>
						<td width="15"></td>
						<td><cf_get_lang dictionary_id='57431.Çıkış'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#total_c#</td>
						<td width="15"></td>
						<td>Net YTA 1-3 Satış</td>
						<td> : </td>
						<td align="right" style="text-align:right;">#tlformat(member_net_sale_1_3)#</td>
						<td width="15"></td>
						<td></td>
						<td></td>
						<td rowspan="5" valign="top">
							<table>
								<cfset attributes.mode = 2>
								<cfloop query="get_premium_cons">       
									<cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
										<tr>
									</cfif>
										<td valign="top">#conscat#</td>
										<td valign="top"> : </td>
										<td align="right" valign="top" style="text-align:right;"><cfif isdefined("cons_count_#get_premium_cons.conscat_id#")>#evaluate("cons_count_#get_premium_cons.conscat_id#")#<cfelse>0</cfif></td>
									<cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq get_premium_cons.recordcount)>
										</tr>
									</cfif>
								</cfloop>
							</table>
						</td>					
					</tr>
					<tr <cfif isdefined("back_color")>style="background-color:#back_color#"<cfelse>class="color-row"</cfif>>
						<td><cf_get_lang dictionary_id='60641.Vadesi Gelmemiş Borç'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#tlformat(total_bakiye)#</td>
						<td width="15"></td>
						<td><cf_get_lang dictionary_id='35989.Bekleyen'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#total_b#</td>
						<td width="15"></td>
						<td></td>
						<td></td>
						<td align="right" style="text-align:right;"></td>
					</tr>
					<tr <cfif isdefined("back_color")>style="background-color:#back_color#"<cfelse>class="color-row"</cfif>>
						<td><cf_get_lang dictionary_id='60642.Gecikmiş Borç'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#tlformat(total_bakiye_2)#</td>
						<td width="15"></td>
						<td><cf_get_lang dictionary_id='60643.Net Büyüme'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#total_k+total_g-total_c#</td>
						<td width="15"></td>
						<td></td>
						<td></td>
						<td align="right" style="text-align:right;"></td>
					</tr>
					<tr <cfif isdefined("back_color")>style="background-color:#back_color#"<cfelse>class="color-row"</cfif>>
						<td><cf_get_lang dictionary_id='60392.Toplam Borç'></td>
						<td> : </td>
						<td align="right" style="text-align:right;">#tlformat(total_bakiye_2+total_bakiye)#</td>
						<td width="15"></td>
						<td></td>
						<td></td>
						<td align="right" style="text-align:right;"></td>
						<td width="15"></td>
						<td></td>
						<td></td>
						<td align="right" style="text-align:right;"></td>
					</tr>
					<tr><td colspan="8"></td></tr>
					<tr>
						<td colspan="14"></td>
						<cfif isdefined("session.ep") and isdefined("attributes.is_zone")><!-- sil --><td align="right" style="text-align:right;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.detail_report&event=det&is_zone=1&report_id=#attributes.report_id#&pos_code=#attributes.pos_code#&camp_id=#attributes.camp_id#&form_submitted=1&is_popup=1&consumer_id=','wide');" class="tableyazi">&raquo;<cf_get_lang dictionary_id='60644.Detaylı Rapor'></a></td><!-- sil --></cfif>
						<cfif isdefined("session.ep") and not isdefined("attributes.is_zone") and not isdefined("attributes.is_color") and not isdefined("attributes.pos_code_list")><!-- sil --><td align="right" style="text-align:right;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.detail_report&event=det&report_id=#attributes.report_id#<cfif isdefined("attributes.consumer_id")>&consumer_id=#attributes.consumer_id#<cfelse>&consumer_id=</cfif>&camp_id=#attributes.camp_id#&form_submitted=1&is_popup=1','wide');" class="tableyazi">&raquo;<cf_get_lang dictionary_id='60644.Detaylı Rapor'></a></td><!-- sil --></cfif>
						<cfif isdefined("session.ep") and not isdefined("attributes.is_zone") and isdefined("attributes.is_color") and not isdefined("attributes.pos_code_list")><!-- sil --><td align="right" style="text-align:right;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.detail_report&event=det&report_id=#attributes.report_id#&pos_code=#attributes.pos_code#&camp_id=#attributes.camp_id#&sales_county=&form_submitted=1&consumer_id=&is_popup=1','wide');" class="tableyazi">&raquo;<cf_get_lang dictionary_id='60644.Detaylı Rapor'></a></td><!-- sil --></cfif>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>		
</table>
