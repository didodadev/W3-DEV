<cfoutput>
	<cfsavecontent variable="my_ims_comp_list">
		SELECT 
			COMP.COMPANY_ID 
		FROM 
			#dsn_alias#.COMPANY COMP
		WHERE
			<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
			 IMS_CODE_ID IN 	
					(SELECT
						IMS_ID
					FROM
						#dsn_alias#.SALES_ZONES_ALL_2
					WHERE
						POSITION_CODE = #session.ep.position_code#	AND 
                        COMPANY_CAT_IDS IS NULL
                    UNION
                    SELECT
						IMS_ID
					FROM
						#dsn_alias#.SALES_ZONES_ALL_2 S2
					WHERE
						POSITION_CODE = #session.ep.position_code# AND
						','+COMPANY_CAT_IDS+',' LIKE '%,'+CAST(COMP.COMPANYCAT_ID AS NVARCHAR)+',%'
                    UNION
                    <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
                    SELECT
                        S1.IMS_ID
                    FROM
                        #dsn_alias#.SALES_ZONES_ALL_1 S1,
                        #dsn_alias#.SALES_ZONES_ALL_1 S2
                    WHERE											
                        (S1.SZ_HIERARCHY = S2.SZ_HIERARCHY OR S2.SZ_HIERARCHY LIKE S1.SZ_HIERARCHY + '.%') AND
                        S1.POSITION_CODE = #session.ep.position_code#		
					 )
	</cfsavecontent>
	<cfsavecontent variable="my_ims_cons_list">
		SELECT 
			CONS.CONSUMER_ID 
		FROM 
			#dsn_alias#.CONSUMER CONS
		WHERE
			<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
            IMS_CODE_ID IN (	SELECT
                                    IMS_ID
                                FROM
                                    #dsn_alias#.SALES_ZONES_ALL_2
                                WHERE
                                    POSITION_CODE = #session.ep.position_code# 
                                    AND CONSUMER_CAT_IDS IS NULL 
                                UNION 
                                SELECT
                                    IMS_ID
                                FROM
                                    #dsn_alias#.SALES_ZONES_ALL_2
                                WHERE
                                    POSITION_CODE = #session.ep.position_code# AND
                                    ','+CONSUMER_CAT_IDS+',' LIKE '%,'+CAST(CONS.CONSUMER_CAT_ID AS NVARCHAR)+',%'
                               UNION
			<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->
                               SELECT
                                    S1.IMS_ID
                                FROM
                                    #dsn_alias#.SALES_ZONES_ALL_1 S1,
                                    #dsn_alias#.SALES_ZONES_ALL_1 S2
                                WHERE											
                                    (S1.SZ_HIERARCHY = S2.SZ_HIERARCHY OR S2.SZ_HIERARCHY LIKE S1.SZ_HIERARCHY + '.%') AND
                                    S1.POSITION_CODE = #session.ep.position_code#
                             )
	</cfsavecontent>
</cfoutput>
