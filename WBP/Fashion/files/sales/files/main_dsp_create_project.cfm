<!--------sipariş kaydedildiğinde o siparişe özel proje oluşturur. update eder.-----------
<cfinclude template="/WBP/Fashion/files/sales/files/main_dsp_create_project">

------------------>


<cfquery name="create_project"  datasource="#attributes.data_source#">
			
			INSERT INTO 
				#caller.dsn3_alias#.PRO_PROJECTS
				(
				 PROJECT_NUMBER	
				,PROJECT_HEAD
				,PROJECT_EMP_ID
				,TARGET_START
				,TARGET_FINISH
				,PRO_CURRENCY_ID
				,PRO_PRIORITY_ID
				,RECORD_DATE
				,PROCESS_CAT
				)
				VALUES
				(
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full#">
				,#session.ep.userid#
				,convert(datetime,convert(varchar(8),getdate(),112))
				,convert(datetime,convert(varchar(8),getdate(),112))+90
				,50
				,1
				,GETDATE()
				,1
				);
				
			DECLARE @ID INT
			SET @ID=(SELECT MAX(PROJECT_ID) FROM workcube_leras.dbo.PRO_PROJECTS );
				
			INSERT INTO
				#caller.dsn3_alias#.PRO_HISTORY	
				(
				 PROJECT_ID
				,PROJECT_EMP_ID
				,TARGET_START
				,TARGET_FINISH
				,PRO_CURRENCY_ID
				,PRO_PRIORITY_ID
				,UPDATE_DATE
				)	
			SELECT 
				 PROJECT_ID
				,PROJECT_EMP_ID
				,TARGET_START
				,TARGET_FINISH
				,PRO_CURRENCY_ID
				,PRO_PRIORITY_ID
				,GETDATE() AS UPDATE_DATE
			FROM #caller.dsn3_alias#.PRO_PROJECTS
			WHERE PROJECT_ID=@ID
		</cfquery>
    
	<!-----
		<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
			UPDATE
				GENERAL_PAPERS
			SET
				OPPORTUNITY_NUMBER = #system_paper_no_add#
			WHERE
				OPPORTUNITY_NUMBER IS NOT NULL
		</cfquery>		

	----->











<!-----
<cfif caller.attributes.fuseaction eq 'sales.list_order' and caller.attributes.event eq 'upd'>
<script type="text/javascript">
function Yuklendi()
{

var divId =document.getElementById("transformation");
element="<a href='javascript://' onclick='addlink();' class='tableyazi'><img src='/images/workdevanalys.gif' alt='Numune görüntüle' border='0' title='Numune görüntüle'>";
divId.innerHTML+=element;
		
}
function addlink()
{
	var sql="select TOP 1 RELATED_ACTION_ID from ORDER_ROW WHERE RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND RELATED_ACTION_ID>0 AND ORDER_ID="+"<cfoutput>#caller.attributes.order_id#</cfoutput>";
	
	rows=wrk_query(sql,'dsn3');
	if(rows.recordcount > 0)
	{
	var req_id=rows.RELATED_ACTION_ID;
	window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=textile.list_sample_request&event=det&req_id='+req_id,'page');
	}
	else
	alert('İlişkili Numune Kaydı Yok!');
}
window.onload = Yuklendi;
</script>
</cfif>
---->