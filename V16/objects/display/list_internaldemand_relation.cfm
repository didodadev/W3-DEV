<cfquery name="get_internald_info" datasource="#dsn3#">
	SELECT
		SUM(IR.QUANTITY) AS QUANTITY,
		IR.PRODUCT_NAME,
		IR.STOCK_ID,
		IR.UNIT,
		ISNULL(IR.SPECT_VAR_ID,0) AS SPECT_VAR_ID, 
		I.SUBJECT,
		I.INTERNAL_NUMBER,
		I.INTERNAL_ID,
		IR.DELIVER_DATE,
		IR.WRK_ROW_ID,
		IR.AMOUNT2,
		IR.UNIT2
	FROM
		INTERNALDEMAND I,
		INTERNALDEMAND_ROW IR
	WHERE
		I.INTERNAL_ID = IR.I_ID
		AND I.INTERNAL_ID = #attributes.internaldemand_id#
		<cfif isdefined('attributes.stock_id') and len(attributes.stock_id)>
			AND IR.STOCK_ID = #attributes.stock_id#
		</cfif>
	GROUP BY
		IR.PRODUCT_NAME,
		IR.STOCK_ID,
		IR.UNIT,
		ISNULL(IR.SPECT_VAR_ID,0), 
		I.SUBJECT,
		I.INTERNAL_NUMBER,
		I.INTERNAL_ID,
		IR.DELIVER_DATE,
		IR.WRK_ROW_ID,
		IR.AMOUNT2,
		IR.UNIT2
</cfquery>
<cfquery name="get_internald_info2" dbtype="query">
	SELECT
		SUM(QUANTITY) AS QUANTITY,
		PRODUCT_NAME,
		STOCK_ID,
		UNIT,
		SPECT_VAR_ID, 
		SUBJECT,
		INTERNAL_NUMBER,
		INTERNAL_ID,
		DELIVER_DATE,
		WRK_ROW_ID,
		AMOUNT2,
		UNIT2
	FROM
		get_internald_info
	GROUP BY
		PRODUCT_NAME,
		STOCK_ID,
		UNIT,
		SPECT_VAR_ID, 
		SUBJECT,
		INTERNAL_NUMBER,
		INTERNAL_ID,
		DELIVER_DATE,
		WRK_ROW_ID,
		AMOUNT2,
		UNIT2
