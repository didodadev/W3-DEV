<cfsetting showdebugoutput="no">
<cfquery name="get_camp_date" datasource="#dsn3#">
	SELECT 
		CAMP_STARTDATE,
		CAMP_FINISHDATE,
		CAMP_ID 
	FROM 
		CAMPAIGNS 
	WHERE 
	<cfif isdefined("attributes.camp_id")>
		CAMP_ID = #attributes.camp_id#
	<cfelse>
		CAMP_STARTDATE < #now()# 
		AND CAMP_FINISHDATE > #now()#
	</cfif>
</cfquery>
<cfif get_camp_date.recordcount>
	<cfquery name="get_ref_member" datasource="#DSN#">
		SELECT
			CONSUMER_ID,
			MEMBER_CODE,
			CONSUMER_REFERENCE_CODE,
			REF_POS_CODE,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER_CAT_ID,
			1 AS KONTROL
		FROM
			CONSUMER_HISTORY CH
		WHERE
			REF_POS_CODE = #cid# AND
			CONSUMER_STATUS = 1 AND
			CAMP_ID = #get_camp_date.camp_id# AND
			CONSUMER_ID IN (SELECT REF_POS_CODE FROM CONSUMER_HISTORY WHERE REF_POS_CODE IS NOT NULL AND REF_POS_CODE = CH.CONSUMER_ID AND CAMP_ID = #get_camp_date.camp_id#)
		UNION ALL
		SELECT
			CONSUMER_ID,
			MEMBER_CODE,
			CONSUMER_REFERENCE_CODE,
			REF_POS_CODE,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER_CAT_ID,
			0 AS KONTROL
		FROM
			CONSUMER_HISTORY CH
		WHERE
			REF_POS_CODE = #cid# AND
			CONSUMER_STATUS = 1 AND
			CAMP_ID = #get_camp_date.camp_id# AND
			CONSUMER_ID NOT IN (SELECT REF_POS_CODE FROM CONSUMER_HISTORY WHERE REF_POS_CODE IS NOT NULL AND REF_POS_CODE = CH.CONSUMER_ID AND CAMP_ID = #get_camp_date.camp_id#)
		UNION ALL
		SELECT
			CONSUMER_ID,
			MEMBER_CODE,
			CONSUMER_REFERENCE_CODE,
			REF_POS_CODE,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER_CAT_ID,
			1 AS KONTROL
		FROM 
			CONSUMER_HISTORY CH
		WHERE
			REF_POS_CODE = #cid# AND
			CONSUMER_STATUS = 1 AND
			CONSUMER_ID IN (SELECT REF_POS_CODE FROM CONSUMER_HISTORY WHERE REF_POS_CODE IS NOT NULL AND REF_POS_CODE = CH.CONSUMER_ID AND RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)#) AND CONSUMER_ID NOT IN (SELECT CONSUMER_ID FROM CONSUMER_HISTORY WHERE CAMP_ID = #get_camp_date.camp_id#) AND
			RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)# AND
			CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM CONSUMER_HISTORY CHH WHERE CHH.CONSUMER_ID = CH.CONSUMER_ID AND CHH.RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)#)
		UNION ALL
		SELECT 
			CONSUMER_ID,
			MEMBER_CODE,
			CONSUMER_REFERENCE_CODE,
			REF_POS_CODE,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER_CAT_ID,
			0 AS KONTROL
		FROM 
			CONSUMER_HISTORY CH
		WHERE
			REF_POS_CODE = #cid# AND
			CONSUMER_STATUS = 1 AND
			CONSUMER_ID NOT IN (SELECT REF_POS_CODE FROM CONSUMER_HISTORY WHERE REF_POS_CODE IS NOT NULL AND REF_POS_CODE = CH.CONSUMER_ID AND RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)#) AND CONSUMER_ID NOT IN (SELECT CONSUMER_ID FROM CONSUMER_HISTORY WHERE CAMP_ID = #get_camp_date.camp_id#) AND
			RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)# AND
			CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM CONSUMER_HISTORY CHH WHERE CHH.CONSUMER_ID = CH.CONSUMER_ID AND CHH.RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)#)
		ORDER BY 
			KONTROL DESC
	</cfquery>
