<cfquery name="get_branches" datasource="#dsn#">
	SELECT 
	    BRANCHES_ID,
        #dsn#.Get_Dynamic_Language(BRANCHES_ID,'#session.ep.language#','SETUP_APP_BRANCHES','BRANCHES_NAME',NULL,NULL,BRANCHES_NAME) AS BRANCHES_NAME, 
        BRANCHES_DETAIL, 
        BRANCHES_STATUS, 
        BRANCHES_ROW_TYPE, 
        BRANCHES_ROW_LINE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_APP_BRANCHES
</cfquery>
<cfquery name="get_branches_row" datasource="#dsn#">
	SELECT 
	    BRANCHES_ROW_ID, 
        BRANCHES_ID, 
        BRANCHES_NAME_ROW, 
        BRANCHES_DETAIL_ROW, 
        BRANCHES_STATUS_ROW, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	SETUP_APP_BRANCHES_ROWS
</cfquery>

<cf_box title="#getLang('','CV Branş Kategorileri','43715')#">
	<ul class="ui-list">
		<cfif get_branches.recordcount>
			<cfoutput query="get_branches">
				<cfquery name="get_branches_rows" datasource="#dsn#">
					SELECT 
						BRANCHES_ROW_ID, 
						BRANCHES_ID, 
						BRANCHES_NAME_ROW, 
						BRANCHES_DETAIL_ROW, 
						BRANCHES_STATUS_ROW, 
						RECORD_DATE, 
						RECORD_EMP, 
						RECORD_IP, 
						UPDATE_DATE, 
						UPDATE_EMP, 
						UPDATE_IP
					FROM 
						SETUP_APP_BRANCHES_ROWS WHERE BRANCHES_ID = #get_branches.branches_id#
				</cfquery>
				<li>
					<a>
						<div class="ui-list-left">
                            <span class="ui-list-icon ctl-visit-cards"></span>
							#branches_name#
                        </div>
						<div class="ui-list-right">
							<i class="fa fa-plus" title="<cf_get_lang dictionary_id='43782.Branş Alt Kategorisi Ekle'>" onclick="javascript:location.href='#request.self#?fuseaction=settings.list_cv_branches&event=addSub&branches_id=#get_branches.branches_id#'"></i>
							<i class="fa fa-pencil" onclick="javascript:location.href='#request.self#?fuseaction=settings.list_cv_branches&event=upd&branches_id=#get_branches.branches_id#'" title="<cf_get_lang no ='1798.Branş Kategorisi Güncelle'>"></i>
							<i class="fa fa-chevron-down"></i>
							
                        </div>
					</a>
					<ul>
						<cfset branches_id_ = get_branches.branches_id>
						<cfloop query="get_branches_rows">
							<li>
								<a href="index.cfm?fuseaction=settings.list_cv_branches&event=updSub&branches_id=#get_branches.branches_id#&bid=#get_branches_rows.BRANCHES_ROW_ID#">
									<div class="ui-list-left">
										<span class="ui-list-icon ctl-visit-cards" title="<cf_get_lang dictionary_id='43783.Branş Alt Kategorisi Güncelle'>"></span>
										#BRANCHES_NAME_ROW#
									</div>
								</a>
							</li>  
						</cfloop>
					</ul>
				</li>
			</cfoutput>
		<cfelse>
			<tr>
				<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</ul>
</cf_box>