</cfquery>
<cfset offer_id_list = ''>
<cfset offer_id_write_list = ''>
<cfset offer_id_only_list = ''>
<cfset order_id_list = ''>
<cfset order_id_write_list = ''>
<cfset internal_id_list = ''>
<cfset internal_id_write_list = ''>
<cfset internal_id_list2 = ''>
<cfset internal_id_write_list2 = ''>
<cfset ship_id_list = ''>
<cfset ship_id_write_list = ''>
<cfset fis_id_list = ''>
<cfset fis_id_write_list = ''>
<cfset order_wrk_id_list = ''>
<cfset ship_wrk_id_list = ''>
<cfset ship_write_id_list = ''>
<cfquery name="get_period_info" datasource="#dsn#">
	SELECT PERIOD_YEAR,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfoutput query="get_internald_info">	
	<!--- Bağlantılı Teklif --->
	<cfquery name="get_offer_relation" datasource="#dsn3#">
		SELECT
			O.OFFER_ID,
			O.OFFER_NUMBER,
			OFR.WRK_ROW_RELATION_ID,
			OFR.STOCK_ID,
			SUM(OFR.QUANTITY) QUANTITY
		FROM 
			OFFER O,
			OFFER_ROW OFR
		WHERE 
			O.OFFER_ID = OFR.OFFER_ID AND
			OFR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		GROUP BY
			O.OFFER_ID,
			O.OFFER_NUMBER,
			OFR.WRK_ROW_RELATION_ID,
			OFR.STOCK_ID
		UNION ALL
		SELECT
			O.OFFER_ID,
			O.OFFER_NUMBER,
			OFR.WRK_ROW_RELATION_ID,
			OFR.STOCK_ID,
			SUM(OFR.QUANTITY) QUANTITY
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			OFFER O,
			OFFER_ROW OFR
		WHERE 
			I.INTERNAL_ID = IR.I_ID AND
			O.OFFER_ID = OFR.OFFER_ID AND
			IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
			IR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		GROUP BY
			O.OFFER_ID,
			O.OFFER_NUMBER,
			OFR.WRK_ROW_RELATION_ID,
			OFR.STOCK_ID
	</cfquery>
	<cfloop query="get_offer_relation">
		<cfset offer_id_list=listappend(offer_id_list,'#OFFER_ID#;#OFFER_NUMBER#;#STOCK_ID#;#QUANTITY#;#WRK_ROW_RELATION_ID#')>
		<cfset offer_id_write_list=listappend(offer_id_write_list,'#OFFER_ID#;#OFFER_NUMBER#')>
		<cfset offer_id_only_list=listappend(offer_id_only_list,'#OFFER_ID#')>
		<cfset offer_id_write_list = listdeleteduplicates(offer_id_write_list)>
	</cfloop>
	<!--- Bağlantılı Teklif --->
	
	<!--- Bağlantılı Sipariş --->
	<cfquery name="get_order_relation" datasource="#dsn3#">
		SELECT
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.DELIVERDATE,
			ORR.WRK_ROW_RELATION_ID,
			ORR.STOCK_ID,
			ORR.DELIVER_DATE,
			SUM(ORR.QUANTITY) QUANTITY
		FROM 
			ORDERS O,
			ORDER_ROW ORR
		WHERE 
			O.ORDER_ID = ORR.ORDER_ID AND
			ORR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		GROUP BY
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.DELIVERDATE,
			ORR.WRK_ROW_RELATION_ID,
			ORR.STOCK_ID,
			ORR.DELIVER_DATE
		UNION ALL
		SELECT
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.DELIVERDATE,
			ORR.WRK_ROW_RELATION_ID,
			ORR.STOCK_ID,
			ORR.DELIVER_DATE,
			SUM(ORR.QUANTITY) QUANTITY
		FROM 
			ORDERS O,
			ORDER_ROW ORR,
            OFFER_ROW OFR
		WHERE 
			O.OFFER_ID = OFR.OFFER_ID AND
			ORR.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID AND
			OFR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		GROUP BY
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.DELIVERDATE,
			ORR.WRK_ROW_RELATION_ID,
			ORR.STOCK_ID,
			ORR.DELIVER_DATE
		UNION ALL
		SELECT
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.DELIVERDATE,
			ORR.WRK_ROW_RELATION_ID,
			ORR.STOCK_ID,
			ORR.DELIVER_DATE,
			SUM(ORR.QUANTITY) QUANTITY
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			OFFER OO,
			OFFER_ROW OFR,
			ORDERS O,
			ORDER_ROW ORR
		WHERE 
			OO.OFFER_ID = OFR.OFFER_ID AND
			I.INTERNAL_ID = IR.I_ID AND
			O.ORDER_ID = ORR.ORDER_ID AND
			IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
			OFR.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
			IR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		GROUP BY
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.DELIVERDATE,
			ORR.WRK_ROW_RELATION_ID,
			ORR.STOCK_ID,
			ORR.DELIVER_DATE
		UNION ALL
		SELECT
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.DELIVERDATE,
			ORR.WRK_ROW_RELATION_ID,
			ORR.STOCK_ID,
			ORR.DELIVER_DATE,
			SUM(ORR.QUANTITY) QUANTITY
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			OFFER OO,
			OFFER_ROW OFR,
			OFFER OO2,
			OFFER_ROW OFR2,
			ORDERS O,
			ORDER_ROW ORR
		WHERE 
			OO.OFFER_ID = OFR.OFFER_ID AND
			OO2.OFFER_ID = OFR2.OFFER_ID AND
			I.INTERNAL_ID = IR.I_ID AND
			O.ORDER_ID = ORR.ORDER_ID AND
			IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
			OFR.WRK_ROW_ID = OFR2.WRK_ROW_RELATION_ID AND
			OFR2.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
			IR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		GROUP BY
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.DELIVERDATE,
			ORR.WRK_ROW_RELATION_ID,
			ORR.STOCK_ID,
			ORR.DELIVER_DATE
		UNION ALL
		SELECT
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.DELIVERDATE,
			ORR.WRK_ROW_RELATION_ID,
			ORR.STOCK_ID,
			ORR.DELIVER_DATE,
			SUM(ORR.QUANTITY) QUANTITY
		FROM 
			OFFER OO,
			OFFER_ROW OFR,
			OFFER OO2,
			OFFER_ROW OFR2,
			ORDERS O,
			ORDER_ROW ORR
		WHERE 
			OO.OFFER_ID = OFR.OFFER_ID AND
			OO2.OFFER_ID = OFR2.OFFER_ID AND
			O.ORDER_ID = ORR.ORDER_ID AND
			OFR.WRK_ROW_ID = OFR2.WRK_ROW_RELATION_ID AND
			OFR2.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
			OFR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		GROUP BY
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.DELIVERDATE,
			ORR.WRK_ROW_RELATION_ID,
			ORR.STOCK_ID,
			ORR.DELIVER_DATE
	</cfquery>
	<cfquery name="get_order_relation2" datasource="#dsn3#">
		SELECT
			ORR.WRK_ROW_ID
		FROM 
			ORDERS O,
			ORDER_ROW ORR
		WHERE 
			O.ORDER_ID = ORR.ORDER_ID AND
			ORR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		UNION ALL
		SELECT
			ORR.WRK_ROW_ID
		FROM 
			ORDERS O,
			ORDER_ROW ORR,
            OFFER_ROW OFR
		WHERE 
			O.OFFER_ID = OFR.OFFER_ID AND
			ORR.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID AND
			OFR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		UNION ALL
		SELECT
			ORR.WRK_ROW_ID
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			OFFER OO,
			OFFER_ROW OFR,
			ORDERS O,
			ORDER_ROW ORR
		WHERE 
			OO.OFFER_ID = OFR.OFFER_ID AND
			I.INTERNAL_ID = IR.I_ID AND
			O.ORDER_ID = ORR.ORDER_ID AND
			IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
			OFR.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
			IR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		UNION ALL
		SELECT
			ORR.WRK_ROW_ID
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			OFFER OO,
			OFFER_ROW OFR,
			OFFER OO2,
			OFFER_ROW OFR2,
			ORDERS O,
			ORDER_ROW ORR
		WHERE 
			OO.OFFER_ID = OFR.OFFER_ID AND
			OO2.OFFER_ID = OFR2.OFFER_ID AND
			I.INTERNAL_ID = IR.I_ID AND
			O.ORDER_ID = ORR.ORDER_ID AND
			IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
			OFR.WRK_ROW_ID = OFR2.WRK_ROW_RELATION_ID AND
			OFR2.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
			IR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		UNION ALL
		SELECT
			ORR.WRK_ROW_ID
		FROM 
			OFFER OO,
			OFFER_ROW OFR,
			OFFER OO2,
			OFFER_ROW OFR2,
			ORDERS O,
			ORDER_ROW ORR
		WHERE 
			OO.OFFER_ID = OFR.OFFER_ID AND
			OO2.OFFER_ID = OFR2.OFFER_ID AND
			O.ORDER_ID = ORR.ORDER_ID AND
			OFR.WRK_ROW_ID = OFR2.WRK_ROW_RELATION_ID AND
			OFR2.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
			OFR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
	</cfquery>
	<cfloop query="get_order_relation">
	    <cfif len(DELIVER_DATE)><cfset teslim_tarih = DELIVER_DATE><cfelse><cfset teslim_tarih = DELIVERDATE></cfif>
		<cfset order_id_list=listappend(order_id_list,'#ORDER_ID#;#ORDER_NUMBER#;#STOCK_ID#;#QUANTITY#;#WRK_ROW_RELATION_ID#;#teslim_tarih#')>
		<cfset order_id_write_list=listappend(order_id_write_list,'#ORDER_ID#;#ORDER_NUMBER#')>
		<cfset order_id_write_list = listdeleteduplicates(order_id_write_list)>
	</cfloop>
	<cfloop query="get_order_relation2">
		<cfset order_wrk_id_list=listappend(order_wrk_id_list,'#WRK_ROW_ID#')>
	</cfloop>
	<!--- Bağlantılı Sipariş --->	
	<!--- Bağlantılı Satınalma Talebi --->
		<cfquery name="get_purchasedemand_relation" datasource="#dsn3#">
		SELECT
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR.STOCK_ID,
			IR.WRK_ROW_RELATION_ID,
			SUM(IR.QUANTITY) QUANTITY
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR
		WHERE 
			I.INTERNAL_ID = IR.I_ID AND
			ISNULL(I.DEMAND_TYPE,0) = 1 AND
			IR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
		GROUP BY
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR.STOCK_ID,
			IR.WRK_ROW_RELATION_ID
		UNION ALL
		SELECT
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR.STOCK_ID,
			IR2.WRK_ROW_RELATION_ID,
			SUM(IR.QUANTITY) QUANTITY
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			INTERNALDEMAND_ROW IR2
		WHERE 
			I.INTERNAL_ID = IR.I_ID AND
			ISNULL(I.DEMAND_TYPE,0) = 1 AND
			IR.WRK_ROW_ID = IR2.WRK_ROW_RELATION_ID AND
			IR2.WRK_ROW_ID = '#WRK_ROW_ID#'
		GROUP BY
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR.STOCK_ID,
			IR2.WRK_ROW_RELATION_ID
		UNION ALL
		SELECT
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR.STOCK_ID,
			IR3.WRK_ROW_RELATION_ID,
			SUM(IR.QUANTITY) QUANTITY
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			INTERNALDEMAND_ROW IR2,
			INTERNALDEMAND_ROW IR3
		WHERE 
			I.INTERNAL_ID = IR.I_ID AND
			ISNULL(I.DEMAND_TYPE,0) = 1 AND
			IR.WRK_ROW_ID = IR2.WRK_ROW_RELATION_ID AND
			IR2.WRK_ROW_ID = IR3.WRK_ROW_RELATION_ID AND
			IR3.WRK_ROW_ID = '#WRK_ROW_ID#'
		GROUP BY
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR.STOCK_ID,
			IR3.WRK_ROW_RELATION_ID
		UNION ALL
		SELECT
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR.STOCK_ID,
			IR4.WRK_ROW_RELATION_ID,
			SUM(IR.QUANTITY) QUANTITY
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			INTERNALDEMAND_ROW IR2,
			INTERNALDEMAND_ROW IR3,
			INTERNALDEMAND_ROW IR4
		WHERE 
			I.INTERNAL_ID = IR.I_ID AND
			ISNULL(I.DEMAND_TYPE,0) = 1 AND
			IR.WRK_ROW_ID = IR2.WRK_ROW_RELATION_ID AND
			IR2.WRK_ROW_ID = IR3.WRK_ROW_RELATION_ID AND
			IR3.WRK_ROW_ID = IR4.WRK_ROW_RELATION_ID AND
			IR4.WRK_ROW_ID = '#WRK_ROW_ID#'
		GROUP BY
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR.STOCK_ID,
			IR4.WRK_ROW_RELATION_ID
	</cfquery>
	<cfloop query="get_purchasedemand_relation">
		<cfset internal_id_list=listappend(internal_id_list,'#INTERNAL_ID#;#INTERNAL_NUMBER#;#STOCK_ID#;#QUANTITY#;#WRK_ROW_RELATION_ID#')>
		<cfset internal_id_write_list=listappend(internal_id_write_list,'#INTERNAL_ID#;#INTERNAL_NUMBER#')>
		<cfset internal_id_write_list = listdeleteduplicates(internal_id_write_list)>
	</cfloop>
	<!--- Bağlantılı Satınalma Talebi --->
	<!--- Bağlantılı İç talep --->
	<cfquery name="get_internaldemand_relation" datasource="#dsn3#">
		SELECT
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR2.WRK_ROW_ID,
			IR.STOCK_ID,
			SUM(IR.QUANTITY) QUANTITY
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			INTERNALDEMAND_ROW IR2
		WHERE 
			I.INTERNAL_ID = IR.I_ID AND
			ISNULL(I.DEMAND_TYPE,0) = 0 AND
			IR.WRK_ROW_ID = IR2.WRK_ROW_RELATION_ID AND
			IR2.WRK_ROW_ID = '#WRK_ROW_ID#'
		GROUP BY
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR2.WRK_ROW_ID,
			IR.STOCK_ID
		UNION ALL
		SELECT
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR2.WRK_ROW_ID,
			IR.STOCK_ID,
			SUM(IR.QUANTITY) QUANTITY
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			INTERNALDEMAND_ROW IR2,
			INTERNALDEMAND_ROW IR3
		WHERE 
			I.INTERNAL_ID = IR.I_ID AND
			ISNULL(I.DEMAND_TYPE,0) = 0 AND
			IR.WRK_ROW_ID = IR2.WRK_ROW_RELATION_ID AND
			IR2.WRK_ROW_ID = IR3.WRK_ROW_RELATION_ID AND
			IR3.WRK_ROW_ID = '#WRK_ROW_ID#'
		GROUP BY
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR2.WRK_ROW_ID,
			IR.STOCK_ID
		UNION ALL
		SELECT
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR2.WRK_ROW_ID,
			IR.STOCK_ID,
			SUM(IR.QUANTITY) QUANTITY
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR,
			INTERNALDEMAND_ROW IR2,
			INTERNALDEMAND_ROW IR3,
			INTERNALDEMAND_ROW IR4
		WHERE 
			I.INTERNAL_ID = IR.I_ID AND
			ISNULL(I.DEMAND_TYPE,0) = 0 AND
			IR.WRK_ROW_ID = IR2.WRK_ROW_RELATION_ID AND
			IR2.WRK_ROW_ID = IR3.WRK_ROW_RELATION_ID AND
			IR3.WRK_ROW_ID = IR4.WRK_ROW_RELATION_ID AND
			IR4.WRK_ROW_ID = '#WRK_ROW_ID#'
		GROUP BY
			I.INTERNAL_ID,
			I.INTERNAL_NUMBER,
			IR2.WRK_ROW_ID,
			IR.STOCK_ID
	</cfquery>
	<cfloop query="get_internaldemand_relation">
		<cfset internal_id_list2=listappend(internal_id_list2,'#INTERNAL_ID#;#INTERNAL_NUMBER#;#STOCK_ID#;#QUANTITY#;#WRK_ROW_ID#')>
		<cfset internal_id_write_list2=listappend(internal_id_write_list2,'#INTERNAL_ID#;#INTERNAL_NUMBER#')>
		<cfset internal_id_write_list2 = listdeleteduplicates(internal_id_write_list2)>
	</cfloop>
	<!--- Bağlantılı İç talep --->	
	<!--- Bağlantılı Stok Fişleri --->
	<cfquery name="get_stockfis_relation" datasource="#dsn2#">
		<cfloop query="get_period_info">
			<cfset new_dsn2 = "#dsn#_#get_period_info.period_year#_#session.ep.company_id#">
			SELECT
				SF.FIS_ID,
				SF.FIS_NUMBER,
				SFR.STOCK_ID,
				SFR.WRK_ROW_RELATION_ID,
				SUM(SFR.AMOUNT) AS STOCKFIS_AMOUNT,
				#get_period_info.PERIOD_ID# PERIOD_ID
			FROM
				#new_dsn2#.STOCK_FIS SF,
				#new_dsn2#.STOCK_FIS_ROW SFR
			WHERE
				SF.FIS_ID =SFR.FIS_ID
				AND SFR.WRK_ROW_RELATION_ID = '#get_internald_info.WRK_ROW_ID#'
			GROUP BY
				SF.FIS_ID,
				SF.FIS_NUMBER,
				SFR.WRK_ROW_RELATION_ID,
				SFR.STOCK_ID
			<cfif get_period_info.recordcount neq get_period_info.currentrow>UNION ALL</cfif>
		</cfloop>
	</cfquery>
	<cfloop query="get_stockfis_relation">
		<cfset fis_id_list=listappend(fis_id_list,'#FIS_ID#;#FIS_NUMBER#;#STOCK_ID#;#STOCKFIS_AMOUNT#;#PERIOD_ID#;#WRK_ROW_RELATION_ID#')>
		<cfset fis_id_write_list=listappend(fis_id_write_list,'#FIS_ID#;#FIS_NUMBER#;#PERIOD_ID#')>
		<cfset fis_id_write_list = listdeleteduplicates(fis_id_write_list)>
	</cfloop>
	<!--- Bağlantılı Stok Fişleri --->
