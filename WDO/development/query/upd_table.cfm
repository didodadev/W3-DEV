<cfsetting showdebugoutput="no">

<cfquery datasource="#dsn#" name="get_old_table">
	SELECT * FROM WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#attributes.object_id#  <!---  --->
</cfquery>
<cfquery datasource="#dsn#" name="get_company">
	SELECT COMP_ID FROM  OUR_COMPANY
</cfquery>
<cfquery datasource="#dsn#" name="get_old_table">
	SELECT * FROM WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#attributes.object_id#  <!---  --->
</cfquery>
<cfquery name="get_old_columns" datasource="#dsn#">
	SELECT * FROM WRK_COLUMN_INFORMATION WHERE TABLE_ID=#attributes.object_id# <!---  --->
</cfquery>
<cfquery name="get_catalog_name" datasource="#dsn#">
	SELECT DB_NAME FROM WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#attributes.object_id#  <!---  --->
</cfquery>

	

<cfif get_old_table.DB_TYPE  eq 1 >
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="upd_table_name_in_object_info" datasource="#get_catalog_name.DB_NAME#">
				UPDATE  
					#dsn#.dbo.WRK_OBJECT_INFORMATION
				SET 
					OBJECT_NAME='#attributes.table_name_text#',
					TABLE_INFO='#attributes.table_info_text#',
					UPDATE_IP='#cgi.remote_addr#',
					UPDATE_DATE=#now()#,
					UPDATE_EMP=#session.ep.userid#,
					TYPE=<cfif isdefined("attributes.TYPE") and attributes.TYPE is 'on' >1<cfelse>0</cfif>,
					STATUS='#attributes.STATUS#',
					VERSION='#attributes.VERSION#',
					TABLE_INFO_ENG= <cfif len("attributes.table_info_eng")>'#attributes.table_info_eng#'<cfelse>NULL</cfif>
				WHERE   
					OBJECT_ID=#attributes.object_id#
			</cfquery>
			<!------>
			<cfset col_id = ValueList(get_old_columns.COLUMN_ID)>
			<cfset col_type=ValueList(get_old_columns.DATA_TYPE)>
			<cfsavecontent variable="veri">
					<cfloop index="i" from="1" to="#attributes.record_num#">
					 <cfif evaluate("attributes.control_#i#") eq 1>
						<cfset attributes.column_id = evaluate("attributes.column_id#i#")>		
						<cfset attributes.column_info=evaluate("attributes.column_info#i#")>
						<cfset attributes.column_info_eng=evaluate("attributes.column_info_eng#i#")>
								<!--- Burda kolon bilgilerini wrk_colomn_information tablosunda da güncelliyoruz--->
                                <cfquery name="update_table_propert_in_column_information" datasource="#get_catalog_name.DB_NAME#">
                                    UPDATE  #dsn#.dbo.WRK_COLUMN_INFORMATION
                                       SET  COLUMN_INFO='#attributes.column_info#',
                                            COLUMN_INFO_ENG='#attributes.column_info_eng#',
                                            UPDATE_IP='#cgi.remote_addr#',
                                            UPDATE_DATE=#now()#,
                                            UPDATE_EMP=#session.ep.userid#
                                    WHERE
                                            TABLE_ID=#attributes.object_id# and COLUMN_ID=#attributes.column_id#	
                                </cfquery>
					</cfif>								
					</cfloop>
			</cfsavecontent>
		</cftransaction>
	</cflock>
    
<cfelseif get_old_table.DB_TYPE  eq 2>	
<cflock name="#CREATEUUID()#" timeout="60">
    <cftransaction>
        <cfquery name="upd_table_name_in_object_info" datasource="#get_catalog_name.DB_NAME#">
            UPDATE  
                #dsn#.dbo.WRK_OBJECT_INFORMATION
            SET 
                OBJECT_NAME='#attributes.table_name_text#',
                TABLE_INFO='#attributes.table_info_text#',
                UPDATE_IP='#cgi.remote_addr#',
                UPDATE_DATE=#now()#,
                UPDATE_EMP=#session.ep.userid#,
                TYPE=<cfif isdefined("attributes.TYPE") and attributes.TYPE is 'on' >1<cfelse>0</cfif>,
                STATUS='#attributes.STATUS#',
                VERSION='#attributes.VERSION#',
                TABLE_INFO_ENG= <cfif len("attributes.table_info_eng")>'#attributes.table_info_eng#'<cfelse>NULL</cfif>
            WHERE   
                OBJECT_ID=#attributes.object_id#
        </cfquery>
		<cfset col_id = ValueList(get_old_columns.COLUMN_ID)>
		<cfset col_type=ValueList(get_old_columns.DATA_TYPE)>
        <cfsavecontent variable="veri">
                <cfloop index="i" from="1" to="#attributes.record_num#">
                 <cfif evaluate("attributes.control_#i#") eq 1>
                    <cfset attributes.column_id = evaluate("attributes.column_id#i#")>		
                    <cfset attributes.column_info=evaluate("attributes.column_info#i#")>
                    <cfset attributes.column_info_eng=evaluate("attributes.column_info_eng#i#")>

							
                    <cfquery name="update_table_propert_in_column_information" datasource="#get_catalog_name.DB_NAME#">
                        UPDATE  #dsn#.dbo.WRK_COLUMN_INFORMATION
                           SET 
                                COLUMN_INFO='#attributes.column_info#',
                                COLUMN_INFO_ENG='#attributes.column_info_eng#',
                                UPDATE_IP='#cgi.remote_addr#',
                                UPDATE_DATE=#now()#,
                                UPDATE_EMP=#session.ep.userid#
                        WHERE
                                TABLE_ID=#attributes.object_id# and COLUMN_ID=#attributes.column_id#	
                    </cfquery>						
            	</cfif>		
        	</cfloop>
		</cfsavecontent>
	</cftransaction>
