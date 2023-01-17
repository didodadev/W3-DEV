<cfif isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>

<CFTRANSACTION>
	<cfquery name="upd_perf" datasource="#dsn#">
		UPDATE PERF_STANDART_FORM SET
			EMPLOYEE_ID = #attributes.employee_id#,
			BOSS_ID = #attributes.amir_id#,
			START_DATE = #attributes.start_date#,
			FINISH_DATE = #attributes.finish_date#,
			STRONG_WAY = '#attributes.strong_way#',
			WEAK_WAY = '#attributes.weak_way#',
			GROW_AREA_1 = '#attributes.grow_area_1#',
			GROW_AREA_2 = '#attributes.grow_area_2#',
			GROW_AREA_3 = '#attributes.grow_area_3#',
			GROW_AREA_4 = '#attributes.grow_area_4#',
			GROW_AREA_5 = '#attributes.grow_area_5#',
			GROW_AREA_6 = '#attributes.grow_area_6#',
			GROW_DATE_1 = '#attributes.grow_date_1#',
			GROW_DATE_2 = '#attributes.grow_date_2#',
			GROW_DATE_3 = '#attributes.grow_date_3#',
			GROW_DATE_4 = '#attributes.grow_date_4#',
			GROW_DATE_5 = '#attributes.grow_date_5#',
			GROW_DATE_6 = '#attributes.grow_date_6#',
			GROW_EDU_1 = '#attributes.grow_edu_1#',
			GROW_EDU_2 = '#attributes.grow_edu_2#',
			GROW_EDU_3 = '#attributes.grow_edu_3#',
			GROW_EDU_4 = '#attributes.grow_edu_4#',
			GROW_EDU_5 = '#attributes.grow_edu_5#',
			GROW_EDU_6 = '#attributes.grow_edu_6#',
			COMMENT_1 = '#attributes.comment_1#',
			COMMENT_2 = '#attributes.comment_2#',
			COMMENT_3 = '#attributes.comment_3#',
			COMMENT_4 = '#attributes.comment_4#',
			COMMENT_5 = '#attributes.comment_5#',
			COMMENT_6 = '#attributes.comment_6#',
			
			KNOW_1=<cfif len(attributes.bilgi_1)>#attributes.bilgi_1#<cfelse>NULL</cfif>,
			KNOW_1_UO=<cfif isdefined("attributes.bilgi_1_uo")>1<cfelse>NULL</cfif>,
			KNOW_1_DETAIL='#attributes.bilgi_1_detail#',
			KNOW_2=<cfif len(attributes.bilgi_2)>#attributes.bilgi_2#<cfelse>NULL</cfif>,
			KNOW_2_UO=<cfif isdefined("attributes.bilgi_2_uo")>1<cfelse>NULL</cfif>,
			KNOW_2_DETAIL='#attributes.bilgi_2_detail#',
			KNOW_3=<cfif len(attributes.bilgi_3)>#attributes.bilgi_3#<cfelse>NULL</cfif>,
			KNOW_3_UO=<cfif isdefined("attributes.bilgi_3_uo")>1<cfelse>NULL</cfif>,
			KNOW_3_DETAIL='#attributes.bilgi_3_detail#',
			KNOW_4=<cfif len(attributes.bilgi_4)>#attributes.bilgi_4#<cfelse>NULL</cfif>,
			KNOW_4_UO=<cfif isdefined("attributes.bilgi_4_uo")>1<cfelse>NULL</cfif>,
			KNOW_4_DETAIL='#attributes.bilgi_4_detail#',
			
			ORG_1=<cfif len(attributes.org_1)>#attributes.org_1#<cfelse>NULL</cfif>,
			ORG_1_UO=<cfif isdefined("attributes.org_1_uo")>1<cfelse>NULL</cfif>,
			ORG_1_DETAIL='#attributes.org_1_detail#',
			ORG_2=<cfif len(attributes.org_2)>#attributes.org_2#<cfelse>NULL</cfif>,
			ORG_2_UO=<cfif isdefined("attributes.org_2_uo")>1<cfelse>NULL</cfif>,
			ORG_2_DETAIL='#attributes.org_2_detail#',
			ORG_3=<cfif len(attributes.org_3)>#attributes.org_3#<cfelse>NULL</cfif>,
			ORG_3_UO=<cfif isdefined("attributes.org_3_uo")>1<cfelse>NULL</cfif>,
			ORG_3_DETAIL='#attributes.org_3_detail#',
			ORG_4=<cfif len(attributes.org_4)>#attributes.org_4#<cfelse>NULL</cfif>,
			ORG_4_UO=<cfif isdefined("attributes.org_4_uo")>1<cfelse>NULL</cfif>,
			ORG_4_DETAIL='#attributes.org_4_detail#',
			
			PROB_1=<cfif len(attributes.prob_1)>#attributes.prob_1#<cfelse>NULL</cfif>,
			PROB_1_UO=<cfif isdefined("attributes.prob_1_uo")>1<cfelse>NULL</cfif>,
			PROB_1_DETAIL='#attributes.prob_1_detail#',
			PROB_2=<cfif len(attributes.prob_2)>#attributes.prob_2#<cfelse>NULL</cfif>,
			PROB_2_UO=<cfif isdefined("attributes.prob_2_uo")>1<cfelse>NULL</cfif>,
			PROB_2_DETAIL='#attributes.prob_2_detail#',
			PROB_3=<cfif len(attributes.prob_3)>#attributes.prob_3#<cfelse>NULL</cfif>,
			PROB_3_UO=<cfif isdefined("attributes.prob_3_uo")>1<cfelse>NULL</cfif>,
			PROB_3_DETAIL='#attributes.prob_3_detail#',
			PROB_4=<cfif len(attributes.prob_4)>#attributes.prob_4#<cfelse>NULL</cfif>,
			PROB_4_UO=<cfif isdefined("attributes.prob_4_uo")>1<cfelse>NULL</cfif>,
			PROB_4_DETAIL='#attributes.prob_4_detail#',
			
			RELATION_1=<cfif len(attributes.relation_1)>#attributes.relation_1#<cfelse>NULL</cfif>,
			RELATION_1_UO=<cfif isdefined("attributes.relation_1_uo")>1<cfelse>NULL</cfif>,
			RELATION_1_DETAIL='#attributes.relation_1_detail#',
			RELATION_2=<cfif len(attributes.relation_2)>#attributes.relation_2#<cfelse>NULL</cfif>,
			RELATION_2_UO=<cfif isdefined("attributes.relation_2_uo")>1<cfelse>NULL</cfif>,
			RELATION_2_DETAIL='#attributes.relation_2_detail#',
			RELATION_3=<cfif len(attributes.relation_3)>#attributes.relation_3#<cfelse>NULL</cfif>,
			RELATION_3_UO=<cfif isdefined("attributes.relation_3_uo")>1<cfelse>NULL</cfif>,
			RELATION_3_DETAIL='#attributes.relation_3_detail#',
			RELATION_4=<cfif len(attributes.relation_4)>#attributes.relation_4#<cfelse>NULL</cfif>,
			RELATION_4_UO=<cfif isdefined("attributes.relation_4_uo")>1<cfelse>NULL</cfif>,
			RELATION_4_DETAIL='#attributes.relation_4_detail#',
			
			SUCCESS_1=<cfif len(attributes.success_1)>#attributes.success_1#<cfelse>NULL</cfif>,
			SUCCESS_1_UO=<cfif isdefined("attributes.success_1_uo")>1<cfelse>NULL</cfif>,
			SUCCESS_1_DETAIL='#attributes.success_1_detail#',
			SUCCESS_2=<cfif len(attributes.success_2)>#attributes.success_2#<cfelse>NULL</cfif>,
			SUCCESS_2_UO=<cfif isdefined("attributes.success_2_uo")>1<cfelse>NULL</cfif>,
			SUCCESS_2_DETAIL='#attributes.success_2_detail#',
			SUCCESS_3=<cfif len(attributes.success_3)>#attributes.success_3#<cfelse>NULL</cfif>,
			SUCCESS_3_UO=<cfif isdefined("attributes.success_3_uo")>1<cfelse>NULL</cfif>,
			SUCCESS_3_DETAIL='#attributes.success_3_detail#',
			SUCCESS_4=<cfif len(attributes.success_4)>#attributes.success_4#<cfelse>NULL</cfif>,
			SUCCESS_4_UO=<cfif isdefined("attributes.success_4_uo")>1<cfelse>NULL</cfif>,
			SUCCESS_4_DETAIL='#attributes.success_4_detail#',
			
			TOTAL_POINT=<cfif len(attributes.genel_toplam)>#attributes.genel_toplam#<cfelse>NULL</cfif>,

			UPDATE_DATE = #now()#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#
		WHERE
			FORM_ID = #attributes.form_id#
	</cfquery>

</CFTRANSACTION>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