</cfoutput>
<!--- Bağlantılı İrsaliyeler --->
<cfif len(order_wrk_id_list)>
	<cfquery name="get_ship_relation" datasource="#dsn2#">
		SELECT
			SUM(SHIP_AMOUNT) SHIP_AMOUNT,
			PERIOD_ID,
			ISNULL(WRK_ROW_RELATION_ID,0) WRK_ROW_RELATION_ID,
			SHIP_ID,
			SHIP_NUMBER,
			STOCK_ID,
			SHIP_TYPE
		FROM
		(
			SELECT
				T1.SHIP_ID,
				T1.SHIP_NUMBER,
				T1.STOCK_ID,
				'0' AS WRK_ROW_RELATION_ID,
				SUM(T1.AMOUNT) AS SHIP_AMOUNT,
				#session.ep.period_id# PERIOD_ID,
				SHIP_TYPE
			FROM
				(SELECT DISTINCT
					S.SHIP_ID,
					S.SHIP_NUMBER,
					SR.STOCK_ID,
					SR.AMOUNT,
					#get_period_info.PERIOD_ID# PERIOD_ID,
					S.SHIP_TYPE
				FROM
					#dsn2_alias#.SHIP S,
					#dsn2_alias#.SHIP_ROW SR,
					#dsn3_alias#.INTERNALDEMAND_RELATION_ROW IRR
				WHERE
					S.SHIP_ID = SR.SHIP_ID
					AND IRR.TO_SHIP_ID = SR.SHIP_ID
					AND IRR.TO_ORDER_ID = S.ORDER_ID
					AND ISNULL(S.IS_SHIP_IPTAL,0)=0
					AND IRR.INTERNALDEMAND_ID = #attributes.internaldemand_id#
				) T1
			GROUP BY
				T1.SHIP_ID,
				T1.SHIP_NUMBER,
				T1.STOCK_ID,
				T1.SHIP_TYPE
			UNION ALL
			<cfloop from="1" to="#listlen(order_wrk_id_list)#" index="kk">	
				<cfloop query="get_period_info">
					<cfset new_dsn2 = "#dsn#_#get_period_info.period_year#_#session.ep.company_id#">
					<cfset new_dsn3 = "#dsn#_#session.ep.company_id#">

						SELECT
							S.SHIP_ID,
							S.SHIP_NUMBER,
							SR.STOCK_ID,
							SR.WRK_ROW_RELATION_ID,
							SUM(SR.AMOUNT) AS SHIP_AMOUNT,
							#get_period_info.PERIOD_ID# PERIOD_ID,
							S.SHIP_TYPE
						FROM
							#new_dsn2#.SHIP S,
							#new_dsn2#.SHIP_ROW SR
						WHERE
							S.SHIP_ID = SR.SHIP_ID
							AND SR.WRK_ROW_RELATION_ID = '#listgetat(order_wrk_id_list,kk)#'
							AND ISNULL(S.IS_SHIP_IPTAL,0)=0
						GROUP BY
							S.SHIP_ID,
							S.SHIP_NUMBER,
							SR.STOCK_ID,
							SR.WRK_ROW_RELATION_ID,
							S.SHIP_TYPE
							UNION ALL
						SELECT
							S.SHIP_ID,
							S.SHIP_NUMBER,
							SR.STOCK_ID,
							ORD.WRK_ROW_RELATION_ID,
							SUM(SR.AMOUNT) AS SHIP_AMOUNT,
							#get_period_info.PERIOD_ID# PERIOD_ID,
							S.SHIP_TYPE
						FROM
							#new_dsn2#.SHIP S,
							#new_dsn2#.SHIP_ROW SR,
							#new_dsn3#.ORDER_ROW ORD
						WHERE
							S.SHIP_ID = SR.SHIP_ID
							AND ORD.WRK_ROW_RELATION_ID = '#listgetat(order_wrk_id_list,kk)#'
							AND ORD.WRK_ROW_ID = SR.WRK_ROW_RELATION_ID
							AND ISNULL(S.IS_SHIP_IPTAL,0)=0
						GROUP BY
							S.SHIP_ID,
							S.SHIP_NUMBER,
							SR.STOCK_ID,
							ORD.WRK_ROW_RELATION_ID,
							S.SHIP_TYPE
						UNION ALL
						SELECT
							S.SHIP_ID,
							S.SHIP_NUMBER,
							SR.STOCK_ID,
							SR.WRK_ROW_RELATION_ID,
							SUM(SR.AMOUNT) AS SHIP_AMOUNT,
							#get_period_info.PERIOD_ID# PERIOD_ID,
							S.SHIP_TYPE
						FROM
							#new_dsn2#.SHIP S,
							#new_dsn2#.SHIP_ROW SR,
							#new_dsn2#.INVOICE_ROW IR
						WHERE
							S.SHIP_ID = SR.SHIP_ID
							AND IR.WRK_ROW_RELATION_ID = '#listgetat(order_wrk_id_list,kk)#'
							AND IR.WRK_ROW_ID = SR.WRK_ROW_RELATION_ID
							AND ISNULL(S.IS_SHIP_IPTAL,0)=0
						GROUP BY
							S.SHIP_ID,
							S.SHIP_NUMBER,
							SR.STOCK_ID,
							SR.WRK_ROW_RELATION_ID,
							S.SHIP_TYPE
					<cfif get_period_info.recordcount neq get_period_info.currentrow>UNION ALL</cfif>
				</cfloop>
				<cfif kk neq listlen(order_wrk_id_list)>UNION ALL</cfif>
			</cfloop>
		)T1
		GROUP BY
			PERIOD_ID,
			WRK_ROW_RELATION_ID,
			SHIP_ID,
			SHIP_NUMBER,
			STOCK_ID,
			SHIP_TYPE
	</cfquery>
	<cfloop query="get_ship_relation">
		<cfset ship_id_list=listappend(ship_id_list,'#SHIP_ID#;#SHIP_NUMBER#;#STOCK_ID#;#SHIP_AMOUNT#;#PERIOD_ID#;#WRK_ROW_RELATION_ID#')>
		<cfset ship_id_write_list=listappend(ship_id_write_list,'#SHIP_ID#;#SHIP_NUMBER#;#PERIOD_ID#;#SHIP_TYPE#')>
		<cfset ship_id_write_list = listdeleteduplicates(ship_id_write_list)>
	</cfloop>
	<cfloop query="get_ship_relation">
		<cfset ship_wrk_id_list=listappend(ship_wrk_id_list,'#WRK_ROW_RELATION_ID#')>
	</cfloop>
	<cfquery name="get_ship_relation2" datasource="#dsn2#">
		SELECT
			SHIP_AMOUNT,
			PERIOD_ID,
			ISNULL(WRK_ROW_RELATION_ID,0) WRK_ROW_RELATION_ID,
			SHIP_ID,
			SHIP_NUMBER,
			STOCK_ID
		FROM
		(
			SELECT
				T1.SHIP_ID,
				T1.SHIP_NUMBER,
				T1.STOCK_ID,
				'0' AS WRK_ROW_RELATION_ID,
				SUM(T1.AMOUNT) AS SHIP_AMOUNT,
				#session.ep.period_id# PERIOD_ID
			FROM
				(SELECT DISTINCT
					S.SHIP_ID,
					S.SHIP_NUMBER,
					SR.STOCK_ID,
					SR.AMOUNT,
					#get_period_info.PERIOD_ID# PERIOD_ID
				FROM
					#dsn2_alias#.SHIP S,
					#dsn2_alias#.SHIP_ROW SR,
					#dsn3_alias#.INTERNALDEMAND_RELATION_ROW IRR
				WHERE
					S.SHIP_ID = SR.SHIP_ID
					AND IRR.TO_SHIP_ID = SR.SHIP_ID
					AND ISNULL(S.IS_SHIP_IPTAL,0)=0
					AND IRR.INTERNALDEMAND_ID = #attributes.internaldemand_id#
				) T1
			GROUP BY
				T1.SHIP_ID,
				T1.SHIP_NUMBER,
				T1.STOCK_ID,
				T1.AMOUNT
				<cfif len(ship_wrk_id_list)>
					UNION ALL
					<cfloop from="1" to="#listlen(ship_wrk_id_list)#" index="kk">	
						<cfloop query="get_period_info">
							<cfset new_dsn2 = "#dsn#_#get_period_info.period_year#_#session.ep.company_id#">
							<cfset new_dsn3 = "#dsn#_#session.ep.company_id#">
								SELECT
									O.ORDER_ID,
									O.ORDER_NUMBER,
									ORD.STOCK_ID,
									ORD.WRK_ROW_RELATION_ID,
									SUM(ORD.QUANTITY) AS ORDER_AMOUNT,
									#get_period_info.PERIOD_ID# PERIOD_ID
								FROM
									#new_dsn3#.ORDERS O,
									#new_dsn3#.ORDER_ROW ORD
								WHERE
									O.ORDER_ID = ORD.ORDER_ID
									AND ORD.WRK_ROW_ID = '#listgetat(ship_wrk_id_list,kk)#'
								GROUP BY
									O.ORDER_ID,
									O.ORDER_NUMBER,
									ORD.STOCK_ID,
									ORD.WRK_ROW_RELATION_ID
									
							<cfif get_period_info.recordcount neq get_period_info.currentrow>UNION ALL</cfif>
						</cfloop>
						<cfif kk neq listlen(ship_wrk_id_list)>UNION ALL</cfif>
					</cfloop>
				</cfif>
			)T1
		GROUP BY
			PERIOD_ID,
			WRK_ROW_RELATION_ID,
			SHIP_ID,
			SHIP_NUMBER,
			STOCK_ID,
			SHIP_AMOUNT
	</cfquery>
	<cfloop query="get_ship_relation2">
		<cfset ship_write_id_list=listappend(ship_write_id_list,'#WRK_ROW_RELATION_ID#;#SHIP_AMOUNT#')>
	</cfloop>
