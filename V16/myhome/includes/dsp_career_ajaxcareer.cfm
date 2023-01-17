<cfsetting showdebugoutput="no">
<cfquery name="get_notice_v" datasource="#dsn#">
	SELECT 
		NOTICE_HEAD,
		POSITION_CAT_NAME,
		DETAIL,
		WORK_DETAIL,
		COUNT_STAFF,
		POSITION_NAME,
		NOTICE_ID,
        NOTICE_CITY,
        STARTDATE,
        FINISHDATE
	FROM
		NOTICES
	WHERE
		STATUS=1 AND
		PUBLISH LIKE '%2%' AND
		STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
		FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
		STATUS_NOTICE= -2
	ORDER BY 
		NOTICE_ID DESC
</cfquery>
<cfset list_city=listsort(listdeleteduplicates(valuelist(get_notice_v.NOTICE_CITY,',')),'Numeric','ASC',',')>
<cfif listlen(list_city,',')>
    <cfquery name="GET_CITY_ALL" datasource="#DSN#">
        SELECT 
    	    CITY_ID, 
            CITY_NAME
        FROM 
	        SETUP_CITY 
        WHERE 
        	CITY_ID IN (#list_city#)
    </cfquery>
</cfif>
<cf_flat_list scroll="1">
	<cfif get_notice_v.recordcount>
		<thead>
			<tr>
				<th width="75"><cf_get_lang no='720.İlan Başlık'></th>
				<th><cf_get_lang_main no='559.Şehir'></th>
				<th><cf_get_lang dictionary_id='56206.İşin Tanımı'></th>
				<th><cf_get_lang dictionary_id='31343.Kadro Sayısı'></th>
			</tr>
		</thead>
		<cfif listfind(list_city,0,',')>
			<cfset list_city_3=ListDeleteAt(list_city,listfind(list_city,0,','),',')>
		<cfelse>
			<cfset list_city_3=list_city>
		</cfif>
		<tbody>
			<cfoutput query="get_notice_v">
				<tr>
					<td>
						<cfset notice_id_ = contentEncryptingandDecodingAES(isEncode:1,content:notice_id,accountKey:session.ep.userid)>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_notice&notice_id=#notice_id_#','page');" class="tableyazi">#notice_head#</a>
					</td>
					<td>
					<cfif listlen(notice_city,',')>
						<cfset list_city_2=listsort(notice_city,'numeric','ASC',',')>
						<cfif listfind(list_city_2,0,',')>
							Tüm Türkiye,
							<cfset list_city_2=ListDeleteAt(list_city_2,listfind(list_city_2,0,','),',')>
						</cfif>
						<cfloop list="#list_city_2#" index="ind_cty">
							<cfif len(ind_cty)>
								#get_city_all.city_name[listfind(list_city_3,ind_cty,',')]#<cfif listlast(list_city_2,',') neq ind_cty>,</cfif>
							</cfif>
						</cfloop>
					</cfif>
					</td>
					<td>
						#trim(listfirst(WORK_DETAIL,"."))#...<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_notice&notice_id=#notice_id_#','page');" class="tableyazi"><cf_get_lang dictionary_id='57904.Daha Fazla'></a>
					</td>
					<td>
						#count_staff#
					</td>
				</tr>
			</cfoutput>
		  <cfelse>
			<tr><td><cf_get_lang_main no='72.Kayıt Yok'> !</td></tr>
		</tbody>
	</cfif>
</cf_flat_list>
