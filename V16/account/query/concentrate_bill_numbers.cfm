<cfquery name="GET_CARD_TYPE" datasource="#DSN2#">
	SELECT DISTINCT CASE WHEN CARD_TYPE=14 THEN 13 ELSE CARD_TYPE END AS CARD_TYPE FROM ACCOUNT_CARD ORDER BY CARD_TYPE
</cfquery>
<!--- Yevmiye nolari degisiyor --->
<cfif isdefined('attributes.yev_start_date') and len(attributes.yev_start_date)>
	<cf_date tarih='attributes.yev_start_date'>
</cfif>
<cfif isdefined('attributes.yev_finish_date') and len(attributes.yev_finish_date)>
	<cf_date tarih='attributes.yev_finish_date'>
</cfif>
<cfif isdefined('attributes.is_only_yev_no') and isdefined('attributes.yev_start_date') and len(attributes.yev_start_date) and isdefined('attributes.yev_no') and len(attributes.yev_no)>
	<!--- sadece yevmiye noları düzenlenecekse --->
	<cfquery name="control_yev_no" datasource="#DSN2#">
		SELECT
			BILL_NO
		FROM
			ACCOUNT_CARD
		WHERE
			ACTION_DATE < #attributes.yev_start_date#
			AND BILL_NO >= #attributes.yev_no#
			<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
				AND (
				<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
					(CARD_TYPE = #listfirst(type_ii,'-')# AND CARD_CAT_ID = #listlast(type_ii,'-')#)
					<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
				</cfloop>  
					)
			</cfif>	
	</cfquery>
	<cfif control_yev_no.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='250.Yevmiye Başlangıç Tarihinden Önce'> <cfoutput>#attributes.yev_no#</cfoutput> <cf_get_lang no ='251.Yevmiye Nosundan Büyük yada Eşit Yevmiye Numaralı Muhasebe Fişi Bulunmaktadır'>!");
			window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=account.form_concentrate_bill_no";
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif GET_CARD_TYPE.RECORDCOUNT>
	<cfset attributes.START_NUM = attributes.yev_no-1>
    <cfquery name="check_table" datasource="#dsn2#" result="aaaaa">
        IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####CONCENTRATE_GET_ROWS_#session.ep.userid#')
        	drop table ####CONCENTRATE_GET_ROWS_#session.ep.userid#
    </cfquery>
	<cfquery name="GET_ROWS" datasource="#DSN2#">
		SELECT
			BILL_NO,
			CARD_ID,
            ROW_NUMBER() OVER (	ORDER BY
                                ACTION_DATE,
                                CARD_TYPE,
                                BILL_NO
									)+#attributes.START_NUM# AS RowNum
		INTO ####CONCENTRATE_GET_ROWS_#session.ep.userid#
        FROM
			ACCOUNT_CARD
		WHERE
			CARD_ID IS NOT NULL
		<cfif isdefined('attributes.yev_start_date') and len(attributes.yev_start_date)>
			AND ACTION_DATE >= #attributes.yev_start_date#
		</cfif>
		<cfif isdefined('attributes.yev_finish_date') and len(attributes.yev_finish_date)>
			AND ACTION_DATE <= #attributes.yev_finish_date#
		</cfif>
		<cfif isdefined('attributes.is_only_yev_no') and isdefined('attributes.yev_start_no') and len(attributes.yev_start_no)>
			AND BILL_NO > #attributes.yev_start_no#
		</cfif>
		<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
			AND (
			<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
				(CARD_TYPE = #listfirst(type_ii,'-')# AND CARD_CAT_ID = #listlast(type_ii,'-')#)
				<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
			</cfloop>  
				)
		</cfif>				
	</cfquery>
    <cfquery name="UPD_ROWS" datasource="#dsn2#">
    	UPDATE
            ACCOUNT_CARD
        SET
            BILL_NO= XXX.RowNum
        FROM
        	####CONCENTRATE_GET_ROWS_#session.ep.userid# AS XXX JOIN ACCOUNT_CARD ON ACCOUNT_CARD.CARD_ID = XXX.CARD_ID
        WHERE 
        	XXX.BILL_NO IS NOT NULL 
    </cfquery>
	<!---<cfif GET_ROWS.RECORDCOUNT>
		<cfloop  index="i"  from="1" to="#GET_ROWS.RECORDCOUNT#">
			<cfif (GET_ROWS.BILL_NO[i] neq  attributes.START_NUM) and LEN(GET_ROWS.BILL_NO[i])>
				<cfquery name="UPD_ROW" datasource="#DSN2#">
					UPDATE
						ACCOUNT_CARD
					SET
						BILL_NO=#attributes.START_NUM#	
					WHERE
						CARD_ID=#GET_ROWS.CARD_ID[i]#
				</cfquery>
			</cfif>
			<cfset attributes.START_NUM = attributes.START_NUM + 1>
		</cfloop>
	</cfif>--->
</cfif>
<cfif not isdefined('attributes.is_only_yev_no')>
<cfif GET_CARD_TYPE.RECORDCOUNT >
	<cfloop from="1" to="#GET_CARD_TYPE.RECORDCOUNT#" index="j">
		<cfif len(GET_CARD_TYPE.CARD_TYPE[j]) >
			<cfif GET_CARD_TYPE.CARD_TYPE[j] eq 11>
				<cfset attributes.START_NUM_11 = attributes.t_bill-1>
                <cfquery name="check_table" datasource="#dsn2#">
           	        IF object_id('tempdb..####CONCENTRATE_GET_ROWS_11_#session.ep.userid#')  IS NOT NULL
                    drop table ####CONCENTRATE_GET_ROWS_11_#session.ep.userid#
                </cfquery>
            <cfelseif GET_CARD_TYPE.CARD_TYPE[j] eq 12>
				 <cfset attributes.START_NUM_12 = attributes.te_bill-1>
                 <cfquery name="check_table" datasource="#dsn2#">
           	        IF object_id('tempdb..####CONCENTRATE_GET_ROWS_12_#session.ep.userid#')  IS NOT NULL
                    drop table ####CONCENTRATE_GET_ROWS_12_#session.ep.userid#
                 </cfquery>
            <cfelseif listfind('13,14,19',GET_CARD_TYPE.CARD_TYPE[j])>    
				<cfset attributes.START_NUM_13 = attributes.m_bill-1>
                <cfquery name="check_table" datasource="#dsn2#">
                    IF object_id('tempdb..####CONCENTRATE_GET_ROWS_13_#session.ep.userid#')  IS NOT NULL
                    drop table ####CONCENTRATE_GET_ROWS_13_#session.ep.userid#
                </cfquery>
            </cfif>
            <cfquery name="GET_ROWS" datasource="#DSN2#">
				SELECT
					CARD_TYPE_NO,
					CARD_ID
                    
                    <cfif GET_CARD_TYPE.CARD_TYPE[j] eq 11>
                        ,ROW_NUMBER() OVER (	ORDER BY
                                                BILL_NO,
                                                ACTION_DATE
                                        )+#attributes.START_NUM_11# AS RowNum
                    <cfelseif GET_CARD_TYPE.CARD_TYPE[j] eq 12> 
                        ,ROW_NUMBER() OVER (	ORDER BY
                                                BILL_NO,
                                                ACTION_DATE
                                        )+#attributes.START_NUM_12# AS RowNum
                    <cfelseif listfind('13,14,19',GET_CARD_TYPE.CARD_TYPE[j])> 
                    	,ROW_NUMBER() OVER (	ORDER BY
                                                BILL_NO,
                                                ACTION_DATE
                                        )+#attributes.START_NUM_13# AS RowNum
                    </cfif>           
                                    
				<cfif GET_CARD_TYPE.CARD_TYPE[j] eq 11>
                	INTO ####CONCENTRATE_GET_ROWS_11_#session.ep.userid#
                <cfelseif GET_CARD_TYPE.CARD_TYPE[j] eq 12> 
                 	INTO ####CONCENTRATE_GET_ROWS_12_#session.ep.userid#
                <cfelseif listfind('13,14,19',GET_CARD_TYPE.CARD_TYPE[j])> 
                 	INTO ####CONCENTRATE_GET_ROWS_13_#session.ep.userid#
                 </cfif> 
                FROM
					ACCOUNT_CARD
				WHERE
					CARD_TYPE = #GET_CARD_TYPE.CARD_TYPE[j]#
				<cfif isdefined('attributes.yev_start_date') and len(attributes.yev_start_date)>
					AND ACTION_DATE >= #attributes.yev_start_date#
				</cfif>
				<cfif isdefined('attributes.yev_finish_date') and len(attributes.yev_finish_date)>
					AND ACTION_DATE <= #attributes.yev_finish_date#
				</cfif>
				<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
					AND (
					<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
						(CARD_TYPE = #listfirst(type_ii,'-')# AND CARD_CAT_ID = #listlast(type_ii,'-')#)
						<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
					</cfloop>  
						)
				</cfif>				
			</cfquery>
			<cfif GET_CARD_TYPE.CARD_TYPE[j] eq 11>
				<!---<cfset attributes.START_NUM_11 = attributes.t_bill>--->
				<cfquery name="UPD_ROW" datasource="#DSN2#">
                    UPDATE
                        ACCOUNT_CARD
                    SET
                        CARD_TYPE_NO = XXX.ROWNUM	
                    FROM 
                    	####CONCENTRATE_GET_ROWS_11_#session.ep.userid# XXX JOIN ACCOUNT_CARD ON ACCOUNT_CARD.CARD_ID = XXX.CARD_ID
                </cfquery>
				<!---<cfif GET_ROWS.RECORDCOUNT>
					<cfloop index="i" from="1" to="#GET_ROWS.RECORDCOUNT#">
						<cfif GET_ROWS.CARD_TYPE_NO[i] neq  attributes.START_NUM_11 >
							<cfquery name="UPD_ROW" datasource="#DSN2#">
								UPDATE
									ACCOUNT_CARD
								SET
									CARD_TYPE_NO = #attributes.START_NUM_11#	
								WHERE
									CARD_ID=#GET_ROWS.CARD_ID[i]#
							</cfquery>
						</cfif>
						<cfset attributes.START_NUM_11 = attributes.START_NUM_11 + 1 >
					</cfloop>
				</cfif>--->
			</cfif>
			<cfif  GET_CARD_TYPE.CARD_TYPE[j] eq 12>
				<!---<cfset attributes.START_NUM_12 = attributes.te_bill>--->
				<cfquery name="UPD_ROW" datasource="#DSN2#">
                    UPDATE
                        ACCOUNT_CARD
                    SET
                        CARD_TYPE_NO = XXX.ROWNUM
                    FROM
                        ####CONCENTRATE_GET_ROWS_12_#session.ep.userid# XXX JOIN ACCOUNT_CARD ON ACCOUNT_CARD.CARD_ID = XXX.CARD_ID
                </cfquery>
				<!---<cfif GET_ROWS.RECORDCOUNT >
					<cfloop index="i" from="1" to="#GET_ROWS.RECORDCOUNT#">
						<cfif GET_ROWS.CARD_TYPE_NO[i] neq  attributes.START_NUM_12 >
							<cfquery name="UPD_ROW" datasource="#DSN2#">
								UPDATE
									ACCOUNT_CARD
								SET
									CARD_TYPE_NO = #attributes.START_NUM_12#	
								WHERE
									CARD_ID=#GET_ROWS.CARD_ID[i]#
							</cfquery>
						</cfif>
						<cfset attributes.START_NUM_12 = attributes.START_NUM_12 + 1 >
					</cfloop>
				</cfif>--->
			</cfif>
			<cfif listfind('13,14,19',GET_CARD_TYPE.CARD_TYPE[j])>
				<cfquery name="UPD_ROW" datasource="#DSN2#">
                    UPDATE
                        ACCOUNT_CARD
                    SET
                        CARD_TYPE_NO = XXX.ROWNUM	
                    FROM
                        ####CONCENTRATE_GET_ROWS_13_#session.ep.userid# XXX JOIN ACCOUNT_CARD ON ACCOUNT_CARD.CARD_ID = XXX.CARD_ID
                </cfquery>
				<!---<cfif not isdefined('attributes.START_NUM_13')>
					<cfset attributes.START_NUM_13 = attributes.m_bill>
				</cfif>--->
				<!---<cfif GET_ROWS.RECORDCOUNT >
					<cfloop index="i" from="1" to="#GET_ROWS.RECORDCOUNT#">
						<cfif GET_ROWS.CARD_TYPE_NO[i] neq  attributes.START_NUM_13 >
							<cfquery name="UPD_ROW" datasource="#DSN2#">
								UPDATE
									ACCOUNT_CARD
								SET
									CARD_TYPE_NO = #attributes.START_NUM_13#	
								WHERE
									CARD_ID=#GET_ROWS.CARD_ID[i]#
							</cfquery>
						</cfif>
						<cfset attributes.START_NUM_13 = attributes.START_NUM_13 + 1 >
					</cfloop>
				</cfif>--->
			</cfif>
		</cfif>
	</cfloop>
</cfif>
</cfif>
<cfif not isdefined("yevmiye_alacak_dev")>
	<script type="text/javascript">
		alert("<cfif not isdefined('attributes.is_only_yev_no')><cf_get_lang no='70.Fiş Numaraları Başarı ile Düzenlenmiştir !'><cfelse><cf_get_lang no ='252.Sadece Yevmiye Numaraları Düzenlenmiştir'>!</cfif>");
		window.location.href= '<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_account_plan';
	</script>
</cfif>