<cfelse>
	<cfquery name="get_ship_relation" datasource="#dsn2#">
		SELECT
			SUM(SHIP_AMOUNT) SHIP_AMOUNT,
			PERIOD_ID,
			SHIP_ID,
			SHIP_NUMBER,
			STOCK_ID,
			WRK_ROW_RELATION_ID,
			SHIP_TYPE
		FROM
		(
			SELECT
				T1.SHIP_ID,
				T1.SHIP_NUMBER,
				T1.STOCK_ID,
				t1.WRK_ROW_RELATION_ID,
				SUM(T1.AMOUNT) AS SHIP_AMOUNT,
				#session.ep.period_id# PERIOD_ID,
				SHIP_TYPE
			FROM
				(SELECT DISTINCT
					S.SHIP_ID,
					S.SHIP_NUMBER,
					SR.STOCK_ID,
					SR.AMOUNT,
					SR.WRK_ROW_RELATION_ID,
					#get_period_info.PERIOD_ID# PERIOD_ID,
					S.SHIP_TYPE
				FROM
					#dsn2_alias#.SHIP S,
					#dsn2_alias#.SHIP_ROW SR,
					#dsn3_alias#.INTERNALDEMAND_RELATION_ROW IRR
				WHERE
					S.SHIP_ID = SR.SHIP_ID
					AND IRR.TO_SHIP_ID = SR.SHIP_ID
					AND ISNULL(S.IS_SHIP_IPTAL,0)=0
					AND IRR.INTERNALDEMAND_ID = #attributes.internaldemand_id#
				) T1
			GROUP BY
				T1.SHIP_ID,
				T1.SHIP_NUMBER,
				T1.STOCK_ID,
				t1.WRK_ROW_RELATION_ID,
				T1.SHIP_TYPE
		)T1
		GROUP BY
			PERIOD_ID,
			SHIP_ID,
			SHIP_NUMBER,
			STOCK_ID,
			WRK_ROW_RELATION_ID,
			SHIP_TYPE
	</cfquery>
	<cfloop query="get_ship_relation">
		<cfset ship_id_list=listappend(ship_id_list,'#SHIP_ID#;#SHIP_NUMBER#;#STOCK_ID#;#SHIP_AMOUNT#;#PERIOD_ID#;#WRK_ROW_RELATION_ID#')>
		<cfset ship_id_write_list=listappend(ship_id_write_list,'#SHIP_ID#;#SHIP_NUMBER#;#PERIOD_ID#;#SHIP_TYPE#')>
		<cfset ship_id_write_list = listdeleteduplicates(ship_id_write_list)>
		<cfset ship_write_id_list = listappend(ship_write_id_list,'#WRK_ROW_RELATION_ID#;#SHIP_AMOUNT#')>
	</cfloop>
