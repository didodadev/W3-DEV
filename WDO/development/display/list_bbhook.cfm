<cfparam name="attributes.author" default="">
<cfparam name="attributes.source" default="">
<cfparam name="attributes.destination" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_search" default="0">
<cfparam name="attributes.work_status" default="-1">
<cfparam name="attributes.work_cat" default="">
<cfparam name="attributes.work_stage" default="">

<cfif attributes.is_search eq 1>
    <cfif len(attributes.start_date)>
        <cf_date tarih="attributes.start_date">
    </cfif>
    <cfif len(attributes.finish_date)>
        <cf_date tarih="attributes.finish_date">
    </cfif>
    <cfquery name="qbblist" datasource="#dsn#">
        SELECT * FROM
        (
            SELECT TASK_ID
            FROM BITBUCKET_HOOKS
            WHERE 1 = 1
            <cfif len(attributes.start_date)>
                AND CREATED >= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#attributes.start_date#'>
            </cfif>
            <cfif len(attributes.finish_date)>
                AND CREATED <= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#attributes.finish_date#'>
            </cfif>
            GROUP BY TASK_ID
        ) BBMAIN
        CROSS APPLY (
            SELECT TOP 1 DESTINATION_BRANCH, SOURCE_BRANCH, CREATED, AUTHOR, TITLE FROM BITBUCKET_HOOKS
            WHERE TASK_ID = BBMAIN.TASK_ID AND STATE = 'MERGED'
            ORDER BY CREATED DESC
        ) BBBRANCH
        LEFT JOIN (
            SELECT 
                PRO_WORKS.WORK_ID,
                PRO_WORKS.WORK_STATUS,
                PRO_WORKS.PROJECT_EMP_ID,
                PRO_WORKS.WORK_CURRENCY_ID,
                (SELECT PTR.STAGE FROM PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID = PRO_WORKS.WORK_CURRENCY_ID) STAGE,
                (SELECT E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = PRO_WORKS.PROJECT_EMP_ID) WORKER_NAME,
                PRO_WORK_CAT.WORK_CAT_ID,
                (#dsn#.Get_Dynamic_Language(PRO_WORK_CAT.WORK_CAT_ID,'#session.ep.language#','PRO_WORK_CAT','WORK_CAT',NULL,NULL,PRO_WORK_CAT.WORK_CAT)) AS WORK_CAT
            FROM PRO_WORKS
            LEFT JOIN PRO_WORK_CAT ON PRO_WORKS.WORK_CAT_ID = PRO_WORK_CAT.WORK_CAT_ID
        ) WORKS 
        ON BBMAIN.TASK_ID = WORKS.WORK_ID
        WHERE 1 = 1
        <cfif len(attributes.destination)>
            AND DESTINATION_BRANCH LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#attributes.destination#%'>        
        </cfif>
        <cfif len(attributes.source)>
            AND SOURCE_BRANCH LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#attributes.source#%'>
        </cfif>
        <cfif len(attributes.author)>
            AND AUTHOR LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#attributes.author#%'>
        </cfif>
        <cfif len(attributes.work_status) and attributes.work_status NEQ -1>
            AND WORK_STATUS = <cfqueryparam cfsqltype='CF_SQL_BIT' value='#attributes.work_status#'>
        </cfif>
        <cfif len(attributes.work_cat)>
            AND WORKS.WORK_CAT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.work_cat#'>
        </cfif>
        <cfif len(attributes.work_stage)>
            AND WORK_CURRENCY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.work_stage#'>
        </cfif>
        ORDER BY CREATED DESC
    </cfquery>
<cfelse>
    <cfset qbblist.recordCount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#qbblist.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="GET_PROCURRENCY" datasource="#DSN#">
	SELECT
        #dsn_alias#.Get_Dynamic_Language(PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.works%">
	ORDER BY
		PTR.LINE_NUMBER,
		PTR.STAGE
</cfquery>

<cfquery name="GET_WORK_CAT" datasource="#DSN#">
	SELECT 
		#dsn#.Get_Dynamic_Language(PRO_WORK_CAT.WORK_CAT_ID,'#session.ep.language#','PRO_WORK_CAT','WORK_CAT',NULL,NULL,PRO_WORK_CAT.WORK_CAT) AS work_cat,
		WORK_CAT_ID,
		TEMPLATE_ID 
	FROM 
		PRO_WORK_CAT
	ORDER BY 
		WORK_CAT
</cfquery>

<cf_box id="filter">
    <cfform method="POST">
        <input type="hidden" name="is_search" value="1">
        <cf_box_search more="0">
            <cfoutput>
                <div class="form-group">
                    <input type="text" name="author" placeholder="Developer" value="#attributes.author#">
                </div>
                <div class="form-group">
                    <input type="text" name="source" placeholder="Source Branch" value="#attributes.source#">
                </div>
                <div class="form-group">
                    <input type="text" name="destination" placeholder="Destination Branch" value="#attributes.destination#">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfoutput>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58053. Başlangıç Tarihi'></cfsavecontent>
                            <cfinput type="text" name="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#" placeholder="#message#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfoutput>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700. Bitiş Tarihi'></cfsavecontent>
                            <cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" message="#message#" placeholder="#message#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <select name="work_status" id="work_status" style="width:60px; height:17px;">
                        <option value="-1" <cfif isDefined("attributes.work_status") and (attributes.work_status eq -1)>selected</cfif>><cf_get_lang_main no='296.Tümü'>
                        <option value="1" <cfif isDefined("attributes.work_status") and (attributes.work_status eq 1)>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                        <option value="0" <cfif isDefined("attributes.work_status") and (attributes.work_status eq 0)>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                    </select>
                </div>
            </cfoutput>
            <div class="form-group">
                <select name="work_cat" id="work_cat" style="width:90px; height:17px;">
                    <option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
                    <cfoutput query="GET_WORK_CAT">
                        <option value="#get_work_cat.work_cat_id#" <cfif attributes.work_cat eq get_work_cat.work_cat_id>selected</cfif>>#get_work_cat.work_cat#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group">
                <select name="work_stage" id="work_stage" style="width:90px; height:17px;">
                    <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
                    <cfoutput query="get_procurrency">
                        <option value="#process_row_id#"<cfif isDefined("attributes.work_stage") and (attributes.work_stage eq process_row_id)>selected</cfif>>#stage#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" >
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </cf_box_search>
    </cfform>
</cf_box>

<cf_box title="#getlang('','Git Requests Son İşlemler','64536')#" id="bb_list" uidrop="1" hide_table_column="1">
    <cf_ajax_list>
        <thead>
            <tr>
                <th>#</th>
                <th>Task ID</th>
                <th>Status</th>
                <th>Category</th>
                <th>Stage</th>
                <th>Worker</th>
                <th>Type</th>
                <th>Source Branch</th>
                <th>Destination Branch</th>
                <th>Created</th>
                <th>Author</th>
            </tr>
        <thead>
        <tbody>
            <cfif qbblist.recordCount>
                <cfoutput query="qbblist" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#currentrow#</td>
                    <td><a href="https://networg.workcube.com/index.cfm?fuseaction=project.works&event=det&id=#task_id#" target="_blank"><i class="fa fa-external-link"></i> #task_id#</a></td>
                    <td>
                        <cfif work_status eq 1>
                            <cf_get_lang_main no='81.aktif'>
                        <cfelseif work_status eq 0>
                            <cf_get_lang_main no='82.pasif'>
                        </cfif>
                    </td>
                    <td>#WORK_CAT#</td>
                    <td>#stage#</td>
                    <td>#worker_name#</td>
                    <td>#((len(TITLE) and listLen(TITLE,'-') gte 3) and (listGetAt(TITLE, 2,'-') eq 'hotfix' or listGetAt(TITLE, 2,'-') eq 'feature')) ? listGetAt(TITLE, 2,'-') : ''#</td>
                    <td>#source_branch#</td>
                    <td>#destination_branch#</td>
                    <td>#dateformat(created, dateformat_style)#</td>
                    <td>#CharsetEncode(ToBinary(ToBase64(author, 'windows-1252')), 'utf-8')#</td>
                </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="20"><cfif not attributes.is_search><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_ajax_list>

    <cfset url_str = "&is_search=1">
    <cfif len(attributes.author)>
        <cfset url_str = "#url_str#&author=#attributes.author#">
    </cfif>
    <cfif len(attributes.source)>
        <cfset url_str = "#url_str#&source=#attributes.source#">
    </cfif>
    <cfif len(attributes.destination)>
        <cfset url_str = "#url_str#&destination=#attributes.destination#">
    </cfif>
    <cfif len(attributes.start_date)>
        <cfset url_str = "#url_str#&start_date=#attributes.start_date#">
    </cfif>
    <cfif len(attributes.finish_date)>
        <cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
    </cfif>
    <cfif len(attributes.work_status)>
        <cfset url_str = "#url_str#&work_status=#attributes.work_status#">
    </cfif>
    <cfif len(attributes.work_stage)>
        <cfset url_str = "#url_str#&work_stage=#attributes.work_stage#">
    </cfif>
    <cf_paging 
        page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="dev.bitbucket#url_str#">
</cf_box>