<cfinclude template="../query/get_offtimes.cfm">
<cfquery name="get_year" dbtype="query">
	SELECT DISTINCT YEAR_INFO FROM get_offtimes ORDER BY YEAR_INFO DESC
</cfquery>
<cf_box>
	<ul class="ui-list">
		<cfif GET_OFFTIMES.RecordCount>
			<cfoutput query="get_year">
				<cfquery name="get_offtimes_row" dbtype="query">
					SELECT OFFTIME_ID,OFFTIME_NAME,YEAR_INFO,START_DATE FROM get_offtimes WHERE YEAR_INFO = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_year.year_info#"> 
				</cfquery>
				<li>
					<a href="javascript://">
						<div class="ui-list-left">
                            <span class="ui-list-icon ctl-circular-clock"></span>
                            #year_info#
                        </div>
						<div class="ui-list-right">
							<i class="fa fa-chevron-down"></i>
                        </div>
					</a>
					<ul>
						<cfloop query="get_offtimes_row">
							<li>
								<a href="#request.self#?fuseaction=#fusebox.circuit#.form_upd_offtimes&offtime_id=#OFFTIME_ID#">#dateformat(start_date,dateformat_style)# - #OFFTIME_NAME#</a>
							</li>  
						</cfloop>
					</ul>
				</li>
			</cfoutput>  
		 <cfelse>
			<cf_get_lang dictionary_id='57484.Kayıt Yok'>! 
		</cfif>
	</ul>
</cf_box>


