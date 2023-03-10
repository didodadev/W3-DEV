<cfif isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>

<CFTRANSACTION>
	<cfquery name="add_perf" datasource="#dsn#">
		INSERT INTO PERF_STANDART_FORM
			(
				MEET_FORM_ID,
				EMPLOYEE_ID,
				BOSS_ID,
				START_DATE,
				FINISH_DATE,
				STRONG_WAY,
				WEAK_WAY,
				GROW_AREA_1,
				GROW_AREA_2,
				GROW_AREA_3,
				GROW_AREA_4,
				GROW_AREA_5,
				GROW_AREA_6,
				GROW_DATE_1,
				GROW_DATE_2,
				GROW_DATE_3,
				GROW_DATE_4,
				GROW_DATE_5,
				GROW_DATE_6,
				GROW_EDU_1,
				GROW_EDU_2,
				GROW_EDU_3,
				GROW_EDU_4,
				GROW_EDU_5,
				GROW_EDU_6,
				COMMENT_1,
				COMMENT_2,
				COMMENT_3,
				COMMENT_4,
				COMMENT_5,
				COMMENT_6,
				
				KNOW_1,
				KNOW_1_UO,
				KNOW_1_DETAIL,
				KNOW_2,
				KNOW_2_UO,
				KNOW_2_DETAIL,
				KNOW_3,
				KNOW_3_UO,
				KNOW_3_DETAIL,
				KNOW_4,
				KNOW_4_UO,
				KNOW_4_DETAIL,
				
				ORG_1,
				ORG_1_UO,
				ORG_1_DETAIL,
				ORG_2,
				ORG_2_UO,
				ORG_2_DETAIL,
				ORG_3,
				ORG_3_UO,
				ORG_3_DETAIL,				
				ORG_4,
				ORG_4_UO,
				ORG_4_DETAIL,
				
				PROB_1,
				PROB_1_UO,
				PROB_1_DETAIL,
				PROB_2,
				PROB_2_UO,
				PROB_2_DETAIL,
				PROB_3,
				PROB_3_UO,
				PROB_3_DETAIL,				
				PROB_4,
				PROB_4_UO,
				PROB_4_DETAIL,
				
				RELATION_1,
				RELATION_1_UO,
				RELATION_1_DETAIL,
				RELATION_2,
				RELATION_2_UO,
				RELATION_2_DETAIL,
				RELATION_3,
				RELATION_3_UO,
				RELATION_3_DETAIL,				
				RELATION_4,
				RELATION_4_UO,
				RELATION_4_DETAIL,
				
				SUCCESS_1,
				SUCCESS_1_UO,
				SUCCESS_1_DETAIL,
				SUCCESS_2,
				SUCCESS_2_UO,
				SUCCESS_2_DETAIL,
				SUCCESS_3,
				SUCCESS_3_UO,
				SUCCESS_3_DETAIL,				
				SUCCESS_4,
				SUCCESS_4_UO,
				SUCCESS_4_DETAIL,				
				
				TOTAL_POINT,				
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
			VALUES
			(
				#attributes.meet_form_id#,
				#attributes.employee_id#,
				#attributes.amir_id#,
				#attributes.start_date#,
				#attributes.finish_date#,
				'#attributes.strong_way#',
				'#attributes.weak_way#',
				'#attributes.grow_area_1#',
				'#attributes.grow_area_2#',
				'#attributes.grow_area_3#',
				'#attributes.grow_area_4#',
				'#attributes.grow_area_5#',
				'#attributes.grow_area_6#',
				'#attributes.grow_date_1#',
				'#attributes.grow_date_2#',
				'#attributes.grow_date_3#',
				'#attributes.grow_date_4#',
				'#attributes.grow_date_5#',
				'#attributes.grow_date_6#',
				'#attributes.grow_edu_1#',
				'#attributes.grow_edu_2#',
				'#attributes.grow_edu_3#',
				'#attributes.grow_edu_4#',
				'#attributes.grow_edu_5#',
				'#attributes.grow_edu_6#',
				'#attributes.comment_1#',
				'#attributes.comment_2#',
				'#attributes.comment_3#',
				'#attributes.comment_4#',
				'#attributes.comment_5#',
				'#attributes.comment_6#',
				
				<cfif len(attributes.bilgi_1)>#attributes.bilgi_1#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.bilgi_1_uo")>1<cfelse>NULL</cfif>,
				'#attributes.bilgi_1_detail#',
				<cfif len(attributes.bilgi_2)>#attributes.bilgi_2#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.bilgi_2_uo")>1<cfelse>NULL</cfif>,
				'#attributes.bilgi_2_detail#',
				<cfif len(attributes.bilgi_3)>#attributes.bilgi_3#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.bilgi_3_uo")>1<cfelse>NULL</cfif>,
				'#attributes.bilgi_3_detail#',
				<cfif len(attributes.bilgi_4)>#attributes.bilgi_4#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.bilgi_4_uo")>1<cfelse>NULL</cfif>,
				'#attributes.bilgi_4_detail#',
				
				<cfif len(attributes.org_1)>#attributes.org_1#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.org_1_uo")>1<cfelse>NULL</cfif>,
				'#attributes.org_1_detail#',
				<cfif len(attributes.org_2)>#attributes.org_2#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.org_2_uo")>1<cfelse>NULL</cfif>,
				'#attributes.org_2_detail#',
				<cfif len(attributes.org_3)>#attributes.org_3#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.org_3_uo")>1<cfelse>NULL</cfif>,
				'#attributes.org_3_detail#',
				<cfif len(attributes.org_4)>#attributes.org_4#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.org_4_uo")>1<cfelse>NULL</cfif>,
				'#attributes.org_4_detail#',
				
				<cfif len(attributes.prob_1)>#attributes.prob_1#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.prob_1_uo")>1<cfelse>NULL</cfif>,
				'#attributes.prob_1_detail#',
				<cfif len(attributes.prob_2)>#attributes.prob_2#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.prob_2_uo")>1<cfelse>NULL</cfif>,
				'#attributes.prob_2_detail#',
				<cfif len(attributes.prob_3)>#attributes.prob_3#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.prob_3_uo")>1<cfelse>NULL</cfif>,
				'#attributes.prob_3_detail#',
				<cfif len(attributes.prob_4)>#attributes.prob_4#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.prob_4_uo")>1<cfelse>NULL</cfif>,
				'#attributes.prob_4_detail#',
								
				<cfif len(attributes.relation_1)>#attributes.relation_1#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.relation_1_uo")>1<cfelse>NULL</cfif>,
				'#attributes.relation_1_detail#',
				<cfif len(attributes.relation_2)>#attributes.relation_2#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.relation_2_uo")>1<cfelse>NULL</cfif>,
				'#attributes.relation_2_detail#',
				<cfif len(attributes.relation_3)>#attributes.relation_3#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.relation_3_uo")>1<cfelse>NULL</cfif>,
				'#attributes.relation_3_detail#',
				<cfif len(attributes.relation_4)>#attributes.relation_4#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.relation_4_uo")>1<cfelse>NULL</cfif>,
				'#attributes.relation_4_detail#',
								
				<cfif len(attributes.success_1)>#attributes.success_1#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.success_1_uo")>1<cfelse>NULL</cfif>,
				'#attributes.success_1_detail#',
				<cfif len(attributes.success_2)>#attributes.success_2#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.success_2_uo")>1<cfelse>NULL</cfif>,
				'#attributes.success_2_detail#',
				<cfif len(attributes.success_3)>#attributes.success_3#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.success_3_uo")>1<cfelse>NULL</cfif>,
				'#attributes.success_3_detail#',
				<cfif len(attributes.success_4)>#attributes.success_4#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.success_4_uo")>1<cfelse>NULL</cfif>,
				'#attributes.success_4_detail#',
				
				<cfif len(attributes.genel_toplam)>#attributes.genel_toplam#<cfelse>NULL</cfif>,
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#session.ep.userid#
			)	
	</cfquery>
</CFTRANSACTION>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