</cfif>
<cfset title = "#getlang('','',45445)#: #len(get_internald_info.recordcount) ? "#get_internald_info.internal_number# - #get_internald_info.subject#" : ""#">
<!--- Bağlantılı İrsaliyeler --->
<cf_box title="#getLang('','İlişkiler',29718)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cf_seperator id="offer_comparison" title="#getLang('','',61089)#">
	<cf_grid_list id="offer_comparison">
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th width="70"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th><cf_get_lang dictionary_id='57636.Birim'></th>
				<th width="70">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
				<th>2.<cf_get_lang dictionary_id='57636.Birim'></th>
				<cfif len(fis_id_write_list)>
					<cfloop list="#fis_id_write_list#" index="i">
					<cfset act_id = listgetat(i,1,';')>
					<cfset act_number = listgetat(i,2,';')>
					<cfset period_id = listgetat(i,3,';')>
					<th>						
						<cfoutput>
							<cfif period_id eq session.ep.period_id>
								<a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#act_id#" target="_blank" style="color:##6699FF"><cf_get_lang dictionary_id ='33102.Stok Fiş'>:#act_number#</a>
							<cfelse>
								<cf_get_lang dictionary_id ='33102.Stok Fiş'>:#act_number#	
							</cfif>
						</cfoutput>
					</th>
					</cfloop>
					<th><cf_get_lang dictionary_id='58444.Kalan'></th>
				</cfif>
				<cfif len(internal_id_write_list2)>
					<cfloop list="#internal_id_write_list2#" index="i">
						<cfset act_id = listgetat(i,1,';')>
						<cfset act_number = listgetat(i,2,';')>
						<th>							
							<cfoutput>
								<a href="#request.self#?fuseaction=purchase.list_internaldemand&event=upd&id=#act_id#" target="_blank" style="color:##6699FF"><cf_get_lang dictionary_id='58798.İç Talep'>:#act_number#</a>
							</cfoutput>
						</th>
					</cfloop>
					<th><cf_get_lang dictionary_id='58444.Kalan'></th>
				</cfif>
				<cfif len(internal_id_write_list)>
					<cfloop list="#internal_id_write_list#" index="i">
						<cfset act_id = listgetat(i,1,';')>
						<cfset act_number = listgetat(i,2,';')>
						<th>							
							<cfoutput>
								<a href="#request.self#?fuseaction=purchase.list_purchasedemand&event=upd&id=#act_id#" target="_blank" style="color:##6699FF"><cf_get_lang dictionary_id='30068.Satın Alma Talebi'>:#act_number#</a>
							</cfoutput>
						</th>
					</cfloop>
					<th><cf_get_lang dictionary_id='58444.Kalan'></th>
				</cfif>
				<cfif len(offer_id_write_list)>
					<cfloop list="#offer_id_write_list#" index="i">
						<cfset act_id = listgetat(i,1,';')>
						<cfset act_number = listgetat(i,2,';')>
						<th>
							<cfoutput>
								<a href="#request.self#?fuseaction=purchase.list_offer&event=upd&OFFER_ID=#act_id#" target="_blank" style="color:##6699FF"><cf_get_lang dictionary_id='57545.Teklif'>:#act_number#</a>
							</cfoutput>
						</th>
					</cfloop>
					<th><cf_get_lang dictionary_id='58444.Kalan'></th>
				</cfif>
				<cfif len(order_id_write_list)>
					<cfloop list="#order_id_write_list#" index="i">
						<cfset act_id = listgetat(i,1,';')>
						<cfset act_number = listgetat(i,2,';')>
						<th>
							<cf_get_lang dictionary_id='57645.Teslim Tarihi'>
						</th>
						<th>
							<cfoutput>
								<a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#act_id#" target="_blank" style="color:##6699FF"><cf_get_lang dictionary_id='57611.Sipariş'>:#act_number#</a>
							</cfoutput>
						</th>
					</cfloop>
					<th><cf_get_lang dictionary_id='58444.Kalan'></th>
				</cfif>
				<cfif len(ship_id_write_list)>
				<cfloop list="#ship_id_write_list#" index="i">
					<cfset act_id = listgetat(i,1,';')>
					<cfset act_number = listgetat(i,2,';')>
					<cfset period_id = listgetat(i,3,';')>
					<cfset ship_type = listgetat(i,4,';')>
					<th>
						<cfoutput>
							<cfif period_id eq session.ep.period_id>
								<cfif ship_type eq 81>
									<a href="#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#act_id#" target="_blank" style="color:##6699FF"><cf_get_lang dictionary_id='57773.İrsaliye'>:#act_number#</a>
								<cfelse>
									<a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#act_id#" target="_blank" style="color:##6699FF"><cf_get_lang dictionary_id='57773.İrsaliye'>:#act_number#</a>
								</cfif>
							<cfelse>
								#act_number#	
							</cfif>
						</cfoutput>
					</th>
				</cfloop>
					<th><cf_get_lang dictionary_id='58444.Kalan'></th>
				</cfif>
			</tr>
		</thead>
		<cfif get_internald_info.recordcount>
			<tbody>
				<cfoutput query="get_internald_info2">
					<tr>
						<td>#product_name#</td>
						<td style="text-align:right">#tlformat(quantity)#</td>
						<td>#unit#</td>
						<td style="text-align:right">#tlformat(amount2)#</td>
						<td><cfif len(unit2)>#unit2#<cfelse><cf_get_lang dictionary_id="58082.Adet"></cfif></td>
						<cfif len(fis_id_write_list)>
							<cfset total_amount_ = 0>
							<cfloop list="#fis_id_write_list#" index="i">
								<cfset act_id = listgetat(i,1,';')>
								<cfset act_period_id = listgetat(i,3,';')>
								<td>
								<cfset amount_new = 0>
								<cfloop list="#fis_id_list#" index="j">
									<cfset fis_id_ = listgetat(j,1,';')>
									<cfset fis_period_id_ = listgetat(j,5,';')>
									<cfset stock_id_ = listgetat(j,3,';')>
									<cfset amount_ = listgetat(j,4,';')>
									<cfset wrk_row_relation_id_ = listgetat(j,6,';')>
									<cfif fis_id_ eq act_id and get_internald_info2.stock_id eq stock_id_ and act_period_id eq fis_period_id_ and get_internald_info2.wrk_row_id eq wrk_row_relation_id_>
										<cfset amount_new = amount_new + amount_>
										<cfset total_amount_ = total_amount_ + amount_>
									</cfif>
								</cfloop>
								#tlformat(amount_new)#
								</td>
							</cfloop>
							<td style="text-align:right">#tlformat(quantity-total_amount_)#</td>
						</cfif>
						<cfif len(internal_id_write_list2)>
							<cfset total_amount_ = 0>
							<cfloop list="#internal_id_write_list2#" index="i">
								<cfset act_id = listgetat(i,1,';')>
								<td>
								<cfset amount_new = 0>
								<cfloop list="#internal_id_list2#" index="j">
									<cfset internal_id_ = listgetat(j,1,';')>
									<cfset interna_number_ = listgetat(j,2,';')>
									<cfset stock_id_ = listgetat(j,3,';')>
									<cfset amount_ = listgetat(j,4,';')>
									<cfset wrk_row_id_ = listgetat(j,5,';')>
									
									<cfif internal_id_ eq act_id and get_internald_info2.stock_id eq stock_id_ and get_internald_info2.wrk_row_id eq wrk_row_id_>
										<cfset amount_new = amount_new + amount_>
										<cfset total_amount_ = total_amount_ + amount_>
									</cfif>
								</cfloop>
								#tlformat(amount_new)#
								</td>
							</cfloop>
							<td style="text-align:right">#tlformat(quantity-total_amount_)#</td>
						</cfif>
						<cfif len(internal_id_write_list)>
							<cfset total_amount_ = 0>
							<cfloop list="#internal_id_write_list#" index="i">
								<cfset act_id = listgetat(i,1,';')>
								<td>
								<cfset amount_new = 0>
								<cfloop list="#internal_id_list#" index="j">
									<cfset internal_id_ = listgetat(j,1,';')>
									<cfset interna_number_ = listgetat(j,2,';')>
									<cfset stock_id_ = listgetat(j,3,';')>
									<cfset amount_ = listgetat(j,4,';')>
									<cfset wrk_row_relation_id_ = listgetat(j,5,';')>
									<cfif internal_id_ eq act_id and get_internald_info2.stock_id eq stock_id_ and get_internald_info2.WRK_ROW_ID eq wrk_row_relation_id_>
										<cfset amount_new = amount_new + amount_>
										<cfset total_amount_ = total_amount_ + amount_>
									</cfif>
								</cfloop>
								#tlformat(amount_new)#
								</td>
							</cfloop>
							<td style="text-align:right">#tlformat(quantity-total_amount_)#</td>
						</cfif>
						<cfif len(offer_id_write_list)>
							<cfset total_amount_ = 0>
							<cfloop list="#offer_id_write_list#" index="i">
								<td>
								<cfset act_id = listgetat(i,1,';')>
								<cfset amount_new = 0>
								<cfloop list="#offer_id_list#" index="j">
									<cfset offer_id_ = listgetat(j,1,';')>
									<cfset offer_number_ = listgetat(j,2,';')>
									<cfset stock_id_ = listgetat(j,3,';')>
									<cfset amount_ = listgetat(j,4,';')>
									<cfset wrk_row_relation_id_ = listgetat(j,5,';')>
									<cfif offer_id_ eq act_id and get_internald_info2.stock_id eq stock_id_ and get_internald_info2.WRK_ROW_ID eq wrk_row_relation_id_>
										<cfset amount_new = amount_new + amount_>
										<cfset total_amount_ = total_amount_ + amount_>
									</cfif>
								</cfloop>
								#tlformat(amount_new)#
								</td>
							</cfloop>
							<td style="text-align:right">#tlformat(quantity-total_amount_)#</td>
						</cfif>
						<!---<cfif len(order_id_write_list)>
							<cfset total_amount_ = 0>
							<cfloop list="#order_id_write_list#" index="i">
								<td>
								<cfset act_id = listgetat(i,1,';')>
								<cfset amount_new = 0>
								<cfloop list="#order_id_list#" index="j">
									<cfset order_id_ = listgetat(j,1,';')>
									<cfset stock_id_ = listgetat(j,3,';')>
									<cfset amount_ = listgetat(j,4,';')>
									<cfset wrk_row_relation_id_ = listgetat(j,5,';')>
									<cfset teslim_tarih_ = listgetat(j,6,';')>
									<cfif order_id_ eq act_id and get_internald_info2.stock_id eq stock_id_ and get_internald_info2.wrk_row_id eq wrk_row_relation_id_>
										#dateformat(teslim_tarih_,dateformat_style)#
										<cfset amount_new = amount_new + amount_>
										<cfset total_amount_ = total_amount_ + amount_>
									</cfif>
								</cfloop>
								#tlformat(amount_new)#
								</td>
							</cfloop>
							<td style="text-align:right">#tlformat(quantity-total_amount_)#</td>
						</cfif>--->
						<cfif len(order_id_write_list)>
							<cfset total_amount_ = 0>
							<cfloop list="#order_id_write_list#" index="i">
								<td>
									<cfloop list="#order_id_list#" index="j">
										<cfset order_id_ = listgetat(j,1,';')>
										<cfset stock_id_ = listgetat(j,3,';')>
										<cfset amount_ = listgetat(j,4,';')>
										<cfset wrk_row_relation_id_ = listgetat(j,5,';')>
										<cfset teslim_tarih_ = listgetat(j,6,';')>
										<cfif order_id_ eq act_id and get_internald_info2.stock_id eq stock_id_ and get_internald_info2.wrk_row_id eq wrk_row_relation_id_>
											#dateformat(teslim_tarih_,dateformat_style)#
										</cfif>
									</cfloop>
								</td>
								<td>
								<cfset act_id = listgetat(i,1,';')>
								<cfset amount_new = 0>
								<cfloop list="#order_id_list#" index="j">
									<cfset order_id_ = listgetat(j,1,';')>
									<cfset stock_id_ = listgetat(j,3,';')>
									<cfset amount_ = listgetat(j,4,';')>
									<cfset wrk_row_relation_id_ = listgetat(j,5,';')>
									<cfset teslim_tarih_ = listgetat(j,6,';')>
									<cfif order_id_ eq act_id and get_internald_info2.stock_id eq stock_id_ and get_internald_info2.wrk_row_id eq wrk_row_relation_id_>
										<cfset amount_new = amount_new + amount_>
										<cfset total_amount_ = total_amount_ + amount_>
									</cfif>
								</cfloop>
								#tlformat(amount_new)#
								</td>
							</cfloop>
							<td style="text-align:left">#tlformat(quantity-total_amount_)#</td>
						</cfif>
						<cfif len(ship_id_write_list)>
							<cfset total_amount_ = 0>
							<cfloop list="#ship_id_write_list#" index="i">
								<cfset act_id = listgetat(i,1,';')>
								<cfset act_period_id = listgetat(i,3,';')>
								<cfset amount_new = 0>      
								<td style="text-align:right">
									<cfloop list="#ship_id_list#" index="j">
										<cfset ship_id_ = listgetat(j,1,';')>
										<cfset ship_period_id_ = listgetat(j,5,';')>
										<cfset stock_id_ = listgetat(j,3,';')>
										<cfset amount_ = listgetat(j,4,';')>
										<cfset rel_id_ = listgetat(j,6,';')>
										<cfif isdefined("attributes.ajax_box_page")>
										<cfloop list="#ship_write_id_list#" index="k">
											<cfset wrk_row_relation_id_ = listgetat(k,1,';')>
											<cfset amount_new_3 = listgetat(k,2,';')>
											<cfif ship_id_ eq act_id and get_internald_info2.stock_id eq stock_id_ and act_period_id eq ship_period_id_ and get_internald_info2.wrk_row_id eq wrk_row_relation_id_>
												<cfset amount_new = amount_new_3>
												<cfset total_amount_ = amount_new_3>
											</cfif>
										</cfloop>
										<cfelse>
										<cfif ship_id_ eq act_id and get_internald_info2.stock_id eq stock_id_ and act_period_id eq ship_period_id_ and get_internald_info2.wrk_row_id eq wrk_row_relation_id_>
											<cfset amount_new = amount_new + amount_>
											<cfset total_amount_ = total_amount_+amount_new>
										</cfif>
										</cfif>
								</cfloop>
								#tlformat(amount_new)#
								</td>
							</cfloop>
							<td style="text-align:right">#tlformat(quantity-total_amount_)#</td>
						</cfif>
					</tr>
				</cfoutput>
			</tbody>
		</cfif>
	</cf_grid_list>
