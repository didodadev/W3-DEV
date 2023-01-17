<cfquery name="PURCHASES" datasource="#dsn2#">
	SELECT
		SHIP.PURCHASE_SALES,
		SHIP.SHIP_ID,
		SHIP.SHIP_NUMBER,
		SHIP.SHIP_TYPE,
		SHIP.SHIP_DATE,
		SHIP.COMPANY_ID,
		SHIP.CONSUMER_ID,
		SHIP.PARTNER_ID,
		SHIP.DELIVER_STORE_ID,
		SHIP.NETTOTAL
	FROM
		SHIP
	WHERE
    	SHIP_TYPE <> 81 
		AND 
		(
			(
				SHIP.SHIP_ID IN ( SELECT
								DISTINCT SHIP_ROW.SHIP_ID
							FROM
								SHIP_ROW
							WHERE
								AMOUNT -(ISNULL((SELECT
													SUM(A1.AMOUNT)
												FROM
												(
														
														SELECT 
															IR.AMOUNT
														FROM
															INVOICE_ROW IR
														WHERE
															IR.WRK_ROW_RELATION_ID=SHIP_ROW.WRK_ROW_ID AND 
															IR.SHIP_ID=SHIP_ROW.SHIP_ID
													                                                    
												) AS A1),0)
											+
											ISNULL((SELECT
													SUM(A1.AMOUNT)
												FROM
												(
                                                    
														SELECT 
															SRR.AMOUNT
														FROM
															SHIP_ROW SRR
														WHERE
															SRR.WRK_ROW_RELATION_ID=SHIP_ROW.WRK_ROW_ID 												
												) AS A1),0)	
											)>0																									
									AND SHIP_ROW.SHIP_ID=SHIP.SHIP_ID )
			 )
		)
		AND SHIP.IS_SHIP_IPTAL = 0
		AND SHIP.PURCHASE_SALES=1
		AND SHIP.IS_WITH_SHIP = 0
		<cfif attributes.xml_is_salaried eq 0><!--- ucretlendirilmemis servis irsaliyelerinin gelmesini engeller --->
			AND ISNULL((SELECT TOP 1 SERVICE.IS_SALARIED FROM SHIP_ROW,#dsn3_alias#.SERVICE WHERE SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND SERVICE.SERVICE_ID = SHIP_ROW.SERVICE_ID),1) = 1
		</cfif>
	ORDER BY 
		SHIP.SHIP_DATE DESC
</cfquery>
