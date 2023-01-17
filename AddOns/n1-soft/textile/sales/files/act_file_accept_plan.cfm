

<!---eklendiği aşama ile iş planını kapatır,numuneye bağlı diğer iş planlarınıda kontrol eder 
    tamamı kapalı ise numune sürecini  onay bekliyora getirir--->
<cfset numuneonaybekliyorsurecid=246>
<cfset work_tamamlanma_surecid=93><!---iş kapatıldı süreci--->
<cfquery name="get_control" datasource="#caller.dsn3#">
	select *from TEXTILE_PRODUCT_PLAN WHERE PLAN_ID=#caller.attributes.plan_id# and REQUEST_ID=#caller.attributes.req_id#
</cfquery>
<cfquery name="upd_work" datasource="#caller.dsn3#">
	UPDATE TEXTILE_PRODUCT_PLAN
	SET IS_APPROV=1
	<cfif not len(get_control.FINISH_DATE) and len(get_control.task_emp)>
		,FINISH_DATE=#now()#
	</cfif>
	WHERE PLAN_ID=#caller.attributes.plan_id# and REQUEST_ID=#caller.attributes.req_id#
</cfquery>
<cfquery name="get_works" datasource="#caller.dsn3#">
	select *from TEXTILE_PRODUCT_PLAN WHERE REQUEST_ID=#caller.attributes.req_id# AND STAGE_ID IS NOT NULL AND ISNULL(IS_APPROV,0)=0
</cfquery>
<cfif get_works.recordcount eq 0>
	<cfquery name="upd_req_stage" datasource="#caller.dsn3#">
		UPDATE TEXTILE_SAMPLE_REQUEST
		SET REQ_STAGE=#numuneonaybekliyorsurecid# <!---onay bekliyor--->
		WHERE  REQ_ID=#caller.attributes.req_id#
	</cfquery>
</cfif>

<!---ilişkili iş tamamlandı olarak günceller--->
<cfif isdefined("caller.attributes.work_id") and len(caller.attributes.work_id)>
	<cfquery name="upd_work" datasource="#caller.dsn3#">
		UPDATE #caller.dsn#.PRO_WORKS
			SET WORK_CURRENCY_ID=#work_tamamlanma_surecid#
		WHERE 
			WORK_ID=#caller.attributes.work_id#
	</cfquery>
</cfif>