<!--- Bağlantılı Teklifler --->
<cfif len(offer_id_only_list)>
	<cf_seperator id="internaldemand_comparison" title="#getLang('','',32656)#/#getLang('','',32652)#" collapsable="1" closable="0" uidrop="1" hide_table_column="1">	
		<cf_grid_list id="internaldemand_comparison">
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='33905.Teklifler'></th>
					<th><cf_get_lang dictionary_id='32656.İlişkili Teklifler'></th>
					<th><cf_get_lang dictionary_id='32652.İlişkili Sipariş'></th>
				</tr>
			</thead>
			<tbody>
				<cfquery name="get_related_offer" datasource="#dsn3#">
					SELECT OFFER_ID,OFFER_NUMBER,FOR_OFFER_ID,(SELECT O.OFFER_NUMBER FROM OFFER O WHERE O.OFFER_ID = OFFER.FOR_OFFER_ID) FOR_OFFER_NUMBER FROM OFFER WHERE FOR_OFFER_ID IN(#offer_id_only_list#)
					UNION ALL
					SELECT '' OFFER_ID,'' OFFER_NUMBER,OFFER_ID FOR_OFFER_ID,OFFER_NUMBER FOR_OFFER_NUMBER FROM OFFER WHERE OFFER_ID IN(#offer_id_only_list#) AND OFFER_ID NOT IN(SELECT FOR_OFFER_ID FROM OFFER WHERE FOR_OFFER_ID IS NOT NULL)
				</cfquery>
				<cfset offer_list = ''>
				<cfset offer_count_list = ''>
				<cfoutput query="get_related_offer">
					<cfif listfindnocase(offer_list,for_offer_id)>
						<cfset sira_ = listfindnocase(offer_list,for_offer_id)>
						<cfset sayi_ = listgetat(offer_count_list,sira_)>
						<cfset sayi_ = sayi_ + 1>
						<cfset offer_count_list = listsetat(offer_count_list,sira_,sayi_)>
					<cfelseif not listfindnocase(offer_list,for_offer_id)>
						<cfset offer_list = listappend(offer_list,for_offer_id)>
						<cfset offer_count_list = listappend(offer_count_list,1)>
					</cfif>
				</cfoutput>
				<cfoutput query="get_related_offer">
					<cfscript>
						this_sira_ = listfindnocase(offer_list,for_offer_id);
					if(this_sira_ gt 0)
						this_rows_ = listgetat(offer_count_list,this_sira_);
					else
						this_rows_ = 1;
					</cfscript>
					<cfif len(offer_id)>
						<cfquery name="get_related_order" datasource="#dsn3#">
							SELECT
								ORDER_ID,
								ORDER_NUMBER
							FROM
								RELATION_ROW,
								ORDERS
							WHERE
							FROM_ACTION_ID = #offer_id#
								AND FROM_TABLE = 'OFFER'
								AND TO_TABLE = 'ORDERS'
								AND TO_ACTION_ID = ORDER_ID
							UNION ALL
							SELECT
								ORDER_ID,
								ORDER_NUMBER
							FROM
								RELATION_ROW,
								ORDERS
							WHERE
							FROM_ACTION_ID = #for_offer_id#
								AND FROM_TABLE = 'OFFER'
								AND TO_TABLE = 'ORDERS'
								AND TO_ACTION_ID = ORDER_ID
						</cfquery>
						<cfelse>
						<cfset get_related_order.recordcount = 0>
					</cfif>
					<tr>
						<cfif for_offer_id[currentrow] neq for_offer_id[currentrow-1] or currentrow eq 1> 
							<td rowspan="#this_rows_#"><a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#for_offer_id#" target="_blank" class="tableyazi">#for_offer_number#</a></td>
						</cfif>
						<td><a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#offer_id#" target="_blank" class="tableyazi">#offer_number#</a></td>
						<td>
							<cfif get_related_order.recordcount>
								<a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#get_related_order.order_id#" target="_blank" class="tableyazi">#get_related_order.order_number#</a>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
</cfif>
</cf_box>