<cfcomponent>
    <cfinclude template="/fbx_workcube_funcs.cfm">
    <cffunction name="getGridData" access="remote" returntype="any" returnformat="plain">
        <cfquery name="getGridQuery" datasource="#application.systemParam.systemParam().dsn#">
            WITH CTE1 AS (
                #url.sql#
            ),
            CTE2 AS (
            	SELECT
                	*,
                    ROW_NUMBER() OVER (
                        <cfif not (isDefined("url.sortdatafield") and len(url.sortdatafield))>
                            ORDER BY (SELECT 0)
                        <cfelse>
                            ORDER BY #url.sortdatafield# #url.sortorder#
                        </cfif>
                    ) AS ROWNUM
                FROM
                	CTE1
                WHERE
                    1 = 1
                    <cfif url.filterscount gt 0>
                        <cfloop from="0" to="#url.filterscount-1#" index="i">
                        	<cfif i eq 0 or evaluate("url.filterdatafield#i#") neq evaluate("url.filterdatafield#i-1#")>
                            	AND (
                            </cfif>
                            
                            #evaluate("url.filterdatafield#i#")#
                            <cfswitch expression="#evaluate('url.filtercondition#i#')#">
                                <cfcase value="CONTAINS"> LIKE '%#evaluate("url.filtervalue#i#")#%' </cfcase>
                                <cfcase value="DOES_NOT_CONTAIN"> NOT LIKE '%#evaluate("url.filtervalue#i#")#%' </cfcase>
                                <cfcase value="EQUAL"> = '#evaluate("url.filtervalue#i#")#' </cfcase>
                                <cfcase value="NOT_EQUAL"> <> '#evaluate("url.filtervalue#i#")#' </cfcase>
                                <cfcase value="GREATER_THAN"> > '#evaluate("url.filtervalue#i#")#' </cfcase>
                                <cfcase value="LESS_THAN"> < '#evaluate("url.filtervalue#i#")#' </cfcase>
                                <cfcase value="GREATER_THAN_OR_EQUAL"> >= '#evaluate("url.filtervalue#i#")#' </cfcase>
                                <cfcase value="LESS_THAN_OR_EQUAL"> <= '#evaluate("url.filtervalue#i#")#' </cfcase>
                                <cfcase value="STARTS_WITH"> LIKE '#evaluate("url.filtervalue#i#")#%' </cfcase>
                                <cfcase value="ENDS_WITH"> LIKE '%#evaluate("url.filtervalue#i#")#' </cfcase>
                                <cfdefaultcase>#evaluate('url.filtercondition#i#')#</cfdefaultcase>
                            </cfswitch>
                            
							<cfif evaluate("url.filteroperator#i#") eq 1>
                                OR
                            <cfelse>
                                AND
                            </cfif>
                            
                        	<cfif i eq url.filterscount-1 or evaluate("url.filterdatafield#i#") neq evaluate("url.filterdatafield#i+1#")>
								<cfif evaluate("url.filteroperator#i#") eq 1>
                                    1 = 2
                                <cfelse>
                                    1 = 1
                                </cfif>
                            	)
                            </cfif>
                        </cfloop>
                    </cfif>
            )
            SELECT
                *,
                (SELECT COUNT(*) FROM CTE2) AS TOTALROWS
            FROM
                CTE2
            WHERE
                ROWNUM BETWEEN #url.pagenum * url.pagesize# AND #(url.pagenum + 1) * url.pagesize#
        </cfquery>
        <cfsavecontent variable="result">
        	<cfoutput>#serializeJQXformat(getGridQuery)#</cfoutput>
        </cfsavecontent>
        <cfreturn result>
    </cffunction>
</cfcomponent>

