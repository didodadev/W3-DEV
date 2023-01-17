<cfset upd_data = createObject("component","V16.crm.cfc.visitorbook")>
<cfparam name="attributes.VISIT_ID" >
<cfparam name="attributes.VISIT_NAME" >
<cfparam name="attributes.VISIT_SURNAME">
<cfparam name="attributes.CARD_NO" >
<cf_date tarih="attributes.VISIT_DATE">
<cfparam name="attributes.START_TIME" >
<cfparam name="attributes.END_TIME" >
<cfparam name="attributes.START_MINUTE" >
<cfparam name="attributes.FINISH_MINUTE">    
<cfparam name="attributes.REASON_VISIT" >
<cfparam name="attributes.EMP_ID" >
<cfparam name="attributes.BRANCH_ID" >
<cfparam name="attributes.DEPARTMENT_ID" >
<cfset emp_id=Listfirst(attributes.EMP_ID,"_")>

<cfset upd_data.getupd( 
    visit_id: attributes.VISIT_ID,
    visit_name:attributes.VISIT_NAME, 
    visit_surname:attributes.VISIT_SURNAME,
    card_no:attributes.CARD_NO,
    VISIT_DATE:attributes.VISIT_DATE,
    start_time:attributes.START_TIME,
    end_time:attributes.END_TIME,
    start_minute:attributes.START_MINUTE,
    finish_minute:attributes.FINISH_MINUTE,
    reason_visit:attributes.REASON_VISIT,
    emp_id:Listfirst(attributes.EMP_ID,"_"),
    branch_id:attributes.BRANCH_ID,
    department_id:attributes.DEPARTMENT_ID
)>