<cfquery name="GET_LIT" DATASOURCE="#DSN#" maxrows="5">
	SELECT
		CONT_HEAD,
		CONTENT_ID
	FROM
		CONTENT
	WHERE
		EMPLOYEE_VIEW = 1 AND
		IS_VIEWED = 1 AND
		VIEW_DATE_START <= #now()# AND
		VIEW_DATE_FINISH >= #now()# AND
		STAGE_ID = -2
</cfquery>
<div class="blog_title"><cfoutput>#getLang('main',706,'duyurular')#</cfoutput></div>
<cfif get_lit.recordcount>
	<div class="flex-col">
		<cfoutput query="get_lit">
			<div class="blog_item">
				<div class="blog_item_text">
					<a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_lit.content_id#">#get_lit.cont_head#</a>
				</div>
			</div>
		</cfoutput>
	</div>	
<cfelse>
	<h2><cf_get_lang_main no='72.Kayıt Yok'></h2>
</cfif>
<!--- <ul class="ltList">
    <cfif get_lit.recordcount>
        <cfoutput query="get_lit">
            <li>
                <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_lit.content_id#">#get_lit.cont_head#</a>
            </li>
        </cfoutput>
    <cfelse>
        <li><cf_get_lang_main no='72.Kayıt Yok'> !</li>
    </cfif>
</ul> --->