<cfelse>DDD
	<cfquery name="get_ref_member" datasource="#DSN#">
		SELECT
			CONSUMER_ID,
			MEMBER_CODE,
			CONSUMER_REFERENCE_CODE,
			REF_POS_CODE,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER_CAT_ID,
			1 AS KONTROL
		FROM
			CONSUMER
		WHERE
			REF_POS_CODE = #cid# AND
			CONSUMER_STATUS = 1
	</cfquery>
</cfif>
<cfif get_camp_date.recordcount gt 0>
	<cfquery name="get_first_camp" datasource="#dsn3#" maxrows="2">
		SELECT CAMP_STARTDATE,CAMP_FINISHDATE,CAMP_ID FROM CAMPAIGNS WHERE CAMP_FINISHDATE < #createodbcdatetime(get_camp_date.camp_startdate)# ORDER BY CAMP_FINISHDATE DESC
	</cfquery>
<cfelse>
	<cfset get_first_camp.recordcount = 0>
</cfif>
<cfif get_first_camp.recordcount gte 2>
	<cfquery name="get_min_camp" dbtype="query" maxrows="1">
		SELECT CAMP_ID FROM get_first_camp ORDER BY CAMP_FINISHDATE
	</cfquery>
	<cfquery name="get_last_camp" datasource="#dsn3#">
		SELECT CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #get_min_camp.camp_id#
	</cfquery>
<cfelse>
	<cfset get_last_camp.recordcount = 0>