</cflock>			

<cfelseif get_old_table.DB_TYPE  eq 3 >
<cflock name="#CREATEUUID()#" timeout="60">
    <cftransaction>			
        <cfquery name="upd_table_name_in_object_info" datasource="#get_catalog_name.DB_NAME#">
            UPDATE  
                #dsn#.dbo.WRK_OBJECT_INFORMATION
            SET 
                OBJECT_NAME='#attributes.table_name_text#',
                TABLE_INFO='#attributes.table_info_text#',
                UPDATE_IP='#cgi.remote_addr#',
                UPDATE_DATE=#now()#,
                UPDATE_EMP=#session.ep.userid#,
                TYPE=<cfif isdefined("attributes.TYPE") and attributes.TYPE is 'on' >1<cfelse>0</cfif>,
                STATUS='#attributes.STATUS#',
                VERSION='#attributes.VERSION#',
                TABLE_INFO_ENG= <cfif len("attributes.table_info_eng")>'#attributes.table_info_eng#'<cfelse>NULL</cfif>
            WHERE   
                OBJECT_ID=#attributes.object_id#
        </cfquery>
		<cfset col_id = ValueList(get_old_columns.COLUMN_ID)>
        <cfset col_type=ValueList(get_old_columns.DATA_TYPE)>
        <cfsavecontent variable="veri">
                <cfloop index="i" from="1" to="#attributes.record_num#">
                 <cfif evaluate("attributes.control_#i#") eq 1>
                    <cfset attributes.column_id = evaluate("attributes.column_id#i#")>		
                    <cfset attributes.column_info=evaluate("attributes.column_info#i#")>
                    <cfset attributes.column_info_eng=evaluate("attributes.column_info_eng#i#")>
                    <cfquery name="update_table_propert_in_column_information" datasource="#get_catalog_name.DB_NAME#">
                        UPDATE  #dsn#.dbo.WRK_COLUMN_INFORMATION
                           SET  COLUMN_INFO='#attributes.column_info#',
                                COLUMN_INFO_ENG='#attributes.column_info_eng#',
                                UPDATE_IP='#cgi.remote_addr#',
                                UPDATE_DATE=#now()#,
                                UPDATE_EMP=#session.ep.userid#
                        WHERE
                                TABLE_ID=#attributes.object_id# and COLUMN_ID=#attributes.column_id#	
                    </cfquery>					
				 </cfif>		
				</cfloop>
		</cfsavecontent>
	</cftransaction>
</cflock>	
            
            								
<cfelseif get_old_table.DB_TYPE  eq 4 >
    <cflock name="#CREATEUUID()#" timeout="60">
        <cftransaction>			
            <cfquery name="upd_table_name_in_object_info" datasource="#get_catalog_name.DB_NAME#">
                UPDATE  
                    #dsn#.dbo.WRK_OBJECT_INFORMATION
                SET 
                    OBJECT_NAME='#attributes.table_name_text#',
                    TABLE_INFO='#attributes.table_info_text#',
                    UPDATE_IP='#cgi.remote_addr#',
                    UPDATE_DATE=#now()#,
                    UPDATE_EMP=#session.ep.userid#,
                    TYPE=<cfif isdefined("attributes.TYPE") and attributes.TYPE is 'on' >1<cfelse>0</cfif>,
                    STATUS='#attributes.STATUS#',
                    VERSION='#attributes.VERSION#',
                    TABLE_INFO_ENG= <cfif len("attributes.table_info_eng")>'#attributes.table_info_eng#'<cfelse>NULL</cfif>
                WHERE   
                    OBJECT_ID=#attributes.object_id#
            </cfquery>
			<cfset col_id = ValueList(get_old_columns.COLUMN_ID)>
            <cfset col_type=ValueList(get_old_columns.DATA_TYPE)>
            <cfsavecontent variable="veri">
                <cfloop index="i" from="1" to="#attributes.record_num#">
                     <cfif evaluate("attributes.control_#i#") eq 1>
                        <cfset attributes.column_id = evaluate("attributes.column_id#i#")>		
                        <cfset attributes.column_info=evaluate("attributes.column_info#i#")>
                        <cfset attributes.column_info_eng=evaluate("attributes.column_info_eng#i#")>
                                    
                        <cfquery name="update_table_propert_in_column_information" datasource="#get_catalog_name.DB_NAME#">
                            UPDATE  #dsn#.dbo.WRK_COLUMN_INFORMATION
                               SET  
                                    COLUMN_INFO='#attributes.column_info#',
                                    COLUMN_INFO_ENG='#attributes.column_info_eng#',
                                    UPDATE_IP='#cgi.remote_addr#',
                                    UPDATE_DATE=#now()#,
                                    UPDATE_EMP=#session.ep.userid#
                            WHERE
                                    TABLE_ID=#attributes.object_id# and COLUMN_ID=#attributes.column_id#	
                        </cfquery>
                    </cfif>		
                </cfloop>
			</cfsavecontent>
		</cftransaction>
	</cflock>		
</cfif>


					
<cflocation addtoken="no" url="http://ep.workcube/index.cfm?fuseaction=dev.form_upd_table&TABLE_ID=#attributes.object_id#">

