<cfif not isDefined("attributes.print")>
  <!-- sil -->
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr class="color-border">
      <td>
        <table width="100%" border="0" cellspacing="1" cellpadding="2">
          <tr class="color-row">
            <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' is_ajax="1" tag_module="pdf_deneme">
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <!-- sil -->
<cfelse>
	<script type="text/javascript">
		function waitfor()
		{
		  window.close();
		}
		setTimeout("waitfor()",3000);
		window.opener.close();
		window.print();
	</script>
</cfif>
<cfif isDefined("attributes.id")>
	<cfset attributes.class_id = attributes.id>
</cfif>
<!--- list will be sorted --->
<cfset liste="">
<cfloop from="1" to="#attributes.max#" index="i">
	<cfif isdefined("attributes.secenek#i#")>
		<cfset deger=evaluate("attributes.secenek#i#")>
		<cfif LEN(deger)>
			<cfset deger="#deger#-#i#">
		<cfelse>
			<cfset deger="500-#i#">
		</cfif>
		<cfset liste=ListAppend(liste,deger,",")>
	</cfif>
</cfloop>
<br/>
<br/>
<cfset arr_temp="">
<cfloop from="1" to="#listlen(liste)#" index="i" >
	<cfloop from="1" to="#evaluate(listlen(liste))#" index="j">
		<cfset temp1_val=listgetat(liste,i,",")>
		<cfset temp2_val=listgetat(liste,j,",")>
		<cfset temp1=Int(listgetat(temp1_val,1,"-"))>
		<cfset temp2=Int(listgetat(temp2_val,1,"-"))>
		<cfif temp2 gt temp1>
			<cfscript>
				liste = ListSetAt(liste, i, temp2_val,",");
				liste = ListSetAt(liste, j, temp1_val,",");
			</cfscript>
		</cfif>
	</cfloop>
</cfloop>
<!--- list was sorted --->
<cfinclude template="../query/get_training_sec_names.cfm">
<cfinclude template="../query/get_class.cfm">
<cfinclude template="../query/get_class_results.cfm">
<cfinclude template="../query/get_class_attender_eval.cfm">
<!--- <cfinclude template="../query/get_class_eval.cfm">  20070815 YD 120 GÜNE SİLİNMELİ--->
<cfinclude template="../query/get_class_cost.cfm">
<cfinclude template="../query/get_training_eval_quizs.cfm">
<cfset attributes.quiz_id = get_class.quiz_id>
<cfif LEN(attributes.quiz_id)>
	<cfquery name="GET_QUIZ_RESULT" datasource="#dsn#">
		SELECT
			CLASS_EVAL_ID
		FROM
			TRAINING_CLASS_EVAL
		WHERE
			QUIZ_ID = #attributes.QUIZ_ID# AND
			CLASS_ID = #attributes.CLASS_ID#
	</cfquery>
</cfif>
<div id="pdf_deneme">
<table style="height:230mm;width:157mm;" border="0">
  <cfinclude template="../query/get_upd_class_queries.cfm">
  <cfloop from="1" to="#listlen(liste)#" index="i">
    <cfset ch_sub_list=listgetat(liste,i)>
    <cfset s=ListGetAt(ch_sub_list,2,"-")>
    <cfif ListGetAt(ch_sub_list,1,"-") neq "500" and ( s lte 5 or (s gte 9 and s lte 15) )>
      <tr>
        <td>
			<cfif isdefined("attributes.excused")>
				<cfset attributes.excused1 = attributes.excused>
			</cfif>
			<cfset name_of_file="training_report_#ListGetAt(ch_sub_list,2,"-")#.cfm">
			<cfinclude template="#name_of_file#">
        </td>
      </tr>
      <cfelseif ListGetAt(ch_sub_list,1,"-") neq "500" >
      <tr>
        <td>
          <cfif  isdefined("attributes.gizli#s#") and LEN(evaluate("attributes.gizli#s#"))>
            <cfif isdefined("attributes.graph_dimension#ListGetAt(ch_sub_list,2,"-")#") and len(evaluate("attributes.graph_dimension#ListGetAt(ch_sub_list,2,"-")#"))>
              <cfset attributes.graph_dim = evaluate("attributes.graph_dimension#ListGetAt(ch_sub_list,2,"-")#")>
            </cfif>
            <cfif isdefined("attributes.graph_type#ListGetAt(ch_sub_list,2,"-")#") and len(evaluate("attributes.graph_type#ListGetAt(ch_sub_list,2,"-")#"))>
              <cfset attributes.gr_type = evaluate("attributes.graph_type#ListGetAt(ch_sub_list,2,"-")#")>
            </cfif>
            <cfif isdefined("attributes.list#ListGetAt(ch_sub_list,2,"-")#") and len(evaluate("attributes.list#ListGetAt(ch_sub_list,2,"-")#"))>
              <cfset attributes.list = 1>
            </cfif>
            <cfset attributes.quiz_id = evaluate("attributes.gizli#s#")>
            <cfinclude template="training_report_6.cfm">
          </cfif>
        </td>
      </tr>
    </cfif>
  </cfloop>
</table>
</div>
<cfscript>
	StructDelete(session,"training_management");
</cfscript>