</cfif>
<cfif get_ref_member.recordcount>
	<cfquery name="get_member_sale" datasource="#dsn2#">
		SELECT 
			ISNULL(SUM(NETTOTAL),0) NETTOTAL,
			CONSUMER_ID
		FROM(
			SELECT
				SUM(NETTOTAL) NETTOTAL,
				CONSUMER_ID		
			FROM
				CONSUMER_SALE
			WHERE	
				CONSUMER_ID IN(#valuelist(get_ref_member.consumer_id)#)
				<cfif get_camp_date.recordcount gt 0>
					AND INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
				</cfif>
			GROUP BY
				CONSUMER_ID
			)T1		
		GROUP BY
			CONSUMER_ID							
	</cfquery>
	<cfif get_camp_date.recordcount gt 0>
		<cfquery name="get_group_sale" datasource="#dsn2#">
			SELECT
				SALE_STAGE,
				CONSUMER_ID AS REF_POS,
				SUM(NETTOTAL) NETTOTAL,
				SUM(INV_NETTOTAL) INV_NETTOTAL
			FROM
			(
				SELECT
					I.SALE_STAGE,
					I.CONSUMER_ID,
					I.INVOICE_DATE,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.GROSSTOTAL ELSE I.GROSSTOTAL END AS NETTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.NETTOTAL ELSE I.NETTOTAL END AS GROSSTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.INV_GROSSTOTAL ELSE I.INV_GROSSTOTAL END AS INV_NETTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.INV_NETTOTAL ELSE I.INV_NETTOTAL END AS INV_GROSSTOTAL
				FROM
					INVOICE_MULTILEVEL_SALES I
				WHERE
					I.INVOICE_CAT IN(52,53,54,55,62)
					AND CONSUMER_ID IN(#valuelist(get_ref_member.consumer_id)#)
					AND REF_CONSUMER_ID IN
					(
					SELECT 
						CH.CONSUMER_ID 
					FROM 
						#dsn_alias#.CONSUMER_HISTORY CH 
					WHERE 
						I.SALE_STAGE =
						CASE WHEN
							(len(replace(SUBSTRING(CH.CONSUMER_REFERENCE_CODE,(CHARINDEX('.'+CAST(I.CONSUMER_ID AS NVARCHAR)+'.','.'+CH.CONSUMER_REFERENCE_CODE+'.')+(LEN(I.CONSUMER_ID))),len(CH.CONSUMER_REFERENCE_CODE) ) ,'.',' .') )-len(SUBSTRING(CH.CONSUMER_REFERENCE_CODE,(CHARINDEX('.'+CAST(I.CONSUMER_ID AS NVARCHAR)+'.','.'+CH.CONSUMER_REFERENCE_CODE+'.')+(LEN(I.CONSUMER_ID)+1)),len(CH.CONSUMER_REFERENCE_CODE)))) = 0
						THEN 
							1
						ELSE 
							(len(replace(SUBSTRING(CH.CONSUMER_REFERENCE_CODE,(CHARINDEX('.'+CAST(I.CONSUMER_ID AS NVARCHAR)+'.','.'+CH.CONSUMER_REFERENCE_CODE+'.')+(LEN(I.CONSUMER_ID))),len(CH.CONSUMER_REFERENCE_CODE) ) ,'.',' .') )-len(SUBSTRING(CH.CONSUMER_REFERENCE_CODE,(CHARINDEX('.'+CAST(I.CONSUMER_ID AS NVARCHAR)+'.','.'+CH.CONSUMER_REFERENCE_CODE+'.')+(LEN(I.CONSUMER_ID)+1)),len(CH.CONSUMER_REFERENCE_CODE))))
						END 
						AND '.'+CH.CONSUMER_REFERENCE_CODE+'.' LIKE '%.'+CAST(I.CONSUMER_ID AS NVARCHAR)+'.%' 
						AND CH.CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM #dsn_alias#.CONSUMER_HISTORY CHH 
						WHERE CHH.CONSUMER_ID = CH.CONSUMER_ID AND (<cfif isdefined("attributes.camp_id")>CHH.CAMP_ID =#attributes.camp_id# OR </cfif>CHH.RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)#))
					)
					<cfif get_camp_date.recordcount gt 0>
						AND INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
					</cfif>	
			) T1
			GROUP BY
				SALE_STAGE,
				CONSUMER_ID
		</cfquery>
		<cfquery name="get_group_sale_2" datasource="#dsn2#">
			SELECT
				CONSUMER_ID AS REF_POS,
				SUM(NETTOTAL) NETTOTAL,
				SUM(INV_NETTOTAL) INV_NETTOTAL
			FROM
			(
				SELECT
					I.SALE_STAGE,
					I.CONSUMER_ID,
					I.INVOICE_DATE,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.GROSSTOTAL ELSE I.GROSSTOTAL END AS NETTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.NETTOTAL ELSE I.NETTOTAL END AS GROSSTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.INV_GROSSTOTAL ELSE I.INV_GROSSTOTAL END AS INV_NETTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.INV_NETTOTAL ELSE I.INV_NETTOTAL END AS INV_GROSSTOTAL
				FROM
					INVOICE_MULTILEVEL_SALES I
				WHERE
					I.INVOICE_CAT IN(52,53,54,55,62)
					AND CONSUMER_ID IN(#valuelist(get_ref_member.consumer_id)#)
					AND REF_CONSUMER_ID IN
					(
					SELECT 
						CH.CONSUMER_ID 
					FROM 
						#dsn_alias#.CONSUMER_HISTORY CH 
					WHERE 
						I.SALE_STAGE =
						CASE WHEN
							(len(replace(SUBSTRING(CH.CONSUMER_REFERENCE_CODE,(CHARINDEX('.'+CAST(I.CONSUMER_ID AS NVARCHAR)+'.','.'+CH.CONSUMER_REFERENCE_CODE+'.')+(LEN(I.CONSUMER_ID))),len(CH.CONSUMER_REFERENCE_CODE) ) ,'.',' .') )-len(SUBSTRING(CH.CONSUMER_REFERENCE_CODE,(CHARINDEX('.'+CAST(I.CONSUMER_ID AS NVARCHAR)+'.','.'+CH.CONSUMER_REFERENCE_CODE+'.')+(LEN(I.CONSUMER_ID)+1)),len(CH.CONSUMER_REFERENCE_CODE)))) = 0
						THEN 
							1
						ELSE 
							(len(replace(SUBSTRING(CH.CONSUMER_REFERENCE_CODE,(CHARINDEX('.'+CAST(I.CONSUMER_ID AS NVARCHAR)+'.','.'+CH.CONSUMER_REFERENCE_CODE+'.')+(LEN(I.CONSUMER_ID))),len(CH.CONSUMER_REFERENCE_CODE) ) ,'.',' .') )-len(SUBSTRING(CH.CONSUMER_REFERENCE_CODE,(CHARINDEX('.'+CAST(I.CONSUMER_ID AS NVARCHAR)+'.','.'+CH.CONSUMER_REFERENCE_CODE+'.')+(LEN(I.CONSUMER_ID)+1)),len(CH.CONSUMER_REFERENCE_CODE))))
						END 
						AND '.'+CH.CONSUMER_REFERENCE_CODE+'.' LIKE '%.'+CAST(I.CONSUMER_ID AS NVARCHAR)+'.%' 
						AND CH.CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM #dsn_alias#.CONSUMER_HISTORY CHH 
						WHERE CHH.CONSUMER_ID = CH.CONSUMER_ID AND (<cfif isdefined("attributes.camp_id")>CHH.CAMP_ID =#attributes.camp_id# OR </cfif>CHH.RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)#))
					)
					<cfif get_camp_date.recordcount gt 0>
						AND INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
					</cfif>	
					AND SALE_STAGE <= 3
			) T1
			GROUP BY
				CONSUMER_ID
		</cfquery>
		<cfquery name="get_ref_member_count" datasource="#dsn#">
			SELECT 
				COUNT(CH.CONSUMER_ID) AS MEMBER_COUNT,
				CH.REF_POS_CODE
			FROM
				CONSUMER C,
				CONSUMER_HISTORY CH
			WHERE
				C.CONSUMER_ID = CH.CONSUMER_ID
				AND CH.CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM CONSUMER_HISTORY CHH WHERE CHH.CONSUMER_ID = CH.CONSUMER_ID AND CHH.RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)#)
				AND CH.REF_POS_CODE IS NOT NULL
				AND C.CONSUMER_ID IN(
									SELECT
										CONSUMER_ID
									FROM 
										#dsn2_alias#.CONSUMER_SALE
									<cfif get_camp_date.recordcount gt 0>
										WHERE
											INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)#
									</cfif>
									GROUP BY
										CONSUMER_ID
									HAVING SUM(NETTOTAL) >= 1
									)
				<cfif get_last_camp.recordcount gt 0>
					AND (C.REF_CHANGE_DATE IS NULL OR (C.REF_CHANGE_DATE < #createodbcdatetime(get_last_camp.camp_startdate)#))
				</cfif>
			GROUP BY
				CH.REF_POS_CODE
		</cfquery>
		<cfquery name="get_all_ref_member_count" datasource="#dsn#">
			SELECT 
				COUNT(CH.CONSUMER_ID) AS MEMBER_COUNT,
				CH.REF_POS_CODE
			FROM
				CONSUMER C,
				CONSUMER_HISTORY CH
			WHERE
				C.CONSUMER_ID = CH.CONSUMER_ID
				AND CH.CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM CONSUMER_HISTORY CHH WHERE CHH.CONSUMER_ID = CH.CONSUMER_ID AND CHH.RECORD_DATE < #createodbcdatetime(get_camp_date.camp_finishdate)#)
				AND CH.REF_POS_CODE IS NOT NULL
			GROUP BY
				CH.REF_POS_CODE
		</cfquery>
		<cfloop query="get_member_sale">
			<cfif len(get_member_sale.nettotal)>	
				<cfset 'member_sale_#get_member_sale.consumer_id#'= get_member_sale.nettotal>
			</cfif>
		</cfloop>
		<cfloop query="get_group_sale">
			<cfif len(get_group_sale.nettotal)>	
				<cfset 'group_sale_#get_group_sale.sale_stage#_#get_group_sale.ref_pos#'= get_group_sale.nettotal>
			</cfif>
		</cfloop>
		<cfloop query="get_group_sale_2">
			<cfif len(get_group_sale_2.nettotal)>	
				<cfset 'group_sale_total_#get_group_sale_2.ref_pos#'= get_group_sale_2.nettotal>
			</cfif>
		</cfloop>
		<cfloop query="get_ref_member_count">
			<cfif len(get_ref_member_count.member_count)>	
				<cfset 'member_count_#get_ref_member_count.ref_pos_code#'= get_ref_member_count.member_count>
			</cfif>
		</cfloop>
		<cfloop query="get_all_ref_member_count">
			<cfif len(get_all_ref_member_count.member_count)>	
				<cfset 'member_all_count_#get_all_ref_member_count.ref_pos_code#'= get_all_ref_member_count.member_count>
			</cfif>
		</cfloop>
	</cfif>
<cfelse>
	<cfset get_group_sale.recordcount = 0>
	<cfset get_member_sale.recordcount = 0>
</cfif>
<cfquery name="get_ref_pos_code" datasource="#dsn#">
	SELECT REF_POS_CODE FROM CONSUMER WHERE REF_POS_CODE IS NOT NULL
</cfquery>
<cfif not isdefined("attributes.is_display")>
	<table width="100%" cellpadding="2" cellspacing="1" border="0" class="color-header">
		<tr class="color-list" height="22">
			<td class="txtboldblue" width="10"><cf_get_lang dictionary_id='57487.No'></td>
			<td class="txtboldblue"><cf_get_lang dictionary_id='32280.Referans Kod'></td>
			<td class="txtboldblue"><cf_get_lang dictionary_id='57558.Üye No'></td>
			<td class="txtboldblue"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
			<td class="txtboldblue"><cf_get_lang dictionary_id='57486.Kategori'></td>
			<td class="txtboldblue"><cf_get_lang dictionary_id='57493.Aktif'></td>
			<td class="txtboldblue" width="120"><cf_get_lang dictionary_id='32281.Temsilci Sayısı'></td>
			<td class="txtboldblue" width="120"><cf_get_lang dictionary_id='32282.Aktif Temsilci Sayısı'></td>
			<td class="txtboldblue"><cf_get_lang dictionary_id='32283.Kişisel Ciro'></td>
			<cfloop from="1" to="3" index="con_indx">
				<td class="txtboldblue"><cfoutput>#con_indx#</cfoutput>.<cf_get_lang dictionary_id='32285.Seviye Ciro'></td>
			</cfloop>
			<td class="txtboldblue"><cf_get_lang dictionary_id='32284.Grup Cirosu'></td>
		</tr>
		<cfif get_ref_member.recordcount>
			<cfset consumer_cat_list = ''>
			<cfoutput query="get_ref_member">
				<cfif not listfind(consumer_cat_list,consumer_cat_id)>
					<cfset consumer_cat_list=listappend(consumer_cat_list,consumer_cat_id)>
				</cfif>
			</cfoutput>	
			<cfset consumer_cat_list=listsort(consumer_cat_list,"numeric")>
			<cfif len(consumer_cat_list)>
				<cfset consumer_cat_list=listsort(consumer_cat_list,"numeric","ASC",",")>
				<cfquery name="GET_CONSCAT" datasource="#DSN#">
					SELECT 
						CONSCAT_ID,
						CONSCAT
					FROM 
						CONSUMER_CAT
					WHERE 
						CONSCAT_ID IN (#consumer_cat_list#)
					ORDER BY
						CONSCAT_ID
				</cfquery>
				<cfset consumer_cat_list = listsort(listdeleteduplicates(valuelist(get_conscat.conscat_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="get_ref_member">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td width="10">#currentrow#</td>
					<td width="100" id="emp_row#consumer_id#" <cfif get_ref_pos_code.recordcount and listfind(valuelist(get_ref_pos_code.ref_pos_code),consumer_id)>onClick="gizle_goster(emp_detail#consumer_id#);connectAjax_list('#consumer_id#','#currentrow#','#consumer_id#');gizle_goster(emp_goster#consumer_id#);gizle_goster(emp_gizle#consumer_id#);"</cfif> nowrap>
						<cfif get_ref_pos_code.recordcount and listfind(valuelist(get_ref_pos_code.ref_pos_code),consumer_id)>
							<img id="emp_goster#consumer_id#" src="/images/listele.gif" border="0" title="Referans Olduğu Üyeleri Göster" align="absbottom">
							<img id="emp_gizle#consumer_id#" src="/images/listele_down.gif" border="0" title="Gizle" style="display:none">
						<cfelse>
							&nbsp;&nbsp;&nbsp;
						</cfif>
						#ref_pos_code#
					</td>
					<td width="60">#member_code#</td>
					<td width="150"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">#consumer_name# #consumer_surname#</a></td>
					<td width="120"><cfif len(consumer_cat_id)>#get_conscat.conscat[listfind(consumer_cat_list,consumer_cat_id,',')]#</cfif></td>
					<td width="20">
						<cfif isdefined("member_sale_#consumer_id#") and evaluate("member_sale_#consumer_id#") gt 0>1<cfelse>0</cfif>
					</td>
					<td width="100"  style="text-align:right;"><cfif isdefined("member_all_count_#consumer_id#")>#evaluate("member_all_count_#consumer_id#")#<cfelse>#0#</cfif></td>
					<td width="100"  style="text-align:right;"><cfif isdefined("member_count_#consumer_id#")>#evaluate("member_count_#consumer_id#")#<cfelse>#0#</cfif></td>
					<td width="100"  style="text-align:right;"><cfif isdefined("member_sale_#consumer_id#")>#tlformat(evaluate("member_sale_#consumer_id#"))#<cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
					<cfloop from="1" to="3" index="con_indx">
						<td width="100"  style="text-align:right;"><cfif isdefined("group_sale_#con_indx#_#consumer_id#")>#tlformat(evaluate("group_sale_#con_indx#_#consumer_id#"))#<cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
					</cfloop>
					<td width="100"  style="text-align:right;"><cfif isdefined("group_sale_total_#consumer_id#")>#tlformat(evaluate("group_sale_total_#consumer_id#"))#<cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
				</tr>
				<!-- sil -->
				<tr id="emp_detail#consumer_id#" class="color-row" style="display:none">
					<td colspan="13">
						<div align="left" id="display_emp_detail#consumer_id#"></div>
					</td>
				</tr>
				<!-- sil -->
			</cfoutput>
		<cfelse>
			<cfif not isdefined("attributes.is_display")>
				<tr class="color-row" height="22">
					<td colspan="13"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
				</tr>
			</cfif>
		</cfif>
	</table>
<cfelse>
	<cfif get_ref_member.recordcount>
	<table width="100%">
		<tr>
			<td width="4%">&nbsp;</td>
			<td width="96%">
				<table width="100%">
					<cfset consumer_cat_list = ''>
					<cfoutput query="get_ref_member">
						<cfif not listfind(consumer_cat_list,consumer_cat_id)>
							<cfset consumer_cat_list=listappend(consumer_cat_list,consumer_cat_id)>
						</cfif>
					</cfoutput>	
					<cfset consumer_cat_list=listsort(consumer_cat_list,"numeric")>
					<cfif len(consumer_cat_list)>
						<cfset consumer_cat_list=listsort(consumer_cat_list,"numeric","ASC",",")>
						<cfquery name="GET_CONSCAT" datasource="#DSN#">
							SELECT 
								CONSCAT_ID,
								CONSCAT
							FROM 
								CONSUMER_CAT
							WHERE 
								CONSCAT_ID IN (#consumer_cat_list#)
							ORDER BY
								CONSCAT_ID
						</cfquery>
						<cfset consumer_cat_list = listsort(listdeleteduplicates(valuelist(get_conscat.conscat_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_ref_member">
						<tr height="25" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td width="90" id="emp_row#consumer_id#" <cfif get_ref_pos_code.recordcount and listfind(valuelist(get_ref_pos_code.ref_pos_code),consumer_id)>onClick="gizle_goster(emp_detail#consumer_id#);connectAjax_list('#consumer_id#','#currentrow#','#consumer_id#');gizle_goster(emp_goster#consumer_id#);gizle_goster(emp_gizle#consumer_id#);"</cfif> nowrap>
								<cfif get_ref_pos_code.recordcount and listfind(valuelist(get_ref_pos_code.ref_pos_code),consumer_id)>
									<img id="emp_goster#consumer_id#" src="/images/listele.gif" border="0" title="Referans Olduğu Üyeleri Göster" align="absbottom">
									<img id="emp_gizle#consumer_id#" src="/images/listele_down.gif" border="0" title="Gizle" style="display:none">
								<cfelse>
									&nbsp;&nbsp;&nbsp;
								</cfif>
								#attributes.ref_code#
							</td>
							<td width="60">#member_code#</td>
							<td width="150"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">#consumer_name# #consumer_surname#</a></td>
							<td width="120"><cfif len(consumer_cat_id)>#get_conscat.conscat[listfind(consumer_cat_list,consumer_cat_id,',')]#</cfif></td>
							<td width="20">
								<cfif isdefined("member_sale_#consumer_id#") and evaluate("member_sale_#consumer_id#") gt 0>1<cfelse>0</cfif>
							</td>
							<td width="100"  style="text-align:right;"><cfif isdefined("member_all_count_#consumer_id#")>#evaluate("member_all_count_#consumer_id#")#<cfelse>#0#</cfif></td>
							<td width="100"  style="text-align:right;"><cfif isdefined("member_count_#consumer_id#")>#evaluate("member_count_#consumer_id#")#<cfelse>#0#</cfif></td>
							<td width="100"  style="text-align:right;"><cfif isdefined("member_sale_#consumer_id#")>#tlformat(evaluate("member_sale_#consumer_id#"))#<cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
							<cfloop from="1" to="3" index="con_indx">
								<td width="100"  style="text-align:right;"><cfif isdefined("group_sale_#con_indx#_#consumer_id#")>#tlformat(evaluate("group_sale_#con_indx#_#consumer_id#"))#<cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
							</cfloop>
							<td width="100"  style="text-align:right;"><cfif isdefined("group_sale_total_#consumer_id#")>#tlformat(evaluate("group_sale_total_#consumer_id#"))#<cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
						</tr>
						<!-- sil -->
						<tr id="emp_detail#consumer_id#" class="color-row" style="display:none">
							<td colspan="11">
								<div align="left" id="display_emp_detail#consumer_id#"></div>
							</td>
						</tr>
						<!-- sil -->
					</cfoutput>
				</table>
			</td>
		</tr>
	</table>
	</cfif>
</cfif>
<script type="text/javascript">
	function connectAjax_list(cons_id,crtrow,ref_code)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=myhome.popupajax_my_consumer_ref_member&ref_code='+ref_code+'&cid='+cons_id+'&maxrows=#attributes.maxrows#&is_display=1<cfif isdefined("attributes.camp_id")>&camp_id=#attributes.camp_id#</cfif></cfoutput>';;
		AjaxPageLoad(bb,'display_emp_detail'+cons_id,1);
	}
</script>
