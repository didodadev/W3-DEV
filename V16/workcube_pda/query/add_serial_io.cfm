<cfquery name="GET_SERIAL_NOS" datasource="#DSN3#">
    SELECT 
        STOCK_ID, 
        SERIAL_NO 
    FROM 
        SERVICE_GUARANTY_NEW
    WHERE
        PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
</cfquery>
<cflock name="#CreateUUID()#" timeout="20">
  	<cftransaction>
        <cfloop from="1" to="50" index="i">
            <cfif len(evaluate('attributes.ship_start_nos#i#'))>
            	<cfif listlen(evaluate('attributes.ship_start_nos#i#'),'#chr(13)##chr(10)#') gt evaluate('attributes.amount#i#')>
                	<script language="javascript">
						alert('Toplam Miktar Sayısından Fazla Kayıt Girmeye Çalışıyorsunuz!');
						history.back(-1);
					</script>
                    <cfabort>
                </cfif>
                <cfquery name="GET_SERIAL_NO_EXIST" dbtype="query">
                    SELECT 
                        * 
                    FROM 
                        GET_SERIAL_NOS 
                    WHERE 
                        STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sid#i#')#">
                </cfquery>
                <cfoutput query="get_serial_no_exist">
                	<cfif not listfindnocase(evaluate('attributes.ship_start_nos#i#'),serial_no,'#chr(13)##chr(10)#')>
                    	<cfquery name="DEL_SERIAL" datasource="#DSN3#">
                        	DELETE FROM SERVICE_GUARANTY_NEW 
                            WHERE 
                            	PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
                                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sid#i#')#"> AND
                                SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#serial_no#">
                        </cfquery>
                    </cfif>
                </cfoutput>
                <cfloop from="1" to="#listlen(evaluate('attributes.ship_start_nos#i#'),'#chr(13)##chr(10)#')#" index="j">
                    <cfset serial_no = "#listgetat(evaluate('attributes.ship_start_nos#i#'),j,'#chr(13)##chr(10)#')#">
                	<cfquery name="GET_SERIAL_NO" dbtype="query">
                    	SELECT 
                        	* 
                        FROM 
                        	GET_SERIAL_NOS 
                        WHERE 
                        	SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#serial_no#"> AND
                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sid#i#')#">
                    </cfquery>
                    
                    <cfquery name="GET_GUARANTY_TIME" datasource="#DSN3#">                    	
						SELECT GUARANTYCAT_TIME FROM #dsn_alias#.SETUP_GUARANTYCAT_TIME
                    </cfquery>
                    
                    <cfif not get_serial_no.recordcount>
                        <cfquery name="ADD_GUARANTY" datasource="#DSN3#" result="xxx">
                            INSERT INTO
                                SERVICE_GUARANTY_NEW
                                (
                                    SALE_GUARANTY_CATID,
                                    IS_SERI_SONU,
                                    IS_SERVICE,
                                    IS_RMA,
                                    IS_RETURN,
                                    IS_PURCHASE,
                                    IS_SALE,
                                    LOT_NO,
				    				IN_OUT,
                                    DEPARTMENT_ID,
                                    LOCATION_ID,
                                    SERIAL_NO,
                                    SPECT_ID,
                                    PROCESS_ID,
				    				PROCESS_NO,
                                    PROCESS_CAT,
                                    STOCK_ID,
                                    PERIOD_ID,
                                    <cfif attributes.in_out eq 1>
                                    	PURCHASE_COMPANY_ID,
                                    	PURCHASE_PARTNER_ID,   
                                        PURCHASE_START_DATE,   
                                        PURCHASE_FINISH_DATE,                                    
                                    <cfelse>
                                      	SALE_COMPANY_ID,
                                    	SALE_PARTNER_ID, 
                                        SALE_START_DATE,   
                                        SALE_FINISH_DATE,                                    
                                    </cfif>
                                    RECORD_IP,
                                    RECORD_EMP,
                                    RECORD_DATE
                                )
                                VALUES
                                (
                                    1,
                                    0,
                                    0,
                                    0,
                                    0,
                                    <cfif attributes.in_out eq 1>
                                    	1,
                                        0,
                                    <cfelse>
                                    	0,
                                        1,
                                    </cfif>
                                    '',
				    				#attributes.in_out#,
                                    <cfif isDefined('attributes.department_id') and len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
                                    <cfif isDefined('attributes.location_id') and len(attributes.location_id)>#attributes.location_id#<cfelse>NULL</cfif>,
                                    '#serial_no#',
                                    <cfif len(evaluate('attributes.spect_var_id#i#'))>#evaluate('attributes.spect_var_id#i#')#<cfelse>NULL</cfif>,
                                    #attributes.process_id#,
				    				'#attributes.process_no#',
                                    #attributes.process_cat#,
                                    #evaluate('attributes.sid#i#')#,
                                    #session.pda.period_id#,
                                    #attributes.company_id#,
                                    #attributes.partner_id#,
                                    <cfif attributes.in_out eq 1>
                                        #now()#,
                                        #DateAdd('m',get_guaranty_time.guarantycat_time,now())#,
                                    <cfelse>
                                        #now()#,
                                        #DateAdd('m',get_guaranty_time.guarantycat_time,now())#,
                                    </cfif>
                                    '#cgi.remote_addr#',
                                    #session.pda.userid#,
                                    #now()#
                                )
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
        </cfloop>
    </cftransaction>
</cflock>

<script language="javascript">
	alert('Kaydınız güncellenmiştir');
	<cfoutput>
	window.location.href='#request.self#?fuseaction=#attributes.fuseact_#';
	</cfoutput>
</script>
